[CmdletBinding()]
param([string]$ProjectPath = (Split-Path -Parent $PSScriptRoot))
$ErrorActionPreference = "Stop"
$root = (Resolve-Path -LiteralPath $ProjectPath).ProviderPath
if (-not (Test-Path -LiteralPath (Join-Path $root "docs/ai-governance/UI_SPEC.md"))) { throw "UI specification is missing." }
foreach ($path in @("docs/ai-governance/BRAND_RULES.md", "docs/ai-context/BRAND_REVIEW.md", "assets/brand/policy.json", "scripts/check-brand.mjs")) {
    if (-not (Test-Path -LiteralPath (Join-Path $root $path))) { throw "Missing brand reference: $path" }
}
foreach ($path in @("docs/ai-governance/I18N_RULES.md", "docs/ai-context/I18N_REVIEW.md", "scripts/check-i18n.mjs", "templates/application/src/i18n/messages/fr.json", "templates/application/src/i18n/messages/nl.json")) {
    if (-not (Test-Path -LiteralPath (Join-Path $root $path))) { throw "Missing French/Dutch reference: $path" }
}
$manifest = Get-Content -Raw -LiteralPath (Join-Path $root ".codex/framework.json") | ConvertFrom-Json
foreach ($file in $manifest.files) {
    if (-not (Test-Path -LiteralPath (Join-Path $root $file.path) -PathType Leaf)) {
        throw "Missing required file: $($file.path)"
    }
}
$brief = Get-Content -Raw -LiteralPath (Join-Path $root "docs/ai-context/BUSINESS_BRIEF.md")
$package = Get-Content -Raw -LiteralPath (Join-Path $root "templates/application/package.json") | ConvertFrom-Json
if ($package.scripts.'check:i18n' -ne 'node scripts/check-i18n.mjs' -or
    $package.scripts.'check:brand' -ne 'node scripts/check-brand.mjs' -or
    $package.scripts.check -notmatch '^npm run check:i18n && npm run check:brand &&') {
    throw "French/Dutch and brand checks must run before tests and compilation."
}
$lockJson = Get-Content -Raw -LiteralPath (Join-Path $root "templates/application/package-lock.json")
# PowerShell 5.1 cannot represent an empty JSON property name as a PSObject.
$lock = ($lockJson -replace '"":', '"__root":') | ConvertFrom-Json
foreach ($section in @("dependencies", "devDependencies")) {
    foreach ($dependency in $package.$section.PSObject.Properties) {
        if ($dependency.Value -ne $lock.packages.__root.$section.($dependency.Name)) {
            throw "Dependency does not match the lockfile: $($dependency.Name)"
        }
    }
}
if ($brief -notmatch '(?m)^Status\s*:\s*(To define|Validated)\s*$') { throw "Invalid business brief status." }
foreach ($file in Get-ChildItem -LiteralPath (Join-Path $root "scripts") -Filter "*.ps1") {
    $errorsFound = $null
    [System.Management.Automation.Language.Parser]::ParseFile($file.FullName, [ref]$null, [ref]$errorsFound) | Out-Null
    if ($errorsFound.Count) { throw "Invalid syntax: $($file.Name)" }
}
Write-Output "Framework valid. This does not certify a business application."
