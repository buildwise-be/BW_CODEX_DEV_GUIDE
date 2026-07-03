[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$TargetPath,

    [switch]$AllowNonGitTarget
)

$ErrorActionPreference = "Stop"

function Resolve-ExistingPath {
    param([string]$Path)

    return (Resolve-Path -LiteralPath $Path).ProviderPath
}

function Get-TargetInfo {
    param(
        [string]$Path,
        [bool]$AllowNonGit
    )

    $resolved = Resolve-ExistingPath -Path $Path
    $gitRoot = & git -C $resolved rev-parse --show-toplevel 2>$null

    if ($LASTEXITCODE -eq 0 -and $gitRoot) {
        return [pscustomobject]@{
            Root = $gitRoot.Trim()
            IsGitRepository = $true
            Error = $null
        }
    }

    if ($AllowNonGit) {
        return [pscustomobject]@{
            Root = $resolved
            IsGitRepository = $false
            Error = $null
        }
    }

    return [pscustomobject]@{
        Root = $resolved
        IsGitRepository = $false
        Error = "TargetPath must be inside a Git repository. Use -AllowNonGitTarget to validate a non-Git directory."
    }
}

function Get-MissingFiles {
    param(
        [string]$Root,
        [string[]]$Paths
    )

    $missing = New-Object System.Collections.Generic.List[string]

    foreach ($path in $Paths) {
        $absolutePath = Join-Path $Root $path

        if (-not (Test-Path -LiteralPath $absolutePath -PathType Leaf)) {
            $missing.Add($path) | Out-Null
        }
    }

    return $missing
}

function Test-GuideVersionFile {
    param([string]$Path)

    $issues = New-Object System.Collections.Generic.List[string]

    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        return $issues
    }

    try {
        $metadata = Get-Content -Raw -LiteralPath $Path | ConvertFrom-Json
    } catch {
        $issues.Add(".codex/guide-version.json is not valid JSON.") | Out-Null
        return $issues
    }

    if (-not $metadata.version) {
        $issues.Add(".codex/guide-version.json is missing the version field.") | Out-Null
    } elseif ($metadata.version -notmatch '^\d+\.\d+\.\d+(-[0-9A-Za-z.-]+)?(\+[0-9A-Za-z.-]+)?$') {
        $issues.Add(".codex/guide-version.json version is not valid SemVer: $($metadata.version)") | Out-Null
    }

    return $issues
}

$payloadFiles = @(
    "AGENTS.md",
    ".codex/hooks.json",
    ".codex/hooks/session_start.ps1",
    ".codex/guide-version.json",
    ".github/ISSUE_TEMPLATE/codex-task.md",
    ".github/pull_request_template.md",
    "docs/ai-context/AI_DEVELOPMENT_GUIDE.md"
)

$requiredContextFiles = @(
    "docs/ai-context/PROMPTS.md",
    "docs/ai-context/CURRENT_STATE.md",
    "docs/ai-context/ARCHITECTURE.md",
    "docs/ai-context/DECISIONS.md",
    "docs/ai-context/KNOWN_ISSUES.md",
    "docs/ai-context/CHANGELOG_AI.md"
)

$optionalContextFiles = @(
    "docs/ai-context/ROADMAP.md"
)

$targetInfo = Get-TargetInfo -Path $TargetPath -AllowNonGit:$AllowNonGitTarget

Write-Host "Target root: $($targetInfo.Root)"
Write-Host "Git repository: $($targetInfo.IsGitRepository)"

if ($targetInfo.Error) {
    Write-Host ""
    Write-Host "[error] $($targetInfo.Error)"
    exit 1
}

$missingPayloadFiles = Get-MissingFiles -Root $targetInfo.Root -Paths $payloadFiles
$missingContextFiles = Get-MissingFiles -Root $targetInfo.Root -Paths $requiredContextFiles
$missingOptionalContextFiles = Get-MissingFiles -Root $targetInfo.Root -Paths $optionalContextFiles
$versionIssues = Test-GuideVersionFile -Path (Join-Path $targetInfo.Root ".codex/guide-version.json")

Write-Host ""
Write-Host "Payload files:"
if ($missingPayloadFiles.Count -eq 0) {
    Write-Host "  [OK] all required payload files are present"
} else {
    foreach ($path in $missingPayloadFiles) {
        Write-Host "  [missing] $path"
    }
}

Write-Host ""
Write-Host "Project context files:"
if ($missingContextFiles.Count -eq 0) {
    Write-Host "  [OK] all required project context files are present"
} else {
    foreach ($path in $missingContextFiles) {
        Write-Host "  [missing] $path"
    }
}

Write-Host ""
Write-Host "Optional context files:"
if ($missingOptionalContextFiles.Count -eq 0) {
    Write-Host "  [OK] all optional context files are present"
} else {
    foreach ($path in $missingOptionalContextFiles) {
        Write-Host "  [optional missing] $path"
    }
}

if ($versionIssues.Count -gt 0) {
    Write-Host ""
    Write-Host "Version metadata:"

    foreach ($issue in $versionIssues) {
        Write-Host "  [error] $issue"
    }
}

if ($missingPayloadFiles.Count -gt 0 -or $missingContextFiles.Count -gt 0 -or $versionIssues.Count -gt 0) {
    Write-Host ""
    Write-Host "Target repository is not Codex-ready."
    exit 1
}

Write-Host ""
Write-Host "Target repository is Codex-ready."
exit 0
