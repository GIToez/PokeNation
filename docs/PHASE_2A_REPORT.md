# Phase 2A report: clean development and distribution

Phase 2A prepares the PSoul baseline for clean development and distribution. It adds no new
gameplay, migrates nothing to Redemption, and modernises no engine code. The starting point is
recorded in [PHASE_2A_BASELINE.md](PHASE_2A_BASELINE.md).

## 1. Summary

| Area | Result |
|---|---|
| Source / build / dist separation | Done. Binaries are only in `build/<platform>-<type>/`, packages only in `dist/`, both ignored. The server no longer writes its binary into `server/` |
| Build and package scripts | `tools/build_*`, `tools/package*.sh`, `tools/windows/Build-PokeNation-Windows.ps1`. Every script fails with a clear message |
| Packages | `PokeNation-Server-{Windows,Linux}-Dev`, `PokeNation-LegacyClient-{Windows,Linux}-Dev` + `.sha256`, `version.json` |
| Linux runtime | **Verified locally and in CI.** The packaged, stripped server passes the 12-step gameplay smoke test on a fresh DB; the packaged client logs in and renders the world |
| Windows build | **Verified in CI** (GitHub `windows-latest`, Windows Server 2025, MSYS2 MINGW64, GCC 16.2.0). `Build-PokeNation-Windows.ps1` builds both programs and writes both zips with `.sha256` |
| Windows runtime | **Server verified in CI** on every build: the packaged launchers set up MariaDB, `PokeNationServer.exe` starts and passes the gameplay smoke test. **Client: crashes as shipped on the GPU-less runner** (BUG-73, texture larger than the 1024x1024 software-OpenGL limit). With Mesa's software OpenGL (llvmpipe) next to it, the same client runs and shows its first screen. **On a real Windows PC with a GPU** (user report with screenshot) the client logged in and played: in game at Professor Oak, a quest running, a battle fought. Using Headbutt stopped it with an assertion dialog (BUG-75, fixed) |
| Docs | README navigation page, baseline, audit, startup audit, client reference, Windows guide, dev info, handbook, 25 tutorials + checklists, reference catalogs, broken references |
| New bugs | BUG-58…BUG-75 in [BUG_TRIAGE.md](BUG_TRIAGE.md). BUG-58…BUG-73 not fixed (out of scope); BUG-74 (Windows database setup) and BUG-75 (client assertion on jump moves), both found on a real PC, fixed |

## 2. Requirement checklist

