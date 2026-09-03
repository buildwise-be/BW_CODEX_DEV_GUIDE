[CmdletBinding()]
param(
    [int]$Port = 5173
)

$ErrorActionPreference = "Stop"
$projectRoot = Split-Path -Parent $PSScriptRoot

Write-Output "Préparation de votre application Buildwise..."

if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    throw "Node.js n'est pas disponible. Demandez à Codex d'installer l'environnement nécessaire."
}

if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
    throw "npm n'est pas disponible. Demandez à Codex de vérifier l'installation de Node.js."
}

Push-Location $projectRoot
try {
    if (-not (Test-Path -LiteralPath (Join-Path $projectRoot "node_modules"))) {
        Write-Output "Première utilisation : installation des éléments nécessaires..."
        & npm install
        if ($LASTEXITCODE -ne 0) {
            throw "L'installation n'a pas abouti. Demandez à Codex d'analyser le problème."
        }
    }

    Write-Output "L'application sera disponible sur http://localhost:$Port"
    Write-Output "Gardez cette fenêtre ouverte pendant le test. Utilisez Ctrl+C pour arrêter."
    & npm run dev -- --host 127.0.0.1 --port $Port
    if ($LASTEXITCODE -ne 0) {
        throw "L'application n'a pas pu démarrer. Demandez à Codex d'analyser le problème."
    }
}
finally {
    Pop-Location
}
