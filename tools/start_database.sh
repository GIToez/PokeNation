#!/usr/bin/env bash
# Start the local MariaDB/MySQL service used by the PSoul server (development only).
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/dev_env.sh"

if mysqladmin -h "$DB_HOST" -P "$DB_PORT" ping --silent 2>/dev/null; then
  say "Database already running on $DB_HOST:$DB_PORT"
else
  say "Starting MariaDB/MySQL service"
  if command -v systemctl >/dev/null 2>&1 && systemctl list-unit-files 2>/dev/null | grep -qE '^(mariadb|mysql)\.service'; then
    sudo systemctl start mariadb 2>/dev/null || sudo systemctl start mysql
  elif command -v service >/dev/null 2>&1; then
    sudo service mariadb start 2>/dev/null || sudo service mysql start
  elif command -v mariadbd-safe >/dev/null 2>&1; then
    sudo mariadbd-safe --user=mysql >/dev/null 2>&1 &
  elif command -v mysqld_safe >/dev/null 2>&1; then
    sudo mysqld_safe --user=mysql >/dev/null 2>&1 &
  else
    die "No MariaDB/MySQL service found. Install it first (Debian/Ubuntu: sudo apt install mariadb-server)."
  fi
  for _ in $(seq 1 30); do
    if mysqladmin -h "$DB_HOST" -P "$DB_PORT" ping --silent 2>/dev/null; then break; fi
    sleep 1
  done
  mysqladmin -h "$DB_HOST" -P "$DB_PORT" ping --silent 2>/dev/null || die "Database did not come up"
  say "Database is up"
fi

if ! mysql_app -e 'SELECT 1' "$DB_NAME" >/dev/null 2>&1; then
  warn "Database '$DB_NAME' / user '$DB_USER' not reachable yet - run tools/setup_database.sh once."
fi
