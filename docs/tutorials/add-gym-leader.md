# Add a gym leader

A gym leader is an NPC trainer (`add-trainer.md`) with four extras:

* it awards a **badge**;
* it can only be fought after the gym trainers are beaten;
* it triggers achievements;
* it usually gives an extra reward (a TM) and a follow-up quest.

The model is **Brock** (`data/npc/scripts/npcbattle_brock.lua`).

Read `add-npc.md` and `add-trainer.md` first. Paths are relative to `server/`.

> **Known blocker (BUG-16, `docs/BUG_TRIAGE.md`).** A badge is given by *transforming a
> placeholder item* that must already be in the player's inventory. Nothing in the repository
> creates those placeholders: the seeded badge case `12280` is empty (`psoul_dev_seed.sql:65`).
> A test character must be given the placeholder by hand (§13). Otherwise the win message
> says "Congratulations! You received the boulder badge from Brock." but no badge appears.

---

## 1. The chain

```
npc/scripts/npcbattle_brock.lua
  NpcBattle:new(getNpcName(), 9101, 9508, npcHandler)
  setRewardBadge(BADGES.BOULDER) ───────────► lib/ps/others/constants.lua:669
  setRequired(fn: 7 × getPlayerDefeatedNPC)        BOULDER = { newItemId = 12213, oldItemId = 12214, name = "Boulder" }
  setOnWin(fn: achievement + TM)                         │                    │
        │                                         items.xml:18141     items.xml:18142
        ▼                                         "boulder badge"     "boulder badge slot"
lib/ps/systems/001-npcBattle.lua
  canPlayerBattleWithNpc:449-453   refuses if the player already has newItemId
  doBattleEnd:741-744              doPlayerGiveBadge → doTransformItem(oldItemId → newItemId)
  doBattleEnd:746                  doPlayerAchievementCheck(KANTO_BADGES)
```

## 2. Files to edit

| File | Why |
|------|-----|
| `data/npc/<Leader>.xml`, `data/npc/scripts/npcbattle_<leader>.lua` | the leader |
| `data/npc/<Gym trainer>.xml`, `data/npc/scripts/npcbattle_<trainer>.lua` | each gym trainer (`add-trainer.md`) |
| `data/world/map-spawn.xml` | leader + trainers |
| `data/lib/ps/others/constants.lua` (`BADGES`, line 667) | **only** for a brand-new badge |
| `data/items/items.xml` | **only** for a brand-new badge: the badge and its "slot" placeholder |
| `data/lib/ps/systems/024-badgeCase.lua` (`BADGE_CASES`) | **only** for a brand-new badge |
| `data/lib/ps/systems/023-achievement.lua` | the per-badge achievement (`add-achievement.md`) |
| `data/lib/ps/config/003-quest.lua` | optional follow-up quest (`add-quest.md`) |

## 3. Files NOT to edit

* `data/lib/ps/systems/001-npcBattle.lua`: shared engine for all trainers.
* `data/lib/ps/config/_pokemon/`, `others/pokemon_backup/`, `others/moves_disabled/`,
  `systems/disabled/`, `data/npc/backup/`, `original/`, `data/npc/tmpCitizen_*.xml`,
  `data/world/-spawn.xml`, `config/003-quest.lua.bak`.

## 4. Authoritative source paths

| What | Where |
|------|-------|
| Badge table | `lib/ps/others/constants.lua:667-682` |
| Badge transform | `lib/ps/systems/001-npcBattle.lua:500-502` |
| "Already has badge" check | `001-npcBattle.lua:449-453` |
| Kanto achievement | `lib/ps/systems/023-achievement.lua:541-553` (`KANTO_BADGES = 80`) |
| Per-badge achievement | `023-achievement.lua:781-784` (`BOULDER_BADGE = 119`) |
| Badge case contents | `lib/ps/systems/024-badgeCase.lua:1-8` |
| Example leader | `npc/scripts/npcbattle_brock.lua` |

## 5. Real example: Brock

`npc/scripts/npcbattle_brock.lua:6-34`:

```lua
local TM_STORAGE = 8398
local function giveTm(cid)
    doCreatureSetStorage(cid, TM_STORAGE, QUEST_STATUS.FINISHED)
    doPlayerSafeAddItem(cid, 17369, 1, true, true, true) -- TM 33 Selfdestruct
end

local npcBattle = NpcBattle:new(getNpcName(), 9101, 9508, npcHandler)
npcBattle:setPokemons({"Golem", "Onix", "Rhyhorn", "Graveler", "Onix", "Golem"})
npcBattle:setRewardBaseExp(5000)
npcBattle:setRewardBadge(BADGES.BOULDER)
npcBattle:setRewardRespect(2)
npcBattle:setPayRespect(3)
npcBattle:setOneWin(true)
npcBattle:setDifficulty(25)
npcBattle:setRequiredMessage("You must first defeat the GYM trainers before battle against me.")
npcBattle:setRequired(function(cid)
                        return getPlayerDefeatedNPC(cid, "Lonnie Boedeker") and
                                getPlayerDefeatedNPC(cid, "Erik Shakespeare") and
                                getPlayerDefeatedNPC(cid, "Jessie Gambrel") and
                                getPlayerDefeatedNPC(cid, "Noemi Retherford") and
                                getPlayerDefeatedNPC(cid, "Marylou Whitbeck") and
                                getPlayerDefeatedNPC(cid, "Dona Cantrelle") and
                                getPlayerDefeatedNPC(cid, "Chandra Wigington")
                        end)
npcBattle:setOnWin(function(cid)
    doPlayerAchievementCheck(cid, ACHIEVEMENT_IDS.BOULDER_BADGE)
    giveTm(cid)
end)
npcBattle:setPokemonDefeatExperienced(true)
```

The conversation (`npcbattle_brock.lua:48-71`) checks in this order:

1. `tm`: re-gives the TM if storage `8398` is not `FINISHED`.
2. Already beaten (`getPlayerDefeatedNPC(cid, getNpcName())`): hands over to the quest system
   (`doQuestTalk`). This is how Brock's follow-up quest (`QUESTS_CONFIG["Brock"]`,
   `config/003-quest.lua:6249`, storage `8456`, `canStart = getPlayerDefeatedNPC(cid, 9508)`)
   becomes reachable.
3. `battle` / `fight` / `duel` → `doTalkStart`.
4. `yes` / `sim` → `doTalkEnd`.

Gym trainers and their storages (each spawned once in `map-spawn.xml`):

| Trainer | lastBattle | level |
|---------|-----------|-------|
| Lonnie Boedeker | 9162 | 9562 |
| Erik Shakespeare | 9163 | 9563 |
| Jessie Gambrel | 9164 | 9564 |
| Noemi Retherford | 9165 | 9565 |
| Marylou Whitbeck | 9166 | 9566 |
| Dona Cantrelle | 9167 | 9567 |
| Chandra Wigington | 9168 | 9568 |

### Duplicate leader spawns

Brock is spawned twice: in the gym (`map-spawn.xml:59594`, at `3309,279,10`) and in his house
(`map-spawn.xml:18083`, spawn centre `5523,243,6` with offset `x=-2 y=4`, so `5521,247,6`).
Both copies share the same storages. The script tries to silence the house copy:

```lua
npcHandler:setCallback(CALLBACK_GREET, function(cid)
  if (getSamePosition(getNpcPos(), {x = 5521, y = 234, z = 6})) then
    return false
  end
```

`npcbattle_brock.lua:76` compares against `y = 234`, but the spawn puts the NPC at `y = 247`.
The guard therefore never matches, and the house Brock greets and battles like the gym Brock
(defect, inferred from the coordinates; not tested in game). When you copy this pattern,
compute the position from the spawn file (centre + offset, absolute z). Also remember that
`getNpcPos()` is the *current* position, so the NPC must not walk (`walkinterval="0"`).

## 6. Required IDs and how to find free ones

