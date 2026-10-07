@echo off
REM One-time setup of the PokeNation development database (MariaDB) and config.lua.
REM All checks and messages are in Setup-PokeNation-Database.ps1 (PowerShell).
cd /d "%~dp0"
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0Setup-PokeNation-Database.ps1" %*
set RC=%ERRORLEVEL%
echo.
pause
exit /b %RC%
