# Phase 2 report — verified playable PSoul baseline

Phase 2 turned the Phase 1 import (`docs/PHASE_1_REPORT.md`) into a local development environment
that can be launched and played with a client **we compile ourselves**, and then exercised the
Pokémon gameplay systems one by one. Nothing in this report is called "working" because its source
exists: every PASS below was reproduced on `127.0.0.1` with the locally built server and either the
locally built graphical client or the protocol probe. Per-test evidence (exact steps, expected,
actual, source files, errors, priority) is in `docs/PHASE_2_TEST_MATRIX.md`; defects are in
`docs/BUG_TRIAGE.md` (BUG-01 … BUG-57).

Out of scope and **not done**, as instructed: OTClient Redemption migration, engine modernisation,
packet redesign, rebalancing, removal of historical code. The original precompiled executables from
the archive were never run or redistributed (see `docs/SECURITY_AUDIT.md`).

## 1. Local Client

| Item | Result |
|---|---|
| Source | `client/src-cpp` (OTClient 0.6-era fork "Poke Aimar", C++) + `client/modules`, `client/data` |
| Build | `tools/build_client.sh` → `build/client/psoulclient` (Linux, GCC 13, Boost 1.83, CMake ≥ 3.5). Windows x64 via GitHub Actions (MSYS2 MinGW-w64, GCC 16, Boost 1.89) → `PokeNationClient.exe`. The workflow run for the final client commit produced all four artifacts (`PokeNation-client-windows-x64`, `PokeNation-server-windows-x64`, `PokeNation-client-linux-x64`, `PokeNation-server-linux-x64`); the Windows client executable was **not** run in this environment (no Windows machine), only built |
| Dev target | `127.0.0.1`, login 7564, game 8548, protocol version 312 (`client/modules/client_entergame/entergame.lua`, `init.lua`), see `docs/LOCAL_CLIENT_TESTING.md §1` |
| Source changes needed | Compile-only: Boost.Asio port (`io_context`, `steady_timer`, resolver `results_type`, `make_address_v4`, `const_buffer::data()` instead of `buffer_cast`), `TPoint::length()`, libxml2 `const`, CMake minimum 3.5, Windows link libraries `crypt32`/`avrt`, and one runtime fix — the Lua-stack crash on monster-yell `StaticText` (BUG-03). No protocol, gameplay or asset code was changed. Full list: `docs/LOCAL_CLIENT_TESTING.md §3.3` |
| Verified | Login as `player`/`player` and `admin`/`admin`, MOTD, character list, world render, minimap, inventory, channel list, Pokémon bar, move bar with tooltips, Pokédex window, outfit/addon window, status icons, NPC and monster speech. Test P2-33 |
| Known client defects | Pokémon bar overlaps the move bar (BUG-11); inventory hides slots 2 (evolve icon) and 3 (backpack) so `/i` items are invisible (BUG-12); harmless `CAST ERROR … TPoint<int>` console lines and a `connect`/`disconnect` leak in `game_tmchoose` (BUG-57); hard-coded AES asset key/IV in source (BUG-56, `docs/SECURITY_AUDIT.md §3`) |

The asset-encryption layer (encrypted `data/` packages, key in `crypt.cpp`) was left exactly as
shipped; it is a Redemption-migration item, not a Phase 2 one.

## 2. Launch Procedure

Complete walkthrough: `docs/BUILDING.md §8 "LOCAL DEVELOPMENT QUICK START"`; for people who only
want to run a build: `docs/BUILDING.md §9`.

1. One time: `tools/dev_env.sh` (dependencies), `tools/build_server.sh` (build tree
   `build/server/`, binary `server/psoul-server` because the server resolves `config.lua` and
   `data/` relative to its working directory), `tools/build_client.sh` (`build/client/psoulclient`),
   `tools/setup_database.sh` (imports `server/src/schemas/mysql.sql`, `psoul_extra_mysql.sql`,
   `psoul_dev_seed.sql` into MariaDB `psoul`/`psoul`), copy `server/config.example.lua` to the
   git-ignored `server/config.lua` and put the local DB password in `sqlPass`.
