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

Two kinds of verification are kept apart. **BUILD VERIFIED** means the build compiled and was
packaged. **RUNTIME VERIFIED** means the program ran against the real server and the check was
observed. Legacy-client rows marked "manual" come from one run on 2026-10-07: the
`build/linux-development/client/psoulclient` binary, started from a temporary copy of `client/`
(the frozen tree was not touched), on a fresh seed under Xvfb. Commands were typed into the chat
with `xdotool`. Screenshots 40–42 are in [`screenshots/README.md`](screenshots/README.md).

| Feature | Legacy client | PokeNation client | Layer | Notes |
|---|---|---|---|---|
| Build (Linux) | PASS (Phase 2A CI) | PASS (local and CI) | build | `tools/build_pokenation_client.sh` |
| Starts (Linux, Xvfb) | PASS | PASS, RUNTIME VERIFIED ("PokeNation build profile 'production', 28 module(s) disabled") | client | packaged `PokeNation-Client-Linux.tar.gz` |
| Build (Windows) | PASS (Phase 2A CI) | PASS, BUILD VERIFIED only (CI MinGW and MSVC jobs; not run on Windows) | build | |
| Build (Android) | n/a | PASS, BUILD VERIFIED only (CI APK, arm64-v8a, NDK 29; not installed on a device) | build | |
| Login, character list, enter world | PASS (manual; on first start it asks for a language and shows the message of the day) | PASS (C-01…C-04) | protocol | the legacy client sends a language byte, the new one uses extended opcode 1 (C-05) |
| Team bar, summon | PASS (manual: `/mypokemon` ×2, `/cp 1` → "Rattata, go!", two-slot bar, move bar for Rattata) | PASS (U-01, U-02) | client Lua/UI | |
| Wild battle | PASS (manual: `/m Rattata`, Quick Attack hit, team bar health 100 % → 44 %) | PASS (U-02) | gameplay | |
| Catch, Pokédex, details, TM, level-up, autoloot, poll, shop, market, TV | NOT TESTED in this phase (legacy behaviour documented in Phase 2, `PHASE_2_TEST_MATRIX.md`) | §2.2 | — | the legacy `game_shop` (Diamond Shop, ext 103) has never been loaded (BUG-38) |
| Log noise | 2 × `CAST ERROR … TPoint<int>` at start-up | clean except BUG-77 on the TV viewer | client | |

### 2.1 PokeNation client against the server (Phase 3A, step by step)

Run with `tools/pokenation_client_smoke.py --account admin --password admin --character Tester`:
the real client binary (built from this branch, `psoul312` profile, Stage A assets from
`tools/stage_pokenation_assets.py`) runs under Xvfb with the test-only mod
`tools/pokenation_smoke/pn_smoke`, which drives the normal Enter Game and character list UI and
logs `CHECK PASS/FAIL` lines. When the character list announces a poll it also runs the poll
round trip (two extra checks), and `--market` adds the market round trip (C-14). Last default
run: `RESULT PASS 12/12` (C-01…C-10 plus the quest checks of C-15), 2026-10-07.

