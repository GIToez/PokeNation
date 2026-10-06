#!/usr/bin/env bash
# Start the packaged PokeNation (PSoul) server. Run from the package folder or anywhere.
# First run: ./setup_database.sh (creates the database and config.lua).
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"
[ -f config.lua ] || { echo "config.lua missing - run ./setup_database.sh first"; exit 1; }
[ -x ./psoul-server ] || chmod +x ./psoul-server
echo "Starting server on ports 7564 (login) / 8548 (game). Wait for '>> Cristal server Online!' (about 15 s). Ctrl+C stops it."
exec ./psoul-server "$@"
