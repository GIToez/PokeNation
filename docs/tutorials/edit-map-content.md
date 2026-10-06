# Edit map content (tiles, spawns, houses)

The world is three files in `server/data/world/`:

| File | What | Format | Edited with |
|------|------|--------|-------------|
| `map.otbm` (≈130 MB) | tiles, items on tiles, towns, waypoints, house tiles | binary OTBM, **Git LFS** | Remere's Map Editor (RME) built from `tools/rme` |
| `map-spawn.xml` | monster and NPC spawns | XML | by hand (`add-spawn.md`), or RME |
| `map-house.xml` | house names, entries, rent, town, size | XML | by hand, or RME |

The two XML names come from the map header, not from `config.lua`. `config.lua` only sets
`mapName = "map"`. `src/iomap.cpp:188-209` reads the spawn and house file names out of
`map.otbm`. The header also records which editor wrote it:
`head -c 4096 server/data/world/map.otbm | strings` →
`Saved with Remere's Map Editor 1.1.9`, `map-spawn.xml`, `map-house.xml`.

Paths are relative to the repository root unless stated otherwise.

---

## 1. Rules

1. **Never run the RME.exe from the original archive.** `RME - PSoul/Remeres Map Editor By Senhor/RME.exe`
   and its DLLs were excluded on import as untrusted prebuilt binaries
   (`docs/SECURITY_AUDIT.md:21`, `docs/LARGE_FILES.md:18`). Build RME from `tools/rme/source`
   (§8.1).
2. **`map.otbm` is a Git LFS object** (`.gitattributes:2`). Run `git lfs pull` before
   editing, and commit it through LFS.
3. **One person edits the map at a time.** An OTBM file cannot be merged. Two branches that
   both change `map.otbm` mean one of the edits must be redone.
4. **Change spawns and houses in XML by hand** whenever possible. The text diff is reviewable;
   a 130 MB binary diff is not.

## 2. Files to edit

| Change | File |
|--------|------|
| ground, walls, decoration, teleports, doors, items lying on the map | `server/data/world/map.otbm` |
| new or moved spawn | `server/data/world/map-spawn.xml` (`add-spawn.md`) |
| house metadata | `server/data/world/map-house.xml` |
| new house area | `map.otbm` (house tiles carry the house id) **and** `map-house.xml` |
| items or scripts used by the new area | `server/data/actions/actions.xml`, `movements/movements.xml`, … (see the other tutorials) |

## 3. Files NOT to edit

* `server/data/world/-spawn.xml`, `-house.xml`: old copies (2014/2016) that nothing loads.
* `server/data/world/map-sound.xml` / `map-sound.xml.lua`: not part of this workflow.
* `tools/rme/data/854/items.otb` and `items.xml` without changing the server copies too. They
  are byte-identical today (`cmp tools/rme/data/854/items.otb server/data/items/items.otb` →
  no output). Keep them in sync.
* Anything under `original/`.
* `server/data/npc/tmpCitizen_*.xml`. They are generated.

## 4. Authoritative source paths

| Topic | Location |
|-------|----------|
| Map load | `server/src/map.cpp:44-77`: OTBM, then spawns, then houses, then the DB house sync |
| OTBM header and file names | `server/src/iomap.cpp:100-210` |
| Fatal errors | `map.cpp:48-51` → `> FATAL: OTBM Loader - <reason>` (reasons at `iomap.cpp:104-152`) |
| Houses file | `server/src/house.cpp:750-850` (`Houses::loadFromXml`) |
| House tables | `server/src/schemas/mysql.sql:228-279` (`houses`, `house_auctions`, `house_lists`, `house_data`); saved tiles `tiles` / `tile_items` (`281`, `294`) |
| RME data directory lookup | `tools/rme/source/gui.cpp:218-240` |
| RME client profile for 8.54 | `tools/rme/data/clients.xml:163-168` |
| RME sprite id reading | `tools/rme/source/graphics.cpp:424-437` |
| RME client file names | `tools/rme/source/client_version.cpp:441-442` (`Tibia.dat`, `Tibia.spr`) |
| Client assets | `client/data/things/data.dat`, `data.spr` (LFS), `data.otfi` |

