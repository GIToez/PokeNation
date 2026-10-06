@echo off
REM One-time database setup for the PokeNation (PSoul) development server on Windows.
REM Requires MariaDB (https://mariadb.org/download/) installed with the default root account.
REM Creates database "psoul", user "psoul" / password "psoul-dev", imports the schema and the
REM development accounts, and writes config.lua. DEVELOPMENT ONLY - never use these on a public server.
setlocal
cd /d "%~dp0"

set MYSQL=mysql
where mysql >nul 2>nul || for /d %%D in ("%ProgramFiles%\MariaDB*") do set "MYSQL=%%D\bin\mysql.exe"
"%MYSQL%" --version >nul 2>nul || (echo Could not find mysql.exe. Install MariaDB and add its bin folder to PATH. & pause & exit /b 1)

set /p ROOTPW=MariaDB root password (set during MariaDB installation): 
echo Creating database and user...
"%MYSQL%" -uroot -p%ROOTPW% -e "CREATE DATABASE IF NOT EXISTS psoul CHARACTER SET utf8mb4; CREATE USER IF NOT EXISTS 'psoul'@'localhost' IDENTIFIED BY 'psoul-dev'; ALTER USER 'psoul'@'localhost' IDENTIFIED BY 'psoul-dev'; GRANT ALL PRIVILEGES ON psoul.* TO 'psoul'@'localhost'; FLUSH PRIVILEGES;" || (echo Failed. & pause & exit /b 1)

for /f %%N in ('"%MYSQL%" -upsoul -ppsoul-dev -N -e "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='psoul' AND table_name='accounts'"') do set HAVE=%%N
if "%HAVE%"=="0" (
  echo Importing schema...
  "%MYSQL%" -upsoul -ppsoul-dev psoul < src\schemas\mysql.sql || goto :fail
  "%MYSQL%" -upsoul -ppsoul-dev psoul < src\schemas\psoul_extra_mysql.sql || goto :fail
  "%MYSQL%" -upsoul -ppsoul-dev psoul < src\schemas\psoul_dev_seed.sql || goto :fail
) else (
  echo Tables already exist - schema import skipped.
)

if not exist config.lua (
  powershell -NoProfile -Command "(Get-Content config.example.lua) -replace '^(\s*sqlUser\s*=\s*)\"[^\"]*\"','$1\"psoul\"' -replace '^(\s*sqlPass\s*=\s*)\"[^\"]*\"','$1\"psoul-dev\"' -replace '^(\s*sqlDatabase\s*=\s*)\"[^\"]*\"','$1\"psoul\"' | Set-Content config.lua"
  echo config.lua created.
)
echo.
echo Development accounts: admin/admin (GM Admin, Tester)   player/player (Trainer)
echo Now run start_server.bat
pause
exit /b 0
:fail
echo Schema import failed.
pause
exit /b 1
