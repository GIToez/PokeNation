# Developer handbook — PokeNation (PSoul / PokeAimar baseline)

This handbook explains how the project is put together and how to change it without breaking
anything. It is written for someone who can edit files and run scripts but has not worked with
The Forgotten Server (TFS), OTClient, Lua, C++ or MySQL before. Every `file:line` reference was
checked against the source in this repository; when a line number drifts after an edit, search
for the quoted symbol instead.

Read first if you have not yet: `docs/BUILDING.md` §8 (quick start), then this file. Deeper
material: `docs/SOURCE_AUDIT.md` (inventory and protocol), `docs/LOCAL_CLIENT_TESTING.md`
(client), `docs/BUG_TRIAGE.md` (known defects BUG-01…BUG-57), `docs/PHASE_2_TEST_MATRIX.md`
(what was tested and how), `docs/HISTORICAL_CODE_DIFF.md` (backup trees).

Companion documents written in parallel (some may not exist yet when you read this):
[`docs/tutorials/README.md`](tutorials/README.md) (step-by-step recipes) and the reference set
[`COMMANDS`](reference/COMMANDS.md), [`FEATURES`](reference/FEATURES.md),
[`POKEMON`](reference/POKEMON.md), [`MOVES`](reference/MOVES.md),
[`POKEBALLS`](reference/POKEBALLS.md), [`ITEMS`](reference/ITEMS.md),
[`NPCS`](reference/NPCS.md), [`QUESTS`](reference/QUESTS.md),
[`ACHIEVEMENTS`](reference/ACHIEVEMENTS.md), [`OPCODES`](reference/OPCODES.md),
[`DATABASE`](reference/DATABASE.md).

---

## 1. The big picture

```
 ┌───────────────────────┐   login 7564 / game 8548   ┌───────────────────────────┐
 │ client/  (OTClient 0.6│ ◄────────────────────────► │ server/ (TFS 0.3.6 + PSoul)│
 │ fork, C++ + Lua UI)   │   protocol "312" = 8.54    │ C++ engine  server/src     │
 │ client/src-cpp        │   packets + PSoul extras   │ Lua content server/data    │
 │ client/modules (Lua)  │                            │ config      server/config.lua
 │ client/data (sprites) │                            └─────────────┬─────────────┘
 └───────────────────────┘                                          │ SQL (MariaDB 3306)
                                                      ┌─────────────▼─────────────┐
                                                      │ database "psoul"          │
                                                      │ (website that created     │
                                                      │  accounts is NOT shipped) │
                                                      └───────────────────────────┘
```

* The **server** is a C++ program (`build/<platform>-<type>/server/psoul-server`, packaged as `PokeNationServer.exe` on Windows) that hosts the world. Almost all
  gameplay — Pokémon, moves, balls, NPCs, quests — is written in **Lua** under `server/data/`.
  The C++ engine provides creatures, items, the map, networking and the database, and exposes
  ~1000 functions to Lua (`lua_register(...)` calls in `server/src/luascript.cpp`).
* The **client** is a C++ program (`build/<platform>-<type>/client/psoulclient`, packaged as `PokeNationLegacyClient.exe`; frozen, see `LEGACY_CLIENT_REFERENCE.md`) whose user interface is entirely
  Lua + `.otui` layout files under `client/modules/`. Sprites and item graphics are in
  `client/data/things/data.dat` + `data.spr`.
* The **database** keeps accounts, characters, inventories, "storages" (key/value flags) and the
  PSoul extra tables. The PHP website that originally created accounts and characters is not in
  the archive; `server/src/schemas/psoul_dev_seed.sql` is the local substitute.

---

## 2. Which directories are authoritative

### 2.1 Live code and data (edit these)

| Path | What it is |
|------|------------|
| `server/src/` | Engine C++ (TFS 0.3.6 + PSoul systems). Rebuild after changes (`tools/build_server.sh`). |
| `server/src/schemas/` | `mysql.sql` (stock TFS schema), `psoul_extra_mysql.sql` (PSoul tables), `psoul_dev_seed.sql` (dev accounts). |
| `server/config.example.lua` | Tracked template of the server configuration. |
| `server/data/lib/*.lua` | Shared Lua library loaded into every Lua state (§4). |
| `server/data/lib/ps/` | The PSoul framework: `others/`, `config/`, `functions/`, `systems/`, `events/` (§4.3). |
| `server/data/{actions,talkactions,creaturescripts,globalevents,movements,spells,weapons}/` | XML bindings (`<name>.xml`) + stock TFS scripts (`scripts/`) + per-system `lib/`. |
| `server/data/npc/*.xml`, `server/data/npc/scripts/`, `server/data/npc/lib/` | NPC definitions, their Lua dialogue, the shared NPC library (`npcsystem/`, `npc.lua`). |
| `server/data/monster/` | Wild Pokémon and other monsters (`monsters.xml` index + one XML per monster). |
| `server/data/items/items.otb` + `items.xml` | Item types (binary id table + names/attributes). |
| `server/data/world/map.otbm`, `map-spawn.xml`, `map-house.xml` | The live map and its spawn/house files (§3.3). |
| `server/data/XML/` | Groups, vocations, outfits, channels, tournaments, stages, etc. |
| `server/pt_br.loc` | Portuguese translations for `__L(cid, text)` (`docs/TRANSLATION.md`). |
| `client/src-cpp/src/` | Client C++ (the only compiled copy; `client/src-cpp/vc12/client/` is stale). |
| `client/modules/`, `client/init.lua`, `client/data/` | Client Lua UI, entry script, assets. |
| `tools/` | Build/run/check helpers (§9). |

### 2.2 Historical / backup content (do not edit, do not "fix")

None of these is loaded at runtime. They are kept on purpose (`docs/BUG_TRIAGE.md` BUG-39,
`docs/HISTORICAL_CODE_DIFF.md`). If you grep for a Pokémon or move name, exclude them or you
will edit the wrong copy.

| Path | Why it is not loaded |
|------|----------------------|
| `original/` | Untouched archive copy (reference only, see `original/README.md`). |
| `server/data/lib/ps/config/_pokemon/` | 432 files; `config/pokemon.lua:22` only iterates `config/pokemon/`. |
| `server/data/lib/ps/others/pokemon_backup/` | `999-ps.lua:10-12` loads only three named files from `others/`. |
| `server/data/lib/ps/others/moves_disabled/` | Same. |
| `server/data/lib/ps/systems/disabled/` | `999-ps.lua:40` `dodirectory(systems/)` is not recursive (§4.2). Its `005-task.lua:1` prints a canary "OLD TASK SYSTEM" if it is ever loaded. |
| `server/data/lib/disabled/` | `003-event.lua`, `034-exhaustion.lua`; sub-directory of `data/lib/`, skipped by the non-recursive loader. |
| `server/data/lib/ps/tools/` | `balanceCalculator.lua`, `catchTest.lua`, `generateLoot.lua` — developer scripts, never loaded. |
| `server/data/lib/ps/config/003-quest.lua.bak`, `server/data/npc/Easter Rabbit.xml.bak` | Wrong extension; nothing loads `.bak`. |
| `server/data/npc/backup/` | 12 old NPC XMLs; not placed on the map. |
| `server/data/world/-spawn.xml`, `-house.xml` | Older spawn/house files. The map header names `map-spawn.xml` / `map-house.xml` (read in `server/src/iomap.cpp:188-205`). Some NPCs exist only in `-spawn.xml` (BUG-15). |
| `client/src-cpp/vc12/client/` | Stale copy of the client source; the VS project compiles `../src`. |

