# Dependency checklists

Each list below is the set of places one kind of content must be wired into. Tick every box
before you call it done. Field names are the real Lua table keys and XML attributes. The
detailed tutorials explain each one.

Paths are relative to `server/` unless they start with `client/`, `tools/` or `docs/`.

Every checklist ends with the same validation block:

- [ ] `bash tools/check_syntax.sh` passes
- [ ] `python3 tools/check_references.py` shows no new `REAL` finding for your names or ids
- [ ] Server start-up shows no new `[Warning …]`, `[Error …]`, `mysql_real_query(): … MYSQL ERROR` or `Lua Script Error` line
- [ ] Tested in game with the seed accounts (`admin`/`admin` → "GM Admin", "Tester"; `player`/`player` → "Trainer")
- [ ] Nothing changed under `data/lib/ps/config/_pokemon`, `data/lib/ps/others/pokemon_backup`, `data/lib/ps/others/moves_disabled`, `data/lib/ps/systems/disabled`, `original/`, or generated `tmpCitizen_*.xml`

---

## Pokémon (summary)

Full tutorial: [`add-pokemon.md`](add-pokemon.md). The model used here is Rattata.

- [ ] `data/lib/ps/config/pokemon/<name>.lua` defines `POKEMON["<Name>"]`, loaded by `dodirectory` (`config/pokemon.lua:22`), with:
  - [ ] `pTypes` (`ELEMENT_*`), `atk`, `def`, `spAtk`, `spDef`, `energy`, `chance`
  - [ ] `dexStorage` and `catchStorage`: unique player storages (`grep -rn "dexStorage = <n>"` / `"catchStorage = <n>"` in `config/pokemon/`)
  - [ ] `portrait`, `dexPortrait`, `fastcallPortrait`: server item ids that exist in `data/items/items.xml` (portraits are in the `fromid="12702" toid="12853"` "pokemon portrait" range, `items.xml:18271`)
  - [ ] `evolutions` (`{ name = …, requiredLevel = … }`; every `name` is itself a `POKEMON[...]` entry)
  - [ ] `description`
  - [ ] `skills` as `{ "<Move>", level, … }`; every move exists in `MOVES` (see Moves below)
  - [ ] `abilities` (`POKEMON_ABILITIES.*` or field-move names) and `specialAbilities` (`POKEMON_SPECIAL_ABILITY_IDS.*`)
  - [ ] `eggGroup` (`POKEMON_EGG_GROUP_*`), `eggId` (an egg item in `items.xml`, e.g. 13984 "rattata egg"), `eggChance`
  - [ ] `learnableTms` (`TM_IDS.*`, `others/constants.lua:451`) and optional `eggMoves`
- [ ] Name listed in `config/pokemonsNames.lua`; dex number in `config/pokemonsNumbers.lua`
- [ ] The "Shiny <Name>" entry is created automatically from `POKEMON` (`config/pokemon.lua:24-45`). Still add its monster XML.
- [ ] `data/monster/Pokemons/<name>.xml`: `<monster name=… shiny="Shiny <Name>" …>`, `<look type="<looktype>" … corpse="…"/>`
- [ ] `data/monster/monsters.xml`: `<monster name="<Name>" file="Pokemons/<name>.xml"/>` (and the Shiny line)
- [ ] Client: `client/modules/gamelib/pokemon.lua` has the `POKEMON[#POKEMON + 1] = {name = …, iconItemId = …}` entry (line 397 for Rattata), the name→number entry (line 595) and `pokemonNameByNumber` (line 1276)
- [ ] Client: `client/data/images/pokeicons/NNN.png` (32×32), `client/data/images/staticPortraits/N.png` (96×96), looktype present in `client/data/things/data.dat` (`add-client-asset.md`)
- [ ] Spawned somewhere (`add-spawn.md`), or deliberately event-only

## Moves

