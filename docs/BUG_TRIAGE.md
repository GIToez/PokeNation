# Bug triage (Phase 2, extended in Phase 2A)

Every defect found while building, running and testing the PSoul baseline, prioritised. Entries
marked **verified** were reproduced on the local server/client (see `docs/PHASE_2_TEST_MATRIX.md`
for the exact test); entries marked **inferred** come from reading the code and have not been
executed. Nothing here was fixed unless the entry says so — Phase 2 only applied the small fixes
that were required to keep testing (build fixes, seed data, the `worldType` default, the client
StaticText crash).

Severity: **P0** prevents server/client running · **P1** breaks core Pokémon gameplay · **P2**
breaks a major game system · **P3** minor gameplay/content bug · **P4** cosmetic / cleanup / dead
code. "Before Redemption" = should be fixed before or during the OTClient Redemption migration.

## Summary

| ID | Sev | Status | Title | Before Redemption |
|---|---|---|---|---|
| BUG-01 | P1 | fixed (config) | `worldType = "no-pvp"` makes every NPC trainer battle unwinnable | yes (keep `pvp`) |
| BUG-02 | P0 | fixed | Server and client do not compile with current Boost / libxml2 / CMake | yes |
| BUG-03 | P0 | fixed | Client crash (Lua stack) on monster yell StaticText | yes |
| BUG-04 | P3 | open | Autoloot OFF is never persisted | no |
| BUG-05 | P3 | open | GM groups (infinite mana) cannot use Pokémon moves | no |
| BUG-06 | P3 | open | `onLogout.lua` Lua errors when a player disconnects mid NPC battle | no |
| BUG-07 | P4 | open | Fractional experience in messages ("1153.125 experience points") | no |
| BUG-08 | P2 | open | Unvalidated login language byte can null-dereference `Localization::t` | yes |
| BUG-09 | P0 (port) | open | Custom locale byte in the login packet is incompatible with stock OTClient | yes (migration) |
| BUG-10 | P3 | fixed (seed) | Evolve icon (13204) missing from the dev starting kit | no |
| BUG-11 | P3 | open | Client: Pokémon bar overlaps the move bar | yes (UI rewrite) |
| BUG-12 | P3 | open | Client hides inventory slots 2 and 3; `/i` items land in the hidden backpack | yes (UI rewrite) |
| BUG-13 | P3 | open (content) | Level-5 trainer loses 40–50 of 50 HP per wild hit (near one-shot) | no |
| BUG-14 | P3 | open | Anniversary event permanently active (hourly raid, bag drops) | no |
| BUG-15 | P3 | open (content) | Kanto bank NPCs only exist in the unused `-spawn.xml`; island NPCs gated | no |
| BUG-16 | P2 | open (inferred) | Gym badges can never appear: badge placeholders are created by nothing | no |
| BUG-17 | P2 | open (inferred) | PvP arena think-loop runtime error every 10 min | no |
| BUG-18 | P3 | open (inferred) | "Minion Cake" kills give no anniversary token (dropped `killer`) | no |
| BUG-19 | P4 | open | "Your X is hungry!" every minute | no |
| BUG-20 | P4 | open | Tournament ids 2/3 commented → startup warnings and truncated NPC list | no |
| BUG-21 | P4 | open | `tm.lua` / `ballSeal.lua` cancel branches do not `return` ("Item not found" error) | no |
| BUG-22 | P4 | open | `EFFECT_SILVERBALL_US` typo (Draco ball shows a blood splash) | no |
| BUG-23 | P3 | open (content) | Item-market NPC Jaron Jewell is not spawned | no |
| BUG-24 | P4 | open | Disabled login hooks: first-Pokémon grant and automatic town marks | no |
| BUG-25 | P4 | open | `update_rank()` stored procedure missing; highscore tables static | no |
| BUG-26 | P4 | open (inferred) | `isPokemonName` is case-sensitive → species names accepted as nicknames | no |
| BUG-27 | P3 | open (inferred) | PROTECTION/HEALBLOCK/PREVENTSTATSCHANGE conditions share the ENDURE subid; Miracle Eye mismatch | no |
| BUG-28 | P3 | open (inferred) | Held item: nil compare at level 6→7; Dragon Fang boosts Fire | no |
| BUG-29 | P4 | open | Incubator text "Remaing 60 minutes (1 days)" | no |
| BUG-30 | P3 | open (inferred) | `"Strenght"` typo in 59 species (`BROKEN_REFERENCES.md`) → Strength never available | no |
| BUG-31 | P2 | open (inferred) | Pokémon Market: seller not paid when the depot letter fails; `LIMIT 1` inside SQL string | no |
| BUG-32 | P3 | open (inferred) | PokeTrader `getPlayerBoughtOnPokeTrader` always true after one purchase | no |
| BUG-33 | P3 | open (inferred) | `bonusDef` reads the attack bonus (copy-paste) | no |
| BUG-34 | P3 | open (inferred) | `getCurrentTimeInSeconds` is day-of-year based → cooldowns/incubators wrap at New Year | no |
| BUG-35 | P3 | open (inferred) | Pokédex code indexes nil when no Pokédex is equipped | no |
| BUG-36 | P2 | open (inferred) | Market window dead for players who never opened a depot | no |
| BUG-37 | P2 | open (inferred) | Market purchase deletes items when the buyer's depot add fails | no |
| BUG-38 | P4 | open | Dead code: `ExtendedOpcode` registration, `game_shop` module, `Soya.xml`, `PS_LIB_SKILLS_DIR`, `003-quest.lua.bak` | partly (Lua opcode dispatcher) |
| BUG-39 | P4 | keep | Historical backup trees under `data/lib/ps` (not loaded) | no |
| BUG-40 | P4 | n/a | Phase 1 items re-classified as HARMLESS (see §Classification) | no |
| BUG-41 | P3 | open (inferred) | Surprise boxes never spawn east of x=2048 (`MAP_MAX_WIDTH`) | no |
| BUG-42 | P3 | open (inferred) | Ranger Club ranks with duplicated ids | no |
| BUG-43 | P3 | open (inferred) | World Boss `sotrageLastBoss` typo | no |
| BUG-44 | P3 | open (inferred) | Team Rocket battles give no reward (code commented) | no |
| BUG-45 | P2 | open (inferred) | Dungeon reset removes every creature in the area, players included | no |
| BUG-46 | P3 | open (inferred) | `evolve.lua:35` precedence lets level-only evaluation bypass day/night gates | no |
| BUG-47 | P4 | open | `inverval` typo in 631 monster XMLs (wild "Evolve" ticks every 2 s) | no |
| BUG-48 | P3 | open (inferred) | `onPokemonDeath.lua` assumes the ball is still in the feet slot | no |
| BUG-49 | P4 | open | `pokemon.lua:121` references undefined `cid` | no |
| BUG-50 | P3 | open (inferred) | Mudkip / Latias / Latios list Dive but have no dive outfit or speed | no |
| BUG-51 | P4 | open | Bank `selfSay` without `cid` on failure paths | no |
| BUG-52 | P4 | open | Poll option id sent as one byte; market/poll config keys absent | no |
| BUG-53 | P4 | open (inferred) | Daily quest remaining-time maths | no |
| BUG-54 | P3 | open (inferred) | Coupon types other than 0 consume the code without reward | no |
| BUG-55 | P4 | open | Wiki Chat greeting omits the existing Spanish tree | no |
| BUG-56 | P2 (security) | open | Hard-coded AES asset key/IV in client source | yes |
| BUG-57 | P4 | open | Client console `CAST ERROR … TPoint<int>` noise, `tmchoose.lua` connect/disconnect leak | yes (UI rewrite) |
| BUG-58 | P4 | open (inferred, Phase 2A) | `checkCorpseOwner ` read with a trailing space → config key ignored | no |
| BUG-59 | P3 (latent) | open (inferred, Phase 2A) | Client doll-case count `U16` read into `uint8_t` → desync ≥256, infinite loop at 255 | yes |
| BUG-60 | P4 (latent) | open (inferred, Phase 2A) | Same `uint8_t` truncation for the level-up move list | yes |
| BUG-61 | P4 | open (inferred, Phase 2A) | Server-driven move bar open/close fires events no module listens to | yes |
| BUG-62 | P4 (latent) | open (inferred, Phase 2A) | Account Manager charlist entry lacks OTClient extras (only if `accountManager = true`) | yes |
| BUG-63 | P4 (latent) | open (inferred, Phase 2A) | `AdvancedSave` vs `AdvanceSave` event name | no |
| BUG-64 | P4 | open (inferred, Phase 2A) | `onLogout_EliteFour` registered but not defined | no |
| BUG-65 | P4 | open (inferred, Phase 2A) | `rateMonsterExperienceMultiplier` read but unused | no |
| BUG-66 | P4 | open (inferred, Phase 2A) | `blessingsOnlyPremium` vs `blessingOnlyPremium` | no |
| BUG-67 | P4 | open (inferred, Phase 2A) | Client `0xFF` dispatcher has no `default` case | yes |
| BUG-68 | P3 (security) | open (inferred, Phase 2A) | Game-login challenge bytes skipped, never compared | yes |
| BUG-69 | P4 | open (inferred, Phase 2A) | `game_environment` module (ambient sound/shaders) never loaded | yes (client) |
| BUG-70 | P4 (ops) | open (Phase 2A) | Test-server NPCs (`npc/scripts/testserver_*.lua`) ship in the datapack | no |
| BUG-71 | P4 (dev seed) | open, verified (Phase 2A) | Dev seed pre-fills the starting kit that Oak hands out again → duplicate kit | no |
| BUG-72 | P3 | open, verified (Phase 2A) | Server never exits after SIGTERM / `/shutdown` (inherited TFS 0.3.6 `ServiceManager` flag) | no |
| BUG-73 | P2 (low-end GPUs) | open, verified (Phase 2A, Windows CI) | Client crashes 2-3 s after start when the 1920x1080 animated background exceeds the GPU's maximum texture size (`AnimatedTexture` left half-initialised) | yes |

