# Add an NPC quest

PSoul quests are **data**: one Lua table per NPC in `data/lib/ps/config/003-quest.lua`,
interpreted by `data/lib/ps/systems/002-quest.lua`. An optional quest-log entry lives in
`data/XML/quests.xml`. The model is **Jack Simps** (bring 25 bitten apples).

Paths are relative to `server/`. Read `add-npc.md` first if the quest needs a new NPC.

---

## 1. The chain

```
NPC script (e.g. npc/scripts/quest_default.lua:21)
   doQuestTalk(cid, getNpcName(), msg, talkState)
        │  keyword "quest"/"mission"/"task"/"help"/"hi" (+ Portuguese)   002-quest.lua:27
        ▼
lib/ps/systems/002-quest.lua
   getCurrentQuest(pid, npcName) ── QUESTS[npcName]  ◄── dofile config/003-quest.lua (line 82)
   doQuestTalkStart → "(Start quest? {YES} or {NO})" / "(End quest? {YES} or {NO})"
   doQuestTalkEnd   → doPlayerStartQuest / canFinishQuest → doPlayerFinishQuest
        │
        ▼
player storage  quest.storage  -1 = UNSTARTED, 0 = STARTED, 1 = FINISHED  (003-quest.lua:16-20)
        │
        ▼
data/XML/quests.xml  <mission storageid="…">  → in-game quest log (src/quests.cpp)
```

The key in `QUESTS_CONFIG` is the **NPC name exactly as `getNpcName()` returns it**, which is
the `name` attribute of `npc/<Name>.xml`.

## 2. Files to edit

| File | Why |
|------|-----|
| `data/lib/ps/config/003-quest.lua` | the quest definition (inside `QUESTS_CONFIG = { … }`, starting at line 27) |
| `data/XML/quests.xml` | optional quest-log entry |
| `data/npc/<Name>.xml` | only if the NPC is new. Use `script="quest_default.lua"` unless it needs more |
| `data/world/map-spawn.xml` | only if the NPC is new |
| `pt_br.loc` | translations of every `talk_*` text (they go through `__L`) |

## 3. Files NOT to edit

* `data/lib/ps/config/003-quest.lua.bak`: dead backup, not loaded.
* `data/lib/ps/systems/002-quest.lua`: engine. The only data in it is `KEYWORDS[...]`
  (lines 28-77) for NPCs that need extra trigger words.
* `data/lib/ps/config/_pokemon/`, `others/pokemon_backup/`, `others/moves_disabled/`,
  `systems/disabled/`, `data/npc/backup/`, `original/`, `data/npc/tmpCitizen_*.xml`,
  `data/world/-spawn.xml`.

## 4. Authoritative source paths

| What | Where |
|------|-------|
| Constants (`REWARD_TYPE`, `QUEST_TYPE`, `QUEST_STATUS`) | `config/003-quest.lua:3-25` |
| Which quest an NPC offers now | `getCurrentQuest`, `systems/002-quest.lua:110-142` |
| Finish text with the requested items | `getQuestMessageFinish`, `144-165` |
| Requirement check per type | `canFinishQuest`, `178-242` |
| Start | `doPlayerStartQuest`, `244-278` |
| Remove items / give rewards | `doPlayerFinishQuest`, `280-365` |
| Start conditions | `canStartQuest`, `367-382` |
| Dialogue | `doQuestTalkStart` `384-443`, `doQuestTalkEnd` `445-469`, `doQuestTalk` `471-499` |
| Kill / catch counters | `doQuestDefeat` `501-512` (called from `events/creaturescripts/onKill.lua:4`), `doQuestCatch` `514-525` (called from `functions/ball/empty.lua:30`) |
| Quest log | `src/quests.cpp:22-66` (mission text), `160-255` (XML parser) |

## 5. Real example: Jack Simps

`config/003-quest.lua:28-43`:

```lua
    ["Jack Simps"] = {
        {
            storage = 8001,
            talk_questStarting = "Well, I'm doing some experiments and I need a few ingredients, do you want help me?",
            talk_questStarted = "Ok, the ingredients that I need are 25 bitten apples, back when you are with them.",
            talk_questFinishing = "You've got what I asked?",
            talk_questFinished = "Oh yeah, thank you, now I can finally finish my experiences.",
            talk_questFinishFail = "No..You do not have, go get the ingredients and return back to me.",
            talk_questDone = "Thanks, but, I have no missions for you now.",
            questType = QUEST_TYPE.BRING_ITEMS, -- Quest type
            questRequest = { 12115, 25 }, -- The request of the quest
            rewardItems = { { type = REWARD_TYPE.ITEM, id = 2152, count = 5 } }, -- The player reward after finish the quest
            rewardExp = 2000, -- The player exp reward after finish the quest
            requiredLevel = 10, -- Required level to do the quest
        }
    },
```

`data/XML/quests.xml:3-7` (the log entry for the same storage):

```xml
	<quest id="1" name="Around the continent" holder="true">
		<mission name="Quimic experience" storageid="8001" startvalue="-1" endvalue="1">
			<missionstate id="1" description="Help Jack Simps in him experience, get 25 apples bites and report back to him."/>
			<missionstate id="2" description="Congratulations! You helped a citzen of pokemon world and got your reward."/>
		</mission>
```

### 5.1 Every field and the code that reads it

| Field | Read at (`002-quest.lua`) | Notes |
|-------|---------------------------|-------|
| `storage` | `106-108`, `167-169` | per-player status. **Unique per quest** |
| `talk_questStarting` | `401`, `426` | shown after `(Start quest? {YES} or {NO})` |
| `talk_questStarted` | `262` | said when the player accepts |
| `talk_questFinishing` | `145` | shown after `(End quest? {YES} or {NO})`, followed by the request in brackets, e.g. `(25 bitten apple)` (`146-164`) |
| `talk_questFinished` | `360` | said on success |
| `talk_questFinishFail` | `459` | said when `canFinishQuest` is false |
| `talk_questDone` | **never read**: the call is commented out at line 440 | the NPC always says `Sorry, I can't help you right now.` when nothing is left |
| `questType` | `146-164`, `193-239`, `282-313` | see 5.2 |
| `questRequest` | same | format depends on `questType` |
| `counterStorage` | `271-273` (reset to 0 on start), `219`, `227`, `504-506`, `517-519` | required for `DEFEAT_POKEMON` and `CATCH_POKEMON`. **Unique** |
| `rewardItems` | `316-342` | list of `{ type = REWARD_TYPE.*, … }` |
| `rewardExp` | `345-348` | plain experience points |
| `requiredLevel` | `374`, `395-396` | `Sorry, you need at least level %s to accept this mission.` |
| `daily` | `121-134`, `181`, `254-260`, `350-356`, `376`, `415-434` | status becomes `os.time()`. Repeatable after the next server start (`GLOBAL_STORAGES.SERVER_START_TIME`) |
| `startPosition` / `finishPosition` | `136`, `189`, `368`, `390`, `406` | only an NPC standing on exactly that tile offers/accepts the quest. Used when the same NPC name is spawned in several places |
| `canStart(cid)` | `120` | function; quest skipped when it returns false |
| `canFinish(cid)` | `185` | function |
| `blockStart` | `120` | `true` = never offered by talk (started from another script with `doPlayerStartQuest(pid, nil, npcName, storage)`) |
| `questStartItems` | `265-269` | `{ id, count, … }` given as **unique** items when the quest starts |
| `onStart(cid)` / `onEnd(cid)` | `275-277`, `362-364` | functions |

### 5.2 `questType` and `questRequest`