## 5. Real examples

### 5.1 A house (`map-house.xml:3`)

```xml
  <house name="Hamlin House #01" houseid="1" entryx="3449" entryy="1469" entryz="7" rent="0" townid="11" size="33"/>
```

| Attribute | Read at (`house.cpp`) | Notes |
|-----------|----------------------|-------|
| `houseid` | `784-797` | must already exist as house tiles in `map.otbm`, otherwise `[Error - Houses::loadFromXml] Unknown house with id: <id>` |
| `entryx`/`entryy`/`entryz` | `800-819` | where `!house` actions and kicks put the player; 0/0/0 gives `[Warning - Houses::loadFromXml] House entry not set for: <name> (<id>)` |
| `name` | `809` | shown in game and in the DB |
| `townid` | `821` | a town id from the OTBM towns list |
| `size` | `826` | number of tiles (RME computes it) |
| `guildhall` | `831` | optional |
| `rent` | `837` | 0 everywhere in PSoul |

The file has 577 houses (`grep -c '<house ' server/data/world/map-house.xml`).

### 5.2 A spawn

See `add-spawn.md` §5. The live file has 19,295 `<spawn>` blocks.

## 6. Required IDs and how to find free ones

* **House id**: the next free number.

  ```bash
  grep -o 'houseid="[0-9]*"' server/data/world/map-house.xml | tr -dc '0-9\n' | sort -n | tail -1
  ```

  Assign the same id to the house tiles in RME.
* **Positions**: check that an area is empty before you build there. As GM Admin,
  `/goto x,y,z`. `/goto` moves you to the **closest free** tile
  (`server/data/talkactions/scripts/teleportto.lua:31`), so look at the ground where you
  land: a GM sees `Position: [X: …] [Y: …] [Z: …].` (`server/src/game.cpp:3685-3686`). If
  it is not exactly x,y,z, the tile is blocked or missing. `Cannot perform action.` means
  there is no free tile nearby.
* **Item ids** placed on the map must exist in `items.otb` **and** `items.xml`
  (`CHECKLISTS.md`, item section).

## 7. Related dependencies

* `items.otb` version: if RME saves with a different `items.otb`, the server stops with
  `> FATAL: OTBM Loader - The map was saved with a different items.otb version, an upgraded items.otb is required.`
  (`iomap.cpp:140`).
* Houses in the database: `map.cpp:66-67` (`updateHouses`, `updateAuctions`) syncs
  `map-house.xml` into the `houses` table, and `loadHouses`/`loadMap` (`map.cpp:71-72`) put
  saved house items back on their tiles. Moving or shrinking a house that already has
  saved items can leave items at the wrong place. On a dev database, clear that house first
  (`database-changes.md`).
* Everything scripted that refers to coordinates: NPC `CITY_BY_POS` (`add-npc.md`),
  dungeon positions (`add-dungeon.md`), boss spawns (`add-boss.md`), teleports in Lua. Moving
  map content can break these silently. Grep before you move anything:

  ```bash
  grep -rn 'x = 5107, y = 287' server/data/lib server/data/npc
  ```

## 8. Safe workflow

### 8.1 Build RME from source (once)

Requirements (`tools/rme/README.md`): a C++ compiler, CMake, wxWidgets ≥ 3.0 and Boost.

```bash
sudo apt-get install -y build-essential cmake libwxgtk3.2-dev libboost-all-dev   # package names vary by distribution
cd tools/rme
mkdir -p build && cd build
cmake ..
make -j"$(nproc)"
./rme
```

Run it from `tools/rme/build`. RME looks for `data/` next to the executable, in the current
directory, and one level up from both (`gui.cpp:218-240`), so `tools/rme/data/` is found as
`../data/`. If it is not found, RME shows `Could not find data directory.`