Full tutorials: [`add-move.md`](add-move.md), [`edit-move.md`](edit-move.md). The model used here is Quick Attack.

- [ ] `data/lib/ps/config/moves/<move>.lua` defines `MOVES["<Move>"]`, loaded by `dodirectory` (`config/skill.lua:52`) and copied into `SKILLS_CONFIG` (`skill.lua:55-56`), with:
  - [ ] `description`, `category` (`MOVE_CATEGORY.*`), `type` (`SKILLS_TYPES.*`)
  - [ ] `clientIconId` (client move icon) and `iconId` (server item, e.g. 13375 "quick attack icon" at `items.xml:19593`)
  - [ ] `dType` (`DAMAGE_TYPE_*`), `damage`, `damageType` (`ELEMENT_*`)
  - [ ] `requiredEnergy` (multiplied by 0.75 at load, `skill.lua:76-80`) and `requiredLevel`
  - [ ] `effect` (`EFFECT_*`), `projectile` / `backProjectile` (`PROJECTILE_*` or `nil`), `maxDistance`
  - [ ] `cooldownTime` and a unique `cooldownStorage` (`grep -rn "cooldownStorage = <n>" data/lib/ps/config/moves`; the current highest is 15454)
  - [ ] `functionName` (stored, read by `getPokemonSkillFunctionName`, `skill.lua:83-85`)
- [ ] Script `data/lib/ps/events/spells/scripts/<Move>.lua`
- [ ] `data/spells/spells.xml`: `<instant name="script_<Move>" words="*stNN" … script="../../lib/ps/events/spells/scripts/<Move>.lua"/>`. The `script_` prefix is `SKILL_FUNCTION_PREFIX` (`others/constants.lua:28`); `words` must be unique.
- [ ] Added to at least one Pokémon's `skills` (or a TM, `add-tm.md`)
- [ ] Client: `client/modules/gamelib/moves.lua` has the `MOVES[#MOVES + 1] = {name = …, iconItemId = <clientIconId>}` entry and the `MOVES_DESCRIPTIONS["<Move>"]` entry
- [ ] Not left in `others/moves_disabled/` (those are not loaded)

## Items

Full tutorials: [`add-item.md`](add-item.md), [`edit-item.md`](edit-item.md), [`add-client-asset.md`](add-client-asset.md).

- [ ] Server id exists in `data/items/items.otb`; the copy at `tools/rme/data/854/items.otb` is identical
- [ ] Client id (from `items.otb`) is ≤ the item count in `client/data/things/data.dat` (28,778), with sprites in `data.spr`
- [ ] `data/items/items.xml`: `<item id="…" article=… name=…>` plus attributes (e.g. `description`). Mirror it in `tools/rme/data/854/items.xml`.
- [ ] Behaviour registered in `data/actions/actions.xml` (`<action itemid="…" event="script" value="…"/>`) or `data/movements/movements.xml`, if the item does something
- [ ] Obtainable: NPC shop, quest `rewardItems`, boss `REWARDS`, or loot in a monster XML
- [ ] Tested with `/i <id>,1`

## Pokéballs

Full tutorial: [`add-pokeball.md`](add-pokeball.md), plus [`edit-catch-rate.md`](edit-catch-rate.md).

- [ ] `data/lib/ps/config/balls.lua` has an entry in `balls` (starts at line 166) with:
  - [ ] `charged`, `discharged`, `inUse`, and `empty` if the ball can be thrown empty (all real server item ids)
  - [ ] `useCounter`. If it is `true`, `systems/020-ballCounter.lua:3-7` reads and writes a `ball_counter` column named after the ball key. Add that column (`psoul_extra_mysql.sql:107-129`) as an `ADD COLUMN IF NOT EXISTS` migration (`database-changes.md`).
  - [ ] `projectile` (`PROJECTILE_*`) and `effects = { use = …, catch = …, catchMiss = … }`
