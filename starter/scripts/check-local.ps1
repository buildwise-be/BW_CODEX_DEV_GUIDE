[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"
$projectRoot = Split-Path -Parent $PSScriptRoot

Push-Location $projectRoot
try {
    if (-not (Test-Path -LiteralPath (Join-Path $projectRoot "node_modules"))) {
        throw "L'application n'est pas encore préparée. Lancez d'abord scripts/start-local.ps1."
    }

    Write-Output "Vérification de l'application..."
    & npm run check
    if ($LASTEXITCODE -ne 0) {
        throw "La vérification a détecté un problème. Demandez à Codex de le corriger."
    }
    Write-Output "L'application est prête à être testée."
}
finally {
    Pop-Location
}
