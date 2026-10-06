<#
.SYNOPSIS
  Check the client package and start the legacy PokeNation client (PokeNationLegacyClient.exe).
  The client connects to the development server on 127.0.0.1:7564. -Force starts it even when
  no server is running.
#>
param([switch]$Force)

Set-StrictMode -Version 2
$ErrorActionPreference = 'Stop'
function Fail([string]$Message, [string]$Hint) {
    Write-Host "[FAIL] $Message" -ForegroundColor Red
    if ($Hint) { Write-Host "       $Hint" }
    exit 1
}
Set-Location $PSScriptRoot
$exe = Join-Path $PSScriptRoot 'PokeNationLegacyClient.exe'

if (-not (Test-Path 'init.lua') -or -not (Test-Path 'modules')) {
    Fail "this folder ($PSScriptRoot) is not a PokeNation client package" 'Extract the whole PokeNation-LegacyClient-Windows zip and start the script from the "client" folder.'
}
if (-not (Test-Path $exe)) { Fail 'PokeNationLegacyClient.exe is missing' 'Download the client package again.' }
$spr = Get-Item 'data\things\data.spr' -ErrorAction SilentlyContinue
if (-not $spr -or $spr.Length -lt 1MB) { Fail 'data\things\data.spr is missing or incomplete' 'The package is broken; download it again.' }
Write-Host '[ OK ] client files present' -ForegroundColor Green

$server = New-Object System.Net.Sockets.TcpClient
$up = $false
try { $a = $server.BeginConnect('127.0.0.1', 7564, $null, $null); $up = $a.AsyncWaitHandle.WaitOne(1000) -and $server.Connected } catch { } finally { $server.Close() }
if (-not $up) {
    if (-not $Force) { Fail 'no server is listening on 127.0.0.1:7564' 'Start the server first (Start-PokeNation-Server.bat) and wait for ">> Cristal server Online!".' }
    Write-Host '[WARN] no server on 127.0.0.1:7564 - starting anyway (-Force)' -ForegroundColor Yellow
} else {
    Write-Host '[ OK ] server is listening on 127.0.0.1:7564' -ForegroundColor Green
}

$proc = Start-Process -FilePath $exe -WorkingDirectory $PSScriptRoot -PassThru
Start-Sleep -Seconds 5
if ($proc.HasExited) {
    # client/init.lua: g_logger.setLogFile(g_resources.getUserDir() .. "psoul.log") = the user profile folder
    $log = Join-Path $env:USERPROFILE 'psoul.log'
    Write-Host "[FAIL] the client closed immediately (exit code $($proc.ExitCode))" -ForegroundColor Red
    Write-Host '       Common causes: graphics driver without OpenGL 2.0, or files missing from the package.'
    if (Test-Path $log) { Write-Host "       Last lines of $log :"; Get-Content $log -Tail 15 | ForEach-Object { Write-Host "       $_" } }
    exit 1
}
Write-Host "[ OK ] client started (PID $($proc.Id)). Log in with player / player (see README.txt)." -ForegroundColor Green
exit 0