- [ ] `ballsNames` is filled automatically from those ids (`balls.lua:1632-1649`)
- [ ] Catch multiplier in `CATCH_RATE["<ball>"]` (`balls.lua:1664`). Missing names default to 1 (`getBallCatchRate`, line 1693).
- [ ] Each id added to the matching `itemid=` list in `actions.xml`: line 90 (`balls/empty.lua`), 91 (`balls/charged.lua`), 92 (`balls/discharged.lua`), 93 (`balls/inUse.lua`)
- [ ] All four ids exist in `items.xml` / `items.otb` / `data.dat` (Items checklist)

## NPCs

Full tutorial: [`add-npc.md`](add-npc.md).

- [ ] `data/npc/<Name>.xml`: `name` is unique, `script=` points to an existing file, `<look type=…/>` is a looktype in `data.dat`
- [ ] Script in `data/npc/scripts/`, or an existing shared one (e.g. `quest_default.lua`)
- [ ] `data/world/map-spawn.xml`: `<npc name="<Name>" x=… y=… z=… spawntime=…/>` inside a `<spawn centerx centery centerz radius>` block. An optional `direction` (0-3) is applied without validation (`src/spawn.cpp:202-204`).
- [ ] Every player-facing string goes through `__L(cid, …)`, with Portuguese in `pt_br.loc` (`English@Portuguese`)
- [ ] Server restarted (spawns do not reload)

## Trainers (NPC battles)

Full tutorials: [`add-trainer.md`](add-trainer.md), [`add-gym-leader.md`](add-gym-leader.md).

- [ ] NPC XML + spawn (NPC checklist)
- [ ] `data/npc/scripts/npcbattle_<name>.lua` with `NpcBattle:new(getNpcName(), <storage1>, <storage2>, npcHandler)`, both storages free (model: `npcbattle_chandrawigington.lua:6`)
- [ ] `setPokemons({ … })`, where every name is a `POKEMON[...]` entry and a monster in `monsters.xml`
- [ ] Optional: `setOneWin`, `setDifficulty`, `setPokemonDefeatExperienced`, and `setOnWin` for rewards or achievements
- [ ] `-- Last Storages:` comment on line 1 of `data/lib/ps/systems/001-npcBattle.lua` bumped (the comment is the only edit to that file)
- [ ] Gym only: `BADGES` (`others/constants.lua:667`), the badge and slot items in `items.xml`, `BADGE_CASES` in `systems/024-badgeCase.lua`

## Quests

Full tutorials: [`add-quest.md`](add-quest.md), [`edit-quest.md`](edit-quest.md).

- [ ] Entry in `QUESTS_CONFIG["<NPC name>"]` in `data/lib/ps/config/003-quest.lua` with:
  - [ ] `storage` (free player storage) and `counterStorage` for counted quests
  - [ ] `talk_questStarting`, `talk_questStarted`, `talk_questFinishing`, `talk_questFinished`, `talk_questFinishFail`
  - [ ] `questType` (`QUEST_TYPE.*`) and a matching `questRequest`
  - [ ] `rewardItems` (`{ type = REWARD_TYPE.ITEM, id = …, count = … }`), `rewardExp`, `requiredLevel`
- [ ] The NPC exists and is spawned (unspawned quest NPCs are flagged as `quest.npc.unspawned` by `check_references.py`)
- [ ] Optional quest-log entry in `data/XML/quests.xml` (`<quest … startstorageid=…>` / `<mission storageid=… startvalue=… endvalue=…>` / `<missionstate id=…>`)
- [ ] Every `talk_*` line in `pt_br.loc`
- [ ] Tested by resetting with `/storage Tester,<storage>,-1`

## Bosses

Full tutorial: [`add-boss.md`](add-boss.md).

