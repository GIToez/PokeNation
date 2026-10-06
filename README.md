# PokeNation

PokeNation starts from the **PSoul / PokeAimar** Pokémon MMORPG (a 2014-2016 Open Tibia project).
The original server and client source was imported, audited, translated to English, made to
compile with current toolchains, and verified to be playable on a local machine. Version:
see [`VERSION`](VERSION). Status: **development baseline** (Phase 2A: clean build and
distribution). No new gameplay has been added yet.

> **`/client` is the frozen legacy PSoul/PokeAimar reference client.** It is built and shipped
> only so that the server can be tested exactly as the original was played. Its gameplay, UI and
> protocol code are not changed. See [docs/LEGACY_CLIENT_REFERENCE.md](docs/LEGACY_CLIENT_REFERENCE.md).

## Architecture

```
 PokeNationLegacyClient (OTClient 0.6 fork, C++ + Lua UI)
        │  Tibia 8.54 protocol, client version 312, RSA + XTEA,
        │  PSoul extensions on opcode 0xFF (Pokémon bar, moves, Pokédex …)
        ▼
 PokeNationServer (TFS 0.3.6 "Crying Damson" fork, C++ engine + ~3000 Lua scripts)
        │  login 7564 / game 8548
        ▼
 MariaDB  (database "psoul", 97 tables)
```

## Repository layout

| Folder | Contents | In Git? |
|---|---|---|
| `/server` | server C++ source (`src/`), game content (`data/`: Lua, XML, map via LFS), `config.example.lua`, SQL schemas (`src/schemas/`) | yes |
| `/client` | frozen legacy client: C++ source (`src-cpp/`), Lua UI (`modules/`), assets (`data/`, sprites via LFS) | yes |
| `/original` | untouched reference copy of the imported archive's sources (no executables) | yes |
| `/tools` | build, package, database, test and analysis scripts | yes |
| `/docs` | reports, guides, references, tutorials | yes |
| `/build` | compiler output only: `build/<platform>-<type>/{server,client}` | **no** (ignored) |
| `/dist` | packaged builds: `dist/windows/{server,client}`, `dist/linux/…`, `dist/debug/…`, archives + `.sha256` | **no** (ignored) |

Large binary assets (`*.otbm`, `*.spr`, `*.psd`) are stored in **Git LFS**. Run
`git lfs install && git lfs pull` after cloning.

## Quick start on Windows (no programming needed)

