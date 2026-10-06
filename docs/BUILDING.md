# Building and running the PSoul server (Linux)

Everything below was executed on Ubuntu 24.04 (GCC 13.3, Boost 1.83, MariaDB 10.11) and the
resulting binary was used for the verification described in `PHASE_1_REPORT.md`. The original
project only shipped a Dev-C++/MinGW build (`src/dev-cpp/Makefile.win`); `server/CMakeLists.txt`
reproduces that configuration (`__USE_MYSQL__ __USE_SQLITE__ __ENABLE_SERVER_DIAGNOSTIC__
__EMERGENCY_SAVE__ __CONSOLE__`) for a modern toolchain. No engine logic was changed.

## 1. Dependencies

| Component | Version used | Ubuntu package |
|-----------|--------------|----------------|
| C++ compiler | GCC 13.3 (`g++`). Clang was **not** tested; the code relies on GNU extensions (`-std=gnu++11`). | `g++` |
| CMake | 3.28 | `cmake` |
| Boost | 1.83 (`system filesystem thread regex`) | `libboost-system-dev libboost-filesystem-dev libboost-thread-dev libboost-regex-dev` |
| Lua | **5.1** (not 5.2+, not LuaJIT) | `liblua5.1-0-dev` (and `lua5.1` for `luac5.1`) |
| libxml2 | 2.9 | `libxml2-dev` (`libxml2-utils` for `xmllint`) |
| GMP | 6.3 (RSA) | `libgmp-dev` |
| MySQL client | libmysqlclient 8.0 (works against MariaDB) | `libmysqlclient-dev` (or `libmariadb-dev`) |
| SQLite | 3.45 | `libsqlite3-dev` |
| OpenSSL | 3.0 (`libcrypto`, SHA-256 passwords) | `libssl-dev` |
| Database server | MariaDB 10.11 (MySQL 8 should also work; the schema uses `ADD COLUMN IF NOT EXISTS`, which is MariaDB syntax — see §3) | `mariadb-server` |
| Git LFS | any | `git-lfs` (the map `server/data/world/map.otbm` is an LFS object) |

```bash
sudo apt-get update
sudo apt-get install -y build-essential g++ cmake pkg-config git-lfs \
  libboost-system-dev libboost-filesystem-dev libboost-thread-dev libboost-regex-dev \
  liblua5.1-0-dev lua5.1 libxml2-dev libxml2-utils libgmp-dev libmysqlclient-dev \
  libsqlite3-dev libssl-dev mariadb-server mariadb-client
git lfs install
git lfs pull            # fetches map.otbm (130 MB) and the client sprite file
```

## 2. Build

```bash
cd server
CXX=g++ cmake -S . -B build -DCMAKE_BUILD_TYPE=RelWithDebInfo
cmake --build build -j"$(nproc)"
# → ./psoul-server  (the executable is written to the server/ directory, not build/)
```

Options: `-DSERVER_DIAGNOSTIC=OFF` drops `__ENABLE_SERVER_DIAGNOSTIC__` (object counters),
`-DROOT_PERMISSION=OFF` makes the binary refuse to run as root (stock TFS behaviour).

A full build takes a few minutes; `protocolgame.cpp`, `luascript.cpp` and `game.cpp` are the
slow translation units. Expect `-Wall` warnings from the 2010-era code (unused variables,
signed/unsigned comparisons); they are not errors.

### 2.1 Source changes that were required to compile

All in commit "Fix server build on Linux/GCC 13 with Boost 1.83"; each is a minimal,
behaviour-preserving fix for a construct that older MinGW accepted:

| File | Error | Fix |
|------|-------|-----|
| `src/house.h` | `boost/tr1/unordered_set.hpp` no longer exists (removed in Boost 1.65) | use `<unordered_set>` / `std::unordered_set` |
| `src/connection.h` | `enum {writeTimeout = 30}` used where `boost::posix_time::seconds` needs an integer type | `static const int32_t` |
| `src/talkaction.cpp` | `std::string cmdstring[N] = words;` (array initialised from a single object) | explicit loop |
| `src/protocolgame.cpp` | `std::stringstream` streamed into another stream (`<< hex`) | `hex.str()` |
| `src/chat.cpp` | `return false;` from a function returning a pointer | `return NULL;` |
| `src/quests.h` | returning a reference to a temporary from `Localization::t` | return by value |
| `src/game.h` | `globalSaveMessage[2]` indexed with 0..2 in `prepareGlobalSave` (out of bounds, GCC error with `-Werror=array-bounds`) | size 3 |
| `src/player.cpp` | `for(i = 0; i <= 13; …)` over a 13-element array | `< 13` |

`gui.cpp`, `inputbox.cpp` and `exception.cpp` are still compiled; their bodies are empty on
non-Windows. `__EXCEPTION_TRACER__` (MinGW stack tracer) is not enabled.

## 3. Database

The server needs MySQL/MariaDB (`sqlType = "mysql"`). SQLite is compiled in but the PSoul Lua
code issues MySQL-only SQL (`INSERT … ON DUPLICATE KEY`, `SHA2()`), so it was not tested.

```bash
sudo systemctl start mariadb          # or: sudo service mariadb start
sudo mysql <<'SQL'
CREATE DATABASE psoul CHARACTER SET utf8mb4;
CREATE USER 'psoul'@'localhost' IDENTIFIED BY 'choose-a-local-password';
GRANT ALL PRIVILEGES ON psoul.* TO 'psoul'@'localhost';
FLUSH PRIVILEGES;
SQL

cd server
mysql -u psoul -p psoul < src/schemas/mysql.sql               # stock TFS 0.3.6 schema (29 tables)
mysql -u psoul -p psoul < src/schemas/psoul_extra_mysql.sql   # PSoul tables/columns + world 1 rows
mysql -u psoul -p psoul < src/schemas/psoul_dev_seed.sql      # optional: local admin account
```

Result: 97 tables, `server_config.db_version = 23`. The Database Manager inside the server
(`>> Running Database Manager`) checks `db_version` and would try to upgrade older schemas; with
the shipped `mysql.sql` it has nothing to do.

What the three files are:

* `mysql.sql` — unchanged stock schema from the original package. It creates account `1` with
  password `1` **in plain text**; because `config.lua` uses `encryptionType = "sha256"` that
  account cannot log in and `accountManager = false` keeps it inert. Leave it or delete it.
* `psoul_extra_mysql.sql` — reconstructed from every SQL statement found in `src/*.cpp` and
  `data/**/*.lua`. Every table/column that the server or scripts read is created
  (`CREATE TABLE IF NOT EXISTS` / `ADD COLUMN IF NOT EXISTS`). Each block cites the source file
  that uses it. On MySQL (not MariaDB) `ADD COLUMN IF NOT EXISTS` is not supported: run the
  `ALTER TABLE` blocks once without the `IF NOT EXISTS` clause.
* `psoul_dev_seed.sql` — account `admin` / `admin` (SHA-256), characters **GM Admin** (group 6,
  level 100) and **Tester** (group 1), both with the starting items that the original website
  created on character creation (order icon, badge case, Pokédex, pokebag with 100 poke balls,
  potions, etc.). Without these items the login scripts (`010-pokedex.lua`) raise Lua errors.
  Change the password before exposing the server:
  `UPDATE accounts SET password = SHA2('new-password', 256) WHERE name = 'admin';`

Not available and not reconstructed: the stored procedure `update_rank()` called by
`start.lua` (website-side highscore ranking). It is only called when `updateHighscores = true`;
the shipped configuration has it `false`.

## 4. Configuration

```bash
cd server
cp config.example.lua config.lua      # config.lua is git-ignored; keep the real password there
```

Edit `config.lua`:

