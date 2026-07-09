[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$TargetPath,

    [switch]$Force,

    [switch]$Backup,

    [switch]$DryRun,

    [switch]$AllowDirtyTarget,

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
        }
    }

    if ($AllowNonGit) {
        return [pscustomobject]@{
            Root            = $resolved
            IsGitRepository = $false
        }
    }

    throw (@(
        "TargetPath must be inside a Git repository."
        "Use -AllowNonGitTarget to copy into a non-Git directory."
    ) -join " ")
}

function Test-DirtyGitRepository {
    param([string]$Root)

    $status = & git -C $Root status --porcelain
    return [bool]$status
}

function Read-FrameworkManifest {
    param([string]$Path)

    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        throw "Framework manifest not found: $Path"
    }

    $manifest = Get-Content -Raw -LiteralPath $Path | ConvertFrom-Json

    if (-not $manifest.schemaVersion -or $manifest.schemaVersion -lt 2) {
        throw "Framework manifest must use schemaVersion 2 or later."
    }

    if (-not $manifest.files) {
        throw "Framework manifest does not define any files."
    }

    return $manifest
}

function Get-InstallFiles {
    param(
        [object]$Manifest,
        [bool]$InstallWiki
    )

    $files = New-Object System.Collections.Generic.List[object]

    foreach ($file in $Manifest.files) {
        if ($file.owner -eq "Generated" -and -not $InstallWiki) {
            continue
        }

        $files.Add($file) | Out-Null
    }

    return $files
}

function Add-Change {
    param(
        [System.Collections.Generic.List[object]]$Changes,
        [string]$Action,
        [object]$ManifestFile,
        [string]$Source,
        [string]$Destination
    )

    $Changes.Add([pscustomobject]@{
        Action      = $Action
        Path        = $ManifestFile.path
        Owner       = $ManifestFile.owner
        InstallMode = $ManifestFile.installMode
        Source      = $Source
        Destination = $Destination
    }) | Out-Null
}

function Write-ChangeSummary {
    param(
        [System.Collections.Generic.List[object]]$Changes,
        [System.Collections.Generic.List[object]]$Conflicts
    )

    $created = @($Changes | Where-Object { $_.Action -eq "create" }).Count
    $updated = @($Changes | Where-Object { $_.Action -eq "update" }).Count
    $unchanged = @($Changes | Where-Object { $_.Action -eq "unchanged" }).Count
    $preserved = @($Changes | Where-Object { $_.Action -eq "preserve" }).Count
    $conflictCount = $Conflicts.Count

    Write-Host ""
    Write-Host "Summary:"
    Write-Host "  created:   $created"
    Write-Host "  updated:   $updated"
    Write-Host "  unchanged: $unchanged"
    Write-Host "  preserved: $preserved"
    Write-Host "  conflicts: $conflictCount"
}

if ($Backup -and -not $Force) {
    throw (@(
        "-Backup requires -Force because backups are only created before"
        "overwriting target files."
    ) -join " ")
}

$scriptRoot = Split-Path -Parent $PSCommandPath
$repoRoot = Resolve-ExistingPath -Path (Join-Path $scriptRoot "..")
$manifestPath = Join-Path $repoRoot "src\.codex\framework.json"
$manifest = Read-FrameworkManifest -Path $manifestPath
$targetInfo = Get-TargetInfo -Path $TargetPath -AllowNonGit:$AllowNonGitTarget
$targetRoot = $targetInfo.Root

Write-Host "Framework:     $($manifest.name) $($manifest.version)"
Write-Host "Manifest:      $manifestPath"
Write-Host "Target root:   $targetRoot"
Write-Host "Include wiki:  $IncludeWiki"

if ($targetInfo.IsGitRepository) {
    $targetIsDirty = Test-DirtyGitRepository -Root $targetRoot

    if ($targetIsDirty -and -not $AllowDirtyTarget) {
        if ($DryRun) {
            Write-Host (@(
                "Target Git working tree is dirty."
                "A non-dry-run install would fail unless -AllowDirtyTarget is used."
            ) -join " ")
        } else {
            throw (@(
                "Target Git working tree is dirty."
                "Commit, stash, or use -AllowDirtyTarget before installing."
            ) -join " ")
        }
    }
} else {
    Write-Host "Target is not a Git repository."
}