| # | Requirement | Status | Where |
|---|---|---|---|
| 1 | Baseline document | done | [PHASE_2A_BASELINE.md](PHASE_2A_BASELINE.md) |
| 2 | Fresh full source audit | done | [FULL_SOURCE_AUDIT.md](FULL_SOURCE_AUDIT.md) (corrections in §16) |
| 3 | `/build` and `/dist` separation | done | [BUILDING.md §9.1](BUILDING.md) |
| 4 | `.gitignore` hygiene | done. Only `server/settings.sav` is tracked and also ignored (inherited, documented, never packaged). No build output or archive is tracked outside `original/` | `.gitignore`, §4 below |
| 5 | Server package | done | `tools/package.sh server` |
| 6 | Legacy client package | done | `tools/package.sh client` |
| 7 | Legacy client reference + README note | done | [LEGACY_CLIENT_REFERENCE.md](LEGACY_CLIENT_REFERENCE.md), README |
| 8 | Reproducible build scripts | done | [BUILDING.md §9.2](BUILDING.md) |
| 9 | GitHub Actions (builds, validation, packaging, artifacts, no Release) | done | `.github/workflows/build.yml`, §5 below |
| 10 | `VERSION` / `version.json` | done | `VERSION`, [BUILDING.md §9.4](BUILDING.md) |
| 11 | SHA-256 checksums | done | [BUILDING.md §9.5](BUILDING.md) |
| 12 | Debug vs release | done (`development` recommended) | [BUILDING.md §9.3](BUILDING.md) |
| 13 | Database package, `init_dev_database` | done (MariaDB only) | `tools/init_dev_database.sh`, `Setup-PokeNation-Database.ps1` |
| 14 | Windows ready-to-run folders | done. Server folder verified in CI; client folder built, but it crashes on a GPU-less machine (BUG-73, §6) | `dist/windows/{server,client}/` (CI artifacts) |
| 15 | Windows launchers with checks | done. Checks verified in CI where noted in §6 | `tools/package-files/windows/` |
| 16 | Windows testing guide | done | [WINDOWS_LOCAL_TESTING.md](WINDOWS_LOCAL_TESTING.md) |
| 17 | Local dev info | done | [LOCAL_DEV_INFO.md](LOCAL_DEV_INFO.md) |
| 18 | Root README | done | [README.md](../README.md) |
| 19 | Commands reference | done (94 active entries with status, 18 disabled listed separately) | [reference/COMMANDS.md](reference/COMMANDS.md) |
| 20 | Features reference | done | [reference/FEATURES.md](reference/FEATURES.md) |
| 21 | Developer handbook | done | [DEVELOPER_HANDBOOK.md](DEVELOPER_HANDBOOK.md) |
| 22 | Tutorials | done | [tutorials/](tutorials/README.md) |
| 23 | Content checklists | done | [tutorials/CHECKLISTS.md](tutorials/CHECKLISTS.md) |
| 24 | Reference catalogs from source | done (`tools/gen_reference.py`, reproducible) | [reference/](reference/) |
| 25 | Broken references | done (`tools/check_references.py --strict` in CI) | [BROKEN_REFERENCES.md](BROKEN_REFERENCES.md) |
| 26 | Startup audit | done | [STARTUP_AUDIT.md](STARTUP_AUDIT.md) |
| 27 | Windows smoke test | done for the server (every CI build). Client start tested in CI: crashes as shipped (BUG-73), runs with Mesa llvmpipe | §6 |
| 28 | Non-developer section in BUILDING.md | done | [BUILDING.md §10](BUILDING.md) |

## 3. Verification performed (Linux, local)

| Check | Result |
|---|---|
| `tools/build_server.sh`, `tools/build_client.sh` (new output paths) | exit 0; `build/linux-development/server/psoul-server` (96 MB unstripped), `build/linux-development/client/psoulclient` (67 MB) |
| `tools/package.sh all` | `dist/linux/{server,client}`, server binary stripped to 4.5 MB, client to 15.9 MB; archives 42 MB / 187 MB + `.sha256` |
| Packaged `start_server.sh` checks | caught a port already in use by a leftover server (correct `[FAIL]`); after the fix, all `[ OK ]` |
| Packaged server, fresh seed DB | online after 14 s; startup output identical to the baseline (only BUG-20 lines) |
| `tools/smoke_test.py` against the packaged server, fresh DB each run | 6 runs with the final Magikarp opponent: 5 × **12/12**, 1 × Charmander fainted (now reported as SKIP, exit 2). Earlier opponents: Rattata and Caterpie each knocked Charmander out in some runs |
| Packaged client (`start_client.sh`) | 48 modules loaded; GUI login as `player` → Trainer in the world, Charmander in the Pokémon bar (screenshot `phase2a_packaged_linux_client_ingame.png`) |
| `tools/check_syntax.sh` | 2998 Lua / 2391 XML, 0 errors |
| `tools/check_references.py --strict` (also on a clean clone without LFS) | 0 unallowlisted REAL ERRORs |
| `tools/gen_reference.py` re-run | output identical apart from the commit stamp |

Problems found and fixed while verifying:

- `config.lua` has CRLF line endings, so the Linux launcher read `3306\r` as the port. The value
  is now stripped.
- `check_references.py` read the local `config.lua` and needed the LFS map. It now uses
  `config.example.lua` and falls back to the known spawn and house names.
