# Add a dungeon

PSoul has two kinds of dungeon. Neither is a generic engine feature; each is plain Lua
around map areas.

| Kind | Real example | Entry | End |
|------|--------------|-------|-----|
| **Mastery dungeon** (instanced per player, timed) | the 11 `MASTERY_DUNGEONS` in `lib/ps/systems/014-mastery.lua:486-498` | the mastery NPC, `dungeon` → `yes` (`npc/scripts/mastery_blaze.lua:201-223`) | the final boss dies (`dungeonEnd.lua`), or 60 minutes pass, or the player logs out or dies |
| **Legendary dungeon** (one group at a time, puzzle + boss) | Zapdos / Moltres / Articuno, `lib/ps/systems/028-dungeons.lua` | use an orb on a statue (`lib/ps/events/actions/quests/legendaryOrbs.lua`) | the boss dies and drops a chest (`legendaryDeath.lua`, `legendaryChest.lua`) |

This tutorial adds a **mastery dungeon** step by step (§8) and explains the legendary
pattern as a reference (§5.2). Paths are relative to `server/data/` unless stated otherwise.

Every dungeon needs map space. Building the rooms is covered in `edit-map-content.md`; this
tutorial assumes the area already exists in `world/map.otbm`.

---

## 1. The chain (mastery dungeon)

```
npc/scripts/mastery_<name>.lua:217    doMasteryDungeonStart(MASTERY, nextRank, cid)
        │
lib/ps/systems/014-mastery.lua
        │ MASTERYS[...].dungeons = {MASTERYDUNGEONID_...}      lines 107-305 (e.g. 117)
        │ getMasteryDungeonsFree → free = global storage "user" == 0     lines 924-932
        │ doMasteryDungeonStart (983-1003)
        │    teleport to MASTERY_DUNGEONS[id].startPosition            lines 486-498
        │    doMasteryDungeonClean → doMasteryDungeonSpawnClear         lines 942-954, 966-981
        │    doMasteryDungeonSpawns: one random DUNGEON_RESPAWNS[id].pokemons per spawn,
        │                            then the boss                      lines 956-964
        │    addEvent(doMasteryDungeonClean, 60 min)                    line 996
        ▼
monster/monsters.xml  "Dungeon <X>" → monster/Dungeons/<Type>/dungeon <x>.xml
        │                 "Dungeon Boss <X>" → <event name="dungeonEvolve"/> or "dungeonEnd"
        ▼
creaturescripts.xml:50-51
        dungeonEvolve.lua → doPokemonEvolve into the next "Dungeon Boss …"
        dungeonEnd.lua    → doMasteryDungeonEnd(killer, true) → rank "dungeon done",
                            "Congratulations, you won the dungeon!"    014-mastery.lua:1005-1019
```

Other exits: `onLogout.lua:42` and `onDeath.lua:28` call `doMasteryDungeonEnd(cid, false)`.
At start-up, `globalevents/scripts/start.lua:30-38` (`>> Cleaning Mastery Dungeons...`) sets
every dungeon's user and clean-event storage to 0.

## 2. Files to edit

| File | What |
|------|------|
| `lib/ps/systems/014-mastery.lua` | a new `MASTERYDUNGEONID_*` constant (after line 79), a `MASTERY_DUNGEONS` row (after 497), a `MASTERY_DUNGEON_IDS` entry (500-512), a `DUNGEON_RESPAWNS` entry (514-894), and the id in one or more `MASTERYS[...].dungeons` lists |
| `monster/Dungeons/<Type>/*.xml` | the dungeon monsters and the boss chain |
| `monster/monsters.xml` | one line per new monster (Dungeons block, lines 961-1049) |
| `world/map.otbm` | the rooms (`edit-map-content.md`) |

## 3. Files NOT to edit

* `globalevents/scripts/start.lua`. The clean-up loop at lines 30-38 already iterates over
  `MASTERY_DUNGEON_IDS`.
* `creaturescripts/creaturescripts.xml`. `dungeonEvolve` and `dungeonEnd` (lines 50-51) are
  generic. Reuse them.
