# Source audit — PSoul / PokeAimar (Phase 1)

This document is the inventory of the original project as it was received. It was produced by
reading the imported source (`/server`, `/client`, `/tools/rme`) and verified against a running
build where a statement is marked **verified**. Nothing here describes planned changes; see
`PHASE_1_REPORT.md` for status and `BUILDING.md` for how to build and run.

Related documents: `BUILDING.md`, `TRANSLATION.md`, `SECURITY_AUDIT.md`, `LARGE_FILES.md`,
`PHASE_1_REPORT.md`, and `original/README.md` (what was imported from where).

---

## 1. Identity of the base

| Item | Finding | Evidence |
|------|---------|----------|
| Engine lineage | **The Forgotten Server 0.3.6** (OTServ family, "Elf, slawkens, Talaturen…" credits), heavily customised by the PSoul team (comments tagged `PS`) | `server/src/otserv.cpp` banner, `server/src/doc/CHANGELOG`, `src/schemas/mysql.sql` (`db_version` 23) |
| Nested history | One commit `77be843 "iniciando projeto"` (2020-06-10) pointing at `bitbucket.org/romulo_junges/pokespace-source`; the shipped tree differs from it (patch kept in `original/server/source-uncommitted-vs-bitbucket-77be843.patch`) | `original/README.md` |
| Package date | Archive contents dated 2020-08-04 | `original/README.md` |
| Project names found | "PSoul", "Poke Aimar" (client title), "Pokemon Genesis World" / "Genesis World" (MOTD, login message), "Cristal server" (startup banner), "PokeNordic" (client website links) | `config.example.lua`, `client/modules/client_entergame/*.otui`, `otserv.cpp` |
| Target client | **OTClient 0.6.x fork** ("Poke Aimar"), custom protocol version **312** (not a real Tibia version) with 8.54-shaped packets | `server/src/resources.h:79-80`, `client/modules/gamelib/protocollogin.lua:38` |
| C++ dialect | Pre-C++11 style (TR1/Boost, `NULL`, raw pointers). Compiles as `-std=gnu++11` with GCC 13 after 9 small fixes (see `BUILDING.md`) | `server/CMakeLists.txt` |
| Original compiler / build | **Dev-C++ / MinGW** (`src/dev-cpp/Makefile.win`, `PS.dev`), a Code::Blocks project, and an unused autotools skeleton (`configure.ac`, `Makefile.am`). No CMake shipped. | `original/server/source/` |
| Lua | **Lua 5.1** (`lua5.1.dll`, `lua51.dll` shipped; `luaL_openlib`, `lua_objlen` used) | `server/src/luascript.cpp`, archive manifest |
| Database | **MySQL** (primary, `__USE_MYSQL__`) and SQLite (`__USE_SQLITE__`). PostgreSQL/ODBC drivers exist in source but were not compiled by the original Makefile. Schema is stock TFS `mysql.sql` + many tables created only by the (missing) website — reconstructed in `src/schemas/psoul_extra_mysql.sql`. | `server/src/database*.cpp`, `server/src/schemas/` |
| Entry point | `server/src/otserv.cpp` (`main` → `otserv_main` → `ServiceManager::run`) | — |
| Executable (Linux build) | `server/psoul-server`, run from `server/` (reads `config.lua`, `data/`, `pt_br.loc` relative to CWD) | `BUILDING.md` |
| Data directory | `server/data/` (`actions creaturescripts globalevents items lib monster movements npc raids spells talkactions weapons world XML`) | — |
| Map | `server/data/world/map.otbm` (130 MB, Git LFS), OTBM saved with "Remere's Map Editor 1.1.9", **5879×3541** tiles; spawn/house files `map-spawn.xml`, `map-house.xml`; extra `map-sound.xml` (client ambience) | startup log (**verified**) |
| Items | `data/items/items.otb` (8.54 item profile, 1.1 MB) + `data/items/items.xml` (~10,100 `<item>` entries incl. Pokémon items, balls, TMs) | — |
| Monsters | 1,418 XML files under `data/monster/{Pokemons,Shiny,Boss,Rockets,RangerClub,FrontierIsland,Events,PvpArena,Cloned,Dungeons,Natural,Quest}` | — |
| NPCs | 902 NPC XML files + 338 NPC Lua scripts; 211 scripts use the `NpcBattle` engine (gym leaders/trainers); 60 `tmpCitizen_*.xml` are regenerated at every start and are git-ignored | `data/npc/` |
| Original config | `config.lua` (340 lines, PSoul additions at the end: `updateHighscores`, event toggles, rates) | `server/config.example.lua` |

