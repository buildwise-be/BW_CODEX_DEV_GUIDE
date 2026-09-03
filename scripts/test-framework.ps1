[CmdletBinding()]
param()
$ErrorActionPreference = "Stop"
$source = Split-Path -Parent $PSScriptRoot
$fixture = Join-Path ([IO.Path]::GetTempPath()) ("bw-builder-test-" + [guid]::NewGuid())
New-Item -ItemType Directory -Path $fixture | Out-Null
# Keep the small test fixture for inspection; never recursively delete a computed path.
foreach ($folder in @("templates/application", "assets/brand", "docs/ai-context")) {
    $target = Join-Path $fixture $folder
    New-Item -ItemType Directory -Path (Split-Path -Parent $target) -Force | Out-Null
    Copy-Item -LiteralPath (Join-Path $source $folder) -Destination $target -Recurse
}
$initialize = Join-Path $source "scripts/initialize-app.ps1"
$blocked = $false
try { & $initialize -ProjectPath $fixture } catch { $blocked = $true }
if (-not $blocked -or (Test-Path (Join-Path $fixture "package.json"))) { throw "Unvalidated brief was not blocked." }
Write-Output "PASS: unvalidated brief blocks initialization."

$briefFile = Join-Path $fixture "docs/ai-context/BUSINESS_BRIEF.md"
$brief = (Get-Content -Raw -LiteralPath $briefFile).Replace("État : À définir", "État : Validé")
[IO.File]::WriteAllText($briefFile, $brief)
& $initialize -ProjectPath $fixture -DryRun
if (Test-Path (Join-Path $fixture "package.json")) { throw "Dry run wrote files." }
Write-Output "PASS: dry run does not create an app."

New-Item -ItemType Directory -Path (Join-Path $fixture "src") -Force | Out-Null
& $initialize -ProjectPath $fixture
foreach ($file in @("package.json", "src/App.tsx", "src/brand.css", "public/brand/buildwise-logo.svg")) {
    if (-not (Test-Path (Join-Path $fixture $file))) { throw "Generated file missing: $file" }
}
Write-Output "PASS: validated brief initializes neutral app with brand assets, including an empty src directory."
$before = (Get-FileHash (Join-Path $fixture "src/App.tsx")).Hash
$blocked = $false
try { & $initialize -ProjectPath $fixture } catch { $blocked = $true }
if (-not $blocked -or $before -ne (Get-FileHash (Join-Path $fixture "src/App.tsx")).Hash) { throw "Existing app was not preserved." }
Write-Output "PASS: repeated initialization preserves existing app."
Write-Output "Test fixture preserved at $fixture"
