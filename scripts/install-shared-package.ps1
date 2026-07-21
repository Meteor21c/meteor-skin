[CmdletBinding()]
param([int]$Port = 9335)

$ErrorActionPreference = 'Stop'
$SourceRoot = Split-Path -Parent $PSScriptRoot
$SkillsRoot = Join-Path $HOME '.codex\skills'
$TargetRoot = Join-Path $SkillsRoot 'meteor-skin'
$LegacyRoot = Join-Path $SkillsRoot 'codex-autoskin'
$stamp = (Get-Date).ToUniversalTime().ToString('yyyyMMddTHHmmssZ') + "-$PID"
New-Item -ItemType Directory -Force -Path $SkillsRoot | Out-Null
if (Test-Path -LiteralPath $LegacyRoot) {
  Write-Host "Legacy Skill detected and left untouched: $LegacyRoot" -ForegroundColor Yellow
  Write-Host 'After verifying Meteor Skin, archive or remove the legacy Skill manually to avoid duplicate triggers.' -ForegroundColor Yellow
}

$sourceFull = [IO.Path]::GetFullPath($SourceRoot).TrimEnd('\')
$targetFull = [IO.Path]::GetFullPath($TargetRoot).TrimEnd('\')
if ($sourceFull -ne $targetFull) {
  if (Test-Path -LiteralPath $TargetRoot) {
    $backup = Join-Path $SkillsRoot "meteor-skin.backup-$stamp"
    Move-Item -LiteralPath $TargetRoot -Destination $backup
    Write-Host "Previous Skill archived for recovery: $backup"
  }
  Copy-Item -LiteralPath $SourceRoot -Destination $TargetRoot -Recurse -Force
}

Write-Host "Installed Skill: $TargetRoot" -ForegroundColor Green
& (Join-Path $TargetRoot 'quickstart.ps1') -Port $Port

$runtime = Join-Path $env:LOCALAPPDATA 'CodexDreamSkin\runtime'
$activate = Join-Path $runtime 'scripts\activate-dream-skin.ps1'
if (Test-Path -LiteralPath $activate) {
  & $activate -Port $Port -Layout 'fullscreen'
}