1. Install [MariaDB](https://mariadb.org/download/) (keep "Install as service").
2. Download the artifacts **`PokeNation-Server-Windows`** and **`PokeNation-LegacyClient-Windows`**
   from the newest green run of **Actions → "Build development packages"**, and extract both zips
   into the same folder.
3. Double-click `server\Setup-PokeNation-Database.bat` (once).
4. Double-click `server\Start-PokeNation-Local.bat`, or start `Start-PokeNation-Server.bat` and
   then `client\Start-PokeNation-Client.bat`.
5. Log in with `player` / `player` (character Trainer) or `admin` / `admin` (GM Admin, Tester).

Full guide with expected output and troubleshooting: **[docs/WINDOWS_LOCAL_TESTING.md](docs/WINDOWS_LOCAL_TESTING.md)**.

Build it yourself on Windows: install [MSYS2](https://www.msys2.org/) and run
`powershell -ExecutionPolicy Bypass -File tools\windows\Build-PokeNation-Windows.ps1 -InstallDependencies`.
On Linux: `tools/build_server.sh && tools/build_client.sh && tools/package.sh all`. See
[docs/BUILDING.md](docs/BUILDING.md).

## Build artifacts (GitHub Actions)

| Artifact | Contents |
|---|---|
| `PokeNation-Server-Windows` | `PokeNation-Server-Windows-Dev.zip` + `.sha256`: `PokeNationServer.exe`, DLLs, `data/`, schemas, launchers |
| `PokeNation-LegacyClient-Windows` | `PokeNation-LegacyClient-Windows-Dev.zip` + `.sha256`: `PokeNationLegacyClient.exe`, DLLs, `data/`, `modules/` |
| `PokeNation-Server-Linux` / `PokeNation-LegacyClient-Linux` | the same for Linux (`.tar.gz`) |

Every executable is compiled from this repository. The original archive's precompiled `.exe`
and `.dll` files are never used or redistributed. Artifacts are development builds kept for 14
days. There are no public releases.

## Local development info

| | |
|---|---|
| Address / ports | `127.0.0.1`, login **7564**, game **8548** |
| Protocol | 8.54 layout, client version **312** |
| Database | MariaDB, database `psoul`, user `psoul` (password only in your local `config.lua`) |
| Accounts (dev only) | `admin`/`admin`, `player`/`player` |

All details, including characters, executables and start order: [docs/LOCAL_DEV_INFO.md](docs/LOCAL_DEV_INFO.md).

## Feature status (summary)

From [docs/reference/FEATURES.md](docs/reference/FEATURES.md) (≈110 systems). **Verified
working** on the local server (Phase 2 test matrix): login and character list, starter Pokémon,
call/return, catching, leveling, faint/revive, Pokémon Center, evolution, nicknames, status
conditions, moves and cooldowns, TMs, held items, vitamins, eggs, ride, fly, wild battles,
quests, bank. **Partial**: Pokédex, NPC trainer battles, tournaments, markets, hunger, autoloot,
premium shop (website-dependent). About half of all systems are **implemented but unverified**.
Known bugs: [docs/BUG_TRIAGE.md](docs/BUG_TRIAGE.md). Nothing is listed as working just because
the code exists.

## Documentation

| Topic | Document |
|---|---|
| Building, packaging, non-developer download guide | [docs/BUILDING.md](docs/BUILDING.md) |
| Windows local testing (step by step) | [docs/WINDOWS_LOCAL_TESTING.md](docs/WINDOWS_LOCAL_TESTING.md) |
| Developer handbook | [docs/DEVELOPER_HANDBOOK.md](docs/DEVELOPER_HANDBOOK.md) |
| Tutorials (add a Pokémon, move, item, NPC, quest …) and checklists | [docs/tutorials/](docs/tutorials/README.md) |
| Commands (talkactions) | [docs/reference/COMMANDS.md](docs/reference/COMMANDS.md) |
| Reference catalogs | [Pokémon](docs/reference/POKEMON.md) · [Moves](docs/reference/MOVES.md) · [Poké Balls](docs/reference/POKEBALLS.md) · [Items](docs/reference/ITEMS.md) · [NPCs](docs/reference/NPCS.md) · [Quests](docs/reference/QUESTS.md) · [Achievements](docs/reference/ACHIEVEMENTS.md) · [Opcodes](docs/reference/OPCODES.md) · [Database](docs/reference/DATABASE.md) |
| Full source audit (status of every system) | [docs/FULL_SOURCE_AUDIT.md](docs/FULL_SOURCE_AUDIT.md) |
| Broken references | [docs/BROKEN_REFERENCES.md](docs/BROKEN_REFERENCES.md) |
| Server startup messages explained | [docs/STARTUP_AUDIT.md](docs/STARTUP_AUDIT.md) |
| Legacy client reference | [docs/LEGACY_CLIENT_REFERENCE.md](docs/LEGACY_CLIENT_REFERENCE.md), [docs/LOCAL_CLIENT_TESTING.md](docs/LOCAL_CLIENT_TESTING.md) |
| Security audit | [docs/SECURITY_AUDIT.md](docs/SECURITY_AUDIT.md) |
| Troubleshooting | [WINDOWS_LOCAL_TESTING.md §7](docs/WINDOWS_LOCAL_TESTING.md#7-troubleshooting), [BUILDING.md](docs/BUILDING.md) |
| Phase reports | [Phase 1](docs/PHASE_1_REPORT.md) · [Phase 2](docs/PHASE_2_REPORT.md) · [Phase 2 test matrix](docs/PHASE_2_TEST_MATRIX.md) · [Phase 2A baseline](docs/PHASE_2A_BASELINE.md) · [Phase 2A report](docs/PHASE_2A_REPORT.md) |

## Licences

Server engine: The Forgotten Server, GNU GPLv3 (`server/src/doc/LICENSE`). Client: OTClient, MIT
(`client/LICENSE`). Game content and art belong to their original authors (PSoul/PokeAimar);
Pokémon is a trademark of Nintendo / Game Freak / The Pokémon Company. This is a non-commercial
preservation and development project.