### 2.3 Generated or local-only (never commit)

From `.gitignore`:

| Path | Produced by |
|------|-------------|
| `build/<platform>-<type>/{server,client}/` | `tools/build_server.sh`, `tools/build_client.sh` (compiler output only; the server is still *run* with `server/` as CWD by `tools/start_server.sh`) |
| `/dist/` (`dist/<platform>/{server,client}/`, archives, `.sha256`) | `tools/package.sh` (see `BUILDING.md` §9) |
| `server/config.lua` | `tools/setup_database.sh` (copy of `config.example.lua` + your DB password). **Contains a secret.** |
| `server/logs/`, `*.log` | server runtime |
| `server/data/npc/tmpCitizen_*.xml` | rewritten at every start by `lib/ps/systems/027-citizens.lua:11,64-65` |
| `__pycache__/` | Python tools |

Git LFS holds the large binaries (`.gitattributes`): `*.otbm` (the 130 MB map), `*.spr` (the
308 MB client sprite file) and `*.psd`. Run `git lfs install && git lfs pull` after cloning, or
the server stops with "map.otbm is an LFS pointer".

---

## 3. Server startup flow

The server must be started from `server/` (`tools/start_server.sh` does this) because
`config.lua`, `data/` and `pt_br.loc` are resolved relative to the working directory.

### 3.1 Sequence in `server/src/otserv.cpp`

`main` (`otserv.cpp:271`) queues `otserv()` (`:404`) on the dispatcher thread
(`:330-334`), waits for it, then runs the network service (`:378-385`). `otserv()` does:

| Step | Code | Console line |
|------|------|--------------|
| Read `config.lua` | `otserv.cpp:487-492` | `>> Loading config (config.lua)` |
| Password hashing mode | `:545-560` | `> Using SHA256 encryption` |
| RSA key (hard-coded OTServ key) | `:643-651` | `>> Loading RSA key` |
| Connect to MySQL, run the schema upgrader | `:653-683` | `>> Starting SQL connection`, `>> Running Database Manager` |
| `items.otb`, then `items.xml` | `:685-702` | `>> Loading items` |
| Groups, vocations, polls, localization | `:704-728` | `>> Loading groups` … `>> Loading localization` |
| **All Lua script systems** (`ScriptingManager::load`, §4) | `:730-735` | `>> Loading script systems` |
| Chat channels, outfits, experience stages | `:737-756` | |
| Monsters (`data/monster/monsters.xml`) | `:758-772` | `>> Loading monsters` |
| Tournaments (`data/XML/tournaments.xml`) | `:774-780` | `>> Loading tournaments`, then the benign `Tournament 2/3 not found` warnings (BUG-20) |
| Mods | `:784-789` | commented out — this build has **no mods** |
| Map + spawn/house files | `:791-796` | `>> Loading map and spawns...`, `> Map size: 5879x3541.` |
| World type | `:820-841` | `>> Checking world type... PvP` (with the shipped `worldType = "pvp"`) |
| Game state INIT (below) | `:843-846` | `>> Initializing game state modules and registering services...` |
| Listeners (login + game; status protocol commented out at `:877`) | `:848-897` | `> Global address: 127.0.0.1`, `> Local ports: 7564 8548` |
| Game state NORMAL, game loop | `:898-904` | `>> All modules were loaded, server is starting up...` |
| Network loop | `:378-385` | `>> Cristal server Online!` (`serverName = "Cristal"`, `config.example.lua:107`) |

`setGameState(GAME_STATE_INIT)` (`server/src/game.cpp:188-196`) starts the spawns, loads raids
and quests, restores the saved game state, and then runs every `type="start"` globalevent
(`g_globalEvents->startup()`, `game.cpp:196`).

### 3.2 What `start.lua` does

`data/globalevents/globalevents.xml:3` binds `globalevents/scripts/start.lua`. Its
`onStartup` (`start.lua:251-268`) runs a list of steps and prints each `msg`:

| Step | Lines | Effect |
|------|-------|--------|
| Cleaning players online status | `start.lua:2-8` | `UPDATE players SET online = 0` (the engine does not do it, see SOURCE_AUDIT §7) |
| Loading PvP Arenas | `:10-13` | `startPvpArenas` (`systems/009-pvpArena.lua`) |
| Caught / Tournament highscores | `:15-23` | rebuild highscore boards |
| Loading Berry Trees | `:25-28` | `startBerryTrees` (`systems/015-berry.lua`, table `berry_trees`) |
| Cleaning Mastery Dungeons | `:30-38` | resets global storages per dungeon |
| Loading Bosses | `:40-43` | `doBossStart` — prints `>> Scheduled Boss Spawn: …` |
| Loading Highscores | `:45-48` | highscore text boards |
| (quest world objects, no message) | `:50-163` | random quest items, a delayed **Crystal Onix** NPC, 5 of 10 Mt. Moon NPCs, the Aerodactyl whirlpool loop (`addEvent` every 3 h), the **PokeTrader** NPC "Tiger Kelsey" at a random city (`:143-156`), Elite Four reset, Anniversary reset (`:159`), `GLOBAL_STORAGES.SERVER_START_TIME` |
| Loading Ball Pillars | `:165-227` | re-creates decorative Pokémon NPCs from table `ball_pillars` |
| Loading Citizens | `:229-232` | `doStartCitizens` — writes `npc/tmpCitizen_*.xml` and spawns them |
| Loading SupriseBox | `:234-237` | `SurpriseBox.onGameStart` |
| Loading Ranks | `:239-249` | calls the missing `update_rank()` procedure only when `updateHighscores = true` (it is `false`, `config.example.lua:340`; BUG-25) |

Every timed globalevent in `globalevents.xml` uses `interval` in **seconds** (compared with
`time()` in `server/src/globalevent.cpp:126-141`): tutorial Rattata 15 s, Eevee respawn
10800 s, Sudowoodo 3600 s, global messages 2700 s, Anniversary 3600 s (BUG-14). `clean`,
`save`, TeamSpeak and Halloween are commented out (`globalevents.xml:17-22`).

### 3.3 Map, spawns and houses

`mapName = "map"` (`config.example.lua:167`) loads `data/world/map.otbm`. The spawn and house
file names are stored *inside* the OTBM header (`iomap.cpp:188-205`) and point at
`map-spawn.xml` and `map-house.xml`. NPCs and wild Pokémon are placed by `map-spawn.xml`; an NPC
XML that is not referenced there never appears (e.g. `Soya.xml`, BUG-38). Edit the map and spawns
with Remere's Map Editor (`tools/rme/`) using the item profile that matches `items.otb`.

---

## 4. Lua: states, load order and XML bindings

### 4.1 One Lua state per script system

This is the single most important thing to understand before editing Lua: **every script
system has its own, separate Lua interpreter.** Each one is a `LuaScriptInterface` created in
its constructor: weapons, spells, actions, talkactions, movements, creaturescripts,
globalevents (`server/src/scriptmanager.cpp:57-108`, e.g. `actions.cpp:48-50`), raids
(`raids.cpp:957`) and one shared NPC interface (`npc.cpp:2487-2490`, created on the first NPC
load at `npc.cpp:106-110`).