### 8.2 Point RME at the client files

RME looks for `Tibia.dat` and `Tibia.spr` (`client_version.cpp:441-442`). The client names
them `data.dat` and `data.spr`. Create a folder with links:

```bash
mkdir -p ~/rme-client-854
ln -sf "$PWD/client/data/things/data.dat" ~/rme-client-854/Tibia.dat
ln -sf "$PWD/client/data/things/data.spr" ~/rme-client-854/Tibia.spr
```

Select `~/rme-client-854` as the 8.54 client path in RME's preferences.

> **Known limitation (not verified at run time).** The signatures match the 8.54 profile
> (`data.dat` = `0x4B1E2CAA`, `data.spr` = `0x4B1E2C87`; `clients.xml:166`). However, the
> profile reads them as `datversion="7.8"` / `sprversion="7.0"` (`clients.xml:166-167`), and
> RME then reads 16-bit sprite ids (`graphics.cpp:428-436`). The PSoul client files are
> **extended**: `client/data/things/data.otfi` says `extended: true`, and `data.spr` holds
> 209,927 sprites in a 32-bit count. A 16-bit reader sees 13,319. Expect missing or wrong
> graphics. Making RME read these files needs a change in `tools/rme/source/graphics.cpp`
> (32-bit sprite count and ids for this profile). That is a source change and needs its own
> review. Until then, keep RME edits small and check every edit in the game client.

### 8.3 Edit

1. Start from an up-to-date branch: `git pull`, then `git lfs pull`.
   `ls -la server/data/world/map.otbm` must show about 130 MB. A file of about 130 **bytes** is
   an LFS pointer.
2. Make a local backup outside the repo:
   `cp server/data/world/map{.otbm,-spawn.xml,-house.xml} /tmp/map-backup/`.
3. Open `server/data/world/map.otbm` in RME with the 8.54 profile.
4. Make the tile changes. Do not "clean" or "convert" the map, and do not run the automatic
   border tools on large areas. Those touch thousands of tiles you did not mean to change.
5. **Save.** RME rewrites `map.otbm` **and** the spawn and house XML files.
6. Review the XML diffs:

   ```bash
   git diff --stat server/data/world/
   git diff server/data/world/map-house.xml | head -50
   git diff server/data/world/map-spawn.xml | head -50
   ```

   If RME reformatted the whole spawn file or dropped spawns (for example, creatures that are
   not in `tools/rme/data/854/creatures.xml`, which only lists stock creatures), restore the
   XML files from Git (`git checkout -- server/data/world/map-spawn.xml map-house.xml`) and
   make the spawn and house changes by hand.
7. Validate and test (§13, §14).
8. Commit (`git add server/data/world/map.otbm` stores it through LFS; check with
   `git lfs status`). Every commit of the map adds a new ~130 MB LFS object, so group map
   edits into few commits.

## 9. Registration steps

* Tiles: nothing to register. The map is loaded at start-up.
* New house: house tiles with the new id in RME → a `<house>` line in `map-house.xml` →
  restart. The `houses` table row is created by the sync (`map.cpp:66`).
* New spawn: `add-spawn.md`.
* Items with scripts placed on the map (levers, teleports, chests): register their item id,
  action id or unique id in `actions.xml` / `movements.xml`.

## 10. Database requirements

* Tiles and spawns: none.
* Houses: the `houses` table is synced from `map-house.xml` at every start. Ownership and
  saved house items live in `houses`, `house_lists`, `house_data` and `tile_items`. Do not
  delete or renumber a house that players own; move the owner first with a reviewed SQL file
  (`database-changes.md`).

## 11. Client requirements

* The OTClient reads the map from the server (protocol), not from `map.otbm`. New tiles do
  not need a client update, as long as every item id already has a sprite in `data.dat`.
* New item graphics: `add-client-asset.md`.

## 12. Server requirements

* `git lfs pull` done (§8.3 step 1).
* `server/data/items/items.otb` matches the one RME used.
* Restart after every map change. `/reload` has no map, spawn or house type
  (`server/data/talkactions/scripts/reload.lua:1-25`).