* `world/map-spawn.xml`. Dungeon monsters are summoned by Lua. A map spawn inside a dungeon
  respawns forever and is never cleaned.
* `lib/ps/config/_pokemon/`, `lib/ps/others/pokemon_backup/`, `lib/ps/others/moves_disabled/`,
  `lib/ps/systems/disabled/`, `original/`, `npc/tmpCitizen_*.xml`, unused `*-spawn.xml`.

## 4. Authoritative source paths

| Topic | Location |
|-------|----------|
| Dungeon ids | `014-mastery.lua:69-79` (`MASTERYDUNGEONID_FIGHT = 1` … `ELECTRICSTEEL = 11`) |
| Which mastery uses which dungeon | `MASTERYS[...].dungeons`, e.g. Blaze at `014-mastery.lua:117` |
| Start positions and global storages | `014-mastery.lua:486-498` |
| Spawn lists and boss | `014-mastery.lua:514-894` |
| Start / clean / end | `014-mastery.lua:934-1019` |
| Rank level of the dungeon monsters | `ranks[...].dungeonLevel`, e.g. `014-mastery.lua:119-124` |
| Player storages | `lib/ps/config/playersStorages.lua:40-41` (`masteryDungeon = 7037`, `lastDungeonDate = 7038`); `014-mastery.lua:100-104` (`requiredStones 8053`, `requiredTokens 8054`, `requiredDungeon 8055`) |
| Boss events | `lib/ps/events/creaturescripts/dungeons/dungeonEvolve.lua`, `dungeonEnd.lua` |
| Legendary dungeons | `028-dungeons.lua`, `legendaryOrbs.lua`, `movements/zapdosDungeon.lua`, `creaturescripts/quests/legendaryDeath.lua`, `actions/quests/legendaryChest.lua` |

## 5. Real examples

### 5.1 Mastery dungeon: ELECTRICSTEEL

`014-mastery.lua:497`:

```lua
    [MASTERYDUNGEONID_ELECTRICSTEEL] = {startPosition = {x = 4841, y = 618, z = 4}, globalStorages = {user = 6020, cleanEvent = 6021}},
```

`014-mastery.lua:515-546` (spawn list shortened):

```lua
    [MASTERYDUNGEONID_ELECTRICSTEEL] = {
        pokemons = {"Dungeon Electrode", "Dungeon Magneton", "Dungeon Raichu"},
        spawns = {
            {x = 4856, y = 618, z = 4},
            {x = 4865, y = 618, z = 4},
            ...
            {x = 4843, y = 610, z = 7},
		},
		boss = {name = "Dungeon Boss Pikachu", position = {x = 4860, y = 602, z = 7}}
    },
```

| Field | Consumed at | Notes |
|-------|-------------|-------|
| `startPosition` | `getMasteryDungeonStartPosition` (`920`), `doMasteryDungeonStart:990` | if `doTeleportThing` fails (bad tile), the start returns `false` → NPC: `You can't do the dungeon right now, please try again later.` |
| `globalStorages.user` | `904-910`, `927` | 0 = free; otherwise the player id |
| `globalStorages.cleanEvent` | `912-918`, `934-940` | the `addEvent` id of the 60-minute timer |
| `pokemons` | `957`, `943` | names from `monsters.xml`; also used as **nicknames** for clean-up |
| `spawns` | `956-961` | one monster per position, any floor. `doSummonCreature(..., false)` fails silently on a blocked tile |
| `boss.name` / `boss.position` | `963` | summoned with the same level as the other monsters |

The monster level is `ranks[nextRank].dungeonLevel` (`doMasteryDungeonStart:992`,
`getMasteryRankDungeonLevel` at `457-459`). Blaze Ember uses 70 (`014-mastery.lua:120`).

The boss chain (ElectricSteel):

