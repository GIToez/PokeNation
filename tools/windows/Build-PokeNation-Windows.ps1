<#
.SYNOPSIS
  Build and package the PokeNation server and/or legacy client on Windows from source.

.DESCRIPTION
  Runs the same bash build scripts CI uses (tools/build_*.sh, tools/package.sh) inside an
  MSYS2 MINGW64 shell. Output:
    build\windows-<type>\{server,client}\        compiler output (ignored by git)
    dist\windows\{server,client}\                ready-to-run folders
    dist\PokeNation-*-Windows-<Dev|Release>.zip   archives + .sha256 (unless -NoArchive)
  Debug builds are packaged to dist\debug\windows\.

.EXAMPLE
  powershell -ExecutionPolicy Bypass -File tools\windows\Build-PokeNation-Windows.ps1 -InstallDependencies
#>
[CmdletBinding()]
param(
  [string]$MsysRoot = "C:\msys64",
  [switch]$InstallDependencies,
  [ValidateSet("development", "release", "debug")][string]$BuildType = "development",
  [ValidateSet("all", "server", "client")][string]$Component = "all",
  [switch]$Clean,
  [switch]$NoArchive
)
$ErrorActionPreference = "Stop"

function Fail([string]$msg) {
  Write-Host "[PROBLEM] $msg" -ForegroundColor Red
  exit 1
}

$repo = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
if (-not (Test-Path (Join-Path $repo "server\CMakeLists.txt"))) { Fail "Cannot find server\CMakeLists.txt under $repo - run this script from a PokeNation checkout." }

$bash = Join-Path $MsysRoot "usr\bin\bash.exe"
if (-not (Test-Path $bash)) {
  Fail "MSYS2 not found at $MsysRoot. Install it from https://www.msys2.org/ (default C:\msys64) or pass -MsysRoot <path>."
}

foreach ($f in @("server\data\world\map.otbm", "client\data\things\data.spr")) {
  $p = Join-Path $repo $f
  if (-not (Test-Path $p) -or (Get-Item $p).Length -lt 1000000) {
    Fail "$f is missing or a Git LFS pointer. Run: git lfs install; git lfs pull"
  }
}

$env:MSYSTEM = "MINGW64"
$env:CHERE_INVOKING = "1"
$env:BUILD_TYPE = $BuildType

function Invoke-Bash([string]$cmd) {
  Write-Host "==> $cmd" -ForegroundColor Cyan
  Push-Location $repo
  try {
    & $bash -lc $cmd
    $code = $LASTEXITCODE
  } finally { Pop-Location }
  if ($code -ne 0) { Fail "Step failed (exit code $code): $cmd" }
}

if ($InstallDependencies) {
  # Same list as .github/workflows/build.yml (windows job).
  $pkgs = @(
    "git", "zip", "mingw-w64-x86_64-gcc", "mingw-w64-x86_64-cmake", "mingw-w64-x86_64-ninja",
    "mingw-w64-x86_64-pkgconf", "mingw-w64-x86_64-boost", "mingw-w64-x86_64-lua51",
    "mingw-w64-x86_64-libxml2", "mingw-w64-x86_64-gmp", "mingw-w64-x86_64-libmariadbclient",
    "mingw-w64-x86_64-sqlite3", "mingw-w64-x86_64-openssl", "mingw-w64-x86_64-zlib",
    "mingw-w64-x86_64-physfs", "mingw-w64-x86_64-openal", "mingw-w64-x86_64-glew",
    "mingw-w64-x86_64-libvorbis", "mingw-w64-x86_64-libogg"
  )
  Invoke-Bash ("pacman -S --needed --noconfirm " + ($pkgs -join " "))
}

$cleanArg = ""
if ($Clean) { $cleanArg = " --clean" }
if ($Component -in @("all", "server")) { Invoke-Bash "tools/build_server.sh$cleanArg" }
if ($Component -in @("all", "client")) { Invoke-Bash "tools/build_client.sh$cleanArg" }

$archiveArg = ""
if ($NoArchive) { $archiveArg = " --no-archive" }
Invoke-Bash "tools/package.sh $Component$archiveArg"

Write-Host "[OK] Build finished. Packages are in $repo\dist" -ForegroundColor Green
