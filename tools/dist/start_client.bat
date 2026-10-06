@echo off
REM Start the PokeNation (PSoul) development client. It connects to 127.0.0.1:7564.
REM Start the server first (start_server.bat in the server package).
cd /d "%~dp0"
if not exist data\things\data.spr (echo data\things\data.spr missing - the package is incomplete. & pause & exit /b 1)
start "" PokeNationClient.exe
