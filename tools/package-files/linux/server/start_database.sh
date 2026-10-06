#!/usr/bin/env bash
# Start the local MariaDB/MySQL service (development machine).
set -euo pipefail
if mysqladmin ping --silent 2>/dev/null; then echo "Database already running"; exit 0; fi
if command -v systemctl >/dev/null 2>&1; then
  sudo systemctl start mariadb 2>/dev/null || sudo systemctl start mysql
else
  sudo service mariadb start 2>/dev/null || sudo service mysql start
fi
for _ in $(seq 1 30); do mysqladmin ping --silent 2>/dev/null && { echo "Database is up"; exit 0; }; sleep 1; done
echo "Database did not start"; exit 1
