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
| `worldType` | `"pvp"` | **changed from the archive's `"no-pvp"` in Phase 2.** Under `no-pvp` the engine refuses every attack on a creature that has a master before it reaches the NPC-trainer exception (`src/combat.cpp:313` vs `322-326`), so NPC/gym battles cannot be won. Player-vs-player stays blocked by `combat.cpp:272-284` (duels/arena only), so `pvp` is behaviour-neutral for players. See `BUG_TRIAGE.md` BUG-01. |

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

Further actions added in Phase 2 (run `python3 tools/protocol_probe.py enter --help` for the
full list): `--approach NAME` walks next to an NPC and faces it, `--npc TEXT` talks in the NPC
channel, `--use-item SID` uses an item from an open container, `--use-on SID:NAME` uses it on a
creature, `--use-on-slot SID:SLOT` on an equipped item (TMs, held items, vitamins on the ball in
slot 8), `--use-on-tile SID:self[:STACK]` on your own tile (order icon 7730 = Ride/Fly/Dive; an
explicit stackpos targets an item lying on the tile, e.g. an incubator on a dropped egg),
`--drop SID` drops an item from a container, `--use-corpse` opens the corpse of the last
`--wait-dead` target, `--raw HEX` sends an arbitrary packet (e.g. `98 c1 01` opens channel 449,
Wiki Chat). Use `python3 -u` so the transcript streams. Note that logging in with the probe on
an account whose character is open in the GUI client kicks that session
(`replaceKickOnLogin = true`); use the `admin` account for the probe and `player` for the GUI.
GM characters have infinite mana, which PSoul uses as Pokémon energy, so **GM Pokémon cannot use
moves** – run move tests as `Trainer`/`Tester` (BUG-05).

`tools/check_syntax.sh` runs `luac5.1 -p` and `xmllint --noout` over `server/data`.

## 7. Known build-environment caveats

* `cmake` without `CXX=g++` may pick up Clang on some images; Clang was not tested.
* The server binds only `127.0.0.1` by default (`ip`). To accept LAN clients set `ip` to the
  interface address or set `bindOnlyConfiguredIpAddress = false`.
* `__ROOT_PERMISSION__` is enabled so the binary runs inside containers as root. Disable it for
  production.
* Boost ≥ 1.87 (MSYS2, recent distributions) removed `boost::asio::io_service`,
  `io_context::post/dispatch` and `address_v4::from_string`; `connection.*` / `server.*` were
  ported to `io_context`, `boost::asio::post/dispatch`, `make_address_v4` and `steady_timer`
  (all available since Boost 1.66, so Boost 1.83 on Ubuntu 24.04 still works).
* libxml2 ≥ 2.12 returns `const xmlError*` from `xmlGetLastError()` (`tools.cpp`).

## 8. LOCAL DEVELOPMENT QUICK START

Everything below runs on one Linux machine (Ubuntu 24.04 was used). All commands are run
from the repository root. The scripts in `tools/` are thin wrappers around the manual steps in
sections 1–5; read them if something fails.

### 8.1 One-time setup

```bash
# 1. dependencies (server + client + database + checks)
sudo apt-get install -y build-essential cmake pkg-config lua5.1 libxml2-utils git-lfs \
  libboost-system-dev libboost-filesystem-dev libboost-thread-dev libboost-regex-dev libboost-chrono-dev \
  liblua5.1-0-dev libxml2-dev libgmp-dev libmysqlclient-dev libsqlite3-dev libssl-dev \
  libphysfs-dev libopenal-dev libglew-dev libvorbis-dev libogg-dev zlib1g-dev \
  libgl1-mesa-dev libglu1-mesa-dev libx11-dev mariadb-server mariadb-client python3

# 2. large assets (map.otbm 130 MB, data.spr 308 MB) are in Git LFS
git lfs install && git lfs pull

# 3. compile both programs (≈3 min server, ≈6 min client on 4 cores)
tools/build_server.sh          # -> server/psoul-server  (+ build/server/)
tools/build_client.sh          # -> build/client/psoulclient

# 4. database: starts MariaDB, creates db "psoul" + user "psoul", imports the three schema
#    files, writes server/config.lua (git-ignored) with the generated credentials
export PSOUL_DB_PASS='choose-a-local-password'   # optional; default "psoul-dev"
tools/setup_database.sh                          # add --reset to wipe and re-import
```

### 8.2 Every session

Open three terminals (or run the first two in the background):

