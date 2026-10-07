# Full source audit — PokeNation (PSoul / PokeAimar baseline)

Fresh audit of `server/src`, `server/data`, `client`, `original`, `tools` and `docs`, written after
Phase 2. It inventories every system found in the tree, says whether it is loaded, and how it is
reached. It does **not** re-test anything: "VERIFIED WORKING" is used only where
[`PHASE_2_TEST_MATRIX.md`](PHASE_2_TEST_MATRIX.md) records a PASS.

Companion documents:

* [`reference/FEATURES.md`](reference/FEATURES.md) — one row per player-facing feature.
* [`reference/OPCODES.md`](reference/OPCODES.md) — protocol reference with `file:line`.
* Catalogs maintained separately: [`reference/COMMANDS.md`](reference/COMMANDS.md),
  [`reference/POKEMON.md`](reference/POKEMON.md), [`reference/MOVES.md`](reference/MOVES.md),
  [`reference/POKEBALLS.md`](reference/POKEBALLS.md), [`reference/ITEMS.md`](reference/ITEMS.md),
  [`reference/NPCS.md`](reference/NPCS.md), [`reference/QUESTS.md`](reference/QUESTS.md),
  [`reference/ACHIEVEMENTS.md`](reference/ACHIEVEMENTS.md),
  [`reference/DATABASE.md`](reference/DATABASE.md), [`BROKEN_REFERENCES.md`](BROKEN_REFERENCES.md).
* Defect ids `BUG-01..57` are in [`BUG_TRIAGE.md`](BUG_TRIAGE.md); test ids `P2-xx` in the test
  matrix. New defects found here are listed in §17 (`BUG-58`…`BUG-70`, recorded in `BUG_TRIAGE.md`).

Paths are relative to the repository root. `server/data/...` is abbreviated `data/...` in the
long tables.

## Classification legend

| Tag | Meaning |
|---|---|
| **ACTIVE** | loaded/registered and reachable by a player or the server loop |
| **VERIFIED WORKING** | ACTIVE and PASS in PHASE_2_TEST_MATRIX (test id given) |
| **IMPLEMENTED / UNVERIFIED** | code complete and loaded, never exercised |
| **PARTIAL** | partly works / partly tested, or a known defect blocks part of it |
| **BROKEN** | loaded but cannot work as written |
| **DISABLED** | code present, deliberately switched off (commented XML, config flag, gate) |
| **HISTORICAL** | old copy / backup / superseded implementation |
| **UNUSED** | present, nothing loads or calls it, no obvious intent |
| **WEBSITE-DEPENDENT** | needs DB rows or actions that only the missing website produced |
| **CLIENT-DEPENDENT** | needs the custom OTClient protocol/module to be usable |
| **SAFE TO IGNORE** | no gameplay impact either way |

Several tags can apply. "Not loaded" never implies "dead": §15 says what would enable each
disabled system.

---

## 1. Tree overview

