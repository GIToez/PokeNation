#!/usr/bin/env bash
# Start the PSoul game server in the foreground (Ctrl+C stops it).
# Builds it first if the binary is missing. Must run from anywhere; it cd's into server/.
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/dev_env.sh"

[ -f "$SERVER_DIR/config.lua" ] || die "server/config.lua missing - run tools/setup_database.sh first"
[ -x "$SERVER_BIN" ] || "$ROOT_DIR/tools/build_server.sh"

if ! mysqladmin -h "$DB_HOST" -P "$DB_PORT" ping --silent 2>/dev/null; then
  "$ROOT_DIR/tools/start_database.sh"
fi
mysql_app -e 'SELECT 1' "$DB_NAME" >/dev/null 2>&1 || die "Cannot connect to database '$DB_NAME' as '$DB_USER' - run tools/setup_database.sh"

# Large map/sprite files live in Git LFS; a 130-byte pointer file means they were not pulled.
if [ "$(stat -c %s "$SERVER_DIR/data/world/map.otbm" 2>/dev/null || echo 0)" -lt 1000000 ]; then
  die "server/data/world/map.otbm is an LFS pointer. Run: git lfs install && git lfs pull"
fi

if (echo >/dev/tcp/127.0.0.1/$LOGIN_PORT) 2>/dev/null; then
  die "Port $LOGIN_PORT already in use - is another server running?"
fi

say "Starting server (login port $LOGIN_PORT, game port $GAME_PORT). Expect '>> Cristal server Online!' after ~15 s."
cd "$SERVER_DIR"
exec "$SERVER_BIN" "$@"
