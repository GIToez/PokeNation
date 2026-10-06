# Shared helpers for the PokeNation Windows development launchers. Dot-sourced, not run directly.
# Works with Windows PowerShell 5.1 (built into Windows 10/11) and PowerShell 7.

Set-StrictMode -Version 2
$ErrorActionPreference = 'Stop'

function Write-Ok([string]$Message)      { Write-Host "[ OK ] $Message" -ForegroundColor Green }
function Write-Warn([string]$Message)    { Write-Host "[WARN] $Message" -ForegroundColor Yellow }
function Write-Problem([string]$Message) { Write-Host "[FAIL] $Message" -ForegroundColor Red }
function Write-Hint([string]$Message)    { Write-Host "       $Message" }

function Stop-WithProblem([string]$Message, [string[]]$Hints = @()) {
    Write-Problem $Message
    foreach ($h in $Hints) { Write-Hint $h }
    exit 1
}

# Locate the MariaDB/MySQL command line client (mysql.exe).
function Find-MySqlClient {
    $cmd = Get-Command mysql.exe -ErrorAction SilentlyContinue
    if ($cmd) { return $cmd.Source }
    $roots = @($env:ProgramFiles, ${env:ProgramFiles(x86)}, 'C:\tools') | Where-Object { $_ }
    foreach ($root in $roots) {
        foreach ($pattern in 'MariaDB*\bin\mysql.exe', 'mariadb*\bin\mysql.exe', 'MySQL\MySQL Server*\bin\mysql.exe') {
            $hit = Get-ChildItem -Path (Join-Path $root $pattern) -ErrorAction SilentlyContinue | Sort-Object FullName -Descending | Select-Object -First 1
            if ($hit) { return $hit.FullName }
        }
    }
    return $null
}

# Read simple `key = value` lines of config.lua (strings and numbers only).
function Read-LuaConfig([string]$Path) {
    $values = @{}
    foreach ($line in [IO.File]::ReadAllLines($Path)) {
        if ($line -match '^\s*(\w+)\s*=\s*"([^"]*)"') { $values[$Matches[1]] = $Matches[2] }
        elseif ($line -match '^\s*(\w+)\s*=\s*(-?\d+)') { $values[$Matches[1]] = [int]$Matches[2] }
    }
    return $values
}

function Get-ConfigValue($Config, [string]$Key, $Default) {
    if ($Config.ContainsKey($Key)) { return $Config[$Key] }
    return $Default
}

function Test-TcpPort([string]$HostName, [int]$Port, [int]$TimeoutMs = 1000) {
    if ($HostName -eq 'localhost') { $HostName = '127.0.0.1' }
    $client = New-Object System.Net.Sockets.TcpClient
    try {
        $async = $client.BeginConnect($HostName, $Port, $null, $null)
        if (-not $async.AsyncWaitHandle.WaitOne($TimeoutMs)) { return $false }
        $client.EndConnect($async)
        return $true
    } catch { return $false } finally { $client.Close() }
}

function Get-PortOwner([int]$Port) {
    try {
        $conn = Get-NetTCPConnection -LocalPort $Port -State Listen -ErrorAction Stop | Select-Object -First 1
        $proc = Get-Process -Id $conn.OwningProcess -ErrorAction SilentlyContinue
        if ($proc) { return "$($proc.ProcessName) (PID $($proc.Id))" }
    } catch { }
    return 'unknown process'
}

# Run SQL with the mysql client. The password is passed through MYSQL_PWD, never on the command line.
function Invoke-MySql {
    param([string]$MySql, [string]$HostName, [int]$Port, [string]$User, [string]$Password,
          [string]$Database = '', [string]$Sql, [switch]$Scalar)
    $cliArgs = @("--host=$HostName", "--port=$Port", "--user=$User", '--default-character-set=utf8mb4', '--batch', '--skip-column-names', "--execute=$Sql")
    if ($Database) { $cliArgs += $Database }
    $old = $env:MYSQL_PWD
    $env:MYSQL_PWD = $Password
    # Windows PowerShell 5.1 turns native stderr into terminating errors under 'Stop'.
    $ErrorActionPreference = 'Continue'
    try {
        $output = & $MySql @cliArgs 2>&1
        $code = $LASTEXITCODE
    } finally { $env:MYSQL_PWD = $old }
    if ($code -ne 0) { throw ("mysql failed: " + (($output | Out-String).Trim())) }
    if ($Scalar) { return (($output | Select-Object -First 1) -as [string]).Trim() }
    return $output
}

# Write text as UTF-8 *without* BOM (Lua 5.1 cannot parse a BOM at the start of config.lua).
function Write-Utf8NoBom([string]$Path, [string]$Text) {
    [IO.File]::WriteAllText($Path, $Text, (New-Object System.Text.UTF8Encoding $false))
}
