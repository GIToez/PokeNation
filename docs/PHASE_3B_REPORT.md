# Phase 3B report — Pokémon UI parity, Redemption module audit, Soul Coin shop

Branch `cursor/phase3b-pokemon-ui-c0d2`. The PokeNation client (`client-pokenation/`, OTClient
Redemption 4.1) now plays the core Pokémon loop against the real PSoul server. That loop is team
bar, summon, moves, battle, catch, Pokédex, details, TM, level-up, autoloot, polls, a Soul Coin
shop, the market window and TV. Every Redemption module has a recorded decision, and
unsupported modules no longer load. The frozen legacy client (`client/`) was not modified.

Two kinds of verification are kept apart throughout:

- **BUILD VERIFIED:** compiled and packaged.
- **RUNTIME VERIFIED:** run against the real server and observed.

UI results are graded PACKET / UI / END-TO-END in [`PHASE_3_TEST_MATRIX.md`](PHASE_3_TEST_MATRIX.md)
§2.2; no level is inferred from a lower one.

## 1. Pokémon UI

Twelve modules were ported from the legacy client. Their reference is
[`reference/CLIENT_MODULES.md`](reference/CLIENT_MODULES.md), and the changes to stock files are
in [`REDEMPTION_CHANGES.md`](REDEMPTION_CHANGES.md) §7.

| Module | Status (matrix row) |
|---|---|
| `game_pokebar` team bar, summon / return / switch | END-TO-END PASS (U-01) |
| `game_pokemoves` move bar m1–m16, cooldowns, `/sd` details | END-TO-END PASS (U-02) |
| Move keys F1–F12, Shift+F1–F4, no WASD conflict | UI PASS by key census; real key presses NOT TESTED (U-03) |
| `game_pokenation_hud` health, energy, levels, respect, balls | UI PASS; energy drain not watched with a GM (U-04 PARTIAL) |
| Catch | END-TO-END PASS (U-05) |
| `game_pokedex`, `game_pokemondetails` | END-TO-END PASS (U-06) |
| `game_advanceeffect` level-up pop-ups (BUG-60) | real level-up END-TO-END PASS; 14-move layout UI only (U-07) |
| `game_lootlist` autoloot strip | END-TO-END PASS (U-08) |
| `game_poll` | END-TO-END PASS (U-09) |
| `game_tmchoose` | open and cancel PASS; choosing a move not run (U-14 PARTIAL) |
| `game_statusbar` | `0x0E` icon and countdown PASS; `0x0F` / `0x10` not checked separately (U-15) |
| `game_effects` colour effects | packets PASS; colour not checked visually (U-16) |

Layout uses anchors relative to the map panel and reusable widgets, with no absolute screen
positions. The move bar never binds letter keys, so it works with chat on or off. `game_hotkeys`
and `game_actionbar` refuse the 16 move keys.

## 2. Gameplay

On a fresh seed, GM Admin creates Venusaur 100 and Rattata 1 with `/mypokemon`. The run then
covers these steps:

1. Summon Venusaur and fight a GM-spawned wild Rattata with moves. Damage and cooldowns come
   from the server.
2. Defeat and catch the Rattata, which grows the team bar from 2 to 3.
3. Open the Pokédex entry and the details window.
4. Open a TM and cancel it.
5. Use a potion, which shows a status icon.
6. Summon the level 1 Rattata and level it up on a kill. This gives a real `0xFF 0x19` pop-up
   and an autoloot entry.
7. Return the Pokémon through the ball slot and log out.

The `pokemon` scenario passed 46/46. The default, shop, market and TV scenarios add login,
character list, walk, quest log, channel list, both poll types, shop, market and a two-client
TV session. All passed (§7).

The trainer "Level 5" pop-up at the first login of a fresh seed is real: the server
recalculates the seeded level-1 character to level 5.

## 3. Module audit

[`REDEMPTION_MODULE_AUDIT.md`](REDEMPTION_MODULE_AUDIT.md) covers all 95 module directories
(88 under `modules/`, 7 under `mods/`). Each has its purpose, autoload, packets and opcodes,
PSoul support, start-up warnings, useful assets, possible PokeNation use and decision.