## 13. Validation steps

```bash
ls -la server/data/world/map.otbm                         # ~130 MB, not a pointer
xmllint --noout server/data/world/map-spawn.xml server/data/world/map-house.xml
python3 tools/check_references.py > /tmp/refs-after.txt    # spawns: monster names and NPC files
git lfs status                                             # map.otbm listed as an LFS object
```

Start-up console (server log):

```
>> Loading map and spawns...
> Map loading time: … seconds.
> Data parsing time: … seconds.
> Houses synchronization time: … seconds.
> Content unserialization time: … seconds.
```

There must be no `> FATAL`, no `> WARNING: Could not load spawn data.` /
`Could not load house data.`, and no new `[Error - Houses::loadFromXml]` lines.

## 14. Test steps

1. As GM Admin, `/goto` the changed area. Walk every new path and use every new door,
   stair and teleport.
2. Check the floor above and below with `/goto x,y,z±1`. The GM `/up` and `/down` commands are
   commented out (`talkactions.xml:95-96`); `/up` and `/down` are the PS flying commands
   (lines 29-30).
3. New house: as a player, stand in front of the door and say `/house buy`
   (`talkactions.xml:129`, `filter="word-spaced"`), or check
   `SELECT id, name, town, size FROM houses WHERE id = <id>;` after the start.
4. Log in with the **client**, not only the protocol probe, and look at the area. Missing
   sprites show as empty or garbage tiles.
5. Optionally run `python3 tools/smoke_test.py`. It needs a freshly seeded database
   (`tools/init_dev_database.sh --reset`) and plays the new-player path around Pewter, so it
   catches regressions in that area of the map.

## 15. Common mistakes

* Running `RME.exe` from the archive, or another prebuilt editor.
* Committing an LFS pointer: `git pull` without `git lfs pull`, then saving or copying the
  pointer over the map.
* Editing `-spawn.xml` instead of `map-spawn.xml`.
* Letting RME rewrite the spawn file and committing the full-file diff.
* Moving content that scripts refer to by coordinates.
* Using an RME item palette (`tools/rme/data/854/items.xml`) that differs from the server's
  `items.xml`.
* Forgetting the house XML when adding house tiles. The tiles exist, but the house has no
  name or entry.

## 16. Failure symptoms

| Symptom | Cause |
|---------|-------|
| `> FATAL: OTBM Loader - Could not open the file …map.otbm.` | missing file, or an LFS pointer instead of the map |
| `> FATAL: OTBM Loader - The map was saved with a different items.otb version, an upgraded items.otb is required.` | RME used another `items.otb` |
| `> FATAL: OTBM Loader - This map needs an updated items.otb.` | the map uses item ids newer than `items.otb` |
| `> WARNING: Could not load spawn data.` | `map-spawn.xml` missing or malformed: **no spawns and no NPCs** |
| `> WARNING: Could not load house data.` | `map-house.xml` missing or malformed |
| `[Error - Houses::loadFromXml] Unknown house with id: N` | XML entry without house tiles in the map |
| `[Warning - Houses::loadFromXml] House entry not set for: <name> (N)` | entry coordinates missing |
| RME: `Could not find data directory.` | RME started from a directory where neither `./data/` nor `../data/` exists |
| RME: `Could not open Tibia.dat.` / `Could not locate Tibia.dat and/or Tibia.spr…` | client path not set to the folder with the links (§8.2) |

## 17. Rollback advice

* Uncommitted: `git checkout -- server/data/world/` (LFS restores the old map), or copy back
  the backup from §8.3 step 2.
* Committed: `git revert <commit>`. It restores the previous LFS object. Pushing the revert
  does not upload the map again, because the old object is already on the server.
* Restart the server after any rollback. If the house sync already wrote new rows, they stay
  in `houses` but are ignored once the XML entry is gone. Remove them with a reviewed SQL file
  only if needed.
