[CmdletBinding()]
param(
    [string]$ProjectPath = (Split-Path -Parent $PSScriptRoot),
    [switch]$DryRun
)
$ErrorActionPreference = "Stop"
$root = (Resolve-Path -LiteralPath $ProjectPath).ProviderPath
$briefPath = Join-Path $root "docs/ai-context/BUSINESS_BRIEF.md"
if (-not (Test-Path -LiteralPath $briefPath)) { throw "Le brief métier est absent." }
$brief = Get-Content -Raw -LiteralPath $briefPath
if ($brief -notmatch '(?m)^État\s*:\s*Validé\s*$') {
    throw "Définissez et validez d'abord la mission avec Codex."
}
$template = Join-Path $root "templates/application"
if (-not (Test-Path -LiteralPath $template)) { throw "Le socle applicatif est absent." }

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
        throw "Une application ou des fichiers existent déjà ($reserved). Codex doit les reprendre sans réinitialiser."
    }
}
foreach ($copy in $copies) {
    if (-not (Test-Path -LiteralPath $copy.Source -PathType Leaf)) { throw "Ressource absente : $($copy.Source)" }
    if (Test-Path -LiteralPath $copy.Target) { throw "Fichier existant préservé : $($copy.Target)" }
}
if ($DryRun) { Write-Output "Initialisation possible : $($copies.Count) fichiers, aucun fichier modifié."; return }
foreach ($copy in $copies) {
    New-Item -ItemType Directory -Path (Split-Path -Parent $copy.Target) -Force | Out-Null
    Copy-Item -LiteralPath $copy.Source -Destination $copy.Target
}
Write-Output "Socle créé. Codex doit maintenant réaliser et vérifier le parcours métier validé."
