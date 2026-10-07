# Add an NPC

This tutorial adds a simple talking NPC (no battle, no quest) and places it on the map. It
uses two real NPCs as models: **Nurse Joy** (a custom script) and **Jack Simps** (a shared
script that only reads parameters from the XML).

All paths are relative to `server/` unless they start with `docs/`, `tools/` or `client/`.

---

## 1. How the server finds an NPC

There are three links in the chain, and all three must match exactly:

```
data/world/map-spawn.xml        <npc name="Jack Simps" .../>
        │  name → file name (case-sensitive on Linux)
        ▼
data/npc/Jack Simps.xml         <npc name="Jack Simps" script="quest_default.lua" ...>
        │  script without "/" → data/npc/scripts/<script>
        ▼
data/npc/scripts/quest_default.lua
```

* `Npc::Npc` builds the file name as `"npc/" + name + ".xml"` (`src/npc.cpp:77`). On Linux
  `Jack simps` and `Jack Simps` are different files.
* A `script` value that contains no `/` is resolved under `data/npc/scripts/`
  (`src/npc.cpp:387-388`).
* The `name` attribute inside the XML overrides the spawn name (`src/npc.cpp:190-191`). That
  name is what `getNpcName()` returns in Lua, and what other systems use as a key (quests,
  NPC battles).
* **All NPCs share one Lua state** (`Npc::m_interface`, `src/npc.cpp:45` and `106-109`). The
  state loads `data/npc/lib/npc.lua`, and through the global `data/lib/` loader also the whole
  PSoul library (`data/lib/999-ps.lua` → `lib/ps/systems/*`). A non-`local` variable in your
  script is therefore visible to every other NPC. Always declare script-level values with `local`.

---

## 2. Files to edit

| File | Why |
|------|-----|
| `data/npc/<Name>.xml` | new file: name, look, script, parameters |
| `data/npc/scripts/<script>.lua` | new file, **only** if no existing shared script fits |
| `data/world/map-spawn.xml` | places the NPC on the map (or place it with RME, see `edit-map-content.md`) |
| `pt_br.loc` | optional: Portuguese translations of the lines you pass through `__L()` |

## 3. Files NOT to edit

* `data/lib/ps/config/_pokemon/`, `data/lib/ps/others/pokemon_backup/`,
  `data/lib/ps/others/moves_disabled/`, `data/lib/ps/systems/disabled/`, `data/lib/disabled/`,
  `data/npc/backup/`: historical copies. Nothing loads them.