---

## P0 / P1

### BUG-01 — `worldType = "no-pvp"` makes NPC trainer battles unwinnable — **verified, fixed in config**
- Description: with the archive's `worldType = "no-pvp"`, starting a battle with any NPC trainer
  works, but every attack by the player's Pokémon is refused with "You may not attack this
  creature." while the NPC's Pokémon attacks freely; the player cannot log out ("You can't logout
  while you're battleing.") until defeated.
- Repro: Tester at Chandra Wigington (3299,246,10): `hi`, `battle`, `yes`, attack the Golem.
- Source: `server/src/combat.cpp:298-331` (`Combat::canDoCombat`): line 313 refuses any attack on a
  creature with a master under `WORLD_TYPE_NO_PVP` unless both are in a PvP zone, before the
  NPC-opponent exception at 322-326 is reached.
- Fix applied (Phase 2): `worldType = "pvp"` in `server/config.example.lua:58-63` with a comment;
  player-vs-player is still blocked by `combat.cpp:272-284` (duel/arena only), so this is
  behaviour-neutral for players. Proper fix: move the NPC-opponent check above the no-pvp check.
- Before Redemption: keep `pvp`, or fix the ordering in C++.

### BUG-02 — Build breaks on modern toolchains — **verified, fixed**
- Server: Boost.Asio deprecated API (`io_service`, `deadline_timer`, `resolver::iterator`),
  `xmlGetLastError()` constness (libxml2 ≥ 2.12). Client: same Asio API set (removed in Boost ≥ 1.87
  as shipped by MSYS2), `TPoint::getLength` (GCC 15 template-body check), `cmake_minimum_required
  (VERSION 2.6)` refused by CMake 4. Fixed in commits `8cd5565`, `dd89b31`, `acc55e9` and the
  Phase 1 asio port; CI (`.github/workflows/build.yml`) builds both on Ubuntu 24.04 and MSYS2.