### 1.1 Source size

91 `.cpp` files, ~110 k lines of C++ (including headers). Files not present in stock TFS 0.3.6
are the PSoul systems: `partyduel.cpp`, `pvparena.cpp`, `tournament.cpp`, `iotournament.cpp`,
`iodatalog.cpp`, `ioplayerstatistics.cpp`, `iomarket.cpp`, `polls.cpp`, `iopoll.cpp`,
`localization.cpp`, plus large edits in `protocolgame.cpp`, `player.cpp`, `monster.cpp`,
`luascript.cpp`, `game.cpp`, `iologindata.cpp`.

---

## 2. Client protocol (what a Redemption client will have to speak)

Baseline: Tibia **8.54** packet shapes (Adler-32 checksum, RSA → XTEA, outfits with addons, no
mounts, 18×14 map, `U16` speed, 7 skills, stamina). Differences from stock 8.54 are the items
marked **custom**. All layouts below were confirmed byte-by-byte by `tools/protocol_probe.py`
against the running server unless marked *source only*.

### 2.1 Transport

* Frame: `[U16 length][U32 adler32(payload)][payload]`; payload = `[U16 inner length][data]`.
  The inner length is present on unencrypted messages too. After the key exchange the payload is
  XTEA-encrypted (delta `0x61C88647`, 32 rounds).
* RSA: classic OTServ 1024-bit key (`p`, `q` hard-coded in `otserv.cpp:648-651`, `e=65537`);
  128-byte block whose first plaintext byte must be `0`.
* Protocol ids: login `0x01`, game `0x0A`, status `0xFF` (**service not registered**,
  `otserv.cpp:877` is commented out — verified: no listener), old login/game (no checksum),
  admin `0xFE` (only when compiled with `__OTADMIN__`; not in this build — verified: only ports
  7564/8548 listen), HTTP `0x00` (unused).
* Client OS ids (`enums.h:58-63`): `0x01` Linux, `0x02` Windows, `0x03` Flash,
  **`0x0A` OTClient Windows, `0x0B` OTClient Linux, `0x0C` OTClient Mac**. Almost every PSoul
  extension is gated on `player->isUsingOtclient()` (OS in `0x0A..0x0C`).
* Version check: `CLIENT_VERSION_MIN = CLIENT_VERSION_MAX = 312`
  (`resources.h`). The client sends 312 while enabling the 8.54 OTClient feature set plus
  `GameMagicEffectU16`, `GameCreatureIcons`, `GameSpritesAlphaChannel`, `GamePlayerMarket`
  (`client/modules/gamelib/protocollogin.lua:29-32`).

### 2.2 Login server (`protocollogin.cpp`)

Request `0x01`: `U16 os`, `U16 version(312)`, **`U8 language` (custom; only if OTClient OS and
version ≥ 293)**, 12 skipped bytes (dat/spr/pic signatures), RSA block = `4×U32 xtea key`,
`string account`, `string password`. Language ids: `0` en_US, `1` pt_BR, `2` es_ES
(`localization.h`); the value is persisted to `accounts.lang_id`, the OS to `accounts.client_id`.

