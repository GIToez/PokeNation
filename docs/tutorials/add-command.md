# Add a chat command (talkaction)

A command is a **talkaction**: one line in `data/talkactions/talkactions.xml` that maps one or
more words to a Lua file with an `onSay(cid, words, param, channel)` function. The model is
`/autoloot`, a simple player command (`talkactions.xml:11`). GM commands such as `/storage`
follow the same pattern with an `access` level.

Paths are relative to `server/` unless stated otherwise.

---

## 1. The chain

```
Player types "/dungeon"  →  src/game.cpp:3918  g_talkActions->onPlayerSay(...)
        │
src/talkaction.cpp:115-188   TalkActions::onPlayerSay
        │  split the text into command + param (filter, lines 118-142)
        │  find the words in talksMap (case rules, lines 144-153)
        │  check channel (155-156), access (158-171), log (173-179)
        ▼
data/talkactions/talkactions.xml
        <talkaction words="/autoloot" case-sensitive="no" event="script"
                    value="../../lib/ps/events/talkactions/autoLoot.lua" description="…"/>
        │  value is relative to data/talkactions/scripts/  (src/baseevents.cpp:51)
        ▼
data/lib/ps/events/talkactions/autoLoot.lua    function onSay(cid, words, param) … return true end
```

If `onSay` returns `true`, the text is consumed. If it returns `false` (or the player lacks
access), `onPlayerSay` returns false and the text is said in chat like normal speech
(`game.cpp:3918-3919`).

## 2. Files to edit

| File | What |
|------|------|
| `data/talkactions/talkactions.xml` | One `<talkaction>` line. Player commands go in the `<!-- PS -->` block (lines 3-49); GM commands go in the access-sorted blocks below (`<!-- Gods -->` starts at line 51) |
| `data/lib/ps/events/talkactions/<name>.lua` | The script, for player/PS commands (the convention of the PS block) |
| `data/talkactions/scripts/<name>.lua` | The script, for GM commands (the convention of the GM blocks, e.g. `storage.lua`) |
| `server/pt_br.loc` | Portuguese text for every string you pass through `__L(cid, …)` |

## 3. Files NOT to edit

* `src/talkaction.cpp`. Only needed for `event="function"` built-ins (`talkaction.cpp:267-300`).
  New commands are always `event="script"`.
* `data/lib/ps/events/talkactions/commands.lua` (`/help`). It builds its list automatically
  from `getTalkActionList()` (§5.3).
* `data/lib/ps/config/_pokemon/`, `data/lib/ps/others/pokemon_backup/`,
  `data/lib/ps/others/moves_disabled/`, `data/lib/ps/systems/disabled/`, `original/`,
  `data/npc/tmpCitizen_*.xml`, unused `*-spawn.xml`.
* The commented-out entries at `talkactions.xml:42-47` (`/tvbanlist`, `/gl`). They are
  disabled on purpose; `/gl` runs a loot generator tool.

## 4. Authoritative source paths

| Topic | Location |
|-------|----------|
| XML attributes | `src/talkaction.cpp:217-265` (`TalkAction::configureEvent`) |
| Defaults | `src/talkaction.cpp:190-200`: filter `word`, access 0, channel -1, not logged, not hidden, **case-sensitive** |
| Several words per line | `separator` attribute, default `;` (`talkaction.cpp:88-109`) |
| Duplicate words | `talkaction.cpp:96-104`: `[Warning - TalkAction::configureEvent] Duplicate registered talkaction with words: …` |
| Access check | `talkaction.cpp:158-171` |
| Logging | `talkaction.cpp:173-179` → `server/logs/talkactions/<player name>.log` (`src/textlogger.cpp:49-57`, `src/tools.cpp:1592-1594`) |
| Script loading errors | `src/baseevents.cpp:197-209` |
| Group → access | `data/XML/groups.xml:3-11` (Gamemaster = 3, Community Manager = 4, God = 5) |
| `/help` | `data/lib/ps/events/talkactions/commands.lua` |
| `/reload` | `data/talkactions/scripts/reload.lua`, `src/game.cpp:6536-6544` |

