@echo off
REM Start the legacy PokeNation client (connects to 127.0.0.1:7564). Start the server first.
REM All checks and messages are in Start-PokeNation-Client.ps1 (PowerShell).
cd /d "%~dp0"
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0Start-PokeNation-Client.ps1" %*
set RC=%ERRORLEVEL%
if not "%RC%"=="0" (echo. & echo Failed - read the messages above. & pause)
exit /b %RC%
