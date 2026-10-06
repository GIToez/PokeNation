@echo off
REM Start the PokeNation (PSoul) development server.
REM First run: setup_database.bat. Wait for ">> Cristal server Online!" before starting the client.
cd /d "%~dp0"
if not exist config.lua (echo config.lua missing - run setup_database.bat first. & pause & exit /b 1)
if not exist data\world\map.otbm (echo data\world\map.otbm missing - the package is incomplete. & pause & exit /b 1)
echo Starting server on ports 7564 (login) / 8548 (game)...
PokeNationServer.exe
pause