| `monsters.xml` name | Monster XML | `name` / `nickname` | Event |
|---|---|---|---|
| `Dungeon Boss Pikachu` (`monsters.xml:961`) | `Dungeons/ElectricSteel/dungeon boss pikachu.xml` | `Shiny Pikachu` / `Elite Pikachu` | `dungeonEvolve` |
| `Dungeon Boss Raichu` | `Dungeons/ElectricSteel/dungeon boss raichu.xml` | `Shiny Raichu` / `Elite Raichu` | `dungeonEnd` |

`dungeonEvolve.lua:2` maps the **creature name** (`getCreatureName`, the XML `name`) to the
next **`monsters.xml` name**: `["Shiny Pikachu"] = "Dungeon Boss Raichu"`. The last form has
`dungeonEnd`, which ends the dungeon for the killer's master.

Regular monsters: `monster/Dungeons/ElectricSteel/dungeon raichu.xml:2` has
`name="Raichu" … nickname="Dungeon Raichu"`. The `nickname` must equal the `monsters.xml`
name, because the clean-up looks monsters up with `getCreatureByNickname(<pokemons entry>)`
(`014-mastery.lua:944`).

### 5.2 Legendary dungeon: Zapdos (reference)

1. **Entry.** `actions.xml:171` registers items 18174-18176 (the orbs) with
   `legendaryOrbs.lua`. Using the Zapdos orb (18174) on the statue 18318 (`legendaryOrbs.lua:6-11`)
   requires the "Ancient Times" quest storage 8369 = `QUEST_STATUS.FINISHED` and storage 8370
   (legendary done) ≠ `FINISHED` (lines 28-33). Otherwise: `Sorry, not possible.`
2. **Occupancy guard.** Any player within 36×34 tiles of `centerPos`, all floors (line 35),
   blocks entry: `There are players completing the dungeon at the moment, you must try again later.`
3. **Reset.** `Dungeons.Zapdos.doReset()` (`028-dungeons.lua:27-43`) creates 7 barrels (item
   18745) and **removes every creature** within 17×12 tiles of `{x = 5107, y = 287, z = 7}`.
4. The player is teleported, receives the tip `Tip: Note the path that you're doing!`, and
   logout is blocked (`legendaryOrbs.lua:53-55`).
5. **Puzzle.** `movements.xml:32` (`AddItem`, tile item 3196) runs `zapdosDungeon.lua`. When
   all 7 barrels stand on `BARRELS` (lines 3-11), they are removed and `Boss Zapdos` is
   created after 33 s (line 47).
6. **Boss.** `monster/Quest/boss zapdos.xml` registers `bossZapdosHealthChange` and
   `legendaryDeath` (lines 34-37, `creaturescripts.xml:41-42`). On death, `legendaryDeath.lua`
   creates chest 18744 with attribute `1000 = 1` (Zapdos), grants
   `LEGENDARY_BIRD_BATTLE`, and unblocks logout (lines 24-31).
7. **Reward.** `actions.xml:173` → `legendaryChest.lua`. `REWARDS_BY_VALUE[1]` is given once
   (storage 8370 → `FINISHED`). Otherwise the player sees `It's empty.`. Either way the player
   goes to the temple and the chest is removed (lines 36-47).

To copy this pattern you need: new orb and statue item ids, a `Dungeons.<Name>.doReset`, an
`ORBS[...]` entry, a puzzle script and registration, a boss monster with a death script, and
a chest value. Each of these is an item (`CHECKLISTS.md`) or an event registration
(`add-command.md` §1 explains how the XML registries work).

## 6. Required IDs and how to find free ones

* **Dungeon id**: the next integer after `MASTERYDUNGEONID_ELECTRICSTEEL = 11` → **12**.

  ```bash
  grep -n 'MASTERYDUNGEONID_[A-Z]* = ' server/data/lib/ps/systems/014-mastery.lua
  ```

* **Two global storages**: the mastery dungeons use 6000-6021 in pairs. The next pair is
  **6022 / 6023**. Make sure nothing else uses them:

  ```bash
  grep -rnwE '602[23]' server/data --include=*.lua | grep -v 'x = \|y = '
  ```

  (no output today). Do not use 6100-6105; they belong to the World Boss levels
  (`021-boss.lua:10-31`).