### 4.1 Attributes

| Attribute | Values | Effect |
|-----------|--------|--------|
| `words` | text; several separated by `;` | **required**. Missing: `[Error - TalkAction::configureEvent] No words for TalkAction.` |
| `separator` | one string | replaces `;` for this line |
| `event` | `script` / `function` | use `script` |
| `value` | path | relative to `data/talkactions/scripts/` |
| `filter` | `word` (default), `word-spaced`, `quotation` | how the command is split from its parameter (lines 118-142). `word`: up to the first space. `word-spaced`: up to the second space (`/house buy`). `quotation`: up to the first `"` |
| `access` | number | minimum `access` of the player's group |
| `channel` | channel id | only works in that channel |
| `log` / `logged` | `yes`/`no` | echoes the command in red to the GM and appends it to the log file |
| `hide` / `hidden` | `yes`/`no` | hides it from `/help` |
| `case-sensitive` / `casesensitive` / `sensitive` | `yes`/`no` | default **yes**. `/autoloot` uses `no` |
| `exception` | names separated by `;` | these players skip the access check |
| `description` | text | shown by `/help` |

An unknown `filter` value prints
`[Warning - TalkAction::configureEvent] Unknown filter for TalkAction: <value>, using default.`

## 5. Real examples

### 5.1 Player command: `/autoloot`

`talkactions.xml:11`:

```xml
		<talkaction words="/autoloot" case-sensitive="no" event="script" value="../../lib/ps/events/talkactions/autoLoot.lua" description="Automatic loot from corpses."/>
```

`data/lib/ps/events/talkactions/autoLoot.lua`:

```lua
function onSay(cid, words, param)
	local autoLoot = getPlayerAutoLoot(cid)
	setPlayerAutoLoot(cid, not autoLoot)
	setPlayerAutoLootSave(cid, not autoLoot)
	doPlayerSendTextMessage(cid, MESSAGE_EVENT_ORANGE, string.format(__L(cid, "Auto Loot %s!"), (autoLoot and "OFF" or "ON")))
	return true
end
```

The translation is `server/pt_br.loc:714`: `Auto Loot %s!@Auto Loot %s!` (English `@` Portuguese).

### 5.2 GM command: `/storage`

`talkactions.xml:74` (the `<!-- Community Managers -->` block, line 71):

```xml
	<talkaction log="yes" words="/storage" access="4" event="script" value="storage.lua"/>
```

`data/talkactions/scripts/storage.lua:1-21` parses `Name,key[,value]` with
`string.explode(param, ",")` (`data/lib/011-string.lua:10`). It answers
`Invalid param specified.`, `Player <param> not found.`, or ` [Name - key] = value`.
Setting a value prints **nothing**.

### 5.3 `/help`

`commands.lua:3-61` reads `getTalkActionList()` (`src/luascript.cpp:7960-7967`: `words`,
`description`, `access`, `log`, `hide`, `channel`). It drops `hide` entries, groups the rest
by access, and shows each player everything at or below their access. The list is built
**10 seconds after the script loads** (`commands.lua:63`), so it also picks up a command
added with `/reload talkactions`.

## 6. Required IDs and how to find free ones

Talkactions have no numeric id. The **words** must be unique:

```bash
grep -n 'words="[^"]*/dungeon[;"]' server/data/talkactions/talkactions.xml   # empty = free
ls server/data/lib/ps/events/talkactions/ server/data/talkactions/scripts/ | grep -i dungeon
```

The map is keyed by the exact words. With `case-sensitive="no"`, `/Dungeon` and `/dungeon`
both match, so check case-insensitively (`grep -in`) too.

If the command uses a storage, find a free one first (see `add-quest.md` §6 for the grep).
The examples below reuse an existing storage and need none.

## 7. Related dependencies

* Every Lua function you call must exist in `data/lib/` (loaded into every interface) or be
  a C++ function registered in `src/luascript.cpp`. Check it:
  `grep -rn "^function getPlayerLastDungeonDate" server/data/lib/` →
  `lib/ps/functions/player.lua:826`.
