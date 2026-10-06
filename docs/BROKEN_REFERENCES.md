# Broken references — static audit

Generated at commit **`3d9cf7f`** (`git rev-parse --short HEAD`). Documentation only: nothing was
deleted or fixed.

How to re-run (Python 3, stdlib only, about 10 s, no server needed):

```bash
python3 tools/check_references.py              # summary + REAL ERROR list, always exits 0
python3 tools/check_references.py --all        # every finding, all classes
python3 tools/check_references.py --markdown   # the tables in the appendix below
python3 tools/check_references.py --json       # machine-readable
python3 tools/check_references.py --strict     # exit 1 on REAL ERROR not in tools/check_references_allowlist.txt
python3 tools/check_references.py --write-allowlist > tools/check_references_allowlist.txt
```

`--strict` passes today: the allowlist holds the 44 current REAL ERROR keys, each with a comment
giving location, impact and BUG id. A new broken reference, or a fixed one (a stale allowlist entry),
is reported. A fixed reference doesn't fail the run; just remove its line.

## 1. Summary

The checker resolved **126 156** references. It produced **217 findings** after grouping: one row per
broken target per directory, with every affected file:line listed in the row.

| class | findings | meaning |
|---|---:|---|
| REAL ERROR | **44** | live code or data points at something that does not exist |
| COMMENTED/DISABLED | 48 | the referencing entry is commented out, disabled, or reachable only from disabled code |
| HISTORICAL BACKUP | 13 | inside a backup/unused tree (`_pokemon/`, `pokemon_backup/`, `npc/backup/`, `lib/disabled/`, `*_backup.*`, `*.bak`, `-spawn.xml`, `-house.xml`); aggregated per tree (≈1 800 raw hits) |
| FALSE POSITIVE | 89 | the checker cannot prove the reference, but it is fine (reason given per row) |
| CLIENT-DEPENDENT | 11 | client↔server mismatches that only matter for a different or stock client |
| WEBSITE-DEPENDENT | 12 | hard-coded external URLs (pokenordic.com / psoul.net) |

REAL ERROR by area:

| area | REAL | checks |
|---|---:|---|
| Pokémon species configs (`lib/ps/config/pokemon/*.lua`) | 35 | `pokemon.tm` 16, `pokemon.eggMove.typo` 11, `pokemon.specialAbility` 4, `pokemon.ability` 3, `pokemon.itemid` 1 |
| Client UI resources | 3 | `client.otui` |
| Client↔server protocol | 2 | `protocol.psoul.listener` |
| Server Lua | 2 | `lua.createMonster`, `lua.creatureEvent` |
| Quests | 1 | `quest.npc.unspawned` |
| SQL schema | 1 | `sql.table` |

Findings by check, all classes (from the script summary):

| check | REAL | COMM | HIST | FP | CLIENT | WEB |
|---|---:|---:|---:|---:|---:|---:|
| client.extopcode / .locale / .send | | 2 | | | 3 | |
| client.guideImage | | 1 | | | | |
| client.otui | 3 | | | | | |
| client.path / .dynamic | | 1 | | 19 | | |
| lua.createMonster | 1 | 1 | | | | |
| lua.creatureEvent | 1 | | | | | |
| lua.executeRaid | | 1 | | | | |
| lua.tm / tm.move | | 6 | | | | |
| monsters.xml.file | | 10 | | | | |
| npc.script | | 1 | | | | |
| pokemon.ability | 3 | | 2 | | | |
| pokemon.eggMove.typo | 11 | | 2 | | | |
| pokemon.eggMove.unimplemented | | | 2 | 50 | | |
| pokemon.itemid | 1 | | 2 | | | |
| pokemon.move | | | 1 | | | |
| pokemon.specialAbility | 4 | 2 | 2 | | | |
| pokemon.tm | 16 | 2 | 2 | | | |
| protocol.c2s.unhandled | | | | | 8 | |
| protocol.psoul.listener | 2 | | | | | |
| quest.npc / .unspawned | 1 | 9 | | 1 | | |
| raid.monster | | 2 | | | | |
| sql.table | 1 | 1 | | 7 | | |
| website.url | | | | | | 12 |
| xml.itemid.otbonly | | 2 | | 12 | | |
| xml.script | | 7 | | | | |

The appendix has the exact per-row evidence. The script's `--all` output is authoritative if this
table drifts.

## 2. What was checked and how references resolve

Server CWD is `server/`, so `getDataDir()` = `data/`. Rules mirror the engine (TFS 0.3.6 fork):

- **Event XML scripts.** `actions`, `movements`, `talkactions`, `creaturescripts`, `globalevents`,
  `spells` and `weapons`: `script`/`value` resolves against `data/<subsystem>/scripts/`
  (`baseevents.cpp:51`). `../../lib/...` paths are honoured. Entries inside `<!-- -->` are checked but
  classed COMMENTED/DISABLED. A script referenced only by commented entries makes its own findings
  COMMENTED (26 such scripts).
- **NPC `script`.** Resolves against `npc/scripts/` unless it contains `/` (`npc.cpp:388`). NPC
  files are looked up case-sensitively as `data/npc/<name>.xml`.
- **Raids.** `raids.xml` `file` resolves under `data/raids/`, and `<script file>` under
  `raids/scripts/`. `executeRaid` names match case-insensitively (`strcasecmp`).
- **Monsters.** `monsters.xml` `file` must exist. Monster names (spawns, raids, `doCreateMonster`,
  `doSummon*`, summons, quest targets) match case-insensitively, as in TFS. Spell names use
  `strcasecmp`. Creature-event names are case-sensitive (`std::map`).
- **Which spawn and house files are used.** `world/map.otbm`'s header names **`map-spawn.xml`** and
  **`map-house.xml`**. `world/-spawn.xml` and `world/-house.xml` are stale copies, classed HISTORICAL.
- **Item ids.** `itemid`/`fromid-toid` in actions and movements, NPC shop ids, monster loot,
  Pokémon egg/portrait ids, TM item ids, quest items and rewards. Each id is checked against
  `items.xml` (17 545 ids) and the server ids parsed from `items.otb` (29 484). An id that exists only
  in the otb is still known to the engine, so it is a FALSE POSITIVE.
- **Lua loaders.** `dofile` / `require` / `loadfile` arguments are evaluated: string literals,
  `..` concatenation, `getDataDir()` and known path globals. All 40 resolve.
- **Pokémon configs.** Live tree only, `lib/ps/config/pokemon/*.lua` (594 species):
  - `evolutions` target species;
  - `skills` and `eggMoves` vs `MOVES[...]` (455 moves);
  - `abilities` vs `POKEMON_ABILITIES`;
  - `learnableTms` `TM_IDS.X` vs `TM_IDS`;
  - `specialAbilities` vs `POKEMON_SPECIAL_ABILITY_IDS`;
  - egg, portrait and dexPortrait ids.

  Egg moves that aren't in `MOVES` are pruned at startup by `doUpdatePokemonEggMovesList()`
  (`lib/ps/functions/pokemon.lua:1668`). Only near-miss spellings (difflib ≥ 0.84) are REAL. The
  50 genuinely unimplemented moves are FALSE POSITIVE.
- **Quests.** `QUESTS_CONFIG` NPC keys must have an NPC file, and be in `map-spawn.xml` or named in a
  Lua file that calls `doCreateNpc`. Also checked: `BRING_ITEMS` ids, Pokémon targets and rewards.
- **SQL.** Table names in Lua and C++ queries vs `schemas/mysql.sql` + `psoul_extra_mysql.sql`
  (98 tables, 430 references).
- **Client** (OTClient PhysFS: `client/modules`, `client/data` and `client/` are all mounted at
  `/`; paths are case-sensitive):
  - `.otmod` `dependencies`, `scripts`, `load-later`, `@onLoad`/`@onUnload`.
  - `dofile` / `importStyle` / `loadUI` / `displayUI` / `g_ui.*` paths. Relative paths resolve from
    the calling file's directory.
  - `/images/...`, `/sounds/...` literals and otui `image-source` / `icon-source`. `guessFilePath`
    extensions are tried, and `~` (OTML null) is skipped.

  48 of 51 modules are loaded. `client_serverlist`, `game_environment` and `game_shop` are never
  loaded, so findings in them are COMMENTED/DISABLED.
- **Protocol.**
  - `0xFF` PSoul sub-opcodes the server sends (`AddByte(0xFF)` + sub byte) vs the client's
    `GameServerPSoulOpcodes` parse cases, plus the Lua listeners for every `g_game.on*` event the
    C++ parser fires.
  - Server `sendExtendedOpcode` ids vs client `ProtocolGame.registerExtendedOpcode`.
  - Client extended and main opcodes vs the server `parsePacket` cases.

## 3. REAL ERROR findings (44)

All are pre-existing in the imported archive. "Inert" means the broken reference has no
player-visible effect today.

### 3.1 Pokémon species configs (35)

| # | evidence (`server/data/lib/ps/config/pokemon/…`) | broken reference | player-visible impact | BUG |
|---|---|---|---|---|
| 1 | 59 files, `:17`: absol, aggron, armaldo, aron, bagon, … (full list in appendix) | ability `"Strenght"` | those species never get the **Strength** field ability | BUG-30 (says 11, see §4) |
| 2 | `flygon.lua:17`, `trapinch.lua:17`, `vibrava.lua:17` | ability `"Rock Slide"` (a move, not a field ability) | entry ignored | BUG-30/50 area, new |
| 3 | `mewtwo.lua:17` | ability `"RockMSmash"` | Mewtwo never gets Rock Smash | new |
| 4–14 | ariados/spinarak `:23` `"Psybeam "` (trailing space) and `"Singal Beam"`; azumarill/marill `"Copycate"`; corsola/misdreavus `"Screeh"`; croconaw/feraligatr/totodile `"Fake Teasr"`; fearow `:25`/spearow `:23` `"Sacry Face"`; granbull/snubbull `"Heall Bell"`; lapras `"Freezy-Dry"`; miltank `"Harmmer Arm"`; murkrow `"Mirro Move"`; piloswine/swinub `"Iciel Crash"` | egg-move typos | the egg move is silently dropped at startup and never offered for breeding | new |
| 15 | `kingler.lua:11` | dexPortrait `135600` (krabby is 13599, so 13600 intended) | inert: `getPokemonDexPortraitId()` has no caller | new |
| 16–19 | `camerupt.lua:21` `SOLID_ROCK`; `milotic.lua:21` `MARVEL_SCALE`; `smoochum.lua:21` + `test smoochum.lua:21` `FOREWARN`; `torkoal.lua:21` `WHITE_SMOKE` | `POKEMON_SPECIAL_ABILITY_IDS.X` undefined → `nil` | species silently lacks that special ability | new |
| 20 | 78 files, `:22` | `TM_IDS.TAUNT` | there is no Taunt TM, so nothing is lost. The `nil` hole can make `table.random` (uses `#t`) in `npcbattle_{lorelei,lance,agatha,bruno}.lua:28` pick `nil` | new |
| 21 | `blastoise.lua:22`, `squirtle.lua:22`, `wartortle.lua:22` | `TM_IDS.FOCUS_PUNHC` (**confirmed**; key is `FOCUS_PUNCH`) | the Squirtle line cannot learn the Focus Punch TM | new |
| 22–35 | `bagon` `ROARBRICK_BREAK`; `carvanha` `CARVANHA`; cleffa/igglybuff/pichu `LIGHT_SCRREN`; dodrio/doduo `SKUL_BASH`; gengar `SEISMC_TOSS`; jumpluff `JUMPLUFF`; jynx `BUBBLEABEAM`; lickitung `SANDSTORMONIX`; meowth/paras/parasect/persian `SKULL_BASh`; moltres `SWFIT`; paras/parasect `BE`; raticate `SHOKC_WAVE`; regice `SHOCK__WAVE`; tangela `SWORDS_DANCCE` (all `:22`) | `TM_IDS.X` undefined → `nil` | the species cannot learn the intended TM (`table.find` skips the hole) | new |