Write-Host ""

$plannedChanges = New-Object System.Collections.Generic.List[object]
$conflicts = New-Object System.Collections.Generic.List[object]
$installFiles = Get-InstallFiles -Manifest $manifest -InstallWiki:$IncludeWiki

foreach ($file in $installFiles) {
    $source = Join-RootPath -Root $repoRoot -RelativePath $file.source
    $destination = Join-RootPath -Root $targetRoot -RelativePath $file.path
    $destinationExists = Test-Path -LiteralPath $destination -PathType Leaf

    if (-not (Test-Path -LiteralPath $source -PathType Leaf)) {
        throw "Manifest source file not found: $($file.source)"
    }

    if ($file.installMode -eq "create-if-missing") {
        if ($destinationExists) {
            Add-Change -Changes $plannedChanges -Action "preserve" -ManifestFile $file -Source $source -Destination $destination
        } else {
            Add-Change -Changes $plannedChanges -Action "create" -ManifestFile $file -Source $source -Destination $destination
        }

        continue
    }

    if ($file.installMode -ne "managed") {
        throw "Unsupported installMode '$($file.installMode)' for $($file.path)"
    }

    if ($destinationExists) {
        $sourceHash = (Get-FileHash -LiteralPath $source -Algorithm SHA256).Hash
        $destinationHash = (Get-FileHash -LiteralPath $destination -Algorithm SHA256).Hash

        if ($sourceHash -eq $destinationHash) {
            Add-Change -Changes $plannedChanges -Action "unchanged" -ManifestFile $file -Source $source -Destination $destination
            continue
        }

        if (-not $Force) {
            $conflicts.Add([pscustomobject]@{
                Path        = $file.path
                Owner       = $file.owner
                Source      = $source
                Destination = $destination
            }) | Out-Null
            continue
        }

        Add-Change -Changes $plannedChanges -Action "update" -ManifestFile $file -Source $source -Destination $destination
    } else {
        Add-Change -Changes $plannedChanges -Action "create" -ManifestFile $file -Source $source -Destination $destination
    }
}

foreach ($change in $plannedChanges) {
    Write-Host "[$($change.Action)] $($change.Path) ($($change.Owner))"
}

foreach ($conflict in $conflicts) {
    Write-Host "[conflict] $($conflict.Path) ($($conflict.Owner))"
}

Write-ChangeSummary -Changes $plannedChanges -Conflicts $conflicts

if ($conflicts.Count -gt 0) {
    Write-Host ""
    Write-Host "Conflicting managed files were found. Nothing was copied."
    Write-Host "Use -Force if you intentionally want to overwrite them."
    exit 2
}

if ($DryRun) {
    Write-Host ""
    Write-Host "Dry run complete. No files were copied."
    exit 0
}

$backupTimestamp = Get-Date -Format "yyyyMMddHHmmss"

foreach ($change in $plannedChanges) {
    if ($change.Action -eq "unchanged" -or $change.Action -eq "preserve") {
        continue
    }

    $destinationDirectory = Split-Path -Parent $change.Destination

    if (-not (Test-Path -LiteralPath $destinationDirectory -PathType Container)) {
        New-Item -ItemType Directory -Path $destinationDirectory -Force | Out-Null
    }

    $shouldCreateBackup =
        $Backup -and
        $change.Action -eq "update" -and
        (Test-Path -LiteralPath $change.Destination -PathType Leaf)

    if ($shouldCreateBackup) {
        $backupPath = "$($change.Destination).$backupTimestamp.bak"
        Copy-Item -LiteralPath $change.Destination -Destination $backupPath -Force
        Write-Host "[backup] $($change.Path) -> $(Split-Path -Leaf $backupPath)"
    }

    Copy-Item -LiteralPath $change.Source -Destination $change.Destination -Force
}

Write-Host ""
Write-Host "Codex development framework files installed."