* Strings shown to the player should go through `__L(cid, "…")` with a matching line in
  `pt_br.loc`. `__L` with a `cid` that is not a player prints `Player not found` and returns
  the English text (`src/luascript.cpp:14092-14106`).

## 8. Example

### 8.1 Player command `/dungeon`: time until the next mastery dungeon

The mastery NPCs refuse a new dungeon for 24 hours (`npc/scripts/mastery_blaze.lua:214-216`).
The date is in `playersStorages.lastDungeonDate` (7038, `lib/ps/config/playersStorages.lua:41`).

`data/talkactions/talkactions.xml`, in the `<!-- Others -->` block after `/lang` (line 24):

```xml
		<talkaction words="/dungeon" case-sensitive="no" event="script" value="../../lib/ps/events/talkactions/dungeonCooldown.lua" description="Show remaining time to be able to enter another Mastery dungeon." />
```

`data/lib/ps/events/talkactions/dungeonCooldown.lua` (modelled on `bossRewardCheck.lua`):

```lua
local DUNGEON_INTERVAL = 24 * 60 * 60

function onSay(cid, words, param)
    local diff = (getPlayerLastDungeonDate(cid) + DUNGEON_INTERVAL) - os.time()
    if (diff <= 0) then
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, __L(cid, "You are able to enter another Mastery dungeon."))
    else
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(cid, "You must wait %s to enter another Mastery dungeon."), table.concat(string.timediff(diff, cid))))
    end
    return true
end
```

`getPlayerLastDungeonDate` returns -1 for a player who never did one, so `diff` is negative.
`string.timediff(diff, cid)` returns translated pieces such as `23 hours`, `, 59 minutes`
(`data/lib/011-string.lua:36-62`).