Responses: `0x0A string` error, `0x14 string "motdId\nmotd"`, `0x64` character list:
`U8 count`, per character `string name, string world, U32 ip, U16 port` **+ custom (OTClient
only): `U16 level, U8 vocation, U16 lookType, U8 head, body, legs, feet, addons, U8 pokemonCount,
pokemonCount × (U16 number, string description)`**, then `U16 premiumDays` (65535 = free
premium) **+ custom `U8 pollAvailable`**. Verified with correct and wrong password.

### 2.3 Game server login (`protocolgame.cpp`)

1. On connect the server immediately sends an **unencrypted** challenge `0x1F U16 rand, U16 0,
   U8 rand` (`protocolgame.cpp:438`).
2. Client sends `0x0A`: `U16 os`, `U16 version`, RSA block = `4×U32 key, U8 gamemaster,
   string account, string character, string password`, 6 skipped bytes.
3. Errors use `0x14 string`. On success the sequence is standard 8.54 with one custom field:
   `0x0A U32 playerId, U16 0x32, U8 canReportBugs, **U16 realLightHour (OTClient only)**`,
   optional `0x0B` + 20 bytes (GM), `0x64` map description, `0x78/0x79` inventory slots 1..10,
   `0xA0` stats, `0xA1` skills, `0x82` world light, `0x8D` creature light, VIP list, then the
   PSoul windows (`0xFF` family) and text messages.

### 2.4 Server → client changes versus stock 8.54

| Opcode | Change | Where |
|--------|--------|-------|
| `0x83` magic effect | effect id is **`U16`** (stock: `U8`) | `AddMagicEffect`, `protocolgame.cpp:4251` |
| `0x6A`/`0x64` creature | after the standard fields (`0x61/0x62`, name, health%, dir, outfit, light, `U16` speed, skull, shield, emblem `U8 0` when unknown) PSoul appends **`U8 creatureIcon` (OTC), `U8 impassable`, `U8 isMySummon` (OTC), `U8 canDoCombat` (OTC)** | `AddCreature`, `protocolgame.cpp:4267-4318` |
| creature name | monsters are sent as `"Name [level]"`, players may be sent with nickname or empty (hideName) | same |
| `0x0A` self login | extra `U16 realLightHour` for OTClient | `protocolgame.cpp:2795` |
| `0x64` charlist | extras listed in §2.2 | `protocollogin.cpp:263-298` |
| `0x32` extended opcode | `U8 opcode, string buffer` (OTClient style), both directions | `sendExtendedOpcode` / `parseExtendedOpcode` |
| `0xF6`–`0xF9` market | 9.x-style market backported (enter/leave/detail/browse); detail attributes mostly stubbed with `U16 0` | `protocolgame.cpp:3600-3695`, `iomarket.cpp` |
| `0xFA`/`0xFB` | poll window request / vote (C→S); poll window itself is `0xFF 0x18` | `polls.cpp`, `iopoll.cpp` |
| `0xAB` channel list | channel count is **`U16`** (stock: `U8`); also used for the **TV channel list** (`CHANNEL_TV = 0xFFFD`) | `sendChannelsDialog`, `protocolgame.cpp:2093`; `sendTVChannelsDialog` |
| `0x1D` (C→S) | ping-back accepted; server replies with `0x1E` for both ping and ping-back | `protocolgame.cpp` |
| `0xFF` + sub-opcode | **PSoul namespace** (below) | `protocolgame.cpp:3053-3370, 4776-4939` |

Unchanged from 8.54 (verified on the wire): map/tiles `0x64-0x6D`, containers `0x6E-0x72`
(no pagination), inventory `0x78/0x79`, stats `0xA0` (health, maxHealth, `U32` cap×100, `U32`
exp, `U16` level, %, mana, maxMana, mlevel, %, soul, `U16` stamina), skills `0xA1`, text
`0xB4` (classes `0x12-0x1B`), speak `0xAA`, creature health `0x8C`, outfit `0x8E`, speed `0x8F`,
skull/shield `0x90/0x91`, cancel walk `0xB5`, floor change `0xBE/0xBF`, VIP `0xD2-0xD4`,
quests `0xF0/0xF1`, outfit window `0xC8`, shop `0x7A-0x7C`, trade `0x7D-0x7F`.