Each state runs `LuaScriptInterface::initState` (`luascript.cpp:836-851`), which loads the whole
`data/lib/` directory — so the entire PSoul framework is loaded **nine or more times** at
startup, once per state. Consequences:

* A Lua global set in one system is invisible in the others. `ONLINE_TUTORS` in
  `creaturescripts/scripts/login.lua:26` exists only in the creaturescripts state; a table
  filled by a talkaction is not seen by an action script.
* State that must be shared lives in the engine: **player storages** (persisted in
  `player_storage`), **creature storages** on summons, **global storages** (one map shared by all
  states, saved to `global_storage`, `luascript.cpp:137-160`), item attributes, and the database.
* A library error is printed once per state, so one typo can produce the same message nine times.

### 4.2 How `data/lib/` is loaded

`LuaScriptInterface::loadDirectory` (`luascript.cpp:721-740`):

1. lists the directory **non-recursively** and keeps only regular files ending in `.lua`
   (`:724-730`) — sub-directories are skipped, which is why `lib/disabled/`, `lib/ps/`,
   `systems/disabled/` are not picked up automatically;
2. sorts the names with `std::sort` (`:732`), i.e. plain byte order: digits before letters,
   upper-case before lower-case — hence the numeric prefixes;
3. loads them one by one and **stops at the first file that fails** (`:733-737`). A syntax or
   runtime error in `systems/010-pokedex.lua` therefore also silently skips `011-…` to `055-…`
   in that state.

`initState` calls it on `data/lib/` (`luascript.cpp:844`), giving this order:
`000-constant.lua`, `001-class.lua`, `002-wait.lua`, `004-database.lua`, `011-string.lua`,
`012-table.lua`, `032-position.lua`, `033-ip.lua`, `050-function.lua`, `051-accountStorage.lua`,
`100-compat.lua` (old function names such as `getPlayerStorageValue = getCreatureStorage`,
`100-compat.lua:128-131`), and finally **`999-ps.lua`**.

The same function is exposed to Lua as `dodirectory(path)` (`luascript.cpp:2845`, `:11565`);
PSoul uses it for its own sub-directories.

### 4.3 What `999-ps.lua` loads, in order

`server/data/lib/999-ps.lua` (whole file, 48 lines) uses the stock Lua `dofile` (raises an error
on failure) and `dodirectory`:

| Order | Line | Loaded |
|-------|------|--------|
| 1 | `:2-7` | path constants `PS_LIB_DIR` … (`PS_LIB_SKILLS_DIR` points at a non-existent dir, BUG-38) |
| 2 | `:10-12` | `others/constants.lua`, `others/logger.lua`, `others/outfits.lua` |
| 3 | `:15-25` | `config/itemsAttributes.lua`, `playersStorages.lua`, `accountStorages.lua`, `balls.lua`, `pokemonsNumbers.lua`, `pokemonsNames.lua`, **`pokemon.lua`** (which runs `dodirectory("config/pokemon/")`, `config/pokemon.lua:22`, and then clones every species into a "Shiny …" entry, `:25-54`), `pokemonsStorages.lua`, `storages.lua`, **`skill.lua`** (runs `dodirectory("config/moves/")`, `config/skill.lua:52`), `globalStorages.lua` |
| 4 | `:29-37` | `functions/ball/{charged,discharged,empty,inUse}.lua`, `functions/player.lua`, `pokemon.lua`, `abilities.lua`, `others.lua` |
| 5 | `:40` | `dodirectory("systems/")` → `001-npcBattle.lua` … `055-julyVacationEvent.lua` in name order. Three systems load their own config: `002-quest.lua:82` → `config/003-quest.lua`, `029-rangerClub.lua:8` → `config/001-rangerClub.lua`, `031-wikiChat.lua:250` → `config/002-wikiChat.lua` |
| 6 | `:43-48` | seeds the RNG and calls `doUpdatePokemonEggMovesList()` (needs everything above) |

Load-order rules that follow from this:

* A `systems/` file may use anything from `others/`, `config/` and `functions/`, and anything
  from a *lower-numbered* system at load time. At *run time* (inside a function body) every
  global is available.
* New system file → pick the next free number (`056-…`); a new species → a new file in
  `config/pokemon/`; a new move → a new file in `config/moves/`. No loader edit is needed.
* `lib/ps/events/` is **not** loaded by `999-ps.lua`. Those files are event scripts, bound by
  XML (next section).

### 4.4 How scripts are bound to the game (XML)

At load, each system first loads its own `data/<system>/lib/` (`server/src/baseevents.cpp:32`;
e.g. `actions/lib/actions.lua`), then parses `data/<system>/<system>.xml` (`:35`). A
`value="file.lua"` or `script="file.lua"` is resolved relative to `data/<system>/scripts/`
(`baseevents.cpp:51`, `:89`, `:112`). That is why PSoul bindings look like
`value="../../lib/ps/events/actions/…"`: they climb back out to `data/` and into
`lib/ps/events/`.

| System | XML | Key attribute(s) | Callback in the Lua file | PSoul example |
|--------|-----|------------------|--------------------------|---------------|
| actions (use an item) | `actions/actions.xml` | `itemid`, `actionid`, `uniqueid` (lists `a;b;c`, ranges `a-b`) | `onUse(cid, item, fromPosition, itemEx, toPosition)` | balls: `actions.xml:90` empty → `balls/empty.lua` (catch), `:91` charged → `charged.lua` (summon), `:92` discharged, `:93` in use → `inUse.lua` (return); evolve icon `:34` |
| talkactions (chat commands) | `talkactions/talkactions.xml` | `words`, `access` (group access level), `hidden` | `onSay(cid, words, param, channel)` | moves `m1…m16`/`s1…s16` `:26` → `events/talkactions/skill.lua`; `/autoloot` `:11`; GM `/i` `:76`, `/m` `:64`, `/mypokemon` `:61`, `/reload` `:65` |
| creaturescripts (creature events) | `creaturescripts/creaturescripts.xml` | `type` (login, logout, death, kill, think, …), `name` | `onLogin(cid)`, `onDeath(…)`, … | `PlayerLogin` `:66` → `scripts/login.lua`, which registers the other named events on the player (`login.lua:18-32`); most PS events live in `lib/ps/events/creaturescripts/` |
| globalevents (timers) | `globalevents/globalevents.xml` | `type="start"`/`"record"`, `interval` (s), `time="HH:MM"` | `onStartup()`, `onThink(interval)`, `onTime()` | §3.2 |
| movements (step/equip) | `movements/movements.xml` | `type` StepIn/StepOut/Equip/DeEquip/AddItem, `itemid`, `actionid`, `slot` | `onStepIn(…)`, `onEquip(…)` | ball equip in slot 8 (`slot="feet"`) `movements.xml:5-6` → `events/movements/ball.lua` |
| spells (moves) | `spells/spells.xml` | `<instant name=… words=… enabled="0" script=…>` | `onCastSpell(cid, var)` | 483 move scripts, e.g. `spells.xml:33` `script_Ember` → `events/spells/scripts/Ember.lua`. `enabled="0"` is normal: players never cast them by words; Lua calls `doCreatureCastSpell(pokemon, "script_" .. name)` (`systems/003-skill.lua:11`) |
| NPCs | `npc/<Name>.xml` | `<npc name=… script=…>` | `onCreatureSay`, `onThink`, … via `npc/lib/npcsystem` | `Professor Oak.xml:2` → `npc/scripts/quest_professorOak.lua` (bare names resolve to `npc/scripts/`, `npc.cpp:387-388`). The NPC library is `npc/lib/npc.lua` (`npc.cpp:109`) |
| monsters | `monster/monsters.xml` | `name`, `file` | XML only (attacks reference spells by name) | `monsters.xml:9` Charmander → `Pokemons/charmander.xml` |

