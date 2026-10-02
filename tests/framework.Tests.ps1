# Standalone integration tests; no Pester or application dependency required.
[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$frameworkRoot = Split-Path -Parent $PSScriptRoot
$shellPath = (Get-Process -Id $PID).Path
$testRoot = Join-Path ([IO.Path]::GetTempPath()) ('bw-ai-framework-' + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $testRoot | Out-Null
$utf8 = New-Object System.Text.UTF8Encoding($false)
$passed = 0

function Assert-True($Condition, [string]$Message) {
    if (-not $Condition) { throw $Message }
}

function Write-TestFile([string]$Path, [string]$Content) {
    New-Item -ItemType Directory -Path (Split-Path -Parent $Path) -Force | Out-Null
    [IO.File]::WriteAllText($Path, $Content, $utf8)
}

function New-TestRepository([string]$Name) {
    $path = Join-Path $testRoot $Name
    New-Item -ItemType Directory -Path $path | Out-Null
    & git -C $path init --quiet
    Assert-True ($LASTEXITCODE -eq 0) 'Cannot initialize disposable Git repository.'
    return $path
}

function Invoke-Framework([string]$Script, [string]$Target, [string[]]$Options = @(), [int]$Expected = 0) {
    $scriptPath = Join-Path $frameworkRoot ('scripts/' + $Script + '.ps1')
    # Windows PowerShell wraps native stderr in error records. Inspect the
    # child's exit code ourselves so expected rejection cases can be tested.
    $savedPreference = $ErrorActionPreference
    try {
        $ErrorActionPreference = 'Continue'
        $output = & $shellPath -NoProfile -ExecutionPolicy Bypass -File $scriptPath -TargetPath $Target @Options 2>&1
        $code = $LASTEXITCODE
    } finally {
        $ErrorActionPreference = $savedPreference
    }
    Assert-True ($code -eq $Expected) "$Script exit $code, expected $Expected`n$($output -join "`n")"
    return ($output -join "`n")
}

function Get-Snapshot([string]$Root) {
    $rows = Get-ChildItem -LiteralPath $Root -Recurse -Force -File |
        Where-Object { $_.FullName -notmatch '[\\/]\.git[\\/]' } |
        Sort-Object FullName |
        ForEach-Object { $_.FullName.Substring($Root.Length) + ':' + (Get-FileHash -LiteralPath $_.FullName).Hash }
    return ($rows -join "`n")
}

function Remove-TestFile([string]$Root, [string]$RelativePath) {
    $path = [IO.Path]::GetFullPath((Join-Path $Root $RelativePath))
    $prefix = [IO.Path]::GetFullPath($testRoot) + [IO.Path]::DirectorySeparatorChar
    Assert-True ($path.StartsWith($prefix, [StringComparison]::OrdinalIgnoreCase)) 'Deletion outside disposable test root.'
    Remove-Item -LiteralPath $path
}

function Pass([string]$Name) {
    $script:passed++
    Write-Host "[PASS] $Name"
}

try {
    $fresh = New-TestRepository 'fresh'
    $before = Get-Snapshot $fresh
    $null = Invoke-Framework 'install' $fresh @('-DryRun')
    Assert-True ((Get-Snapshot $fresh) -eq $before) 'Dry run changed files.'
    Pass 'Fresh dry run writes nothing'

    $null = Invoke-Framework 'install' $fresh
    $null = Invoke-Framework 'validate-target' $fresh @('-Profile', 'full')
    $manifest = Get-Content -Raw (Join-Path $fresh '.ai/framework.json') | ConvertFrom-Json
    Assert-True ($manifest.version -eq '3.0.0' -and $manifest.schemaVersion -eq 2) 'Wrong version or schema.'
    Assert-True (-not (Test-Path (Join-Path $fresh '.codex/framework.json'))) 'New installation created a legacy manifest.'
    Assert-True ((Get-Content -Raw (Join-Path $fresh 'CLAUDE.md')) -match '(?m)^@AGENTS\.md\s*$') 'Shared Claude import missing.'
    Pass 'Fresh V3 installation includes both entry points and valid required context'

    $before = Get-Snapshot $fresh
    $null = Invoke-Framework 'install' $fresh @('-AllowDirtyTarget')
    Assert-True ((Get-Snapshot $fresh) -eq $before) 'Reinstall changed files.'
    Pass 'Reinstall is idempotent'

    # Different managed files conflict before ANY planned creates are applied.
    Write-TestFile (Join-Path $fresh 'AGENTS.md') 'Custom project rules: retain me.'
    Write-TestFile (Join-Path $fresh 'CLAUDE.md') 'Custom Claude rules: retain me.'
    Remove-TestFile $fresh 'docs/ai-governance/ASSISTANT_SETUP.md'
    $before = Get-Snapshot $fresh
    $out = Invoke-Framework 'install' $fresh @('-AllowDirtyTarget') 2
    Assert-True ($out.Contains('[conflict] AGENTS.md') -and $out.Contains('[conflict] CLAUDE.md')) 'Custom instruction conflicts missing.'
    Assert-True ((Get-Snapshot $fresh) -eq $before) 'Conflict caused partial writes.'
    Pass 'Custom instructions preserved; conflicts prevent partial copies'

    $statePath = Join-Path $fresh 'docs/ai-context/CURRENT_STATE.md'
    Write-TestFile $statePath 'Project-owned current state must survive updates.'
    $stateHash = (Get-FileHash $statePath).Hash
    $before = Get-Snapshot $fresh
    $null = Invoke-Framework 'install' $fresh @('-AllowDirtyTarget', '-Force', '-Backup', '-DryRun')
    Assert-True ((Get-Snapshot $fresh) -eq $before) 'Forced dry run wrote files or backups.'
    Pass 'Forced dry run also writes nothing'
    $null = Invoke-Framework 'install' $fresh @('-AllowDirtyTarget', '-Force', '-Backup')
    Assert-True ((Get-FileHash $statePath).Hash -eq $stateHash) 'Force overwrote project memory.'
    $backup = @(Get-ChildItem -LiteralPath $fresh -Filter 'CLAUDE.md.*.bak')
    Assert-True ($backup.Count -eq 1) 'Claude custom instructions not backed up.'
    Assert-True ((Get-Content -Raw $backup[0].FullName) -eq 'Custom Claude rules: retain me.') 'Backup differs from custom instructions.'
    Pass 'Explicit forced update backs up instructions and preserves memory'

    Remove-TestFile $fresh '.codex/hooks.json'
    Remove-TestFile $fresh '.codex/hooks/session_start.ps1'
    $null = Invoke-Framework 'validate-target' $fresh
    $null = Invoke-Framework 'validate-target' $fresh @('-Profile', 'full')
    Pass 'Optional hooks are not required in either profile'

    Remove-TestFile $fresh 'docs/ai-context/ROADMAP.md'
    $null = Invoke-Framework 'validate-target' $fresh
    $null = Invoke-Framework 'validate-target' $fresh @('-Profile', 'full') 1
    Remove-TestFile $fresh 'docs/ai-context/DECISIONS.md'
    $null = Invoke-Framework 'validate-target' $fresh @() 1
    Pass 'Required memory and optional full-profile memory are distinguished'

    $wiki = New-TestRepository 'wiki'
    $null = Invoke-Framework 'install' $wiki @('-IncludeWiki')
    $null = Invoke-Framework 'validate-target' $wiki @('-IncludeWiki', '-Profile', 'full')
    Remove-TestFile $wiki 'docs/wiki/API.md'
    $null = Invoke-Framework 'validate-target' $wiki @('-IncludeWiki') 1
    Pass 'Optional wiki install and validation flags still work'

    # Representative V2 manifest/layout, generated without relying on Git history.
    $legacy = New-TestRepository 'legacy-v2'
    $v2 = Get-Content -Raw (Join-Path $frameworkRoot 'src/.ai/framework.json') | ConvertFrom-Json
    $v2.version = '2.0.1'
    $v2.name = 'bw-codex-dev-framework'
    $v2.files = @($v2.files | Where-Object { $_.path -notin @('CLAUDE.md', 'docs/ai-governance/ASSISTANT_SETUP.md') })
    foreach ($file in $v2.files) {
        if ($file.path -eq '.ai/framework.json') {
            $file.path = '.codex/framework.json'
            $file.source = 'src/.codex/framework.json'
        } elseif ($file.owner -ne 'Generated') {
            Write-TestFile (Join-Path $legacy $file.path) ([IO.File]::ReadAllText((Join-Path $frameworkRoot $file.source)))
        }
    }
    $legacyPath = Join-Path $legacy '.codex/framework.json'
    Write-TestFile $legacyPath ($v2 | ConvertTo-Json -Depth 10)
    Write-TestFile (Join-Path $legacy 'AGENTS.md') 'V2 custom startup rules.'
    Write-TestFile (Join-Path $legacy 'docs/ai-context/CURRENT_STATE.md') 'Existing project state without handoff.'
    $legacyHash = (Get-FileHash $legacyPath).Hash
    $memoryHash = (Get-FileHash (Join-Path $legacy 'docs/ai-context/CURRENT_STATE.md')).Hash
    $out = Invoke-Framework 'validate-target' $legacy
    Assert-True ($out.Contains('Legacy V2 manifest')) 'No V2 migration warning.'
    Pass 'V2-only target validates with migration warning'

    Write-TestFile (Join-Path $legacy '.codex/guide-version.json') '{"version":"1.0.0"}'
    Write-TestFile (Join-Path $legacy 'docs/ai-context/ARCHITECTURE.md') 'Legacy architecture.'
    $before = Get-Snapshot $legacy
    $report = Invoke-Framework 'migration-report' $legacy
    Assert-True ($report.Contains('[found] .codex/guide-version.json') -and $report.Contains('[found] .codex/framework.json') -and $report.Contains('Session handoff')) 'Missing V1/V2 migration advice.'
    Assert-True ((Get-Snapshot $legacy) -eq $before) 'Migration report wrote files.'
    $null = Invoke-Framework 'install' $legacy @('-DryRun') 2
    Assert-True ((Get-Snapshot $legacy) -eq $before) 'Legacy dry run changed files.'
    Pass 'V1 and V2 migration report and conflicting dry run are read-only'

    $null = Invoke-Framework 'install' $legacy @('-AllowDirtyTarget', '-Force', '-Backup')
    Assert-True ((Get-FileHash $legacyPath).Hash -eq $legacyHash) 'Legacy manifest changed.'
    Assert-True ((Get-FileHash (Join-Path $legacy 'docs/ai-context/CURRENT_STATE.md')).Hash -eq $memoryHash) 'Migration overwrote project state.'
    $out = Invoke-Framework 'validate-target' $legacy
    Assert-True ($out.Contains('authoritative') -and $out.Contains('3.0.0')) 'Neutral manifest not authoritative.'
    Write-TestFile $legacyPath 'invalid legacy JSON deliberately ignored'
    $null = Invoke-Framework 'validate-target' $legacy
    Pass 'V2 migration preserves memory and old files; neutral manifest takes priority'

    $neutralPath = Join-Path $legacy '.ai/framework.json'
    Write-TestFile $legacyPath ($v2 | ConvertTo-Json -Depth 10)
    Write-TestFile $neutralPath 'invalid neutral JSON'
    $null = Invoke-Framework 'validate-target' $legacy @() 1
    Pass 'Invalid neutral manifest never falls back to valid legacy metadata'

    Push-Location $wiki
    try {
        $hook = Join-Path $wiki '.codex/hooks/session_start.ps1'
        $null = & $shellPath -NoProfile -ExecutionPolicy Bypass -File $hook 2>&1
        Assert-True ($LASTEXITCODE -eq 0) 'Valid hook context failed.'
        Remove-TestFile $wiki 'docs/ai-context/KNOWN_ISSUES.md'
        $null = & $shellPath -NoProfile -ExecutionPolicy Bypass -File $hook 2>&1
        Assert-True ($LASTEXITCODE -eq 1) 'Hook ignored missing required memory.'
    } finally { Pop-Location }
    Pass 'Startup hook checks neutral manifest and required project memory'

    Write-Host "All $passed regression scenarios passed."
} finally {
    # Retain disposable fixtures for inspection; never remove a computed tree.
    Write-Host "Disposable fixtures retained at: $testRoot"
}