* `original/`: the untouched archive (`original/README.md`: "Nothing in this directory is
  ever edited").
* `data/npc/tmpCitizen_*.xml`: generated at every start by `lib/ps/systems/027-citizens.lua`
  (`FILE_PREFIX = "tmpCitizen_"`, line 11). They are not tracked by Git, and any edit is
  overwritten on the next start.
* `data/world/-spawn.xml`, `data/world/-house.xml`: unused. The map header points to
  `map-spawn.xml` / `map-house.xml` (confirmed by `tools/check_references.py`: "map.otbm spawn
  file map-spawn.xml").
* `data/lib/ps/config/003-quest.lua.bak`: dead backup.

## 4. Authoritative source paths

| What | Where |
|------|-------|
| NPC XML loader | `src/npc.cpp:165-391` (`Npc::loadFromXml`) |
| NPC spawn loader | `src/spawn.cpp:182-215` |
| NPC conversation framework | `data/npc/lib/npcsystem/npchandler.lua`, `keywordhandler.lua`, `modules.lua` |
| Localization table | `pt_br.loc`, loaded once at startup by `src/localization.cpp:295` |

## 5. Real examples

### 5.1 Nurse Joy: XML plus a custom script

`data/npc/Nurse Joy.xml` (complete file):

```xml
<?xml version="1.0" encoding="UTF-8"?>
<npc name="Nurse Joy" script="nurse_joy.lua" walkinterval="0" floorchange="0">
	<health now="100" max="100"/>
	<look type="560" head="0" body="0" legs="0" feet="0" addons="0"/>
	<voices>
		<voice text="Welcome to the Pokemon Center. We {restore} your tired Pokemon to full health. Just speak out 'hi' next to me!" interval2="10" margin="30000"/>
	</voices>
</npc>
```

| Attribute | Consumed by | Effect |
|-----------|-------------|--------|
| `name` | `npc.cpp:190` | display name, `getNpcName()` |
| `script` | `npc.cpp:186`, `387-391` | Lua file under `npc/scripts/` |
| `walkinterval` | `npc.cpp:222` | milliseconds between steps; `0` = stands still. Jack Simps uses `2000` |
| `floorchange` | `npc.cpp:225` | `0` = never uses stairs |
| `look type` | outfit id; must exist in the client `data.dat` (see `add-client-asset.md`) | |
| `voice text / interval2 / margin` | random shouting | |

The script `data/npc/scripts/nurse_joy.lua` contains the real logic: a position table
`CITY_BY_POS` (lines 105-151; Pewter is `{x = 3307, y = 296, z = 7}` at line 107), `getCity`
(line 153) and `tryHeal` (lines 165-211). If you copy Nurse Joy to a new Pokémon Center, the
new position **must** be added to `CITY_BY_POS`. Otherwise the default callback logs
`NurseJoy::ChangeCity - Unknown Nurse position.` (line 241).

### 5.2 Jack Simps: XML plus a shared script

`data/npc/Jack Simps.xml` (complete file):

```xml
<?xml version="1.0" encoding="UTF-8"?>
<npc name="Jack Simps" script="quest_default.lua" walkinterval="2000" floorchange="0">
	<health now="100" max="100"/>
	<look type="636" head="152" body="73" legs="75" feet="0" addons="0"/>
	<parameters>
		<parameter key="message_greet" value="Hello |PLAYERNAME|, can I help you?"/>
	</parameters>
</npc>
```

`quest_default.lua` (26 lines) is used by many NPCs. It sets a quest icon and hands every
message to the quest system (`doQuestTalk`, see `add-quest.md`). `message_greet` is read by
`NpcSystem.parseParameters(npcHandler)` (`quest_default.lua:5`). `|PLAYERNAME|` is replaced by
the NPC handler.

### 5.3 Minimal new NPC (example, not in the repo)

`data/npc/Ranger Liam.xml`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<npc name="Ranger Liam" script="ranger_liam.lua" walkinterval="0" floorchange="0">
	<health now="100" max="100"/>
	<look type="636" head="152" body="73" legs="75" feet="0" addons="0"/>
	<parameters>
		<parameter key="message_greet" value="Hello |PLAYERNAME|, the forest is dangerous today."/>
	</parameters>
</npc>
```

`data/npc/scripts/ranger_liam.lua`. The skeleton is the same as `quest_default.lua:3-10` and
`26`:

```lua
local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, function(cid, type, msg)
    if (not npcHandler:isFocused(cid)) then
        return false
    end

    if (msgcontains(msg, "forest") or msgcontains(msg, "floresta")) then
        selfSay(__L(cid, "Wild Pokemon are restless. Keep a Pokemon out of its ball."), cid)
    else
        selfSay("Ok..", cid)
    end
    return true
end)

npcHandler:addModule(FocusModule:new())
```

`msgcontains` matches whole words. Existing NPCs always accept the Portuguese keyword as well
(`'yes'` / `'sim'` in `npcbattle_chandrawigington.lua:27`).

## 6. Required IDs and how to find free ones

An NPC has no numeric id of its own. What must be unique is:

* **The name.** Check that no file exists:
  `ls "data/npc/Ranger Liam.xml"` must fail, and so must
  `grep -n 'name="Ranger Liam"' data/world/map-spawn.xml`.
* **The look type** must exist in the client. Reuse an id that other NPCs already use
  (`grep -ho 'look type="[0-9]*"' data/npc/*.xml | sort | uniq -c | sort -rn | head`).
* **Storages**, only if the script stores per-player state (see `add-quest.md` §6 for the free
  ranges).

## 7. Related dependencies

* `data/npc/lib/npcsystem/*` (`NpcHandler`, `KeywordHandler`, `FocusModule`).
* The PSoul library is loaded into the NPC Lua state, so `__L`, `selfSay`, `doQuestTalk`,
  `NpcBattle` and every `lib/ps/systems/*.lua` global are available.
* `setCreatureIcon(getNpcId(), CREATURE_ICONS.QUEST)` (`quest_default.lua:1`) shows the
  quest icon. `NpcBattle:new` sets `CREATURE_ICONS.BATTLE` automatically
  (`lib/ps/systems/001-npcBattle.lua:179-181`).

## 8. Registration steps

1. Create `data/npc/<Name>.xml`. Copy an existing file so the encoding header and layout match.
2. Create the script, or point `script=` at an existing shared script (`quest_default.lua`).
3. Add a spawn entry to `data/world/map-spawn.xml`. Format, using Jack Simps at
   `map-spawn.xml:30871-30873`:

   ```xml
   <spawn centerx="3934" centery="315" centerz="7" radius="1">
     <npc name="Jack Simps" x="-1" y="1" z="7" spawntime="60" level="0"/>
   </spawn>
   ```

   `x`/`y` are **offsets** from the centre, `z` is the **absolute** floor (`spawn.cpp:193-200`,
   the `+` is commented out: `placePos.z /*+*/= intValue`). Jack Simps therefore stands on
   `3933,316,7`. An optional `direction` (0 north, 1 east, 2 south, 3 west) is applied to
   NPCs **without validation** (`spawn.cpp:202-204`); keep it in 0-3. Read `add-spawn.md` for
   the full rules.
4. Optional: add `English text@Texto em português` lines to `pt_br.loc` for every string you
   wrap in `__L()`. Keep the file **ISO-8859-1** with CRLF line endings (`file pt_br.loc` →
   "ISO-8859 text … with CRLF line terminators"; `docs/TRANSLATION.md`: "do not re-save it as
   UTF-8").

## 9. Database requirements

None for a talking NPC. If the script uses `setPlayerStorageValue`/`doCreatureSetStorage`,
the values land in the stock `player_storage` table. No schema change is needed.

## 10. Client requirements

Only the outfit (`look type`) must exist in `client/data/things/data.dat`. Reusing an
existing look type needs no client change. A brand-new outfit is a client asset change; see
`add-client-asset.md`.

## 11. Server requirements

* New XML or script files are only read when the NPC is created. A running server picks them
  up through `/n <Name>` or `/reload npcs` (see §15). A new **spawn entry** needs a restart,
  because `/reload` has no spawn type (`talkactions/scripts/reload.lua:1-25`).
* Translations in `pt_br.loc` are read once at startup (`localization.cpp:295`), so they need
  a restart.

## 12. Validation steps

```bash
bash tools/check_syntax.sh                 # luac5.1 -p + xmllint over server/data
# expected last line: "Lua: N files, 0 with syntax errors; XML: M files, 0 malformed"

python3 tools/check_references.py > /tmp/refs-after.txt
# compare the "REAL ERROR findings" list with a run you saved before the change;
# checks npc.script (XML → script file) and spawn.npc (spawn name → npc/<name>.xml)
```

Then start the server (`tools/start_server.sh`). A broken NPC prints one of these lines during
`>> Loading map and spawns...`:

* `[Warning - Npc::loadFromXml] Cannot load npc file (data/npc/Ranger Liam.xml).` means the
  file is missing or the name case differs. It is followed by the libxml2 error if the file
  exists but is malformed.
* `[Error - Npc::loadFromXml] Malformed npc file (…)` means the root element is not `<npc>`.
* `[Warning - NpcScript::NpcScript] Cannot load script: data/npc/scripts/ranger_liam.lua`
  (`npc.cpp:2911`) is followed by the Lua syntax error.

## 13. Test steps

Log in as **GM Admin** (`admin`/`admin`). The character starts in Pewter temple
`3307,300,7` (`docs/BUILDING.md` §8.3).

1. `/n Ranger Liam` (access 5, `talkactions.xml:63`, `talkactions/scripts/creature.lua`)
   creates the NPC next to you without touching the spawn file. If the name is wrong you get
   the default cancel message "Sorry, not possible.".
2. Say `hi` in the NPC channel. Expected: `Hello GM Admin, the forest is dangerous today.`
3. Say `forest`. Expected: `Wild Pokemon are restless. Keep a Pokemon out of its ball.`
4. Say `bye`. The FocusModule farewell is printed.
5. After adding the spawn entry, restart and `/goto` the spawn position. The NPC must be
   standing there.

With the probe tool (no GUI):

```bash
python3 -u tools/protocol_probe.py enter --account admin --password admin --character "GM Admin" \
  --say "/n Ranger Liam" --approach "Ranger Liam" --npc hi --npc forest
```

## 14. Common mistakes

* File name and spawn name differ in case (`Ranger liam.xml`). This works on Windows and
  fails on Linux.
* `script="scripts/ranger_liam.lua"`: the `/` disables the `npc/scripts/` prefix and the
  path becomes relative to the server directory.
* A global (non-`local`) variable such as `talkState = {}` in two NPC scripts. Both NPCs then
  overwrite each other's state, because they share one Lua state.
* Copying Nurse Joy without adding the new position to `CITY_BY_POS`.
* Setting `direction` outside 0-3 in the spawn. `spawn.cpp:203` checks the initial
  `direction` variable (always `SOUTH`, which passes) instead of the parsed value. Any number
  is therefore cast to a `Direction`, and values such as 7 give the NPC an invalid facing.
  (For **monsters** the same check starts from `NORTH` and always fails, so a monster's
  `direction` is ignored, `spawn.cpp:172-174`.)
* Editing `pt_br.loc` with a UTF-8 editor. Every accented character in the file becomes
  garbage.

## 15. Failure symptoms

| Symptom | Cause |
|---------|-------|
| `[Warning - Npc::loadFromXml] Cannot load npc file (…)` at startup | wrong name/case, or broken XML |
| NPC visible but never answers | script failed to load (`Cannot load script:` above it), or the callback returns `false` because `npcHandler:isFocused(cid)` is false (you did not say `hi`) |
| `[Error - Npc interface]` followed by the script path and `Description:` | Lua runtime error in your script (format from `luascript.cpp:801-809`) |
| `/n Name` answers "Sorry, not possible." | `doCreateNpc` returned `false`: the XML could not be loaded |
| Portuguese players see English text | the string is missing from `pt_br.loc`, the text differs by a single character, or the server was not restarted |

## 16. Rollback advice

* Uncommitted: `git restore server/data/npc/ server/data/world/map-spawn.xml` and
  `git clean -n server/data/npc/` (check the list), then `git clean -f <file>` for your new
  files. `git clean -f server/data/npc/` would also delete the generated `tmpCitizen_*.xml`
  files; that is harmless, because they are recreated on start.
* Committed: `git revert <commit>`.
* On a running server, `/reload npcs` re-reads the XML of NPCs that already exist
  (`Npcs::reload`, `npc.cpp:47-56`). It does **not** remove an NPC that was created from a
  spawn entry you deleted. Restart the server for a clean state.