- The old `.gitignore` patterns `core` / `core.*` matched the client's `framework/core/` source
  directory. They are now anchored.
- The server ignores SIGINT when started in the background and never exits after SIGTERM
  (BUG-72). CI now stops it explicitly.
- The smoke test's wild battle was flaky. Wild levels are rolled between the monster XML's
  `minLevel` and `maxLevel`, so a Rattata or a level-9 Caterpie could knock the level-5 starter
  out. The opponent is now Magikarp (levels 1-5). The fight is still random, so a fainted starter
  is reported as `[SKIP]` with exit code 2 instead of a failure, and CI retries once on a fresh
  database.
- The first version of the Windows client check reported success although the client had
  crashed (PowerShell returned the log lines as part of the function result). Fixed; the check
  now records the exit code and a screenshot.

## 4. Repository hygiene

- `git ls-files -ci --exclude-standard` (tracked but ignored) outside `original/`: only
  `server/settings.sav`. It is an inherited RME/IDE settings file with the original developer's
  Windows paths, is not read by the source, and is excluded from packages. It is kept for
  provenance.
- No `*.exe`, `*.dll`, `*.zip`, `*.rar`, `*.7z`, object files or logs are tracked outside
  `original/`, which is the untouched reference copy.
- Git LFS rules (`*.otbm`, `*.spr`, `*.psd`) unchanged. `*.ps1` added to the CRLF rules.
- No history rewritten. The original archive is not in Git.

## 5. CI

`.github/workflows/build.yml` has three jobs:

- `validate`: syntax and references.
- `linux`: build, package, packaged server smoke test, packaged client under Xvfb.
- `windows`: build and package via `Build-PokeNation-Windows.ps1`, MariaDB, the packaged
  launchers, and the server smoke test.

Artifacts are `PokeNation-Server-Windows`, `PokeNation-LegacyClient-Windows`,
`PokeNation-Server-Linux`, `PokeNation-LegacyClient-Linux` and the `logs-*` artifacts. No
Release is created.

Results on this branch (all jobs green unless noted):

