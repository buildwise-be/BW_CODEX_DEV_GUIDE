[CmdletBinding()]
param(
    [string]$StarterPath = (Join-Path (Split-Path -Parent $PSScriptRoot) "starter")
)

$ErrorActionPreference = "Stop"
$required = @(
    "package.json",
    "README.md",
    "AGENTS.md",
    "docs/ai-context/BUSINESS_BRIEF.md",
    "docs/ai-context/FEATURE_CHECKLIST.md",
    "docs/ai-context/VALIDATION_CHECKLIST.md",
    "docs/LOCAL_TESTING.md",
    "scripts/start-local.ps1",
    "scripts/check-local.ps1",
    "src/App.tsx",
    "src/styles.css",
    "src/data/adapters.ts",
    "src/data/projects.ts",
    "src/data/kpis.ts"
)

$missing = @($required | Where-Object { -not (Test-Path -LiteralPath (Join-Path $StarterPath $_)) })
if ($missing.Count -gt 0) {
    Write-Error ("Missing starter files:`n - " + ($missing -join "`n - "))
}

$package = Get-Content -Raw -LiteralPath (Join-Path $StarterPath "package.json") | ConvertFrom-Json
if ($package.name -ne "bw-app-starter") { Write-Error "Starter package name must be bw-app-starter." }
if (-not $package.scripts.build) { Write-Error "Starter must expose a build script." }
if (-not $package.scripts.check) { Write-Error "Starter must expose a check script." }

$brief = Get-Content -Raw -LiteralPath (Join-Path $StarterPath "docs/ai-context/BUSINESS_BRIEF.md")
if ($brief -notmatch "État\s*:\s*À définir") {
    Write-Error "The starter business brief must begin in the 'À définir' state."
}

Write-Output "BW App Starter validation passed: $StarterPath"