2. Every session: `tools/start_database.sh` → `tools/start_server.sh` (wait for
   `>> Cristal server Online!`) → `tools/start_client.sh` (needs an X display; `tools/start_client.sh` on
   `DISPLAY=:1` was used here). Windows equivalents `start_database.bat`, `start_server.bat`,
   `start_client.bat` (`tools/dist/`, shipped inside the GitHub Actions packages).
3. Log in with a development account (`docs/BUILDING.md §8.3`; development-only passwords, not the
   production ones, which were never in the archive):

| Account | Password | Characters | Purpose |
|---|---|---|---|
| `admin` | `admin` | **GM Admin** (group 6, Pewter 3307,300,7), **Tester** (group 1) | Phase 1 dev account; commands `/i`, `/goto`, `/send`, `/exp`, `/n`, `/raid` … |
| `player` | `player` | **Trainer** (group 1, level 5, Beginner Island 5000,806,6) | normal player path: Professor Oak starter, tutorial town |

Every seeded character starts with the Pokédex (12281, slot 6), pokebag (12282, slot 10) with
100 Poké Balls (12157), 100 Pokémon food (2687), 20 potions (12244) and two tools, the order icon (13206, slot 1),
evolve icon (13204, slot 2, added in Phase 2), badge case (12280, slot 5) and ball support
(verified P2-03). `replaceKickOnLogin = true`: logging the probe in on the same account as the GUI
kicks the GUI, so use `admin` for scripted runs and `player` for the GUI.

Development-only configuration differences from the archive, both documented in
`server/config.example.lua`: `ip = "127.0.0.1"`, and `worldType = "pvp"` (BUG-01, below).

## 3. Verified Pokémon Systems (PASS)

| System | Evidence (test id) |
|---|---|
| Account login, MOTD, character list, world entry (login 7564 → game 8548) | P2-01 |
| Starter Pokémon from Professor Oak (choice, gender, ball, bar icon) | P2-02 |
| Starting kit, order/evolve icons, Pokédex, pokebag, ball support | P2-03 |
| Call / return Pokémon ("it's the battle time!", ball 12159 → 12158, move bar `0xFF 0x01`) | P2-04 |
| Wild battle, experience to player and Pokémon, loot, autoloot collection | P2-05 |
| Moves with cooldown (`0xFF 0x09`), damage/effect lines — as a group-1 character | P2-06 (Trainer) |
| Nurse Joy heal | P2-07 |
| Catch (empty ball on corpse, Pokédex register, catch XP, ball counter) | P2-09 |
| Pokémon faint / revive flow | P2-10 |
| Evolution via evolve icon with a stone | P2-11 |
| Nickname change (Soul Coin) | P2-12 |
| Status conditions (poison icon `0xFF 0x0E/0x0F`, antidote 16718) | P2-13 |
| Player commands (`/held /addon /boss /time /afk /dv /find /lang /exp`, GM `/i`, `/goto`, `/send`, `/m`, `/mypokemon`) | P2-14, P2-15 |
| TM teaching (TM window `0xFF 0x0D`, move replaced) | P2-16 |
| Held item attach (Black Belt) and `/held` level/exp report | P2-17 |
| Vitamin (Calcium) | P2-18 |
| Egg incubator: empty (14048) + egg → full incubator (14049), 60-minute timer, hatch ("Your Ponyta egg hatches!"), ball delivered to the depot | P2-19 |
| Ride and Fly (outfit change, `/up` `/down` floor change for Fly, dismount) | P2-20, P2-21 |
| Wiki Chat channel (449) dialogue tree | P2-23 |
| Town-guide map marks (`0xDD`) | P2-25 |
| Quest framework: deliver quest with Jack Simps, reward money + 2000 exp, storage flag | P2-26 |
| Bank deposit / withdraw / balance / history (`datalog_bank_transactions`) | P2-27 |
| Tournament scheduler broadcast | P2-28 |
| NPC trainer battle **under `worldType = "pvp"`**: attacks accepted, Pokémon exp, loss path "You have been defeated by …", battle-loss counter | P2-29 |
| Statistics logging (`datalog_online`, login rows, bank log) | §2.16 |
| Graphical client render of all `0xFF` sub-opcodes exercised, `0xAB`, `0xC8`, `0xDD` without desync | P2-33, P2-34 |

