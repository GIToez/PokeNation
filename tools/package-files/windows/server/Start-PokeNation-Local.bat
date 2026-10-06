@echo off
REM Start the server in its own window, wait until it is online, then start the legacy client.
REM All checks and messages are in Start-PokeNation-Local.ps1 (PowerShell).
cd /d "%~dp0"
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0Start-PokeNation-Local.ps1" %*
set RC=%ERRORLEVEL%
if not "%RC%"=="0" (echo. & echo Failed - read the messages above. & pause)
exit /b %RC%
