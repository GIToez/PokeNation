<#
.SYNOPSIS
  One-time setup of the PokeNation DEVELOPMENT database on Windows (MariaDB).

.DESCRIPTION
  1. finds the MariaDB client (mariadb.exe/mysql.exe; MariaDB's own is preferred) and checks that MariaDB is running
  2. creates database "psoul" and user "psoul" (password "psoul-dev" by default)
  3. imports database\mysql.sql, database\psoul_extra_mysql.sql, database\psoul_dev_seed.sql
     (skipped when the tables already exist, unless -Reset)
  4. creates config.lua from config.example.lua if it does not exist yet

  Development accounts created by the seed: admin/admin (GM Admin, Tester), player/player (Trainer).
  These passwords are for local testing only - never use them on a public server.

.EXAMPLE
  .\Setup-PokeNation-Database.ps1                     (asks for the MariaDB root password)
.EXAMPLE
  .\Setup-PokeNation-Database.ps1 -Reset              (drop the database and start from the seed again)
#>
param(
    [string]$RootUser = 'root',
    [string]$RootPassword,
    [string]$DbHost = '127.0.0.1',
    [int]$DbPort = 3306,
    [string]$DbName = 'psoul',
    [string]$DbUser = 'psoul',
    [string]$DbPassword = 'psoul-dev',
    [switch]$Reset,
    [switch]$NonInteractive
)

. (Join-Path $PSScriptRoot 'PokeNation-Common.ps1')
Set-Location $PSScriptRoot

Write-Host "PokeNation development database setup (folder: $PSScriptRoot)"
foreach ($f in 'database\mysql.sql', 'database\psoul_extra_mysql.sql', 'database\psoul_dev_seed.sql', 'config.example.lua') {
    if (-not (Test-Path $f)) {
        Stop-WithProblem "$f is missing" @('Run this script from the extracted server package folder (the one containing PokeNationServer.exe).')
    }
}

$mysql = Find-MySqlClient
if (-not $mysql) {
    Stop-WithProblem 'the MariaDB client (mariadb.exe / mysql.exe) was not found' @(
        'Install MariaDB from https://mariadb.org/download/ (keep "Install as service" enabled),',
        'or add its "bin" folder (e.g. C:\Program Files\MariaDB 11.4\bin) to PATH, then run this again.')
}
Write-Ok "MariaDB client: $mysql"

if (-not (Test-TcpPort $DbHost $DbPort)) {
    Write-Warn "MariaDB is not answering on ${DbHost}:$DbPort - trying to start the service"
    foreach ($svc in Get-Service -Name 'MariaDB*', 'MySQL*' -ErrorAction SilentlyContinue) {
        try { Start-Service $svc.Name; Write-Ok "started service $($svc.Name)" } catch { Write-Warn "could not start $($svc.Name): $($_.Exception.Message)" }
    }
    Start-Sleep -Seconds 3
    if (-not (Test-TcpPort $DbHost $DbPort)) {
        Stop-WithProblem "MariaDB is not running on ${DbHost}:$DbPort" @(
            'Start it from the Windows "Services" app (service name "MariaDB"),',
            'or run Start-MariaDB.bat as administrator, then run this again.')
    }
}
Write-Ok "MariaDB is running on ${DbHost}:$DbPort"

if (-not $PSBoundParameters.ContainsKey('RootPassword')) {
    if ($NonInteractive) { $RootPassword = '' }
    else {
        $secure = Read-Host "MariaDB '$RootUser' password (the one chosen while installing MariaDB; Enter if none)" -AsSecureString
        $RootPassword = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure))
    }
}

function Admin([string]$Sql) { Invoke-MySql -MySql $mysql -HostName $DbHost -Port $DbPort -User $RootUser -Password $RootPassword -Sql $Sql }
function App([string]$Sql, [switch]$Scalar) { Invoke-MySql -MySql $mysql -HostName $DbHost -Port $DbPort -User $DbUser -Password $DbPassword -Database $DbName -Sql $Sql -Scalar:$Scalar }

try { Admin 'SELECT 1' | Out-Null } catch {
    Stop-WithProblem "cannot log in to MariaDB as '$RootUser'" @($_.Exception.Message, 'Check the root password you chose during the MariaDB installation.')
}
Write-Ok "logged in as '$RootUser'"
if ($script:MySqlLastStderr) { Write-Hint "client message (not an error): $($script:MySqlLastStderr -replace '\s*\r?\n\s*', ' | ')" }