| Step | Command | Wait for |
|------|---------|----------|
| Database | `tools/start_database.sh` | `Database is up` |
| Server | `tools/start_server.sh` | `>> Cristal server Online!` (≈15 s; the map takes ~6 s) |
| Client | `tools/start_client.sh` | the PSoul login window |

`tools/start_server.sh` refuses to start when `config.lua` is missing, the LFS map was not
pulled, the database is unreachable, or port 7564 is already taken. `tools/start_client.sh`
needs `DISPLAY`; on machines without a sound card it sets `ALSOFT_DRIVERS=null` automatically.

Windows: the GitHub Actions packages (section 9) contain `setup_database.bat`,
`start_database.bat`, `start_server.bat` and `start_client.bat` with the same roles.

### 8.3 Test credentials (development only — never reuse on a public server)

| Account / password | Character | Group | Starts at | Purpose |
|--------------------|-----------|-------|-----------|---------|
| `admin` / `admin` | **GM Admin** | 6 (GM) | Pewter City temple (3307,300,7) | GM commands; has order icon, badge case, Pokédex, Pokébag with 100 poke balls / cookies / potions |
| `admin` / `admin` | **Tester** | 1 (player) | Pewter City temple | plain player with the same startup items, no Pokémon |
| `player` / `player` | **Trainer** | 1 (player) | Tutorial town temple (5000,806,6) | plain player that walks to Professor Oak (5020,788,7) and receives the starter Pokémon exactly like a new character |

Passwords are stored as `SHA2(…, 256)` in `accounts.password`; change them with
`UPDATE accounts SET password = SHA2('new', 256) WHERE name = 'admin';`. These are **not** the
original production passwords (none are in the repository).

The two accounts are deliberately separate so a GM and a player can be online at the same
time (`replaceKickOnLogin = true` kicks an earlier session of the *same account*).

Getting a Pokémon:

* **Trainer**: talk to Professor Oak — `hi` → `charmander` (or `squirtle`, `bulbasaur`) →
  `yes` → `male`/`female`. Oak hands over a level-5 Pokémon in a soul ball plus the main items
  (100 poke balls, 100 cookies, 20 potions, rope, old fishing rod). On the first login the
  server also grants +4 levels and opens the tutorial.
* **GM Admin**: `/mypokemon Charmander,10` (optional 3rd/4th argument: extra points, egg move).
  The ball appears in the Pokébag; click the Pokémon's icon in the Pokémon bar to summon it.

Useful GM commands (full list: `server/data/talkactions/talkactions.xml`):
`/i <itemid>,<count>` · `/m <Monster>` (`/m Rattata,Trainer` spawns next to another player) ·
`/goto x,y,z` or `/goto Name` · `/send Name;x,y,z` · `/r` (remove the thing you face) ·
`/attr`, `/addskill`, `/promote`, `/closeserver`, `/shutdown`.

Known limitation: GM groups 4–6 carry `PlayerFlag_HasInfiniteMana`, and PSoul maps Pokémon
energy onto the trainer's mana, so **GM Pokémon can never use moves** ("Sorry, your Pokemon has
insufficient energy"). Test moves with Tester or Trainer, or temporarily remove flag bit 10
from the group in `data/XML/groups.xml` (not done in the repository).

### 8.4 Ports and addresses

| What | Value | Where |
|------|-------|-------|
| Login server | `127.0.0.1:7564` | `server/config.lua` `loginPort`; client `modules/client_entergame/entergame.lua` |
| Game server | `127.0.0.1:8548` | `server/config.lua` `gamePort`; sent to the client in the character list (`ip = "127.0.0.1"`) |
| Database | `127.0.0.1:3306` | `server/config.lua` `sqlHost`/`sqlPort` |
| Client protocol version | 312 (PSoul custom id on an 8.54 protocol) | `client/modules/gamelib/protocollogin.lua:38`, `client/src-cpp/src/client/protocolgamesend.cpp:57`; server `src/resources.h` (details: `docs/LOCAL_CLIENT_TESTING.md`) |

### 8.5 Expected console messages

Server (abridged, full list in section 5):

```
>> Loading config (config.lua)           > Using SHA256 encryption
>> Starting SQL connection               >> Running Database Manager
>> Loading map and spawns...             > Map size: 5879x3541.
[Warning - Tournaments::getTournament] Tournament 2 not found.   <- benign (tournaments.xml)
[Error - Npc interface] data/npc/scripts/tournament.lua ...        <- same cause, benign
>> Cristal server Online!
```

