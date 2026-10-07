# Add a spawn (wild Pokémon or NPC)

A spawn is a `<spawn>` block in `server/data/world/map-spawn.xml`. The server reads it once,
together with the map, at start-up. Wild Pokémon then respawn on a timer; NPCs are placed
once. The model is a real Rattata spawn (`map-spawn.xml:5815-5817`).

Paths are relative to `server/` unless stated otherwise.

---

## 1. The chain

```
server/data/world/map.otbm  header attribute "map-spawn.xml"  (src/iomap.cpp:188-197)
        │  RME 1.1.9 wrote this name into the map header
        ▼
src/map.cpp:56-57   loader->loadSpawns()  → "> WARNING: Could not load spawn data." on failure
        ▼
src/spawn.cpp
        Spawns::loadFromXml (51-83)    whole file; root must be <spawns>
        parseSpawnNode (85-222)        one <spawn>; skipped silently if centerx/y/z or radius is missing
          <monster …> (136-181) → Spawn::addMonster (447-…)
               g_monsters.getMonsterType(name)   case-insensitive (src/monsters.cpp:1621-1629)
          <npc …>     (182-216) → Npc::createNpc(name) → data/npc/<name>.xml   (add-npc.md)
        Spawns::startup (224-237)      place NPCs, spawn every monster once
        Spawn::checkSpawn (379-445)    respawn dead monsters after spawntime
        Spawn::spawnMonster (306-368)  1 in shinyAppearChance → "Shiny <name>" instead
                                       singleSpawn events, then the global "spawn" event
```

## 2. Files to edit

| File | What |
|------|------|
| `data/world/map-spawn.xml` | Add a `<spawn>` block before the closing `</spawns>` (the file ends at line 61756) |
| `data/monster/monsters.xml` | Only if the monster does not exist yet (`add-pokemon.md`) |
| `data/npc/<Name>.xml` | Only for NPC spawns (`add-npc.md`) |

## 3. Files NOT to edit

* `data/world/-spawn.xml` and `data/world/-house.xml`. They are old leftovers. The map header
  names `map-spawn.xml` and `map-house.xml` (check with
  `head -c 4096 server/data/world/map.otbm | strings` → `map-spawn.xml`, `map-house.xml`).
  `check_references.py` reports problems in `-spawn.xml` as `HISTORICAL`.
* `data/npc/tmpCitizen_*.xml`. They are generated at start-up by
  `lib/ps/systems/027-citizens.lua`.
* `data/world/map.otbm`, unless the tiles themselves must change (`edit-map-content.md`).
* `data/lib/ps/config/_pokemon/`, `data/lib/ps/others/pokemon_backup/`,
  `data/lib/ps/others/moves_disabled/`, `data/lib/ps/systems/disabled/`, `original/`.

## 4. Authoritative source paths

| Topic | Location |
|-------|----------|
| Spawn file name | the OTBM header (`src/iomap.cpp:188-197`), not `config.lua` |
| Parsing | `src/spawn.cpp:85-222` |
| Minimum spawntime | `MINSPAWN_INTERVAL 1000` (`spawn.cpp:36`) → `spawntime` must be **greater than** 1 s (lines 147-158) |
| Default interval | `DEFAULTSPAWN_INTERVAL 60000` (`spawn.cpp:37`). A spawn block is checked as often as its fastest monster (lines 462-463) |
| Monster level | `level` > 0 → fixed (`spawn.cpp:357-359`); 0 → random `minLevel`-`maxLevel` from the monster XML (`src/monster.cpp:65`) |
| Shiny chance | `shinyAppearChance = 8192` (`config.example.lua:337`, `src/configmanager.cpp:293`); roll at `spawn.cpp:310-312` |
| Respawns per check | `rateSpawn = 1` (`config.example.lua:257`), `spawn.cpp:433-434` |
| Leaving the area | `deSpawnRange = 2`, `deSpawnRadius = 25` (`config.example.lua:310-311`; `monster.cpp:1362-1378`) |
| Spawn hooks | `creaturescripts.xml:17-18`: `onSpawn.lua` (every monster), `onSingleSpawn.lua` (monsters that register it) |

### 4.1 Attributes