| Id | Test | Result | Evidence |
|---|---|---|---|
| C-01 | Login with wire version 312, OS `0x15`, RSA, Adler-32, XTEA | PASS | character list received; server accepted the version and OS |
| C-02 | Character list PSoul extras and poll flag | PASS | `GM Admin level=100 vocation=1 looktype=302`, `Tester level=5 looktype=611`, `hasPoll=false`; screenshot `02-charlist.png` |
| C-03 | Enter game: challenge echo, self-login light hour | PASS | `light hour read (279)`; no challenge mismatch in the server log |
| C-04 | Profile active in game | PASS | `GamePSoulProtocol=true wire=312 protocol=854 os=21` |
| C-05 | ACTIVATE then LOCALE (BUG-09) | PASS | `extended opcode 0 received`; with locale pt `accounts.lang_id` became 1, with en back to 0 |
| C-06 | Creature descriptions with summon/attackable bytes | PASS | 4 spectators parsed, no desync; world rendered with the legacy sprites (`03-world.png`) |
| C-07 | `0xAB` channel list with U16 count | PASS | 10 channels |
| C-08 | `0xFF 0x0A` Pokédex status | PASS | 386 entries received; Pokédex UI in U-06 |
| C-09 | Walk | PASS | south step `3307,301,7 → 3307,302,7` accepted (`04-after-walk.png`) |
| C-10 | Logout | PASS | `onGameEnd` |
| C-11 | Pokémon bar, moves, summon, battle, catch | PASS | Phase 3B, see U-01…U-07 (§2.2). NPC dialogue: the NPC channel is used by the market scenario (U-11); no NPC-specific window exists in either client |
| C-12 | Legacy GUI client against the Phase 3 server | PASS (manual, login → summon → wild battle) | §2 comparison table; screenshots 40–42 |
| C-13 | Polls: charlist poll flag, `0xFA` request, `0xFF 0x18` window, `0xFB` vote | PASS (packets; the poll window is U-09) | test polls inserted by SQL (`text_mode` 0 with 3 options, then `text_mode` 1). Option poll: `hasPoll=true`, window "PokeNation smoke poll: favourite starter?" with options 1–3, vote → `poll_votes (1, 2, 1)`. Text poll: vote → `poll_texts (2, 2, 'pn-smoke text vote')`. Test rows deleted and the server restarted afterwards (BUG-76); the next run showed `hasPoll=false`, 10/10 |
| C-14 | Market packets: `0xF6` enter, C→S create offer, `0xF9` item browse, C→S browse own offers, C→S cancel | PASS (packets; window in U-11) | `--character "GM Admin" --market`, seed: `players.balance = 12345` for GM Admin, `player_depotitems` locker 2589 (depot 0) holding 5 red apples (server id 2674, client id 3585, has a ware id). Mod places Jaron Jewell with `/n` (no spawn on the map), `hi`, `market` in the NPC channel. Enter: balance 12345, 5 apples. Buy offer 1×3585 at 150: new balance 12175 (150 + minimum fee 20) and the offer listed by "GM Admin". Own offers (`0xFFFE`): the offer. Cancel: balance 12325, `market_history` row state 1. 14/14. Seed rows removed and server restarted afterwards. By source comparison, the stock `0xF6` parser (U32 balance + vocation byte at 854) and the U64 create price do not match the server; the stock client was not run against it |
| C-15 | Quest log `0xF0` and quest line `0xF1` | PASS | Tester: 3 quests listed; quest 1 line received (0 missions, quest not started) |


### 2.2 Pokémon UI and Phase 3B features (PokeNation client)

Each row is graded at three levels, and a higher level is never inferred from a lower one:

- **PACKET PASS:** the client parsed the server packet, or sent its own, and the server reacted
  as expected.
- **UI PASS:** the widget exists, is visible and shows the data from that packet (widget state
  plus screenshot).
- **END-TO-END PASS:** an action started through the module's own code path changed state on
  the server, and the UI then showed the result. That code path is the public function that the
  widget's click handler or key binding calls (`pokebar.summon`, `pokemoves.useMove`,
  `poll.vote`, `shop.purchase`, …). The smoke mod does **not** synthesise mouse clicks or key
  presses, so the input layer itself (hit-testing, focus, key dispatch) is covered only by the
  key-binding census in U-03 and by manual use.

Runs: `tools/pokenation_gui_smoke_ci.sh` on a fresh seed, 2026-10-07, all scenarios PASS
(default 21/21, shop 28/28, pokemon 46/46, market 27/27, tv-record 24/24, tv-watch 16/16).
Screenshot numbers refer to [`screenshots/README.md`](screenshots/README.md).

