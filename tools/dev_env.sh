#!/usr/bin/env bash
# Shared settings for the tools/*.sh development scripts. Source, do not execute.
#
# Everything here is DEVELOPMENT-ONLY. The database password is read from server/config.lua
# (git-ignored) when it exists, otherwise the default below is used and written there by
# tools/setup_database.sh.

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SERVER_DIR="$ROOT_DIR/server"
CLIENT_DIR="$ROOT_DIR/client"
DIST_ROOT="$ROOT_DIR/dist"

# Platform: "linux" or "windows" (MSYS2 MinGW-w64 bash).
case "$(uname -s)" in
  MINGW*|MSYS*|CYGWIN*) PLATFORM=windows; EXE=.exe ;;
  *)                    PLATFORM=linux;   EXE="" ;;
esac

# Build type: development (default, optimised + symbols in build/, stripped in packages),
# release (optimised, no symbols) or debug (no optimisation, full symbols, packaged to dist/debug/).
BUILD_TYPE="${BUILD_TYPE:-development}"
case "$BUILD_TYPE" in
  development) CMAKE_BUILD_TYPE=RelWithDebInfo; PKG_SUFFIX=Dev ;;
  release)     CMAKE_BUILD_TYPE=Release;        PKG_SUFFIX=Release ;;
  debug)       CMAKE_BUILD_TYPE=Debug;          PKG_SUFFIX=Debug ;;
  *) printf 'ERROR unknown BUILD_TYPE "%s" (development|release|debug)\n' "$BUILD_TYPE" >&2; exit 1 ;;
esac

# Compiler output only: build/<platform>-<type>/{server,client}. Never committed.
BUILD_DIR="$ROOT_DIR/build/$PLATFORM-$BUILD_TYPE"

POKENATION_VERSION="$(tr -d ' \r\n' < "$ROOT_DIR/VERSION" 2>/dev/null || echo 0.0.0)"
GIT_SHA="$(git -C "$ROOT_DIR" rev-parse HEAD 2>/dev/null || echo "${GITHUB_SHA:-unknown}")"
GIT_DIRTY="$(git -C "$ROOT_DIR" status --porcelain --untracked-files=no 2>/dev/null | head -c1)"

DB_NAME="${PSOUL_DB_NAME:-psoul}"
DB_USER="${PSOUL_DB_USER:-psoul}"
DB_HOST="${PSOUL_DB_HOST:-localhost}"
DB_PORT="${PSOUL_DB_PORT:-3306}"
DB_PASS_DEFAULT="psoul-dev"

LOGIN_PORT=7564
GAME_PORT=8548

SERVER_BIN="$BUILD_DIR/server/psoul-server$EXE"
CLIENT_BIN="$BUILD_DIR/client/psoulclient$EXE"

# Names inside the packages (dist/). Linux keeps the historical names.
if [ "$PLATFORM" = windows ]; then
  PKG_SERVER_EXE=PokeNationServer.exe; PKG_CLIENT_EXE=PokeNationLegacyClient.exe
else
  PKG_SERVER_EXE=psoul-server; PKG_CLIENT_EXE=psoulclient
fi

njobs() { nproc 2>/dev/null || echo 2; }

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
