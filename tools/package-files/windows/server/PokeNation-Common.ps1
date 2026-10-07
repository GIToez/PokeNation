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

# Locate the MariaDB/MySQL command line client. MariaDB is the documented database, so its own
# client is preferred over a MySQL client that happens to be first on PATH (e.g. MySQL 8 on CI runners).
function Find-MySqlClient {
    $roots = @($env:ProgramFiles, ${env:ProgramFiles(x86)}, 'C:\tools') | Where-Object { $_ }
    $newestFirst = { if ($_.Directory.Parent.Name -match '(\d+(\.\d+)+)') { [version]$Matches[1] } else { [version]'0.0' } }

    $cmd = Get-Command mariadb.exe -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($cmd) { return $cmd.Source }
    foreach ($exe in 'mariadb.exe', 'mysql.exe') {
        $hits = foreach ($root in $roots) { Get-ChildItem -Path (Join-Path $root "MariaDB*\bin\$exe") -ErrorAction SilentlyContinue }
        $hit = $hits | Sort-Object -Property $newestFirst -Descending | Select-Object -First 1
        if ($hit) { return $hit.FullName }
    }
    $cmd = Get-Command mysql.exe -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($cmd) { return $cmd.Source }
    $hits = foreach ($root in $roots) { Get-ChildItem -Path (Join-Path $root 'MySQL\MySQL Server*\bin\mysql.exe') -ErrorAction SilentlyContinue }
    $hit = $hits | Sort-Object -Property $newestFirst -Descending | Select-Object -First 1
    if ($hit) { return $hit.FullName }
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

# Quote one argument for a Windows command line (the rules CommandLineToArgvW and the C runtime use).
function ConvertTo-CommandLineArgument([string]$Value) {
    if ($Value -ne '' -and $Value -notmatch '[\s"]') { return $Value }
    $escaped = [regex]::Replace($Value, '(\\*)"', { param($m) $m.Groups[1].Value + $m.Groups[1].Value + '\"' })
    $escaped = [regex]::Replace($escaped, '(\\+)$', { param($m) $m.Groups[1].Value + $m.Groups[1].Value })
    return '"' + $escaped + '"'
}

# Messages the client printed on stderr during the last successful Invoke-MySql call (e.g. warnings).
$script:MySqlLastStderr = ''

# Run SQL (-Sql) or a .sql file (-InputFile, fed through stdin) with the mysql client. The password is
# passed through MYSQL_PWD, never on the command line. stdout (the result rows) and stderr (warnings
# such as MariaDB 11's "insecure passwordless login") are read separately; only stdout is returned.
# A non-zero exit code or an "ERROR nnnn" line on stderr is an error. (The client exits 0 after errors
# inside "source file", which is why files go through stdin, where it stops at the first error.)
function Invoke-MySql {
    param([string]$MySql, [string]$HostName, [int]$Port, [string]$User, [string]$Password,
          [string]$Database = '', [string]$Sql, [string]$InputFile, [switch]$Scalar)
    $cliArgs = @("--host=$HostName", "--port=$Port", "--user=$User", '--default-character-set=utf8mb4', '--batch', '--skip-column-names')
    if (-not $InputFile) { $cliArgs += "--execute=$Sql" }
    if ($Database) { $cliArgs += $Database }

    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = $MySql
    $psi.Arguments = ($cliArgs | ForEach-Object { ConvertTo-CommandLineArgument $_ }) -join ' '
    $psi.UseShellExecute = $false
    $psi.CreateNoWindow = $true
    $psi.RedirectStandardInput = $true
    $psi.RedirectStandardOutput = $true
    $psi.RedirectStandardError = $true
    $psi.StandardOutputEncoding = New-Object System.Text.UTF8Encoding $false
    $psi.StandardErrorEncoding = New-Object System.Text.UTF8Encoding $false
    # An empty MYSQL_PWD is not the same as no password for every client version, so unset it instead.
    $psi.EnvironmentVariables.Remove('MYSQL_PWD')
    if ($Password) { $psi.EnvironmentVariables['MYSQL_PWD'] = $Password }

    $sqlFile = $null
    if ($InputFile) { $sqlFile = [IO.File]::OpenRead($InputFile) }
    try {
        $proc = [System.Diagnostics.Process]::Start($psi)
        # Both pipes are drained concurrently, otherwise a full stderr pipe can block the client forever.
        $stdoutTask = $proc.StandardOutput.ReadToEndAsync()
        $stderrTask = $proc.StandardError.ReadToEndAsync()
        if ($sqlFile) {
            # The client stops reading at the first SQL error; its exit code reports that error.
            try { $sqlFile.CopyTo($proc.StandardInput.BaseStream) } catch [IO.IOException] { }
        }
        try { $proc.StandardInput.Close() } catch [IO.IOException] { }
        $proc.WaitForExit()
        $stdout = $stdoutTask.Result
        $stderr = $stderrTask.Result.Trim()
        $code = $proc.ExitCode
        $proc.Dispose()
    } finally { if ($sqlFile) { $sqlFile.Dispose() } }

    if ($code -ne 0 -or $stderr -match '(?m)^ERROR \d+') {
        $detail = if ($stderr) { $stderr } else { $stdout.Trim() }
        throw "mysql failed (exit code $code): $detail"
    }
    $script:MySqlLastStderr = $stderr
    $rows = @($stdout -split '\r?\n')
    if ($rows.Count -gt 0 -and $rows[-1] -eq '') { $rows = @($rows | Select-Object -First ($rows.Count - 1)) }
    if ($Scalar) {
        if ($rows.Count -eq 0) { return '' }
        return $rows[0].Trim()
    }
    return $rows
}

# Write text as UTF-8 *without* BOM (Lua 5.1 cannot parse a BOM at the start of config.lua).
function Write-Utf8NoBom([string]$Path, [string]$Text) {
    [IO.File]::WriteAllText($Path, $Text, (New-Object System.Text.UTF8Encoding $false))
}