| Key | Value for a local run | Notes |
|-----|-----------------------|-------|
| `ip` | `"127.0.0.1"` | advertised in the character list; `bindOnlyConfiguredIpAddress = true` also binds to it |
| `loginPort` / `gamePort` | `7564` / `8548` | original PSoul ports (the client defaults to login port 7564 in `client/modules/client_entergame/entergame.lua`; the game port comes from the character list) |
| `sqlHost` `sqlPort` `sqlUser` `sqlPass` `sqlDatabase` | `localhost` `3306` `psoul` *(secret)* `psoul` | |
| `encryptionType` | `"sha256"` | must match how account passwords were stored |
| `mapName` | `"map"` | loads `data/world/map.otbm` + `map-spawn.xml` + `map-house.xml` |
| `worldId` | `1` | all seed rows use world 1 |

`config.example.lua` is the original `config.lua` with the MOTD/login message translated and
the database credentials left at the original placeholders (`root` / empty password /
`genesis`). The original author's stale IP/dyndns hostname remains in a comment on the `ip`
line for reference.

## 5. Run

```bash
cd server            # must be the CWD: config.lua, data/, pt_br.loc are resolved relatively
./psoul-server       # Ctrl+C or the in-game /shutdown command to stop
```

Expected startup (≈15 s on the test machine, the map alone takes ~6 s):

```
>> Loading config (config.lua)
> Using SHA256 encryption
>> Loading RSA key
>> Starting SQL connection
>> Running Database Manager
>> Loading items … groups … vocations … polls … localization … script systems … chat channels
>> Loading outfits … experience stages … monsters … tournaments
>> Loading map and spawns...
> Map size: 5879x3541.
[Warning - Tournaments::getTournament] Tournament 2 not found.      <- benign, see below
[Error - Npc interface] data/npc/scripts/tournament.lua … (luaGetTournamentInfo) Tournament not found
[Warning - Tournaments::getTournament] Tournament 3 not found.
>> Checking world type... NoN-PvP
>> Initializing game state modules and registering services...
>> Cleaning players online status... Loading PvP Arenas... Caught Highscores... Berry Trees...
>> Loading Bosses...  >> Scheduled Boss Spawn: The Turbo in 3 days, …
>> Loading Ball Pillars... Citizens... SupriseBox... Ranks...
> Global address: 127.0.0.1
> Local ports: 7564	8548
>> All modules were loaded, server is starting up...
>> Cristal server Online!
```

The tournament messages come from `data/XML/tournaments.xml`, where tournament 2 is commented
out and 3 is disabled while `data/npc/scripts/tournament.lua` still asks for them. This is the
original configuration and was left unchanged.

Logs: the engine and the Lua `log()` helper write under `server/logs/` (`admin.log`,
`client_assertions.log`, per-player files); the directory is git-ignored.

## 6. Verifying without the Windows client

`tools/protocol_probe.py` (Python 3, standard library only) implements the PSoul wire protocol
(checksum, RSA, XTEA, challenge, PSoul character-list extras, `0xFF` opcodes) and can log in,
enter the world, say commands, walk, open containers, move items, summon, attack, catch and
talk to NPCs:

```bash
python3 tools/protocol_probe.py login --account admin --password admin
python3 tools/protocol_probe.py enter --account admin --password admin --character "GM Admin" \
  --open 10 --move-to-bag 8 --say "/mypokemon Charizard,50" --move-to-slot 12159:8 --use-slot 8 \
  --say "/m Rattata" --attack "Rattata [" --wait-dead "Rattata [:60" --catch 12157 \
  --wait-text "(Gotcha|ball broke):15"
```

`tools/check_syntax.sh` runs `luac5.1 -p` and `xmllint --noout` over `server/data`.

## 7. Known build-environment caveats

* `cmake` without `CXX=g++` may pick up Clang on some images; Clang was not tested.
* The server binds only `127.0.0.1` by default (`ip`). To accept LAN clients set `ip` to the
  interface address or set `bindOnlyConfiguredIpAddress = false`.
* `__ROOT_PERMISSION__` is enabled so the binary runs inside containers as root. Disable it for
  production.
