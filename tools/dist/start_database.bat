@echo off
REM Start the MariaDB Windows service (installed by the MariaDB installer).
net start | findstr /i "MariaDB MySQL" >nul && (echo Database service already running. & goto :eof)
net start MariaDB 2>nul || net start MySQL 2>nul || echo Could not start a MariaDB/MySQL service. Start it from services.msc or run the installer.
pause
