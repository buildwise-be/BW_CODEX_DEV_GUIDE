[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$TargetPath,

    [switch]$Force,

    [switch]$DryRun,

    [switch]$AllowNonGitTarget
)

$ErrorActionPreference = "Stop"

function Resolve-ExistingPath {
    param([string]$Path)

    return (Resolve-Path -LiteralPath $Path).ProviderPath
}

function Get-RelativePathFromRoot {
    param(
        [string]$Root,
        [string]$Path
    )

    $normalizedRoot = $Root.TrimEnd([System.IO.Path]::DirectorySeparatorChar, [System.IO.Path]::AltDirectorySeparatorChar)
    return $Path.Substring($normalizedRoot.Length).TrimStart([System.IO.Path]::DirectorySeparatorChar, [System.IO.Path]::AltDirectorySeparatorChar)
}

function Get-TargetRoot {
    param(
        [string]$Path,
        [bool]$AllowNonGit
    )

    $resolved = Resolve-ExistingPath -Path $Path
    $gitRoot = & git -C $resolved rev-parse --show-toplevel 2>$null

    if ($LASTEXITCODE -eq 0 -and $gitRoot) {
        return $gitRoot.Trim()
    }

    if ($AllowNonGit) {
        return $resolved
    }

    throw "TargetPath must be inside a Git repository. Use -AllowNonGitTarget to copy into a non-Git directory."
}

$scriptRoot = Split-Path -Parent $PSCommandPath
$repoRoot = Resolve-ExistingPath -Path (Join-Path $scriptRoot "..")
$sourceRoot = Join-Path $repoRoot "src"

if (-not (Test-Path -LiteralPath $sourceRoot -PathType Container)) {
    throw "Source payload not found: $sourceRoot"
}

$sourceRoot = Resolve-ExistingPath -Path $sourceRoot
$targetRoot = Get-TargetRoot -Path $TargetPath -AllowNonGit:$AllowNonGitTarget

$sourceFiles = Get-ChildItem -LiteralPath $sourceRoot -Recurse -File -Force
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
                Action = "unchanged"
                Path = $relativePath
                Source = $file.FullName
                Destination = $destination
            }) | Out-Null
            continue
        }

        if (-not $Force) {
            $conflicts.Add([pscustomobject]@{
                Path = $relativePath
                Source = $file.FullName
                Destination = $destination
            }) | Out-Null
            continue
        }

        $action = "update"
    } else {
        $action = "create"
    }

    $plannedChanges.Add([pscustomobject]@{
        Action = $action
        Path = $relativePath
        Source = $file.FullName
        Destination = $destination
    }) | Out-Null
}

Write-Host "Source payload: $sourceRoot"
Write-Host "Target root:    $targetRoot"
Write-Host ""

if ($conflicts.Count -gt 0) {
    Write-Host "Conflicting files were found. Nothing was copied."
    Write-Host "Use -Force if you intentionally want to overwrite them."
    Write-Host ""

    foreach ($conflict in $conflicts) {
        Write-Host "[conflict] $($conflict.Path)"
    }

    exit 2
}

foreach ($change in $plannedChanges) {
    Write-Host "[$($change.Action)] $($change.Path)"
}

if ($DryRun) {
    Write-Host ""
    Write-Host "Dry run complete. No files were copied."
    exit 0
}

foreach ($change in $plannedChanges) {
    if ($change.Action -eq "unchanged") {
        continue
    }

    $destinationDirectory = Split-Path -Parent $change.Destination

    if (-not (Test-Path -LiteralPath $destinationDirectory -PathType Container)) {
        New-Item -ItemType Directory -Path $destinationDirectory -Force | Out-Null
    }

    Copy-Item -LiteralPath $change.Source -Destination $change.Destination -Force
}

Write-Host ""
Write-Host "Codex development guide files installed."
