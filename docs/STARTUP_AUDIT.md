# Server startup audit

Every line the server prints between launch and `>> Cristal server Online!` was reviewed on a
**fresh database** (seed only), on Linux (local VM and CI) and on Windows (CI). Lines are grouped
by type. The only warnings or errors are the four tournament lines (BUG-20), and they are harmless.

Reproduce: `tools/init_dev_database.sh --reset && tools/start_server.sh`. To list only the
problems, run `grep -nE 'Warning|Error' <log>`.

## 1. Banner

| Line | Source | Verdict |
|---|---|---|
| `Unknown, version Unknown (Unknown)` | `STATUS_SERVER_NAME/VERSION/CODENAME` = `"Unknown"` in `server/src/resources.h:83-85` (inherited) | Cosmetic. The real version is in `version.json` / `VERSION.txt` of the package. Not changed: the same strings are sent in the status protocol. |
| `Compiled with GNU C++ version … at <date>` | `otserv.cpp` | Informational. Confirms the binary was compiled from this repository. |
| `A server developed by Elf, slawkens, …` | TFS 0.3.6 credits | Informational. |

## 2. Loading sequence

| Line | Verdict |
|---|---|
| `>> Loading config (config.lua)` | OK. If it is missing, the server exits with "Unable to load config.lua", and the start launchers check for this first. |
| `> Using SHA256 encryption` | OK. `encryptionType = "sha256"`, matching the seed passwords. |
| `>> Loading RSA key` | OK. This is the standard OTServ key, matching the client's key (`client/modules/gamelib/const.lua`). |
| `>> Starting SQL connection` | OK. If MariaDB is down or the password is wrong, this line is followed by a MySQL error and the server exits. |
| `>> Running Database Manager` | OK. On a fresh seed DB there are no pending schema updates. |
| `>> Loading items` … `>> Loading monsters` | OK, no warnings. |
| `>> Loading tournaments` + two `> Broadcasted message: "The … tournament … will begin in N hours!"` | OK. The tournament scheduler (`tournaments.cpp`) announces the next tournaments in a global broadcast that is also echoed to the console (`game.cpp:5767`). This is expected behaviour, not an error. |
| `>> Loading map and spawns...` / `> Map size: 5879x3541.` / map descriptions `"Saved with Remere's Map Editor 1.1.9"` | OK. Map loading takes ~7 s. If `map.otbm` is a Git LFS pointer, loading fails here (all launchers check this beforehand). |

## 3. Warnings and errors

| Line | Classification | Explanation |
|---|---|---|
| `[Warning - Tournaments::getTournament] Tournament 2 not found.` | KNOWN BUG (BUG-20, P4) | Tournaments 2 and 3 are commented out in `data/XML/tournaments.xml:25-66`. `data/npc/scripts/tournament.lua:21-30` asks for ids 1-3 while loading NPC Joey. |
| `[Error - Npc interface] data/npc/scripts/tournament.lua … (luaGetTournamentInfo) Tournament not found` | KNOWN BUG (BUG-20) | The same lookup, reported again by the Lua binding. Joey lists only the "Titan" tournament because `ipairs` stops at the gap. |
| The same two lines for tournament 3 | KNOWN BUG (BUG-20) | As above. |

This was not fixed in Phase 2A, because the phase only restructures the project. The fix is to
either re-enable the two tournaments or make `tournament.lua` skip missing ids.

## 4. Post-map initialisation

`Data parsing time`, `Houses synchronization time`, `Content unserialization time`,
`Checking world type... PvP`, `Cleaning players online status`, `Loading PvP Arenas`,
`Caught Highscores`, `Tournament Highscores`, `Berry Trees`, `Cleaning Mastery Dungeons`,
`Loading Bosses` + `Scheduled Boss Spawn: DoomBoy in …`, `Highscores`, `Ball Pillars`,
`Citizens`, `SupriseBox` (sic, inherited spelling), `Ranks`: all are informational, from the PSoul
startup modules in `data/lib/ps/systems/`. `Loading Citizens` rewrites
`data/npc/tmpCitizen_*.xml`, which is why those files are git-ignored and excluded from packages.

## 5. Network

| Line | Verdict |
|---|---|
| `> Global address: 127.0.0.1` | OK. From `ip = "127.0.0.1"` in `config.lua`. For LAN testing, set your LAN IP (see LOCAL_DEV_INFO.md). |
| `> Local ports: 7564 8548` | OK. Login and game ports. If a port is taken, the server prints a bind error, and the launchers check this first. |
| `>> All modules were loaded, server is starting up...` / `>> Cristal server Online!` | Ready. `Cristal` is `serverName` in `config.lua`. CI and `tools/smoke_test.py` wait for `^>> Cristal server Online`. |

## 6. Runtime messages seen during the smoke test

`Trainer has logged in.` / `… has logged out.` are normal. No warnings were printed during the
12-step gameplay smoke test.

## 7. Not printed by the server, but seen by players

- The HELP channel greeting links to `http://www.pokenordic.com/blogCategories/1-tutorials`
  (`data/lib/ps/events/creaturescripts/onJoinChannel.lua:85`). This is WEBSITE-DEPENDENT: the
  original project's site, which is presumably offline. It is harmless.
- The legacy client's "Create account" / "Lost account" buttons open pokenordic.com
  (`client/modules/client_entergame/entergame.otui:72,79`). This is WEBSITE-DEPENDENT. Development
  accounts come from the SQL seed instead.

## 8. Windows

The Windows CI job starts the packaged `PokeNationServer.exe` against a fresh MariaDB database and
prints every `Warning|Error` line at the end of the smoke-test step. The lines are the same
as on Linux: the BUG-20 tournament and NPC-interface lines, nothing Windows-specific.

The client's Windows start-up log matches the Linux one (48 modules, ending with
`Loaded module 'game_guide'`), with two additions:

- `ERROR: unable to open audio device` appears on machines without a sound device; the client
  continues.
- `ERROR: loading texture with size 1920x1080 failed, the maximum size allowed by the graphics card is 1024x1024`
  means the renderer is too limited for the animated background. The client crashes a few seconds
  later (BUG-73).

See the "Windows runtime evidence" section of [PHASE_2A_REPORT.md](PHASE_2A_REPORT.md).