### BUG-03 — Client crash on monster yell — **verified, fixed**
- `StaticText` pushed the wrong number of Lua values when a monster yelled (`Caterpie: BUG BITE`
  style yells) → `assert` in RelWithDebInfo. Fixed in `client/src-cpp` (Phase 2), the GUI client
  now sits in combat without crashing.

### BUG-08 — Unvalidated language byte → null dereference — **inferred**
- `server/src/protocollogin.cpp:83-89,162-165` stores any byte as `accounts.lang_id`;
  `server/src/localization.cpp:335-344` does `(*languages[lang])` on a map populated only for
  1 and 2 → NULL deref for ids ≥ 3 on the first `__L()` call after login. Fix: clamp in
  `protocollogin.cpp`, validate in `IOLoginData::getAccountLanguage`, `find()` with fallback in
  `Localization::t`. Before Redemption: yes.

### BUG-09 — Login locale byte incompatible with stock OTClient — **inferred, migration item**
- `client/modules/gamelib/protocollogin.lua:36-39` appends a `U8` locale after OS/version; the
  server consumes it for OTClient OS ids with `version >= 293` (`protocollogin.cpp:86-89`). A stock
  Redemption `ProtocolLogin` does not send it → RSA block misaligned → disconnect. Must be handled
  in the protocol work (drop the byte server-side and take the language from `/lang` or an
  extended opcode).

