@echo off
REM Start the PokeNation development server after checking MariaDB, the database, config.lua and the ports.
REM All checks and messages are in Start-PokeNation-Server.ps1 (PowerShell).
cd /d "%~dp0"
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0Start-PokeNation-Server.ps1" %*
set RC=%ERRORLEVEL%
echo.
pause
exit /b %RC%
