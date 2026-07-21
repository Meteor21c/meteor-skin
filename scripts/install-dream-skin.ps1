[CmdletBinding()]
param(
  [int]$Port = 9335,
  [switch]$NoShortcuts,
  [switch]$NoAutoRecover
)

$ErrorActionPreference = 'Stop'
$SourceRoot = Split-Path -Parent $PSScriptRoot
$StateRoot = Join-Path $env:LOCALAPPDATA 'CodexDreamSkin'
New-Item -ItemType Directory -Force -Path $StateRoot | Out-Null
$RuntimeRoot = Join-Path $StateRoot 'runtime'
$PrivateThemesRoot = Join-Path $StateRoot 'themes-private'
New-Item -ItemType Directory -Force -Path $PrivateThemesRoot | Out-Null

$statePath = Join-Path $StateRoot 'state.json'
if (Test-Path -LiteralPath $statePath) {
  try {
    $state = Get-Content -LiteralPath $statePath -Raw | ConvertFrom-Json
    if ($state.injectorPid) { Stop-Process -Id ([int]$state.injectorPid) -Force -ErrorAction SilentlyContinue }
  } catch {}
  Remove-Item -LiteralPath $statePath -Force -ErrorAction SilentlyContinue
}

if (Test-Path -LiteralPath $RuntimeRoot) {
  $stamp = (Get-Date).ToUniversalTime().ToString('yyyyMMddTHHmmssZ')
  $runtimeArchive = Join-Path $StateRoot "runtime.backup-$stamp-$PID"
  Move-Item -LiteralPath $RuntimeRoot -Destination $runtimeArchive
  Write-Host "Previous runtime archived for recovery: $runtimeArchive"
}
New-Item -ItemType Directory -Force -Path $RuntimeRoot | Out-Null
foreach ($entry in @('scripts', 'assets', 'styles', 'themes')) {
  Copy-Item -LiteralPath (Join-Path $SourceRoot $entry) -Destination (Join-Path $RuntimeRoot $entry) -Recurse -Force
}
$sourcePrivate = Join-Path $SourceRoot 'themes-private'
if (Test-Path -LiteralPath $sourcePrivate) {
  Get-ChildItem -LiteralPath $sourcePrivate -Directory | ForEach-Object {
    Copy-Item -LiteralPath $_.FullName -Destination (Join-Path $PrivateThemesRoot $_.Name) -Recurse -Force
  }
}
$runtimePrivate = Join-Path $RuntimeRoot 'themes-private'
try {
  New-Item -ItemType Junction -Path $runtimePrivate -Target $PrivateThemesRoot | Out-Null
} catch {
  New-Item -ItemType Directory -Force -Path $runtimePrivate | Out-Null
  Get-ChildItem -LiteralPath $PrivateThemesRoot -Directory | ForEach-Object {
    Copy-Item -LiteralPath $_.FullName -Destination (Join-Path $runtimePrivate $_.Name) -Recurse -Force
  }
}
$RuntimeScripts = Join-Path $RuntimeRoot 'scripts'
$ConfigPath = Join-Path $HOME '.codex\config.toml'
$BackupPath = Join-Path $StateRoot 'config.before-dream-skin.toml'
if (-not (Test-Path -LiteralPath $ConfigPath)) { throw "Codex config not found: $ConfigPath" }
. (Join-Path $RuntimeScripts 'lib\windows-common.ps1')
$node = Get-DreamNodePath
& $node (Join-Path $RuntimeScripts 'configure-base-theme.mjs') --config $ConfigPath --backup $BackupPath --platform win32 | Out-Null

if (-not $NoShortcuts) {
  $shell = New-Object -ComObject WScript.Shell
  $desktop = [Environment]::GetFolderPath('Desktop')
  $startMenu = Join-Path $env:APPDATA 'Microsoft\Windows\Start Menu\Programs'
  $powershell = (Get-Command powershell.exe).Source
  $startScript = Join-Path $RuntimeScripts 'activate-dream-skin.ps1'
  $restoreScript = Join-Path $RuntimeScripts 'restore-dream-skin.ps1'
  foreach ($folder in @($desktop, $startMenu)) {
    $shortcut = $shell.CreateShortcut((Join-Path $folder 'Codex Dream Skin.lnk'))
    $shortcut.TargetPath = $powershell
    $shortcut.Arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$startScript`" -Port $Port"
    $shortcut.WorkingDirectory = $RuntimeRoot
    $shortcut.Description = 'Launch Codex with the Dream Skin theme engine'
    $shortcut.Save()
  }
  $restore = $shell.CreateShortcut((Join-Path $desktop 'Codex Dream Skin - Restore.lnk'))
  $restore.TargetPath = $powershell
  $restore.Arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$restoreScript`" -Port $Port"
  $restore.WorkingDirectory = $RuntimeRoot
  $restore.Description = 'Remove the live Codex Dream Skin'
  $restore.Save()
}

if (-not $NoAutoRecover) {
  $shell = New-Object -ComObject WScript.Shell
  $powershell = (Get-Command powershell.exe).Source
  $startup = [Environment]::GetFolderPath('Startup')
  $watchScript = Join-Path $RuntimeScripts 'watch-dream-skin.ps1'
  $watcherShortcutPath = Join-Path $startup 'Codex Dream Skin Watcher.lnk'
  $watcherShortcut = $shell.CreateShortcut($watcherShortcutPath)
  $watcherShortcut.TargetPath = $powershell
  $watcherShortcut.Arguments = "-NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$watchScript`" -Port $Port"
  $watcherShortcut.WorkingDirectory = $RuntimeRoot
  $watcherShortcut.Description = 'Keep the Dream Skin injector healthy without restarting Codex'
  $watcherShortcut.Save()

  $watcherStatePath = Join-Path $StateRoot 'watcher-state.json'
  if (Test-Path -LiteralPath $watcherStatePath) {
    try {
      $watcherState = Get-Content -LiteralPath $watcherStatePath -Raw | ConvertFrom-Json
      if ($watcherState.watcherPid) { Stop-Process -Id ([int]$watcherState.watcherPid) -Force -ErrorAction SilentlyContinue }
    } catch {}
    Remove-Item -LiteralPath $watcherStatePath -Force -ErrorAction SilentlyContinue
  }
  Start-Process -FilePath $powershell -WindowStyle Hidden -ArgumentList @(
    '-NoProfile', '-WindowStyle', 'Hidden', '-ExecutionPolicy', 'Bypass',
    '-File', "`"$watchScript`"", '-Port', "$Port"
  )
}

Write-Host "Codex Dream Skin installed to $RuntimeRoot. The watcher repairs the injector but never restarts Codex without consent."