| `QUEST_TYPE` | Value | `questRequest` format | Check (`canFinishQuest`) | Removed on finish |
|--------------|-------|-----------------------|--------------------------|-------------------|
| `BRING_ITEMS` | 0 | `{ itemid, count, itemid, count, … }` | `getPlayerItemCount` ≥ count for every pair (`193-199`) | yes (`282-288`) |
| `BRING_POKEMON` | 1 | `"Pokemon Name"` | a ball with that Pokémon that is **not** unique-owned (`201-213`); the Pokémon must be in its ball | the ball (`289-299`) |
| `DEX_POKEMONS` | 2 | number | `getPlayerTotalDexedPokemons ≥ n` (`215-216`) | nothing |
| `DEFEAT_POKEMON` | 3 | `{ "Pokemon Name", count }` | `counterStorage ≥ count` (`218-219`). **One species only** (comment at `003-quest.lua:12`) | nothing |
| `CATCH_POKEMON` | 4 | `{ "Pokemon Name", count }` | counter **and** `count` plain balls of that species in the bag (`221-235`) | those balls (`300-313`) |
| `CUSTOM` | 5 | `function(cid) return bool end` | the function (`237-238`) | nothing |

### 5.3 Reward entries

```lua
{ type = REWARD_TYPE.ITEM, id = 2152, count = 5 }                       -- 2152 = "note of hundred dollars" (items.xml:1603)
{ type = REWARD_TYPE.ITEM, id = 18754, count = 1, unique = true }       -- unique item (config/003-quest.lua:5160)
{ type = REWARD_TYPE.POKEMON, name = "Pikachu", level = 10, unique = true }
{ type = REWARD_TYPE.ADDON, female = { looktype = 1200, addons = 0 }, male = { looktype = 1201, addons = 0 } }  -- 003-quest.lua:337
```

`ITEM` uses `doPlayerSafeAddItem` (`319`), which drops the item to the depot if the bag is
full. `POKEMON` always creates a **Poké Ball** (`"poke"`, lines 325/327). `ADDON` sends
`Congratulations! You got a new outfit.` (line 339).

## 6. Required IDs and how to find free ones

| ID | Rule | Next free value when this was written |
|----|------|---------------------------------------|
| `storage` | unique player storage | `config/003-quest.lua:1` says `-- LAST STORAGE: 8755`. **8756** is free |
| `counterStorage` | unique player storage | **8757** |
| quest-log `<quest id>` | unique in `quests.xml` | highest is `90` (Rusty Barret, line 1794), so **91** |

Verify before use. Storages have no registry, and the same numbers appear as item ids in
`items.xml`, so restrict the search to Lua:

```bash
cd server/data
grep -rnw --include=*.lua -e 8756 -e 8757 . | grep -v -e _pokemon/ -e pokemon_backup/ -e '\.bak'
grep -o '<quest id="[0-9]*"' XML/quests.xml | grep -o '[0-9]*' | sort -n | tail -1
```

Then update the `-- LAST STORAGE:` comment on line 1 of `003-quest.lua`. The header of
`002-quest.lua:1` (`-- LAST STORAGE: 8397`) is stale; ignore it.

Values to avoid: `2` is `QUEST_STATUS.ERROR` (`003-quest.lua:20`). A quest storage that some
other script sets to `2` makes `getCurrentQuest` skip the quest forever (`002-quest.lua:118`).

## 7. Related dependencies

* The NPC script must call `doQuestTalk`. `quest_default.lua` does. A trainer can do it after
  being beaten (`npcbattle_brock.lua:60-61`).
* Item ids in `questRequest`/`rewardItems` must exist in `data/items/items.xml`
  (`12115` = "bitten apple", `2152`).
* Pokémon names must be valid `POKEMON[...]` keys (`lib/ps/config/pokemon/*.lua`) and
  `monsters.xml` names.
* `DEFEAT_POKEMON` relies on the `onKill` creature event (`creaturescripts.xml:6`).
  `CATCH_POKEMON` relies on the ball code (`functions/ball/empty.lua:30`).

## 8. Example: a new defeat quest