### 2.5 PSoul custom opcode family `0xFF`

Envelope `U8 0xFF, U8 sub`. Client enum `GameServerPSoul = 255` in
`client/src-cpp/src/client/protocolcodes.h:151-181`; parsers in `protocolgameparse.cpp`.

| Sub | Server function | Payload | Purpose |
|----:|-----------------|---------|---------|
| `0x01` | `sendPokemonSkills` | `U16 iconItemId, U8 n, n×U16 moveIconId` | move bar of the active Pokémon (**verified** on summon) |
| `0x02` / `0x03` | `sendPokemonSkillContainerClose/Open` | — | move bar visibility |
| `0x04` | `sendPokemonWindowAddPokemonIcon` | `U16 itemId, U16 fastcall, U8 color, string text` | Pokémon window (team bar) entry |
| `0x05` | `sendPokemonWindowRemovePokemonIcon` | `U16 fastcall` | |
| `0x06` | `sendPokemonWindowUpdatePokemonIcon` | `U16 fastcall, U8 color, string` | |
| `0x07` / `0x08` | `sendPokemonWindowOpen/Close` | — | (**verified** on login) |
| `0x09` | `sendPokemonSkillCooldown` | `U16 moveIconId, U8 seconds` | |
| `0x0A` | `sendPokedexStatus` | `U16 n, n×U8 status` | whole Pokédex bitmap (**verified**) |
| `0x0B` | `sendPokedexOpen` | — | |
| `0x0C` | `sendPokedexItemUpdate` | `U16 number, U8 status` | (**verified** after catch) |
| `0x0D` | `sendTmWindow` | `U16 tmMove, U8 n, n×U16 moves` | TM replace dialog |
| `0x0E` / `0x0F` / `0x10` | `sendPokemonStatusAdd/Remove/Clear` | `U16 itemId, U8 cooldown` / `U16 itemId` / — | status-condition icons |
| `0x11` | `sendPokedexInfo` | `U16 number, string details, string moves, string effectiveness, string families` | Pokédex entry |
| `0x12` | `sendCreatureJump` | `U32 creatureId` | |
| `0x13` | `sendCreatureEffect` | `U32 creatureId, U8 effectId, U32 var` | advanced creature effects |
| `0x14` / `0x15` | `sendDollCaseStatus/Update` | `U16 n, n×U8` / `U16 number, U8 status` | doll collection |
| `0x16` | `sendSlotMachine` | `3×U8` | casino reels |
| `0x17` | `sendTip` | `U8 tipId` | gameplay tips |
| `0x18` | `sendPollWindow` | `string question, U8 textMode, [U8 n, n×(U8 id, string)]` | polls |
| `0x19` | `sendPokemonLevelUp` | `U16 number, U8 level, U16 n, n×U16 moves` | level-up popup |
| `0x1A` | `sendLootList` | `U8 n, n×(U16 clientId, U8 count)` | auto-loot list (OTC only) |

Extended opcode (`0x32`) ids used by scripts and client modules (`EXTENDED_IDS` in
`data/lib/ps/others/constants.lua`, `ExtendedIds` in `client/modules/gamelib/const.lua`):
`0 Activate, 1 Locale, 2 Ping, 3 Sound, 4 Game, 5 Particles, 6 MapShader, 7 NeedsUpdate,
8 GameplayTutorialText, 9 GameplayTutorialImage, 10 DashWalking`; the client shop module also
registers an ad-hoc id **103** (purchase failed).

### 2.6 Client → server additions

