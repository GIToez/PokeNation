#!/usr/bin/env bash
# One-time local database setup (development only):
#   1. create database + user (password from server/config.lua, $PSOUL_DB_PASS or "psoul-dev")
#   2. import the three schema files (stock TFS, PSoul additions, dev seed with test accounts)
#   3. create server/config.lua from config.example.lua if it does not exist
# Safe to re-run: existing tables are left alone unless --reset is given.
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/dev_env.sh"

RESET=0
[ "${1:-}" = "--reset" ] && RESET=1

command -v mysql >/dev/null 2>&1 || die "mysql client not found (Debian/Ubuntu: sudo apt install mariadb-client)"
mysqladmin -h "$DB_HOST" -P "$DB_PORT" ping --silent 2>/dev/null || "$ROOT_DIR/tools/start_database.sh"

say "Creating database '$DB_NAME' and user '$DB_USER'@'localhost' (if missing)"
if [ "$RESET" = 1 ]; then
  warn "--reset: dropping database '$DB_NAME'"
  mysql_admin -e "DROP DATABASE IF EXISTS \`$DB_NAME\`;"
fi
mysql_admin <<SQL
CREATE DATABASE IF NOT EXISTS \`$DB_NAME\` CHARACTER SET utf8mb4;
CREATE USER IF NOT EXISTS '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASS';
ALTER USER '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASS';
GRANT ALL PRIVILEGES ON \`$DB_NAME\`.* TO '$DB_USER'@'localhost';
FLUSH PRIVILEGES;
SQL

have_tables=$(mysql_app -N -e "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='$DB_NAME' AND table_name='accounts';" 2>/dev/null || echo 0)
if [ "$have_tables" = "0" ]; then
  say "Importing schema: src/schemas/mysql.sql (stock TFS 0.3.6)"
  mysql_app "$DB_NAME" < "$SERVER_DIR/src/schemas/mysql.sql"
  say "Importing schema: src/schemas/psoul_extra_mysql.sql (PSoul tables/columns)"
  mysql_app "$DB_NAME" < "$SERVER_DIR/src/schemas/psoul_extra_mysql.sql"
  say "Importing seed: src/schemas/psoul_dev_seed.sql (development accounts)"
  mysql_app "$DB_NAME" < "$SERVER_DIR/src/schemas/psoul_dev_seed.sql"
else
  say "Tables already exist - skipping schema import (use --reset to start over)"
fi

tables=$(mysql_app -N -e "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='$DB_NAME';")
say "Database '$DB_NAME' has $tables tables"

if [ ! -f "$SERVER_DIR/config.lua" ]; then
  say "Creating server/config.lua from config.example.lua (git-ignored)"
  sed -E \
    -e "s/^([[:space:]]*sqlHost[[:space:]]*=[[:space:]]*)\"[^\"]*\"/\1\"$DB_HOST\"/" \
    -e "s/^([[:space:]]*sqlPort[[:space:]]*=[[:space:]]*)[0-9]+/\1$DB_PORT/" \
    -e "s/^([[:space:]]*sqlUser[[:space:]]*=[[:space:]]*)\"[^\"]*\"/\1\"$DB_USER\"/" \
    -e "s/^([[:space:]]*sqlPass[[:space:]]*=[[:space:]]*)\"[^\"]*\"/\1\"$DB_PASS\"/" \
    -e "s/^([[:space:]]*sqlDatabase[[:space:]]*=[[:space:]]*)\"[^\"]*\"/\1\"$DB_NAME\"/" \
    "$SERVER_DIR/config.example.lua" > "$SERVER_DIR/config.lua"
else
  say "server/config.lua already exists - not touched"
fi

cat <<EOF

Development accounts (seeded by psoul_dev_seed.sql, DEVELOPMENT ONLY):
  account "admin"  / password "admin"   -> characters "GM Admin" (GM, group 6) and "Tester" (normal player)
  account "player" / password "player"  -> character "Trainer" (normal player)
EOF
