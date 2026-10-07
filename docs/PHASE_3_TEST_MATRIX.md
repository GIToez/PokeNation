# Phase 3 test matrix — PokeNation client migration

Legacy client (`client/`, frozen reference) versus the new PokeNation client (`client-pokenation/`,
OTClient Redemption 4.1 based), plus the server changes Phase 3 needs.

Result values: **PASS**, **PARTIAL**, **FAIL**, **BLOCKED**, **NOT TESTED**. A failure names its
layer: server, protocol, client C++, client Lua/UI, assets, build/packaging, environment.

Environment for the server rows: Ubuntu 24.04 VM, MariaDB 10.11, server built by
`tools/build_server.sh` from this branch, `worldType = "no-pvp"`, seed database
(`tools/init_dev_database.sh --reset`) unless a row says otherwise. Client role played by
`tools/protocol_probe.py` (wire level). Dev-only accounts `admin`/`admin`, `player`/`player`.

---

## 1. Server (migration-blocking fixes)

| Id | Test | Exact steps | Result | Evidence |
|---|---|---|---|---|
| S-01 | Login of the legacy OS id still works | `protocol_probe.py login --account admin --password admin` (OS `0x0A`, language byte 0) | PASS | characters GM Admin / Tester listed with PSoul extras |
| S-02 | Language byte from the legacy client (BUG-08) | `login --lang 1`, then `--lang 99`, then `--lang 0`; read `accounts.lang_id` after each | PASS | `lang_id` 0 → 1 → 1 (99 ignored) → 0 |
| S-03 | Out-of-range language stored in the database (BUG-08) | `UPDATE accounts SET lang_id=7` for `player`; enter as Trainer, say `hi` | PASS | entered, no crash, server alive; reset to 0 afterwards |
| S-04 | PokeNation OS id logs in without a language byte (BUG-09) | `--os 0x14 login --account admin --password admin` | PASS | characters listed with level/vocation/outfit extras; `lang_id` unchanged |
| S-05 | ACTIVATE and LOCALE extended opcodes (BUG-09) | `--os 0x14 enter … --ext 1:2`; then `--ext 1:9 --ext 1:xx --ext 1:`; then `--ext 1:0` | PASS | `extended opcode 0: ''` received after login; `lang_id` 2 → 2 (invalid ignored) → 0; connection kept |
| S-06 | Login challenge (BUG-68) | `enter … --bad-challenge` versus a normal `enter` | PASS | wrong echo: disconnected, server log `login challenge mismatch from 127.0.0.1`; correct echo: in game |
| S-07 | NPC trainer battle under `no-pvp` (BUG-01) | Tester (level 100 and level-100 Blastoise/Pidgeot created with `/mypokemon` while temporarily GM, then group 1) at Chandra Wigington (3299,246,10): `hi`, `battle`, `yes`, attack Golem, Onix, Sandslash/Rhydon with m1–m5 | PASS | Pidgeot run: damage accepted ("Your Pidgeot deals 794 damage to a Golem."), loss path ("You have been defeated by Chandra Wigington!"). Blastoise run: "You won Chandra Wigington.", "Your battle win has increased to 11." |
| S-08 | Gym battle under `no-pvp` (BUG-01) | Tester with the six other Pewter gym trainers marked as beaten (storages 9562–9567 = 2, test shortcut) at Brock: `hi`, `battle`, `yes`, attack his six Pokémon | PASS | "You won Brock and received your reward.", "Congratulations! You received the boulder badge from Brock.", "You received 1x TM 33." (badge item in the case not inspected; see BUG-16) |
| S-09 | PvP stays blocked under `no-pvp` (BUG-01) | Trainer (Charmander out) next to Tester (Blastoise out), no duel: `--attack Blastoise`, `m1`, `m2`, `--attack Tester` | PASS | "You may not attack this creature." and "You may not attack this player." |
| S-10 | Duel under `no-pvp` (BUG-01) | Duel icon 13016 placed in both backpack slots by SQL (the seed characters have none). Trainer: use the icon on Tester, open channels 100 (1 Pokémon), 106 (1×1), 446 (no bet). Tester: use the icon on Trainer. Both attack | PASS | invitation, "Team B is ready!", countdown, "The duel has begun!", damage both ways ("Your Blastoise deals 811 damage to a Charmander."), "Trainer was defeated.", "Team B win!", duel win/loss counters updated |
| S-11 | Gameplay smoke test | `tools/smoke_test.py` on a fresh seed, `no-pvp` | PASS | 16/16 (the 12 Phase 2 checks + S-02, S-04, S-05, S-06 as regression checks) |

Notes:
- S-07…S-10 used database edits only to set up test characters (GM group to run `/mypokemon`,
  level 100, gym-trainer storages, duel icons). The seed was reset afterwards.
- The legacy GUI client against this server is part of the Phase 3A comparison (§2).

---

## 2. Legacy client versus PokeNation client