## P2

### BUG-16 — Gym badges never appear — inferred
- `lib/ps/systems/001-npcBattle.lua:500-502 doPlayerGiveBadge` transforms an existing placeholder
  (`BADGES[].oldItemId`) in the badge case into the badge; nothing in the repo (seed, website-less
  character creation, quests) creates the placeholders and the seeded case 12280 is empty.
- Repro: beat Brock (3309,279,10; requires 7 route trainers) and open the badge case.
- Fix: create placeholders in `doPlayerAddMainItems` / seed, or make `doPlayerGiveBadge` add the
  badge when no placeholder exists.

### BUG-17 — PvP arena runtime error — inferred
- `lib/ps/systems/009-pvpArena.lua:199-211`: `ipairs(LAST_EVENTS)` passes the arena **table** to
  `getPvpArenaUsers`, `#users >= 0` is always true, `table.random` on the empty
  `itemRaids.positions` (comment "TODO POS FIX") raises every 10 min once an arena has users.

### BUG-31 — Pokémon Market seller not paid — inferred
- `server/data/npc/scripts/shop_pokemonMarket.lua:163-185` returns before
  `doPlayerAddBalanceByName` when the depot letter cannot be created (buyer already has the
  Pokémon); `:49` has `LIMIT 1` inside the quoted id.

### BUG-36 / BUG-37 — Item market — inferred
- `server/src/protocolgame.cpp:3617-3624` returns before `setInMarket(true)` when the player has no
  depot → browse/create ignored. `server/src/game.cpp:7466-7484` uses the seller's
  `getLastDepotId()` for the buyer and `delete`s items on add failure (item loss). Both unreachable
  today because the only entry NPC is unspawned (BUG-23).

### BUG-45 — Dungeon reset removes players — inferred
- `lib/ps/systems/028-dungeons.lua` reset uses `getSpectators(..., false)` and removes all
  creatures in the area.

### BUG-56 — Hard-coded AES key/IV in the client source — verified (by reading)
- `client/src-cpp/src/framework/util/crypt.cpp:516-517` (`Crypt::__aesDecrypt`, compiled only with
  `-DENCRYPTED_ASSETS=ON`). The key protects nothing once the source is public. See
  `docs/SECURITY_AUDIT.md §3`. Fix before any public release: drop the asset encryption layer or
  move to a build-time secret; never reuse that key.

## P3

### BUG-04 — Autoloot OFF never persisted — verified
- Repro: `/autoloot` → "Auto Loot OFF!", relog, `/autoloot` → "Auto Loot OFF!" again.
- Source: C++ default `autoLoot = true` (`server/src/player.cpp:69`); `login.lua:183-185` only
  applies a saved `true`. Fix: save and restore both states (`setPlayerAutoLootSave` with an
  explicit 0/1 and read it unconditionally at login).

