[CmdletBinding()]
param()
$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
if (-not (Test-Path -LiteralPath (Join-Path $root "package.json"))) { throw "Pas encore d'application métier à vérifier." }
$npm = Get-Command npm.cmd -ErrorAction SilentlyContinue
if (-not $npm) { $npm = Get-Command npm -ErrorAction SilentlyContinue }
if (-not $npm) { throw "Node.js/npm est requis." }
Push-Location $root
try {
    & $npm.Source run check
    if ($LASTEXITCODE -ne 0) { throw "La vérification de l'application a échoué." }
} finally { Pop-Location }
