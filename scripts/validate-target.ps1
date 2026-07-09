[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$TargetPath,

    [ValidateSet("minimal", "full")]
    [string]$Profile = "minimal",

    [switch]$AllowNonGitTarget,

    [switch]$IncludeWiki
)

$ErrorActionPreference = "Stop"

function Resolve-ExistingPath {
    param([string]$Path)

    return (Resolve-Path -LiteralPath $Path).ProviderPath
}

function Join-RootPath {
    param(
        [string]$Root,
        [string]$RelativePath
    )

    $normalized = $RelativePath -replace '/', [System.IO.Path]::DirectorySeparatorChar
    return Join-Path $Root $normalized
}

function Get-TargetInfo {
    param(
        [string]$Path,
        [bool]$AllowNonGit
    )

    $resolved = Resolve-ExistingPath -Path $Path
    $gitRoot = $null
    $gitExitCode = 1

    try {
        $gitRoot = & git -C $resolved rev-parse --show-toplevel 2>$null
        $gitExitCode = $LASTEXITCODE
    } catch {
        $gitRoot = $null
        $gitExitCode = 1
    }

    if ($gitExitCode -eq 0 -and $gitRoot) {
        return [pscustomobject]@{
            Root            = $gitRoot.Trim()
            IsGitRepository = $true
            Error           = $null
        }
    }

    if ($AllowNonGit) {
        return [pscustomobject]@{
            Root            = $resolved
            IsGitRepository = $false
            Error           = $null
        }
    }

    return [pscustomobject]@{
        Root            = $resolved
        IsGitRepository = $false
        Error           = (@(
            "TargetPath must be inside a Git repository."
            "Use -AllowNonGitTarget to validate a non-Git directory."
        ) -join " ")
    }
}

function Read-JsonFile {
    param([string]$Path)

    try {
        return Get-Content -Raw -LiteralPath $Path | ConvertFrom-Json
    } catch {
        throw "Invalid JSON file: $Path"
    }
}

function Test-SemVer {
    param([string]$Version)

    return $Version -match '^\d+\.\d+\.\d+(-[0-9A-Za-z.-]+)?(\+[0-9A-Za-z.-]+)?$'
}

function Get-ExpectedFiles {
    param(
        [object]$Manifest,
        [string]$ValidationProfile,
        [bool]$ValidateWiki
    )

    $files = New-Object System.Collections.Generic.List[object]

    foreach ($file in $Manifest.files) {
        $isFramework = $file.owner -eq "Framework"
        $isRequiredProjectFile = $file.owner -eq "Project" -and $file.required -eq $true
        $isFullProjectFile = $file.owner -eq "Project" -and $ValidationProfile -eq "full"
        $isWikiFile = $file.owner -eq "Generated" -and $ValidateWiki

        if ($isFramework -or $isRequiredProjectFile -or $isFullProjectFile -or $isWikiFile) {
            $files.Add($file) | Out-Null
        }
    }

    return $files
}

$scriptRoot = Split-Path -Parent $PSCommandPath
$repoRoot = Resolve-ExistingPath -Path (Join-Path $scriptRoot "..")
$sourceManifestPath = Join-Path $repoRoot "src\.codex\framework.json"
$sourceManifest = Read-JsonFile -Path $sourceManifestPath
$targetInfo = Get-TargetInfo -Path $TargetPath -AllowNonGit:$AllowNonGitTarget

Write-Host "Target root: $($targetInfo.Root)"
Write-Host "Git repository: $($targetInfo.IsGitRepository)"
Write-Host "Profile: $Profile"
Write-Host "Include wiki: $IncludeWiki"

if ($targetInfo.Error) {
    Write-Host ""
    Write-Host "[error] $($targetInfo.Error)"
    exit 1
}

$targetManifestPath = Join-RootPath -Root $targetInfo.Root -RelativePath ".codex/framework.json"
$manifest = $null
$issues = New-Object System.Collections.Generic.List[string]

if (Test-Path -LiteralPath $targetManifestPath -PathType Leaf) {
    $manifest = Read-JsonFile -Path $targetManifestPath
} else {
    $issues.Add(".codex/framework.json is missing.") | Out-Null
    $manifest = $sourceManifest
}

if (-not $manifest.schemaVersion -or $manifest.schemaVersion -lt 2) {
    $issues.Add(".codex/framework.json must use schemaVersion 2 or later.") | Out-Null
}

if (-not $manifest.version) {
    $issues.Add(".codex/framework.json is missing the version field.") | Out-Null
} elseif (-not (Test-SemVer -Version $manifest.version)) {
    $issues.Add(".codex/framework.json version is not valid SemVer: $($manifest.version)") | Out-Null
}

if (-not $manifest.files) {
    $issues.Add(".codex/framework.json does not define files.") | Out-Null
}

$expectedFiles = Get-ExpectedFiles -Manifest $manifest -ValidationProfile $Profile -ValidateWiki:$IncludeWiki
$missingFiles = New-Object System.Collections.Generic.List[object]

foreach ($file in $expectedFiles) {
    $absolutePath = Join-RootPath -Root $targetInfo.Root -RelativePath $file.path

    if (-not (Test-Path -LiteralPath $absolutePath -PathType Leaf)) {
        $missingFiles.Add($file) | Out-Null
    }
}

Write-Host ""
Write-Host "Expected files:"
if ($missingFiles.Count -eq 0) {
    Write-Host "  [OK] all expected files are present"
} else {
    foreach ($file in $missingFiles) {
        Write-Host "  [missing] $($file.path) ($($file.owner))"
    }
}

if ($issues.Count -gt 0) {
    Write-Host ""
    Write-Host "Manifest issues:"

    foreach ($issue in $issues) {
        Write-Host "  [error] $issue"
    }
}

$targetIsNotReady = $missingFiles.Count -gt 0 -or $issues.Count -gt 0

if ($targetIsNotReady) {
    Write-Host ""
    Write-Host "Target repository is not Codex-ready."
    exit 1
}

Write-Host ""
Write-Host "Target repository is Codex-ready."
exit 0
