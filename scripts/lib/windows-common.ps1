Set-StrictMode -Version 2.0

function Get-DreamCodexPackage {
  $package = Get-AppxPackage OpenAI.Codex -ErrorAction SilentlyContinue |
    Sort-Object Version -Descending |
    Select-Object -First 1
  if (-not $package) { throw 'The Microsoft Store OpenAI Codex package is not installed.' }
  return $package
}

function Get-DreamNodePath {
  $candidates = New-Object System.Collections.Generic.List[string]
  $systemNode = Get-Command node.exe -ErrorAction SilentlyContinue
  if ($systemNode) { $candidates.Add($systemNode.Source) }
  try {
    $package = Get-DreamCodexPackage
    foreach ($relative in @(
      'app\resources\cua_node\bin\node.exe',
      'app\Resources\cua_node\bin\node.exe',
      'app\node.exe'
    )) {
      $candidates.Add((Join-Path $package.InstallLocation $relative))
    }
  } catch {}
  foreach ($candidate in $candidates) {
    if (-not (Test-Path -LiteralPath $candidate)) { continue }
    try {
      $major = [int](& $candidate -p 'Number(process.versions.node.split(".")[0])')
      if ($major -ge 20) { return $candidate }
    } catch {}
  }
  throw 'Node.js 20 or newer was not found. Update Codex or install a current Node.js LTS release.'
}

function Test-DreamDebugPort([int]$Port) {
  foreach ($loopback in @('127.0.0.1', '[::1]')) {
    try {
      $targets = Invoke-RestMethod "http://$($loopback):$Port/json/list" -TimeoutSec 2
      if ($targets | Where-Object { $_.type -eq 'page' -and $_.url -like 'app://-/index.html*' }) { return $true }
    } catch {}
  }
  return $false
}