Duplicate bindings are reported at startup, e.g. `[Warning - Actions::registerEvent] Duplicate
registered item id: …` (`actions.cpp:108-252`), `[Warning - TalkAction::configureEvent]
Duplicate registered talkaction with words: …` (`talkaction.cpp:101`),
`[Warning - MoveEvents::addEvent] Duplicate move event found: …` (`movement.cpp:304`).

### 4.5 Core PSoul call chains (for orientation)

| Flow | Chain |
|------|-------|
| Summon | `actions.xml:91` → `events/actions/balls/charged.lua` → `doPokemonCall` (`functions/others.lua:699`) |
| Move | talkaction `m1` → `events/talkactions/skill.lua` → `doPokemonUseSkill` (`systems/003-skill.lua`) → `doCreatureCastSpell` → `spells.xml` → `events/spells/scripts/<Move>.lua` → `doSkillDamage` (`systems/004-skillDamage.lua:335`, type chart at the top of that file `:1+`) |
| Catch | `actions.xml:90` → `balls/empty.lua` → `functions/ball/empty.lua` (`getCatchChance` `:52`) |
| Pokémon experience | `doPlayerPokemonAddExperience` (`functions/player.lua:414`) |
| Move bar | `doPlayerSendPokemonSkillWindowData` (`functions/player.lua:369-403`) builds the icon list and calls `doPlayerSendPokemonSkills` |
| Starting kit | `doPlayerAddMainItems` (`functions/player.lua:717`) |

---

## 5. Client startup flow

`client/init.lua` is the first script the client executes (working directory = `client/`,
`tools/start_client.sh` sets it):