| Tree | Content | Notes |
|---|---|---|
| `server/src` | TFS 0.3.6 C++ + PSoul extensions, `CMakeLists.txt` (new), `schemas/` | 3 SQL schemas: `mysql.sql` (stock+PSoul columns), `psoul_extra_mysql.sql` and `psoul_dev_seed.sql` (both Phase 1/2 additions, only in the working tree) |
| `server/data` | Lua 5.1 + XML datapack | `lib/999-ps.lua` loads the PSoul layer (`lib/ps/**`) |
| `server/data/world` | `map.otbm` (Git LFS, only in working tree), `map-spawn.xml`, `map-house.xml`, `map-sound.xml(.lua)`, stale `-spawn.xml`, `-house.xml` | map name `map` in config |
| `client` | OTClient 0.6 fork: `src-cpp/src` (built), `src-cpp/vc12` (second copy of the C++ sources, unused by CMake), `modules/` (51 modules), `data/` (things 296 MB, images 71 MB, sounds 51 MB, shaders 640 KB) | |
| `original` | read-only archive import (`original/server/source`, `original/server/data`, `original/client`) | reference only |
| `tools` | build/run/DB scripts, `protocol_probe.py`, `smoke_test.py`, `gen_reference.py`, `find_portuguese.py`, `check_syntax.sh`, launchers (`dist/`, being moved to `package-files/`), `rme/` (Remere's Map Editor source + 8.54 data) | §14 |
| `docs` | Phase 1/2 reports, audits, triage, building, testing, translation | |

Counts re-measured for this audit:

| Item | Count | Evidence |
|---|---|---|
| `lib/ps/systems/*.lua` (top level, loaded) | **54** | `ls data/lib/ps/systems` (+ `disabled/005-task.lua`) |
| Pokémon config files | 432 | `data/lib/ps/config/pokemon/` |
| Move config files | 455 | `data/lib/ps/config/moves/` |
| Spell (move) scripts | 459 + 21 custom | `data/lib/ps/events/spells/scripts`, `.../custom` |
| `<instant>` entries in `spells.xml` | 483 | `data/spells/spells.xml` |
| actions.xml entries active / commented | 328 / 8 | `data/actions/actions.xml` |
| movements.xml | 207 / 8 | `data/movements/movements.xml` |
| creaturescripts.xml | 59 / 1 | `data/creaturescripts/creaturescripts.xml` |
| globalevents.xml | 7 / 5 | `data/globalevents/globalevents.xml` |
| talkactions.xml | 82 / 17 | `data/talkactions/talkactions.xml` |
| weapons.xml | 0 | empty |
| NPC XML / NPC scripts | 902 (842 non-citizen) / 338 | `data/npc`, `data/npc/scripts` |
| distinct NPC names in `map-spawn.xml` | 725 | |
| config.lua keys / keys read by `configmanager.cpp` | 229 / 228 | §9 |
| client modules | 51 (same set as `original/client`) | `client/modules` |

---

## 2. `original/` versus the working tree

`diff -rq` summary, by category (details of the C++ changes are in
[`BUILDING.md`](BUILDING.md) §2 and [`LOCAL_CLIENT_TESTING.md`](LOCAL_CLIENT_TESTING.md) §3.3).

### 2.1 Server C++ (`original/server/source` → `server/src`)

| Category | Files | Nature |
|---|---|---|
| Compiler fixes | `chat.cpp:1666` (`false`→`NULL`), `connection.h` (enum→`static const`), `game.h:723` (`globalSaveMessage[3]`), `house.h` (TR1→`std::unordered_set`), `otsystem.h` (`<chrono>`), `player.cpp:138` (`<13`), `protocolgame.cpp:907` (`hex.str()`), `quests.h:75` (return by value), `talkaction.cpp:117` (array loop) | one-line build fixes (Phase 1) |
| Library ports | `tools.cpp:315` (`const xmlError*`, libxml2 ≥ 2.12); `connection.{h,cpp}`, `server.{h,cpp}` (Boost.Asio `io_context`, `steady_timer`, `post/dispatch`, `make_address_v4`, `to_uint`) | Phase 2 |
| Build system | `server/CMakeLists.txt` | new |
| Schemas | `schemas/psoul_extra_mysql.sql`, `schemas/psoul_dev_seed.sql` | only in working tree |

No gameplay or protocol logic changed in C++.

### 2.2 Server datapack (`original/server/data` → `server/data`)

| Category | Files |
|---|---|
| Translation (PT→EN text only) | `lib/ps/config/002-wikiChat.lua`, `003-quest.lua`, `skill.lua`; `lib/ps/events/movements/activationTile.lua`; `lib/ps/events/actions/quests/emptyMasterBallPrototype.lua`; `lib/ps/events/creaturescripts/onJoinChannel.lua`; `lib/ps/events/globalevents/globalMessages.lua`; `lib/ps/systems/055-julyVacationEvent.lua`; `npc/Professor Tommy.xml`; `npc/scripts/{eggmove_regenerator,event_julyVacation,professorTommy}.lua`; `talkactions/scripts/shutdown.lua` (13 files, see [`TRANSLATION.md`](TRANSLATION.md)) |
| Regenerated at runtime | 60 `npc/tmpCitizen_*.xml` (rewritten at every start by `027-citizens.lua`; git-ignored `.gitignore:84`) |
| Added | `spells/scripts/.gitkeep`, `world/map.otbm` (LFS) |
| Config | `config.example.lua` vs archive `config.lua`: `worldType` `no-pvp`→`pvp` (BUG-01), `motd`/`loginMessage` translated. Local `config.lua` (git-ignored) differs only in `sqlUser/sqlDatabase/sqlPass`. |
| Locale | `pt_br.loc` +21 pairs |

### 2.3 Client (`original/client` → `client`)

| Category | Files |
|---|---|
| Lua case fixes | `game_duelmessage/duelmessage.lua:44`, `game_lootlist/lootlist.lua:96` (`loadUI` file-name case) |
| Translation | `game_shop/shop.lua:69,75` (module not loaded anyway) |
| C++ crash fix | `client/statictext.cpp` (`g_lua.pop()`, BUG-03) |
| C++ build/library ports | `CMakeLists.txt`, framework `CMakeLists.txt`, `resourcemanager.cpp:193-204` (`#ifdef ENCRYPTED_ASSETS`), `apngloader.cpp`, `net/connection.{h,cpp}`, `net/server.cpp`, `unixcrashhandler.cpp`, `stdext/net.cpp`, `shared_object.h`, `uilayout.{h,cpp}`, `crypt.cpp` (OpenSSL 1.1 API), `point.h` |
| Assets | `client/data/{images,sounds,things}` present only in the working tree (decrypted / imported) |
| Untracked | `client/crash_report.log` (ignored) |

The Phase 2 statement "no protocol, gameplay or asset code was changed" holds: none of the client
changes touch packet parsing or module logic beyond the two `loadUI` names.

---

## 3. Server C++ systems

| System | Files | Status | Notes |
|---|---|---|---|
| Pokémon monsters (nickname, level, sex, master, shiny) | `monster.cpp`, `spawn.cpp:310` (`shinyAppearChance`) | ACTIVE, VERIFIED WORKING (P2-05, P2-09) | |
| PSoul `0xFF` protocol | `protocolgame.cpp:3053-3370, 4776-4939` | ACTIVE, CLIENT-DEPENDENT, partly VERIFIED (P2-34) | [`OPCODES.md`](reference/OPCODES.md) §5 |
| Localization (en/pt/es) | `localization.{h,cpp}`, `protocollogin.cpp:86-89,162-165` | ACTIVE, CLIENT-DEPENDENT | BUG-08, BUG-09 |
| Tournaments | `tournament.cpp`, `iotournament.cpp` | ACTIVE, PARTIAL (P2-28) | `tournamentWeekDayCheck`, `tournamentWeekWinnerStorage` read but absent from config (§9) |
| PvP arena | `pvparena.cpp` + `009-pvpArena.lua` | IMPLEMENTED / UNVERIFIED | BUG-17 |
| Item market (9.x backport) | `iomarket.cpp`, `protocolgame.cpp:3600-3940`, `game.cpp` market handlers | IMPLEMENTED / UNVERIFIED, CLIENT-DEPENDENT | BUG-36, BUG-37, BUG-52; NPC Jaron Jewell not spawned (BUG-23) |
| Polls | `polls.cpp`, `iopoll.cpp` | IMPLEMENTED / UNVERIFIED, WEBSITE-DEPENDENT, CLIENT-DEPENDENT | BUG-52 |
| TV (spectator channels) | `chat.cpp` TV channels, `protocolgame.cpp:2136,4710,4725` | IMPLEMENTED / UNVERIFIED | no client `game_tv` module exists; uses stock channel UI |
| Datalog / statistics | `iodatalog.cpp`, `ioplayerstatistics.cpp` | ACTIVE, VERIFIED WORKING (passive, test matrix §2.16) | |
| Extended opcode id 10 (dash walking) | `game.cpp:7714-7730` | IMPLEMENTED / UNVERIFIED | |
| Lua `onExtendedOpcode` dispatch | `creatureevent.cpp:2690`, `protocolgame.cpp:302-304` | UNUSED | registers non-existent event "ExtendedOpcode" (BUG-38) |
| Status protocol / admin protocol | `otserv.cpp:877` (commented), `__OTADMIN__` | DISABLED | |
| Light hour (day/night) | `game.cpp:87-89, 5180-5190`, sent `protocolgame.cpp:2794-2796` | ACTIVE, CLIENT-DEPENDENT | client `game_time` |

---

## 4. Lua loading model

* TFS loads `data/lib/*.lua` non-recursively (`luascript.cpp:721-740`). Subdirectories are only
  loaded if a file `dofile`s them.
* `data/lib/999-ps.lua` loads, in order: `ps/others/{constants,logger,outfits}`;
  `ps/config/{itemsAttributes,playersStorages,accountStorages,balls,pokemonsNumbers,pokemonsNames,pokemon,pokemonsStorages,storages,skill,globalStorages}`;
  `ps/functions/ball/{charged,discharged,empty,inUse}`, `ps/functions/{player,pokemon,abilities,others}`;
  then `dodirectory(PS_LIB_SYSTEMS_DIR)` (`999-ps.lua:40`) — non-recursive, so
  `systems/disabled/` is skipped. `PS_LIB_SKILLS_DIR` (`999-ps.lua:6`) points to nothing (BUG-38).
* Extra config files are loaded by their system: `config/001-rangerClub.lua` by
  `029-rangerClub.lua:8`, `config/002-wikiChat.lua` by `031-wikiChat.lua:250`,
  `config/003-quest.lua` by `002-quest.lua:82`.
* Event scripts in `lib/ps/events/**` are referenced from the XML files with
  `../../lib/ps/events/...` paths.
* NPC library `npc/lib/npc.lua` `dofile`s `npc/lib/npcsystem/*`, `npc/lib/frontierisland.lua`
  (→ 5 stadium-arena modes) and `npc/lib/wavearena.lua` (`npc.lua:167-168`).

### 4.1 Lua directories that nothing loads

| Path | Content | Status |
|---|---|---|
| `data/lib/disabled/003-event.lua` (2013), `034-exhaustion.lua` | stock TFS helpers | UNUSED, SAFE TO IGNORE (non-recursive loader) |
| `data/lib/ps/systems/disabled/005-task.lua` | old task system (prints "IF YOU SEEING THIS, THE OLD TASK SYSTEM IS BEEING LOADED") | DISABLED, HISTORICAL — superseded by the quest framework |
| `data/lib/ps/tools/{balanceCalculator,catchTest,generateLoot}.lua` | developer tools (`catchTest.lua` fully commented, `generateLoot.lua` 323 KB) | UNUSED; reachable only through the commented `/gl` talkaction (`talkactions.xml:46`) |
| Backups: `lib/ps/events/movements/activationTile.lua.bak`, `lib/ps/events/actions/events/halloween/suramoonRemains_backup.lua`, `lib/ps/config/003-quest.lua.bak`, `npc/{Aldo Vumblevore_backup,Hermitwo_Backup,Queter Phill_backup,Selam_backup}.xml`, `npc/Easter Rabbit.xml.bak`, `npc/backup/` | | HISTORICAL, SAFE TO IGNORE (BUG-39) |

---

## 5. Gameplay systems (`data/lib/ps/systems/`, all loaded)

Status reflects reachability + Phase 2 tests. "Reach" = how a player gets there.

| File | System | Status | Reach / notes | Bugs |
|---|---|---|---|---|
| `001-npcBattle.lua` | NPC trainer battles, gyms, badges | ACTIVE, PARTIAL (P2-29 loss path) | talk `battle` to trainer NPCs (199 `npcbattle_*` scripts) | BUG-01, BUG-16 |
| `002-quest.lua` | quest framework | VERIFIED WORKING (P2-26) | quest NPCs (73 `quest_*`), loads `config/003-quest.lua` | BUG-53 |
| `003-skill.lua` | move execution (`m1..m16`, `s1..s16`) | VERIFIED WORKING (P2-06) | GM energy FAIL | BUG-05 |
| `004-skillDamage.lua` | damage model | ACTIVE, PARTIAL (matrix §2.2) | | BUG-33 |
| `006-fastcall.lua` | Pokémon bar fast call | VERIFIED WORKING (P2-04) | CLIENT-DEPENDENT (`0xFF 0x04-0x08`) | |
| `007-cooldown.lua` | move cooldowns | VERIFIED WORKING (P2-06) | day-of-year clock | BUG-34 |
| `008-conditions.lua` | status conditions | VERIFIED WORKING (P2-13, poison) | other conditions unverified | BUG-27 |
| `009-pvpArena.lua` | PvP arenas | IMPLEMENTED / UNVERIFIED | arena NPC/tiles | BUG-17 |
| `010-pokedex.lua` | Pokédex | ACTIVE, PARTIAL (P2-09, P2-33) | | BUG-35 |
| `011-highscore.lua` | per-species catch highscore ids | IMPLEMENTED / UNVERIFIED, WEBSITE-DEPENDENT (display) | | BUG-25 |
| `012-extraExpRate.lua` | timed exp boost | IMPLEMENTED / UNVERIFIED | item `xpBoostPotion.lua` (29131), events | |
| `013-tournamentHighscore.lua` | tournament score ranking | IMPLEMENTED / UNVERIFIED, WEBSITE-DEPENDENT (display) | | |
| `014-mastery.lua` | mastery factions (9 mastery NPCs) | IMPLEMENTED / UNVERIFIED | `mastery_*` NPCs, Ader | duplicated function `:453/:461` |
| `015-berry.lua` | berry trees / planting | IMPLEMENTED / UNVERIFIED | `berrySeedBox.lua`, `berries/` actions, `berry_trees` table | |
| `016-safariZone.lua` | Safari Zone | IMPLEMENTED / UNVERIFIED | Jeffrey 3920,792,7 | |
| `017-specialAbilities.lua` | Pokémon special-ability ids/descriptions | IMPLEMENTED / UNVERIFIED | used by `039-pokemonAbility.lua` | |
| `018-technicalMachine.lua` | TMs | VERIFIED WORKING (P2-16) | | BUG-21 |
| `019-ballSeal.lua` | ball seals | IMPLEMENTED / UNVERIFIED | | BUG-21 |
| `020-ballCounter.lua` | ball counter | VERIFIED WORKING (P2-09) | | |
| `021-boss.lua` | World Boss | IMPLEMENTED / UNVERIFIED (`/boss` answers, P2-14) | | BUG-43 |
| `022-highscores.lua` | arena/event highscores (Frontier Island, Gladiator, Cooperative Elite/Titan, Survive, Battle Tower 10/15/20, Survive Hardcore, Achievements, Ranger Club) | IMPLEMENTED / UNVERIFIED, WEBSITE-DEPENDENT (display) | `player_highscores` | BUG-25 |
| `023-achievement.lua` | achievements | IMPLEMENTED / UNVERIFIED | `player_achievements` | see [`ACHIEVEMENTS.md`](reference/ACHIEVEMENTS.md) |
| `024-badgeCase.lua` | badge case | IMPLEMENTED / UNVERIFIED, CLIENT-DEPENDENT (`game_badgecase`) | | BUG-16 |
| `025-datalog.lua` | datalog writers | VERIFIED WORKING (passive, §2.16) | 40+ `datalog_*` tables | |
| `026-guide.lua` | town guide map marks | VERIFIED WORKING (P2-25) | | |
| `027-citizens.lua` | random citizen NPCs (`tmpCitizen_*`) | ACTIVE (observed at start) | regenerated XML at `:156` | |
| `028-dungeons.lua` | dungeons | IMPLEMENTED / UNVERIFIED | | BUG-45 |
| `029-rangerClub.lua` | Ranger Club tasks/bosses/ranks | IMPLEMENTED / UNVERIFIED | Dan Lambert 3941,471,7 | BUG-42 |
| `030-easterEvent.lua` | Easter | DISABLED (gates commented) | §15 | |
| `031-wikiChat.lua` | Wiki Chat channel bot | VERIFIED WORKING (P2-23) | | BUG-55 |
| `032-ski.lua` | ski equipment | IMPLEMENTED / UNVERIFIED | `skiEquipment.lua` | |
| `033-oxygenMask.lua` | oxygen mask (underwater) | IMPLEMENTED / UNVERIFIED | | |
| `034-surpriseBox.lua` | surprise boxes on the map | IMPLEMENTED / UNVERIFIED | | BUG-41 |
| `035-referral.lua` | referrals | IMPLEMENTED / UNVERIFIED, WEBSITE-DEPENDENT | `accounts.referral`, `referral_friends` | |
| `036-headbutt.lua` | headbutt trees | IMPLEMENTED / UNVERIFIED | | |
| `037-halloweenEvent.lua` | Halloween | DISABLED (NPCs on map) | §15 | |
| `038-pokemonAddon.lua` | Pokémon addons | ACTIVE, PARTIAL (P2-22) | `/addon`; website image HTML commented `:2138-2141` | |
| `039-pokemonAbility.lua` | Pokémon abilities | IMPLEMENTED / UNVERIFIED | | |
| `040-vitamin.lua` | vitamins | VERIFIED WORKING (P2-18) | | |
| `041-dollCase.lua` | doll case | IMPLEMENTED / UNVERIFIED, CLIENT-DEPENDENT | `0xFF 0x14/0x15`; client count truncation (§17) | |
| `042-sandboard.lua` | sandboard | IMPLEMENTED / UNVERIFIED | | |
| `043-fishing.lua` | fishing | IMPLEMENTED / UNVERIFIED | | |
| `044-slotMachine.lua` | casino slot machine | IMPLEMENTED / UNVERIFIED, CLIENT-DEPENDENT (`0xFF 0x16`) | `casinoMerchant.lua` | |
| `045-pokemonEgg.lua` | eggs / incubators | VERIFIED WORKING (P2-19) | | BUG-29, BUG-34 |
| `046-heldItem.lua` | held items | VERIFIED WORKING (P2-17) | | BUG-28 |
| `047-pokemonFood.lua` | hunger / feeding | PARTIAL (P2-08) | | BUG-19 |
| `048-anniversaryEvent.lua` | Anniversary | ACTIVE, PARTIAL (P2-32) | hourly `globalevents.xml:13` | BUG-14, BUG-18 |
| `049-eliteFour.lua` | Elite Four | IMPLEMENTED / UNVERIFIED | Drogo Toby 3115,590,7 | dead `onLogout_EliteFour` registration (§17) |
| `050-rocketBattle.lua` | Team Rocket battles | IMPLEMENTED / UNVERIFIED, PARTIAL (no reward) | | BUG-44 |
| `051-christmasEvent.lua` | Christmas | DISABLED | §15 | |
| `052-extraLootRate.lua` | timed loot boost | IMPLEMENTED / UNVERIFIED | | |
| `053-extraCatchRate.lua` | timed catch boost | IMPLEMENTED / UNVERIFIED | | |
| `054-extraEggRate.lua` | timed egg boost | IMPLEMENTED / UNVERIFIED | | |
| `055-julyVacationEvent.lua` | July Vacation | DISABLED | §15 | |

### 5.1 Systems outside `lib/ps/systems`

| System | Files | Status |
|---|---|---|
| **Frontier Island** (not in earlier reports): 48 trainer NPCs `npc/scripts/npcbattle_fi_*.lua`, Battle Tower `npc/scripts/fi_battletower.lua` (NPC Rafael Townson, spawned), Stadium Arena modes `npc/lib/frontierisland/stadiumarena/{gladiator,cooperativeelite,cooperativetitan,survivechallenge,survivehardcore}.lua` via `npc/scripts/fi_stadiumarena.lua` (NPC Kurt Petrillose, spawned), monsters `data/monster/FrontierIsland` | IMPLEMENTED / UNVERIFIED |
| **Wave Arena** (not in earlier reports): `npc/lib/wavearena.lua` (9 arenas, 20 rounds), `npc/scripts/wavearena.lua` (NPC Leroi Bradley, spawned), `datalog_colosseum_arena` | IMPLEMENTED / UNVERIFIED |
| Daycare / egg moves | `npc/scripts/daycare{Female,Male}.lua`, `eggmove_{regenerator,remover}.lua` | IMPLEMENTED / UNVERIFIED |
| Bank | `npc/scripts/bank.lua`, `shop_bank.lua` | VERIFIED WORKING (P2-27), transfer PARTIAL; BUG-51 |
| Pokémon Market | `npc/scripts/shop_pokemonMarket.lua` | PARTIAL (P2-30); BUG-31 |
| PokeTrader | `npc/scripts/poketrader.lua` | PARTIAL (P2-31); BUG-32 |
| Soul Trade (premium shop, nick change, guild creation) | `npc/scripts/soulTrade.lua` | PARTIAL (P2-12 nick PASS), WEBSITE-DEPENDENT (Soul Coins) |
| Travel (boats/trains) | `npc/scripts/travels.lua` | IMPLEMENTED / UNVERIFIED |
| Tutors (TM/held/vitamin/sketch removers & resets) | `tm_remover.lua`, `held_remove.lua`, `vitamin_reset.lua`, `sketch_reset.lua` | IMPLEMENTED / UNVERIFIED |
| Test-server NPCs | `npc/scripts/testserver_{held,pokemon_creator,vitamin}.lua` (NPCs "Testserver Held", "Pokemon Creator", "Testserver Vitamin", **not spawned**) | UNUSED; a GM can still summon them with `/n` — keep them out of production |
| Gameplay tutorial | `gameplayTutorial_*`, `login.lua:69-86`, `globalevents.xml` Rattata respawn | ACTIVE, CLIENT-DEPENDENT (`0x32` ids 8/9, `game_guide`) |
| TV | `lib/ps/events/actions/tv/{record,watch}.lua`, `lib/ps/events/talkactions/tv/*` | IMPLEMENTED / UNVERIFIED |
| Duels / party duels | `lib/ps/events/actions/duel.lua`, client `game_duelmessage` | IMPLEMENTED / UNVERIFIED |

---

## 6. Event registrations (XML → script)

### 6.1 Missing scripts

No **active** entry points to a missing file. All missing targets sit inside commented entries
(7, Phase 1 listed 3):

| XML line | Missing script |
|---|---|
| `actions.xml:33` | `portrait.lua` |
| `movements.xml:24-25` | `underwaterEnterSecure.lua`, `underwaterLeaveSecure.lua` |
| `globalevents.xml:15` | `my_script.lua` |
| `globalevents.xml:20` | `globalMessageTeamSpeak.lua` |
| `talkactions.xml:43` | `tv/banlist.lua` |
| `talkactions.xml:147` | `position.lua` |

NPC: only `npc/Soya.xml` → `loot.lua` is missing (BUG-38). See [`BROKEN_REFERENCES.md`](BROKEN_REFERENCES.md).

### 6.2 Scripts no active XML entry references

| Script | Why | Status |
|---|---|---|
| `lib/ps/events/globalevents/halloween.lua` | `globalevents.xml:21` inside the commented block `:17-22` | DISABLED |
| `globalevents/scripts/{clean,save}.lua` | same block | DISABLED (server save/clean not scheduled) |
| `lib/ps/events/actions/smallStone.lua` | `actions.xml:26` "DEPRECATED"; live version `safariZone/smallStone.lua` (`actions.xml:105`) | HISTORICAL |
| `lib/ps/events/actions/safariFishing.lua` | `actions.xml:36` commented | DISABLED |
| `lib/ps/events/actions/events/halloween/suramoonRemains_backup.lua` | backup | HISTORICAL |
| `actions/scripts/tools/pick.lua` (`actions.xml:229`), `actions/scripts/other/food.lua` | stock TFS | UNUSED |
| `movements/scripts/{drown,swimming,citizen}.lua` | `movements.xml:53-60, 87` commented | UNUSED (stock) |
| `creaturescripts/scripts/reportbug.lua` | `creaturescripts.xml:70` commented; PSoul `onReportBug.lua` is used | HISTORICAL |
| `talkactions/scripts/{uptime,commands,pvp,event,serverinfo,deathlist,money,teleportfloor,frags}.lua` | commented `talkactions.xml:95-96,118-126,142-147` | DISABLED (stock commands) |

### 6.3 Creature-event names

`creaturescripts/scripts/login.lua:18-20` registers 22 events; all exist in
`creaturescripts.xml:4-73`, with two exceptions:

* `login.lua:22-24` registers **"AdvancedSave"**; the XML event is named **"AdvanceSave"**
  (`creaturescripts.xml:71`). Latent (`advancedSave = false`, `config.example.lua:342`). §17.
* `049-eliteFour.lua:97` registers **"onLogout_EliteFour"**, defined nowhere. Harmless because
  `onLogout.lua:37-38` handles Elite Four logouts. §17.
* `protocolgame.cpp:302-304` registers "ExtendedOpcode" (BUG-38).

Other dynamic registrations resolve: `npcPokemonDeath` (`001-npcBattle.lua:528`,
`050-rocketBattle.lua:373`), `onPokemonDeath` (`others.lua:787`, `pokemon.lua:141`),
`onPrepareDeath_Remove` (`activationTile.lua:301,359,655`, `rocketSurpriseBox.lua:12`),
`onDeath_Remove` (`Double Team.lua:56`), `cursedBedsheet.lua:11`, monster-XML death events.

### 6.4 Global events

| Name | Interval | Status |
|---|---|---|
| `start.lua` (server start) | startup | ACTIVE |
| playersrecord | record | ACTIVE |
| Gameplay Tutorial Rattata | 15 s | ACTIVE |
| eeveeRespawn | 10800 s | ACTIVE |
| sudowoodoTree | 3600 s | ACTIVE |
| globalMessages | 2700 s | ACTIVE, WEBSITE-DEPENDENT text (PokeNordic URLs) |
| anniversary | 3600 s (`globalevents.xml:13`) | ACTIVE (BUG-14) |
| clean, save, halloween, my_script, TeamSpeak | — | DISABLED (`:15-22`) |

### 6.5 Seasonal gates (re-confirmed)

| Event | Gates | State |
|---|---|---|
| Anniversary | `onKill.lua:8` active, `onSpawn.lua:5` active, globalevent hourly, `raids.xml:5 enabled="no"` but `048-anniversaryEvent.lua:594-600` calls `executeRaid("anniversary")` anyway (`raids.cpp:90-94` only checks `enabled` for the scheduler) | **ON** |
| Halloween | `onKill.lua:7`, `onSpawn.lua:7`, `globalevents.xml:21`, `raids.xml:6-11` commented | OFF (NPCs live) |
| Easter | `onKill.lua:9`, `onSpawn.lua:2-4` commented; item actions always registered | OFF |
| Christmas | `onKill.lua:10`, `onSpawn.lua:6`, `raids.xml:14-18` commented | OFF |
| July Vacation | `onStaminaChange.lua:2` commented | OFF |

---

## 7. Talkactions

Full command catalog: [`reference/COMMANDS.md`](reference/COMMANDS.md). Structure of
`talkactions.xml`: PSoul player commands `:5-41` (`/addon`, `/cupom;/coupon`, `/afk`, `/time`,
`/help`, `/autoloot`, `/dv`, `/exp`, `/held`, `/love`, `t1..t4`, `/autoWalk`, `/sd`, `/cp`,
`/pd`, `/tc`, `/d1;/d2`, `/boss`, `/lang`, `s1..s16`, `m1..m16`, `/teleport;/tele;/tp`, `/up`,
`/down`, `/find`, TV `/tvname /tvlist /tvkick /tvban /tvunban /tvpassword`, `/list`,
`/setrank`); gods (access 5) `:52-69`; CMs (4) `:72-81`; GMs (3) `:84-104`; tutors `:107-113`;
`/autoTrade` `:116`; houses `:129-135`; `!createguild` commented `:138`; `!joinguild` `:139`.
`/gl` (loot generator, `:46`) commented.

---

## 8. NPCs

* 902 NPC XML; 842 non-citizen; 338 scripts. 725 distinct names are spawned by
  `world/map-spawn.xml`.
* ~113 definitions are neither in `map-spawn.xml` nor created by a literal `doCreateNpc`. Some
  are created dynamically: Elite Four (`049-eliteFour.lua:155,228,498`), `start.lua:79,179`,
  `npcbattle_sabrina.lua:53,121`, `npcbattle_mewtwo.lua:66`, `movements/scripts/tiles.lua:274`,
  citizens (`027-citizens.lua:156`), `activationTile.lua`. The rest (e.g. Jaron Jewell, BUG-23;
  Kanto bankers only in the stale `world/-spawn.xml`, BUG-15; test-server NPCs) are UNUSED
  until placed. Details: [`reference/NPCS.md`](reference/NPCS.md).

---

## 9. Configuration (`config.lua` ↔ `configmanager.cpp`)

229 keys in `config.example.lua`, 228 `getGlobal*` reads in `configmanager.cpp`.

### 9.1 In config, not read by C++ (read by Lua instead)

`loginMessage` (`login.lua:16`), `deathLostPercent` (`login.lua:154`), `idleWarningTime` /
`idleKickTime` (`idle.lua`), `expireReportsAfterReads` (`reports.lua`),
`displayGamemastersWithOnlineCommand` (`online.lua`) — ACTIVE. `advancedFragList` (`frags.lua`)
and `maxDeathRecords` (`deathlist.lua`) — both scripts unregistered → dead config.

### 9.2 Read by C++, absent from config (silent defaults)

| Key | Default | Read at | Used at |
|---|---|---|---|
| `marketOfferDuration` | (30 days) | `configmanager.cpp:301` | market |
| `premiumToCreateMarketOffer` | true | `:302` | market |
| `checkExpiredMarketOffersEachMinutes` | 60 | `:303` | market |
| `maxMarketOffersAtATimePerPlayer` | 100 | `:304` | market |
| `minimumLevelToPollVote` | 25 | `:305` | polls |
| `rateMonsterExperienceMultiplier` | 10 | `:291` | **nowhere** (`RATE_MONSTER_EXPERIENCE_MULTIPLIER`, `configmanager.h:193`) — dead |
| `tournamentWeekDayCheck` | 0 | `:307` | `tournament.cpp:1207` |
| `tournamentWeekWinnerStorage` | 7065 | `:308` | `tournament.cpp:1233,1244` |

### 9.3 Mismatches

| Issue | Evidence | Effect |
|---|---|---|
| **`"checkCorpseOwner "` read with a trailing space** | `configmanager.cpp:250` | the config value is ignored; corpse-owner protection is always the default `true` (`actions.cpp:511`). §17 |
| `blessingOnlyPremium` (config, C++ `configmanager.cpp:212`, `iologindata.cpp:467,893`) vs `getConfigValue('blessingsOnlyPremium')` | `npc/lib/npcsystem/modules.lua:139` | NPC blessing module reads `nil` → premium check skipped (stock 0.3.6 quirk) |
| `updateHighscores` default `true` in C++ (`:296`), `false` in config | | static highscores (BUG-25) |
| `advancedSave` → wrong event name | §6.3 | |

PSoul-specific keys in use: `shinyAppearChance` (`spawn.cpp:310`), `LOG_MAP_ITEMS`
(`game.cpp:6670`), `DEFAULT_TOWN_ID` (`iologindata.cpp:374`), `DISCONNECT_AT_EXIT`
(`player.cpp:1860`).

---

## 10. Client modules (`client/modules`, 51)

Loading: `client/init.lua:30-46` (discover, autoload priorities, then `corelib`, `gamelib`,
`client`, `game_interface`). `client.otmod` load-later: `client_styles`, `client_locales`,
`client_topmenu`, `client_background`, `client_options`, `client_entergame`.
`game_interface/interface.otmod` load-later: 37 game modules. `game_guide` autoloads
(`guide.otmod:7-8`, priority 1001).

| Module | Loaded | Server dependency | Status |
|---|---|---|---|
| `corelib`, `gamelib`, `game_things`, `client`, `client_styles`, `client_locales`, `client_topmenu`, `client_background`, `client_options`, `client_entergame`, `game_interface` | yes | login/charlist extras | ACTIVE, VERIFIED WORKING (P2-33) |
| `game_console`, `game_inventory`, `game_minimap`, `game_healthinfo`, `game_battle`, `game_containers`, `game_skills`, `game_textmessage`, `game_outfit` | yes | stock | VERIFIED WORKING (P2-33; inventory BUG-12) |
| `game_hotkeys`, `game_questlog`, `game_combatcontrols`, `game_viplist`, `game_npctrade`, `game_textwindow`, `game_playertrade`, `game_bugreport`, `game_playerdeath`, `game_ruleviolation` | yes | stock | ACTIVE |
| `game_pokemoves` | yes | `0xFF 0x01, 0x09` (0x02/0x03 not listened, §17) | VERIFIED WORKING (P2-34) |
| `game_pokebar` | yes | `0xFF 0x04-0x08` | VERIFIED WORKING (P2-04, BUG-11) |
| `game_pokedex` | yes | `0xFF 0x0A-0x0C, 0x11`; cries `data/sounds/cries` | VERIFIED WORKING (P2-34) |
| `game_tmchoose` | yes | `0xFF 0x0D` | VERIFIED WORKING (P2-16; BUG-57) |
| `game_statusbar` | yes | `0xFF 0x0E-0x10` | VERIFIED WORKING (P2-13) |
| `game_effects` | yes | `0xFF 0x13` | VERIFIED WORKING (P2-34) |
| `game_lootlist` | yes | `0xFF 0x1A` | VERIFIED WORKING (P2-34) |
| `game_dollcase` | yes | `0xFF 0x14/0x15` | IMPLEMENTED / UNVERIFIED |
| `game_badgecase` | yes | item-based | IMPLEMENTED / UNVERIFIED |
| `game_slotmachine` | yes | `0xFF 0x16` | IMPLEMENTED / UNVERIFIED |
| `game_tips` | yes | `0xFF 0x17` | IMPLEMENTED / UNVERIFIED |
| `game_poll` | yes | `0xFF 0x18`, `0xFA/0xFB`, charlist byte | IMPLEMENTED / UNVERIFIED, WEBSITE-DEPENDENT |
| `game_advanceeffect` | yes | `0xFF 0x19`, skill change | IMPLEMENTED / UNVERIFIED |
| `game_market` | yes | `0xF4-0xF9` | IMPLEMENTED / UNVERIFIED |
| `game_duelmessage` | yes | text/duel | IMPLEMENTED / UNVERIFIED |
| `game_time` | yes | self-login light hour | ACTIVE (day/night clock) |
| `game_tutorial` | yes | none (static content `content/{en,pt}`) | ACTIVE |
| `game_guide` | yes (autoload) | `0x32` ids 8/9 | ACTIVE, not GUI-verified |
| **`game_environment`** | **no** (no `autoload`, not in `interface.otmod`; caller commented at `client_options/options.lua:266`) | none — purely client-side position-based ambient sounds (`data/sounds/environment`, 46 MB), map shaders incl. rain (`data/shaders/environment`), location label via `game_time.setLocation` | DISABLED, CLIENT-DEPENDENT |
| `game_shop` | no | `0x32` id 103 never sent | UNUSED (BUG-38) |
| `client_serverlist` | no | — | UNUSED, SAFE TO IGNORE |

There is **no `game_tv` module**; TV channels use the stock channel window (`0xAB`).

---

## 11. Protocol summary and client/server mismatches

Full layout: [`reference/OPCODES.md`](reference/OPCODES.md). Mismatches found:

| Mismatch | Evidence | Impact |
|---|---|---|
| Doll-case status count read as `uint8_t`, loop index `uint8_t` | client `protocolgameparse.cpp:1965-1970` vs server `U16` `protocolgame.cpp:4776`; 250 dolls today (`041-dollCase.lua:9`) | latent desync (≥256) / infinite loop (=255) |
| Level-up move count read as `uint8_t` | `protocolgameparse.cpp:2026` | latent |
| `0xFF 0x02/0x03` fire `onMoveBarClose/Open`, modules listen to `onPokemonMovesClose/Open` | `protocolgameparse.cpp:1825,1830` vs `pokemoves.lua:250-251`, `statusbar.lua:239-243` | move bar never hidden/shown by the server; using a move icon (`openSkillWindow.lua:2`) only opens the Pokémon bar |
| Account Manager charlist row without OTC extras | `protocollogin.cpp:227-234` vs `protocollogin.lua:173-186` | latent (account manager off) |
| Unknown `0xFF` sub-id silently skipped | `protocolgameparse.cpp:64-180` (no `default`) | future additions desync instead of erroring cleanly |
| Poll option id one byte | `protocolgame.cpp:4871` | BUG-52 |
| Login language byte | `protocollogin.cpp:86-89` | BUG-08/09 |
| Game-login challenge not validated | `protocolgame.cpp:487` | security note (replay protection absent) |
| Extended ids 0, 3-7 declared on both sides, never sent | `constants.lua:33-45`, `const.lua:241-253` | UNUSED (the intended sender was a server-driven `game_environment`) |

Client features present but not used by the server: `GameExtendedClientPing` (`0x32` id 2),
`client_serverlist`. Server features not used by the client: Lua `onExtendedOpcode`.

---

## 12. Database

All tables created by `mysql.sql` (29 `CREATE TABLE`) + `psoul_extra_mysql.sql` (69) are referenced by at least one
C++ or Lua file outside the schemas. No live query targets a table missing from the schemas; the
only miss is `player_first_pokemon`, used solely in commented code
(`lib/ps/functions/player.lua:745`). Missing stored procedure `update_rank()` (BUG-25).
Website-written tables: `polls`, `poll_options`, `poll_texts`, `coupons`, `accounts.soulcoins`,
`accounts.premdays`, `accounts.referral*`, `tournaments` scheduling rows. Table catalog:
[`reference/DATABASE.md`](reference/DATABASE.md).

---

## 13. Website-dependent behaviour

| Behaviour | Evidence | Status |
|---|---|---|
| Account / character creation | `protocollogin.cpp:198-201`; client buttons `client_entergame/entergame.otui:72,79` (pokenordic.com), `newcharacterlist.otui:223,232` (psoul.net) | WEBSITE-DEPENDENT (seed SQL substitute) |
| Soul Coins / premium / donate | `accounts.soulcoins`, `accounts.premdays`, `soulTrade.lua` | WEBSITE-DEPENDENT |
| Coupons | `lib/ps/events/talkactions/coupon.lua`, `coupons` | WEBSITE-DEPENDENT (BUG-54) |
| Referrals | `035-referral.lua`, `referral_friends` | WEBSITE-DEPENDENT |
| Polls | §7 of OPCODES | WEBSITE-DEPENDENT |
| Highscores / tournament history display | `011`, `013`, `022`, `onTournamentHistory.lua` | WEBSITE-DEPENDENT (display only) |
| Broadcast URLs | `globalMessages.lua:3-24`, `onJoinChannel.lua:85`, `shutdown.lua:38-42` | SAFE TO IGNORE (text) |
| Addon image HTML export | `038-pokemonAddon.lua:2138-2141` (commented) | HISTORICAL |

---

## 14. Tools, build and assets

| Item | Status |
|---|---|
| `tools/build_*.sh`, `package.sh`, `init_dev_database.sh`, `smoke_test.py`, `check_references.py`, `gen_reference.py`, `windows/Build-PokeNation-Windows.ps1`, package launchers `package-files/{linux,windows}/` | ACTIVE, VERIFIED WORKING on Linux (Phase 2A: build, package, packaged server 12/12 smoke test, packaged client login). Windows: see `PHASE_2A_REPORT.md` |
| `tools/setup_database.sh`, `init_dev_database.sh`, `start_database.sh`, `start_server.sh`, `start_client.sh`, `dev_env.sh` | ACTIVE |
| `tools/protocol_probe.py`, `smoke_test.py` | ACTIVE (P2 test harness) |
| `tools/check_syntax.sh`, `find_portuguese.py`, `gen_reference.py`, `import_original.sh` | ACTIVE (maintenance) |
| `tools/__pycache__/` | SAFE TO IGNORE (should be git-ignored) |
| `tools/rme/` (Remere's Map Editor source + `data/854/items.otb`) | IMPLEMENTED / UNVERIFIED (not built in Phase 2) |
| `client/src-cpp/vc12/` | HISTORICAL (Visual Studio 2013 copy of the C++ sources; CMake builds `src/`) |
| Client asset spot checks | `sounds/startup.ogg` (`client/client.lua:1`), `images/map` (`minimap.lua:385`), `images/animated` (`entergame.otui:83`), `images/staticPortraits` (`advanceeffect.lua:170`), `images/trainerCards` (`characterlist.lua:204`), `sounds/cries` (`pokedex.lua:23`) are used. `images/background.psd` is a source file (UNUSED). `sounds/environment` (46 MB) and `shaders/environment` are used only by the unloaded `game_environment` (DISABLED). |

---

## 15. Disabled-but-useful systems and how to enable them

| System | What would enable it | Risk |
|---|---|---|
| Halloween / Easter / Christmas / July Vacation | uncomment the `onKill.lua` / `onSpawn.lua` / `onStaminaChange.lua` lines (§6.5) and the matching `raids.xml` / `globalevents.xml` blocks | events have no date check — they stay on until edited back (same as Anniversary, BUG-14) |
| Anniversary **off** | comment `onKill.lua:8`, `onSpawn.lua:5`, `globalevents.xml:13` | |
| Server save / clean globalevents | uncomment `globalevents.xml:17-22` (not the halloween line) | |
| Client ambient sound / shaders (`game_environment`) | add it to `interface.otmod` load-later and restore `options.lua:266` | 46 MB of assets, untested |
| Client shop (`game_shop`) | load module and send `0x32` id 103 from a shop script | needs a shop backend |
| Account manager | `accountManager = true` **after** fixing the charlist row (§11) | |
| Item market | spawn Jaron Jewell (BUG-23), add market keys to config (BUG-52), fix BUG-36/37 | |
| Advanced save | fix the event name (§6.3) then `advancedSave = true` | |
| Old task system | move `systems/disabled/005-task.lua` up | superseded; not recommended |
| Stock commands (`/uptime`, `/serverinfo`, `!frags`, `!deathlist`…) | uncomment `talkactions.xml` entries | `frags/deathlist` use `advancedFragList`/`maxDeathRecords` |
| Developer tools (`/gl`, test-server NPCs) | uncomment `/gl`, place NPCs | development only |
| Halloween safari fishing (`safariFishing.lua`) | uncomment `actions.xml:36` | |

---

## 16. Corrections to earlier reports

### 16.1 Inaccurate

| Report | Statement | Correction | Evidence |
|---|---|---|---|
| SOURCE_AUDIT §4 | "55" Lua systems | **54** top-level files (+1 in `disabled/`) | `ls data/lib/ps/systems` |
| PHASE_1_REPORT | 3 missing scripts in event XMLs | **7**, all in commented entries; no active entry is missing | §6.1 |
| SOURCE_AUDIT §6 | client features include `game_tv` | no such module | `ls client/modules` |
| SOURCE_AUDIT §6 / earlier feature lists | `game_environment` (sounds/particles/shaders) listed as a client feature | module is **not loaded**; it is client-side (not driven by `0x32` ids 3/5/6) | `environment.otmod` (no autoload), `interface.otmod`, `options.lua:266` |
| PHASE_1_REPORT / BUILDING.md §2.1 vs SOURCE_AUDIT §1 | "eight one-line fixes" vs "9 small fixes" | the diff shows **9** small compiler fixes: the 8 in `BUILDING.md` §2.1 plus the unlisted `otsystem.h` `#include <chrono>`; on top come the Phase 2 libxml2 (`tools.cpp:315`) and Boost.Asio ports (`connection.*`, `server.*`) | §2.1 |
| SOURCE_AUDIT §2.3 | "6 skipped bytes" | they are the 5-byte challenge + 1 byte; the challenge is never validated | `protocolgame.cpp:487` |
| SOURCE_AUDIT §2.6 | `banUnknownBytes`, `:874-902` | key `autoBanishUnknownBytes`, code `:874-912` | `configmanager.cpp:237` |
| SOURCE_AUDIT §2.5 | doll-case / level-up `U16 n` | correct on the server, the client reads `uint8_t` | `protocolgameparse.cpp:1965,2026` |
| SOURCE_AUDIT §2.5 | `0x02/0x03` "move bar visibility" | no client listener | §11 |
| SOURCE_AUDIT §2.4 | market senders `:3600-3695` | `:3600-3940` (`0xF9` used for 5 responses, `0xF8` detail) | OPCODES §6 |
| Phase 1/2 inventories | no mention of Frontier Island / Battle Tower / Stadium Arena / Wave Arena | ~2,000 lines of NPC-library code, 50 NPC scripts, spawned NPCs | §5.1 |
| Phase 1/2 inventories | `data/lib/disabled/` and `data/lib/ps/tools/` not listed | present, not loaded | §4.1 |
| LOCAL_CLIENT_TESTING §2, §1.2 | client settings in `%APPDATA%\psoul\` on Windows | `%USERPROFILE%\psoul\config.otml` and `%USERPROFILE%\psoul.log` (PhysFS user dir = profile folder); docs corrected in Phase 2A | `resourcemanager.cpp:71-80,354-357`, `client/init.lua:5-8` |
| Phase 2 package READMEs | server engine "GPL v2" | **GNU GPLv3** | `server/src/doc/LICENSE:12` |
| BUILDING.md §5 / tools | stopping with `/shutdown` ends the server | it saves, then never exits (BUG-72) | `server.cpp:213-233` |

### 16.2 Re-confirmed

* All seasonal gates and the Anniversary-always-on finding (BUG-14).
* `ExtendedOpcode` dead registration, `game_shop` dead, `Soya.xml` → `loot.lua`,
  `PS_LIB_SKILLS_DIR`, `003-quest.lua.bak` (BUG-38).
* Poll option one byte (BUG-52), market/poll keys absent from config (BUG-52).
* Language byte unvalidated / non-stock (BUG-08, BUG-09).
* Item market NPC not spawned (BUG-23), Kanto bankers only in `-spawn.xml` (BUG-15).
* SOURCE_AUDIT §2: transport, RSA, OS ids, version 312, charlist extras, `0x1F` challenge,
  `U16` magic effect, creature extras, `U16` channel count, `0xFF` payloads, `0x32` ids.
* Phase 2 claim that client changes do not touch protocol/gameplay.
* No SQL table is unreferenced; `update_rank()` missing (BUG-25).

---

## 17. New defects (BUG-58+, now recorded in BUG_TRIAGE.md)

| # | Severity (proposed) | Description | Evidence |
|---|---|---|---|
| BUG-58 | P4 | `checkCorpseOwner` is read with a trailing space, so the config key is ignored and corpse-owner protection is always on (config sets `true` at `config.example.lua:220`, so no change today; setting `false` would have no effect) | `server/src/configmanager.cpp:250`, used `actions.cpp:511` |
| BUG-59 | P3 (latent) | Client reads the doll-case status count (`U16`) into `uint8_t` with a `uint8_t` loop: desync when ≥256 entries, infinite loop at exactly 255 | `client/src-cpp/src/client/protocolgameparse.cpp:1963-1973`; server `protocolgame.cpp:4776`, `041-dollCase.lua:537-544` |
| BUG-60 | P4 (latent) | Same `uint8_t count = getU16()` truncation for the level-up move list | `protocolgameparse.cpp:2026` |
| BUG-61 | P4 | `0xFF 0x02/0x03` call `g_game.onMoveBarClose/onMoveBarOpen`, but modules listen to `onPokemonMovesClose/Open` → server-driven move bar hide/show is a no-op | `protocolgameparse.cpp:1825,1830`; `game_pokemoves/pokemoves.lua:250-251` |
| BUG-62 | P4 (latent) | Account Manager charlist entry lacks the OTClient extra fields → client desync if `accountManager = true` | `server/src/protocollogin.cpp:227-234` vs `client/modules/gamelib/protocollogin.lua:173-186` |
| BUG-63 | P4 (latent) | `login.lua` registers "AdvancedSave", XML event is "AdvanceSave" → advanced save silently never runs if enabled | `creaturescripts/scripts/login.lua:22-24`, `creaturescripts.xml:71` |
| BUG-64 | P4 | `registerCreatureEvent(cid, 'onLogout_EliteFour')` for an event that does not exist | `lib/ps/systems/049-eliteFour.lua:97` |
| BUG-65 | P4 | `rateMonsterExperienceMultiplier` read but never used | `configmanager.cpp:291`, `configmanager.h:193` |
| BUG-66 | P4 | NPC blessing module reads `blessingsOnlyPremium`, config/C++ use `blessingOnlyPremium` | `npc/lib/npcsystem/modules.lua:139` vs `configmanager.cpp:212` |
| BUG-67 | P4 | Client `0xFF` dispatcher has no `default` case: unknown sub-opcodes are skipped silently and the remainder is misparsed | `protocolgameparse.cpp:64-180` |
| BUG-68 | P3 (security) | Game-login challenge bytes are skipped, never compared with the value sent in `0x1F` | `server/src/protocolgame.cpp:438-452, 487` |
| BUG-69 | P4 | `game_environment` (ambient sounds/shaders, 46 MB assets) never loaded | `client/modules/game_environment/environment.otmod`, `client_options/options.lua:266` |
| BUG-70 | P4 (ops) | Test-server NPCs (Pokémon Creator, held/vitamin givers) ship in the datapack; summonable by GMs | `npc/scripts/testserver_*.lua` |

---

## 18. Classification counts

Number of table rows in §3–§15 of this document that carry each tag (142 tagged rows; a row
with several tags counts once per tag). Feature-level counts are at the end of
[`reference/FEATURES.md`](reference/FEATURES.md).

| Tag | Rows |
|---|---|
| ACTIVE | 29 |
| VERIFIED WORKING | 25 |
| IMPLEMENTED / UNVERIFIED | 51 |
| PARTIAL | 12 |
| BROKEN | 0 (no loaded system is shown to be fully broken; BUG-16/17/45 are suspected, not reproduced) |
| DISABLED | 13 |
| HISTORICAL | 7 |
| UNUSED | 10 |
| WEBSITE-DEPENDENT | 14 |
| CLIENT-DEPENDENT | 11 |
| SAFE TO IGNORE | 5 |