`0x1D` ping-back, `0x32` extended opcode, market `0xF4` leave / `0xF5` browse (`U16`, `0xFFFE`
own offers, `0xFFFF` history) / `0xF6` create (`U8 type, U16 sprite, U16 amount, U32 price,
U8 anonymous`) / `0xF7` cancel (`U32 timestamp, U16 counter`) / `0xF8` accept (`U32, U16, U16
amount`), poll `0xFA` request / `0xFB` vote. Unknown bytes can trigger a ban when
`banUnknownBytes` is on (`protocolgame.cpp:874-902`).

### 2.7 Redemption migration notes (for later, not done in Phase 1)

1. Advertise version 312, OS `0x0A..0x0C`, keep Adler + OT RSA + XTEA and the `0x1F` challenge.
2. Force features: MagicEffectU16, CreatureIcons, PlayerMarket, SpritesAlphaChannel, addons,
   stamina, creature emblems, challenge-on-login; do **not** enable mounts, 9.x item animation,
   `U64` exp or container pagination.
3. Character list: parse the per-character extras and the trailing poll byte.
4. Creature parsing: read `icon` (OTC), `impassable`, `isSummon`, `canAttack` after the emblem.
5. Self-login: read `U16 lightHour` after `canReportBugs`.
6. Implement the `0xFF` family and Lua UI for move bar, Pokémon window, Pokédex, doll case,
   slot machine, tips, polls, level-up, loot list; the `0x32` ids above; market `0xF4-0xF9`;
   poll `0xFA/0xFB`.
7. Assets: `client/data/things/data.dat` + `data.spr` (8.54 format, PSoul sprites), the item
   profile `tools/rme/data/854/items.otb`.

---

## 3. Server systems (C++)

| System | Files | Notes |
|--------|-------|-------|
| Localization | `localization.cpp/.h` | Loads `pt_br.loc` (`English@Português` pairs, 6,928 lines) at startup; `Localization::t(lang, text)`; exposed to Lua as `__L(cid, text)`. English is the source language. |
| Party duel | `partyduel.cpp` | Team duels with bets (`datalog_duel_bet`). |
| PvP arena | `pvparena.cpp` + Lua `009-pvpArena.lua` | Instanced arenas, `players.pvparenafrags/pvparenadeaths`. |
| Tournaments | `tournament.cpp`, `iotournament.cpp`, `data/XML/tournaments.xml` | Scheduled tournaments; tables `tournaments`, `tournament_*`. Tournament 1 enabled, 2 commented out, 3 disabled in the original XML → benign startup warnings. |
| Datalog | `iodatalog.cpp` | Analytics inserts (`datalog_*` tables), e.g. `doDatalogCaught`. |
| Player statistics | `ioplayerstatistics.cpp` | `player_statistics` counters. |
| Market | `iomarket.cpp` | Backported in-game market (`market_offers`, `market_history`). |
| Polls | `polls.cpp`, `iopoll.cpp` | `polls`, `poll_options`, `poll_votes`, `poll_texts`. |
| TV | `protocolgame.cpp`, `player.cpp` | Spectate other players (`CHANNEL_TV`). |
| Account storage | `iologindata.cpp` | `account_storage` key/value per account. |
| Pokémon corpses | `monster.cpp:1308-1312` | Corpse gets attributes `pokemon`, `sex`, `level`, `specialAbility`, `corpseowner` used by the catch script. |
| Creature icons / summons | `creature.cpp`, `monster.cpp` | Icon ids and summon flags sent to OTClient. |
| Login extras | `protocollogin.cpp` | Pokémon team in charlist read from `player_pokemon`. |

---

## 4. Lua data layer

Load order: TFS libs `data/lib/000-constant.lua … 051-accountStorage.lua`, then `999-ps.lua`
loads `lib/ps/others/*`, `lib/ps/config/*`, `lib/ps/functions/*` and every `lib/ps/systems/*.lua`
(55 files; `systems/disabled/005-task.lua` is not loaded).

### 4.1 Pokémon data

