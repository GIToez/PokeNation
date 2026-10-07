# Edit an existing quest

Changing a quest that players may already have started is riskier than adding a new one. The
player's progress is a single number in a storage, and the meaning of that number is defined
by the table you are editing. This tutorial lists which edits are safe and which need a data
migration.

Background: `add-quest.md` (fields, code paths, IDs). Paths are relative to `server/`.

---

## 1. Where an existing quest lives

1. Find the NPC entry:

   ```bash
   cd server/data
   grep -n '\["Jack Simps"\] = {' lib/ps/config/003-quest.lua        # → 28
   ```

2. Find the quest by its storage:

   ```bash
   grep -n 'storage = 8001,' lib/ps/config/003-quest.lua            # → 30
   ```

3. Find everything else that reads or writes that storage. NPC scripts, actions and
   movements often touch quest storages directly:

   ```bash
   grep -rnw --include=*.lua 8001 . | grep -v -e _pokemon/ -e pokemon_backup/ -e '\.bak'
   grep -n 'storageid="8001"\|startstorageid="8001"' XML/quests.xml
   ```

Real examples of hidden coupling found this way:

* **Ray Fitz, PokeMart order**: `onStart = function(cid) doCreatureSetStorage(cid, 8367, QUEST_STATUS.STARTED) end`
  (`003-quest.lua:4983`) starts *another* quest from inside a quest.
* **Ray Fitz** (`003-quest.lua:4955+`) shares numbers with the NPC battle in
  `npc/scripts/quest_beginner.lua:13` (`NpcBattle:new(getNpcName(), 8364, 8366, npcHandler)`):
  * quest `8360` uses `counterStorage = 8366` (line 4987), which is the battle's
    **level storage**;
  * `8364` is the battle's last-battle storage *and* the gate in `quest_beginner.lua:42-43` and
    `85-86` (an old quest entry with `storage = 8364` is commented out at line 5043).

  This only works because the counter quest is always done before the battle. Reordering
  these quests would make `getPlayerDefeatedNPC` wrong for Ray Fitz.
* **Captain Neil Pace** (`003-quest.lua:5972+`) is a `CUSTOM` quest whose `questRequest` loops
  `getPlayerDefeatedNPC(cid, storage)` over **9675-9679** (line 5986). Those are NPC-battle
  level storages. Changing those trainers' storages silently breaks this quest.

## 2. Files to edit

| File | Typical edit |
|------|-------------|
| `data/lib/ps/config/003-quest.lua` | text, requirement, reward, level |
| `data/XML/quests.xml` | quest-log text |
| `pt_br.loc` | the Portuguese text of every English line you change |
| SQL migration file (see `database-changes.md`) | only when existing progress must be converted |

## 3. Files NOT to edit

* `data/lib/ps/config/003-quest.lua.bak`: not loaded. Editing it changes nothing.
* `data/lib/ps/systems/002-quest.lua`: the engine.
* `data/lib/ps/config/_pokemon/`, `others/pokemon_backup/`, `others/moves_disabled/`,
  `systems/disabled/`, `data/npc/backup/`, `original/`, `data/npc/tmpCitizen_*.xml`,
  `data/world/-spawn.xml`.
* A live database by hand (`database-changes.md`).

## 4. Authoritative source paths

Same as `add-quest.md` §4. The decisive functions for "what happens to players already in
progress" are:

* `getCurrentQuest` (`002-quest.lua:110-142`): the **first** entry in the NPC's list that is
  `STARTED`, or `UNSTARTED` and startable, wins;
* `canFinishQuest` (`178-242`): evaluated with the **current** table at the moment the player
  says `yes`.

## 5. Safety table

| Change | Players who have not started | Players who started (`0`) | Players who finished (`1`) | Action |
|--------|-----------------------------|---------------------------|----------------------------|--------|
| `talk_*` text | new text | new text | – | update `pt_br.loc`. The old English line is the lookup key, so a changed English text loses its translation |
| `requiredLevel` | applies | ignored (only checked before start, `374`, `395`) | – | none |
| `questRequest` count/items (`BRING_ITEMS`) | applies | applies at finish | – | announce it |
| `questRequest` count (`DEFEAT`/`CATCH`) | applies | counter kept, compared with the new target | – | none |
| `questRequest` species (`DEFEAT`/`CATCH`) | applies | old kills still counted; new kills only for the new species | – | consider resetting `counterStorage` |
| `rewardItems` / `rewardExp` | applies | applies at finish | **not** re-paid | none |
| `questType` | applies | **undefined**: the counter or items may not exist | – | migrate (reset to `-1`) |
| `storage` number | applies | **progress lost**, the quest appears new | **can repeat** the quest | never; if unavoidable, migrate rows |
| `counterStorage` number | applies | counter restarts from the old storage's absence (`-1`) | – | migrate or reset |
| Insert a quest **before** others in the NPC list | it is offered first | if unstarted and startable, it is offered **before** the quest they are doing, and they cannot hand that one in until it is done | it is offered now | append at the end instead |
| Remove a quest entry | – | stuck: the storage stays `0` and the NPC never offers it again | – | finish or reset by migration |
| Make a quest `daily` | – | status changes from `0/1` to a timestamp only on next finish | `1` is not `> 100000`, so it is never repeated | migrate `1` → `0`-like timestamp or leave |

