# Add an NPC trainer (Pokémon battle NPC)

A trainer is a normal NPC (read `add-npc.md` first) whose script creates an `NpcBattle`
object. The model used here is **Chandra Wigington**, one of the seven Pewter gym trainers
that Brock requires.

Paths are relative to `server/` unless noted.

---

## 1. How a trainer works

```
npc/Chandra Wigington.xml  ── script="npcbattle_chandrawigington.lua"
        │
npc/scripts/npcbattle_chandrawigington.lua
        │  NpcBattle:new(getNpcName(), 9168, 9568, npcHandler)
        ▼
lib/ps/systems/001-npcBattle.lua   (loaded into the shared NPC Lua state)
        ├─ canPlayerBattleWithNpc  → refuses with a message, or returns true
        ├─ doBattleStart / doCallPokemon → summons the NPC's Pokémon
        └─ doBattleEnd             → rewards, storages, onWin / onEnd callbacks
```

Two per-player storages belong to every trainer:

| Constructor argument | Example | Written by | Meaning |
|----------------------|---------|-----------|---------|
| `lastBattleTimeStorage` | `9168` | `setPlayerLastBattleTimeWithNpc` (`001-npcBattle.lua:389-395`) | `os.time()` of the last win, or **`-2`** (`NPC_TIME_BETWEEN_BATTLES_FOREVER`, line 5) when `setOneWin(true)` |
| `levelStorage` | `9568` | `setLevel` (`404-407`) after every win | how many times the player beat the trainer, plus 1. `getPlayerDefeatedNPC` returns true when it is `> 1` (`1084-1088`) |
| `lastDefeatTimeStorage` (optional 5th argument) | – | `doBattleEnd:776-778` | time of the last win, for custom cooldowns |

## 2. Files to edit

| File | Why |
|------|-----|
| `data/npc/<Name>.xml` | the NPC (look, greet message, `idletime`) |
| `data/npc/scripts/npcbattle_<name>.lua` | the `NpcBattle` configuration |
| `data/world/map-spawn.xml` | place the trainer (`add-spawn.md`) |
| `pt_br.loc` | optional translations |

You do **not** edit `001-npcBattle.lua` to add a trainer.

## 3. Files NOT to edit

* `data/lib/ps/systems/001-npcBattle.lua`: shared by every trainer. Change it only to fix a
  bug, and test all trainers afterwards.
* `data/lib/ps/config/_pokemon/`, `others/pokemon_backup/`, `others/moves_disabled/`,
  `systems/disabled/`, `data/npc/backup/`, `original/`: historical, not loaded.
* `data/npc/tmpCitizen_*.xml`: generated at startup.
* `data/world/-spawn.xml`: unused spawn file.

## 4. Authoritative source paths

| What | Where |
|------|-------|
| Constructor | `lib/ps/systems/001-npcBattle.lua:135-184` |
| Default values of every option | `001-npcBattle.lua:89-131` |
| All setters | `001-npcBattle.lua:186-310` |
| Eligibility checks and their messages | `canPlayerBattleWithNpc`, `001-npcBattle.lua:427-493` |
| Pokémon level formula | `doCallPokemon`, `001-npcBattle.lua:537-551` |
| Rewards | `doBattleEnd`, `001-npcBattle.lua:714-819` |
| Talk helpers | `doTalkStart` `1019-1038`, `doTalkEnd` `1040-1064` |
| "Has the player beaten X?" | `getPlayerDefeatedNPC` `1084-1088`, `doPlayerEraseDefeatedNpc` `1094+` |

## 5. Real example

`data/npc/Chandra Wigington.xml`:

```xml
<npc name="Chandra Wigington" script="npcbattle_chandrawigington.lua" walkinterval="0" floorchange="0">
	<health now="100" max="100"/>
	<look type="621" head="90" body="30" legs="30" feet="22" addons="3"/>
	<parameters>
		<parameter key="message_greet" value="Stop right there, kid! You're ten thousand light-years from facing Brock!"/>
		<parameter key="idletime" value="30" />
	</parameters>
</npc>
```

`data/npc/scripts/npcbattle_chandrawigington.lua`, lines 1-10 and 17-36:

```lua
local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler, CONVERSATION_DEFAULT)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

local npcBattle = NpcBattle:new(getNpcName(), 9168, 9568, npcHandler)
npcBattle:setPokemons({"Sandslash", "Golem", "Onix", "Rhydon"})
npcBattle:setOneWin(true)
npcBattle:setDifficulty(20)
npcBattle:setPokemonDefeatExperienced(true)
-- ...
function creatureSayCallback(cid, type, msg)
	if(not npcHandler:isFocused(cid)) then
		return false
	end

	local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid

	if(msgcontains(msg, 'battle') or msgcontains(msg, 'fight') or msgcontains(msg, 'duel') or msgcontains(msg, 'batalha') or msgcontains(msg, 'duelar')) then
		talkState[talkUser] =  npcBattle:doTalkStart(getNpcId(), cid)

	elseif(msgcontains(msg, 'yes') or msgcontains(msg, 'sim')) then
		talkState[talkUser] =  npcBattle:doTalkEnd(getNpcId(), cid, talkState[talkUser])

	else
		selfSay("Ok..", cid)
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
```

What each call does (the default is from the table at `001-npcBattle.lua:89-131`):

| Call | Field | Default | Consumed at |
|------|-------|---------|-------------|
| `setPokemons({...})` | `pokemons` | `{}` | `doCallNextPokemon` (`611+`). Every name must be a `monsters.xml` entry **and** a `POKEMON["…"]` config |
| `setOneWin(true)` | `oneWin` | `false` | `doBattleEnd:772-774` writes `-2`. `canPlayerBattleWithNpc:456-457` then answers "You beat me before, there is no reason to a new battle." |
| `setDifficulty(20)` | `difficulty` | `10` | `doCallPokemon:540-541`: level = `difficulty + (timesBeaten) * 3`. `0` (`NPC_DIFFICULTY_DYNAMIC`) means player level −20…player level, clamped to 10-90 |
| `setPokemonDefeatExperienced(true)` | `pokemonDefeatExperienced` | `false` | `doCallPokemon:555-558`: the player's Pokémon earns exp from the NPC's Pokémon |
| `setRewardBaseExp(n)` | `rewardBaseExp` | `0` | `doBattleEnd:736-739`: player exp = `n * previousLevel` |
| `setRewardRespect(n)` | `rewardRespect` | `0` | `doBattleEnd:730`: **`n * 2`** respect is added |
| `setPayRespect(n)` | `payRespect` | `0` | entry fee, checked at `432-434` |
| `setRequiredRespect(n)` | `requiredRespect` | `0` | `447-449` |
| `setRequiredLevel(n)` | `requiredLevel` | `0` | `436-438` |
| `setBaseBet(n)` | `baseBet` | `0` | `doUpdateCurrentBet`; the winner gets `currentBet * 2` (`768-770`) |
| `setRewardItems({id, count, ...})` | `rewardItems` | `{}` | flat list of pairs (`748-751`) |
| `setRewardUniqueItems({id, count, ...})` | `rewardUniqueItems` | `{}` | `753-762` |
| `setRequired(function(cid) ... end)` + `setRequiredMessage("...")` | `required`, `requiredMessage` | `nil` | `472-475` |
| `setRequiredStorage(key)` | `requiredStorage` | `nil` | refused while that storage is `< 0` (`472`) |
| `setBattleInterval(seconds)` | `battleInterval` | `nil` (23 h) | `460-466` |
| `setOnWin(fn(cid))` / `setOnEnd(fn(cid, won, npcUid))` | | `nil` | `780-782`, `815-817` |
| `setWinSpeech` / `setLossSpeech` | | random line from `NPC_DIALOGS` | `716-720`, `785-789` |
| `addChange(level, pokemon)`, `setEvolve`, `setPokemonMaxLevel`, `setPokemonTeamEvolvable`, `setPokemonExtraStats`, `setLinealOrder`, `setSpecialMove`, `setPokemonMovesets`, `setCustomPokemonLevel` | | see table | `186-310` |

## 6. Required IDs and how to find free ones

Two storage numbers, unique per trainer, are needed.

