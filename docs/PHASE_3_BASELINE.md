# Phase 3 baseline (pre-flight record)

State of the project when the Phase 3 Redemption client migration started (2026-10-07). Every
later Phase 3 claim is measured against this record. Phase 3 work happens on the branch
`cursor/phase3-redemption-client-c0d2`, created from the Phase 2A branch.

## 1. Baseline commit

| Item | Value |
|---|---|
| Baseline commit (Phase 2A head) | `0179ffb6f799c100f11df9732592bbb856332613` |
| Branch | `cursor/phase1-import-psoul-baseline-c0d2` (PR [#1](https://github.com/GIToez/PokeNation/pull/1)) |
| Version file | `VERSION` = `0.2.0` |

## 2. Status at the baseline

| Area | Status | Evidence |
|---|---|---|
| Server build | builds on Linux (GCC 13, local) and Windows (MSYS2 GCC 16.2, CI) | `build/linux-development/server/psoul-server`; CI run [37557648558](https://github.com/GIToez/PokeNation/actions/runs/37557648558) (commit `0179ffb`, all jobs green) |
| Database | MariaDB 10.11.14 locally; `tools/init_dev_database.sh --reset` gives 97 tables, accounts `1,admin,player` | checked 2026-10-07 with `information_schema.tables` and `SELECT name FROM accounts` |
| Legacy client build | builds on Linux and Windows; BUG-75 (assertion on jump moves) fixed in `4d661ad` | CI run [37555497661](https://github.com/GIToez/PokeNation/actions/runs/37555497661) artifact `PokeNation-LegacyClient-Windows`, commit `b60375b` |
| CI | green on all three jobs (validate, linux, windows) for the last runs | runs 37555497661, 37555503433, 37557648558 |
| Server smoke test | **12/12** locally before any Phase 3 change (fresh database, `tools/smoke_test.py`) | run on 2026-10-07 against the unchanged server |
| Real Windows PC | server, database setup and legacy client used for play by the project owner; BUG-74 and BUG-75 found there | `PHASE_2A_REPORT.md` §6-7 |

## 3. Brief item 1 — Windows database setup bug

The brief asks to fix the real-PC `Setup-PokeNation-Database.ps1` bug first. It was already fixed
at the end of Phase 2A as **BUG-74** (commit `43c68f4`, regression test `d34a37a`, CI `fd8f9e4`,
docs `d3a81c4`):

- `Invoke-MySql` reads stdout and stderr separately (`System.Diagnostics.Process`, asynchronous
  reads); `-Scalar` returns the first stdout row; a non-zero exit code or an `ERROR nnnn` line on
  stderr still fails; imports stream the `.sql` file through stdin so an SQL error stops them.
- Windows PowerShell 5.1 and PowerShell 7: `tools/windows/Test-PokeNationCommon.ps1` passes 23/23
  under both in CI.
- With MariaDB's own client (13.0.2) and a passwordless root, CI verifies a fresh setup, a second
  run and `-Reset`, each ending with `97 tables; accounts: 1,admin,player`.
- The Windows server package was rebuilt (sha256
  `417a7a1e9428f083dff7944e29b4b2096c8152886a9f40facdf53eb386df51a4`, commit `fd8f9e4`; later runs
  rebuild it on every commit).
- The real-PC finding and the fix are documented in `BUG_TRIAGE.md` BUG-74,
  `WINDOWS_LOCAL_TESTING.md` §8 and `PHASE_2A_REPORT.md` §6.

No further change was needed for Phase 3; the Phase 3 CI keeps those checks.

## 4. Known blockers and migration-relevant bugs

| Bug | Why it matters for Phase 3 |
|---|---|
| BUG-09 | The PSoul login packet carries a custom language byte that stock OTClient does not send |
| BUG-08 | The language byte is not range-checked server-side |
| BUG-01 | `worldType = "pvp"` is a configuration workaround for NPC battles; the real fix is in `canDoCombat` |
| BUG-59 / BUG-60 | The legacy client reads two `U16` counts into `uint8_t` (doll case, level-up moves) |
| BUG-67 | The legacy `0xFF` dispatcher has no `default` case |
| BUG-68 | The game-login challenge is skipped, never compared |
| BUG-38 | The Lua `ExtendedOpcode` registration on the server is dead |
| BUG-56 | Hard-coded AES asset key in the legacy client (must not be carried forward) |
| BUG-72 | The server never exits after SIGTERM (CI kills it) |
| BUG-73 | Legacy client crash on GPUs whose maximum texture size is below 1920 |

## 5. Specification sources

The legacy client and the server source are the specification for the new client. The packet
reference is [`reference/OPCODES.md`](reference/OPCODES.md), which was checked line by line
against both in Phase 2A.
