#!/usr/bin/env bash
# Initialise the local development database (MariaDB) without writing any SQL by hand.
#   tools/init_dev_database.sh           create database/user, import schemas + dev seed if empty
#   tools/init_dev_database.sh --reset   drop the database first and start from the seed again
# Same implementation as tools/setup_database.sh (kept for existing docs and scripts).
# Windows equivalent: Setup-PokeNation-Database.ps1 in the server package.
exec "$(dirname "${BASH_SOURCE[0]}")/setup_database.sh" "$@"