`server/pt_br.loc` (keep the file's ISO-8859-1 encoding and CRLF line ends; see §15):

```
You are able to enter another Mastery dungeon.@Você já pode entrar em outra dungeon de Maestria.
You must wait %s to enter another Mastery dungeon.@Você precisa esperar %s para entrar em outra dungeon de Maestria.
```

### 8.2 GM command `/resetdungeon Name`

`talkactions.xml`, in the access-4 block next to `/storage`:

```xml
	<talkaction log="yes" words="/resetdungeon" access="4" event="script" value="resetdungeon.lua" description="Reset a player's Mastery dungeon cooldown."/>
```

`data/talkactions/scripts/resetdungeon.lua`:

```lua
function onSay(cid, words, param, channel)
	if(param == '') then
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Command param required.")
		return true
	end

	local pid = getPlayerByNameWildcard(param)
	if(not pid) then
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Player " .. param .. " not found.")
		return true
	end

	setPlayerLastDungeonDate(pid, -1)
	doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Dungeon cooldown of " .. getCreatureName(pid) .. " reset.")
	return true
end
```

The messages copy the style of `promote.lua` and `storage.lua`. GM-only messages are not
translated in this codebase.

## 9. Registration steps

1. Choose free words (§6).
2. Write the script with `function onSay(...)` that returns `true`.
3. Add the XML line. Use `log="yes"` for every GM command, like the existing ones.
4. Add `pt_br.loc` lines for translated strings.
5. Validate (§13).
6. On a running dev server, `/reload talkactions` (§17). `pt_br.loc` changes need a restart
   (it is read once, `src/localization.cpp:295`).

## 10. Database requirements

None for the command itself. If the command writes to the database, follow
`database-changes.md`.

## 11. Client requirements

None. Talkactions are plain chat text. The PS client sends some hidden commands itself
(`/sd`, `/cp`, `/pd`, `/tc`, `talkactions.xml:18-21`); do not reuse those words.

## 12. Server requirements

None beyond a running server. Test GM commands with **GM Admin** (group 6, access 5).

## 13. Validation steps

```bash
bash tools/check_syntax.sh            # talkactions.xml and the new .lua
python3 tools/check_references.py > /tmp/refs-after.txt
grep -n 'dungeonCooldown\|resetdungeon' /tmp/refs-after.txt   # empty = the script paths resolve
grep -c 'words="/dungeon"' server/data/talkactions/talkactions.xml   # 1
```

Start-up or `/reload talkactions`: no `[Warning - Event::loadScript]` and no
`Duplicate registered talkaction` line.

## 14. Test steps

1. As GM Admin: `/reload talkactions` → `Reloading talkactions...`, then
   `Reloaded successfully.`.
2. As Tester: `/dungeon` → `You are able to enter another Mastery dungeon.`
3. As GM Admin: `/storage Tester,7038,<os.time() value>`, e.g. the current Unix time from
   `date +%s`. Then, as Tester, `/dungeon` → `You must wait 23 hours, 59 minutes … to enter another Mastery dungeon.`
4. As Tester: `/DUNGEON` → the same answer (`case-sensitive="no"`).
5. As GM Admin: `/resetdungeon Tester` → the command is echoed in red, then
   `Dungeon cooldown of Tester reset.`. `server/logs/talkactions/GM Admin.log` gets a line,
   if the `server/logs/talkactions/` directory exists (the logger silently skips a missing
   directory, `textlogger.cpp:51-53`).
6. As Tester (access 0): `/resetdungeon GM Admin` → the text appears in chat as normal speech.
   The command does not run.
7. `/resetdungeon Nobody` → `Player Nobody not found.`
8. `/help` as Tester lists `/dungeon` with its description; as GM Admin it also lists
   `/resetdungeon` (up to 10 s after the reload).

## 15. Common mistakes

* Forgetting `return true`. The command runs **and** the text is said in public chat.
* Relying on the default case sensitivity. `/Dungeon` does nothing unless you set
  `case-sensitive="no"`.
* Words that start another command's words. With `filter="word"`, `/dungeons` is a different
  command from `/dungeon`. That is safe, but confusing for players.
* `value="dungeonCooldown.lua"` in the PS block. That path means
  `data/talkactions/scripts/dungeonCooldown.lua`.
* Saving `pt_br.loc` as UTF-8 or with LF line ends. Other lines then stop matching or show
  broken accents. Check with `file server/pt_br.loc` →
  `ISO-8859 text, with very long lines (647), with CRLF line terminators`.
* Expecting `access` to hide the command. Players without access see their text spoken
  normally. That reveals that nothing happened, but not that the command exists.
  Players whose group has the GM custom flag instead get `You cannot execute this talkaction.`
  (`talkaction.cpp:164-168`).
* Not checking `param`. `string.explode("", ",")` returns an empty table, so `t[1]` is `nil`.

## 16. Failure symptoms

| Symptom | Cause |
|---------|-------|
| `[Warning - Event::loadScript] Cannot load script (…)` followed by a Lua error | Wrong path, or a syntax error in the script |
| `[Warning - Event::loadScript] Event onSay not found (…)` | The function is not called `onSay` |
| `[Warning - TalkAction::configureEvent] Duplicate registered talkaction with words: /dungeon` | The words already exist; the new line is ignored |
| The text appears in chat, nothing happens | No match (case, typo, wrong `filter`), insufficient access, or `onSay` returned `false` |
| `[Error - TalkAction Interface]` + stack trace when used | A run-time error in the script (nil function, nil `param` field) |
| `Failed to reload.` and `[Error - Game::reloadInfo] Failed to reload talk actions.` | `talkactions.xml` is malformed |

## 17. Rollback advice

* `git checkout -- server/data/talkactions/talkactions.xml` and delete the new script, or
  `git revert <commit>`.
* `/reload talkactions` applies **both** directions on a running server: it rebuilds
  `talksMap` from the XML (`game.cpp:6536-6544`). If the XML is broken, the reload fails and
  the server keeps **no** talkactions until a successful reload. Fix the file and reload
  again. `/reload` itself is a talkaction; if it is gone, restart the server.
* `pt_br.loc` changes only take effect after a restart.
