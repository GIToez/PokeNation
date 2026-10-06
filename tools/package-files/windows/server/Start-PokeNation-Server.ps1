<#
.SYNOPSIS
  Check every prerequisite, then start the PokeNation development server (PokeNationServer.exe).

.DESCRIPTION
  Reports clearly when: the folder is wrong or incomplete, the executable is missing, config.lua is
  missing, MariaDB is not running, the database is missing or not initialised, or the login/game
  ports are already in use. Use -CheckOnly to run the checks without starting the server.
#>
param([switch]$CheckOnly)

. (Join-Path $PSScriptRoot 'PokeNation-Common.ps1')
Set-Location $PSScriptRoot
$exe = Join-Path $PSScriptRoot 'PokeNationServer.exe'

if (-not (Test-Path 'data\XML') -or -not (Test-Path 'config.example.lua')) {
    Stop-WithProblem "this folder ($PSScriptRoot) is not a PokeNation server package" @('Extract the whole PokeNation-Server-Windows zip and start the script from the "server" folder.')
}
if (-not (Test-Path $exe)) {
    Stop-WithProblem 'PokeNationServer.exe is missing' @('Download the server package again (GitHub Actions artifact "PokeNation-Server-Windows").')
}
$map = Get-Item 'data\world\map.otbm' -ErrorAction SilentlyContinue
if (-not $map -or $map.Length -lt 1MB) {
    Stop-WithProblem 'data\world\map.otbm is missing or incomplete' @('The package is broken; download it again.')
}
Write-Ok 'package files present'

if (-not (Test-Path 'config.lua')) {
    Stop-WithProblem 'config.lua is missing' @('Run Setup-PokeNation-Database.bat once; it creates the database and config.lua.')
}
$cfg = Read-LuaConfig (Join-Path $PSScriptRoot 'config.lua')
$dbHost = Get-ConfigValue $cfg 'sqlHost' '127.0.0.1'
$dbPort = Get-ConfigValue $cfg 'sqlPort' 3306
$dbUser = Get-ConfigValue $cfg 'sqlUser' 'psoul'
$dbPass = Get-ConfigValue $cfg 'sqlPass' ''
$dbName = Get-ConfigValue $cfg 'sqlDatabase' 'psoul'
$loginPort = Get-ConfigValue $cfg 'loginPort' 7564
$gamePort = Get-ConfigValue $cfg 'gamePort' 8548
Write-Ok "config.lua: database '$dbName' on ${dbHost}:$dbPort, ports $loginPort/$gamePort"

if (-not (Test-TcpPort $dbHost $dbPort)) {
    Stop-WithProblem "MariaDB is not running on ${dbHost}:$dbPort" @(
        'Start the "MariaDB" service (Windows "Services" app, or Start-MariaDB.bat as administrator).')
}
Write-Ok 'MariaDB is running'

$mysql = Find-MySqlClient
if ($mysql) {
    try {
        $count = Invoke-MySql -MySql $mysql -HostName $dbHost -Port $dbPort -User $dbUser -Password $dbPass -Database $dbName -Sql 'SELECT COUNT(*) FROM accounts' -Scalar
        Write-Ok "database '$dbName' is initialised ($count accounts)"
    } catch {
        Stop-WithProblem "database '$dbName' is missing or cannot be read as '$dbUser'" @($_.Exception.Message, 'Run Setup-PokeNation-Database.bat (add -Reset in PowerShell to start over).')
    }
} else {
    Write-Warn 'mysql.exe not found - skipping the database content check'
}

foreach ($port in $loginPort, $gamePort) {
    if (Test-TcpPort '127.0.0.1' $port 500) {
        Stop-WithProblem "port $port is already in use by $(Get-PortOwner $port)" @('Is another PokeNation server already running? Close it first.')
    }
}
Write-Ok "ports $loginPort (login) and $gamePort (game) are free"

if ($CheckOnly) { Write-Ok 'all checks passed (-CheckOnly: server not started)'; exit 0 }

Write-Host ''
Write-Host "Starting PokeNationServer.exe. Wait for '>> Cristal server Online!' (about 15-30 seconds),"
Write-Host 'then start the client. Close this window (or type /shutdown in game as GM) to stop the server.'
Write-Host ''
& $exe @args
$code = $LASTEXITCODE
if ($code -ne 0) {
    Write-Problem "PokeNationServer.exe stopped with exit code $code"
    Write-Hint 'Read the lines above for the reason; logs are in the logs\ folder.'
}
exit $code