### BUG-05 — GM groups cannot use moves — verified
- Repro: GM Admin, any `m1`: "Sorry, your Pokemon has insufficient energy (12)." Energy shown
  `0/0`. Cause: PSoul uses mana as Pokémon energy; `PlayerFlag_HasInfiniteMana` (groups 4–6 in
  `data/XML/groups.xml`) zeroes the reported mana. Fix: special-case the flag in
  `003-skill.lua:70-80` (treat infinite mana as enough energy) or remove the flag from the dev GM
  group. Workaround used in Phase 2: test with group-1 characters.

### BUG-06 — `onLogout.lua` errors when a battling player disconnects — verified
- Console: `(internalGetPlayerInfo) Player not found when requesting player info #18`,
  `(luaDoTeleportThing) Thing not found`, `(luaDoCreatureSetStorage) Creature not found`,
  `(luaGetCreatureStorage) Creature not found` (`lib/ps/events/creaturescripts/onLogout.lua`).
  The battle-end handler runs after the player object is gone. Fix: guard with `isPlayer(cid)` or
  end the battle in `onLogout` before the creature is removed.

### BUG-10 — Evolve icon missing from the dev kit — verified, fixed (`psoul_dev_seed.sql`, commit `73b854c`).

### BUG-11 / BUG-12 — Client layout — verified
- The Pokémon bar is drawn over the move bar at the bottom-left of the game view (GUI screenshot
  P2-33). The inventory window comments out `NeckSlot` (2) and `BackSlot` (3)
  (`client/modules/game_inventory/inventory.otui:87,101`), so the evolve icon and the slot-3
  backpack where `/i` puts items are invisible (the server still uses both slots). Both are UI-module issues to redo during
  the Redemption migration; no server change needed.

### BUG-13 — Early-game damage — verified (content observation, not changed)
- Trainer level 5 (50 HP): "You lose 49 hitpoints due to an attack by a Spearow.", "You lose 40
  hitpoints due to an attack by a Rattata." near the Pewter PC. Wild Pokémon target the trainer
  when the Pokémon is recalled. Whether this is intended (the original server had Beginner Island
  with its own spawns) cannot be decided here; no rebalancing was done.

### BUG-14 — Anniversary event permanently active — verified (broadcast "Cake Minions" ≈1 h after boot)
- `globalevents/globalevents.xml:13` (every 3600 s) → `AnniversaryEvent.doStartEvent`;
  `creaturescripts/onKill.lua:8` active; `start.lua:159` "remove after event end". Fix (when the
  team decides): comment the globalevent and the onKill hook like the other four events; do **not**
  delete the system.

### BUG-15 / BUG-23 — Unspawned or gated NPCs — verified
- Bank NPCs Billy, Cage, Chris, Cole, Craig, Daimon, Lars, Arthur Jones, Shayne Pete and the
  market NPC Jaron Jewell exist as `npc/*.xml` but are not in `world/map-spawn.xml` (only in the
  stale `world/-spawn.xml`). Island bank/Soul-Trade NPCs (Todd Clancy, Erik) answer "You do not
  have enough access to deal here!" without Orange Archipelago access. Ungated banks on the live
  map: Emmet Cash (4709,130,6), Hedley Mort (2753,2833,7), Hilary Aston (2710,2455,8).

### BUG-18 — `anniversary_onDeath.lua:5-6` drops the `killer` argument for "Minion Cake" — inferred.

### BUG-27 — Condition subid copy-paste — inferred
- `lib/ps/systems/008-conditions.lua:252-262`: PREVENTSTATSCHANGE / HEALBLOCK / PROTECTION are
  created with `CUSTOM.ENDURE`; getters use their own subids → never detectable, "PROTECTED" branch
  in `004-skillDamage.lua:374-377` dead; `:236` Miracle Eye subid mismatch.

### BUG-28 — Held items — inferred
- `046-heldItem.lua:446-449` `EXP_TABLE[8]` nil compare when passing level 6 with surplus exp;
  `:89` Dragon Fang declared `ELEMENT_FIRE`.

