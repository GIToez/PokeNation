#!/usr/bin/env bash
# Shared settings for the tools/*.sh development scripts. Source, do not execute.
#
# Everything here is DEVELOPMENT-ONLY. The database password is read from server/config.lua
# (git-ignored) when it exists, otherwise the default below is used and written there by
# tools/setup_database.sh.

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SERVER_DIR="$ROOT_DIR/server"
CLIENT_DIR="$ROOT_DIR/client"
BUILD_DIR="$ROOT_DIR/build"

DB_NAME="${PSOUL_DB_NAME:-psoul}"
DB_USER="${PSOUL_DB_USER:-psoul}"
DB_HOST="${PSOUL_DB_HOST:-localhost}"
DB_PORT="${PSOUL_DB_PORT:-3306}"
DB_PASS_DEFAULT="psoul-dev"

LOGIN_PORT=7564
GAME_PORT=8548

SERVER_BIN="$SERVER_DIR/psoul-server"
CLIENT_BIN="$BUILD_DIR/client/psoulclient"

# Read sqlPass from server/config.lua if present.
config_db_pass() {
  if [ -f "$SERVER_DIR/config.lua" ]; then
    sed -nE 's/^[[:space:]]*sqlPass[[:space:]]*=[[:space:]]*"([^"]*)".*/\1/p' "$SERVER_DIR/config.lua" | head -n1
  fi
}

DB_PASS="${PSOUL_DB_PASS:-$(config_db_pass)}"
DB_PASS="${DB_PASS:-$DB_PASS_DEFAULT}"

say()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33mWARN\033[0m %s\n' "$*" >&2; }
die()  { printf '\033[1;31mERROR\033[0m %s\n' "$*" >&2; exit 1; }

mysql_admin() {
  # Administrative connection (creating the database/user). Works with the default
  # unix_socket authentication of Debian/Ubuntu MariaDB when run with sudo.
  if mysql -u root -e 'SELECT 1' >/dev/null 2>&1; then
    mysql -u root "$@"
  elif command -v sudo >/dev/null && sudo -n true 2>/dev/null; then
    sudo mysql "$@"
  else
    mysql -u root -p "$@"
  fi
}

mysql_app() {
  mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" -p"$DB_PASS" "$@"
}
