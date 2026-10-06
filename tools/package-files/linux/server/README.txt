PokeNation development server for Linux (PSoul/PokeAimar baseline)
===================================================================

DEVELOPMENT BUILD - for local testing only. Version/commit: VERSION.txt, version.json.

Needs: MariaDB server + client (Debian/Ubuntu: sudo apt install mariadb-server mariadb-client)
and the runtime libraries listed in docs/BUILDING.md (Boost, Lua 5.1, libxml2, GMP,
libmysqlclient/libmariadb, SQLite, OpenSSL).

  ./setup_database.sh    once: database "psoul", user "psoul"/"psoul-dev", dev accounts, config.lua
  ./start_database.sh    if MariaDB is not running
  ./start_server.sh      wait for ">> Cristal server Online!"

Accounts (local only): admin/admin (GM Admin, Tester), player/player (Trainer).
Ports: login 7564, game 8548 on 127.0.0.1. Licence: LICENSE-server.txt (GPL v2).