## 4. Partial Systems (PARTIAL)

| System | What worked | What did not / was not reached | Ref |
|---|---|---|---|
| Feeding | Food refused on a full Pokémon ("Your Pokemon is full."); hunger message appears over time | Feeding a *hungry* Pokémon not exercised; "Your X is hungry!" every minute (BUG-19) | P2-08 |
| Move damage model | Damage lines, STAB-looking numbers | Typing/STAB not measured; `bonusDef` reads the attack bonus (BUG-33); day-of-year cooldown clock (BUG-34) | §2.2 |
| Daycare / egg moves | Incubator path is PASS (P2-19), with the "Remaing 60 minutes (1 days)" text defect (BUG-29) | Daycare NPCs (level ≥ 85 + premium), egg moves and extra-egg rate not reached | §2.5 |
| Addons | Addon item and `/addon` both make the server send the outfit window (`0xC8`) | Window content not inspected, no choice sent back, so "Your Pokemon received the … addon." is unverified | P2-22 |
| Bank transfer | Dialogue starts, asks for amount and name | 4-step confirmation answered out of order by the probe; not a verified defect | P2-27 |
| Tournaments | Hourly broadcast | Joey's list only shows "Titan" because ids 2/3 are commented (BUG-20) | P2-28 |
| NPC trainer battle | Loss path | Win path (reward, respect, badge) not reached; impossible at all under the archive's `no-pvp` (BUG-01) | P2-29 |
| Pokémon Market NPC (Jack Eden) | `list`, `buy` dialogue | Actual sale/purchase; suspected unpaid-seller path (BUG-31) | P2-30 |
| PokeTrader auction NPC (Tiger Kelsey) | Spawn, `offer`, `bid` dialogue, 4 startup offers in `poketrader_offerts` | Placing a bid; suspected always-true purchase flag (BUG-32) | P2-31 |
| Anniversary event | Auto-start observed: `> Broadcasted message: "Cake Minions".` one hour after boot | Minions, surprise bags, "Mad Big Cake" boss not played; event is permanently on (BUG-14) | P2-32 |
| Pokédex | Catch registration, XP, client window | Corpse/TM/trainer-card uses; nil index without an equipped Pokédex (BUG-35) | §2.4 |
| Shop / premium / Soul Coins | Nickname change with a GM-created coin | Coins and premium days come only from the website DB columns | §2.18 |

## 5. Broken Systems (FAIL / BLOCKED)

| System | Finding | Severity | Ref |
|---|---|---|---|
| NPC trainer battles under the shipped `worldType = "no-pvp"` | Every player attack is refused ("You may not attack this creature.") while the NPC's Pokémon hits back; the player cannot log out. Cause: `Combat::canDoCombat` (`server/src/combat.cpp:313`) rejects attacks on mastered creatures before the NPC-opponent exception (`:322-326`). **Fixed for development** by `worldType = "pvp"`; PvP between players stays blocked by `combat.cpp:272-284`. | P1 | BUG-01, P2-29 |
| Pokémon moves as a GM character | Groups 4–6 have infinite mana, which PSoul uses as energy → energy 0/0 → "Sorry, your Pokemon has insufficient energy". Test as a group-1 character. | P3 | BUG-05, P2-06 |
| Autoloot OFF persistence | OFF never saved; every login prints "Auto Loot OFF!" and the C++ default is `autoLoot = true` (`player.cpp:69`, `login.lua:183-185`). | P3 | BUG-04, P2-24 |
| `onLogout.lua` errors | Four Lua errors when a client disconnects during an NPC battle. | P3 | BUG-06 |
| Builds on current toolchains (Phase 2 start) | Server/client did not compile with modern Boost, libxml2, CMake 4 — fixed. | P0 | BUG-02 |
| Client crash on monster yell | Lua stack corruption in `StaticText` — fixed. | P0 | BUG-03 |
| Login language byte | Unvalidated byte can null-dereference `Localization::t` (inferred from source, not triggered). | P2 | BUG-08 |

