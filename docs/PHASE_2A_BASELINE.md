# Phase 2A baseline (before restructuring)

This records the state of the project **before** any Phase 2A change, so that every later change
can be compared against something that was actually measured. All results below were produced on
the Linux development VM (Ubuntu 24.04, GCC 13.3, MariaDB 10.11) from clean scratch build
directories; nothing was taken from older notes.

## 1. Source

| | |
|---|---|
| Commit | `3d9cf7f5865345d23f89f87c32936161d65e0191` "Establish verified playable PSoul baseline" (2026-10-06) |
| Branch | `cursor/phase1-import-psoul-baseline-c0d2` ([PR #1](https://github.com/GIToez/PokeNation/pull/1)) |
| Last green CI | run 37491586132 on `6714bdd` (code identical to `3d9cf7f`; later commits were docs-only and are skipped by `paths-ignore`) |

## 2. Build status

| Component | Command (scratch dir) | Result | Warnings | Output |
|---|---|---|---|---|
| Server | `cmake -S server -B /tmp/bl/server -DCMAKE_BUILD_TYPE=RelWithDebInfo && cmake --build` | exit 0 | 339 | `psoul-server`, 96 MB (with symbols), sha256 `0fdb5cb0…91aa` |
| Legacy client | `cmake -S client/src-cpp -B /tmp/bl/client -DUSE_STATIC_LIBS=ON -DLUAJIT=OFF -DENCRYPTED_ASSETS=OFF` | exit 0 | 1520 | `psoulclient`, 66.8 MB, sha256 `9320d4b1de9f31e86d1c4ecbc8b32bc6817d796ad3b3143c5092ff07ea4259c9` |

The image's default `c++` alternative was broken, so `CC=gcc CXX=g++` had to be exported; the
build scripts now do this themselves. The warnings are inherited (misleading indentation,
deprecated `std::auto_ptr`, unused variables, etc.) and were not changed. Engine modernisation
is out of scope.

### Exact build outputs before restructuring

| | Path before Phase 2A | Path after Phase 2A |
|---|---|---|
| Server binary | `server/psoul-server` (CMake `RUNTIME_OUTPUT_DIRECTORY` = source dir) | `build/<platform>-<type>/server/psoul-server[.exe]` |
| Client binary | `build/client/psoulclient` | `build/<platform>-<type>/client/psoulclient[.exe]` |
| Packages | `dist/PokeNation-{server,client}-{linux,windows}-x64.{tar.gz,zip}` | `dist/<platform>/{server,client}/` + `dist/PokeNation-{Server,LegacyClient}-{Windows,Linux}-Dev.{zip,tar.gz}` + `.sha256` |
| Windows exe names | `PokeNationServer.exe`, `PokeNationClient.exe` | `PokeNationServer.exe`, `PokeNationLegacyClient.exe` |
| CI artifacts | `PokeNation-{server,client}-{linux,windows}-x64` | `PokeNation-Server-{Windows,Linux}`, `PokeNation-LegacyClient-{Windows,Linux}` |

## 3. Database status

- MariaDB 10.11, database `psoul`, user `psoul` (password only in the git-ignored `server/config.lua`).
- Schema: `server/src/schemas/mysql.sql` + `psoul_extra_mysql.sql` + `psoul_dev_seed.sql` → **97 tables**.
- The Phase 2 test database was dumped (outside the repository) and then reset to the seed with
  `tools/setup_database.sh --reset`. A server start on the fresh database printed exactly the same
  output as on the Phase 2 database.

## 4. Local login and gameplay status

| Check | Result |
|---|---|
| `protocol_probe.py login` admin/admin | PASS, characters GM Admin, Tester |
| `protocol_probe.py login` player/player | PASS, character Trainer |
| Wrong password | PASS, rejected |
| GUI client login (Xvfb + xdotool) | PASS: Trainer in Pewter with Charmander in the Pokémon bar (screenshot `phase2a_baseline_gui_login.png`, artifacts only) |
| `tools/smoke_test.py` on a fresh seed DB (new in Phase 2A) | **12/12 PASS**: 3 logins, enter game, Oak starter, summon, attack, moves, kill, catch attempt, return, logout |

## 5. Startup output on a fresh database

The only non-informational lines are:

```
[Warning - Tournaments::getTournament] Tournament 2 not found.
[Error - Npc interface] data/npc/scripts/tournament.lua (luaGetTournamentInfo) Tournament not found
[Warning - Tournaments::getTournament] Tournament 3 not found.
[Error - Npc interface] data/npc/scripts/tournament.lua (luaGetTournamentInfo) Tournament not found
```

These are known bug BUG-20 (tournaments 2/3 are commented out in `XML/tournaments.xml`). Every
startup line is explained in [STARTUP_AUDIT.md](STARTUP_AUDIT.md).

## 6. Known Phase 2 issues carried over

See [BUG_TRIAGE.md](BUG_TRIAGE.md) (BUG-01…BUG-57 from Phase 2; BUG-58…BUG-72 added in Phase 2A). None is P0.
The most visible ones are BUG-20 (tournament warnings), BUG-56 (hard-coded AES key in the client
source) and BUG-57 (client console noise).

New findings while building the smoke test and packaging:

- **BUG-71** (P4, dev seed only): the seed already fills Trainer's bag with the starting kit
  (100 Poke Balls, 100 Cookies, 20 potions, rope, fishing rod), and Professor Oak adds the same
  kit again when he hands out the starter (`doPlayerAddMainItems`,
  `npc/scripts/quest_professorOak.lua:111`). The duplicate lands in the next container with free
  space. The +4 levels on the first login are intended (`creaturescripts/scripts/login.lua:48-59`,
  "Give start items").
- **BUG-72** (P3, inherited TFS 0.3.6): after SIGTERM or `/shutdown` the server saves, prints
  `Preparing to shutdown the server- done.`, and then never exits. `ServiceManager::run()` sets
  `running = true` only after `io_service.run()` returns, so `ServiceManager::stop()` returns
  early (`server/src/server.cpp:213-233`). It is safe to kill the process after the "- done."
  line, and CI does this. Ctrl+C in the server window (SIGINT, not handled) ends the process
  immediately without the shutdown save. Characters are still saved when they log out.

## 7. Test credentials, ports and protocol (development only)

| | |
|---|---|
| Accounts | `admin` / `admin` → GM Admin (group 6), Tester (group 1); `player` / `player` → Trainer |
| Login port | 7564 |
| Game port | 8548 |
| Protocol | 8.54, client version 312 |
| World type | `pvp` |
| Server address | 127.0.0.1 |

These passwords exist only in the development seed. Never use them on a reachable server. Details
are in [LOCAL_DEV_INFO.md](LOCAL_DEV_INFO.md).