* Species: `data/lib/ps/config/pokemon/*.lua` — 432 files, 594 `POKEMON[...]` entries (base,
  seasonal and Ranger-Club variants); shiny variants are cloned at load time
  (`config/pokemon.lua:44-53`). National number table `config/pokemonsNumbers.lua`
  (`POKEMON_NUMBER = 386`, Gen 1–3). `config/_pokemon/` is an unused duplicate.
* Species fields: `pTypes, atk, def, spAtk, spDef, energy, chance (catch), portrait,
  evolutions{name, requiredLevel, requiredItems, requiredTime, random}, skills{move, level,…},
  abilities (field: Cut/Surf/Fly/…), eggGroup/eggId/eggChance, specialAbilities, learnableTms,
  eggMoves, allowedBall, ignoreBallCounter`.
* Moves: `config/moves/*.lua` — 455 files (`description, category, dType, damage, requiredEnergy,
  requiredLevel, cooldownTime, cooldownStorage, functionName, iconId, clientIconId, …`). Casting:
  talkactions `m1..m16`/`s1..s16` → `events/talkactions/skill.lua` → `doPokemonUseSkill`
  (`systems/003-skill.lua`) → `doCreatureCastSpell` → `spells.xml` (483 instants, `enabled="0"`)
  → `lib/ps/events/spells/scripts/<Move>.lua` (459 scripts) → `doSkillDamage`
  (`systems/004-skillDamage.lua:194-335`, type chart, STAB ×1.1, crits ×1.3/×1.6, held-item and
  mastery bonuses).
* Wild Pokémon: ordinary TFS monsters (`data/monster/**`), level in the name suffix, `Moves`,
  `Evolve`, `Berries` as spell attacks.
* Owned Pokémon: **ball items** with ~70 integer attributes (`config/balls.lua`, base 10000):
  name, level, experience, HP, energy, status flags, nickname, sex, extraPoints (boost), special
  ability, TM slots, seal, vitamins, egg move, held item, addons. ~201 ball types
  (`balls.lua:166+`), each with empty/charged/discharged/inUse item ids; e.g. poke ball
  `12157 empty → 12159 charged → 12158 in use → 12160 discharged`.
* Inventory slot meaning (`others/constants.lua:1366-1375`): 1 order icon, 2 evolve, 3 duel,
  4 Pokémon item, 5 badge case, 6 Pokédex, 7 portrait, 8 **ball**, 9 key item, 10 pokebag.

### 4.2 Gameplay systems (Lua `lib/ps/systems/`)

`001-npcBattle` (gym/trainer battles, 211 NPCs), `002-quest` (+ `config/003-quest.lua`, ~469
quest entries, 161 NPC givers), `003-skill`, `004-skillDamage`, `006-fastcall`, `007-cooldown`,
`008-conditions`, `009-pvpArena`, `010-pokedex`, `011-highscore`, `012-extraExpRate`,
`013-tournamentHighscore`, `014-mastery`, `015-berry`, `016-safariZone`, `017-specialAbilities`,
`018-technicalMachine`, `019-ballSeal`, `020-ballCounter` (catch pity), `021-boss`,
`022-highscores`, `023-achievement` (~181 ids), `024-badgeCase`, `025-datalog`, `026-guide`,
`027-citizens`, `028-dungeons`, `029-rangerClub`, `030-easterEvent`, `031-wikiChat`, `032-ski`,
`033-oxygenMask`, `034-surpriseBox`, `035-referral`, `036-headbutt`, `037-halloweenEvent`,
`038-pokemonAddon`, `039-pokemonAbility`, `040-vitamin`, `041-dollCase`, `042-sandboard`,
`043-fishing`, `044-slotMachine`, `045-pokemonEgg`, `046-heldItem`, `047-pokemonFood`,
`048-anniversaryEvent`, `049-eliteFour`, `050-rocketBattle`, `051-christmasEvent`,
`052-extraLootRate`, `053-extraCatchRate`, `054-extraEggRate`, `055-julyVacationEvent`.