* The header of `001-npcBattle.lua` line 1 is `-- Last Storages: 9312, 9712`. Continue from there:
  **9313** (last battle) and **9713** (level).
* Confirm that the numbers are really unused. There is no central registry, so grep the
  whole data tree:

  ```bash
  cd server/data
  grep -rnw --include=*.lua -e 9313 -e 9713 . | grep -v -e _pokemon/ -e pokemon_backup/
  ```

  No output means the numbers are free. `9313`–`9319` and `9713`–`9719` were free when this
  tutorial was written.
* Update the header comment to the new last values.
* Do **not** reuse the storages of another trainer, even one that "does the same". Both
  trainers would then share wins and cooldowns.

Note that the storage *ranges* are not strict. Brock uses `9101/9508`, the beginner quest NPC
uses `8364/8366` (`npc/scripts/quest_beginner.lua:13`), and `8366` is **also** the
`counterStorage` of a quest (`config/003-quest.lua:4987`). Always grep.

## 7. Related dependencies

* Every Pokémon in `setPokemons` needs:
  * `monster/monsters.xml` entry (e.g. `monsters.xml:24` `<monster name="Rattata" file="Pokemons/rattata.xml"/>`)
  * `lib/ps/config/pokemon/<name>.lua` with `POKEMON["<Name>"]`
  * moves listed in its `skills` that exist in `lib/ps/config/moves/`
* `registerCreatureEvent(pokemon, "npcPokemonDeath")` (`doCallPokemon:528`) must exist in
  `creaturescripts.xml`. It does; do not rename it.
* The world must be `worldType = "pvp"`. Under the archive's `no-pvp` every attack on the
  NPC's Pokémon is refused ("You may not attack this creature."). See BUG-01 and
  `docs/BUILDING.md` §4.

## 8. Registration steps

1. Copy `npc/Chandra Wigington.xml` to `npc/<Name>.xml` and change `name`, `look` and
   `message_greet`. Keep `idletime` so an idle player loses focus.
2. Copy `npc/scripts/npcbattle_chandrawigington.lua` to `npc/scripts/npcbattle_<name>.lua`.
   Change the two storages and the team.
3. Point the XML `script=` at the new file.
4. Add the spawn entry (`add-spawn.md`). Chandra is at `map-spawn.xml:59436-59438`:

   ```xml
   <spawn centerx="3299" centery="247" centerz="10" radius="1">
     <npc name="Chandra Wigington" x="0" y="-1" z="10" spawntime="60" level="0"/>
   </spawn>
   ```

5. Bump the `-- Last Storages:` comment in `001-npcBattle.lua` line 1. This is the only edit
   to that file, and it is a comment.

## 9. Database requirements

None. Both storages are rows in the stock `player_storage` table.

## 10. Client requirements

None for an existing outfit and existing Pokémon. The battle icon above the NPC is set
server-side (`CREATURE_ICONS.BATTLE`, `001-npcBattle.lua:179-181`).

## 11. Server requirements

* `worldType = "pvp"` in `config.lua` (see §7).
* Changing only the script or XML of an NPC that is already on the map: `/reload npcs` is
  enough (it rebuilds the NPC Lua state, `src/npc.cpp:47-56`).
* A new spawn entry needs a restart.

## 12. Validation steps

```bash
bash tools/check_syntax.sh
python3 tools/check_references.py > /tmp/refs-after.txt   # diff the REAL ERROR list with your baseline
cd server/data && grep -rnw --include=*.lua -e <lastBattleStorage> -e <levelStorage> . | grep -v _pokemon/
#  → exactly one hit each: your new script
```

At startup, `NpcBattle:new` refuses to build the object and logs to
`server/logs/Error - <date>.log` (`lib/ps/others/logger.lua`, `LOGS_DIR = "logs/"`):

* `NpcBattle:new missing npcHandler`
* `NpcBattle:new missing levelStorage`
* `NpcBattle:new missing lastBattleTimeStorage`
* `NpcBattle:new missing name`

After such an error `npcBattle` is `nil`, and the first `battle` prints an
`[Error - Npc interface]` "attempt to index … nil" trace.

## 13. Test steps