## 6. Required IDs and how to find free ones

An edit should not need new IDs. If you must add a `counterStorage` (e.g. converting to
`DEFEAT_POKEMON`), take the next free quest storage (`add-quest.md` §6: start after the
`-- LAST STORAGE: 8755` header, **8756**) and grep it.

## 7. Related dependencies

* Other scripts that read the storage (§1).
* `quests.xml` missions with the same `storageid`. Their `startvalue`/`endvalue` describe
  the value range. A new value outside it shows
  `Couldn't retrieve any mission description, please report to a gamemaster.`
  (`src/quests.cpp:67`).
* Achievements counting completed quests: `PLAYER_STATISTIC_IDS.COMPLETE_QUEST` is incremented
  at `002-quest.lua:356` and feeds `ACHIEVEMENT_IDS.QUEST_1` (`onStatisticChange.lua:46`).
  A quest that becomes repeatable inflates that statistic.

## 8. Example edits

### 8.1 Change Jack Simps' request from 25 to 20 bitten apples

`003-quest.lua:38`: `questRequest = { 12115, 20 }, -- The request of the quest`

Also update the started text on line 32, because it hard-codes the number ("…25 bitten
apples…"). Add a new line to `pt_br.loc` for the new English sentence (the old line becomes
unused but harmless). Update the quest-log text in `quests.xml:5` ("get 25 apples bites").

### 8.2 Reset everyone who is in progress on a changed quest (migration)

`server/src/schemas/migrations/<date>_reset_quest_8001.sql`. This is a convention proposal;
the repository has no migrations folder yet (see `database-changes.md`).

```sql
-- Jack Simps (storage 8001) changed type; restart in-progress players.
-- Run with the server STOPPED: the server caches storages of online players and would
-- write the old value back on logout.
UPDATE `player_storage` SET `value` = '-1' WHERE `key` = 8001 AND `value` = '0';
```

`player_storage` is the stock TFS table (`src/schemas/mysql.sql`). `value` is a string
column, hence the quotes.

## 9. Registration steps

1. Make the edit in `003-quest.lua` and, if needed, in `quests.xml` and `pt_br.loc`.
2. If §5 says "migrate", write the SQL file and test it on a copy of the database first
   (`database-changes.md` §8).
3. Bump nothing: `-- LAST STORAGE:` only changes when you add a storage.

## 10. Database requirements

None for text/reward/requirement edits. Storage or type changes need a migration (§8.2)
applied **while the server is stopped**.

## 11. Client requirements

None.

## 12. Server requirements

`/reload npcs` (dialogue/rewards), `/reload creaturescripts` (defeat counting),
`/reload actions` (catch counting), `/reload quests` (`quests.xml`). Restart for `pt_br.loc`
and after any SQL migration.

## 13. Validation steps

```bash
bash tools/check_syntax.sh
python3 tools/check_references.py > /tmp/refs-after.txt      # diff with the baseline
git diff --stat server/data/lib/ps/config/003-quest.lua     # make sure only the intended lines changed
```

`003-quest.lua` is ~8,000 lines of one table. A missing `,` or `}` breaks **every** quest
NPC, not just yours. Run `check_syntax.sh` after every edit.

## 14. Test steps

As GM Admin with Tester online:

1. Put Tester into each state and talk to the NPC (`hi`, `quest`, `yes`):
   * not started: `/storage Tester,8001,-1` → the new `talk_questStarting`;
   * in progress: `/storage Tester,8001,0` → `(End quest? {YES} or {NO})` and the new request
     in brackets, e.g. `You've got what I asked? (20 bitten apple)`;
   * finished: `/storage Tester,8001,1` → `Sorry, I can't help you right now.` (if it is the
     NPC's last quest).
2. Give the items: `/i 12115,20`. Hand in → `talk_questFinished`, reward, `+EXP!`.
3. Open the quest log and check the mission text for each state.
4. With the client language set to Portuguese, repeat step 1 and check the translations.

## 15. Common mistakes

* Editing `003-quest.lua.bak`.
* Changing a number inside a `talk_*` text but not the `questRequest`, or the reverse.
* Inserting a new quest at the top of an NPC's list (see §5).
* Running a storage migration while the server is online.
* Forgetting the quest-log state ids after changing `startvalue` (`add-quest.md` §8).

## 16. Failure symptoms

| Symptom | Likely cause |
|---------|--------------|
| All quest NPCs stop answering after the edit | Lua syntax error in `003-quest.lua` (see the console on start/reload) |
| Portuguese players see English | `pt_br.loc` key no longer matches the changed English text |
| Players report "the NPC offers me an old quest again" | storage number changed, or a quest was inserted before theirs |
| Quest log: `Couldn't retrieve any mission description…` | storage value outside the mission's `startvalue`…`endvalue` states |
| A player can never finish | entry removed or `questType` changed while they were at `0`; reset with §8.2 |

## 17. Rollback advice

* `git revert` the edit. The table goes back, but **migrations are not undone by Git**.
  Before running one, take a backup
  (`mysqldump … psoul player_storage > before.sql`, `database-changes.md` §7) and keep it
  with the commit.
* After reverting a reward change, players who already received the new reward keep it.
* Apply the revert with the same reloads as in §12, or restart.
