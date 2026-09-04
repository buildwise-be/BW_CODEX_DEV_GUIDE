[CmdletBinding()]
param([string]$ProjectPath = (Split-Path -Parent $PSScriptRoot))
$ErrorActionPreference = "Stop"
$root = (Resolve-Path -LiteralPath $ProjectPath).ProviderPath
if (-not (Test-Path -LiteralPath (Join-Path $root "docs/ai-governance/UI_SPEC.md"))) { throw "Spécifications UI absentes." }
foreach ($path in @("docs/ai-governance/BRAND_RULES.md", "docs/ai-context/BRAND_REVIEW.md", "assets/brand/policy.json", "scripts/check-brand.mjs")) {
    if (-not (Test-Path -LiteralPath (Join-Path $root $path))) { throw "Référence graphique absente : $path" }
}
$manifest = Get-Content -Raw -LiteralPath (Join-Path $root ".codex/framework.json") | ConvertFrom-Json
foreach ($file in $manifest.files) {
    if (-not (Test-Path -LiteralPath (Join-Path $root $file.path) -PathType Leaf)) {
        throw "Fichier requis absent : $($file.path)"
    }
}
$brief = Get-Content -Raw -LiteralPath (Join-Path $root "docs/ai-context/BUSINESS_BRIEF.md")
$package = Get-Content -Raw -LiteralPath (Join-Path $root "templates/application/package.json") | ConvertFrom-Json
if ($package.scripts.'check:brand' -ne 'node scripts/check-brand.mjs' -or $package.scripts.check -notmatch '^npm run check:brand &&') {
    throw "Le contrôle graphique doit précéder les tests et la compilation."
}
$lockJson = Get-Content -Raw -LiteralPath (Join-Path $root "templates/application/package-lock.json")
# PowerShell 5.1 cannot represent an empty JSON property name as a PSObject.
$lock = ($lockJson -replace '"":', '"__root":') | ConvertFrom-Json
foreach ($section in @("dependencies", "devDependencies")) {
    foreach ($dependency in $package.$section.PSObject.Properties) {
        if ($dependency.Value -ne $lock.packages.__root.$section.($dependency.Name)) {
            throw "Dépendance incohérente avec le lockfile : $($dependency.Name)"
        }
    }
}
if ($brief -notmatch '(?m)^État\s*:\s*(À définir|Validé)\s*$') { throw "État du brief invalide." }
foreach ($file in Get-ChildItem -LiteralPath (Join-Path $root "scripts") -Filter "*.ps1") {
    $errorsFound = $null
    [System.Management.Automation.Language.Parser]::ParseFile($file.FullName, [ref]$null, [ref]$errorsFound) | Out-Null
    if ($errorsFound.Count) { throw "Syntaxe invalide : $($file.Name)" }
}
Write-Output "Framework valide. Cela ne certifie pas une application métier."