### 3.2 Client, protocol, server Lua, quests, SQL (9)

| # | evidence | broken reference | player-visible impact | BUG |
|---|---|---|---|---|
| 36 | `client/src-cpp/src/client/protocolgameparse.cpp:1828` (open), `:1823` (close) | `parseMoveBarOpen/Close` fire `g_game.onMoveBarOpen/onMoveBarClose`. No loaded module connects them: `game_pokemoves/pokemoves.lua:245-252` listens to `onPokemonMovesOpen/Close` | server `0xFF 0x02`/`0x03` never hides or shows the move bar, so a stale bar can stay after recalling a Pokémon. Inherited from `original/` | **new** |
| 37 | | (same pair, counted as 2 findings) | | |
| 38 | `client/data/styles/30-minimap.otui:98`, `client/modules/game_minimap/flagwindow.otui:7` | `icon-source: /images/game/minimap/mapflags` (only `flag0.png` and `cross.png` ship) | minimap-flag icons in the flag window render blank | new |
| 39 | | (same image, second file) | | |
| 40 | `client/modules/game_market/ui/general/marketcombobox.otui:7` | `/images/combobox_rounded` | market combobox has no background image. The market NPC isn't spawned anyway (BUG-15) | new |
| 41 | `server/data/actions/scripts/tools/shovel.lua:21` (shovel 2554, `actions.xml:226`) | `doCreateMonster("Scarab")`: no such monster | 15 % of digs log "monster not found"; nothing spawns | new |
| 42 | `server/data/lib/ps/systems/049-eliteFour.lua:97` | `registerCreatureEvent(cid, "onLogout_EliteFour")`: no such event | inert: `onLogout.lua:37-38` already removes the challenger | new |
| 43 | `server/data/lib/ps/config/003-quest.lua:6060` | quest NPC **London Hamnet** has an XML but is not in `map-spawn.xml` and no `doCreateNpc` names him | his quest line is unreachable | BUG-15 (not listed there) |
| 44 | `server/src/iologindata.cpp:1243` | `INSERT INTO parcels`: no shipped schema creates it | each player-to-player parcel logs an SQL error ("PS - Parcel log" in `IOLoginData::playerMail`). The parcel itself is delivered | **new** |

## 4. Contradictions and additions to earlier docs

