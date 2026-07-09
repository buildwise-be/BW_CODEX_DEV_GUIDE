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
            "Use -AllowNonGitTarget to inspect a non-Git directory."
        ) -join " ")
    }
}

function Write-PathFinding {
    param(
        [string]$Root,
        [string]$Path,
        [string]$Recommendation
    )

    $absolutePath = Join-RootPath -Root $Root -RelativePath $Path

    if (Test-Path -LiteralPath $absolutePath -PathType Leaf) {
        Write-Host "[found] $Path"
        Write-Host "        $Recommendation"
    } else {
        Write-Host "[missing] $Path"
    }
}

$targetInfo = Get-TargetInfo -Path $TargetPath -AllowNonGit:$AllowNonGitTarget

Write-Host "Target root: $($targetInfo.Root)"
Write-Host "Git repository: $($targetInfo.IsGitRepository)"

if ($targetInfo.Error) {
    Write-Host ""
    Write-Host "[error] $($targetInfo.Error)"
    exit 1
}

Write-Host ""
Write-Host "V1 to V2 migration report"
Write-Host ""
Write-Host "This script reports migration work only. It does not move or delete files."

Write-Host ""
Write-Host "Framework metadata:"
Write-PathFinding `
    -Root $targetInfo.Root `
    -Path ".codex/guide-version.json" `
    -Recommendation "Replace with .codex/framework.json by running the V2 installer."

Write-PathFinding `
    -Root $targetInfo.Root `
    -Path ".codex/framework.json" `
    -Recommendation "Already using V2 framework metadata."

Write-Host ""
Write-Host "Governance files:"
Write-PathFinding `
    -Root $targetInfo.Root `
    -Path "docs/ai-context/AI_DEVELOPMENT_GUIDE.md" `
    -Recommendation "Move governance content to docs/ai-governance/AI_DEVELOPMENT_GUIDE.md."

Write-PathFinding `
    -Root $targetInfo.Root `
    -Path "docs/ai-context/PROMPTS.md" `
    -Recommendation "Move reusable prompts to docs/ai-governance/PROMPTS.md unless they are project-specific."

Write-Host ""
Write-Host "Project memory:"
Write-PathFinding `
    -Root $targetInfo.Root `
    -Path "docs/ai-context/ARCHITECTURE.md" `
    -Recommendation "Split repository-inferred facts into docs/wiki/ and preserve human intent in docs/ai-context/DECISIONS.md."

Write-PathFinding `
    -Root $targetInfo.Root `
    -Path "docs/ai-context/CURRENT_STATE.md" `
    -Recommendation "Keep as project-owned operational memory."

Write-PathFinding `
    -Root $targetInfo.Root `
    -Path "docs/ai-context/DECISIONS.md" `
    -Recommendation "Keep as project-owned operational memory."

Write-PathFinding `
    -Root $targetInfo.Root `
    -Path "docs/ai-context/KNOWN_ISSUES.md" `
    -Recommendation "Keep as project-owned operational memory."

Write-PathFinding `
    -Root $targetInfo.Root `
    -Path "docs/ai-context/CHANGELOG_AI.md" `
    -Recommendation "Keep as project-owned operational memory."

Write-Host ""
Write-Host "Recommended sequence:"
Write-Host "1. Commit or stash target repository changes."
Write-Host "2. Run scripts/install.ps1 -DryRun from the V2 framework repository."
Write-Host "3. Review managed file conflicts."
Write-Host "4. Run the real install when the plan is acceptable."
Write-Host "5. Manually migrate old ARCHITECTURE.md facts into docs/wiki/."
Write-Host "6. Run scripts/validate-target.ps1."
