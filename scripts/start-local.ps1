[CmdletBinding()]
param([ValidateRange(1024,65535)][int]$Port = 5173)
$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
if (-not (Test-Path -LiteralPath (Join-Path $root "package.json"))) {
    throw "L'application n'existe pas encore. Définissez la mission dans Codex, puis validez sa construction."
}
$npm = Get-Command npm.cmd -ErrorAction SilentlyContinue
if (-not $npm) { $npm = Get-Command npm -ErrorAction SilentlyContinue }
if (-not $npm) { throw "Node.js/npm est requis. Codex peut vous aider à le préparer avec votre accord." }
Push-Location $root
try {
    if (-not (Test-Path -LiteralPath "node_modules")) {
        if (Test-Path -LiteralPath "package-lock.json") { & $npm.Source ci }
        else { & $npm.Source install }
        if ($LASTEXITCODE -ne 0) { throw "Installation impossible. Codex doit analyser le message affiché." }
    }
    Write-Output "Démarrage local demandé. Attendre la confirmation du serveur. Ctrl+C pour arrêter."
    & $npm.Source run dev -- --host 127.0.0.1 --port $Port --strictPort
    if ($LASTEXITCODE -ne 0) { throw "Le serveur n'a pas démarré. Vérifier notamment si le port $Port est déjà utilisé." }
} finally { Pop-Location }