* **Monster names** must be unique in `monsters.xml`:
  `grep -n 'name="Dungeon Dragonair"' server/data/monster/monsters.xml`.
* **Use monster names that no other dungeon uses.** The clean-up removes creatures by nickname
  across the whole server (§15). Several existing names are shared already:

  ```bash
  sed -n '514,894p' server/data/lib/ps/systems/014-mastery.lua | grep -o '"Dungeon [^"]*"' | sort | uniq -d
  ```

  This prints `Dungeon Cloyster`, `Dungeon Dewgong`, `Dungeon Golbat`, `Dungeon Lapras`,
  `Dungeon Onix`, `Dungeon Poliwrath`, `Dungeon Rhydon`.

## 7. Related dependencies

* Each `pokemons` entry and boss form needs a Pokémon config for its XML `name` (moves come
  from it). The regular monsters use the base name (`name="Raichu"`), so the existing config
  is reused. `Shiny <Name>` entries are generated automatically from `POKEMON[<Name>]`
  (`lib/ps/config/pokemon.lua:24-45`), so the `Shiny …` boss forms need no file either.
* `checkPlayerPokemon` in the NPC script decides which Pokémon may enter
  (`mastery_blaze.lua:211-212`): `You can only enter the dungeon carrying Pokemon with Mastery %s types and without Ditto!`.
* `TRADE_ROOM_POSITION` (`lib/ps/others/constants.lua:1`) is where a failed run teleports
  the player (`014-mastery.lua:974-975`). A completed run goes to the mastery
  `basePosition` (`1013`).

## 8. Example: a Dragon dungeon for the Hurricane mastery

Hurricane today only has `MASTERYDUNGEONID_ELECTRICSTEEL` (`014-mastery.lua:139`).

**8.1 Id** (after line 79):

```lua
MASTERYDUNGEONID_DRAGON = 12
```

**8.2 Start position and storages** (after line 497, inside `MASTERY_DUNGEONS`):

```lua
    [MASTERYDUNGEONID_DRAGON] = {startPosition = {x = 4900, y = 700, z = 7}, globalStorages = {user = 6022, cleanEvent = 6023}},
```

The position is a placeholder. Use a real walkable tile of your new area, checked in game
with `/goto 4900,700,7`.

**8.3 Clean-up list** (`MASTERY_DUNGEON_IDS`, before the closing `}` at line 512):

```lua
    MASTERYDUNGEONID_ELECTRICSTEEL,
    MASTERYDUNGEONID_DRAGON
}
```

Without this, `start.lua` never resets storages 6022/6023. After a crash during a run, the
dungeon then stays "busy" forever.

**8.4 Spawns** (inside `DUNGEON_RESPAWNS`, before its closing `}` at line 894):

```lua
    [MASTERYDUNGEONID_DRAGON] = {
        pokemons = {"Dungeon Dragonair", "Dungeon Seadra Dragon"},
        spawns = {
            {x = 4905, y = 702, z = 7},
            {x = 4910, y = 706, z = 7},
            {x = 4915, y = 700, z = 7},
        },
        boss = {name = "Dungeon Boss Dratini Dragon", position = {x = 4920, y = 704, z = 7}}
    },
```

**8.5 Use it** (`014-mastery.lua:139`):

```lua
        dungeons = {MASTERYDUNGEONID_ELECTRICSTEEL, MASTERYDUNGEONID_DRAGON},
```

**8.6 Monsters.** Copy `monster/Dungeons/ElectricSteel/dungeon raichu.xml` to
`monster/Dungeons/Dragon/dungeon dragonair.xml` and change line 2 so that `name` is the base
Pokémon and `nickname` equals the `monsters.xml` name:

```xml
<monster name="Dragonair" nameDescription="a Dragonair" nickname="Dungeon Dragonair" race="blood" experience="0" speed="300" manacost="0" minLevel="50" maxLevel="60">
```

