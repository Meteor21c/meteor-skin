[CmdletBinding()]
param([string]$OutputRoot = (Join-Path (Get-Location) 'dist'))

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'lib\windows-common.ps1')
$node = Get-DreamNodePath
$stamp = (Get-Date).ToUniversalTime().ToString('yyyyMMddTHHmmssZ')
$packageName = "Codex-AutoSkin-Portable-2.3.0-$stamp"
$packageDir = Join-Path $OutputRoot $packageName
$zipPath = Join-Path $OutputRoot "$packageName.zip"
New-Item -ItemType Directory -Force -Path $OutputRoot | Out-Null
if (Test-Path -LiteralPath $packageDir) { throw "Output already exists: $packageDir" }
if (Test-Path -LiteralPath $zipPath) { throw "Archive already exists: $zipPath" }

& $node (Join-Path $PSScriptRoot 'build-share-package.mjs') --output $packageDir
if ($LASTEXITCODE -ne 0) { throw 'Package staging failed.' }
Compress-Archive -LiteralPath $packageDir -DestinationPath $zipPath -CompressionLevel Optimal
Write-Host $zipPath