Core flows:

| Flow | Entry | Notes |
|------|-------|-------|
| Summon | `actions.xml:91` → `events/actions/balls/charged.lua` → `doPokemonCall` (`functions/others.lua:699`) | requires the ball in slot 8 |
| Return | `actions.xml:93` → `balls/inUse.lua` | saves HP/energy/status back to the ball |
| Catch | `actions.xml:90` → `balls/empty.lua` → `functions/ball/empty.lua` (`getCatchChance`, ball counter pity, `rateCatch`) | creates a charged ball, dex entry, achievements, datalog |
| Attack / damage | creaturescripts `combat`, `statschange`, spells → `doSkillDamage` | exp split: Pokémon exp via `doPlayerPokemonAddExperience` (`functions/player.lua:414+`) |
| Leveling | `getExperienceForLevel` (`lib/050-function.lua:162`) `((50·L³ − 150·L² + 400·L)/3)`; Pokémon threshold `functions/player.lua:459` uses the raw level (inconsistent with the `L-1` player formula — left as is) | |
| Evolution | `events/actions/evolve.lua` | stones from `config/pokemon.lua` `ITEMS` |
| NPC dialogue | TFS `npcsystem` + `KEYWORDS` tables; Nurse Joy heals on `hi` | |
| Startup | `globalevents/scripts/start.lua` (`onStartup`): online reset, arenas, highscores, berry trees, bosses, quest world spawns, Tiger Kelsey auction NPC, ball pillars, citizens, surprise boxes, `CALL update_rank()` (skipped while `updateHighscores = false`) | |

### 4.3 Storage keys

Players `config/playersStorages.lua` (base 7000, 78 keys), summons `config/pokemonsStorages.lua`
(base 7500), misc `config/storages.lua` (base 14000), globals `config/globalStorages.lua`, quests
(~427 unique ids inside `003-quest.lua`), NpcBattle (base 9000), highscores (`HIGHSCORE_ID_*`,
~388), move cooldowns (per move, up to ~15437), catch (`16000 + dex number`).

### 4.4 Events

Globalevents: `serverstart`, `playersrecord`, `Gameplay Tutorial Rattata` (15 s), `eeveeRespawn`
(3 h), `sudowoodoTree` (1 h), `globalMessages` (45 min), `anniversary` (1 h); `clean`, `save`,
TeamSpeak message and `halloween` are commented out in the original XML.
Creaturescripts cover login/logout/advance/think/kill/death/prepareDeath/gainexperience/target/
combat/statschange/spawn/container/channel/trade/questinfo/tournament/customoutfit. The engine
calls `registerCreatureEvent("ExtendedOpcode")` for OTClient players (`protocolgame.cpp:303`),
but no `type="extendedopcode"` event is defined in `creaturescripts.xml`, so the registration
silently fails (see §7).

---

## 5. Database

* Stock schema: `src/schemas/mysql.sql` (29 tables, `db_version 23`, account `1`/password `1`,
  "Account Manager" player).
* PSoul additions reconstructed from every SQL string in C++ and Lua:
  `src/schemas/psoul_extra_mysql.sql` — 12 `accounts`/`players` columns (`lang_id, client_id,
  referral, referral_points, soulcoins`; `hidden, pvparenafrags, pvparenadeaths,
  tournament_score, tournament_weekly_score, firstpokemon, lasteggtime`), plus 69 tables
  (`account_storage, player_statistics, player_pokemon, player_achievements, player_highscores,
  player_stored_items, ball_counter, egg_counter, daycare_*, berry_trees, ball_pillars,
  elite_four_*, referral_friends, coupons, coupon_uses, poketrader_*, pokemon_market,
  market_offers, market_history, polls, poll_*, tournaments, tournament_*, datalog_*`) and the
  `world_id 1` MOTD/record rows. Column types follow the query usage; nothing in the server
  creates these tables itself.