| Element | Attribute | Meaning | Source |
|---------|-----------|---------|--------|
| `<spawn>` | `centerx`, `centery`, `centerz` | centre (absolute). Alternative: `centerpos="x,y,z"` | `spawn.cpp:94-116` |
| `<spawn>` | `radius` | walking area around the centre. **Required**; without it the whole block is ignored, with no message | `118-121` |
| `<monster>` | `name` | the `monsters.xml` name (case-insensitive) | `139-145`, `455-460` |
| `<monster>` | `x`, `y` | **offsets** from the centre | `163-167` |
| `<monster>` | `z` | **absolute** floor. The `+` is commented out: `placePos.z /*+*/= intValue` | `169-170` |
| `<monster>` | `spawntime` (or `interval`) | seconds, > 1 | `148-159` |
| `<monster>` | `level` | 0 = random; > 0 = fixed | `176-178` |
| `<monster>` | `direction` | **ignored**. The check uses the variable's initial value `NORTH` and always fails | `172-174` |
| `<npc>` | `name`, `x`, `y`, `z` | as above; `name` = file name in `data/npc/` (case-sensitive) | `185-200` |
| `<npc>` | `direction` | applied **without validation** (initial value `SOUTH` passes the check). Use 0-3 | `202-204` |
| `<npc>` | `spawntime`, `level` | not read for NPCs | – |

## 5. Real example

`map-spawn.xml:5815-5817`:

```xml
  <spawn centerx="4162" centery="608" centerz="4" radius="1">
    <monster name="Rattata" x="1" y="0" z="4" spawntime="60" level="0"/>
  </spawn>
```

* The Rattata appears at `4163,608,4` (x offset +1, absolute z 4).
* It walks within 1 tile of the centre.
* It respawns 60 s after it is removed (killed, caught, or despawned).
* `level="0"` → a random level between `minLevel` and `maxLevel` of
  `monster/Pokemons/rattata.xml`.
* With probability 1/8193 it spawns as `Shiny Rattata` (`monsters.xml` contains that name).
  Monsters without a `Shiny …` entry simply spawn normally.

Statistics of the live file: 19,295 `<spawn>` blocks, 22,231 monsters and 1,021 NPCs. Almost
all use `radius="1"`, `spawntime="60"` and `level="0"`; 508 monsters use `level="100"`.

NPC example (`map-spawn.xml:30871-30873`, see `add-npc.md`):

```xml
  <spawn centerx="3934" centery="315" centerz="7" radius="1">
    <npc name="Jack Simps" x="-1" y="1" z="7" spawntime="60" level="0"/>
  </spawn>
```

## 6. Required IDs and how to find free ones

Spawns have no id. What you need is a **free, walkable position**:

1. In game, as GM Admin, `/goto x,y,z`. `/goto` moves you to the **closest free** tile
   (`server/data/talkactions/scripts/teleportto.lua:31`), so look at the ground where you
   land: a GM sees `Position: [X: …] [Y: …] [Z: …].` (`server/src/game.cpp:3685-3686`). If
   it is not exactly x,y,z, the tile is blocked or missing. `Cannot perform action.` means
   there is no free tile nearby.
2. Make sure no spawn already uses the same centre. Two blocks with the same centre both load
   at start-up (`checkDuplicate` is `false`, `spawn.cpp:76`), so the area gets twice the
   monsters:

   ```bash
   grep -n 'centerx="4170" centery="610" centerz="4"' server/data/world/map-spawn.xml   # empty = free
   ```

3. Check that the monster name exists:

   ```bash
   grep -in 'name="Rattata"' server/data/monster/monsters.xml
   ```

## 7. Related dependencies

* A monster in a spawn needs everything a wild Pokémon needs: a `monsters.xml` line, its
  XML file, and a `POKEMON[...]` config for moves (`CHECKLISTS.md`, Pokémon section).
* `onSpawn.lua` (`lib/ps/events/creaturescripts/onSpawn.lua:9-11`) gives every spawned monster
  a random special ability and a 1-in-4 chance to be "evolvable".
* Protection zones: monsters can be placed on PZ tiles at start-up (placement is forced,
  `spawn.cpp:324`, `330`), but they cannot attack there. Do not spawn in towns.

## 8. Example: three Rattata east of the real spawn

Add before `</spawns>`:

```xml
  <spawn centerx="4170" centery="610" centerz="4" radius="2">
    <monster name="Rattata" x="0" y="0" z="4" spawntime="60" level="0"/>
    <monster name="Rattata" x="1" y="1" z="4" spawntime="60" level="0"/>
    <monster name="Raticate" x="-1" y="1" z="4" spawntime="300" level="25"/>
  </spawn>
```

Keep the file's two-space indentation. `4170,610,4` is an example; check the tiles first
(§6). The Raticate is always level 25 and respawns after 5 minutes. The block is checked every
60 s, the shortest interval in it.

### 8.1 Alternative: a raid (timed, not permanent)

