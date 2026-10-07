#!/usr/bin/env bash
# Start the packaged PokeNation (PSoul) development server. Run from the package folder or anywhere.
# First run: ./setup_database.sh (creates the database and config.lua). Ctrl+C stops the server.
set -uo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"
fail() { echo "[FAIL] $*" >&2; exit 1; }
ok()   { echo "[ OK ] $*"; }

[ -f ./psoul-server ] || fail "psoul-server missing - this folder is not a complete server package"
[ -d data ] || fail "data/ missing - run this script from the server package folder"
[ "$(wc -c < data/world/map.otbm 2>/dev/null || echo 0)" -gt 1000000 ] || fail "data/world/map.otbm missing or incomplete"
[ -f config.lua ] || fail "config.lua missing - run ./setup_database.sh first"
ok "package files and config.lua present"

cfg() { sed -nE "s/^[[:space:]]*$1[[:space:]]*=[[:space:]]*\"?([^\"-]*)\"?.*/\1/p" config.lua | head -n1 | tr -d ' \r'; }   # config.lua has CRLF line endings
DB_HOST="$(cfg sqlHost)"; DB_PORT="$(cfg sqlPort)"; DB_USER="$(cfg sqlUser)"; DB_NAME="$(cfg sqlDatabase)"
DB_PASS="$(sed -nE 's/^[[:space:]]*sqlPass[[:space:]]*=[[:space:]]*"([^"]*)".*/\1/p' config.lua | head -n1 | tr -d '\r')"
LOGIN_PORT="$(cfg loginPort)"; GAME_PORT="$(cfg gamePort)"

if command -v mysql >/dev/null; then
  mysqladmin -h "$DB_HOST" -P "$DB_PORT" ping --silent 2>/dev/null || fail "MariaDB is not running on $DB_HOST:$DB_PORT - run ./start_database.sh"
  n=$(MYSQL_PWD="$DB_PASS" mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" -N -e "SELECT COUNT(*) FROM accounts" "$DB_NAME" 2>/dev/null) \
    || fail "cannot read database '$DB_NAME' as '$DB_USER' - run ./setup_database.sh"
  ok "database '$DB_NAME' reachable ($n accounts)"
else
  echo "[WARN] mysql client not installed - database check skipped"
fi

for p in "$LOGIN_PORT" "$GAME_PORT"; do
  (echo >/dev/tcp/127.0.0.1/"$p") 2>/dev/null && fail "port $p is already in use - is another server running? (pkill -x psoul-server)"
done
ok "ports $LOGIN_PORT (login) and $GAME_PORT (game) are free"

chmod +x ./psoul-server
echo "Starting server. Wait for '>> Cristal server Online!' (about 15 s)."
exec ./psoul-server "$@"