if ($Reset) {
    Write-Warn "-Reset: dropping database '$DbName' (all characters and progress are lost)"
    Admin "DROP DATABASE IF EXISTS ``$DbName``;" | Out-Null
}

# The server connects over TCP to 127.0.0.1; 'localhost' covers the named-pipe/socket case.
$create = @"
CREATE DATABASE IF NOT EXISTS ``$DbName`` CHARACTER SET utf8mb4;
CREATE USER IF NOT EXISTS '$DbUser'@'localhost' IDENTIFIED BY '$DbPassword';
CREATE USER IF NOT EXISTS '$DbUser'@'127.0.0.1' IDENTIFIED BY '$DbPassword';
ALTER USER '$DbUser'@'localhost' IDENTIFIED BY '$DbPassword';
ALTER USER '$DbUser'@'127.0.0.1' IDENTIFIED BY '$DbPassword';
GRANT ALL PRIVILEGES ON ``$DbName``.* TO '$DbUser'@'localhost';
GRANT ALL PRIVILEGES ON ``$DbName``.* TO '$DbUser'@'127.0.0.1';
FLUSH PRIVILEGES;
"@
try { Admin $create | Out-Null } catch { Stop-WithProblem 'creating the database/user failed' @($_.Exception.Message) }
Write-Ok "database '$DbName' and user '$DbUser' ready"

try { $haveAccounts = App "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='$DbName' AND table_name='accounts'" -Scalar }
catch { Stop-WithProblem "cannot read database '$DbName' as '$DbUser'" @($_.Exception.Message) }
if ($haveAccounts -notmatch '^\d+$') {
    Stop-WithProblem "unexpected answer from mysql while checking for the 'accounts' table: '$haveAccounts'" @('Run again with -Reset to start from an empty database.')
}
if ($haveAccounts -eq '0') {
    foreach ($file in 'mysql.sql', 'psoul_extra_mysql.sql', 'psoul_dev_seed.sql') {
        $path = (Resolve-Path (Join-Path 'database' $file)).Path
        Write-Host "       importing database\$file ..."
        # mysql.sql creates triggers, which needs the administrative account.
        try { Invoke-MySql -MySql $mysql -HostName $DbHost -Port $DbPort -User $RootUser -Password $RootPassword -Database $DbName -InputFile $path | Out-Null }
        catch { Stop-WithProblem "importing database\$file failed" @($_.Exception.Message, 'Run again with -Reset to start from an empty database.') }
    }
    Write-Ok 'schema and development accounts imported'
} else {
    Write-Ok 'tables already exist - import skipped (use -Reset to start over)'
}
try {
    $tables = App "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='$DbName'" -Scalar
    $accounts = App 'SELECT GROUP_CONCAT(name ORDER BY id) FROM accounts' -Scalar
} catch { Stop-WithProblem "the database '$DbName' is incomplete" @($_.Exception.Message, 'Run again with -Reset to start from an empty database.') }
Write-Ok "$tables tables; accounts: $accounts"

if (-not (Test-Path 'config.lua')) {
    $text = [IO.File]::ReadAllText((Join-Path $PSScriptRoot 'config.example.lua'))
    $set = @{ sqlHost = "`"$DbHost`""; sqlPort = "$DbPort"; sqlUser = "`"$DbUser`""; sqlPass = "`"$DbPassword`""; sqlDatabase = "`"$DbName`"" }
    foreach ($key in $set.Keys) {
        $text = [regex]::Replace($text, "(?m)^(\s*$key\s*=\s*)(`"[^`"]*`"|\d+)", { param($m) $m.Groups[1].Value + $set[$key] }.GetNewClosure())
    }
    Write-Utf8NoBom (Join-Path $PSScriptRoot 'config.lua') $text
    Write-Ok 'config.lua created from config.example.lua'
} else {
    Write-Ok 'config.lua already exists - not changed'
}

Write-Host ''
Write-Host 'Development accounts (local testing only):'
Write-Host '  admin  / admin   -> GM Admin (game master), Tester (normal player)'
Write-Host '  player / player  -> Trainer (normal new player)'
Write-Host 'Next: double-click Start-PokeNation-Server.bat'
exit 0
