@echo off
REM Start the MariaDB Windows service. Right-click -> "Run as administrator".
sc query MariaDB | findstr /i RUNNING >nul && (echo MariaDB is already running. & pause & exit /b 0)
net start MariaDB || net start MySQL || (echo Could not start MariaDB. Open the Windows "Services" app and start the "MariaDB" service, or reinstall MariaDB with "Install as service". & pause & exit /b 1)
pause
