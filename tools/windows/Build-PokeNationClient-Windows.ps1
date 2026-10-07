<#
.SYNOPSIS
  Build the PokeNation client (OTClient Redemption 4.1 based, client-pokenation\) for Windows x64 with MSVC.

.DESCRIPTION
  Uses Visual Studio's C++ toolset (2022 or 2026), Ninja and vcpkg in manifest mode with the
  static triplet x64-windows-static-release from client-pokenation\cmake\triplets.
  Output: build\client-pokenation\windows-<type>\bin\otclient.exe (renamed when packaged).
  The legacy client is built by Build-PokeNation-Windows.ps1 (MSYS2); the two never share files.

.PARAMETER BuildType
  development (RelWithDebInfo, default), release (Release) or debug (Debug).

.EXAMPLE
  powershell -ExecutionPolicy Bypass -File tools\windows\Build-PokeNationClient-Windows.ps1
#>
param(
    [ValidateSet('development', 'release', 'debug')]
    [string]$BuildType = 'development',
    [switch]$Clean
)
$ErrorActionPreference = 'Stop'

$Root = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
$Src = Join-Path $Root 'client-pokenation'
$Out = Join-Path $Root "build\client-pokenation\windows-$BuildType"
$CMakeBuildType = @{ development = 'RelWithDebInfo'; release = 'Release'; debug = 'Debug' }[$BuildType]

function Fail([string]$Message) { Write-Host "[FAIL] $Message" -ForegroundColor Red; exit 1 }
function Step([string]$Message) { Write-Host "==> $Message" -ForegroundColor Cyan }

# MSVC environment: reuse the current Developer shell, otherwise import VsDevCmd's variables.
if (-not (Get-Command cl.exe -ErrorAction SilentlyContinue)) {
    $vswhere = Join-Path ${env:ProgramFiles(x86)} 'Microsoft Visual Studio\Installer\vswhere.exe'
    if (-not (Test-Path $vswhere)) { Fail 'Visual Studio with "Desktop development with C++" is required (vswhere.exe not found)' }
    $vs = & $vswhere -latest -prerelease -products '*' -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath
    if (-not $vs) { Fail 'no Visual Studio installation with the x64 C++ toolset was found' }
    $devCmd = Join-Path $vs 'Common7\Tools\VsDevCmd.bat'
    Step "Importing the MSVC environment from $devCmd"
    $envLines = & cmd.exe /s /c "`"$devCmd`" -arch=x64 -host_arch=x64 -no_logo && set"
    foreach ($line in $envLines) {
        if ($line -match '^([^=]+)=(.*)$') { [Environment]::SetEnvironmentVariable($Matches[1], $Matches[2]) }
    }
    if (-not (Get-Command cl.exe -ErrorAction SilentlyContinue)) { Fail 'cl.exe still not found after VsDevCmd' }
}
foreach ($tool in 'cmake', 'ninja', 'git') {
    if (-not (Get-Command $tool -ErrorAction SilentlyContinue)) { Fail "$tool is not on PATH (Visual Studio ships cmake and ninja; install Git for Windows)" }
}

$baseline = (Get-Content (Join-Path $Src 'vcpkg.json') -Raw | ConvertFrom-Json).'builtin-baseline'
if (-not $env:VCPKG_ROOT) { $env:VCPKG_ROOT = Join-Path $env:LOCALAPPDATA 'pokenation\vcpkg' }
if (-not (Test-Path (Join-Path $env:VCPKG_ROOT 'vcpkg.exe'))) {
    Step "Bootstrapping vcpkg $baseline into $env:VCPKG_ROOT"
    if (-not (Test-Path (Join-Path $env:VCPKG_ROOT '.git'))) {
        git clone -q https://github.com/microsoft/vcpkg.git $env:VCPKG_ROOT
        if ($LASTEXITCODE -ne 0) { Fail 'cannot clone vcpkg' }
    }
    git -C $env:VCPKG_ROOT fetch -q origin $baseline 2>$null
    git -C $env:VCPKG_ROOT checkout -q $baseline
    if ($LASTEXITCODE -ne 0) { Fail "cannot check out vcpkg baseline $baseline" }
    & (Join-Path $env:VCPKG_ROOT 'bootstrap-vcpkg.bat') -disableMetrics
    if ($LASTEXITCODE -ne 0) { Fail 'vcpkg bootstrap failed' }
}

if ($Clean -and (Test-Path $Out)) { Step "Cleaning $Out"; Remove-Item -Recurse -Force $Out }
New-Item -ItemType Directory -Force -Path $Out | Out-Null

Step "Configuring PokeNation client (windows, $BuildType -> $CMakeBuildType)"
$cmakeArgs = @(
    '-S', $Src, '-B', $Out, '-G', 'Ninja',
    "-DCMAKE_TOOLCHAIN_FILE=$env:VCPKG_ROOT\scripts\buildsystems\vcpkg.cmake",
    '-DVCPKG_TARGET_TRIPLET=x64-windows-static-release', '-DVCPKG_HOST_TRIPLET=x64-windows',
    "-DVCPKG_OVERLAY_TRIPLETS=$Src\cmake\triplets",
    '-DVCPKG_INSTALL_OPTIONS=--clean-packages-after-build;--clean-buildtrees-after-build',
    '-DCMAKE_C_COMPILER=cl.exe', '-DCMAKE_CXX_COMPILER=cl.exe',
    "-DCMAKE_BUILD_TYPE=$CMakeBuildType", '-DBUILD_STATIC_LIBRARY=ON',
    '-DOTCLIENT_BUILD_TESTS=OFF', '-DOPTIONS_ENABLE_IPO=OFF', '-DTOGGLE_BIN_FOLDER=ON', '-Wno-dev'
) + $args
& cmake @cmakeArgs
if ($LASTEXITCODE -ne 0) { Fail "CMake configure failed (vcpkg log: $Out\vcpkg-manifest-install.log)" }

Step 'Compiling PokeNation client'
& cmake --build $Out --parallel
if ($LASTEXITCODE -ne 0) { Fail 'PokeNation client compilation failed' }

$exe = Get-ChildItem (Join-Path $Out 'bin') -Filter '*.exe' -ErrorAction SilentlyContinue |
    Where-Object { $_.Name -in 'PokeNationClient.exe', 'otclient.exe', 'OTClient.exe' } | Select-Object -First 1
if (-not $exe) { Fail "build finished but no client executable in $Out\bin" }
Write-Host "[ OK ] PokeNation client: $($exe.FullName)" -ForegroundColor Green