| Id | Feature | Packets | PACKET | UI | END-TO-END | Evidence |
|---|---|---|---|---|---|---|
| U-01 | Team bar, summon, return, switch | `0xFF 0x04–0x08` | PASS | PASS | PASS | 2 slots shown. `summon(fastcall)` → `/cp` → slot in use, own summon on the map, fade-in effect. Return through the ball slot → `inUse=nil`, move bar dimmed. Screenshots 10, 11, 16 |
| U-02 | Move bar m1–m16, cooldown, move details | `0xFF 0x01–0x03`, `0x09`; `/sd` | PASS | PASS | PASS | 14 moves for Venusaur. `useMove(i)` in a real fight against a GM-spawned Rattata → server damage and cooldown shown. `/sd` tooltip "Power 15, energy 12, cooldown 1s". Screenshots 11, 12 |
| U-03 | Move keys without WASD conflict | — | n/a | PASS | NOT TESTED (no real key presses) | Key census: `F1`–`F12` and `Shift+F1`–`Shift+F4` bound only by `game_pokemoves` (16 keys); WASD and arrows bound only by `game_walk` with chat off (8 keys); `game_hotkeys` and `game_actionbar` loaded. Their refusal dialogs for move keys were not exercised |
| U-04 | Vitals HUD and energy | stock stats (mana = energy) | PASS | PASS | PARTIAL | HUD shows health, energy, trainer and Pokémon level, respect and balls (screenshots 10–12). GM Admin has infinite energy, so the drain was not watched in the UI; the server cost is verified by `tools/energy_test.py` (FEATURES "Moves") |
| U-05 | Catch | ball use on corpse; `0xFF 0x05` | PASS | PASS | PASS | Wild Rattata defeated and caught on the first try; team bar 2 → 3; the caught level 1 Rattata summoned with 1 move. Screenshots 13, 18 |
| U-06 | Custom Pokédex and Pokémon details | `0xFF 0x0A–0x0C`, `0x11`; `/dv`, `/pd` | PASS | PASS | PASS | Pokédex opened, entry clicked through its `onClick` → `/dv 19` → Rattata entry (386 entries, 1 caught, 4 moves). `/pd` → details window "Venusaur lv 100". Screenshots 14, 15 |
| U-07 | Level-up pop-ups (BUG-60) | `0xFF 0x19`, stock level change | PASS | PASS | PASS (1 move) / UI only (14 moves) | Real level-up of the caught Rattata: "#19 level 5, 1 new moves", pop-up 300×114 drawn over the map. 14-move layout: event fired locally, 14 icons in two rows, 300×159, inside the map. Screenshots 20, 23 |
| U-08 | Autoloot strip | `0xFF 0x1A` | PASS | PASS | PASS | `/autoloot` on, kill, `use` corpse → strip with 1 entry. Screenshot 21 |
| U-09 | Poll window | `0xFA`, `0xFF 0x18`, `0xFB` | PASS | PASS | PASS | Question and all 3 options shown; vote without a choice refused in the window; choice vote and text vote sent from the window; no further poll afterwards. Screenshots 04, 05 |
| U-10 | PokeNation Shop (Soul Coins) | ext 201 | PASS | PASS | PASS | Catalog (8 offers) and balance 20 from the server. Purchase → 19, "You bought 1x Stamina recover for 1 Soul Coins." Invalid quantity and unknown product rejected. Forged `price = 0` for a 15-coin addon → charged 15 (balance 4). A 15-coin purchase at 4 refused, no debit. History lists 2 purchases. Screenshots 06–08 |
| U-11 | Market window | `0xF6`, `0xF9`, C→S `0xF4–0xF8` | PASS (C-14) | PARTIAL | PARTIAL | Window opens at Jaron Jewell and shows the `0xF6` balance (12,345). The item list is empty because the 8.54 `.dat` has no market attribute (BUG-78, same in the legacy client). Offers created and cancelled at packet level only. The Tibia-coin "Get" button is still shown. Screenshot 09 |
| U-12 | TV channel (two clients) | `0xAB`, TV `sendTVStart` | PASS | PASS | PASS (with BUG-77) | Client 1 (GM Admin, display :97) records; client 2 (Trainer, :98) uses the television → channel list → watches → map re-sent around the recorder → leaves. Viewer sees the recorder twice and logs "got a thing with invalid stackpos" on join and leave (BUG-77). Not testable here: more than one viewer, chat inside the channel, and replay of a finished recording. Screenshots 30–33 |
| U-13 | Module control and clean start | — | n/a | PASS | n/a | "28 module(s) disabled"; no "Unable to send extended opcode" line (the stock `game_shop` no longer sends 201 at game start); no Lua error in `otclient.log` in any scenario except BUG-77 on the TV viewer |
| U-14 | TM chooser | `0xFF 0x0D`; `/tc` | PASS | PASS | PARTIAL | TM created with `/i` and used on the ball → chooser with 13 moves; cancel closes it without sending `/tc`. Choosing a move was not run, because it consumes the TM. Screenshot 17 |
| U-15 | Status icons | `0xFF 0x0E–0x10` | PASS (`0x0E`) | PASS | PASS | Potion used on the summon → icon "Health +1" with 57 s countdown, 38×38, top right of the map. Removal (`0x0F`) and clear (`0x10`) were not checked separately. Screenshot 19 |
| U-16 | Creature colour effects | `0xFF 0x13` | PASS | NOT TESTED (visual) | n/a | Fade-in and fade-out received and handled at summon and return; the colour change itself was not checked pixel by pixel |

### 2.3 CI

`.github/workflows/pokenation-client.yml` job **GUI smoke (packaged Linux client vs server,
Xvfb)**. It builds the server, imports the schema into a MariaDB 11 service, starts the server,
and runs `tools/pokenation_gui_smoke_ci.sh` on the packaged Linux client from the `linux` job.
It uploads the artifact `PokeNation-Phase3-Screenshots`: per scenario the PNG screenshots,
`otclient.log`, `client-console.log` and `result.log`, plus `results.txt` and `server.log`.
First green run: 37597248525 (commit be1fb14). Latest at the end of Phase 3B: 37601842327, every scenario with the same counts as the local run (shop 28/28 included); the `Build development packages` workflow, Windows MinGW database setup included, is green in run 37601842338. The Windows and Android jobs build and package
only (BUILD VERIFIED).
