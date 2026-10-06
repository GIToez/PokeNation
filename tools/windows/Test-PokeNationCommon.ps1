<#
.SYNOPSIS
  Regression tests for Invoke-MySql in tools/package-files/windows/server/PokeNation-Common.ps1.

.DESCRIPTION
  Uses a fake mysql client (compiled with the .NET Framework csc.exe on Windows, a shell script
  elsewhere) that prints what the FAKE_* environment variables say and records the arguments and
  MYSQL_PWD it received. Covers BUG-74: a warning on stderr (MariaDB 11's "insecure passwordless
  login") must not end up in -Scalar results, and real errors must still throw.
  Runs under Windows PowerShell 5.1 and PowerShell 7 (Windows and Linux). Exit code 0 = all passed.

.EXAMPLE
  powershell -NoProfile -ExecutionPolicy Bypass -File tools\windows\Test-PokeNationCommon.ps1
  pwsh -NoProfile -File tools/windows/Test-PokeNationCommon.ps1
#>
$repo = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
. (Join-Path $repo 'tools\package-files\windows\server\PokeNation-Common.ps1')

$work = Join-Path ([IO.Path]::GetTempPath()) ("pokenation-common-test-" + [Guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $work | Out-Null
$onWindows = [IO.Path]::DirectorySeparatorChar -eq '\'

if ($onWindows) {
    $fake = Join-Path $work 'fake-mysql.exe'
    $source = Join-Path $work 'FakeMySql.cs'
    [IO.File]::WriteAllText($source, @'
using System;
using System.IO;
using System.Text;
static class FakeMySql {
    static int Main(string[] args) {
        string argsFile = Environment.GetEnvironmentVariable("FAKE_ARGS_FILE");
        if (argsFile != null) File.WriteAllText(argsFile, string.Join("\0", args), new UTF8Encoding(false));
        string pwdFile = Environment.GetEnvironmentVariable("FAKE_PWD_FILE");
        if (pwdFile != null) File.WriteAllText(pwdFile, Environment.GetEnvironmentVariable("MYSQL_PWD") ?? "<unset>");
        string stdinFile = Environment.GetEnvironmentVariable("FAKE_STDIN_FILE");
        if (stdinFile != null) using (var f = File.Create(stdinFile)) Console.OpenStandardInput().CopyTo(f);
        int big = int.Parse(Environment.GetEnvironmentVariable("FAKE_BIG") ?? "0");
        for (int i = 0; i < big; i++) Console.Error.WriteLine("stderr filler line " + i);
        string err = Environment.GetEnvironmentVariable("FAKE_STDERR");
        if (!string.IsNullOrEmpty(err)) Console.Error.WriteLine(err);
        string output = Environment.GetEnvironmentVariable("FAKE_STDOUT");
        if (!string.IsNullOrEmpty(output)) Console.Out.Write(output.Replace("|", "\r\n"));
        for (int i = 0; i < big; i++) Console.Out.WriteLine("stdout filler line " + i);
        return int.Parse(Environment.GetEnvironmentVariable("FAKE_EXIT") ?? "0");
    }
}
'@)
    $csc = Join-Path $env:WINDIR 'Microsoft.NET\Framework64\v4.0.30319\csc.exe'
    if (-not (Test-Path $csc)) { $csc = Join-Path $env:WINDIR 'Microsoft.NET\Framework\v4.0.30319\csc.exe' }
    & $csc /nologo /target:exe "/out:$fake" $source | Out-Host
    if ($LASTEXITCODE -ne 0 -or -not (Test-Path $fake)) { Write-Host "[FAIL] could not compile the fake mysql client"; exit 1 }
} else {
    $fake = Join-Path $work 'fake-mysql.sh'
    [IO.File]::WriteAllText($fake, @'
#!/bin/sh
[ -n "$FAKE_ARGS_FILE" ] && { first=1; for a in "$@"; do [ $first = 1 ] || printf '\000'; printf '%s' "$a"; first=0; done > "$FAKE_ARGS_FILE"; }
[ -n "$FAKE_PWD_FILE" ] && printf '%s' "${MYSQL_PWD-<unset>}" > "$FAKE_PWD_FILE"
[ -n "$FAKE_STDIN_FILE" ] && cat > "$FAKE_STDIN_FILE"
i=0; while [ $i -lt "${FAKE_BIG:-0}" ]; do echo "stderr filler line $i" >&2; i=$((i+1)); done
[ -n "$FAKE_STDERR" ] && printf '%s\n' "$FAKE_STDERR" >&2
[ -n "$FAKE_STDOUT" ] && printf '%s' "$FAKE_STDOUT" | tr '|' '\n'
i=0; while [ $i -lt "${FAKE_BIG:-0}" ]; do echo "stdout filler line $i"; i=$((i+1)); done
exit "${FAKE_EXIT:-0}"
'@.Replace("`r`n", "`n"))
    & chmod +x $fake
}

$script:failures = 0
function Check([string]$Name, [bool]$Condition, [string]$Detail = '') {
    if ($Condition) { Write-Host "[ OK ] $Name" }
    else { Write-Host "[FAIL] $Name $Detail"; $script:failures++ }
}
function Set-Fake([string]$Stdout = '', [string]$Stderr = '', [int]$Exit = 0, [int]$Big = 0) {
    $env:FAKE_STDOUT = $Stdout; $env:FAKE_STDERR = $Stderr; $env:FAKE_EXIT = "$Exit"; $env:FAKE_BIG = "$Big"
}
$warning = 'WARNING: option --ssl-verify-server-cert is disabled, because of an insecure passwordless login.'
$common = @{ MySql = $fake; HostName = '127.0.0.1'; Port = 3306; User = 'root'; Password = '' }
$env:FAKE_ARGS_FILE = Join-Path $work 'args.txt'
$env:FAKE_PWD_FILE = Join-Path $work 'pwd.txt'

try {
    Write-Host "PowerShell $($PSVersionTable.PSVersion) ($($PSVersionTable.PSEdition)); fake client: $fake"

    # BUG-74: the real-PC failure. Warning on stderr, scalar 0 on stdout, exit code 0.
    Set-Fake -Stdout "0|" -Stderr $warning
    $r = Invoke-MySql @common -Database 'psoul' -Sql "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='psoul' AND table_name='accounts'" -Scalar
    Check 'scalar ignores the passwordless-login warning on stderr' ($r -eq '0') "(got '$r')"
    $lastStderr = Get-Variable -Name MySqlLastStderr -Scope Script -ValueOnly -ErrorAction SilentlyContinue
    Check 'warning is kept in MySqlLastStderr' ($lastStderr -eq $warning) "(got '$lastStderr')"

    Set-Fake -Stdout "97|" -Stderr $warning
    $r = Invoke-MySql @common -Sql 'SELECT COUNT(*)' -Scalar
    Check 'scalar returns the table count' ($r -eq '97') "(got '$r')"

    Set-Fake -Stdout "1,admin,player|" -Stderr $warning
    $r = Invoke-MySql @common -Sql 'SELECT GROUP_CONCAT(name ORDER BY id) FROM accounts' -Scalar
    Check 'scalar returns the accounts list' ($r -eq '1,admin,player') "(got '$r')"

    Set-Fake -Stdout "a|b|c|" -Stderr $warning
    $rows = @(Invoke-MySql @common -Sql 'SELECT name FROM t')
    Check 'non-scalar returns only stdout rows' (($rows -join ',') -eq 'a,b,c') "(got '$($rows -join ',')')"

    Set-Fake -Stdout '' -Stderr $warning
    $rows = @(Invoke-MySql @common -Sql 'DROP DATABASE IF EXISTS x')
    Check 'statement without result set returns nothing' ($rows.Count -eq 0) "(got $($rows.Count) rows)"
    $r = Invoke-MySql @common -Sql 'SELECT 1 WHERE 0' -Scalar
    Check 'scalar without rows returns an empty string' ($r -eq '') "(got '$r')"

    # Real errors must still be raised, with the stderr text.
    Set-Fake -Stderr "ERROR 1146 (42S02) at line 1: Table 'psoul.accounts' doesn't exist" -Exit 1
    $thrown = $null
    try { Invoke-MySql @common -Sql 'SELECT COUNT(*) FROM accounts' -Scalar | Out-Null } catch { $thrown = $_.Exception.Message }
    Check 'non-zero exit code throws' ($null -ne $thrown)
    Check 'the error message contains the stderr text' ("$thrown" -like "*ERROR 1146 (42S02)*psoul.accounts*") "(got '$thrown')"

    Set-Fake -Stdout '' -Stderr "$warning`nERROR 1045 (28000): Access denied for user 'root'@'localhost' (using password: NO)" -Exit 1
    $thrown = $null
    try { Invoke-MySql @common -Sql 'SELECT 1' | Out-Null } catch { $thrown = $_.Exception.Message }
    Check 'warning plus error still throws with the error text' ("$thrown" -like '*ERROR 1045*') "(got '$thrown')"

    # A client that exits 0 but reports an SQL error on stderr (what "source file" does) must throw.
    Set-Fake -Stderr "ERROR 1146 (42S02) at line 3 in file: 'x.sql': Table 'psoul.x' doesn't exist"
    $thrown = $null
    try { Invoke-MySql @common -Sql 'source x.sql' | Out-Null } catch { $thrown = $_.Exception.Message }
    Check 'ERROR line on stderr with exit code 0 throws' ("$thrown" -like '*ERROR 1146*') "(got '$thrown')"

    # -InputFile streams the file through stdin, byte for byte, without --execute.
    $sqlPath = Join-Path $work 'import.sql'
    $sqlText = "DELIMITER //`r`nCREATE TRIGGER t BEFORE INSERT ON a FOR EACH ROW BEGIN SET NEW.x = 'it''s'; END//`r`nDELIMITER ;`r`n" + ("INSERT INTO a VALUES (1, 'filler');`n" * 60000)
    [IO.File]::WriteAllText($sqlPath, $sqlText, (New-Object System.Text.UTF8Encoding $false))
    $env:FAKE_STDIN_FILE = Join-Path $work 'stdin.sql'
    Set-Fake -Stderr $warning -Big 20000
    $rows = @(Invoke-MySql @common -Database 'psoul' -InputFile $sqlPath)
    $sent = [IO.File]::ReadAllBytes($sqlPath)
    $got = [IO.File]::ReadAllBytes($env:FAKE_STDIN_FILE)
    $bom = $got.Length -ge 3 -and $got[0] -eq 0xEF -and $got[1] -eq 0xBB -and $got[2] -eq 0xBF
    if ($bom) { Write-Host '       note: a UTF-8 BOM was prepended to stdin (the mysql client skips it)'; $got = $got[3..($got.Length - 1)] }
    Check 'InputFile content reaches stdin unchanged (2 MB, no deadlock)' ([Convert]::ToBase64String($got) -ceq [Convert]::ToBase64String($sent)) "(sent $($sent.Length) bytes, got $($got.Length))"
    Check 'InputFile result rows come from stdout only' ($rows.Count -eq 20000 -and $rows[0] -eq 'stdout filler line 0') "(got $($rows.Count) rows)"
    $argv = [IO.File]::ReadAllText($env:FAKE_ARGS_FILE).Split([char]0)
    Check 'InputFile does not pass --execute' (-not ($argv | Where-Object { $_ -like '--execute*' }) -and $argv[-1] -eq 'psoul') "(got: $($argv -join ' | '))"
    Remove-Item Env:\FAKE_STDIN_FILE

    # A client that stops reading stdin at the first error: its exit code and stderr are reported.
    Set-Fake -Stderr "ERROR 1064 (42000) at line 1: You have an error in your SQL syntax" -Exit 1
    $thrown = $null
    try { Invoke-MySql @common -Database 'psoul' -InputFile $sqlPath | Out-Null } catch { $thrown = $_.Exception.Message }
    Check 'InputFile import error throws with the client error, not a pipe error' ("$thrown" -like '*exit code 1*ERROR 1064*') "(got '$thrown')"

    # Arguments must reach the client exactly, the password only through MYSQL_PWD.
    $sql = "CREATE USER IF NOT EXISTS 'psoul'@'localhost' IDENTIFIED BY 'p ss`"w\`"rd\\';`nGRANT ALL ON ``psoul``.* TO 'psoul'@'127.0.0.1'; -- \"
    Set-Fake -Stdout ''
    Invoke-MySql -MySql $fake -HostName '127.0.0.1' -Port 3307 -User 'root' -Password 'se cr"et\' -Database 'psoul' -Sql $sql | Out-Null
    $got = [IO.File]::ReadAllText($env:FAKE_ARGS_FILE).Split([char]0)
    $expected = @('--host=127.0.0.1', '--port=3307', '--user=root', '--default-character-set=utf8mb4', '--batch', '--skip-column-names', "--execute=$sql", 'psoul')
    Check 'arguments (SQL with quotes, backslashes, newline) arrive unchanged' (($got -join "`n") -ceq ($expected -join "`n")) ("(got: " + ($got -join ' | ') + ')')
    Check 'password is passed through MYSQL_PWD' ([IO.File]::ReadAllText($env:FAKE_PWD_FILE) -ceq 'se cr"et\')
    Check 'password is not on the command line' (-not (($got -join ' ') -like '*se cr*'))

    Invoke-MySql @common -Sql 'SELECT 1' | Out-Null
    Check 'empty password leaves MYSQL_PWD unset' ([IO.File]::ReadAllText($env:FAKE_PWD_FILE) -eq '<unset>') "(got '$([IO.File]::ReadAllText($env:FAKE_PWD_FILE))')"

    $env:MYSQL_PWD = 'from-parent'
    Invoke-MySql @common -Sql 'SELECT 1' | Out-Null
    Check 'an inherited MYSQL_PWD is not passed on when the password is empty' ([IO.File]::ReadAllText($env:FAKE_PWD_FILE) -eq '<unset>')
    Check 'the caller environment is unchanged' ($env:MYSQL_PWD -eq 'from-parent')
    Remove-Item Env:\MYSQL_PWD

    # Large output on both pipes must not deadlock.
    Set-Fake -Stdout "first|" -Stderr $warning -Big 50000
    $sw = [Diagnostics.Stopwatch]::StartNew()
    $rows = @(Invoke-MySql @common -Sql 'SELECT 1')
    Check 'large stdout and stderr do not deadlock' ($rows.Count -eq 50001 -and $rows[0] -eq 'first') "(got $($rows.Count) rows in $($sw.Elapsed.TotalSeconds) s)"

    $ErrorActionPreference = 'Stop'
    Set-Fake -Stdout "0|" -Stderr $warning
    $r = Invoke-MySql @common -Sql 'SELECT 0' -Scalar
    Check "stderr does not raise a NativeCommandError under ErrorActionPreference 'Stop'" ($r -eq '0')

    if ($onWindows) { Write-Host "       Find-MySqlClient on this machine: $(Find-MySqlClient)" }
} catch {
    Write-Host "[FAIL] unexpected exception: $($_.Exception.Message)"
    Write-Host $_.ScriptStackTrace
    $script:failures++
} finally {
    foreach ($v in 'FAKE_STDIN_FILE', 'FAKE_STDOUT', 'FAKE_STDERR', 'FAKE_EXIT', 'FAKE_BIG', 'FAKE_ARGS_FILE', 'FAKE_PWD_FILE') { Remove-Item "Env:\$v" -ErrorAction SilentlyContinue }
    Remove-Item -Recurse -Force $work -ErrorAction SilentlyContinue
}

if ($script:failures) { Write-Host "$($script:failures) check(s) failed"; exit 1 }
Write-Host 'all Invoke-MySql checks passed'
exit 0