Also change the `look type` and `corpse` to the Dragonair values from
`monster/Pokemons/dragonair.xml`. For the boss chain, copy the two ElectricSteel boss files,
give them names that are **not** already in `dungeonEvolve.lua` (for example, the boss
`name="Shiny Dratini"` is taken by the Flying dungeon at `dungeonEvolve.lua:10`), and add the
mapping:

```lua
    ["Shiny Seadra"] = "Dungeon Boss Kingdra Dragon",
```

The final form must have `<event name="dungeonEnd"/>`.

Register every file (`monsters.xml`, Dungeons block):

```xml
			<monster name="Dungeon Dragonair" file="Dungeons/Dragon/dungeon dragonair.xml"/>
			<monster name="Dungeon Seadra Dragon" file="Dungeons/Dragon/dungeon seadra.xml"/>
			<monster name="Dungeon Boss Dratini Dragon" file="Dungeons/Dragon/dungeon boss seadra.xml"/>
			<monster name="Dungeon Boss Kingdra Dragon" file="Dungeons/Dragon/dungeon boss kingdra.xml"/>
```

`Dungeon Boss Dratini Dragon` here points at a Shiny Seadra file. The `monsters.xml` name is
only the lookup key; the player sees the XML `name`/`nickname`. Choose clear names in your
own content. These ones only show which key goes where.

## 9. Registration steps

1. Build the area in the map (`edit-map-content.md`), including an exit.
2. Add the id, the `MASTERY_DUNGEONS` row, the `MASTERY_DUNGEON_IDS` entry, the
   `DUNGEON_RESPAWNS` entry and the `MASTERYS[...].dungeons` reference.
3. Create and register the monster files.
4. Add the `dungeonEvolve.lua` mapping(s).
5. Validate (§13) and restart the server.

## 10. Database requirements

None. The dungeon state lives in `global_storage` (keys 6022/6023) and `player_storage`
(7037, 7038, 8053-8055). Both are created by the base schema.

## 11. Client requirements

None, if the monsters reuse existing look types. New map tiles or items need the client
sprites (`add-client-asset.md`).

## 12. Server requirements

* `worldType = "pvp"` (BUG-01).
* A player in the mastery, at a rank with a `next` rank (`getMasteryRankNext`), with tokens
  paid. See §14 for a test setup.

## 13. Validation steps

```bash
bash tools/check_syntax.sh
python3 tools/check_references.py > /tmp/refs-after.txt
grep -n 'Dungeons/Dragon' /tmp/refs-after.txt     # empty: every file exists and its events resolve
grep -c 'MASTERYDUNGEONID_DRAGON' server/data/lib/ps/systems/014-mastery.lua   # 5 (definition, MASTERY_DUNGEONS, IDS, RESPAWNS, MASTERYS)
```

Start-up console:

```
>> Cleaning Mastery Dungeons...
> Done in 0.00 seconds
```

A missing `DUNGEON_RESPAWNS` or `MASTERY_DUNGEONS` entry does not fail at start-up. It fails
the first time the dungeon is picked, with an `[Error - Npc interface]` trace
`attempt to index field '?' (a nil value)` from `014-mastery.lua`.

## 14. Test steps

GM Pokémon cannot use moves (BUG-05). Use Tester with a Pokémon of a Hurricane type
(Flying or Dragon, `014-mastery.lua:138`).

1. **Monster names**, as GM Admin: `/m Dungeon Dragonair`, then each boss form. Each must
   appear; `Sorry, not possible.` means the name is not in `monsters.xml`.
2. **Tiles**: `/goto` the start position and each spawn position. Each must be walkable.
3. **Prepare Tester** (server stopped, see `database-changes.md` for why):

   ```sql
   -- 20 = VOCATIONID_HURRICANESTARTER (014-mastery.lua:20); its next rank is HURRICANEWIND (21)
   UPDATE players SET vocation = 20 WHERE name = 'Tester';
   ```

   Then start the server and, as GM Admin:
   * `/storage Tester,8054,20`: tokens paid for this rank (`014-mastery.lua:407`);
   * `/storage Tester,7038,-1`: clears the 24-hour wait (`mastery_blaze.lua:214-216`).