| Decision | Count |
|---|---:|
| KEEP ACTIVE (includes the 12 PokeNation modules) | 64 |
| REPURPOSE FOR POKENATION (`game_shop`) | 1 |
| REPLACE WITH POKENATION MODULE (`game_store` → `game_shop`, `game_spelllist` → `game_pokemoves`, `game_cyclopedia` → `game_pokedex`) | 3 |
| KEEP BUT DISABLE FOR NOW | 9 |
| REMOVE FROM PRODUCTION LOAD | 13 |
| DEVELOPER ONLY | 4 |
| UNKNOWN (`mods/game_tasks`, extended opcode 215, not loaded) | 1 |

## 4. Disabled modules

Profile-based control lives in `init.lua`. `PokeNationConfig.disabledModules` (24 modules) is
off in every profile. `developerModules` (4 modules) is off unless
`POKENATION_PROFILE=development`. The framework function `g_modules.setModuleDisabled` makes
every load path skip the module (autoload, `ensureModuleLoaded`, `load-later`, dependency), and
no files are deleted. A production start logs
`PokeNation build profile 'production', 28 module(s) disabled`.

| Group | Modules |
|---|---|
| Replaced | `game_store` (its CipSoft opcodes `0xFA` / `0xFB` are PSoul's poll request and vote), `game_spelllist`, `game_cyclopedia` |
| Removed from production load | `game_prey`, `game_imbuing`, `game_imbuementtracker`, `game_forge`, `game_wheel`, `game_stash`, `game_quickloot`, `game_blessing`, `game_tutorial`, `game_inspect`, `game_proficiency`, `game_bot`, `game_buttons` |
| Kept but disabled | `game_analyser`, `game_lootsplitter`, `game_highscore`, `game_paperdolls`, `game_playermount`, `game_unjustifiedpoints`, `game_taskboard`, `game_rewardwall` (`updater` is not loaded at all) |
| Developer only | `client_debug_info`, `client_terminal`, `dev_otui`, `game_htmlsample` |

The automatic extended opcode 201 send at game start is gone. Stock `game_shop` used to send
it before ACTIVATE ("Unable to send extended opcode 201"). The shop now sends `fetch` only when
its window is opened, and no scenario log contains the line.

## 5. Repurpose candidates

All of these are disabled now. Each needs server data before it is worth enabling.

| Module | Candidate use | Needs |
|---|---|---|
| `game_highscore` | PokeNation highscores | an extended opcode that serves `011-highscore.lua` data |
| `game_taskboard` | Pokémon hunt tasks | task data over an extended opcode |
| `game_rewardwall` | daily login reward | reward state over an extended opcode |
| `game_analyser` | hunt / experience analyser | parsing of PSoul loot and experience messages |
| `game_playermount` | ride / fly toggle | mapping to the PSoul order system |
| `game_paperdolls` | Pokémon addons | per-Pokémon addon data |
| `game_cyclopedia` (images only) | Pokédex art | — |
| `updater` | client patching | an update server |

## 6. Soul Coin shop

Reference: [`reference/SOUL_COINS.md`](reference/SOUL_COINS.md). Adding a product:
[`tutorials/add-shop-product.md`](tutorials/add-shop-product.md). Packet layout:
[`reference/OPCODES.md`](reference/OPCODES.md) §8.1.

- **One currency.** It is the account balance `accounts.soulcoins`, credited externally (the
  website or payment provider, later). The Soul Coin item 6500 exists only as the Soul Trade
  withdrawal form. No second implementation was created; the shop uses the same column, the
  same `datalog_coin_uses` log (use 13) and a new history table `datalog_shop_purchases`.
- **Server-owned.**
  - The catalog, prices and balance come from `lib/ps/systems/057-soulShop.lua` over extended
    opcode 201.
  - The client sends only the action, product id and quantity.
  - The debit is one conditional `UPDATE … WHERE soulcoins >= price` checked with
    `ROW_COUNT()`. A failed grant is refunded, and requests are rate-limited to one per second
    per action.
- **The client is not trusted.** A forged request with `price = 0` for a 15-coin product was
  charged 15, and a purchase above the balance was refused without a debit. Both checks are in
  the CI smoke.
- **Client.** `game_shop` was rewritten as "PokeNation Shop". The Tibia products, gift and coin
  transfer, the name-change windows and the bundled `serverSIDE/` scripts were removed.
- **No secrets.** No SQL credentials or payment secrets are in the client. The development
  database password lives only in the git-ignored `server/config.lua` and is never packaged.
- **Dead code found.** `shop_bank.lua` is not referenced by any NPC XML, and the legacy
  "Diamond Shop" (`client/modules/game_shop`, extended opcode 103) has never been loaded
  (BUG-38).

Upgrade note: the fresh schema now has **98** tables. An older database needs the
`datalog_shop_purchases` statement from `psoul_extra_mysql.sql`; without it purchases still
work, but the history stays empty.

## 7. Screenshots

- **Curated:** 29 images in [`images/phase3/`](images/phase3/), with captions and the matching
  smoke check in [`screenshots/README.md`](screenshots/README.md). They include three
  legacy-client images from a manual side-by-side run.
- **Complete:** every push produces the CI artifact `PokeNation-Phase3-Screenshots` (job
  `gui-smoke`). Per scenario it holds the PNGs, `otclient.log`, `client-console.log` and
  `result.log`, plus `results.txt` and `server.log`.

| Scenario | Result (local, fresh seed) |
|---|---|
| default (Tester) | 21/21 |
| shop | 28/28 |
| pokemon (GM Admin) | 46/46 |
| market (GM Admin) | 27/27 |
| tv-record (GM Admin, display :97) | 24/24 |
| tv-watch (Trainer, display :98) | 16/16 |

## 8. Desktop

| Platform | Status |
|---|---|
| Linux x64 | RUNTIME VERIFIED: packaged client, all scenarios above, in CI (`gui-smoke`) and locally |
| Windows x64 (MinGW, MSVC) | BUILD VERIFIED only; not run on Windows in this phase |
| Legacy client (Linux) | RUNTIME VERIFIED manually against the same server: login, team bar, summon, wild battle (matrix §2, C-12) |

## 9. Android

BUILD VERIFIED only: the CI job "Android APK (arm64-v8a, NDK 29)" builds and packages the APK
with the Stage A assets. It was not installed or run on a device or emulator. The UI uses
anchored layouts and has no absolute positions, but its touch use (move bar without F-keys,
team bar taps) is untested.

## 10. Known problems

| Id | Problem | Priority |
|---|---|---|
| BUG-77 | TV viewer sees the recorder twice and logs "got a thing with invalid stackpos" on join and leave (server keeps the owner as a known creature in `sendTVStart`) | P3 |
| BUG-78 | Market item list empty: the 8.54 `.dat` has no market attribute (same in the legacy client); the Tibia-coin "Get" button is still shown | P3 |
| BUG-79 | Redemption top status bar shows 9999999999 in its right gauge for a character without a Pokémon | P4 |
| — | The right-panel shop button image still reads "Store" (the text is in `images/options/store_large.png`); the tooltip says "PokeNation Shop" | P4 |
| — | Legacy modules not ported: `game_badgecase`, `game_dollcase`, `game_slotmachine`, `game_tips`, `game_guide` (extended opcodes 8/9), `game_duelmessage`, `game_time`, `game_environment`, legacy `game_tutorial`. The C++ parser already raises the events for `0xFF 0x14–0x17` | — |
| — | `things.otml` per-thing opacity not loaded | P4 |
| — | No real mouse or key input in the smoke; the hotkey refusal dialogs were not exercised | — |

## 11. Next phase

1. Port the remaining legacy modules: badge case, doll case, slot machine, tips, guide (ext
   8/9), duel message, time and environment.
2. Fix BUG-77 on the server. Decide whether the market stays (it would need market data for
   8.54 items) or is replaced by the NPC market (BUG-78). Remove the Tibia-coin button.
3. Run the Windows client on Windows and the APK on a device. Add touch controls for the move
   bar.
4. Add input-level tests that send real clicks and keys through `g_window` events or xdotool,
   and cover the TM choice, energy drain for a normal player, and status-icon removal.
5. Replace the "Store" button image and the remaining Tibia artwork.
6. Website and payment integration that credits `accounts.soulcoins`. It runs outside the
   client and holds no secrets in the client.
