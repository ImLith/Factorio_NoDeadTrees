<#
Usage:
  .\build_mod.ps1              # bump the last version part and create a build in dist/
  .\build_mod.ps1 -minor       # bump the middle version part and create a build in dist/
  .\build_mod.ps1 -major       # bump the first version part and create a build in dist/
#>

param(
  [Parameter()]
  [Alias('release')]
  [switch]$Minor,

  [Parameter()]
  [switch]$Major
)

if ($args -contains '--minor' -or $args -contains '--release' -or $args -contains '-minor' -or $args -contains '-release') {
  $Minor = $true
}

if ($args -contains '--major' -or $args -contains '-major') {
  $Major = $true
}

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$modRoot = Join-Path $root "mod"
$infoPath = Join-Path $modRoot "info.json"
$distRoot = Join-Path $root "dist"

if (-not (Test-Path $infoPath)) {
  throw "info.json was not found at $infoPath"
}

if (-not (Test-Path $distRoot)) {
  New-Item -ItemType Directory -Path $distRoot -Force | Out-Null
}

$info = Get-Content -Path $infoPath -Raw | ConvertFrom-Json
$modName = $info.name
$versionText = [string]$info.version
$versionParts = $versionText -split '\.'
$numbers = @()

foreach ($part in $versionParts) {
  if ($part -notmatch '^\d+$') {
    throw "Version '$versionText' is not numeric"
  }

  $numbers += [int]$part
}

if ($Major) {
  $numbers[0] = $numbers[0] + 1

  for ($i = 1; $i -lt $numbers.Length; $i++) {
    $numbers[$i] = 0
  }
}
elseif ($Minor) {
  if ($numbers.Length -lt 2) {
    $numbers += 0
  }

  $numbers[1] = $numbers[1] + 1

  if ($numbers.Length -gt 2) {
    for ($i = 2; $i -lt $numbers.Length; $i++) {
      $numbers[$i] = 0
    }
  }
}
else {
  $numbers[$numbers.Length - 1] = $numbers[$numbers.Length - 1] + 1
}

$newVersion = ($numbers -join '.')

$info.version = $newVersion
$info | ConvertTo-Json -Depth 10 | Set-Content -Path $infoPath -Encoding UTF8


$archiveName = "${modName}_$newVersion.zip"
$archivePath = Join-Path $distRoot $archiveName

$packageRootName = "${modName}_$newVersion"
$packageRoot = Join-Path $distRoot $packageRootName


if (Test-Path $packageRoot) {
  Remove-Item $packageRoot -Recurse -Force
}

if (Test-Path $archivePath) {
  Remove-Item $archivePath -Force
}


New-Item -ItemType Directory -Path $packageRoot -Force | Out-Null

Copy-Item `
  -Path (Join-Path $modRoot '*') `
  -Destination $packageRoot `
  -Recurse `
  -Force


#
# Create ZIP using 7-Zip
# Required because Compress-Archive creates Windows-style paths
#

$sevenZipCandidates = @(
    "${env:ProgramFiles}\7-Zip\7z.exe",
    "${env:ProgramFiles(x86)}\7-Zip\7z.exe"
)

$sevenZip = $sevenZipCandidates |
    Where-Object { Test-Path $_ } |
    Select-Object -First 1

if (-not $sevenZip) {
    throw "7-Zip was not found. Install 7-Zip."
}


Push-Location $distRoot

& $sevenZip a `
  -tzip `
  $archivePath `
  $packageRootName | Out-Null

Pop-Location


Remove-Item $packageRoot -Recurse -Force


Write-Host "Created $archivePath"
Write-Host "Updated version to $newVersion"