### BUG-30 / BUG-50 — Ability tables — inferred
- `"Strenght"` in 59 species files under `lib/ps/config/pokemon/` (e.g. `aggron,claydol,linoone,shelgon,seviper,regice,vibrava,rayquaza,groudon,manectric,delcatty.lua:17`; full list in `BROKEN_REFERENCES.md`);
  Mudkip/Latias/Latios lack `OUTFIT_DIVE_*` and `DIVE_SPEED` entries (`lib/ps/others/outfits.lua`,
  `lib/ps/functions/abilities.lua:234-291`).

### BUG-32 — PokeTrader purchase flag — inferred (`poketrader.lua:11-25`, `repeat ret = true until not dbResult:next()`).

### BUG-33 — `lib/ps/functions/pokemon.lua:227` `bonusDef` reads `bonusAtk` — inferred.

### BUG-34 — Day-of-year clock — inferred
- `lib/ps/systems/007-cooldown.lua:1-4`; `eggIncubator/fullIncubator.lua:14-21` already contains a
  "Bug fix" hack for it. Fix: use `os.time()`.

### BUG-35 — Pokédex nil index — inferred (`010-pokedex.lua:109,515,546`; seed characters are fine because slot 6 is populated).

### BUG-41 … BUG-45, BUG-46, BUG-48, BUG-54 — see the summary table; all inferred from
`034-surpriseBox.lua`, `001-rangerClub.lua:30,39,48`, `021-boss.lua:266`,
`050-rocketBattle.lua:510-626`, `028-dungeons.lua`, `evolve.lua:35`,
`onPokemonDeath.lua:17-19`, `coupon.lua`.

## P4

- **BUG-07** "Your Pidgeot received 1153.125 experience points." — `lib/ps/functions/player.lua`
  `doPlayerPokemonAddExperience` formats a float; `math.floor` before the message.
- **BUG-19** hunger message once per minute (`lib/ps/functions/pokemon.lua` hunger think) — verified in the GUI.
- **BUG-20** tournaments 2/3 commented in `XML/tournaments.xml:25-66`; `npc/scripts/tournament.lua:21-30` iterates all ids (`[Warning - Tournaments::getTournament]` ×2 at startup) and `ipairs` stops at the hole → Joey lists only "Titan".
- **BUG-21** `lib/ps/events/actions/tm.lua:2-4`, `ballSeal.lua:2-4`, `ballSealRemover.lua:2-4` cancel without `return` (observed `(luaGetItemAttribute) Item not found`).
- **BUG-22** `lib/ps/config/balls.lua:973` `EFFECT_SILVERBALL_US` → `EFFECT_SILVERBALL_USE` (effect 0 = blood splash shown instead).
- **BUG-24** `creaturescripts/scripts/login.lua:57` (first Pokémon from `players.firstpokemon`) and `:67` (town marks) commented; `getPlayerFirstPokemon` has the same `LIMIT` quoting bug.
- **BUG-25** `start.lua` "Loading Ranks" would call `update_rank()` (defined in no schema) if `updateHighscores` were true.
- **BUG-26** `lib/ps/config/pokemonsNames.lua:857` discards `string.lower`.
- **BUG-29** `fullIncubator.lua:32` "Remaing %s" and `math.ceil(remaingTime/86400)` days for a 60-minute timer.
- **BUG-38** dead code: `protocolgame.cpp:302-304` registers a non-existent `ExtendedOpcode` creature event; `client/modules/game_shop` never loaded (opcode 103 never sent, item 3028 is a corpse here); `npc/Soya.xml` → missing `loot.lua`; `lib/999-ps.lua:6 PS_LIB_SKILLS_DIR`; `lib/ps/config/003-quest.lua.bak`.
- **BUG-47** `inverval` typo in 631 `monster/Pokemons/*.xml` → wild "Evolve" attack uses the default 2000 ms interval.
- **BUG-49** `lib/ps/functions/pokemon.lua:121` undefined `cid`.
- **BUG-51** `bank.lua:165,181,232,252,263` `selfSay(...)` without `cid`.
- **BUG-52** `protocolgame.cpp:4871` poll option id as `U8`; `configmanager.cpp:301-305` market/poll keys missing from `config.lua` (silent defaults: premium-only market, poll level 25).
- **BUG-53** `002-quest.lua:416-420`.
- **BUG-55** `lib/ps/config/002-wikiChat.lua:1-5` greeting lists two languages, tree has three.
- **BUG-57** client console `CAST ERROR: failed to cast value of type 'std::string' to type 'TPoint<int>'` (harmless), `game_tmchoose/tmchoose.lua:111-114` `connect` instead of `disconnect` in `onTerminate`.