4. As Tester, talk to the Hurricane mastery NPC: `hi`, `dungeon`, `yes`. Expected:
   `The dungeon will automatically end on 60 minutes, be fast!` (`014-mastery.lua:998`).
   Because the dungeon is picked at random from the free ones (`989`), you may land in
   ElectricSteel. Leave (logout) and try again, or temporarily list only your dungeon.
5. Check as GM Admin that the monsters exist at your spawns (`/goto`).
6. Kill the boss chain. Expected: the first form evolves; when the last dies,
   `Congratulations, you won the dungeon!`, and you are teleported to the mastery base.
7. Fail path: start again (reset 7038), then log out. Log back in; you are at
   `TRADE_ROOM_POSITION`. Storage 6022 must be 0 again. Check it in the database after a
   server save, or simply start the dungeon again.

## 15. Common mistakes

* Forgetting `MASTERY_DUNGEON_IDS`. The dungeon works until a crash, then it stays occupied.
* Reusing a storage pair. Two dungeons then share one "busy" flag.
* `nickname` ≠ `monsters.xml` name. Clean-up never finds the monsters, so they pile up with
  every run.
* Sharing monster names with another dungeon. Known defect: `doMasteryDungeonSpawnClear`
  (`014-mastery.lua:942-954`) removes creatures by nickname **globally**. Starting or ending
  the Water dungeon also removes `Dungeon Lapras`, `Dungeon Cloyster` and `Dungeon Dewgong`
  from a running Ice dungeon (lines 725 and 857).
* Expecting the boss to be cleaned. Known defect: the clean-up only walks `pokemons`
  (line 943). A boss left alive after a timeout or logout stays, and the next run adds a
  second one. Its nickname (`Elite …`) is not in `pokemons`.
* A boss form without `dungeonEvolve` or `dungeonEnd`. Killing it then ends nothing; the
  player waits for the 60-minute timer.
* Placing spawns on blocked tiles. `doSummonCreature(..., false)` fails silently.

## 16. Failure symptoms

| Symptom | Cause |
|---------|-------|
| NPC: `There is no dungeon avaiable, please try again later.` | All dungeons of the mastery are busy (storage `user` ≠ 0), or the mastery's `dungeons` list is wrong |
| NPC: `You can't do the dungeon right now, please try again later.` | The teleport to `startPosition` failed |
| `[Error - Npc interface]` … `014-mastery.lua` … `attempt to index` | `MASTERY_DUNGEONS` or `DUNGEON_RESPAWNS` entry missing for the id |
| Dungeon empty after the teleport | wrong `pokemons` names, or blocked spawn tiles |
| `[Warning - Monster::Monster] Unknown event name - dungeonEnd` | the event name in the boss XML is misspelled |
| `[Warning - Monsters::loadMonster] Cannot load monster (…) file (…).` | wrong `file=` path; Linux paths are case-sensitive |
| Boss vanishes in an evolve cloud, nothing appears, and about 9.5 s later a Lua error from `doCreateWildPokemon` | the boss has `dungeonEvolve`, but its creature `name` is not a key in `EVOLVES`, so `doPokemonEvolve(cid, nil)` runs (`lib/ps/functions/pokemon.lua:175-213`) |
| Boss dies with a corpse, the dungeon does not end | the last form has neither `dungeonEvolve` nor `dungeonEnd` |

## 17. Rollback advice

* `git revert` / `git checkout --` the Lua and monster changes together. If you only remove
  the id from `MASTERYS[...].dungeons`, players are no longer sent there; that is the
  smallest safe rollback.
* `014-mastery.lua` is a `lib/` file. `/reload npcs` reloads the NPC interface (and with it
  the lib) for NPCs. Creature scripts and global events keep the old copy until restart.
  **Restart the server** after any dungeon change.
* Leftover monsters from a broken run disappear on restart. If storages 6022/6023 hold a
  stale player id, the start-up clean-up resets them, as long as the id is in
  `MASTERY_DUNGEON_IDS`.