- [ ] `POKEMON["<Boss>"]` file in `config/pokemon/` (stats, `skills`)
- [ ] `data/monster/Boss/<base>.xml` with `<flag boss="1"/>`, `<flag catchable="0"/>` and the `bossReward` script event
- [ ] `<monster name="<Boss>" file="Boss/<base>.xml"/>` in `monsters.xml` (Boss block)
- [ ] `BOSSES["<Boss>"] = { level = BOSS_LEVEL_IDS.HARD, spawns = { {x=…, y=…, z=…} }, messages = { … } }` in `systems/021-boss.lua`. Only `HARD` is active.
- [ ] `REWARDS["<Boss>"] = { {itemid=…, count=…, chance=…, unique=…}, … }` in `events/creaturescripts/boss/bossReward.lua`, with at least one `chance = CHANCE_MAX` entry. Otherwise no reward and no cooldown are given.
- [ ] Every reward `itemid` exists in `items.xml`
- [ ] The boss name contains no comma if you want to test it with `/m` (the command splits on commas)
- [ ] `datalog_boss_spawns` / `datalog_boss_rewards` tables exist (`psoul_extra_mysql.sql:525`, `641`)

## Achievements

Full tutorial: [`add-achievement.md`](add-achievement.md).

- [ ] New `ACHIEVEMENT_IDS.<KEY> = <next id>` after the last one (182, `systems/023-achievement.lua:1144`)
- [ ] `ACHIEVEMENT_NAMES[…]`, `ACHIEVEMENT_DESCRIPTIONS[…]`, `ACHIEVEMENT_RANKS[…]` (`RANK_IDS.EASY/MEDIUM/HARD` → `SCORE_BY_RANKS` 10/20/30)
- [ ] Optional `ACHIEVEMENT_CHECKS[…] = function(cid, var) … end`, `ACHIEVEMENT_SERIES[<previous>] = <this>`, `SECRET_ACHIEVEMENTS[…] = true`
- [ ] Something calls `doPlayerAchievementCheck(cid, ACHIEVEMENT_IDS.<KEY>, var)`
- [ ] Name and description in `pt_br.loc`
- [ ] `player_achievements` table exists (`psoul_extra_mysql.sql:78`)

## Client modules

Full tutorial for assets: [`add-client-asset.md`](add-client-asset.md).

- [ ] `client/modules/<module>/<module>.otmod` with `name`, `scripts: [ … ]`, `@onLoad` / `@onUnload` (model: `game_poll/poll.otmod`)
- [ ] Loaded either by `autoload: true` + `autoload-priority` (model: `game_guide/*.otmod`) or by a `load-later:` line in `client/modules/game_interface/interface.otmod`
- [ ] `connect(g_game, { … })` in init, matched by `disconnect` in terminate (`game_poll/poll.lua:123`, `135`)
- [ ] Server→client data: a new id in **both** `ExtendedIds` (`client/modules/gamelib/const.lua:241`) and `EXTENDED_IDS` (`server/data/lib/ps/others/constants.lua:33`), received with `ProtocolGame.registerExtendedOpcode` (model: `game_guide/guide.lua:43`) and sent with `doSendPlayerExtendedOpcode(cid, EXTENDED_IDS.…, buffer)` (`src/luascript.cpp:2761`)
- [ ] Every string wrapped in `tr()`, with locale entries in `client/data/locales/`
- [ ] Client built with `ENCRYPTED_ASSETS=OFF` for development (`tools/build_client.sh:17`)

## Database changes

Full tutorial: [`database-changes.md`](database-changes.md).

- [ ] The new table or column is in `src/schemas/psoul_extra_mysql.sql` with a comment citing the code that uses it
- [ ] The same SQL is in an idempotent migration file (`CREATE TABLE IF NOT EXISTS`, `ADD COLUMN IF NOT EXISTS`, `INSERT IGNORE`)
- [ ] Applied to the existing database (`setup_database.sh` without `--reset` skips the schema files)
- [ ] Ran twice on a scratch database without errors
- [ ] Backup taken with `mysqldump` before touching a database that has data