| Line | Step |
|------|------|
| `init.lua:5-9` | user write dir and log: `~/.psoul/` + `~/psoul.log` (Linux) / `%USERPROFILE%\psoul\` + `%USERPROFILE%\psoul.log` (Windows) |
| `:15-22` | add `client/data` and `client/modules` to the virtual file system |
| `:28` | load `/config.otml` (saved settings) |
| `:30` | discover every `*.otmod` |
| `:33-35` | autoload priority 0–99, then **force** `corelib` and `gamelib` (`gamelib` depends on `game_things`, which loads `data.dat`/`data.spr`, `game_things/things.lua:24-25`) |
| `:38-39` | priority 100–499, then force `client` — its `load-later` list (`client/client.otmod`) loads `client_styles`, `client_locales`, `client_topmenu`, `client_background`, `client_options`, `client_entergame` |
| `:42-43` | priority 500–999, then force `game_interface` — its `load-later` list (`game_interface/interface.otmod`) loads 36 `game_*` modules (move bar, Pokémon bar, Pokédex, …) |
| `:46` | priority 1000–9999 |

In this fork only **one** module declares `autoload: true`: `game_guide` (priority 1001,
`game_guide/guide.otmod`). Everything else is loaded because it is listed in a `load-later`
block. Hence: **a new module will not load until you add it to a `load-later` list** (normally
`game_interface/interface.otmod`) or give it `autoload: true` + `autoload-priority`. Present but
not loaded today: `game_environment`, `client_serverlist`, `game_shop`. The startup log counts
48 loaded modules (`docs/BUILDING.md` §8.5).

Login path:

1. `client_entergame/entergame.lua` `EnterGame.doLogin()` (`:188`) hard-codes
   `G.host = '127.0.0.1'` (`:191`), `G.port = 7564` (`:192`) and `protocolVersion = 854`
   (`:193`, chooses the 8.54 packet layout; not sent on the wire), then
   `ProtocolLogin.create()` / `protocolLogin:login(...)` (`:206`, `:226`).
2. `gamelib/protocollogin.lua:36-39` writes OS id, **version `312`** and the PSoul **language
   byte** (BUG-09).
3. The character list (`entergame.lua:36-47` → `characterlist.lua:184`) shows the PSoul extras;
   choosing a character calls `g_game.loginWorld(... charInfo.worldHost, charInfo.worldPort ...)`
   (`characterlist.lua:31`). Host/port come from the server's character list, i.e. `ip` and
   `gamePort` in `server/config.lua`.
4. The C++ game login sends version 312 again (`client/src-cpp/src/client/protocolgamesend.cpp:57`).
5. `game_interface/gameinterface.lua:27-28` reacts to `onGameStart` and shows the game screen.

To point the client at another server change `entergame.lua:191-192` (Lua only, no rebuild);
see `docs/LOCAL_CLIENT_TESTING.md` §1.2.

---

## 6. Server ↔ client protocol

Full byte layouts: `docs/SOURCE_AUDIT.md` §2 and [`docs/reference/OPCODES.md`](reference/OPCODES.md).

| Item | Value | Where |
|------|-------|-------|
| Ports | login `7564`, game `8548` | `config.example.lua:95-96` (`loginPort`, `gamePort`) |
| Advertised IP | `127.0.0.1` | `config.example.lua:93` (`ip`) |
| Version | `312` on both sides (an invented id carried on 8.54-shaped packets) | server `server/src/resources.h:79-80`; client `protocollogin.lua:38`, `protocolgamesend.cpp:57` |
| OTClient detection | OS id `0x0A–0x0C` | most PSoul extras are only sent when `player->isUsingOtclient()` |
| PSoul extras | language byte at login, character-list extras + poll byte, `U16` light hour, 4 extra creature bytes, `U16` magic effects, `U16` channel count | `SOURCE_AUDIT.md` §2.2–2.4 |

If you change any packet, you must change **both** `server/src/protocol*.cpp` and
`client/src-cpp/src/client/protocolgame*.cpp` (or the client Lua) in the same commit, and
re-run the probe (§9.3), which encodes the expected layout.

### 6.1 The `0xFF` PSoul opcode family (server → client)

Architecture, using the move bar as the example:

1. **Lua** calls a registered engine function, e.g. `doPlayerSendPokemonSkills(cid, iconId,
   {icons})` (`functions/player.lua:402`).
2. **luascript.cpp** binds it: `lua_register(…"doPlayerSendPokemonSkills"…)`
   (`luascript.cpp:1615`) → `luaDoPlayerSendPokemonSkills` (`:3661-3688`) pops the arguments and
   calls `Player::sendPokemonSkills` (`player.h:533-534`).
3. **protocolgame.cpp** writes the packet: `ProtocolGame::sendPokemonSkills`
   (`protocolgame.cpp:3053-3074`) emits `0xFF 0x01 U16 icon U8 n n×U16`.
4. **Client C++** dispatches it: `protocolgameparse.cpp:62-…` (`case Proto::GameServerPSoul`,
   enum in `protocolcodes.h:151-181`) → `parseMoveBarUpdate` (`protocolgameparse.cpp:1810-1821`)
   → `g_lua.callGlobalField("g_game", "onPokemonMoves", …)`.
5. **Client Lua** handles it: `game_pokemoves/pokemoves.lua:191` `onPokemonMoves`, connected to
   `g_game` at `:249`.

Lua bindings for the family (all in `luascript.cpp`): `doPlayerSendPokemonSkills`,
`…SkillContainerClose/Open`, `…PokemonWindowAddPokemonIcon/RemovePokemonIcon/UpdatePokemonIcon/Open/Close`,
`…PokemonSkillCooldown`, `…PokedexStatus/Open/ItemUpdate` (`:1615-1648`), `doPlayerSendTmWindow`
(`:2650`), `doPlayerSendPokemonStatusAdd/Remove/Clear` (`:2671-2677`), `doPlayerSendPokedexInfo`
(`:2764`), `doSendCreatureJump`, `doSendCreatureEffect` (`:2773-2776`),
`doPlayerSendDollCaseStatus/Update`, `doPlayerSendSlotMachine`, `doPlayerSendTip`,
`doPlayerSendPokemonLevelUp` (`:2800-2818`). The poll window (`0x18`) and loot list (`0x1A`) are
sent from C++ only. Senders: `protocolgame.cpp:3053-3370` and `:4776-4939`.

To add a new sub-opcode you touch five places: a `ProtocolGame::send…` + `Player::send…`
wrapper, a `luaDo…` function + `lua_register`, the client enum in `protocolcodes.h`, a `case` +
`parse…` in `protocolgameparse.cpp`, and a Lua handler in a module. The C++ sides are compiled,
so both binaries must be rebuilt.

### 6.2 Extended opcode `0x32` (string messages, no C++ change needed on the client)

* Server → client from Lua: `doSendPlayerExtendedOpcode(cid, id, "text")`
  (`luascript.cpp:2761`, `:13641-13654`) → `ProtocolGame::sendExtendedOpcode`
  (`protocolgame.cpp:1834-1848`, OTClient players only) → `0x32 U8 id string`.
* Client parsing: `protocolgameparse.cpp:464-465` → `parseExtendedOpcode` (`:1782-1792`; ids 0
  and 2 are handled in C++) → Lua `ProtocolGame.registerExtendedOpcode(id, fn)`
  (`client/modules/gamelib/protocolgame.lua:33-46`); example `game_guide/guide.lua:43-44`.
* Ids: `EXTENDED_IDS` (`server/data/lib/ps/others/constants.lua:33-45`) and `ExtendedIds`
  (`client/modules/gamelib/const.lua:241-253`) must stay identical. Today the server only sends
  8/9 (gameplay tutorial, `lib/ps/events/movements/activationTile.lua` and others).
* Client → server: `g_game.getProtocolGame():sendExtendedOpcode(id, buffer)`
  (`client_options/options.lua:97`). The server handles only id 10 (dash walking) in C++
  (`server/src/game.cpp:7714-7731`). The engine registers a creature event named
  `"ExtendedOpcode"` for OTClient players (`protocolgame.cpp:302-304`), but
  `creaturescripts.xml` defines no `type="extendedopcode"` event, so there is no Lua handler
  yet (BUG-38). To add one, define the event in `creaturescripts.xml` with that name.

---

## 7. Assets: server ids, client ids, looktypes

### 7.1 Server id vs client id

An item has **two** numbers:

* the **server id** — used everywhere on the server: `items.xml`, `actions.xml`, Lua
  (`doPlayerAddItem(cid, 13204)`), the database (`player_items.itemtype`), the map;
* the **client id** — the index of the graphic in the client's `data.dat`/`data.spr`.

`server/data/items/items.otb` is the translation table between them. The engine converts
automatically whenever it sends a normal item: `NetworkMessage::AddItem`/`AddItemId` write
`Item::items[id].clientId` (`server/src/networkmessage.cpp:97-130`).

Example, decoded from `items.otb`: the **evolve icon** is server id `13204`
(`items.xml:19288`, `actions.xml:34`, `functions/player.lua:17`) and client id `11595`; the
client's right-click "Evolve" uses the client id: `g_game.useInventoryItem(11595)`
(`client/modules/game_interface/gameinterface.lua:586`). Other pairs: order icon
13206→11597, Poké Ball empty/in use/charged/discharged 12157–12160 → 11118–11121, Pokédex
12281→11242, pokebag 12282→11243.

**The `0xFF` packets are not converted.** Whatever number Lua passes is sent raw, so PSoul data
files keep both ids side by side:

| Field | Kind | Example (Charmander, Ember) |
|-------|------|-----------------------------|
| `POKEMON[…].portrait` | server id (item created in slot 7) | `12705` (`config/pokemon/charmander.lua:10`) |
| `POKEMON[…].fastcallPortrait` | **client** id of the same picture, sent in the Pokémon bar / move bar | `10638` (`:12`) = client id of server item 12705 |
| `MOVES[…].iconId` | server id | `13340` (`config/moves/ember.lua:5`) |
| `MOVES[…].clientIconId` | **client** id, sent in `0xFF 0x01` | `11714` (`:4`) = client id of 13340 |

If you pass a server id where a client id is expected, the client shows an unrelated sprite.

Adding a brand-new item needs a new entry in `items.otb` (binary; edit with an OTB editor or
RME's tooling), its graphic in `data.dat`/`data.spr` (an object builder), and an `items.xml`
entry. `items.xml` alone is not enough. The highest server id in use is 30135.

### 7.2 Outfits and looktypes

A **looktype** is the client outfit id (also from `data.dat`). Wild Pokémon set it in their
monster XML (`monster/Pokemons/charmander.xml:4` `<look type="355" … corpse="11392"/>`); player
outfits are in `data/XML/outfits.xml` (e.g. Trainer 611/612); ride/fly/surf outfits are condition
objects in `lib/ps/others/outfits.lua`. Corpse ids in monster XML are server ids.

### 7.3 Large assets

`client/data/things/data.spr` (308 MB) and `server/data/world/map.otbm` (130 MB) are Git LFS
objects. When you change them, commit through LFS (`git lfs status`) and mention it in the
commit message; see `docs/LARGE_FILES.md`.

---

## 8. Database

### 8.1 Relationships

```
accounts (id, name, password SHA-256, premdays, lang_id, soulcoins, …)
  └─ players (account_id → accounts.id, world_id must be 1, group_id, posx/posy/posz, …)
       ├─ player_items      (player_id, sid, pid, itemtype, count, attributes BLOB)  inventory
       ├─ player_depotitems (same columns)                                            depot
       ├─ player_storage    (player_id, key INT UNSIGNED, value VARCHAR)              storages
       ├─ player_skills, player_viplist, player_deaths, …                             stock TFS
       └─ PSoul: player_pokemon (char-list team), player_achievements,
          player_highscores, player_statistics, player_stored_items, ball_counter, …