Filled in as the new client reaches each migration step (login → character list → enter world →
map → movement → chat → inventory → Pokémon bar → summon → moves → battle → catch → Pokédex →
NPCs → market/social).

| Feature | Legacy client | PokeNation client | Layer | Notes |
|---|---|---|---|---|
| Build (Linux) | PASS (Phase 2A CI) | PASS (stock Redemption 4.1, local and CI) | build | `tools/build_pokenation_client.sh` |
| Starts (Linux, Xvfb) | PASS | PASS (stock: "Startup done :]") | client | packaged `PokeNation-Client-Linux.tar.gz` |
| Build (Windows) | PASS (Phase 2A CI) | PASS (CI runs 37563373089 stock and 37566367616 with the psoul312 profile + Stage A assets, 124 MB zip; build only, not run on Windows) | build | |
| Build (Android) | n/a | PASS (CI runs 37563373089 and 37566367616, 125 MB APK artifact with Stage A assets; not installed on a device) | build | |

### 2.1 PokeNation client against the server (Phase 3A, step by step)

Run with `tools/pokenation_client_smoke.py --account admin --password admin --character Tester`:
the real client binary (built from this branch, `psoul312` profile, Stage A assets from
`tools/stage_pokenation_assets.py`) runs under Xvfb with the test-only mod
`tools/pokenation_smoke/pn_smoke`, which drives the normal Enter Game and character list UI and
logs `CHECK PASS/FAIL` lines. When the character list announces a poll it also runs the poll
round trip (two extra checks). Last run without a poll: `RESULT PASS 10/10`; with a test poll:
`RESULT PASS 12/12`, 2026-10-07.

| Id | Test | Result | Evidence |
|---|---|---|---|
| C-01 | Login with wire version 312, OS `0x15`, RSA, Adler-32, XTEA | PASS | character list received; server accepted the version and OS |
| C-02 | Character list PSoul extras and poll flag | PASS | `GM Admin level=100 vocation=1 looktype=302`, `Tester level=5 looktype=611`, `hasPoll=false`; screenshot `02-charlist.png` |
| C-03 | Enter game: challenge echo, self-login light hour | PASS | `light hour read (279)`; no challenge mismatch in the server log |
| C-04 | Profile active in game | PASS | `GamePSoulProtocol=true wire=312 protocol=854 os=21` |
| C-05 | ACTIVATE then LOCALE (BUG-09) | PASS | `extended opcode 0 received`; with locale pt `accounts.lang_id` became 1, with en back to 0 |
| C-06 | Creature descriptions with summon/attackable bytes | PASS | 4 spectators parsed, no desync; world rendered with the legacy sprites (`03-world.png`) |
| C-07 | `0xAB` channel list with U16 count | PASS | 10 channels |
| C-08 | `0xFF 0x0A` Pokédex status | PASS | 386 entries received; no Pokédex UI yet (p5) |
| C-09 | Walk | PASS | south step `3307,301,7 → 3307,302,7` accepted (`04-after-walk.png`) |
| C-10 | Logout | PASS | `onGameEnd` |
| C-11 | Pokémon bar, moves, summon, battle, catch, NPC dialogue windows | NOT TESTED | Pokémon UI modules not ported yet |
| C-12 | Legacy GUI client against the Phase 3 server | NOT TESTED | planned for the Phase 3A comparison |
| C-13 | Polls: charlist poll flag, `0xFA` request, `0xFF 0x18` window, `0xFB` vote | PASS (packets; no poll UI yet) | test polls inserted by SQL (`text_mode` 0 with 3 options, then `text_mode` 1). Option poll: `hasPoll=true`, window "PokeNation smoke poll: favourite starter?" with options 1–3, vote → `poll_votes (1, 2, 1)`. Text poll: vote → `poll_texts (2, 2, 'pn-smoke text vote')`. Test rows deleted and the server restarted afterwards (BUG-76); the next run showed `hasPoll=false`, 10/10 |
| C-14 | Market packets: `0xF6` enter, C→S create offer, `0xF9` item browse, C→S browse own offers, C→S cancel | PASS (packets; market window not verified) | `--character "GM Admin" --market`, seed: `players.balance = 12345` for GM Admin, `player_depotitems` locker 2589 (depot 0) holding 5 red apples (server id 2674, client id 3585, has a ware id). Mod places Jaron Jewell with `/n` (no spawn on the map), `hi`, `market` in the NPC channel. Enter: balance 12345, 5 apples. Buy offer 1×3585 at 150: new balance 12175 (150 + minimum fee 20) and the offer listed by "GM Admin". Own offers (`0xFFFE`): the offer. Cancel: balance 12325, `market_history` row state 1. 14/14. Seed rows removed and server restarted afterwards. By source comparison, the stock `0xF6` parser (U32 balance + vocation byte at 854) and the U64 create price do not match the server; the stock client was not run against it |

Known non-fatal log line: `Unable to send extended opcode 201` from the stock Redemption `game_shop`
module (layer: client Lua/UI); it will be disabled with the other inapplicable stock modules.
