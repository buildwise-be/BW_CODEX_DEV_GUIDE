[CmdletBinding()]
param([string]$ProjectPath = (Split-Path -Parent $PSScriptRoot))
$ErrorActionPreference = "Stop"
$root = (Resolve-Path -LiteralPath $ProjectPath).ProviderPath
$manifest = Get-Content -Raw -LiteralPath (Join-Path $root ".codex/framework.json") | ConvertFrom-Json
foreach ($file in $manifest.files) {
    if (-not (Test-Path -LiteralPath (Join-Path $root $file.path) -PathType Leaf)) {
        throw "Fichier requis absent : $($file.path)"
    }
}
$brief = Get-Content -Raw -LiteralPath (Join-Path $root "docs/ai-context/BUSINESS_BRIEF.md")
$package = Get-Content -Raw -LiteralPath (Join-Path $root "templates/application/package.json") | ConvertFrom-Json
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