Client (`tools/start_client.sh` prints to the terminal):

```
Loaded module 'game_interface' … Loaded module 'game_guide'        (48 modules)
WARNING: widget 'tab' destroyed but still have 1 reference(s) left   <- harmless
```

In game, a normal player sees on first login: the MOTD box, "Welcome to Genesis World! …",
the Wiki Chat and Help channels opening by themselves, and the Wiki Chat bot greeting.

### 8.6 Common problems

| Symptom | Cause / fix |
|---------|-------------|
| `server/data/world/map.otbm is an LFS pointer` | `git lfs install && git lfs pull` |
| `ERROR 1064 … near 'IF NOT EXISTS'` while importing `psoul_extra_mysql.sql` | you are on MySQL, not MariaDB. Either install MariaDB or strip `IF NOT EXISTS` from the `ALTER TABLE` blocks |
| `ERROR 1419 … SUPER privilege and binary logging` while importing `mysql.sql` | MySQL 8 with binlog: import as root or `SET GLOBAL log_bin_trust_function_creators = 1` |
| `Cannot connect to database 'psoul' as 'psoul'` | password in `server/config.lua` differs from the one used by `setup_database.sh`; re-run with the same `PSOUL_DB_PASS` or edit `config.lua` |
| `Port 7564 already in use` | a previous server is still running (`pkill -x psoul-server`) |
| client aborts immediately with an OpenAL error | no sound device; `ALSOFT_DRIVERS=null tools/start_client.sh` |
| client shows the login window but "Connection failed" | server not yet `Online`, or `ip` in `config.lua` is not `127.0.0.1` |
| character list is empty after login | the account has no characters in **world 1**, or `players.deleted = 1` |
| `First get your Pokemon.` on `/exp`, moves, `/find` | Pokémon return to their ball on logout; summon it again (Pokémon bar icon) |
| GM Pokémon: `Sorry, your Pokemon has insufficient energy` | infinite-mana GM flag, see 8.3 |
| `You do not have enough access to deal here!` at a soul-trade NPC | that NPC requires Orange Archipelago access; use Richard (4733,129,7) or another unrestricted one |
| move/Pokémon bars overlap at the bottom of the map | default layout; both windows are draggable (right-click toggles vertical) |
| a plain player standing outside a protection zone dies instantly | wild Pokémon hit trainers; always have a Pokémon out (level-5 trainers have 50 HP) |

## 9. For non-developers: downloading and running a build

Every push to the repository (except documentation-only changes) runs
`.github/workflows/build.yml`, which compiles the server and the client **from this
repository's source** on Linux and on Windows (MSYS2 MinGW-w64) and uploads four packages as
workflow artifacts (kept 14 days):

| Artifact | Contents |
|----------|----------|
| `PokeNation-server-windows-x64` | `PokeNationServer.exe`, required DLLs, `data/`, `src/schemas/*.sql`, `config.example.lua`, `setup_database.bat`, `start_database.bat`, `start_server.bat` |
| `PokeNation-client-windows-x64` | `PokeNationClient.exe`, DLLs, `data/`, `modules/`, `init.lua`, `start_client.bat` |
| `PokeNation-server-linux-x64` | `psoul-server` + the same payload with `.sh` scripts |
| `PokeNation-client-linux-x64` | `psoulclient` + client payload |

None of the original archive's precompiled executables are used or shipped. Generated binaries
are not committed to Git; they exist only as workflow artifacts.

Steps:

1. Open the repository on GitHub → **Actions** → the latest green run of *Build development
   packages* → scroll to **Artifacts** and download the server and client zip for your OS
   (a GitHub login is required to download artifacts).
2. Unpack both zips into separate folders.
3. Install MariaDB (Windows: the MariaDB MSI installer, remember the root password). Then run
   `setup_database.bat` once in the server folder; it asks for the root password, creates the
   `psoul` database and user, imports the schemas and writes `config.lua`.
4. Run `start_server.bat` and wait for `>> Cristal server Online!`.
5. Run `start_client.bat` in the client folder, log in with one of the development accounts
   from section 8.3 (`admin`/`admin` or `player`/`player`).

If the Windows job of the workflow is red, no Windows artifacts exist for that commit; use the
most recent green run or the Linux packages. The job status is visible on the PR's checks.

What is **not** in the packages: the PHP website (account creation, shop, polls, highscores
ranking), so new accounts/characters must be inserted with SQL
(`src/schemas/psoul_dev_seed.sql` shows the required rows and starter items).