New NPC **Ranger Liam** (`add-npc.md` §5.3, but with `script="quest_default.lua"`). Add to
`QUESTS_CONFIG` in `003-quest.lua`, next to the other NPC entries:

```lua
    ["Ranger Liam"] = {
        {
            storage = 8756,
            counterStorage = 8757,
            talk_questStarting = "Rattatas are eating the forest berries. Can you scare 10 of them away?",
            talk_questStarted = "Thank you! Come back when you have defeated 10 Rattata.",
            talk_questFinishing = "Did you defeat them?",
            talk_questFinished = "The berries are safe again. Take this.",
            talk_questFinishFail = "Not yet, I still hear them.",
            talk_questDone = "",
            questType = QUEST_TYPE.DEFEAT_POKEMON,
            questRequest = { "Rattata", 10 },
            rewardItems = { { type = REWARD_TYPE.ITEM, id = 2152, count = 2 } },
            rewardExp = 1000,
            requiredLevel = 5,
        },
    },
```

Quest-log entry at the end of `data/XML/quests.xml` (before `</quests>`):

```xml
	<quest id="91" name="Forest Patrol" startstorageid="8756" startstoragevalue="0">
		<mission name="Berry thieves" storageid="8756" startvalue="0" endvalue="1">
			<missionstate id="0" description="Defeat 10 Rattata for Ranger Liam."/>
			<missionstate id="1" description="This mission is done."/>
		</mission>
	</quest>
```

