[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$TargetPath,

    [switch]$Force,

    [switch]$Backup,

    [switch]$DryRun,

    [switch]$AllowDirtyTarget,

    [switch]$AllowNonGitTarget
)

$ErrorActionPreference = "Stop"

function Resolve-ExistingPath {
    param(
        [string]$Path
    )

    return (Resolve-Path -LiteralPath $Path).ProviderPath
}

function Get-RelativePathFromRoot {
    param(
        [string]$Root,
        [string]$Path
    )

    $normalizedRoot = $Root.TrimEnd(
        [System.IO.Path]::DirectorySeparatorChar,
        [System.IO.Path]::AltDirectorySeparatorChar
    )

    return $Path.Substring($normalizedRoot.Length).TrimStart(
        [System.IO.Path]::DirectorySeparatorChar,
        [System.IO.Path]::AltDirectorySeparatorChar
    )
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
    param(
        [string]$Root
    )

    $status = & git -C $Root status --porcelain
    return [bool]$status
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
$sourceRoot = Join-Path $repoRoot "src"
$templateRoot = Join-Path $repoRoot "templates\ai-context"

if (-not (Test-Path -LiteralPath $sourceRoot -PathType Container)) {
    throw "Source payload not found: $sourceRoot"
}

if (-not (Test-Path -LiteralPath $templateRoot -PathType Container)) {
    throw "AI context templates not found: $templateRoot"
}

$sourceRoot = Resolve-ExistingPath -Path $sourceRoot
$templateRoot = Resolve-ExistingPath -Path $templateRoot
$targetInfo = Get-TargetInfo -Path $TargetPath -AllowNonGit:$AllowNonGitTarget
$targetRoot = $targetInfo.Root

Write-Host "Source payload: $sourceRoot"
Write-Host "Templates:      $templateRoot"
Write-Host "Target root:    $targetRoot"

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

$sourceFiles = Get-ChildItem -LiteralPath $sourceRoot -Recurse -File -Force
$templateFiles = Get-ChildItem -LiteralPath $templateRoot -File -Force
$plannedChanges = New-Object System.Collections.Generic.List[object]
$conflicts = New-Object System.Collections.Generic.List[object]

foreach ($file in $sourceFiles) {
    $relativePath = Get-RelativePathFromRoot -Root $sourceRoot -Path $file.FullName
    $destination = Join-Path $targetRoot $relativePath
    $destinationExists = Test-Path -LiteralPath $destination -PathType Leaf

    if ($destinationExists) {
        $sourceHash = (Get-FileHash -LiteralPath $file.FullName -Algorithm SHA256).Hash
        $destinationHash = (Get-FileHash -LiteralPath $destination -Algorithm SHA256).Hash

        if ($sourceHash -eq $destinationHash) {
            $plannedChanges.Add([pscustomobject]@{
                Action      = "unchanged"
                Path        = $relativePath
                Source      = $file.FullName
                Destination = $destination
            }) | Out-Null
            continue
        }

        if (-not $Force) {
            $conflicts.Add([pscustomobject]@{
                Path        = $relativePath
                Source      = $file.FullName
                Destination = $destination
            }) | Out-Null
            continue
        }

        $action = "update"
    } else {
        $action = "create"
    }

    $plannedChanges.Add([pscustomobject]@{
        Action      = $action
        Path        = $relativePath
        Source      = $file.FullName
        Destination = $destination
    }) | Out-Null
}

foreach ($file in $templateFiles) {
    $relativeTemplatePath = Get-RelativePathFromRoot -Root $templateRoot -Path $file.FullName
    $relativePath = Join-Path "docs\ai-context" $relativeTemplatePath
    $destination = Join-Path $targetRoot $relativePath
    $destinationExists = Test-Path -LiteralPath $destination -PathType Leaf

    if ($destinationExists) {
        $plannedChanges.Add([pscustomobject]@{
            Action      = "preserve"
            Path        = $relativePath
            Source      = $file.FullName
            Destination = $destination
        }) | Out-Null
        continue
    }

    $plannedChanges.Add([pscustomobject]@{
        Action      = "create"
        Path        = $relativePath
        Source      = $file.FullName
        Destination = $destination
    }) | Out-Null
}

foreach ($change in $plannedChanges) {
    Write-Host "[$($change.Action)] $($change.Path)"
}

foreach ($conflict in $conflicts) {
    Write-Host "[conflict] $($conflict.Path)"
}

Write-ChangeSummary -Changes $plannedChanges -Conflicts $conflicts

if ($conflicts.Count -gt 0) {
    Write-Host ""
    Write-Host "Conflicting files were found. Nothing was copied."
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
Write-Host "Codex development guide files installed."