global_storage (key, world_id, value)            shared world flags
account_storage                                  per-account flags (lib/051-accountStorage.lua)
```

Stock tables: `server/src/schemas/mysql.sql` (`accounts` `:35`, `players` `:52`,
`player_depotitems` `:133`, `player_items` `:145`, `player_storage` `:185`, `global_storage`
`:357`). PSoul tables: `psoul_extra_mysql.sql` (every block cites the code that uses it). All
child tables use `ON DELETE CASCADE` on `players.id`.

The engine reads and writes the inventory in `server/src/iologindata.cpp` (load `player_items`
`:647`, depot `:676`, storages `:722`; save `:945-999`). `pid` is the parent slot/container and
`sid` a running id, so containers are reconstructed from `pid`/`sid`.

### 8.2 Pokémon are item attributes on the ball

There is **no Pokémon table**. An owned Pokémon is a ball item whose custom attributes hold
everything (name, level, experience, HP, energy, status, nickname, sex, boost, TMs, vitamins,
held item, addons …). The attribute keys are numbers 10002–10073 defined in
`server/data/lib/ps/config/balls.lua:1-74` (`ballsAttributes`, `base = 10000`); other item
attributes are in `config/itemsAttributes.lua`.

* Lua reads/writes them with `getItemAttribute(uid, key)` / `doItemSetAttribute(uid, key, value)`
  (`luascript.cpp:2338-2344`; the key is converted to a string, `:10900-10929`). Wrappers in
  `balls.lua`: `getBallPokemonName` (`:1696-1697`), `getBallPokemonLevel` (`:1704`), the setters
  around `:1837`, and the constructor `doCreatePokemonBall` (`:2088`).
* On save the whole attribute map is serialized (`ItemAttributes::serializeMap`,
  `server/src/itemattributes.cpp:301-315`) into the **`attributes` BLOB** of `player_items`,
  `player_depotitems` or (in houses) `tile_items`. Some PSoul tables copy the blob explicitly with
  `getItemAttributesBlob` / `doItemLoadAttributes` (`ball_pillars` in `start.lua:177`, the
  daycare and Pokémon-market NPCs).
* Because the species is stored **by name** (`pokemonName = base + 2`), renaming a key in
  `POKEMON[...]` orphans every existing ball of that species. Never renumber an existing
  `ballsAttributes` entry; add new ones at the end (`base + 74`, …). Note the comment at
  `balls.lua:35-40`: the authors once moved keys on purpose to reset all transformations.
* You cannot read the blob with plain SQL. Inspect a Pokémon in game (`/held`, `/exp`, look at
  the ball) or through Lua.

`player_pokemon` is only the team preview for the character list: written at logout
(`lib/ps/events/creaturescripts/onLogout.lua:95`), read by the login server
(`iologindata.cpp:1867`).

### 8.3 The missing website

The original site created accounts, characters (with the starting items), Soul Coins, premium
days, coupons and polls (`docs/PHASE_2_REPORT.md` §6). With `accountManager = false`
(`config.example.lua:4`) the game itself cannot create accounts. Create them with SQL following
`psoul_dev_seed.sql` (an account row, a `players` row in `world_id 1`, and the starter
`player_items`); passwords are `SHA2('…', 256)` because `encryptionType = "sha256"`
(`config.example.lua:128`).

---

## 9. Testing workflow

### 9.1 Static checks (no server needed)

```bash
tools/check_syntax.sh                       # luac5.1 -p on every .lua, xmllint on every .xml under server/data
tools/check_syntax.sh server/data/lib/ps    # only a sub-tree
python3 tools/check_references.py           # cross-reference checker: XML → script files, NPC/monster names, client paths, ids
python3 tools/check_references.py --strict  # exit 1 on a real error that is not allowlisted (use before committing)
```

`check_references.py` (stdlib only, never modifies the tree) resolves file paths, names and ids
the way the engines do and lists references that do not resolve; `--all`, `--markdown` and
`--json` change the output. Its rules are explained in its header and in
`docs/BROKEN_REFERENCES.md` (written alongside it).

`check_syntax.sh` only proves the files parse. It does not catch an undefined global, a wrong
item id or a misspelled `TM_IDS.X` (which silently evaluates to `nil`,
`docs/HISTORICAL_CODE_DIFF.md` Tree 1).

### 9.2 Start the stack

```bash
tools/start_database.sh        # wait for "Database is up"
tools/start_server.sh          # wait for ">> Cristal server Online!" (~15 s)
tools/start_client.sh          # GUI (needs DISPLAY)
```

After every start, scan the console for new `[Error - …]` / `[Warning - …]` lines. The known
benign ones are the two tournament messages (BUG-20). Lua errors from your change appear as
`[Error - LuaScriptInterface::loadFile]` (syntax) or `[Error - … Interface]` with a stack trace.
Every line of a clean start is explained in `docs/STARTUP_AUDIT.md`.

Gameplay regression check (the same one CI runs on Linux and Windows) on a fresh seed database:

```bash
tools/init_dev_database.sh --reset && tools/start_server.sh   # in one terminal
python3 tools/smoke_test.py                                   # in another: 12 checks, exit 0 = all pass
```

It covers the logins, entering the game, Oak's starter, summon, a move, a wild battle, a catch
attempt, return and logout. Re-run `--reset` before each run, because it plays Trainer's
new-player path.

### 9.3 Scripted checks with the protocol probe

`tools/protocol_probe.py` speaks the real protocol (`docs/BUILDING.md` §6; `--help` lists every
action):

```bash
python3 tools/protocol_probe.py login --account admin --password admin
python3 -u tools/protocol_probe.py enter --account admin --password admin --character "GM Admin" \
  --open 10 --move-to-bag 8 --say "/mypokemon Charizard,50" --move-to-slot 12159:8 --use-slot 8 \
  --say "/m Rattata" --attack "Rattata [" --wait-dead "Rattata [:60" --catch 12157 \
  --wait-text "(Gotcha|ball broke):15"