* Missing and **not** reconstructable: stored procedure `update_rank()` (website-side ranking);
  the website itself (account creation, character creation with starting items, shop, polls).
* Dev seed: `src/schemas/psoul_dev_seed.sql` (account `admin`/`admin`, characters "GM Admin"
  (group 6) and "Tester" (group 1) with the starting inventory the website used to create).

---

## 6. Client (`/client`, not converted in Phase 1)

OTClient 0.6-era C++ (`client/src-cpp`, VS2013 project) with Pokémon modules: `game_pokemon*`,
`game_pokedex`, `game_dollcase`, `game_badgecase`, `game_shop`, `game_market`, `game_guide`,
`game_environment` (sounds/particles/shaders), `game_tv`, `game_poll`. Text assets were imported;
`data/things/data.spr` (308 MB) is in Git LFS; `data/images` (71 MB) and `data/sounds` (51 MB)
are normal objects. The prebuilt `Poke Aimar.exe` and DLLs were not imported.

---

## 7. Known defects inherited from the original (not fixed in Phase 1)

| Issue | Evidence |
|-------|----------|
| Three XML entries point at scripts that are not in the package: `talkactions.xml:43` (`/tvbanlist` → `tv/banlist.lua`), `movements.xml:24-25` (`underwater*Secure.lua`), `actions.xml:33` (`portrait.lua`). All three were already commented out by the original authors, so nothing fails at startup; the features are simply absent. | startup log has no `[Warning - Event::loadScript]` lines (**verified**) |
| `balls.lua` defines `yereblu` twice and references `EFFECT_SILVERBALL_US` (typo) | `balls.lua:306-319` |
| `npc/backup/*.xml` reference `default.lua` / `quest_default.lua` that do not exist | not loaded (backup folder) |
| Tournaments 2 and 3 referenced by `npc/scripts/tournament.lua` are disabled in `XML/tournaments.xml` | startup warnings, harmless |
| `players.online` is reset at startup by Lua, not by the engine | `start.lua` |
| Pokémon level-up threshold uses `level` where the player formula uses `level-1` | `functions/player.lua:459` |
| Status protocol (`0xFF` service) disabled in source; the client's server-list ping cannot work | `otserv.cpp:877` |
| No Lua handler for client→server extended opcodes: `creaturescripts.xml` defines no `extendedopcode` event, so `registerCreatureEvent("ExtendedOpcode")` returns `false` and `Game::parsePlayerExtendedOpcode` only handles id `10` (dash walking) in C++. The client's `Locale` (id 1) opcode sent at login is therefore ignored; language comes from `accounts.lang_id` instead. | `protocolgame.cpp:303`, `game.cpp:7721-7729`, `creature.cpp:1734` |
| Extended opcode `103` (shop "purchase failed") is only registered on the client; nothing in the server ever sends it | `client/modules/game_shop/shop.lua`; no `103` in `server/src` or `server/data` |
| NPC `Soya.xml` references `script="loot.lua"`, which does not exist. Latent: Soya is not placed in either spawn file, so the NPC is never loaded. | `npc/Soya.xml:2`; no `loot.lua` under `npc/scripts/`; no `Soya` in `world/*-spawn.xml` |
| Move configs `Meowth Super Rocket` and `Rocket Missile` exist in `config/moves/` but have no `spells.xml` entry or script and are not in any Pokémon moveset — dead configuration | `config/moves/meowth super rocket.lua`, `config/moves/rocket missile.lua` |
| `PS_LIB_SKILLS_DIR` points at `lib/ps/skills/`, which does not exist; the constant is never used | `lib/999-ps.lua:6` |
| Unused duplicate trees are shipped but not loaded: `config/_pokemon/` (432 files), `others/pokemon_backup/` (304), `others/moves_disabled/` (9), `systems/disabled/005-task.lua`. Kept untouched in Phase 1; candidates for removal later. | no loader references these paths |
