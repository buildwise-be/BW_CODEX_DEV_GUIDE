$ErrorActionPreference = "Stop"
# Optional read-only check. No installation, app launch or approval changes.
$root = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
& (Join-Path $root "scripts/validate-framework.ps1") -ProjectPath $root
Write-Output "Lire AGENTS.md puis les règles dans docs/ai-governance/. Reprendre le brief et l'état courant."