Inferred-only breakages (from reading, NOT TESTED, all in the triage): gym badges can never
appear because badge placeholders are created by nothing (BUG-16), PvP-arena think-loop runtime
error (BUG-17), item-market window dead without a depot and purchase deletes items on a failed
depot add (BUG-36/37), dungeon reset removes players (BUG-45), `"Strenght"` typo disables Strength
for 11 species (BUG-30), Team Rocket battles give no reward (BUG-44).

## 6. Website Dependencies

The server was operated together with a website (Gesior/Znote-style AAC) that is **not in the
archive**. Nothing was recreated; the dev seed SQL is the local substitute for the parts that block
play. Hard dependencies (feature does not exist without the site):

| Dependency | Affected feature | Tables / columns / URLs |
|---|---|---|
| Account and character creation | login (`accountManager = false`, login-only protocol; `protocollogin.cpp:198-201` tells players to create a character "on the website") | `accounts(name, password SHA-256, premdays, lang_id, client_id, referral, referral_points, soulcoins)`, `players(…, hidden, firstpokemon, lasteggtime, pvparena*, tournament_*)`, `player_items`, `player_skills`; client links `http://pokenordic.com/accounts/create`, `http://www.psoul.net/players/createCharacter`, `/accounts/donate` |
| Soul Coins credit (donations) | Soul Trade NPC withdraw, nickname change, guild creation (`!createguild` is disabled), premium | `accounts.soulcoins`; `datalog_coin_uses` |
| Premium days | market offers, TV recording, houses/beds, daycare | `accounts.premdays` (also `/coupon`) |
| Coupons | `/coupon` | `coupons`, `coupon_uses` (site-generated codes) |
| Referral program | referral points at the Soul Trade NPC | `accounts.referral` (only *read* in-game), `referral_points`, `referral_friends` |
| Polls | in-game poll window (`0xFA/0xFB`, login flag) | `polls`, `poll_options`, `poll_texts` created externally; server writes only `poll_votes` |