How the log picks the text (`src/quests.cpp:40-66`): if `value ≥ endvalue`, the **last**
state is shown. Otherwise it shows `missionstate id = value − startvalue`. That is why Jack
Simps (`startvalue="-1"`) numbers its states `1` and `2`, and the example above
(`startvalue="0"`) numbers them `0` and `1`. `holder="true"` (Jack Simps' "Around the
continent") makes a quest that is always shown and never completed (`quests.cpp:83-85`, `93-95`).

## 9. Registration steps

1. Choose the storages (§6). Write the table entry and bump `-- LAST STORAGE:`.
2. Make sure the NPC exists and is spawned (or use `/n` for testing).
3. Optional: add the quest-log entry.
4. Optional: add all `talk_*` strings to `pt_br.loc` (ISO-8859-1, CRLF).
5. If the NPC needs trigger words other than the defaults (`002-quest.lua:27`), add a
   `KEYWORDS["Ranger Liam"] = { … }` line next to the existing ones (lines 28-77).

## 10. Database requirements

None. Quest state is in `player_storage`.

## 11. Client requirements

None. The quest log uses the standard quest-log packets and the `game_questlog` module.

## 12. Server requirements

The quest table is part of `data/lib/`, which is loaded **separately into every Lua state**
(NPCs, creature scripts, actions, …). After editing `003-quest.lua` on a running server:

| Reload | Updates |
|--------|---------|
| `/reload npcs` | dialogue, start/finish, rewards (the NPC state is rebuilt) |
| `/reload creaturescripts` | `DEFEAT_POKEMON` counting (`onKill`) |
| `/reload actions` | `CATCH_POKEMON` counting (ball use) |
| `/reload quests` | `quests.xml` (the log) |

If in doubt, restart. A restart is required for new spawns and for `pt_br.loc`.

## 13. Validation steps

```bash
bash tools/check_syntax.sh                       # a missing comma in 003-quest.lua breaks ALL quests
python3 tools/check_references.py > /tmp/refs-after.txt
#   check "quest.npc.unspawned": quest NPC has an XML but is not in map-spawn.xml …
#   diff the REAL ERROR list with your baseline
```

At startup a syntax error in `003-quest.lua` appears once per Lua state that loads `lib/`, as
an error naming `data/lib/ps/config/003-quest.lua` with the line number. Every quest NPC then
answers `Hmm?` or nothing.

## 14. Test steps

As Tester (level ≥ 5). Use GM Admin for `/n` and `/storage`.

1. GM Admin: `/n Ranger Liam` next to Tester (or `/goto` the spawn).
2. Tester, NPC channel: `hi` → greet; `quest` → `(Start quest? {YES} or {NO})` followed by the
   `talk_questStarting` text.
3. `yes` → `Thank you! Come back when you have defeated 10 Rattata.`
   GM: `/storage Tester,8756` → ` [Tester - 8756] = 0`.
4. GM: `/m Rattata` ten times near Tester (outside a protection zone). Defeat them. Each
   kill prints `Defeat Task: Rattata - step complete [1/10].` … `[10/10].`
5. `quest` → `(End quest? {YES} or {NO})` and `Did you defeat them? (10 Rattata)`.
6. `yes` → `The berries are safe again. Take this.` plus `+EXP!`. Storage `8756` = `1`.
7. `quest` again → `Sorry, I can't help you right now.`
8. Open the quest log: "Forest Patrol" shows "This mission is done.".
9. Reset: `/storage Tester,8756,-1` and `/storage Tester,8757,-1`.

## 15. Common mistakes

* Key typo: `["Ranger liam"]` vs NPC name `Ranger Liam`. The NPC answers
  `Sorry, I can't help you right now.`, and `Quest:getCurrentQuest - Unkown NPC.` is logged
  (`002-quest.lua:112`, file `server/logs/Error - <date>.log`).
* Reusing a storage from another quest. Daily quests deliberately share storages per NPC
  (e.g. `8080`/`8082`/`8084`/`8195`); normal quests must not.
* `DEFEAT_POKEMON` without `counterStorage`. `getCreatureStorage(pid, nil)` fails during the
  kill callback.
* Expecting shiny or summoned Pokémon to count. `doQuestDefeat` compares the exact creature
  name (`"Shiny Rattata"` ≠ `"Rattata"`), and `onKill.lua:3` skips summons.
* Two species in one `DEFEAT_POKEMON`/`CATCH_POKEMON` request. Only `questRequest[1]` and
  `[2]` are read.
* `startPosition` that does not match the NPC tile exactly → `Sorry, I can't help you.`
* Expecting `talk_questDone` to be said. It never is.
* Missing `daily` behaviour: a daily quest's status is a timestamp, so `/storage` shows a
  10-digit number, not `1`.
* Putting the quest-log mission state ids on the wrong base (see §8).

## 16. Failure symptoms

| Player sees | Cause |
|-------------|-------|
| `Hmm?` | message did not contain a keyword (`002-quest.lua:497`), or `yes` without a pending question (`463`) |
| `Sorry, I can't help you right now.` | no startable quest: all done, `canStart` false, `blockStart`, wrong `startPosition`, or an unknown NPC key |
| `Sorry, I can't help you.` | `startPosition`/`finishPosition` mismatch, or `canStartQuest` false (e.g. level dropped) |
| `Sorry, you need at least level %s to accept this mission.` | `requiredLevel` |
| `talk_questFinishFail` text | requirement not met; for `BRING_POKEMON`/`CATCH_POKEMON` also `Before you complete this mission you need to call your Pokemon back.` |
| `You have done this mission in the last 24 hours, you must wait %s minutes to be able to do it again.` | daily quest already done since the last server start |
| Log: `Quest::doPlayerFinishQuest - Can't remove player item.` | the item vanished between check and removal (rare) |
| Quest log: `Couldn't retrieve any mission description, please report to a gamemaster.` | storage value has no matching `missionstate id` (§8) |

## 17. Rollback advice

* `git restore server/data/lib/ps/config/003-quest.lua server/data/XML/quests.xml`, or
  `git revert`.
* Players who started the quest keep storage `0`/`1`. If you later reuse the storage for a
  different quest, they will appear to have started or finished it. **Never recycle quest
  storages.** Leave a comment with the retired number instead.
* Apply with `/reload npcs` + `/reload creaturescripts` + `/reload quests`, or restart.
