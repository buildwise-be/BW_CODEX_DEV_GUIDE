$ErrorActionPreference = "Continue"

function Write-Section {
    param([string]$Title)

    Write-Host ""
    Write-Host "== $Title =="
}

function Write-FileStatus {
    param(
        [string]$Path,
        [bool]$Required = $false
    )

    if (Test-Path $Path) {
        Write-Host "[OK] $Path"
        return $true
    }

    if ($Required) {
        Write-Host "[MISSING] $Path (required)"
    } else {
        Write-Host "[missing] $Path"
    }

    return $false
}

$repoRoot = git rev-parse --show-toplevel 2>$null
if ($LASTEXITCODE -eq 0 -and $repoRoot) {
    Set-Location $repoRoot
}

Write-Host "=== Codex SessionStart: AGENTS protocol ==="
Write-Host "Workspace: $(Get-Location)"

Write-Section "Required context"
$hasAgents = Write-FileStatus -Path "AGENTS.md" -Required $true
$hasGuide = Write-FileStatus -Path "docs/ai-context/AI_DEVELOPMENT_GUIDE.md" -Required $true

Write-Section "Optional project memory"
$optionalDocs = @(
    "docs/ai-context/CURRENT_STATE.md",
    "docs/ai-context/ARCHITECTURE.md",
    "docs/ai-context/DECISIONS.md",
    "docs/ai-context/KNOWN_ISSUES.md",
    "docs/ai-context/PROMPTS.md"
)

foreach ($doc in $optionalDocs) {
    [void](Write-FileStatus -Path $doc)
}

Write-Section "Git branch"
git branch --show-current

Write-Section "Git status"
git status --short

Write-Section "Diff with main"
git rev-parse --verify main 2>$null | Out-Null
if ($LASTEXITCODE -eq 0) {
    git diff --stat main...HEAD
} else {
    Write-Host "main ref not found; skipping comparison."
}

Write-Section "Before code changes"
Write-Host "1. Read AGENTS.md and required project context."
Write-Host "2. Read the related Issue or task description."
Write-Host "3. Summarize understanding, risks, and ambiguities."
Write-Host "4. Propose a step-by-step plan."
Write-Host "5. Wait for approval before modifying files."

if (-not $hasAgents -or -not $hasGuide) {
    Write-Host ""
    Write-Host "Required startup context is missing."
    exit 1
}

exit 0