The Phase 2 test (P2-29, `docs/PHASE_2_TEST_MATRIX.md`) used **Tester** with a level-100
Pidgeot added by SQL. GM Pokémon cannot use moves (BUG-05), so use Tester or Trainer for a
real fight. Use GM Admin for the commands.

1. As GM Admin: `/goto 3299,246,10` (Chandra) or the position of your trainer.
2. As Tester, summon a Pokémon, stand next to the NPC **outside** a protection zone, and
   say in the NPC channel:
   * `hi` → the `message_greet` text.
   * `battle` → `Do you really want to battle with me?` (`doTalkStart:1028`). With
     `setPayRespect(3)` the text continues ` (You will pay 3 respect points)`.
   * `yes` → `Go, Sandslash!`, and the fight starts.
3. Lose → `You have been defeated by Chandra Wigington!` (`doBattleEnd:790`).
4. Win → `You won Chandra Wigington.` (without rewards) or
   `You won Chandra Wigington and received your reward.` (`724`, `726`).
5. Check the storages as GM Admin:
   * `/storage Tester,9168` → ` [Tester - 9168] = -2` after a win with `setOneWin(true)`
   * `/storage Tester,9568` → ` [Tester - 9568] = 2`
6. Say `battle` again → `You beat me before, there is no reason to a new battle.`
7. Reset for another test: `/storage Tester,9168,-1` and `/storage Tester,9568,-1`.

## 14. Common mistakes

* Copying a script and forgetting to change the storages. The new trainer then counts as
  "already beaten" for everyone who beat the original.
* Naming a Pokémon that is not in `monsters.xml` (e.g. a typo like `"Rhyhorn "` with a
  trailing space). `doSummonCreature` returns nothing and the battle breaks.
* `setRewardRespect(2)` expecting 2 respect: the player receives **4** (`rewardRespect * 2`,
  line 730).
* Testing at a protection-zone tile: `You can't duel against me while you are in a protection zone.`
* Testing while your own Pokémon is in the ball: `doTalkEnd` answers with a random line from
  `NPC_DIALOGS.PLAYER_WITHOUT_POKEMON` (`1047-1049`).
* Using a trainer name in another script's `getPlayerDefeatedNPC(cid, "Name")` when that
  trainer is never spawned. See §15.

## 15. Failure symptoms

All messages below are verbatim from `canPlayerBattleWithNpc` (`427-493`) and `doTalkStart`.

| Message to the player | Cause |
|-----------------------|-------|
| `I'm battling at the moment, please wait.` | another player is fighting this NPC |
| `You can't battle against me while you're dueling.` | player duel active |
| `You need pay %s respect points to battle against me.` | `setPayRespect` |
| `You need at least level %s to battle against me.` | `setRequiredLevel` |
| `You need at least %s dollars to bet.` | `setBaseBet` |
| `Sorry kid, you need at least %s respect points to do a battle with me.` | `setRequiredRespect` |
| `You already have my badge, there is no reason to a new battle.` | gym leader, badge in inventory |
| `You beat me before, there is no reason to a new battle.` | `oneWin` and storage = `-2` |
| `Sorry, you must wait %s seconds to battle with me again.` | interval not over |
| `You can't duel against me yet.` (or your `setRequiredMessage`) | `setRequired`/`setRequiredStorage` failed |
| `First get next to me.` | no clear line of sight |
| `You can't battle against me while your Pokemon is using potions.` | potion running |
| `You can't duel against me while you are in a protection zone.` | PZ tile |
| `You may not attack this creature.` during the fight | `worldType` is `no-pvp` (BUG-01) |
| `[Error - Npc interface] … attempt to index a nil value` inside `getPlayerDefeatedNPC` | the named trainer was never created, so `NpcsByName[name]` is `nil` (`1085-1086`). Pass the storage number instead of the name, or make sure the NPC is spawned |

## 16. Rollback advice

* `git restore` / `git revert` the NPC XML, script and spawn line.
* Players who already beat the removed trainer keep its two storages. Harmless, but if you
  later reuse the numbers for another trainer, those players count as having beaten it.
  **Never recycle trainer storages.**
* `/reload npcs` applies script changes. Removing the spawn needs a restart.
