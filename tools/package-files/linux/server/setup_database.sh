#!/usr/bin/env bash
# One-time database setup for the packaged server (DEVELOPMENT ONLY).
# Creates database "psoul", user "psoul" with password "psoul-dev" (override with PSOUL_DB_PASS),
# imports the schema + development accounts, and writes config.lua from config.example.lua.
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"
DB_PASS="${PSOUL_DB_PASS:-psoul-dev}"
command -v mysql >/dev/null || { echo "mysql client not found (Debian/Ubuntu: sudo apt install mariadb-server mariadb-client)"; exit 1; }
mysqladmin ping --silent 2>/dev/null || ./start_database.sh

admin() { if mysql -u root -e 'SELECT 1' >/dev/null 2>&1; then mysql -u root "$@"; else sudo mysql "$@"; fi; }
admin <<SQL
CREATE DATABASE IF NOT EXISTS psoul CHARACTER SET utf8mb4;
CREATE USER IF NOT EXISTS 'psoul'@'localhost' IDENTIFIED BY '$DB_PASS';
ALTER USER 'psoul'@'localhost' IDENTIFIED BY '$DB_PASS';
GRANT ALL PRIVILEGES ON psoul.* TO 'psoul'@'localhost';
FLUSH PRIVILEGES;
SQL

if [ "$(mysql -upsoul -p"$DB_PASS" -N -e "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='psoul' AND table_name='accounts'")" = "0" ]; then
  mysql -upsoul -p"$DB_PASS" psoul < database/mysql.sql
  mysql -upsoul -p"$DB_PASS" psoul < database/psoul_extra_mysql.sql
  mysql -upsoul -p"$DB_PASS" psoul < database/psoul_dev_seed.sql
  echo "Schema imported."
else
  echo "Tables already exist - schema import skipped."
fi

if [ ! -f config.lua ]; then
  sed -E -e "s/^([[:space:]]*sqlUser[[:space:]]*=[[:space:]]*)\"[^\"]*\"/\1\"psoul\"/" \
         -e "s/^([[:space:]]*sqlPass[[:space:]]*=[[:space:]]*)\"[^\"]*\"/\1\"$DB_PASS\"/" \
         -e "s/^([[:space:]]*sqlDatabase[[:space:]]*=[[:space:]]*)\"[^\"]*\"/\1\"psoul\"/" config.example.lua > config.lua
  echo "config.lua created."
fi
echo
echo "Development accounts: admin/admin (GM Admin, Tester)  player/player (Trainer)"
echo "Now run ./start_server.sh"
