<#
.SYNOPSIS
  Start the development server in its own window, wait until it is online, then start the client.
  Expects both packages extracted into the same folder:  PokeNation\server  and  PokeNation\client.
#>
. (Join-Path $PSScriptRoot 'PokeNation-Common.ps1')
$clientScript = Join-Path $PSScriptRoot '..\client\Start-PokeNation-Client.ps1'
if (-not (Test-Path $clientScript)) {
    Stop-WithProblem 'the client package was not found next to the server package' @(
        'Extract PokeNation-LegacyClient-Windows-*.zip into the same folder as the server zip,',
        'so that you have PokeNation\server and PokeNation\client.')
}

$serverScript = Join-Path $PSScriptRoot 'Start-PokeNation-Server.ps1'
& powershell -NoProfile -ExecutionPolicy Bypass -File $serverScript -CheckOnly
if ($LASTEXITCODE -ne 0) { Stop-WithProblem 'server prerequisites are not met (see above)' }

Write-Host 'Opening the server in a new window...'
Start-Process powershell -WorkingDirectory $PSScriptRoot -ArgumentList '-NoProfile', '-ExecutionPolicy', 'Bypass', '-NoExit', '-File', "`"$serverScript`""

$cfg = Read-LuaConfig (Join-Path $PSScriptRoot 'config.lua')
$loginPort = Get-ConfigValue $cfg 'loginPort' 7564
$deadline = (Get-Date).AddSeconds(180)
while (-not (Test-TcpPort '127.0.0.1' $loginPort 500)) {
    if ((Get-Date) -gt $deadline) { Stop-WithProblem "the server did not open port $loginPort within 3 minutes" @('Look at the server window for the error.') }
    Start-Sleep -Seconds 2
}
# The login port opens a moment before the game world is fully ready.
Start-Sleep -Seconds 3
Write-Ok "server is online on port $loginPort"

& powershell -NoProfile -ExecutionPolicy Bypass -File (Resolve-Path $clientScript).Path
exit $LASTEXITCODE