For an event spawn that should only appear sometimes, use a raid instead:
`data/raids/raids.xml` registers files such as `events/halloween.xml` (line 9). Raids are
started by their interval or manually with `/raid <name>` (access 5):
`Raid started.` or
`Could not execute raid. (Raid does not exist or other raid is already running)`.
Raids with `enabled="no"` (e.g. `Anniversary`, line 5) are still loaded and can be started
by name.

## 9. Registration steps

1. Make sure the monster (or NPC file) exists.
2. Add the `<spawn>` block.
3. Validate (§13).
4. **Restart the server.** There is no `/reload` type for spawns
   (`talkactions/scripts/reload.lua:1-25` has none; `/reload monsters` re-reads monster
   types, not spawns).

## 10. Database requirements

None.

## 11. Client requirements

None, if the monster's look type exists in the client.

## 12. Server requirements

The map must load. `map.otbm` is a Git LFS file; a 130-byte pointer file instead of the
~130 MB map means `git lfs pull` was not run (`edit-map-content.md` §4).

## 13. Validation steps

```bash
xmllint --noout server/data/world/map-spawn.xml     # or: bash tools/check_syntax.sh server/data/world
python3 tools/check_references.py > /tmp/refs-after.txt
grep -n 'map-spawn.xml' /tmp/refs-after.txt          # no new REAL "spawned monster not in monsters.xml"
grep -c '<spawn ' server/data/world/map-spawn.xml    # 19296 after adding one block
```

Start-up console, in the map section:

```
>> Loading map and spawns...
> Map loading time: … seconds.
> Data parsing time: … seconds.
```

There must be no new `[Spawn::addMonster]` or `[Warning - Spawns::loadFromXml]` lines.

## 14. Test steps

1. As GM Admin, `/goto 4170,610,4`. Three monsters stand around the centre: two Rattata and a
   level-25 Raticate (look at it to see the level).
2. As Tester (GM Pokémon cannot attack, BUG-05), defeat one Rattata. After about 60 s a new one
   appears at the same place. TFS 0.3.6 respawns even while players stand next to it
   (the player check `findPlayer` is commented out, `spawn.cpp:291-304`, `423-429`).
3. Defeat the Raticate. It comes back after about 300 s.
4. Wrong-entry test (local only): change one name to `Ratata`, restart, and look for
   `[Spawn::addMonster] Cannot find "Ratata"`. Then revert.

## 15. Common mistakes

* Treating `z` as an offset. `z="1"` puts the monster on floor 1, not one floor above the centre.
* Forgetting `radius`. The block disappears silently.
* `spawntime="1"` (or less). The monster is skipped with
  `[Warning - Spawns::loadFromXml] Rattata ( 04170 / 00610 / 004 ) spawntime cannot be less than 1 seconds.`
  (the check is `<=`, so 1 is also rejected).
* Expecting `direction` to turn a monster.
* Editing `-spawn.xml`. Nothing changes in game.
* Editing `map-spawn.xml` in RME **and** by hand at the same time. RME rewrites the whole file
  on save, so the hand edit is lost (`edit-map-content.md`).
* Saving with a different encoding or line ending. The file is plain ASCII with LF line ends
  (`file` → `XML 1.0 document, ASCII text`); keep it that way so that `git diff` shows only
  your lines.

## 16. Failure symptoms

| Symptom | Cause |
|---------|-------|
| `[Spawn::addMonster] Cannot find "<name>"` | name not in `monsters.xml` |
| `[Spawn::addMonster] NULL tile at spawn position (( 04170 / 00610 / 004 ))` (positions are zero-padded, `src/position.cpp:21-26`) | no tile there (wrong coordinates or floor) |
| `[Warning - Spawns::loadFromXml] <name> <pos> spawntime cannot be less than 1 seconds.` | `spawntime` ≤ 1 |
| `[Warning - Spawns::loadFromXml] Cannot open spawns file.` + an XML error | malformed XML. **No spawns and no NPCs load at all** |
| `> WARNING: Could not load spawn data.` | the file is missing or malformed |
| Monster missing, no message | missing `radius`/centre, or the tile is blocked at start-up (the next check retries) |
| Twice as many monsters as expected | a duplicate centre, or a second block on the same tiles |

## 17. Rollback advice

* `git checkout -- server/data/world/map-spawn.xml` (uncommitted) or `git revert <commit>`,
  then restart. `/reload` cannot remove spawns.
* Monsters that were spawned stay until the restart. On a dev server you can remove one with
  `/r` (access 5) while looking at it.
* Because a malformed spawn file removes **every** spawn and NPC, always run `xmllint` before
  you restart a shared server.