---

## Classification of the 12 Phase 1 defects

| # | Phase 1 item | Classification | Sev | Evidence | Fix before Redemption |
|---|---|---|---|---|---|
| 1 | Missing `ExtendedOpcode` creature event | DEAD CODE | P4 | `protocolgame.cpp:302-304` registers it; `creaturescripts.xml` has no `type="extendedopcode"`; only client→server opcode in use (10, dash walking) is handled in C++ `game.cpp:7714-7730` | No today; add a Lua dispatcher when Redemption modules start sending opcodes 0/1/201 |
| 2 | Client Locale opcode "ignored" | HARMLESS (premise wrong) | P4 | `client_locales/locales.lua:8-15` stub never sends opcode 1; the locale travels as a byte in the login packet (`protocollogin.lua:39` ↔ `protocollogin.cpp:86-89`) and is stored in `accounts.lang_id`; `/lang` overrides | Yes, as part of the login-protocol work (BUG-09) |
| 3 | Extended opcode 103 orphaned (`game_shop`) | DEAD CODE | P4 | module not autoloaded nor in `interface.otmod`; server never sends 103; triggers (`#vip30#`, `/clan`) do not exist; currency item 3028 is a corpse here | No; delete the module before porting |
| 4 | Duplicate `yereblu` key in `balls.lua` | HARMLESS | P4 | `balls.lua:306-312` and `:313-319` byte-identical; second wins | No |
| 5 | `EFFECT_SILVERBALL_US` typo | BUG | P4 | `balls.lua:968-974`; nil → effect 0 (blood) via `luaDoSendMagicEffect`; Draco ball obtainable (`shop_ballPaint.lua:190`) | No (one-character fix any time) |
| 6 | Pokémon EXP threshold `level` vs `level-1` | HARMLESS (equivalent formulas) | – | `player.lua:459` inline `f(level)` ≡ `getExperienceForLevel(level+1)` (`lib/050-function.lua:162-165` subtracts 1 first); same in C++ `player.h:176-180` | No |
| 7 | `Soya.xml` → missing `loot.lua` | DEAD CODE | P4 | stock TFS equipment buyer, not in any spawn file; only reachable via `/n Soya` (warning, NPC not created) | No |
| 8 | "Meowth Super Rocket" move | HARMLESS (premise wrong) | P4 | wired to `spells.xml:494` and `monster/Events/Christmas/team rocket.xml:24`; raid commented out (`raids.xml:14-18`) | No — keep the file |
| 9 | "Rocket Missile" move | HARMLESS | P4 | `spells.xml:492`; used by `team rocket.xml:22` and `rocket bot.xml:22` | No — keep |
| 10 | Dangling `PS_LIB_SKILLS_DIR` | DEAD CODE | P4 | `lib/999-ps.lua:6`; no `lib/ps/skills/` dir; no reader | No |
| 11 | `config/_pokemon/`, `others/pokemon_backup/` | HISTORICAL BACKUP | P4 | loader is non-recursive (`luascript.cpp:721-740`), neither path referenced; content differs from the live tree (see `docs/HISTORICAL_CODE_DIFF.md`) | No (keep; archive later) |
| 12 | `others/moves_disabled/`, `systems/disabled/` | HISTORICAL BACKUP | P4 | same loader argument; `005-task.lua:1` prints its own "OLD TASK SYSTEM" canary, never seen in any run log | No |

