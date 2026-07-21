[CmdletBinding()]
param(
  [int]$Port = 9335,
  [string]$Theme,
  [ValidateSet('banner', 'fullscreen')][string]$Layout = 'fullscreen',
  [switch]$RestartExisting
)

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'lib\windows-common.ps1')
$node = Get-DreamNodePath
$start = Join-Path $PSScriptRoot 'start-dream-skin.ps1'
$injector = Join-Path $PSScriptRoot 'injector.mjs'
$setTheme = Join-Path $PSScriptRoot 'set-theme.mjs'

Write-Host '[1/4] Checking Codex and AutoSkin status...' -ForegroundColor Cyan
$running = @(Get-Process ChatGPT -ErrorAction SilentlyContinue | Where-Object { $_.MainWindowHandle -ne 0 })
if (-not (Test-DreamDebugPort $Port) -and $running.Count -gt 0 -and -not $RestartExisting) {
  $answer = Read-Host 'Codex is open without AutoSkin. Restart Codex now? [y/N]'
  if ($answer -notmatch '^(y|yes)$') {
    throw 'Activation cancelled; Codex was left open and unchanged.'
  }
  $RestartExisting = $true
}

Write-Host '[2/4] Starting or hot-reloading AutoSkin...' -ForegroundColor Cyan
$startArgs = @{ Port = $Port }
if ($RestartExisting) { $startArgs.RestartExisting = $true }
& $start @startArgs

if ($Theme) {
  Write-Host "[3/4] Applying theme '$Theme' ($Layout)..." -ForegroundColor Cyan
  & $node $setTheme --port $Port $Theme $Layout | Out-Null
} else {
  Write-Host '[3/4] Keeping the saved theme and layout...' -ForegroundColor Cyan
}

Write-Host '[4/4] Verifying the live skin...' -ForegroundColor Cyan
& $node $injector --verify --port $Port --timeout-ms 12000 | Out-Null
if ($LASTEXITCODE -ne 0) { throw 'AutoSkin verification failed. Check the injector logs in LOCALAPPDATA\CodexDreamSkin.' }
Write-Host "Codex AutoSkin is active on port $Port." -ForegroundColor Green