| ID | Where | How to find a free one |
|----|-------|-----------------------|
| Two NPC-battle storages per trainer and per leader | script | `add-trainer.md` §6 (start after `9312` / `9712`) |
| Extra-reward storage (Brock's `TM_STORAGE = 8398`) | script | quest range: start after `-- LAST STORAGE: 8755` in `config/003-quest.lua:1` (**8756**). Grep: `grep -rnw --include=*.lua 8756 data/` |
| Achievement id | `023-achievement.lua` | last is `HALLOWEEN_WON_SATOSHI = 182` (line 1144), so the next is **183** (`add-achievement.md`) |
| New badge item ids (badge + slot) | `items.xml`, `items.otb`, client `data.dat` | `add-client-asset.md`. Existing badges use consecutive pairs `12213/12214` … `12227/12228` and `18197-18200` / `18624-18627` |

## 7. Related dependencies

* All trainers named in `setRequired` **must be spawned**. `getPlayerDefeatedNPC(cid, "Name")`
  looks up `NpcsByName[name]` (`001-npcBattle.lua:1085-1086`). That table is only filled when
  the NPC is created. An unspawned name throws "attempt to index a nil value" inside the NPC
  Lua state. Passing the **level storage number** instead of the name avoids this. Brock's
  quest does exactly that (`getPlayerDefeatedNPC(cid, 9508)`).
* The `KANTO_BADGES` achievement check (`023-achievement.lua:544-552`) lists the eight Kanto
  badges explicitly. A new region's badge does not count unless you add an achievement for it.
* The badge case (`024-badgeCase.lua:3-8`) lists which badges go into which case. A badge
  missing there is lost when a case is upgraded (`doPlayerUpgradeBadgeCase`, `15-43`).

## 8. Registration steps

### 8.1 Leader with an existing badge

1. Create every gym trainer (`add-trainer.md`) and spawn them.
2. Create the leader script:
   * `setRewardBadge(BADGES.<NAME>)`;
   * `setOneWin(true)` (the badge check blocks a rematch anyway);
   * `setRequired` listing the trainers (preferably by level storage);
   * `setRequiredMessage`;
   * `setOnWin` that calls `doPlayerAchievementCheck(cid, ACHIEVEMENT_IDS.<NAME>_BADGE)`.
3. Spawn the leader once. If a second copy exists elsewhere, block it with a position check
   that matches the spawn file exactly.

### 8.2 Brand-new badge

1. Client: add the two sprites/item types (badge + placeholder) to `client/data/things/data.dat`
   / `data.spr`, and to `data/items/items.otb` (`add-client-asset.md`).
2. `data/items/items.xml`, following `items.xml:18141-18142`:

   ```xml
   <item id="NEW1" article="a" name="crystal badge"/>
   <item id="NEW2" article="a" name="crystal badge slot"/>
   ```

3. `lib/ps/others/constants.lua` inside `BADGES = { ... }`:
   `CRYSTAL = { newItemId = NEW1, oldItemId = NEW2, name = "Crystal" },`
4. `lib/ps/systems/024-badgeCase.lua`: add `BADGES.CRYSTAL` to the right `BADGE_CASES[...]`
   list. The order is reversed when added (comment on line 2).
5. Achievement for the badge (`add-achievement.md`).
6. Decide **how players get the placeholder `NEW2`** (BUG-16). Today nothing gives any
   placeholder. Options: add it in `doPlayerAddMainItems` (`lib/ps/functions/player.lua:717`),
   or change `doPlayerGiveBadge`. Both are source changes outside this tutorial; agree on them
   with the maintainers first.

## 9. Database requirements

None. Storages go to `player_storage`. Achievements are rows in `player_achievements`, which
`psoul_extra_mysql.sql:78-83` already creates.

## 10. Client requirements

* An existing badge: none.
* A new badge: two new item types in `data.dat`/`data.spr`. The badge-case window is a client
  module (`client/modules/game_badgecase`). It displays whatever items the container holds;
  check it visually.

## 11. Server requirements

* `worldType = "pvp"` (BUG-01).
* A restart for new spawns. `items.xml`/`items.otb` changes need a restart (`/reload items`
  prints `[Notice - Game::reloadInfo] Reload type does not work.`, `src/game.cpp:6438-6443`).

## 12. Validation steps

```bash
bash tools/check_syntax.sh
python3 tools/check_references.py > /tmp/refs-after.txt     # diff against your baseline
grep -n "NEW1\|NEW2" server/data/items/items.xml           # each id exactly once
grep -rn "BADGES.CRYSTAL" server/data/lib                  # constants + badge case + leader
```

## 13. Test steps

Use Tester (normal player, a strong Pokémon) for fights and GM Admin for commands.

1. Give Tester the placeholder (BUG-16 workaround). As GM Admin, stand next to Tester,
   `/i 12214,1`, and drop the item on the floor for Tester to pick up. Alternatively, insert
   it into `player_items` by SQL while Tester is offline, as `psoul_dev_seed.sql:61-91` does
   for other items.
   `getPlayerItemById(pid, true, id)` searches containers, so the placeholder can be anywhere
   in the inventory.
2. Talk to Brock (`/goto 3309,279,10`) **before** beating the trainers: `hi`, `battle` →
   `You must first defeat the GYM trainers before battle against me.`
3. Shortcut the trainers as GM Admin by setting their level storages to 2:
   `/storage Tester,9562,2` … `/storage Tester,9568,2`.
4. `battle` → `Do you really want to battle with me? (You will pay 3 respect points)`. The
   player needs at least 3 respect, otherwise `You need pay 3 respect points to battle against me.`
5. Win. Expected messages:
   * `You won Brock and received your reward.`
   * `Congratulations! You received the boulder badge from Brock.`
   * `You earned a new achievement: 'I am the Rock!'`
   * `You received 30 achievement score points.` (HARD rank)
6. `battle` again → `You already have my badge, there is no reason to a new battle.`
7. `tm` → `You already got this reward.`
8. Reset: remove the badge (`12213`), then `/storage Tester,9101,-1`, `/storage Tester,9508,-1`
   and `/storage Tester,8398,-1`. Delete the achievement row with
   `DELETE FROM player_achievements WHERE player_id = <id> AND \`key\` = 119;`.

## 14. Common mistakes

* Listing gym trainers by name when one of them is not spawned (see §7).
* Forgetting `setOneWin(true)`. Without it, a player who loses the badge can farm the
  `rewardBaseExp` every 23 h.
* Adding a badge to `BADGES` but not to `BADGE_CASES`. It disappears on case upgrade.
* A position-based guard for a duplicate NPC that does not match the spawn (Brock, §5).
* Expecting `setRewardBadge` to *add* an item. It only transforms the placeholder.

## 15. Failure symptoms

| Symptom | Cause |
|---------|-------|
| "Congratulations! You received the … badge" but no badge | no placeholder (`oldItemId`) in the inventory (BUG-16). `doTransformItem` receives uid 0 and the console shows an `[Error - Npc interface]` item-not-found trace |
| `You must first defeat the GYM trainers before battle against me.` after beating them | a trainer's level storage is still `≤ 1`, or `setRequired` uses a wrong name |
| `[Error - Npc interface]` … `attempt to index a nil value` at `001-npcBattle.lua:1086` | `getPlayerDefeatedNPC` with the name of an NPC that does not exist on the map |
| The "Kanto badges" achievement never fires | one of the 8 `newItemId`s is missing from the inventory (`023-achievement.lua:546-550`) |
| `You received: X [a] directly into your depot.` | the known `"[%x]"` format bug at `001-npcBattle.lua:760`; the count prints in hex |

## 16. Rollback advice

* `git revert` the commit, or `git restore` the files.
* Badges already handed out stay in player inventories. A removed badge **id** that is still
  in a player's inventory makes the item unknown to the server on next login. Do not delete
  badge ids from `items.xml` once players own them.
* Achievement rows stay in `player_achievements`. They are harmless as long as the id is not
  reused.
* Restart after rolling back spawns or items.