Additional classification found during the review: A1 = BUG-08 (BUG, P2), A2 = BUG-09 (REQUIRES
LATER MIGRATION), A3 `/lang` overwritten at each login (HARMLESS, P4), A4 sv/de/pl/es locales map to
the empty `LANG_ES_ES` (HARMLESS, P4), A5 `game_shop` latent bugs (fold into #3), A6
`003-quest.lua.bak` (HISTORICAL BACKUP, P4, BUG-38).

The four historical trees are **kept** as required (`config/_pokemon/`, `others/pokemon_backup/`,
`others/moves_disabled/`, `systems/disabled/`); Phase 2 re-verified that the loader never touches
them (no "OLD TASK SYSTEM" line in any server log of this phase).


---

## Phase 2A additions (BUG-58 … BUG-73)

BUG-58…BUG-70 come from the fresh full-source audit (`FULL_SOURCE_AUDIT.md §17`, with file:line
evidence there). BUG-58 and BUG-68 were re-checked by reading the cited lines. None was fixed:
Phase 2A only restructures build and distribution.

### BUG-71 — Dev seed duplicates the starting kit — verified
`psoul_dev_seed.sql` puts the main items (100 Poke Balls 12157, 100 Cookies 2687, 20 potions
12244, rope 2120, old fishing rod 12292) into Trainer's pokebag. Professor Oak then calls
`doPlayerAddMainItems` when handing out the starter (`npc/scripts/quest_professorOak.lua:111`,
`lib/ps/functions/player.lua:717-723`), so the kit is added a second time and lands in the next
container with free space (seen in the badge case, sid 103). Only the development seed is
affected; real characters created by the original website had an empty bag. The +4 levels on
the first login of a level-1 character outside the beginner island are intended
(`creaturescripts/scripts/login.lua:48-59`). Fix: remove the kit from Trainer's seed rows, or
keep it only for GM Admin and Tester, who never meet Oak.

### BUG-72 — Server process does not exit after shutdown — verified
After SIGTERM (or `/shutdown`), the server kicks and saves everyone and prints
`Preparing to shutdown the server- done.`, but the process stays alive in `epoll_wait` with one
thread. `ServiceManager::run()` (`server/src/server.cpp:213-226`) sets `running = true` only
*after* `m_io_service.run()` returns, so `ServiceManager::stop()` (`:228-233`) sees
`running == false` and returns without closing the acceptors or stopping the io_service.
`Game::shutdown()` calls `exit(1)` only in non-console Windows builds (`game.cpp:6685-6688`).
Inherited from TFS 0.3.6. Workaround: kill the process after the "- done." line; the data is
already saved. Ctrl+C (SIGINT) is not handled and ends the process at once without the shutdown
save. Fix (Phase 3): set `running = true` before `m_io_service.run()`.

### BUG-73 — Client crash when a texture exceeds the GPU's maximum size — verified (Windows CI)
On the GitHub Windows runner (no GPU, Windows "GDI Generic" OpenGL 1.1, maximum texture size
1024x1024) the packaged client loads all 48 modules, logs
`ERROR: loading texture with size 1920x1080 failed, the maximum size allowed by the graphics card is 1024x1024`
and exits 2-3 s later with `0xC0000374` (heap corruption). Under gdb the unstripped build stops
with SIGSEGV in `AnimatedTexture::updateAnimation()` (`client/src-cpp/src/framework/graphics/animatedtexture.cpp:75`),
called from `TextureManager::poll()` (`texturemanager.cpp:61`). Cause: the constructor
(`animatedtexture.cpp:28-42`) returns early when `setupSize()` fails (`texture.cpp:173-179`),
leaving `m_framesDelay` empty and `m_currentFrame` uninitialised; `updateAnimation()` then
indexes the empty vector. The texture is `client/data/images/background.png`, an animated PNG
(APNG, 1920x1080) shown by `client_background` (`modules/client_background/background.otui:3`).
GPUs with real OpenGL 2 drivers report a maximum texture size of 4096 or more (current GPUs
16384), so normal PCs are not expected to hit this; GPU-less virtual machines, remote sessions without GPU acceleration and very
old drivers are. Inherited from OTClient. Not fixed: the legacy client is frozen
(`LEGACY_CLIENT_REFERENCE.md`). Fix (if the frozen client is ever patched): return early from
`updateAnimation()` when `m_frames` is empty, or initialise `m_currentFrame` and skip animated
textures that failed `setupSize()`.