```

### 9.4 Which character to use

| Character (account / password) | Use for |
|--------------------------------|---------|
| **GM Admin** (`admin`/`admin`, group 6) | GM commands (`/i`, `/m`, `/mypokemon`, `/goto`, `/reload`). **Its Pokémon cannot use moves**: groups 4–6 have `PlayerFlag_HasInfiniteMana` (bit 10, `server/src/const.h:496`; flags in `data/XML/groups.xml:6-8`) and PSoul uses mana as Pokémon energy (BUG-05). |
| **Tester** (`admin`/`admin`, group 1) | Moves, battles, anything a normal player does. |
| **Trainer** (`player`/`player`, group 1) | New-player path (Professor Oak starter) and the GUI client. |

`replaceKickOnLogin = true` (`config.example.lua:110`): logging in on an account that is
already online kicks the earlier session. Run the probe on `admin` and the GUI on `player`.

### 9.5 Minimum test after a change

1. `tools/check_syntax.sh` passes and `python3 tools/check_references.py` reports no new error.
2. Server starts with no new error lines and reaches `Online!`.
3. The feature works as Tester/Trainer (probe or GUI), and one unrelated core flow still works
   (summon → attack → catch, `docs/PHASE_2_TEST_MATRIX.md` P2-04/P2-05/P2-09).
4. Log out and back in — this is when inventory and storages are saved and reloaded.

---

## 10. Validating and rolling back

### 10.1 Code

All code and content is in Git; nothing is generated into tracked files at runtime except the
git-ignored `tmpCitizen_*.xml`.

```bash
git status && git diff                         # see exactly what changed
git restore server/data/lib/ps/systems/003-skill.lua   # throw away an uncommitted edit
git revert <commit>                            # undo a pushed commit safely
```

Do not edit `original/` or the historical trees of §2.2 to "try something".

### 10.2 Database

The server writes a player only on logout, on `/save` (`talkactions.xml:97`) and at shutdown —
the periodic `save` globalevent is disabled (`globalevents.xml:19`, `globalSaveEnabled = false`,
`config.example.lua:304`). So stop the server (or `/save`) before taking a backup:

```bash
mysqldump -u psoul -p psoul > ~/psoul-$(date +%F-%H%M).sql      # backup
mysql     -u psoul -p psoul < ~/psoul-2026-10-06-1600.sql       # restore (server stopped)
tools/setup_database.sh --reset   # DROP DATABASE and re-import mysql.sql + psoul_extra + dev seed
```

`--reset` (`tools/setup_database.sh:10-19`) deletes all characters and progress; it keeps
`server/config.lua`. Never run SQL against `players`/`player_items` while the character is
online — the server overwrites those rows at logout.

### 10.3 What `/reload` can and cannot do

`/reload <type>` (`talkactions.xml:65`, access 5 = group 6 only; `talkactions/scripts/reload.lua`)
calls `Game::reloadInfo` (`server/src/game.cpp:6341-6601`):

| Works | Does nothing / not supported |
|-------|------------------------------|
| `actions`, `talkactions`, `creaturescripts`, `globalevents`, `movements`, `spells` (also reloads monsters), `monsters`, `npcs`, `config`, `chat`, `quests`, `raids`, `stages`, `highscores`, `houseprices`, `gameservers` | `items`, `outfits`, `weapons` ("Reload type does not work"), `groups`, `vocations` (report success but do nothing), `all` ("Reload all type does not work"), `mods` (case commented out → "Reload type not found"). The map and C++ code always need a restart. |

Pitfalls, all following from §4.1:

* Reloading a system rebuilds **only that system's Lua state** (`BaseEvents::reload` →
  `reInitState`, `baseevents.cpp:140-145`, `luascript.cpp:645-649`). An edit to
  `data/lib/ps/**` reaches the reloaded system only; the others keep the old code until restart,
  so behaviour can become inconsistent.
* `closeState` drops every pending `addEvent` timer of that state (`luascript.cpp:854-872`).
  `/reload globalevents` therefore kills the timers that `start.lua` started (Aerodactyl
  whirlpool cycle, delayed Crystal Onix spawn), and `onStartup` is not run again.
* Lua tables that track live state (battles, cooldown tables, `ONLINE_TUTORS`) are emptied.
* `/reload config` re-reads `config.lua`, but ports, SQL settings and the map are only used at
  startup.

Rule of thumb: use `/reload` for quick iteration on an isolated script, then **always confirm
with a full restart** before committing.

---

## 11. IDs and storages: where they live and how to avoid collisions

### 11.1 Storage keys

A *storage* is an integer key → value pair. Player storages persist in `player_storage`;
creature storages on summons (`getCreatureStorage`/`doCreatureSetStorage`, `luascript.cpp:1561-1564`)
live only in memory; global storages persist in `global_storage`. All three share no number
space with **item attributes** (the 10000+ keys in `balls.lua` are attributes, not storages).

Declared tables:

| Range | Use | Declared in |
|-------|-----|-------------|
| 4962–5000, 5001–5152, 6000–6021, 6100–6105, 6150–6156 | **global** storages (events, Elite Four, highscore boards, mastery dungeons, bosses) | `lib/ps/config/globalStorages.lua:1-52` (ranges in the comments) |
| 7001–7078 | player flags (`playersStorages`) | `config/playersStorages.lua` (`base = 7000`) |
| 7501–7521 | summon creature storages (`pokemonsStorages`) | `config/pokemonsStorages.lua` (`base = 7500`) |
| 8001–8754 (+ a few up to 9681) | quests | `config/003-quest.lua` (`storage =`, `counterStorage =`), NPC `setRequiredStorage(…)` |
| 8381 | boss reward | `systems/021-boss.lua:1` |
| 9001–9009 | NpcBattle per-battle scratch (on the player) | `systems/001-npcBattle.lua:15-26`, `050-rocketBattle.lua:20` |
| ~9100–9312 / ~9500–9712 | per-trainer "last battle time" / "NPC level" | 2nd/3rd argument of `NpcBattle:new(name, lastBattle, level, handler)` in each `npc/scripts/npcbattle_*.lua` (bases noted at `001-npcBattle.lua:9,13`) |
| 10001–10386 | Pokédex entry per species (`dexStorage`) | `config/pokemon/*.lua` |
| 14001–14008 | misc player / Pokémon status | `config/storages.lua` |
| 15000–15457 | move cooldowns (`cooldownStorage`) | `config/moves/*.lua`; header `config/skill.lua:1` says "last used 15437" (stale; real max 15457); 15439–15456 are reserved by `others/moves_disabled/` |
| 16001–16386 | catch counter per species (`catchStorage`, auto `16000 + number`) | `config/pokemon.lua:27-29` |
| 20200–20349 | Ranger Club tasks | `config/001-rangerClub.lua` |
| 20001–20170 | historical task system (not loaded) | `systems/disabled/005-task.lua` — avoid anyway |

Known irregularities (inferred from data, not fixed): Mawile uses `catchStorage = 28559` (its
egg item id) instead of 16303 (`config/pokemon/mawile.lua:13`); four pairs of unrelated moves
share a cooldown storage — Constrict/Stealth Rock 15201, Spider Web/Stone Edge 15288, Aqua
Jet/Shell Smash 15355, Echoed Voice/Metal Burst 15426.

Finding a free storage key (check all three places: data, NPC scripts, live DB):

```bash
K=20500
rg -n "\b$K\b" server/data --glob '*.{lua,xml}' \
   --glob '!**/_pokemon/**' --glob '!**/pokemon_backup/**' --glob '!**/moves_disabled/**'
mysql -u psoul -p psoul -e "SELECT COUNT(*) FROM player_storage WHERE \`key\` = $K;
                            SELECT COUNT(*) FROM global_storage WHERE \`key\` = $K;"
# list cooldown storages in use, sorted, with duplicates
rg -o --no-filename "cooldownStorage\s*=\s*\d+" server/data/lib/ps/config/moves | sort -t= -k2 -n | uniq -c | sort -rn | head
```

Prefer adding a named constant to an existing table (`playersStorages`, `GLOBAL_STORAGES`, …)
over a bare number, and keep new blocks in an unused range (e.g. 21000+), with a comment.

### 11.2 Item ids

Server ids are defined by `items.otb` + `items.xml` (§7.1). Before binding an id in
`actions.xml`/`movements.xml`, check it is not already bound (the engine warns, §4.4):

```bash
ID=29131
rg -n "itemid=\"[^\"]*\b$ID\b" server/data/{actions,movements}/*.xml   # exact-id matches
rg -n "<item id=\"$ID\"" server/data/items/items.xml                     # does the item exist?
rg -n "\b$ID\b" server/data/lib/ps --glob '!**/_pokemon/**' --glob '!**/pokemon_backup/**' | head
```

Ranges (`a-b`) in XML are not found by the first grep; scan them visually or with a small script.
Action ids / unique ids placed on the map (doors, quest chests) are inside `map.otbm`; search
them in RME.

### 11.3 Pokémon identifiers

| Identifier | Where | Notes |
|------------|-------|-------|
| Species name (the real key) | `POKEMON["Charmander"]` in `config/pokemon/<name>.lua`; ball attribute `pokemonName` | case-sensitive; variants are separate keys ("Shiny …" generated by `config/pokemon.lua:43-53`, "RC …", "Easter …", "Christmas …") |
| National number | `config/pokemonsNumbers.lua` (name → number, e.g. `:11` Charmander = 4; reverse map `:838`) | `POKEMON_NUMBER = 386` (Gen 1–3); drives `dexStorage`, `catchStorage`, Pokédex packets |
| Monster XML name | `monster/monsters.xml:9` `name="Charmander"` → `Pokemons/charmander.xml:2` | must equal the `POKEMON` key, or catching, levels and moves break |
| Looktype | monster XML `<look type="355">` | client outfit id |
| Portraits / icons | `portrait` (server id), `fastcallPortrait` (client id), `dexPortrait` | §7.1 |

Find every place a species is used before renaming or removing it:

```bash
N="Charmander"
rg -n "\"$N\"|name=\"$N\"|\[\"$N\"\]" server/data \
   --glob '!**/_pokemon/**' --glob '!**/pokemon_backup/**' | head -50
```

---

## 12. Where do I change X?

| I want to… | Edit | Then |
|------------|------|------|
| change a species' stats, types, moveset, evolutions, catch rate | `server/data/lib/ps/config/pokemon/<name>.lua` | restart |
| change a move's damage, cooldown, energy, level | `lib/ps/config/moves/<move>.lua` | restart |
| change what a move does (effect/animation) | `lib/ps/events/spells/scripts/<Move>.lua` | `/reload spells` for a quick try, then restart |
| change the type chart, STAB, crits | `lib/ps/systems/004-skillDamage.lua` (table at `:1+`, `doSkillDamage` `:335`) | restart |
| change the catch formula | `lib/ps/functions/ball/empty.lua` (`getCatchChance` `:52`) | restart |
| add a ball type / ball attribute | `lib/ps/config/balls.lua` + `actions.xml:90-93` + `movements.xml:5-6` + `items.otb`/`items.xml` | restart |
| change what using an item does | the script bound in `data/actions/actions.xml` | `/reload actions`, then restart |
| add a player command | `data/talkactions/talkactions.xml` + script | `/reload talkactions` |
| change login behaviour, starting messages | `data/creaturescripts/scripts/login.lua`, `lib/ps/events/creaturescripts/` | restart |
| change what happens at server start | `data/globalevents/scripts/start.lua` | restart (never `/reload globalevents` for this) |
| change NPC dialogue / shop | `data/npc/scripts/<script>.lua` (find it from `npc/<Name>.xml` `script=`) | `/reload npcs` |
| move or add an NPC / wild spawn | `data/world/map-spawn.xml` (RME) | restart |
| change a quest | `lib/ps/config/003-quest.lua`, quest NPC script | restart |
| change rates, MOTD, ports, world type | `server/config.lua` (and `config.example.lua` if the default should change) | restart |
| change group permissions (e.g. GM energy) | `data/XML/groups.xml` | restart (`/reload groups` does nothing) |
| add/translate a server message | text in Lua wrapped in `__L(cid, "…")`, Portuguese in `server/pt_br.loc` | restart; `docs/TRANSLATION.md` |
| change the client's target server | `client/modules/client_entergame/entergame.lua:191-192` | restart client |
| change a client window | `client/modules/game_<name>/*.lua` / `.otui` | restart client (no rebuild) |
| add a client module | new `client/modules/<name>/<name>.otmod` + add it to `game_interface/interface.otmod` `load-later` | restart client |
| add a packet | `server/src/protocolgame.cpp` + `luascript.cpp` + `client/src-cpp/src/client/protocol*` | rebuild both (§6.1) |
| add a database table | new `CREATE TABLE IF NOT EXISTS` block in `server/src/schemas/psoul_extra_mysql.sql` citing the code that uses it | apply to your DB (`mysql … < file` or `setup_database.sh --reset`) |
| change engine behaviour | `server/src/*.cpp` | `tools/build_server.sh`, restart |

---

## 13. Glossary

| Term | Meaning here |
|------|--------------|
| **TFS** | The Forgotten Server, the open-source Tibia server engine; this is version 0.3.6 with PSoul changes (comments tagged `PS`). |
| **OTServ / OT** | "Open Tibia" — the family of open-source Tibia servers/clients TFS belongs to. |
| **OTClient** | Open-source Tibia client (C++ core + Lua modules). `client/` is a 0.6-era fork ("Poke Aimar"). |
| **Redemption** | OTClient Redemption, a modern OTClient fork; a possible future migration target (not started). |
| **PSoul / PokeAimar** | The original Pokémon project this repository imports. |
| **Protocol 8.54 / "312"** | The packet format of Tibia 8.54; PSoul labels it with the invented version number 312. |
| **Opcode** | First byte of a packet that says what it is. **`0xFF` + sub-opcode** = PSoul's custom family; **`0x32` extended opcode** = OTClient's generic "id + string" message. |
| **otmod** | Client module descriptor (`*.otmod`): name, scripts, dependencies, `load-later`, `autoload`. |
| **otui** | Client UI layout file. |
| **otbm** | Binary map file (`map.otbm`), edited with Remere's Map Editor (RME). |
| **otb** | `items.otb`: binary item-type table mapping server ids to client ids and flags. |
| **items.xml** | Names and attributes for server item ids. |
| **dat / spr** | Client asset files: `data.dat` (object metadata, outfits) and `data.spr` (sprites). |
| **Server id / client id** | Item number on the server vs graphic index in the client (§7.1). |
| **Looktype** | Outfit id used to draw a creature. |
| **Creature** | Anything that lives on the map: player, monster, NPC. |
| **Monster** | Engine creature type used for wild Pokémon and summoned Pokémon. |
| **Summon / master** | A creature controlled by another; a called Pokémon is a monster summon whose *master* is the player. |
| **NPC** | Scripted non-player character (`npc/*.xml` + `npc/scripts/*.lua`). NpcBattle trainers are NPCs whose Pokémon are summons with the NPC as master. |
| **cid / uid** | Numeric handles Lua uses for a creature (`cid`) or an item (`uid`) during a script call. |
| **Storage** | Integer key → value flag on a player, creature or the world (§11.1). |
| **Item attribute** | Key → value data attached to one item instance; how Pokémon live inside balls (§8.2). |
| **action** | Script run when an item is used (`actions.xml`). |
| **talkaction** | Script run when a player says certain words (`talkactions.xml`). |
| **creaturescript** | Script run on a creature event: login, logout, death, kill, think, … (`creaturescripts.xml`). |
| **globalevent** | Script run at startup, on a timer or at a clock time (`globalevents.xml`). |
| **movement (moveevent)** | Script run when something is stepped on, equipped or de-equipped (`movements.xml`). |
| **spell / instant** | Engine spell; PSoul uses one per Pokémon move (`spells.xml`). |
| **Lua state / interface** | A separate Lua interpreter; one per script system (§4.1). |
| **stackpos** | Position of a thing inside the stack of items/creatures on one map tile (0 = ground). Used-with targets are resolved by exact stackpos. |
| **Group / access** | Player permission level (`data/XML/groups.xml`); `access` gates talkactions. |
| **Fastcall** | The Pokémon bar shortcut number for a ball. |
| **Charlist** | Character list sent by the login server. |
| **AAC** | "Automatic Account Creator", i.e. the missing website. |
| **LFS** | Git Large File Storage, used for the map and sprite files. |

---

## 14. Safe-change checklist

1. Find the authoritative file (§2.1, §12); exclude backup trees in every search.
2. Check ids/storages/names for collisions (§11) before using a new number.
3. Keep server and client in step for anything that crosses the wire (§6), and server id vs client
   id straight for anything shown in a `0xFF` packet (§7.1).
4. `tools/check_syntax.sh`, restart, read the console, test as Tester/Trainer (§9).
5. Back up the database before anything that touches persistent data (§10.2).
6. Commit small, focused changes with a message that names the system and the test you ran.
