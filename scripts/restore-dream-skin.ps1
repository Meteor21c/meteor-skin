[CmdletBinding()]
param(
  [int]$Port = 9335,
  [switch]$Uninstall,
  [switch]$RestoreBaseTheme
)

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'lib\windows-common.ps1')
$node = Get-DreamNodePath
$injector = Join-Path $PSScriptRoot 'injector.mjs'
$StateRoot = Join-Path $env:LOCALAPPDATA 'CodexDreamSkin'
$StatePath = Join-Path $StateRoot 'state.json'
$WatcherStatePath = Join-Path $StateRoot 'watcher-state.json'

if (Test-Path -LiteralPath $WatcherStatePath) {
  try {
    $watcherState = Get-Content -LiteralPath $WatcherStatePath -Raw | ConvertFrom-Json
    if ($watcherState.watcherPid) { Stop-Process -Id ([int]$watcherState.watcherPid) -Force -ErrorAction SilentlyContinue }
  } catch {}
  Remove-Item -LiteralPath $WatcherStatePath -Force -ErrorAction SilentlyContinue
}

if (Test-Path -LiteralPath $StatePath) {
  try {
    $state = Get-Content -LiteralPath $StatePath -Raw | ConvertFrom-Json
    if ($state.injectorPid) { Stop-Process -Id ([int]$state.injectorPid) -Force -ErrorAction SilentlyContinue }
  } catch {}
  Remove-Item -LiteralPath $StatePath -Force -ErrorAction SilentlyContinue
}
Start-Sleep -Milliseconds 250
try { & $node $injector --remove --port $Port --timeout-ms 3000 } catch {}

if ($Uninstall) {
  $desktop = [Environment]::GetFolderPath('Desktop')
  $startMenu = Join-Path $env:APPDATA 'Microsoft\Windows\Start Menu\Programs'
  $desktopStart = Join-Path $desktop 'Meteor Skin.lnk'
  $desktopRestore = Join-Path $desktop 'Meteor Skin - Restore.lnk'
  $menuStart = Join-Path $startMenu 'Meteor Skin.lnk'
  $startupWatcher = Join-Path ([Environment]::GetFolderPath('Startup')) 'Meteor Skin Watcher.lnk'
  $legacyDesktopStart = Join-Path $desktop 'Codex Dream Skin.lnk'
  $legacyDesktopRestore = Join-Path $desktop 'Codex Dream Skin - Restore.lnk'
  $legacyMenuStart = Join-Path $startMenu 'Codex Dream Skin.lnk'
  $legacyStartupWatcher = Join-Path ([Environment]::GetFolderPath('Startup')) 'Codex Dream Skin Watcher.lnk'
  Remove-Item -LiteralPath $desktopStart -Force -ErrorAction SilentlyContinue
  Remove-Item -LiteralPath $desktopRestore -Force -ErrorAction SilentlyContinue
  Remove-Item -LiteralPath $menuStart -Force -ErrorAction SilentlyContinue
  Remove-Item -LiteralPath $startupWatcher -Force -ErrorAction SilentlyContinue
  Remove-Item -LiteralPath $legacyDesktopStart -Force -ErrorAction SilentlyContinue
  Remove-Item -LiteralPath $legacyDesktopRestore -Force -ErrorAction SilentlyContinue
  Remove-Item -LiteralPath $legacyMenuStart -Force -ErrorAction SilentlyContinue
  Remove-Item -LiteralPath $legacyStartupWatcher -Force -ErrorAction SilentlyContinue
}

if ($RestoreBaseTheme) {
  $backup = Join-Path $StateRoot 'config.before-dream-skin.toml'
  $config = Join-Path $HOME '.codex\config.toml'
  if (Test-Path -LiteralPath $backup) {
    & $node (Join-Path $PSScriptRoot 'configure-base-theme.mjs') --config $config --backup $backup --restore | Out-Null
  } else {
    Write-Host 'No pre-install appearance backup was found; there is nothing to restore.'
  }
}

Write-Host 'The live Dream Skin was removed.'
