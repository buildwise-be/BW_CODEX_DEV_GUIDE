[CmdletBinding()]
param(
    [string]$ProjectPath = (Split-Path -Parent $PSScriptRoot),
    [switch]$DryRun
)
$ErrorActionPreference = "Stop"
$root = (Resolve-Path -LiteralPath $ProjectPath).ProviderPath
$briefPath = Join-Path $root "docs/ai-context/BUSINESS_BRIEF.md"
if (-not (Test-Path -LiteralPath $briefPath)) { throw "The business brief is missing." }
$brief = Get-Content -Raw -LiteralPath $briefPath
if ($brief -notmatch '(?m)^Status\s*:\s*Validated\s*$') {
    throw "Define and validate the mission with Codex first."
}
$template = Join-Path $root "templates/application"
if (-not (Test-Path -LiteralPath $template)) { throw "The application template is missing." }

$copies = @()
foreach ($file in Get-ChildItem -LiteralPath $template -Recurse -File -Force) {
    $relative = $file.FullName.Substring($template.Length).TrimStart([char[]]"\/")
    $copies += [pscustomobject]@{ Source = $file.FullName; Target = (Join-Path $root $relative) }
}
$copies += [pscustomobject]@{ Source = (Join-Path $root "assets/brand/theme.css"); Target = (Join-Path $root "src/brand.css") }
$copies += [pscustomobject]@{ Source = (Join-Path $root "assets/brand/buildwise-logo.svg"); Target = (Join-Path $root "public/brand/buildwise-logo.svg") }

# Validate everything before the first copy. Never overwrite an existing application.
foreach ($reserved in @("package.json", "src", "public")) {
    $reservedPath = Join-Path $root $reserved
    $hasContent = (Test-Path -LiteralPath $reservedPath -PathType Leaf)
    if (Test-Path -LiteralPath $reservedPath -PathType Container) {
        $hasContent = @(Get-ChildItem -LiteralPath $reservedPath -Recurse -Force -File).Count -gt 0
    }
    if ($hasContent) {
        throw "An application or existing files were found ($reserved). Codex must continue from them without reinitializing."
    }
}
foreach ($copy in $copies) {
    if (-not (Test-Path -LiteralPath $copy.Source -PathType Leaf)) { throw "Missing resource: $($copy.Source)" }
    if (Test-Path -LiteralPath $copy.Target) { throw "Existing file preserved: $($copy.Target)" }
}
if ($DryRun) { Write-Output "Initialization is possible: $($copies.Count) files, no files changed."; return }
foreach ($copy in $copies) {
    New-Item -ItemType Directory -Path (Split-Path -Parent $copy.Target) -Force | Out-Null
    Copy-Item -LiteralPath $copy.Source -Destination $copy.Target
}
Write-Output "Application shell created. Codex must now implement and verify the validated business journey."