| Run | Commit | Linux smoke | Windows smoke | Windows client |
|---|---|---|---|---|
| [37505394395](https://github.com/GIToez/PokeNation/actions/runs/37505394395) | `a43d4ee` | 10/12 (Rattata knocked Charmander out) → job failed | 12/12 | 48 modules, then exit (not detected by the old check) |
| [37510656252](https://github.com/GIToez/PokeNation/actions/runs/37510656252) | `3b119f0` | starter fainted → SKIP warning | starter fainted → SKIP warning | `0xC0000374` after 2 s (check still broken) |
| [37513558891](https://github.com/GIToez/PokeNation/actions/runs/37513558891) | `3245d7a` | attempt 1 SKIP, attempt 2 **12/12** | **12/12** | as shipped `0xC0000374`; Mesa d3d12 driver `0x80070057` |
| [37516068648](https://github.com/GIToez/PokeNation/actions/runs/37516068648) | `3f9c5f3` | **12/12** | **12/12** | gdb backtraces (§6) |
| [37518468969](https://github.com/GIToez/PokeNation/actions/runs/37518468969) | `3e74dce` | **12/12** | attempt 1 SKIP, attempt 2 **12/12** | as shipped `0xC0000374`; **Mesa llvmpipe: running after 30 s, first screen rendered** |
| [37524351264](https://github.com/GIToez/PokeNation/actions/runs/37524351264) | `584f605` | green | green | (Node 24 action versions) |
| [37526792085](https://github.com/GIToez/PokeNation/actions/runs/37526792085) | `fd8f9e4` | **12/12** | **12/12**; setup with the MariaDB client (BUG-74) | as shipped `0xC0000374`; Mesa llvmpipe running after 30 s |

The client steps are informational (`continue-on-error`), so they never fail the job.

## 6. Windows runtime evidence

All of this comes from the GitHub-hosted Windows runner (Windows Server 2025 Datacenter, no
GPU), run [37518468969](https://github.com/GIToez/PokeNation/actions/runs/37518468969) unless
noted. Nothing was run on a Windows PC with a real GPU.

**Build and packages.** `tools/windows/Build-PokeNation-Windows.ps1` (MSYS2 MINGW64, GCC 16.2.0):

| Archive | Size (bytes) | sha256 |
|---|---|---|
| `PokeNation-Server-Windows-Dev.zip` | 54,978,825 | `23480d5f03f55d4bf7ac83f154fc2f21b7344b884a7b2ccbc6f9b0f82ea16a68` |
| `PokeNation-LegacyClient-Windows-Dev.zip` | 190,632,886 | `21706919689c584e8b2b803ef263ed4b256f6abe5e3d7cc9a96fd9f8afdef97c` |

The hashes change with every commit because `version.json` contains the commit.

**Database setup (`Setup-PokeNation-Database.ps1 -NonInteractive -RootPassword ''`).** In run
37518468969 and earlier it printed only `[ OK ]` lines, ending with
`97 tables; accounts: 1,admin,player`. That evidence came from the wrong client, though. The
runner has MySQL 8.0 preinstalled, and the script took the first `mysql.exe` on PATH,
`C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe`, instead of the client of the MariaDB
server installed from Chocolatey. The MySQL 8 client prints no warning for a passwordless root, so
CI missed **BUG-74**. On a real PC with MariaDB's own client, setup failed with
`ERROR 1146 (42S02): Table 'psoul.accounts' doesn't exist`, because the client's stderr warning
`option --ssl-verify-server-cert is disabled, because of an insecure passwordless login` was read
as the result of the table check.

After the fix (run [37526792085](https://github.com/GIToez/PokeNation/actions/runs/37526792085)),
the client search prefers MariaDB's client. CI asserts the client path, the table count and the
account list for a fresh database, a second run and `-Reset`:

```
[ OK ] MariaDB client: C:\Program Files\MariaDB 13.0\bin\mariadb.exe
[ OK ] logged in as 'root'
       client message (not an error): WARNING: option --ssl-verify-server-cert is disabled, because of an insecure passwordless login.
[ OK ] schema and development accounts imported          (fresh database)
[ OK ] tables already exist - import skipped (use -Reset to start over)   (second run)
[WARN] -Reset: dropping database 'psoul' (all characters and progress are lost)
[ OK ] schema and development accounts imported          (-Reset)
[ OK ] 97 tables; accounts: 1,admin,player                (all three runs)
```

The full logs are `setup-fresh.log`, `setup-again.log`, `setup-reset.log` and `checkonly.log` in
that run's `logs-windows` artifact. The regression test `tools/windows/Test-PokeNationCommon.ps1`
runs in the same job under Windows PowerShell 5.1 and PowerShell 7. The server package rebuilt
there (commit `fd8f9e4`) is 54,980,207 bytes, sha256
`417a7a1e9428f083dff7944e29b4b2096c8152886a9f40facdf53eb386df51a4`, and contains the fixed
scripts.

**Launcher checks (`Start-PokeNation-Server.ps1 -CheckOnly`).** It passed every check: package
files, `config.lua` (database `psoul`, ports 7564/8548), MariaDB running, database initialised
(3 accounts), and ports free.

**Server (`PokeNationServer.exe`, the packaged, stripped binary).** It came online after
20-29 s, with the same startup warnings as on Linux (BUG-20 tournaments and NPC interface lines,
see `STARTUP_AUDIT.md`). The protocol login as `admin` listed GM Admin. `tools/smoke_test.py`
then ran against it:

- runs 37505394395, 37513558891 and 37516068648: 12/12;
- run 37518468969: 12/12 on the retry (attempt 1 ended with Charmander fainting);
- run 37510656252: SKIP (Charmander fainted; that run had no retry yet).

The 12 checks are: logins, wrong password rejected, entering the game, GM teleport to Oak, the
Charmander starter, summon, moves, the wild battle won, the catch attempt resolved, return and
logout.

**Legacy client (`PokeNationLegacyClient.exe`).** The test starts it, waits 30 s, records the
exit code, takes a screenshot at 15 s and keeps its `psoul.log`.

- *As shipped:* Windows offers only its "GDI Generic" OpenGL 1.1 renderer on this runner, with a
  maximum texture size of 1024. All 48 modules load. The log then shows
  `ERROR: loading texture with size 1920x1080 failed, the maximum size allowed by the graphics card is 1024x1024`,
  and the process exits after 2-3 s with `0xC0000374`. Under gdb, the unstripped binary crashes
  with SIGSEGV in `AnimatedTexture::updateAnimation()` (`animatedtexture.cpp:75`). This is
  **BUG-73**: the animated 1920x1080 background is rejected, and the half-initialised animated
  texture is then used.
- *With Mesa (`opengl32.dll` from MSYS2 `mingw-w64-x86_64-mesa` copied next to the exe):* by
  default Mesa chose its d3d12 driver ("Microsoft Basic Render Driver"). That driver exited
  inside `SwapBuffers` (`0x80070057`). With `GALLIUM_DRIVER=llvmpipe` (OpenGL 4.6 in software),
  the client was **still running after 30 s**. The screenshot (`client-mesa.png` in that run's
  `logs-windows` artifact) shows the PSoul window with the language selection over the login
  window and the background.

So the Windows client build itself starts, loads its data and renders. The crash is specific to
renderers with a maximum texture size below 1920. CI performs no graphical login on Windows.
On a real Windows PC with a GPU, a user logged in and played (screenshot: in game at Professor
Oak, quest "defeat 5 Rattata" running). There, Bulbasaur's Headbutt opened
`Assertion failed! … eventdispatcher.cpp Line: 85 Expression: delay >= 0`. This is **BUG-75**,
inherited code that only development builds report, because their asserts are active. It is fixed
in `Creature::updateJump()`. The fix was verified on Linux: the old client aborts on
`creature:jump(20, 450)`, the fixed one does not. It has not yet been re-tested on that PC. On Linux the same client source
logged in and played (Phase 2, and §3 above).

## 7. Not done / open

- No engine or gameplay change, as the phase requires. The only client source change beyond
  build fixes is the BUG-75 crash fix, which keeps the original behaviour. BUG-20, BUG-71 and BUG-72 are the
  ones a tester notices first.
- Packages are not code-signed, so SmartScreen warns on first start.
- The graphical client on Windows needs a GPU driver with OpenGL 2 and a maximum texture size
  of at least 1920. Machines without one (GPU-less virtual machines, Remote Desktop without GPU
  acceleration) crash with BUG-73. The workaround is Mesa's software `opengl32.dll` plus
  `GALLIUM_DRIVER=llvmpipe`, as in CI (`WINDOWS_LOCAL_TESTING.md` §7). Mesa is not shipped in
  the package.
- A user has logged in, walked and fought on a Windows PC, which is how BUG-75 was found. The
  complete `WINDOWS_LOCAL_TESTING.md` §6 checklist has not been reported back yet.
- BUG-74 (setup failing with `ERROR 1146 … 'psoul.accounts' doesn't exist` on a real PC) is fixed
  and verified in CI with MariaDB's own client (13.0.2). The fix has not yet been re-run on the
  PC where it was found. The earlier "setup worked in CI" evidence used the runner's MySQL 8
  client and did not cover this case. The user's screenshot of a running game suggests that setup
  then worked there, but that was not confirmed separately.
- BUG-75 (client assertion `delay >= 0` on Headbutt) is fixed and verified locally on Linux; the
  rebuilt Windows client has not yet been re-tested on the PC where it was found.