Soft dependencies (server writes, site reads; play is unaffected): `player_highscores`,
`player_statistics`, `datalog_*`, `tournament_weekly_winners` ("store this information for the
website", `tournament.cpp:1257`), `market_history`, `market_offers`, `pokemon_market`,
`poketrader_*`, `guilds.logo/description`, `house_auctions` (never read in-game), the missing
stored procedure `update_rank()` (`updateHighscores = false` keeps it unused), `server_motd`,
`server_record`, and the HELP-channel link `http://www.pokenordic.com/blogCategories/1-tutorials`.

Local workarounds used in Phase 2: seeded accounts/characters, GM-created Soul Coin (`/i 6500`),
premium flag by SQL. Password hashing is unsalted SHA-256 (`encryptionType = "sha256"`), so a
classic SHA-1 AAC would not log in without reconfiguration.

## 7. Protocol Findings

Protocol tables are unchanged from Phase 1 (`docs/SOURCE_AUDIT.md §2`, `docs/PHASE_1_REPORT.md
§8–9`). Phase 2 validated them with the graphical client instead of only the probe:

- The client we compiled completes login (7564) and game entry (8548) with version 312, the
  Adler-32 checksum, RSA + XTEA, the `0x1F` challenge and the PSoul login extras (language byte,
  character-list extras, poll byte, `U16` light hour).
- Rendered without desync: `0xFF` sub-opcodes `0x01` skills/move bar, `0x09` cooldown,
  `0x0A/0x0B/0x0C/0x11` Pokédex, `0x0D` TM window, `0x0E/0x0F/0x10` status icons, `0x13`
  creature effect, `0x1A` loot list; standard `0xAB` channel list (`U16` count), `0xC8` outfit
  window, `0xDD` map marks; four extra creature bytes and `U16` magic-effect ids.
- Not exercised in the GUI: market `0xF4–0xF9` (NPC not spawned), poll `0xFA/0xFB` (no poll rows),
  doll case/slot machine/TV/level-up sub-opcodes.
- Client → server: only extended-opcode id 10 (dash walking) has a server handler
  (`game.cpp:7714-7730`); `registerCreatureEvent("ExtendedOpcode")` is dead (no Lua event). The
  `Locale` extended opcode is never sent by the client; language travels in the login packet and
  is stored in `accounts.lang_id` — this is the migration item BUG-09 (stock OTClient does not
  send that byte) and the robustness item BUG-08.
- Probe additions (`tools/protocol_probe.py`, documented in `docs/BUILDING.md §6`): `--use-on-tile
  SID:self|X,Y[:STACK]`, `--use-corpse`, `--wait-dead`, `--raw`, `--call-poke`. Server-side
  "use with" resolves the target by exact stackpos (`Actions::executeUse`), which is why the
  incubator test needed `:3`.
- No packet was redesigned.

## 8. Content Findings

- **Early-game difficulty**: a level-5 Trainer loses 40–50 of 50 HP per wild hit on Beginner
  Island (BUG-13, observed, not changed).
- **Unspawned / gated NPCs**: the Kanto bank NPCs (Billy, Cage, Chris, Cole, Craig, Daimon, Lars,
  Arthur Jones, Shayne Pete) exist only in the unused `world/-spawn.xml`; live ungated banks are
  Emmet Cash (4709,130,6), Hedley Mort (2753,2833,7), Hilary Aston (2710,2455,8); Todd Clancy is
  island-gated (BUG-15). Item-market NPC Jaron Jewell is not spawned (BUG-23). Halloween NPCs
  Trevor/Hermitwo/Selam are on the live map although the event is off.
- **Events**: Anniversary runs hourly on every server (`globalevents.xml:13`, `onKill.lua:8`);
  Easter, Halloween, Christmas and July Vacation are switched off by commented hook lines, not by
  dates or config. Nothing was flipped; safe inspection recipes are in the matrix §2.9.
- **Tournaments**: ids 2/3 commented in `XML/tournaments.xml` → startup warnings and a truncated
  NPC list (BUG-20).
- **Species data**: `"Strenght"` typo in 11 species (BUG-30); Mudkip/Latias/Latios have Dive
  without dive outfit/speed (BUG-50); `inverval` typo in 631 monster XMLs (BUG-47);
  `nidorina.lua eggId = 0`; duplicate `yereblu` ball key (harmless).
- **Citizens**: ~60 `tmpCitizen_*` NPC files are regenerated in `server/data/npc/` on every start
  (git-ignored).
- **Text/cosmetics**: fractional experience messages (BUG-07), "Remaing 60 minutes (1 days)"
  (BUG-29), Wiki Chat greeting omits the existing Spanish tree (BUG-55), `[%x]` hex format in
  reward texts.
- **Database**: `psoul_extra_mysql.sql` is mandatory — without `poketrader_*`, `ball_pillars`,
  `polls`, `tournaments` the startup scripts fail (Phase 1 saw `Npc with name 'Tiger Kelsey' not
  found`). All extra tables now receive rows at runtime (`ball_pillars`, `polls` schema,
  `tournaments`, `datalog_online`).

## 9. Historical Code

The four historical trees were kept untouched as required: `server/data/lib/ps/config/_pokemon/`,
`server/data/lib/ps/others/pokemon_backup/`, `server/data/lib/ps/others/moves_disabled/`,
`server/data/lib/ps/systems/disabled/`. `docs/HISTORICAL_CODE_DIFF.md` documents how they differ
from the live tree and now carries a Phase 2 verification note: the Lua loader is non-recursive
(`luascript.cpp:721-740`), no path references these directories, and the `005-task.lua` "OLD TASK
SYSTEM" canary never appeared in any of the six server start-ups of this phase.

The 12 Phase 1 defects were classified in `docs/BUG_TRIAGE.md §Classification`: 1 BUG
(`EFFECT_SILVERBALL_US` typo), 4 DEAD CODE (`ExtendedOpcode` registration, `game_shop` / opcode
103, `Soya.xml`, `PS_LIB_SKILLS_DIR`), 5 HARMLESS (Locale-opcode premise, duplicate `yereblu`
key, EXP threshold formulas are equivalent, "Meowth Super Rocket" and "Rocket Missile" are wired
to Team Rocket content), 2 HISTORICAL BACKUP (the four trees above). Two additional findings:
BUG-08 (BUG, P2) and BUG-09 (REQUIRES LATER MIGRATION). Nothing from these lists was deleted.

## 10. Redemption Readiness

Not started, by instruction. What Phase 2 established that a port will need:

- **Known-good reference behaviour**: the PASS rows of §3 and the matrix are the acceptance
  tests for a new client; `tools/protocol_probe.py` is an executable specification of
  login/enter/combat/use packets and can drive either client.
- **Server-side blockers to fix first** (`fix before Redemption = yes` in the triage): BUG-08
  (validate the language byte), BUG-09 (decide how the locale reaches the server when the stock
  login packet has no such byte — most likely move it to an extended opcode), BUG-01 (keep `pvp`
  or fix `canDoCombat` ordering), BUG-02/03 already fixed.
- **Client-side items that disappear with a rewrite**: BUG-11/12/57 (layout, hidden slots, console
  noise), the dead `game_shop` module and `ExtendedOpcode` registration (BUG-38), the hard-coded
  AES asset key (BUG-56 — Redemption loads plain `data/` so the layer can be dropped).
- **Protocol surface to implement**: version 312 + OTClient OS id, forced features
  (MagicEffectU16, CreatureIcons, PlayerMarket, SpritesAlphaChannel, addons, stamina, emblems,
  challenge), character-list extras + poll byte, `U16` light hour, four extra creature bytes, the
  `0xFF` family (26 sub-opcodes, 12 of them now GUI-verified), market `0xF4–0xF9`, poll
  `0xFA/0xFB`, `U16` channel count in `0xAB`; assets `data.dat`/`data.spr` (8.54 format) and
  PSoul's `items.otb`.
- **Not ready**: no automated regression beyond the probe; gyms, badges, PvP arena, market UI,
  polls and events have never been observed working and must be verified server-side before a
  client port can be blamed for them.

## 11. Recommended Phase 3

1. Finish the NOT TESTED backlog of the matrix §2 on the server side (gyms/badges, Surf/Dive/Cut
   and the other field abilities, daycare and egg hatch, PvP arena/duels, Safari, Elite Four,
   Team Rocket, World Boss, dungeons, mastery, item market with a spawned Jaron Jewell, polls with
   seeded rows, TV). Each already has reach instructions and suspected defects.
2. Fix the P1/P2 server defects that do not depend on the client: BUG-01 (proper `canDoCombat`
   fix instead of the config change), BUG-08, BUG-16, BUG-17, BUG-31, BUG-36/37, BUG-45; then the
   cheap verified P3/P4 items (BUG-04, BUG-05 GM energy, BUG-06, BUG-07, BUG-20, BUG-21, BUG-22,
   BUG-29).
3. Decide the website question: either a minimal local AAC (account/character creation,
   Soul Coins, premium, coupons, polls) or in-game substitutes behind a dev flag; without it the
   economy, guild and premium systems cannot be fully tested.
4. Content decisions (not code): Anniversary auto-start, early-game damage, unspawned bank/market
   NPCs, tournaments 2/3.
5. Add a repeatable smoke test: probe-driven login → starter → battle → catch → heal run plus
   `tools/check_syntax.sh` in CI, so the baseline established here stays verifiable.
6. Only then begin the OTClient Redemption migration using §10 as the checklist, starting with the
   login-packet locale decision (BUG-09) because it changes a packet both sides must agree on.