| doc | earlier statement | finding |
|---|---|---|
| `docs/BUG_TRIAGE.md:47,218` (BUG-30) | `"Strenght"` typo in **11** species (aggron, claydol, linoone, shelgon, seviper, regice, vibrava, rayquaza, groudon, manectric, delcatty) | **59** live species carry it (the original archive has the same 59). The 11 listed are a subset. |
| `docs/PHASE_2_REPORT.md:68,161` | move bar via `0xFF 0x01` "rendered without desync" | Correct for `0x01`, but `0xFF 0x02`/`0x03` (move bar close/open) reach no Lua handler (§3.2 #36). Not in BUG_TRIAGE. |
| `docs/BUG_TRIAGE.md:32,199` (BUG-15) | unspawned NPCs: bank NPCs + Jaron Jewell | Also **London Hamnet** (quest NPC). Ray Fitz, the Easter NPCs (Snap, Easter Rabbit), Santa Claus and five Halloween NPCs are also unspawned, but they are superseded or tied to disabled events (COMMENTED/DISABLED). |
| `docs/BUG_TRIAGE.md` | — | New: missing `parcels` table (§3.2 #44); Squirtle-line `FOCUS_PUNHC` and 15 other TM key typos; 11 egg-move typos; 4 undefined special-ability ids; `mapflags.png` / `combobox_rounded.png` missing; shovel `Scarab`. |
| `docs/BUG_TRIAGE.md:31,193` (BUG-14) | Anniversary event permanently active, hourly raid | Consistent, with a nuance: `raids.xml:5` has Anniversary `enabled="no"`. The hourly raid comes from the anniversary globalevent (`globalevents.xml`, interval 3600) calling `executeRaid("anniversary")` at `lib/ps/systems/048-anniversaryEvent.lua:596`, which bypasses the flag. |
| `docs/BUG_TRIAGE.md:249` (BUG-38) | dead code: Soya `loot.lua`, `game_shop` opcode 103, `003-quest.lua.bak` | Confirmed; all classed COMMENTED/DISABLED or HISTORICAL. |
| `docs/PHASE_2_REPORT.md` (client→server: only ext opcode 10 handled; Locale never sent) | — | Confirmed. In addition, the C++ client sends ext opcode **2** (ping) at `protocolgamesend.cpp:131`, which the server silently drops. 8 client main opcodes (0x33, 0x77, 0x8D, 0xD4, 0xDE, 0xF2, 0xF3, 0xF9) have no server `parsePacket` case. They're harmless with `autoBanishUnknownBytes = false` and the shipped client doesn't send them in normal play. CLIENT-DEPENDENT. |

## 5. Verified clean

- **Spawns and houses:** all 32 950 monster and 1 764 NPC entries in `map-spawn.xml` resolve
  (case-insensitive). `map.otbm` uses `map-spawn.xml` / `map-house.xml`.
- **Monsters:** all 1 171 `monsters.xml` files exist, except 10 commented Shiny legendaries. All
  8 747 loot ids, all summons, all monster spells and all creature-script events resolve. 246
  monster XMLs are not registered in `monsters.xml` (informational).
- **Raids:** every active raid's file, script and monster names resolve. 26 raid XMLs
  (`raids/pvpArena/...`, one backup) are not referenced by `raids.xml`, and no Lua or C++ loader
  for them was found. They are unused data, not broken references.
- **Event XML scripts and item ids:** every non-commented script exists. Every itemid exists in
  `items.xml` or `items.otb`.
- **NPCs:** every NPC script exists except Soya's (BUG-38). Shop ids resolve.
- **Lua loaders:** all 40 `dofile`/`require`/`loadfile` targets exist.
- **Pokémon:** all evolution targets and all `skills` moves resolve. All TM item ids and TM moves
  resolve, except two commented TMS entries.
- **Quests:** all NPC keys (except the placeholder `PokeMart`), `BRING_ITEMS` ids, Pokémon targets
  and rewards resolve.
- **SQL:** 430 table references resolve; the exceptions are `parcels` and commented
  `player_first_pokemon` (BUG-24).
- **Client:** every `.otmod` dependency, script and hook resolves. Every static `dofile`, style,
  otui and image/sound path resolves, apart from the 3 otui images above. All 39 tutorial pages exist
  in `content/en` and `content/pt`. Every server tutorial image name exists in `/images/guide/`
  (except the commented `00?-pokemart`).
- **Protocol:**
  - All **26** `0xFF` PSoul sub-opcodes the server sends are parsed by the client, and vice versa.
  - Server extended opcodes 8 and 9 are handled by `game_guide`.
  - Server `EXTENDED_IDS` matches client `ExtendedIds`.
  - Every other C++ `g_game.on*` PSoul event has a Lua listener.

## Appendix — every finding (`python3 tools/check_references.py --markdown`)

Grouped rows list every affected file:line in the "detail" column. For those rows, the "file:line"
column shows the directory.

#### `client.extopcode`

| class | file:line | target | detail | note |
|---|---|---|---|---|
| COMMENTED/DISABLED | `client/modules/game_shop/shop.lua:3` | `103` | client registers extended opcode 103 (module game_shop, never loaded) but the server never sends it | game_shop module is never loaded; server never sends 103 BUG-38 |

#### `client.extopcode.locale`

| class | file:line | target | detail | note |
|---|---|---|---|---|
| CLIENT-DEPENDENT | `client/modules/client_locales/locales.lua:80` | `1` | client registers extended opcode 1 (module client_locales) but the server never sends it | client_locales registers opcode 1 but locales travel in the login packet BUG-09 |
| CLIENT-DEPENDENT | `client/modules/client_locales/locales.lua:88` | `1` | client registers extended opcode 1 (module client_locales) but the server never sends it | client_locales registers opcode 1 but locales travel in the login packet BUG-09 |

#### `client.extopcode.send`

| class | file:line | target | detail | note |
|---|---|---|---|---|
| COMMENTED/DISABLED | `client/modules/client_locales/locales.lua:11` | `1` | client sends extended opcode 1; server has no handler (silently dropped) | sendLocale() stub is never called (locale sent in the login packet) BUG-09 |
| CLIENT-DEPENDENT | `client/src-cpp/src/client/protocolgamesend.cpp:131` | `2` | client sends extended opcode 2; server has no handler (silently dropped) | C++ ProtocolGame sends opcode 2 (ping) on login; server has no extendedopcode event |

#### `client.guideImage`

| class | file:line | target | detail | note |
|---|---|---|---|---|
| COMMENTED/DISABLED | `server/data/lib/ps/events/movements/activationTile.lua:1169` | `00?-pokemart` | server tutorial image has no client file /images/guide/00?-pokemart.png |  |

#### `client.otui`

| class | file:line | target | detail | note |
|---|---|---|---|---|
| REAL ERROR | `client/data/styles/30-minimap.otui:98` | `/images/game/minimap/mapflags` | icon-source does not resolve (/images/game/minimap/mapflags.png) | minimap flag icons render blank (mapflags.png missing; only flag0.png ships) |
| REAL ERROR | `client/modules/game_market/ui/general/marketcombobox.otui:7` | `/images/combobox_rounded` | image-source does not resolve (/images/combobox_rounded.png) | market combobox has no background image |
| REAL ERROR | `client/modules/game_minimap/flagwindow.otui:7` | `/images/game/minimap/mapflags` | icon-source does not resolve (/images/game/minimap/mapflags.png) | minimap flag icons render blank (mapflags.png missing; only flag0.png ships) |

#### `client.path`

| class | file:line | target | detail | note |
|---|---|---|---|---|
| COMMENTED/DISABLED | `client/modules/game_environment/environment.lua:160` | `data.lua` | dofile('data.lua') does not resolve (/game_environment/data.lua) |  |

#### `client.path.dynamic`

| class | file:line | target | detail | note |
|---|---|---|---|---|
| FALSE POSITIVE | `client/modules/client_entergame/characterlist.lua:204` | `'/images/trainerCards/' .. getVocationNameById(characterInfo.vocation)` | setImageSource path built at runtime |  |
| FALSE POSITIVE | `client/modules/client_entergame/characterlist.lua:224` | `'/images/pictures/' .. v.number` | setImageSource path built at runtime |  |
| FALSE POSITIVE | `client/modules/client_locales/locales.lua:32` | `'/images/flags/' .. name .. ''` | setImageSource path built at runtime |  |
| FALSE POSITIVE | `client/modules/client_styles/styles.lua:6` | `'/styles/' .. file` | importStyle path built at runtime |  |
| FALSE POSITIVE | `client/modules/client_styles/styles.lua:13` | `'/fonts/' .. file` | importFont path built at runtime |  |
| FALSE POSITIVE | `client/modules/client_styles/styles.lua:20` | `'/particles/' .. file` | importParticle path built at runtime |  |
| FALSE POSITIVE | `client/modules/game_advanceeffect/advanceeffect.lua:170` | `'/images/staticPortraits/' .. id` | setImageSource path built at runtime |  |
| FALSE POSITIVE | `client/modules/game_guide/guide.lua:28` | `'/images/guide/' .. buffer` | setImageSource path built at runtime | names come from the server; resolved by the client.guideImage check |
| FALSE POSITIVE | `client/modules/game_pokedex/pokedex.lua:213` | `"/images/types/" .. info` | setImageSource path built at runtime |  |
| FALSE POSITIVE | `client/modules/game_pokedex/pokedex.lua:219` | `"/images/moveCategories/" .. info` | setImageSource path built at runtime |  |
| FALSE POSITIVE | `client/modules/game_pokedex/pokedex.lua:229` | `"/images/pictures/" .. pokemonId` | setImageSource path built at runtime |  |
| FALSE POSITIVE | `client/modules/game_pokedex/pokedex.lua:235` | `"/images/types/" .. getTypeIdByName(type1Name)` | setImageSource path built at runtime |  |
| FALSE POSITIVE | `client/modules/game_pokedex/pokedex.lua:243` | `"/images/types/" .. getTypeIdByName(type2Name)` | setImageSource path built at runtime |  |
| FALSE POSITIVE | `client/modules/game_pokedex/pokedex.lua:254` | `"/images/pokeicons/" .. string.format("%03d", v)` | setImageSource path built at runtime |  |
| FALSE POSITIVE | `client/modules/game_pokedex/pokedex.lua:324` | `"/images/types/square/" .. type` | setImageSource path built at runtime |  |
| FALSE POSITIVE | `client/modules/game_tips/tips.lua:22` | `'/images/tips/' .. value` | setImageSource path built at runtime |  |
| FALSE POSITIVE | `client/modules/game_tutorial/tutorial.lua:11` | `"/modules/game_tutorial/content/en/".. string.format("%02d", i) ..".lua"` | dofile path built at runtime | loop 1..39 verified: content/en and content/pt both hold 01.lua..39.lua |
| FALSE POSITIVE | `client/modules/game_tutorial/tutorial.lua:12` | `"/modules/game_tutorial/content/pt/".. string.format("%02d", i) ..".lua"` | dofile path built at runtime | loop 1..39 verified: content/en and content/pt both hold 01.lua..39.lua |
| FALSE POSITIVE | `client/modules/gamelib/ui/uiminimap.lua:121` | `'/images/game/minimap/flag' .. icon` | setIcon path built at runtime |  |

#### `lua.createMonster`

| class | file:line | target | detail | note |
|---|---|---|---|---|
| REAL ERROR | `server/data/actions/scripts/tools/shovel.lua:21` | `Scarab` | doCreateMonster: monster not in monsters.xml | stock TFS shovel: 15% of digs log 'monster not found' (no Scarab here) |
| COMMENTED/DISABLED | `server/data/actions/scripts/other/music.lua:43` | `Wolf` | doSummonCreature: monster not in monsters.xml |  |

#### `lua.creatureEvent`

| class | file:line | target | detail | note |
|---|---|---|---|---|
| REAL ERROR | `server/data/lib/ps/systems/049-eliteFour.lua:97` | `onLogout_EliteFour` | registerCreatureEvent: no creaturescripts.xml event with this name | registration returns false; inert because the generic onLogout.lua:37-38 already removes the Elite Four challenger |

#### `lua.executeRaid`

| class | file:line | target | detail | note |
|---|---|---|---|---|
| COMMENTED/DISABLED | `server/data/lib/ps/events/globalevents/halloween.lua:2` | `halloween` | executeRaid: raid is commented out in raids.xml:9 (call returns false) | script is only referenced by commented-out registry entries |

#### `lua.tm`

| class | file:line | target | detail | note |
|---|---|---|---|---|
| COMMENTED/DISABLED | `server/data/lib/ps/systems/018-technicalMachine.lua:26` | `TM_IDS.WHIRLWIND` | TM_IDS key undefined |  |
| COMMENTED/DISABLED | `server/data/lib/ps/systems/018-technicalMachine.lua:98` | `TM_IDS.PAY_DAY` | TM_IDS key undefined |  |
| COMMENTED/DISABLED | `server/data/lib/ps/systems/018-technicalMachine.lua:171` | `TM_IDS.DIG` | TM_IDS key undefined |  |
| COMMENTED/DISABLED | `server/data/lib/ps/systems/018-technicalMachine.lua:180` | `TM_IDS.TELEPORT` | TM_IDS key undefined |  |

#### `monsters.xml.file`

| class | file:line | target | detail | note |
|---|---|---|---|---|
| COMMENTED/DISABLED | `server/data/monster/monsters.xml:733` | `Shiny/shiny latias.xml` | monster file missing for 'Shiny Latias' |  |
| COMMENTED/DISABLED | `server/data/monster/monsters.xml:736` | `Shiny/shiny registeel.xml` | monster file missing for 'Shiny Registeel' |  |
| COMMENTED/DISABLED | `server/data/monster/monsters.xml:743` | `Shiny/shiny rayquaza.xml` | monster file missing for 'Shiny Rayquaza' |  |
| COMMENTED/DISABLED | `server/data/monster/monsters.xml:765` | `Shiny/shiny jirachi.xml` | monster file missing for 'Shiny Jirachi' |  |
| COMMENTED/DISABLED | `server/data/monster/monsters.xml:769` | `Shiny/shiny latios.xml` | monster file missing for 'Shiny Latios' |  |
| COMMENTED/DISABLED | `server/data/monster/monsters.xml:802` | `Shiny/shiny groudon.xml` | monster file missing for 'Shiny Groudon' |  |
| COMMENTED/DISABLED | `server/data/monster/monsters.xml:806` | `Shiny/shiny kyogre.xml` | monster file missing for 'Shiny Kyogre' |  |
| COMMENTED/DISABLED | `server/data/monster/monsters.xml:807` | `Shiny/shiny regice.xml` | monster file missing for 'Shiny Regice' |  |
| COMMENTED/DISABLED | `server/data/monster/monsters.xml:812` | `Shiny/shiny deoxys.xml` | monster file missing for 'Shiny Deoxys' |  |
| COMMENTED/DISABLED | `server/data/monster/monsters.xml:833` | `Shiny/shiny regirock.xml` | monster file missing for 'Shiny Regirock' |  |

#### `npc.script`

| class | file:line | target | detail | note |
|---|---|---|---|---|
| COMMENTED/DISABLED | `server/data/npc/Soya.xml:2` | `loot.lua` | NPC script missing: server/data/npc/scripts/loot.lua | stock TFS buyer NPC, in no spawn file; only reachable with /n Soya BUG-38 |

#### `pokemon.ability`

| class | file:line | target | detail | note |
|---|---|---|---|---|
| REAL ERROR | `server/data/lib/ps/config/pokemon/` | `Strenght` (x59) | ability string matches no POKEMON_ABILITIES value (typo of 'Strength'?); the field ability is never granted [in absol.lua:17, aggron.lua:17, armaldo.lua:17, aron.lua:17, bagon.lua:17, blaziken.lua:17, camerupt.lua:17, claydol.lua:17, combusken.lua:17, corphish.lua:17, cradily.lua:17, crawdaunt.lua:17, delcatty.lua:17, deoxys.lua:17, electrike.lua:17, flygon.lua:17, groudon.lua:17, grovyle.lua:17, kecleon.lua:17, kyogre.lua:17, lairon.lua:17, linoone.lua:17, manectric.lua:17, marshtomp.lua:17, mawile.lua:17, medicham.lua:17, meditite.lua:17, metagross.lua:17, metang.lua:17, mightyena.lua:17, mudkip.lua:17, nosepass.lua:17, numel.lua:17, nuzleaf.lua:17, rayquaza.lua:17, regice.lua:17, regirock.lua:17, registeel.lua:17, salamence.lua:17, sceptile.lua:17, seviper.lua:17, sharpedo.lua:17, shelgon.lua:17, shiftry.lua:17, slaking.lua:17, slakoth.lua:17, spinda.lua:17, swampert.lua:17, torchic.lua:17, torkoal.lua:17, trapinch.lua:17, treecko.lua:17, tropius.lua:17, vibrava.lua:17, vigoroth.lua:17, wailmer.lua:17, wailord.lua:17, whiscash.lua:17, zangoose.lua:17] | species never get the Strength field ability (BUG-30 lists 11; 59 are affected) BUG-30 |
| REAL ERROR | `server/data/lib/ps/config/pokemon/` | `Rock Slide` (x3) | ability string matches no POKEMON_ABILITIES value; the field ability is never granted [in flygon.lua:17, trapinch.lua:17, vibrava.lua:17] | 'Rock Slide' is a move, not a field ability; entry is ignored |
| REAL ERROR | `server/data/lib/ps/config/pokemon/` | `RockMSmash` | ability string matches no POKEMON_ABILITIES value (typo of 'Rock Smash'?); the field ability is never granted [in mewtwo.lua:17] | Mewtwo never gets Rock Smash |
| HISTORICAL BACKUP | `server/data/lib/ps/config/_pokemon/` | `*` (x63) | historical tree, not loaded; e.g. server/data/lib/ps/config/_pokemon/absol.lua:17 Strenght -- ability string matches no POKEMON_ABILITIES value (typo of 'Strength'?); the field ability is never granted | BUG-30 |
| HISTORICAL BACKUP | `server/data/lib/ps/others/pokemon_backup/` | `*` (x3) | historical tree, not loaded; e.g. server/data/lib/ps/others/pokemon_backup/deoxys_atk.lua:17 Strenght -- ability string matches no POKEMON_ABILITIES value (typo of 'Strength'?); the field ability is never granted | BUG-30 |

#### `pokemon.eggMove.typo`

| class | file:line | target | detail | note |
|---|---|---|---|---|
| REAL ERROR | `server/data/lib/ps/config/pokemon/` | `Psybeam ` (x2) | eggMoves typo of 'Psybeam'; doUpdatePokemonEggMovesList() silently drops it [in ariados.lua:23, spinarak.lua:23] | egg move silently dropped at startup by doUpdatePokemonEggMovesList(); never offered |
| REAL ERROR | `server/data/lib/ps/config/pokemon/` | `Singal Beam` (x2) | eggMoves typo of 'Signal Beam'; doUpdatePokemonEggMovesList() silently drops it [in ariados.lua:23, spinarak.lua:23] | egg move silently dropped at startup by doUpdatePokemonEggMovesList(); never offered |
| REAL ERROR | `server/data/lib/ps/config/pokemon/` | `Copycate` (x2) | eggMoves typo of 'Copycat'; doUpdatePokemonEggMovesList() silently drops it [in azumarill.lua:23, marill.lua:23] | egg move silently dropped at startup by doUpdatePokemonEggMovesList(); never offered |
| REAL ERROR | `server/data/lib/ps/config/pokemon/` | `Screeh` (x2) | eggMoves typo of 'Screech'; doUpdatePokemonEggMovesList() silently drops it [in corsola.lua:23, misdreavus.lua:23] | egg move silently dropped at startup by doUpdatePokemonEggMovesList(); never offered |
| REAL ERROR | `server/data/lib/ps/config/pokemon/` | `Fake Teasr` (x3) | eggMoves typo of 'Fake Tears'; doUpdatePokemonEggMovesList() silently drops it [in croconaw.lua:23, feraligatr.lua:23, totodile.lua:23] | egg move silently dropped at startup by doUpdatePokemonEggMovesList(); never offered |
| REAL ERROR | `server/data/lib/ps/config/pokemon/` | `Sacry Face` (x2) | eggMoves typo of 'Scary Face'; doUpdatePokemonEggMovesList() silently drops it [in fearow.lua:25, spearow.lua:23] | egg move silently dropped at startup by doUpdatePokemonEggMovesList(); never offered |
| REAL ERROR | `server/data/lib/ps/config/pokemon/` | `Heall Bell` (x2) | eggMoves typo of 'Heal Bell'; doUpdatePokemonEggMovesList() silently drops it [in granbull.lua:23, snubbull.lua:23] | egg move silently dropped at startup by doUpdatePokemonEggMovesList(); never offered |
| REAL ERROR | `server/data/lib/ps/config/pokemon/` | `Freezy-Dry` | eggMoves typo of 'Freeze-Dry'; doUpdatePokemonEggMovesList() silently drops it [in lapras.lua:23] | egg move silently dropped at startup by doUpdatePokemonEggMovesList(); never offered |
| REAL ERROR | `server/data/lib/ps/config/pokemon/` | `Harmmer Arm` | eggMoves typo of 'Hammer Arm'; doUpdatePokemonEggMovesList() silently drops it [in miltank.lua:23] | egg move silently dropped at startup by doUpdatePokemonEggMovesList(); never offered |
| REAL ERROR | `server/data/lib/ps/config/pokemon/` | `Mirro Move` | eggMoves typo of 'Mirror Move'; doUpdatePokemonEggMovesList() silently drops it [in murkrow.lua:23] | egg move silently dropped at startup by doUpdatePokemonEggMovesList(); never offered |
| REAL ERROR | `server/data/lib/ps/config/pokemon/` | `Iciel Crash` (x2) | eggMoves typo of 'Icicle Crash'; doUpdatePokemonEggMovesList() silently drops it [in piloswine.lua:23, swinub.lua:23] | egg move silently dropped at startup by doUpdatePokemonEggMovesList(); never offered |
| HISTORICAL BACKUP | `server/data/lib/ps/config/_pokemon/` | `*` (x20) | historical tree, not loaded; e.g. server/data/lib/ps/config/_pokemon/ariados.lua:23 Psybeam  -- eggMoves typo of 'Psybeam'; doUpdatePokemonEggMovesList() silently drops it |  |
| HISTORICAL BACKUP | `server/data/lib/ps/others/pokemon_backup/` | `*` (x21) | historical tree, not loaded; e.g. server/data/lib/ps/others/pokemon_backup/ariados.lua:9 Psybeam  -- eggMoves typo of 'Psybeam'; doUpdatePokemonEggMovesList() silently drops it |  |

#### `pokemon.eggMove.unimplemented`

| class | file:line | target | detail | note |
|---|---|---|---|---|
| HISTORICAL BACKUP | `server/data/lib/ps/config/_pokemon/` | `*` (x363) | historical tree, not loaded; e.g. server/data/lib/ps/config/_pokemon/abra.lua:23 Guard Split -- egg move not implemented; pruned at startup by design (pokemon.lua:1668) |  |
| HISTORICAL BACKUP | `server/data/lib/ps/others/pokemon_backup/` | `*` (x333) | historical tree, not loaded; e.g. server/data/lib/ps/others/pokemon_backup/abra.lua:9 Guard Split -- egg move not implemented; pruned at startup by design (pokemon.lua:1668) |  |
| FALSE POSITIVE | `server/data/lib/ps/config/pokemon/` | `Guard Split` (x5) | egg move not implemented; pruned at startup by design (pokemon.lua:1668) [in abra.lua:23, alakazam.lua:23, kadabra.lua:23, rhydon.lua:23, rhyhorn.lua:23] |  |
| FALSE POSITIVE | `server/data/lib/ps/config/pokemon/` | `Guard Swap` (x10) | egg move not implemented; pruned at startup by design (pokemon.lua:1668) [in abra.lua:23, alakazam.lua:23, drowzee.lua:23, hypno.lua:23, kadabra.lua:23, magcargo.lua:23, quagsire.lua:23, skarmory.lua:23, slugma.lua:23, wooper.lua:23] |  |
| FALSE POSITIVE | `server/data/lib/ps/config/pokemon/` | `Power Trick` (x9) | egg move not implemented; pruned at startup by design (pokemon.lua:1668) [in abra.lua:23, alakazam.lua:23, forretress.lua:23, gligar.lua:23, kadabra.lua:23, machamp.lua:23, machoke.lua:23, machop.lua:23, pineco.lua:23] |  |
| FALSE POSITIVE | `server/data/lib/ps/config/pokemon/` | `Skill Swap` (x13) | egg move not implemented; pruned at startup by design (pokemon.lua:1668) [in abra.lua:23, alakazam.lua:23, drowzee.lua:23, exeggcute.lua:23, exeggutor.lua:23, girafarig.lua:23, hypno.lua:23, kadabra.lua:23, misdreavus.lua:23, natu.lua:23, venomoth.lua:23, venonat.lua:23, xatu.lua:23] |  |
| FALSE POSITIVE | `server/data/lib/ps/config/pokemon/` | `Me First` (x11) | egg move not implemented; pruned at startup by design (pokemon.lua:1668) [in absol.lua:23, mightyena.lua:23, misdreavus.lua:23, pinsir.lua:23, poochyena.lua:23, raticate.lua:23, rattata.lua:23, slowbro.lua:23, slowking.lua:23, slowpoke.lua:26, stantler.lua:23] |  |
| FALSE POSITIVE | `server/data/lib/ps/config/pokemon/` | `Whirlwind` (x14) | egg move not implemented; pruned at startup by design (pokemon.lua:1668) [in aerodactyl.lua:23, crobat.lua:23, fearow.lua:25, golbat.lua:23, hoothoot.lua:23, murkrow.lua:23, noctowl.lua:23, skarmory.lua:23, snorlax.lua:23, spearow.lua:23, swellow.lua:23, taillow.lua:23, yanma.lua:23, zubat.lua:23] |  |
| FALSE POSITIVE | `server/data/lib/ps/config/pokemon/` | `Wide Guard` (x10) | egg move not implemented; pruned at startup by design (pokemon.lua:1668) [in aerodactyl.lua:23, geodude.lua:23, golem.lua:23, graveler.lua:23, hariyama.lua:23, makuhita.lua:23, mantine.lua:23, nosepass.lua:23, paras.lua:23, parasect.lua:23] |  |
| FALSE POSITIVE | `server/data/lib/ps/config/pokemon/` | `Beat Up` (x19) | egg move not implemented; pruned at startup by design (pokemon.lua:1668) [in aipom.lua:23, arbok.lua:23, charizard.lua:23, charmander.lua:23, charmeleon.lua:23, diglett.lua:23, dugtrio.lua:23, ekans.lua:23, girafarig.lua:23, houndoom.lua:23, houndour.lua:23, mankey.lua:23, nidoking.lua:23, nidoqueen.lua:23, nidorana.lua:23, nidorano.lua:23, nidorina.lua:23, nidorino.lua:23, primeape.lua:23] |  |
| FALSE POSITIVE | `server/data/lib/ps/config/pokemon/` | `Switcheroo` (x3) | egg move not implemented; pruned at startup by design (pokemon.lua:1668) [in aipom.lua:23, arbok.lua:23, ekans.lua:23] |  |
| FALSE POSITIVE | `server/data/lib/ps/config/pokemon/` | `After You` (x10) | egg move not implemented; pruned at startup by design (pokemon.lua:1668) [in ampharos.lua:23, bellossom.lua:23, flaaffy.lua:23, gloom.lua:23, mareep.lua:23, oddish.lua:23, quagsire.lua:23, snorlax.lua:23, vileplume.lua:23, wooper.lua:23] |  |
| FALSE POSITIVE | `server/data/lib/ps/config/pokemon/` | `Electric Terrain` (x3) | egg move not implemented; pruned at startup by design (pokemon.lua:1668) [in ampharos.lua:23, flaaffy.lua:23, mareep.lua:23] |  |
| FALSE POSITIVE | `server/data/lib/ps/config/pokemon/` | `Odor Sleuth` (x5) | egg move not implemented; pruned at startup by design (pokemon.lua:1668) [in ampharos.lua:23, flaaffy.lua:23, mareep.lua:23, meowth.lua:23, persian.lua:23] |  |
| FALSE POSITIVE | `server/data/lib/ps/config/pokemon/` | `Snatch` (x4) | egg move not implemented; pruned at startup by design (pokemon.lua:1668) [in arbok.lua:23, ekans.lua:23, meowth.lua:23, persian.lua:23] |  |
| FALSE POSITIVE | `server/data/lib/ps/config/pokemon/` | `Howl` (x7) | egg move not implemented; pruned at startup by design (pokemon.lua:1668) [in arcanine.lua:23, cyndaquil.lua:23, growlithe.lua:23, ninetales.lua:23, quilava.lua:23, typhlosion.lua:23, vulpix.lua:23] |  |
| FALSE POSITIVE | `server/data/lib/ps/config/pokemon/` | `Morning Sun` (x10) | egg move not implemented; pruned at startup by design (pokemon.lua:1668) [in arcanine.lua:23, growlithe.lua:23, ponyta.lua:23, rapidash.lua:23, sunflora.lua:23, sunkern.lua:23, togepi.lua:23, togetic.lua:23, venomoth.lua:23, venonat.lua:23] |  |
| FALSE POSITIVE | `server/data/lib/ps/config/pokemon/` | `Baton Pass` (x7) | egg move not implemented; pruned at startup by design (pokemon.lua:1668) [in ariados.lua:23, gligar.lua:23, scizor.lua:23, scyther.lua:23, spinarak.lua:23, venomoth.lua:23, venonat.lua:23] |  |
| FALSE POSITIVE | `server/data/lib/ps/config/pokemon/` | `Belly Drum` (x17) | egg move not implemented; pruned at startup by design (pokemon.lua:1668) [in azumarill.lua:23, charizard.lua:23, charmander.lua:23, charmeleon.lua:23, clefable.lua:23, clefairy.lua:23, cleffa.lua:23, cubone.lua:23, magby.lua:23, magmar.lua:23, marill.lua:23, marowak.lua:23, slowbro.lua:23, slowking.lua:23, slowpoke.lua:26, teddiursa.lua:23, ursaring.lua:23] |  |
| FALSE POSITIVE | `server/data/lib/ps/config/pokemon/` | `Perish Song` (x13) | egg move not implemented; pruned at startup by design (pokemon.lua:1668) [in azumarill.lua:23, cubone.lua:23, dewgong.lua:24, gastly.lua:23, gengar.lua:23, haunter.lua:23, igglybuff.lua:23, jigglypuff.lua:23, marill.lua:23, marowak.lua:23, murkrow.lua:23, seel.lua:23, wigglytuff.lua:23] |  |
| FALSE POSITIVE | `server/data/lib/ps/config/pokemon/` | `Soak` (x4) | egg move not implemented; pruned at startup by design (pokemon.lua:1668) [in azumarill.lua:23, chinchou.lua:23, lanturn.lua:23, marill.lua:23] |  |
| FALSE POSITIVE | `server/data/lib/ps/config/pokemon/` | `Teeter Dance` (x5) | egg move not implemented; pruned at startup by design (pokemon.lua:1668) [in bellossom.lua:23, gloom.lua:23, mr. mime.lua:23, oddish.lua:23, vileplume.lua:23] |  |
| FALSE POSITIVE | `server/data/lib/ps/config/pokemon/` | `Natural Gift` (x24) | egg move not implemented; pruned at startup by design (pokemon.lua:1668) [in bellsprout.lua:23, blissey.lua:23, chansey.lua:23, dodrio.lua:23, doduo.lua:23, eevee.lua:29, espeon.lua:23, exeggcute.lua:23, exeggutor.lua:23, flareon.lua:23, furret.lua:23, jolteon.lua:23, miltank.lua:23, paras.lua:23, parasect.lua:23, sentret.lua:23, snorlax.lua:23, sunflora.lua:23, sunkern.lua:23, tangela.lua:23, umbreon.lua:23, vaporeon.lua:23, victreebel.lua:23, weepinbell.lua:23] |  |
| FALSE POSITIVE | `server/data/lib/ps/config/pokemon/` | `Water Spout` (x5) | egg move not implemented; pruned at startup by design (pokemon.lua:1668) [in blastoise.lua:23, octillery.lua:23, remoraid.lua:23, squirtle.lua:23, wartortle.lua:23] |  |
| FALSE POSITIVE | `server/data/lib/ps/config/pokemon/` | `Gravity` (x5) | egg move not implemented; pruned at startup by design (pokemon.lua:1668) [in blissey.lua:23, chansey.lua:23, igglybuff.lua:23, jigglypuff.lua:23, wigglytuff.lua:23] |  |
| FALSE POSITIVE | `server/data/lib/ps/config/pokemon/` | `Helping Hand` (x13) | egg move not implemented; pruned at startup by design (pokemon.lua:1668) [in blissey.lua:23, chansey.lua:23, hitmonchan.lua:23, hitmonlee.lua:23, hitmontop.lua:23, hoppip.lua:23, jumpluff.lua:23, miltank.lua:23, shuckle.lua:23, skiploom.lua:23, sunflora.lua:23, sunkern.lua:23, tyrogue.lua:23] |  |
| FALSE POSITIVE | `server/data/lib/ps/config/pokemon/` | `Block` (x17) | egg move not implemented; pruned at startup by design (pokemon.lua:1668) [in cacnea.lua:23, cacturne.lua:23, croconaw.lua:23, exeggcute.lua:23, exeggutor.lua:23, feraligatr.lua:23, geodude.lua:23, glalie.lua:23, golem.lua:23, graveler.lua:23, onix.lua:23, slowbro.lua:23, slowking.lua:23, slowpoke.lua:26, snorunt.lua:23, steelix.lua:23, totodile.lua:23] |  |
| FALSE POSITIVE | `server/data/lib/ps/config/pokemon/` | `Bestow` (x4) | egg move not implemented; pruned at startup by design (pokemon.lua:1668) [in delibird.lua:23, pichu.lua:23, pikachu.lua:23, raichu.lua:23] |  |
| FALSE POSITIVE | `server/data/lib/ps/config/pokemon/` | `Spikes` (x6) | egg move not implemented; pruned at startup by design (pokemon.lua:1668) [in delibird.lua:23, glalie.lua:23, omanyte.lua:23, omastar.lua:23, roselia.lua:23, snorunt.lua:23] |  |
| FALSE POSITIVE | `server/data/lib/ps/config/pokemon/` | `Entrainment` (x4) | egg move not implemented; pruned at startup by design (pokemon.lua:1668) [in dewgong.lua:24, octillery.lua:23, remoraid.lua:23, seel.lua:23] |  |
| FALSE POSITIVE | `server/data/lib/ps/config/pokemon/` | `Final Gambit` (x10) | egg move not implemented; pruned at startup by design (pokemon.lua:1668) [in diglett.lua:23, dugtrio.lua:23, nincada.lua:26, ninjask.lua:23, raticate.lua:23, rattata.lua:23, seviper.lua:23, shedinja.lua:23, shuckle.lua:23, zangoose.lua:23] |  |
| FALSE POSITIVE | `server/data/lib/ps/config/pokemon/` | `Assist` (x7) | egg move not implemented; pruned at startup by design (pokemon.lua:1668) [in drowzee.lua:23, furret.lua:23, hypno.lua:23, meowth.lua:23, persian.lua:23, sentret.lua:23, sneasel.lua:23] |  |
| FALSE POSITIVE | `server/data/lib/ps/config/pokemon/` | `Trump Card` (x3) | egg move not implemented; pruned at startup by design (pokemon.lua:1668) [in dunsparce.lua:23, farfetchd.lua:23, kangaskhan.lua:23] |  |
| FALSE POSITIVE | `server/data/lib/ps/config/pokemon/` | `Grudge` (x10) | egg move not implemented; pruned at startup by design (pokemon.lua:1668) [in dusclops.lua:23, duskull.lua:23, gardevoir.lua:23, gastly.lua:23, gengar.lua:23, haunter.lua:23, kirlia.lua:23, koffing.lua:23, ralts.lua:23, weezing.lua:23] |  |
| FALSE POSITIVE | `server/data/lib/ps/config/pokemon/` | `Feint` (x14) | egg move not implemented; pruned at startup by design (pokemon.lua:1668) [in electabuzz.lua:23, elekid.lua:23, gligar.lua:23, hariyama.lua:23, hitmonchan.lua:23, hitmonlee.lua:23, hitmontop.lua:23, houndoom.lua:23, houndour.lua:23, makuhita.lua:23, pinsir.lua:23, sneasel.lua:23, tyrogue.lua:23, yanma.lua:23] |  |
| FALSE POSITIVE | `server/data/lib/ps/config/pokemon/` | `Lucky Chant` (x7) | egg move not implemented; pruned at startup by design (pokemon.lua:1668) [in exeggcute.lua:23, exeggutor.lua:23, pichu.lua:23, pikachu.lua:23, raichu.lua:23, togepi.lua:23, togetic.lua:23] |  |
| FALSE POSITIVE | `server/data/lib/ps/config/pokemon/` | `Power Swap` (x7) | egg move not implemented; pruned at startup by design (pokemon.lua:1668) [in exeggcute.lua:23, exeggutor.lua:23, magby.lua:23, magmar.lua:23, ninetales.lua:23, tangela.lua:23, vulpix.lua:23] |  |
| FALSE POSITIVE | `server/data/lib/ps/config/pokemon/` | `Trick` (x3) | egg move not implemented; pruned at startup by design (pokemon.lua:1668) [in furret.lua:23, mr. mime.lua:23, sentret.lua:23] |  |
| FALSE POSITIVE | `server/data/lib/ps/config/pokemon/` | `Autotomize` (x3) | egg move not implemented; pruned at startup by design (pokemon.lua:1668) [in geodude.lua:23, golem.lua:23, graveler.lua:23] |  |
| FALSE POSITIVE | `server/data/lib/ps/config/pokemon/` | `Mean Look` (x3) | egg move not implemented; pruned at startup by design (pokemon.lua:1668) [in girafarig.lua:23, grimer.lua:23, muk.lua:23] |  |
| FALSE POSITIVE | `server/data/lib/ps/config/pokemon/` | `Posil Tail` | egg move not implemented; pruned at startup by design (pokemon.lua:1668) [in gligar.lua:23] |  |
| FALSE POSITIVE | `server/data/lib/ps/config/pokemon/` | `Imprison` (x3) | egg move not implemented; pruned at startup by design (pokemon.lua:1668) [in grimer.lua:23, misdreavus.lua:23, muk.lua:23] |  |
| FALSE POSITIVE | `server/data/lib/ps/config/pokemon/` | `Vacuum Wave` (x4) | egg move not implemented; pruned at startup by design (pokemon.lua:1668) [in hitmonchan.lua:23, hitmonlee.lua:23, hitmontop.lua:23, tyrogue.lua:23] |  |
| FALSE POSITIVE | `server/data/lib/ps/config/pokemon/` | `Pain Split` (x2) | egg move not implemented; pruned at startup by design (pokemon.lua:1668) [in koffing.lua:23, weezing.lua:23] |  |
| FALSE POSITIVE | `server/data/lib/ps/config/pokemon/` | `Sweet Scent` (x8) | egg move not implemented; pruned at startup by design (pokemon.lua:1668) [in lombre.lua:23, lotad.lua:23, ludicolo.lua:23, paras.lua:23, parasect.lua:23, shuckle.lua:23, sunflora.lua:23, sunkern.lua:23] |  |
| FALSE POSITIVE | `server/data/lib/ps/config/pokemon/` | `Tail Whip` (x2) | egg move not implemented; pruned at startup by design (pokemon.lua:1668) [in meowth.lua:23, persian.lua:23] |  |
| FALSE POSITIVE | `server/data/lib/ps/config/pokemon/` | `Wonder Room` (x4) | egg move not implemented; pruned at startup by design (pokemon.lua:1668) [in misdreavus.lua:23, slowbro.lua:23, slowking.lua:23, slowpoke.lua:26] |  |
| FALSE POSITIVE | `server/data/lib/ps/config/pokemon/` | `Magic Room` | egg move not implemented; pruned at startup by design (pokemon.lua:1668) [in mr. mime.lua:23] |  |
| FALSE POSITIVE | `server/data/lib/ps/config/pokemon/` | `Power Split` | egg move not implemented; pruned at startup by design (pokemon.lua:1668) [in mr. mime.lua:23] |  |
| FALSE POSITIVE | `server/data/lib/ps/config/pokemon/` | `Tail Slap` (x2) | egg move not implemented; pruned at startup by design (pokemon.lua:1668) [in ninetales.lua:23, vulpix.lua:23] |  |
| FALSE POSITIVE | `server/data/lib/ps/config/pokemon/` | `Rototiller` (x8) | egg move not implemented; pruned at startup by design (pokemon.lua:1668) [in onix.lua:23, paras.lua:23, parasect.lua:23, rhydon.lua:23, rhyhorn.lua:23, sandshrew.lua:23, sandslash.lua:23, steelix.lua:23] |  |
| FALSE POSITIVE | `server/data/lib/ps/config/pokemon/` | `Acupressure` (x3) | egg move not implemented; pruned at startup by design (pokemon.lua:1668) [in shuckle.lua:23, tentacool.lua:23, tentacruel.lua:23] |  |

#### `pokemon.itemid`

| class | file:line | target | detail | note |
|---|---|---|---|---|
| REAL ERROR | `server/data/lib/ps/config/pokemon/` | `135600` | dexPortrait item id not in items.xml/otb [in kingler.lua:11] | Kingler dexPortrait typo (13600 intended); inert, getPokemonDexPortraitId() has no caller |
| HISTORICAL BACKUP | `server/data/lib/ps/config/_pokemon/` | `*` | historical tree, not loaded; e.g. server/data/lib/ps/config/_pokemon/kingler.lua:11 135600 -- dexPortrait item id not in items.xml/otb |  |
| HISTORICAL BACKUP | `server/data/lib/ps/others/pokemon_backup/` | `*` | historical tree, not loaded; e.g. server/data/lib/ps/others/pokemon_backup/kingler.lua:2 135600 -- dexPortrait item id not in items.xml/otb |  |

#### `pokemon.move`

| class | file:line | target | detail | note |
|---|---|---|---|---|
| HISTORICAL BACKUP | `server/data/lib/ps/others/pokemon_backup/` | `*` (x2) | historical tree, not loaded; e.g. server/data/lib/ps/others/pokemon_backup/deoxys_def.lua:16 Spikes -- skills entry is not a MOVES[...] move |  |

#### `pokemon.specialAbility`

| class | file:line | target | detail | note |
|---|---|---|---|---|
| REAL ERROR | `server/data/lib/ps/config/pokemon/` | `POKEMON_SPECIAL_ABILITY_IDS.SOLID_ROCK` | POKEMON_SPECIAL_ABILITY_IDS key undefined -> nil (stray token, intended value unknown) [in camerupt.lua:21] | species silently lacks that special ability (nil entry) |
| REAL ERROR | `server/data/lib/ps/config/pokemon/` | `POKEMON_SPECIAL_ABILITY_IDS.MARVEL_SCALE` | POKEMON_SPECIAL_ABILITY_IDS key undefined -> nil (stray token, intended value unknown) [in milotic.lua:21] | species silently lacks that special ability (nil entry) |
| REAL ERROR | `server/data/lib/ps/config/pokemon/` | `POKEMON_SPECIAL_ABILITY_IDS.FOREWARN` (x2) | POKEMON_SPECIAL_ABILITY_IDS key undefined -> nil (stray token, intended value unknown) [in smoochum.lua:21, test smoochum.lua:21] | species silently lacks that special ability (nil entry) |
| REAL ERROR | `server/data/lib/ps/config/pokemon/` | `POKEMON_SPECIAL_ABILITY_IDS.WHITE_SMOKE` | POKEMON_SPECIAL_ABILITY_IDS key undefined -> nil (stray token, intended value unknown) [in torkoal.lua:21] | species silently lacks that special ability (nil entry) |
| COMMENTED/DISABLED | `server/data/lib/ps/config/pokemon/` | `POKEMON_SPECIAL_ABILITY_IDS.FOREWARN` (x3) | POKEMON_SPECIAL_ABILITY_IDS key undefined -> nil (stray token, intended value unknown) [in drowzee.lua:21, hypno.lua:21, jynx.lua:21] |  |
| COMMENTED/DISABLED | `server/data/lib/ps/config/pokemon/` | `POKEMON_SPECIAL_ABILITY_IDS.MOLD_BREAKER` | POKEMON_SPECIAL_ABILITY_IDS key undefined -> nil (stray token, intended value unknown) [in pinsir.lua:21] |  |
| HISTORICAL BACKUP | `server/data/lib/ps/config/_pokemon/` | `*` (x9) | historical tree, not loaded; e.g. server/data/lib/ps/config/_pokemon/camerupt.lua:21 POKEMON_SPECIAL_ABILITY_IDS.SOLID_ROCK -- POKEMON_SPECIAL_ABILITY_IDS key undefined -> nil (stray token, intended value unknown) |  |
| HISTORICAL BACKUP | `server/data/lib/ps/others/pokemon_backup/` | `*` (x6) | historical tree, not loaded; e.g. server/data/lib/ps/others/pokemon_backup/drowzee.lua:7 POKEMON_SPECIAL_ABILITY_IDS.FOREWARN -- POKEMON_SPECIAL_ABILITY_IDS key undefined -> nil (stray token, intended value unknown) |  |

#### `pokemon.tm`

| class | file:line | target | detail | note |
|---|---|---|---|---|
| REAL ERROR | `server/data/lib/ps/config/pokemon/` | `TM_IDS.TAUNT` (x78) | TM_IDS key undefined -> nil (stray token, intended value unknown) [in abra.lua:22, absol.lua:22, aerodactyl.lua:22, aggron.lua:22, aipom.lua:22, alakazam.lua:22, arcanine.lua:22, banette.lua:22, carvanha.lua:22, chimecho.lua:22, corphish.lua:22, crawdaunt.lua:22, crobat.lua:22, deoxys.lua:22, dodrio.lua:22, dusclops.lua:22, duskull.lua:22, electrode.lua:22, exploud.lua:22, gardevoir.lua:22, gastly.lua:22, gengar.lua:22, gligar.lua:22, golbat.lua:22, granbull.lua:22, grimer.lua:22, growlithe.lua:22, grumpig.lua:22, gyarados.lua:22, haunter.lua:22, houndoom.lua:22, houndour.lua:22, jynx.lua:22, kadabra.lua:22, kirlia.lua:22, koffing.lua:22, larvitar.lua:22, loudred.lua:22, mankey.lua:22, mawile.lua:22, meowth.lua:22, mightyena.lua:22, misdreavus.lua:22, mr. mime.lua:22, muk.lua:22, murkrow.lua:22, nidoking.lua:22, nidoqueen.lua:22, nosepass.lua:22, onix.lua:22, persian.lua:22, poochyena.lua:22, primeape.lua:22, pupitar.lua:22, qwilfish.lua:22, ralts.lua:22, raticate.lua:22, rattata.lua:22, sableye.lua:22, seviper.lua:22, sharpedo.lua:22, shuppet.lua:22, skarmory.lua:22, slaking.lua:22, sneasel.lua:22, snubbull.lua:22, spoink.lua:22, steelix.lua:22, sudowoodo.lua:22, teddiursa.lua:22, tyranitar.lua:22, umbreon.lua:22, ursaring.lua:22, vigoroth.lua:22, voltorb.lua:22, weezing.lua:22, zangoose.lua:22, zubat.lua:22] | no Taunt TM exists, so nothing is lost; the nil hole can make table.random(#t) in npcbattle_{lorelei,lance,agatha,bruno}.lua:28 pick nil |
| REAL ERROR | `server/data/lib/ps/config/pokemon/` | `TM_IDS.ROARBRICK_BREAK` | TM_IDS key undefined (typo of BRICK_BREAK?) -> nil, species cannot use it [in bagon.lua:22] | the species cannot learn that TM (nil in learnableTms; table.find skips it) |
| REAL ERROR | `server/data/lib/ps/config/pokemon/` | `TM_IDS.FOCUS_PUNHC` (x3) | TM_IDS key undefined (typo of FOCUS_PUNCH?) -> nil, species cannot use it [in blastoise.lua:22, squirtle.lua:22, wartortle.lua:22] | the species cannot learn that TM (nil in learnableTms; table.find skips it) |
| REAL ERROR | `server/data/lib/ps/config/pokemon/` | `TM_IDS.CARVANHA` | TM_IDS key undefined -> nil (stray token, intended value unknown) [in carvanha.lua:22] | the species cannot learn that TM (nil in learnableTms; table.find skips it) |
| REAL ERROR | `server/data/lib/ps/config/pokemon/` | `TM_IDS.LIGHT_SCRREN` (x3) | TM_IDS key undefined (typo of LIGHT_SCREEN?) -> nil, species cannot use it [in cleffa.lua:22, igglybuff.lua:22, pichu.lua:22] | the species cannot learn that TM (nil in learnableTms; table.find skips it) |
| REAL ERROR | `server/data/lib/ps/config/pokemon/` | `TM_IDS.SKUL_BASH` (x2) | TM_IDS key undefined (typo of SKULL_BASH?) -> nil, species cannot use it [in dodrio.lua:22, doduo.lua:22] | the species cannot learn that TM (nil in learnableTms; table.find skips it) |
| REAL ERROR | `server/data/lib/ps/config/pokemon/` | `TM_IDS.SEISMC_TOSS` | TM_IDS key undefined (typo of SEISMIC_TOSS?) -> nil, species cannot use it [in gengar.lua:22] | the species cannot learn that TM (nil in learnableTms; table.find skips it) |
| REAL ERROR | `server/data/lib/ps/config/pokemon/` | `TM_IDS.JUMPLUFF` | TM_IDS key undefined -> nil (stray token, intended value unknown) [in jumpluff.lua:22] | the species cannot learn that TM (nil in learnableTms; table.find skips it) |
| REAL ERROR | `server/data/lib/ps/config/pokemon/` | `TM_IDS.BUBBLEABEAM` | TM_IDS key undefined (typo of BUBBLEBEAM?) -> nil, species cannot use it [in jynx.lua:22] | the species cannot learn that TM (nil in learnableTms; table.find skips it) |
| REAL ERROR | `server/data/lib/ps/config/pokemon/` | `TM_IDS.SANDSTORMONIX` | TM_IDS key undefined -> nil (stray token, intended value unknown) [in lickitung.lua:22] | the species cannot learn that TM (nil in learnableTms; table.find skips it) |
| REAL ERROR | `server/data/lib/ps/config/pokemon/` | `TM_IDS.SKULL_BASh` (x4) | TM_IDS key undefined (typo of SKULL_BASH?) -> nil, species cannot use it [in meowth.lua:22, paras.lua:22, parasect.lua:22, persian.lua:22] | the species cannot learn that TM (nil in learnableTms; table.find skips it) |
| REAL ERROR | `server/data/lib/ps/config/pokemon/` | `TM_IDS.SWFIT` | TM_IDS key undefined -> nil (stray token, intended value unknown) [in moltres.lua:22] | the species cannot learn that TM (nil in learnableTms; table.find skips it) |
| REAL ERROR | `server/data/lib/ps/config/pokemon/` | `TM_IDS.BE` (x2) | TM_IDS key undefined -> nil (stray token, intended value unknown) [in paras.lua:22, parasect.lua:22] | the species cannot learn that TM (nil in learnableTms; table.find skips it) |
| REAL ERROR | `server/data/lib/ps/config/pokemon/` | `TM_IDS.SHOKC_WAVE` | TM_IDS key undefined (typo of SHOCK_WAVE?) -> nil, species cannot use it [in raticate.lua:22] | the species cannot learn that TM (nil in learnableTms; table.find skips it) |
| REAL ERROR | `server/data/lib/ps/config/pokemon/` | `TM_IDS.SHOCK__WAVE` | TM_IDS key undefined (typo of SHOCK_WAVE?) -> nil, species cannot use it [in regice.lua:22] | the species cannot learn that TM (nil in learnableTms; table.find skips it) |
| REAL ERROR | `server/data/lib/ps/config/pokemon/` | `TM_IDS.SWORDS_DANCCE` | TM_IDS key undefined (typo of SWORDS_DANCE?) -> nil, species cannot use it [in tangela.lua:22] | the species cannot learn that TM (nil in learnableTms; table.find skips it) |
| COMMENTED/DISABLED | `server/data/lib/ps/config/pokemon/` | `TM_IDS.WHIRLWIND` (x18) | TM_IDS key is commented out in constants.lua (TM disabled) -> nil entry [in aerodactyl.lua:22, articuno.lua:22, butterfree.lua:22, dodrio.lua:22, doduo.lua:22, farfetchd.lua:22, fearow.lua:24, frozen boss articuno.lua:22, golbat.lua:22, moltres.lua:22, pidgeot.lua:22, pidgeotto.lua:22, pidgey.lua:22, spearow.lua:22, thief fearow.lua:22, venomoth.lua:22, zapdos.lua:22, zubat.lua:22] |  |
| COMMENTED/DISABLED | `server/data/lib/ps/config/pokemon/` | `TM_IDS.PAY_DAY` (x17) | TM_IDS key is commented out in constants.lua (TM disabled) -> nil entry [in dewgong.lua:23, golduck.lua:22, mankey.lua:22, meowth.lua:22, mewtwo.lua:22, nidoking.lua:22, nidoqueen.lua:22, persian.lua:22, pikachu.lua:22, primeape.lua:22, psyduck.lua:22, raichu.lua:22, rhydon.lua:22, seel.lua:22, slowbro.lua:22, slowpoke.lua:25, snorlax.lua:22] |  |
| HISTORICAL BACKUP | `server/data/lib/ps/config/_pokemon/` | `*` (x47) | historical tree, not loaded; e.g. server/data/lib/ps/config/_pokemon/aerodactyl.lua:22 TM_IDS.WHIRLWIND -- TM_IDS key is commented out in constants.lua (TM disabled) -> nil entry |  |
| HISTORICAL BACKUP | `server/data/lib/ps/others/pokemon_backup/` | `*` (x47) | historical tree, not loaded; e.g. server/data/lib/ps/others/pokemon_backup/aerodactyl.lua:8 TM_IDS.WHIRLWIND -- TM_IDS key is commented out in constants.lua (TM disabled) -> nil entry |  |

#### `protocol.c2s.unhandled`

| class | file:line | target | detail | note |
|---|---|---|---|---|
| CLIENT-DEPENDENT | `client/src-cpp/src/client/protocolgamesend.cpp:281` | `ClientEquipItem=0x77` | client can send ClientEquipItem; server parsePacket has no case (dropped, or banned if autoBanishUnknownBytes) |  |
| CLIENT-DEPENDENT | `client/src-cpp/src/client/protocolgamesend.cpp:468` | `ClientLookCreature=0x8D` | client can send ClientLookCreature; server parsePacket has no case (dropped, or banned if autoBanishUnknownBytes) |  |
| CLIENT-DEPENDENT | `client/src-cpp/src/client/protocolgamesend.cpp:719` | `ClientMount=0xD4` | client can send ClientMount; server parsePacket has no case (dropped, or banned if autoBanishUnknownBytes) |  |
| CLIENT-DEPENDENT | `client/src-cpp/src/client/protocolgamesend.cpp:746` | `ClientEditVip=0xDE` | client can send ClientEditVip; server parsePacket has no case (dropped, or banned if autoBanishUnknownBytes) |  |
| CLIENT-DEPENDENT | `client/src-cpp/src/client/protocolgamesend.cpp:805` | `ClientNewRuleViolation=0xF2` | client can send ClientNewRuleViolation; server parsePacket has no case (dropped, or banned if autoBanishUnknownBytes) |  |
| CLIENT-DEPENDENT | `client/src-cpp/src/client/protocolgamesend.cpp:817` | `ClientRequestItemInfo=0xF3` | client can send ClientRequestItemInfo; server parsePacket has no case (dropped, or banned if autoBanishUnknownBytes) |  |
| CLIENT-DEPENDENT | `client/src-cpp/src/client/protocolgamesend.cpp:827` | `ClientAnswerModalDialog=0xF9` | client can send ClientAnswerModalDialog; server parsePacket has no case (dropped, or banned if autoBanishUnknownBytes) |  |
| CLIENT-DEPENDENT | `client/src-cpp/src/client/protocolgamesend.cpp:840` | `ClientChangeMapAwareRange=0x33` | client can send ClientChangeMapAwareRange; server parsePacket has no case (dropped, or banned if autoBanishUnknownBytes) |  |

#### `protocol.psoul.listener`

| class | file:line | target | detail | note |
|---|---|---|---|---|
| REAL ERROR | `client/src-cpp/src/client/protocolgameparse.cpp:1823` | `onMoveBarClose` | parseMoveBarClose fires g_game.onMoveBarClose but no loaded client module connects it | 0xFF/0x02 and 0x03 (move bar close/open) reach no Lua handler: game_pokemoves listens to onPokemonMovesOpen/Close, so the move bar is never hidden by the server (stale bar after recall); inherited from the archive |
| REAL ERROR | `client/src-cpp/src/client/protocolgameparse.cpp:1828` | `onMoveBarOpen` | parseMoveBarOpen fires g_game.onMoveBarOpen but no loaded client module connects it | 0xFF/0x02 and 0x03 (move bar close/open) reach no Lua handler: game_pokemoves listens to onPokemonMovesOpen/Close, so the move bar is never hidden by the server (stale bar after recall); inherited from the archive |

#### `quest.npc`

| class | file:line | target | detail | note |
|---|---|---|---|---|
| FALSE POSITIVE | `server/data/lib/ps/config/003-quest.lua:5072` | `PokeMart` | QUESTS_CONFIG key has no data/npc/<name>.xml | placeholder key ('Default name, isn't really a NPC name', 003-quest.lua:5073) used by quest_pokemart.lua |

#### `quest.npc.unspawned`

| class | file:line | target | detail | note |
|---|---|---|---|---|
| REAL ERROR | `server/data/lib/ps/config/003-quest.lua:6060` | `London Hamnet` | quest NPC has an XML but is not in map-spawn.xml and no doCreateNpc script names it | quest NPC with QUESTS_CONFIG entry is not on the map; quest unreachable BUG-15 |
| COMMENTED/DISABLED | `server/data/lib/ps/config/003-quest.lua:4955` | `Ray Fitz` | quest NPC has an XML but is not in map-spawn.xml and no doCreateNpc script names it | superseded beginner guide (the Red tutorial replaced him; quest_professorOak.lua:139 hint is commented); the PokeMart 'Ray's order' quest (003-quest.lua:5072) is therefore unreachable |
| COMMENTED/DISABLED | `server/data/lib/ps/config/003-quest.lua:5238` | `Snap` | quest NPC has an XML but is not in map-spawn.xml and no doCreateNpc script names it | Easter event NPC; only placed by the stale -spawn.xml / during the event (no live Easter hook) |
| COMMENTED/DISABLED | `server/data/lib/ps/config/003-quest.lua:5256` | `Easter Rabbit` | quest NPC has an XML but is not in map-spawn.xml and no doCreateNpc script names it | Easter event NPC; only placed by the stale -spawn.xml / during the event (no live Easter hook) |
| COMMENTED/DISABLED | `server/data/lib/ps/config/003-quest.lua:7354` | `Santa Claus` | quest NPC has an XML but is not in map-spawn.xml and no doCreateNpc script names it | Christmas event NPC; all Christmas raids are commented out (raids.xml:14-19) |
| COMMENTED/DISABLED | `server/data/lib/ps/config/003-quest.lua:7572` | `Ed Blackhood` | quest NPC has an XML but is not in map-spawn.xml and no doCreateNpc script names it | Halloween event NPC; the halloween globalevent is in the DISABLED block (globalevents.xml:17-22) |
| COMMENTED/DISABLED | `server/data/lib/ps/config/003-quest.lua:7796` | `Barba Roja` | quest NPC has an XML but is not in map-spawn.xml and no doCreateNpc script names it | Halloween event NPC; the halloween globalevent is in the DISABLED block (globalevents.xml:17-22) |
| COMMENTED/DISABLED | `server/data/lib/ps/config/003-quest.lua:7828` | `Javy Dones` | quest NPC has an XML but is not in map-spawn.xml and no doCreateNpc script names it | Halloween event NPC; the halloween globalevent is in the DISABLED block (globalevents.xml:17-22) |
| COMMENTED/DISABLED | `server/data/lib/ps/config/003-quest.lua:7860` | `Jack Spearow` | quest NPC has an XML but is not in map-spawn.xml and no doCreateNpc script names it | Halloween event NPC; the halloween globalevent is in the DISABLED block (globalevents.xml:17-22) |
| COMMENTED/DISABLED | `server/data/lib/ps/config/003-quest.lua:7890` | `Calico` | quest NPC has an XML but is not in map-spawn.xml and no doCreateNpc script names it | Halloween event NPC; the halloween globalevent is in the DISABLED block (globalevents.xml:17-22) |

#### `raid.monster`

| class | file:line | target | detail | note |
|---|---|---|---|---|
| COMMENTED/DISABLED | `server/data/raids/example.xml:3` | `Rat` (x6) | raid monster not in monsters.xml (raid 'Example', commented in raids.xml) |  |
| COMMENTED/DISABLED | `server/data/raids/example.xml:6` | `Cave Rat` (x2) | raid monster not in monsters.xml (raid 'Example', commented in raids.xml) |  |

#### `sql.table`

| class | file:line | target | detail | note |
|---|---|---|---|---|
| REAL ERROR | `server/src/iologindata.cpp:1243` | `parcels` | query references table `parcels`, which the shipped schemas do not create | every player-to-player parcel logs an SQL error ('PS - Parcel log', IOLoginData::playerMail); the parcel itself is delivered |
| COMMENTED/DISABLED | `server/data/lib/ps/functions/player.lua:745` | `player_first_pokemon` | query references table `player_first_pokemon`, which the shipped schemas do not create |  |
| FALSE POSITIVE | `server/src/databasemanager.cpp:35` | `information_schema` (x4) | schema-migration / engine-metadata query (information_schema), not a runtime table reference |  |
| FALSE POSITIVE | `server/src/databasemanager.cpp:90` | `sqlite_master` (x2) | schema-migration / engine-metadata query (sqlite_master), not a runtime table reference |  |
| FALSE POSITIVE | `server/src/databasemanager.cpp:226` | `bans2` (x5) | schema-migration / engine-metadata query (bans2), not a runtime table reference |  |
| FALSE POSITIVE | `server/src/databasemanager.cpp:359` | `them` | schema-migration / engine-metadata query (them), not a runtime table reference |  |
| FALSE POSITIVE | `server/src/databasemanager.cpp:434` | `global_storage2` | schema-migration / engine-metadata query (global_storage2), not a runtime table reference |  |
| FALSE POSITIVE | `server/src/databasemanager.cpp:437` | `player_storage2` | schema-migration / engine-metadata query (player_storage2), not a runtime table reference |  |
| FALSE POSITIVE | `server/src/databasemanager.cpp:1371` | `table` | schema-migration / engine-metadata query (table), not a runtime table reference |  |

#### `tm.move`

| class | file:line | target | detail | note |
|---|---|---|---|---|
| COMMENTED/DISABLED | `server/data/lib/ps/systems/018-technicalMachine.lua:27` | `Whirlwind` | TMS[...].move is not a MOVES[...] move |  |
| COMMENTED/DISABLED | `server/data/lib/ps/systems/018-technicalMachine.lua:99` | `Pay Day` | TMS[...].move is not a MOVES[...] move |  |

#### `website.url`

| class | file:line | target | detail | note |
|---|---|---|---|---|
| WEBSITE-DEPENDENT | `client/modules/client_entergame/entergame.otui:72` | `http://pokenordic.com/accounts/create` | hard-coded external URL (not verifiable offline) |  |
| WEBSITE-DEPENDENT | `client/modules/client_entergame/entergame.otui:79` | `http://pokenordic.com/accounts/lostAccount` | hard-coded external URL (not verifiable offline) |  |
| WEBSITE-DEPENDENT | `client/modules/client_entergame/newcharacterlist.otui:223` | `http://www.psoul.net/players/createCharacter` | hard-coded external URL (not verifiable offline) |  |
| WEBSITE-DEPENDENT | `client/modules/client_entergame/newcharacterlist.otui:232` | `http://www.psoul.net/accounts/donate` | hard-coded external URL (not verifiable offline) |  |
| WEBSITE-DEPENDENT | `server/config.example.lua:321` | `http://www.psoul.net/` | hard-coded external URL (not verifiable offline) |  |
| WEBSITE-DEPENDENT | `server/data/lib/ps/events/creaturescripts/onJoinChannel.lua:85` | `http://www.pokenordic.com/blogCategories/1-tutorials` | hard-coded external URL (not verifiable offline) |  |
| WEBSITE-DEPENDENT | `server/data/lib/ps/events/globalevents/globalMessages.lua:9` | `http://www.PokeNordic.com/blogCategories/1-tutorials` | hard-coded external URL (not verifiable offline) |  |
| WEBSITE-DEPENDENT | `server/data/lib/ps/events/globalevents/globalMessages.lua:15` | `http://www.PokeNordic.com` | hard-coded external URL (not verifiable offline) |  |
| WEBSITE-DEPENDENT | `server/data/lib/ps/events/globalevents/globalMessages.lua:18` | `http://www.PokeNordic.com/TournamentHistories/view` | hard-coded external URL (not verifiable offline) |  |
| WEBSITE-DEPENDENT | `server/data/lib/ps/events/globalevents/globalMessages.lua:21` | `http://forum.PokeNordic.com/` | hard-coded external URL (not verifiable offline) |  |
| WEBSITE-DEPENDENT | `server/data/lib/ps/events/globalevents/globalMessages.lua:24` | `http://www.PokeNordic.com/accounts/sendFeedback` | hard-coded external URL (not verifiable offline) |  |
| WEBSITE-DEPENDENT | `server/data/talkactions/scripts/shutdown.lua:38` | `http://forum.psoul.net/announcements/` (x3) | hard-coded external URL (not verifiable offline) |  |

#### `xml.itemid.otbonly`

| class | file:line | target | detail | note |
|---|---|---|---|---|
| COMMENTED/DISABLED | `server/data/actions/actions.xml:358` | `10044` | actions itemid only in items.otb (no items.xml entry, engine still knows it): 10044 |  |
| COMMENTED/DISABLED | `server/data/movements/movements.xml:76` | `8714` | movements itemid only in items.otb (no items.xml entry, engine still knows it): 8714 |  |
| FALSE POSITIVE | `server/data/actions/actions.xml:5` | `29562-29783` | actions itemid only in items.otb (no items.xml entry, engine still knows it): 29566;29571;29573-29574;29580;29582;29590;29615;29619;29637;29641;29661;29677;29688-29689;29715;29722;29726;29730-29731;29740-29741;29760;29762;29764-29765;29769-29772;29774-29775;29779-29781 |  |
| FALSE POSITIVE | `server/data/actions/actions.xml:5` | `29784-29858` | actions itemid only in items.otb (no items.xml entry, engine still knows it): 29790;29795;29803;29809;29816-29817;29824;29838;29843-29844;29851;29854 |  |
| FALSE POSITIVE | `server/data/actions/actions.xml:41` | `24216-24218` | actions itemid only in items.otb (no items.xml entry, engine still knows it): 24216-24218 |  |
| FALSE POSITIVE | `server/data/actions/actions.xml:42` | `24112-24113` | actions itemid only in items.otb (no items.xml entry, engine still knows it): 24112-24113 |  |
| FALSE POSITIVE | `server/data/actions/actions.xml:131` | `10044` | actions itemid only in items.otb (no items.xml entry, engine still knows it): 10044 |  |
| FALSE POSITIVE | `server/data/actions/actions.xml:219` | `22811` | actions itemid only in items.otb (no items.xml entry, engine still knows it): 22811 |  |
| FALSE POSITIVE | `server/data/actions/actions.xml:356` | `9973` | actions itemid only in items.otb (no items.xml entry, engine still knows it): 9973 |  |
| FALSE POSITIVE | `server/data/actions/actions.xml:357` | `9974` | actions itemid only in items.otb (no items.xml entry, engine still knows it): 9974 |  |
| FALSE POSITIVE | `server/data/actions/actions.xml:359` | `10045` | actions itemid only in items.otb (no items.xml entry, engine still knows it): 10045 |  |
| FALSE POSITIVE | `server/data/actions/actions.xml:419` | `22833` | actions itemid only in items.otb (no items.xml entry, engine still knows it): 22833 |  |
| FALSE POSITIVE | `server/data/movements/movements.xml:11` | `4608-4666` | movements itemid only in items.otb (no items.xml entry, engine still knows it): 4626-4631 |  |
| FALSE POSITIVE | `server/data/movements/movements.xml:30` | `18647` | movements itemid only in items.otb (no items.xml entry, engine still knows it): 18647 |  |

#### `xml.script`

| class | file:line | target | detail | note |
|---|---|---|---|---|
| COMMENTED/DISABLED | `server/data/actions/actions.xml:33` | `../../lib/ps/events/actions/portrait.lua` | actions <action> script does not exist: server/data/lib/ps/events/actions/portrait.lua |  |
| COMMENTED/DISABLED | `server/data/globalevents/globalevents.xml:15` | `my_script.lua` | globalevents <globalevent> script does not exist: server/data/globalevents/scripts/my_script.lua |  |
| COMMENTED/DISABLED | `server/data/globalevents/globalevents.xml:20` | `../../lib/ps/events/globalevents/globalMessageTeamSpeak.lua` | globalevents <globalevent> script does not exist: server/data/lib/ps/events/globalevents/globalMessageTeamSpeak.lua |  |
| COMMENTED/DISABLED | `server/data/movements/movements.xml:24` | `../../lib/ps/events/movements/underwaterEnterSecure.lua` | movements <movement> script does not exist: server/data/lib/ps/events/movements/underwaterEnterSecure.lua |  |
| COMMENTED/DISABLED | `server/data/movements/movements.xml:25` | `../../lib/ps/events/movements/underwaterLeaveSecure.lua` | movements <movement> script does not exist: server/data/lib/ps/events/movements/underwaterLeaveSecure.lua |  |
| COMMENTED/DISABLED | `server/data/talkactions/talkactions.xml:43` | `../../lib/ps/events/talkactions/tv/banlist.lua` | talkactions <talkaction> script does not exist: server/data/lib/ps/events/talkactions/tv/banlist.lua |  |
| COMMENTED/DISABLED | `server/data/talkactions/talkactions.xml:147` | `position.lua` | talkactions <talkaction> script does not exist: server/data/talkactions/scripts/position.lua |  |
