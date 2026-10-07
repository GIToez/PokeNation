# Add a World Boss

A World Boss is a strong, uncatchable variant of a Pokémon. The server spawns **one** of them,
at a random time after each start, at a fixed position. It broadcasts `World Boss: …` every 10
minutes while the boss is alive. Every player who dealt at least 10 % of the damage gets one
random item, at most once every 7 days. The model used in this tutorial is **Grisly Mind**,
an Alakazam boss.

Paths are relative to `server/` unless stated otherwise.

> **Not covered here:** Ranger Club bosses (`rangerClubBoss`, `creaturescripts.xml:55`),
> Frontier Island bosses (`monster/FrontierIsland/Boss/`), quest bosses with
> `boss*HealthChange` events (`creaturescripts.xml:35-44`) and legendary dungeons
> (`add-dungeon.md`). Each of these is a separate system.

---

## 1. The chain

```
globalevents/scripts/start.lua:40-43        ">> Loading Bosses..."  → doBossStart()
        │
lib/ps/systems/021-boss.lua
        │ LEVELS[HARD]   (storages 6104 / 6105, spawnMinInterval = 3 days)    lines 10-31
        │ BOSSES["Grisly Mind"] = {level, spawns, messages}                   lines 34-44
        │ doBossStart() picks ONE random boss per level, addEvent(doBossSpawn) lines 260-285
        │ doBossSpawn() → doCreateMonster(name, pos) → broadcast()            lines 242-258
        ▼
monster/monsters.xml:886   <monster name="Grisly Mind" file="Boss/alakazam.xml"/>
        │
monster/Boss/alakazam.xml  <flag boss="1"/>  …  <script><event name="bossReward"/></script>
        │                       │                          │
        │                       │      creaturescripts/creaturescripts.xml:53 (prepareDeath)
        │                       │                          ▼
        │                       │      lib/ps/events/creaturescripts/boss/bossReward.lua
        │                       │        REWARDS["Grisly Mind"] (lines 5-11), onPrepareDeath (191-219)
        │                       ▼
        │      src/monsters.cpp:1025-1026 → isBoss → src/monster.cpp:110-111 skull icon
        ▼
lib/ps/config/pokemon/grisly mind.lua   POKEMON["Grisly Mind"]  (types, stats, skills)
        used by the "Moves" attack: lib/ps/events/spells/Moves.lua:22 → getPokemonDefaultSkills
```

The monster **name** is the key that connects all five places: `BOSSES[...]`,
`REWARDS[...]`, `monsters.xml name=`, the monster XML `name=`, and `POKEMON[...]`. It is
compared exactly, including case, spaces and punctuation.

## 2. Files to edit

| File | What you add |
|------|--------------|
| `data/lib/ps/config/pokemon/<boss name>.lua` | `POKEMON["<Boss>"] = {...}` (stats, `skills`) |
| `data/monster/Boss/<base>.xml` | The monster: `name`, health, look, `<flag boss="1"/>`, `<flag catchable="0"/>`, the `bossReward` event |
| `data/monster/monsters.xml` | One `<monster name="<Boss>" file="Boss/<base>.xml"/>` line in the Boss block (lines 886-905) |
| `data/lib/ps/systems/021-boss.lua` | A `BOSSES["<Boss>"]` entry (before the closing `}` at line 219) |
| `data/lib/ps/events/creaturescripts/boss/bossReward.lua` | A `REWARDS["<Boss>"]` table (after `Kirby`, line 171) |
| `data/items/items.xml` (optional) | A new "artifacts" item, if the boss gets one (see `items.xml:24431`) |

## 3. Files NOT to edit

* `data/lib/ps/config/_pokemon/` and `data/lib/ps/others/pokemon_backup/`. Both contain a
  `grisly mind.lua`, but they are never loaded. Only `config/pokemon/` is loaded
  (`lib/ps/config/pokemon.lua:22`, `dodirectory`).
* `data/lib/ps/others/moves_disabled/`, `data/lib/ps/systems/disabled/`, `original/`,
  `data/npc/tmpCitizen_*.xml`, any unused `*-spawn.xml`.
* `data/world/map-spawn.xml`. World bosses are **not** map spawns. If you put one there, it
  respawns like a normal monster and ignores the 3-day rule.
* `globalevents/scripts/start.lua`. The boss loader is already registered at lines 40-43.
* `server/src/` C++. The `boss` flag and the datalog functions already exist.

## 4. Authoritative source paths

| Topic | Location |
|-------|----------|
| Reward cooldown storage and interval | `021-boss.lua:1-2` (`BOSS_REWARD_STORAGE = 8381`, `7 * 24 * 60 * 60`) |
| Level definitions | `021-boss.lua:10-31`. EASY and MEDIUM are commented out; only HARD is active |
| Boss list | `021-boss.lua:33-219` (20 bosses) |
| Spawn and broadcast | `021-boss.lua:231-258` |
| Start-up scheduling | `021-boss.lua:260-285` |
| Rewards | `bossReward.lua:1-171` |
| Reward logic | `bossReward.lua:174-219` |
| `/boss` command | `talkactions/talkactions.xml:23` → `lib/ps/events/talkactions/bossRewardCheck.lua` |
| Datalog | `doDatalogBossSpawn` (C++, `src/luascript.cpp:2680`, `src/iodatalog.cpp:87`); `doDatalogBossReward` (`lib/ps/systems/025-datalog.lua:37-46`) |
| Tables | `datalog_boss_spawns` (`src/schemas/psoul_extra_mysql.sql:525`), `datalog_boss_rewards` (`:641`) |

## 5. Real example: Grisly Mind

`021-boss.lua:34-44`:

```lua
    ["Grisly Mind"] = {
        level = BOSS_LEVEL_IDS.HARD,
        spawns = {{x = 4198, y = 217, z = 11}},
        messages = {
            "It wields a silver spoon in each hand.",
            "This is a large mustache!",
            "He is emerging dark psychic powers!",
            "Its brain can outperform a super-computer. Its intelligence quotient is said to be 5,000.",
            "A Pokemon that can memorize anything. It never forgets what it learns -- that's why this Pokemon is smart."
        }
    },
```

| Field | Consumed at | Meaning |
|-------|-------------|---------|
| `level` | `021-boss.lua:226-228` (grouping), `233`, `248-249` | Must be a key that exists in `LEVELS`. Today that is only `BOSS_LEVEL_IDS.HARD` |
| `spawns` | `243` (`table.random`) | One or more absolute positions. One is picked at random. The tile must exist and be walkable |
| `messages` | `236` | Broadcast lines. Half the time a line from `LEVELS[...].globalMessage` is used instead (`233-234`) |

`bossReward.lua:5-11`:

```lua
REWARDS["Grisly Mind"] = {
    {itemid = 18757, count = 1, chance = (CHANCE_MAX / 36), unique = false}, -- mastery stone
    {itemid = 18114, count = 1, chance = (CHANCE_MAX / 36), unique = false}, -- Grisly Mind artifacts
    {itemid = 14463, count = 1, chance = (CHANCE_MAX / 18), unique = false}, -- rare candy
    {itemid = 12233, count = 5, chance = (CHANCE_MAX / 18), unique = false}, -- mind plate
    {itemid = 2160, count = 2, chance = CHANCE_MAX, unique = false}, -- gold bar
}
```

How it is consumed (`giveRandomReward`, lines 179-189):

* The entries are tried **in order**. The first one whose roll `getRandom(1, 100000) <= chance`
  succeeds is given, and the loop stops. The player gets exactly **one** item.
* `count` is a maximum. The amount is `getRandom(1, count)` (line 182).
* `unique` is passed to `doPlayerSafeAddItem` (line 183).
* The cooldown storage 8381 is set **only when an item is given** (line 184). Always end the
  list with a `chance = CHANCE_MAX` entry. Otherwise an unlucky player gets nothing and no
  cooldown.

The monster file `monster/Boss/alakazam.xml` (lines 2-9 and 45-47):

```xml
<monster name="Grisly Mind" nameDescription="a Grisly Mind" race="blood" experience="15" speed="320" manacost="0" minLevel="100" maxLevel="100">
	<health now="5760" max="5760"/>
	<look type="1153" head="0" body="0" legs="0" feet="0" corpse="18127"/>
	...
	<flags>
		<flag boss="1"/>
		<flag catchable="0"/>
	...
	<script>
        <event name="bossReward"/>
	</script>
```

* `boss="1"` → `mType->isBoss` (`src/monsters.cpp:1025-1026`) → a skull icon over the boss
  (`src/monster.cpp:110-111`).
* `catchable="0"` → `isCatchable` (`monsters.cpp:1031-1032`).
* `<event name="bossReward"/>` must match the `name` in `creaturescripts.xml:53`. If it
  does not, the console prints `[Warning - Monster::Monster] Unknown event name - <name>`
  every time the boss is created (`monster.cpp:117-121`).
* `minLevel`/`maxLevel` = 100. The `Moves` attack only uses a skill if the monster's level is
  at least the level in `skills` (`Moves.lua:13`). Grisly Mind's skills are all level 100
  (`config/pokemon/grisly mind.lua:17`).
* The `<loot>` block (lines 36-44) **never drops**. `onPrepareDeath` removes the creature
  and returns `false` (`bossReward.lua:217-218`), so no corpse is created. Rewards come only
  from `REWARDS`.

The Pokémon entry `config/pokemon/grisly mind.lua` reuses Alakazam's `dexStorage` (10065),
`catchStorage` (16065) and portraits. Bosses are not catchable, so these are not counted
separately.

## 6. Required IDs and how to find free ones

A boss added to the existing HARD level needs **no new storage**. Storages 6104/6105 are
shared by the whole level, and the reward storage 8381 is shared by all bosses.

Check that the name is not already in use:

```bash
cd server/data
grep -n 'name="Rock Titan"' monster/monsters.xml
grep -rn '^POKEMON\["Rock Titan"\]' lib/ps/config/pokemon/
grep -n '\["Rock Titan"\]' lib/ps/systems/021-boss.lua lib/ps/events/creaturescripts/boss/bossReward.lua
```

All must return nothing. Avoid commas in the name. `/m` splits its argument on `,`
(`talkactions/scripts/creature.lua:8-10`), so `/m Cesar, The Simian` tries to summon `Cesar`
at the position of player ` The Simian` and answers `Player  The Simian not found.`.

The artifact item ids used so far are 18107-18126 (`grep -n 'artifacts' data/items/items.xml`).
A new item id also needs `items.otb` and client sprites; see the item section of
`CHECKLISTS.md`. Reusing existing items, as the Golem example below does, avoids that work.

## 7. Related dependencies

* The look type must exist in the client `data.dat` (`client/data/things/data.dat`).
  Reuse the base Pokémon's `look type` (Golem uses 427, `monster/Pokemons/golem.xml:4`).
* Every skill name in `POKEMON[...].skills` must exist in `config/moves/`. Otherwise
  `Moves.lua` errors at run time.
* Every reward `itemid` must exist in `items.xml`. `check_references.py` does not read
  `bossReward.lua`, so check this yourself: `grep -n 'id="12234"' data/items/items.xml`.
* `datalog_boss_spawns` and `datalog_boss_rewards` must exist (created by
  `psoul_extra_mysql.sql`).

## 8. Example: "Rock Titan" (a Golem boss)

**`data/lib/ps/config/pokemon/rock titan.lua`** (new file; copy `golem.lua`, keep the
storages and portraits, raise the stats, and set every skill level to 100):

```lua
POKEMON["Rock Titan"] = {
    -- Golem Boss
    pTypes = { ELEMENT_ROCK, ELEMENT_GROUND },
    dexStorage = 10076,
    atk = 120 * 6,
    def = 130 * 3,
    spAtk = 55 * 6,
    spDef = 65 * 3,
    energy = 100,
    chance = 800,
    portrait = 12777,
    dexPortrait = 13577,
    fastcallPortrait = 10710,
    catchStorage = 16076,
    evolutions = {},
    description = "It is enclosed in a hard shell that is as rugged as slabs of rock.",
    skills = { "Rock Throw", 100, "Magnitude", 100, "Rock Blast", 100, "Earthquake", 100, "Rock Slide", 100, "Stone Edge", 100, "Heavy Slam", 100 },
    abilities = {},
    eggGroup = {},
    eggId = 0,
    eggChance = 0,
    specialAbilities = { POKEMON_SPECIAL_ABILITY_IDS.ROCK_HEAD, POKEMON_SPECIAL_ABILITY_IDS.STURDY },
    learnableTms = true
}
```

**`data/monster/Boss/golem.xml`** (new file; copy `Boss/alakazam.xml` and change the name,
look, health and voices; drop the `<loot>` block because it never drops):

```xml
<?xml version="1.0" encoding="UTF-8"?>
<monster name="Rock Titan" nameDescription="a Rock Titan" race="blood" experience="15" speed="245" manacost="0" minLevel="100" maxLevel="100">
	<health now="6000" max="6000"/>
	<look type="427" head="0" body="0" legs="0" feet="0" corpse="11464"/>
	<targetchange interval="5000" chance="8"/>
	<strategy attack="100" defense="0"/>
	<flags>
		<flag boss="1"/>
		<flag catchable="0"/>
		<flag summonable="0"/>
		<flag attackable="1"/>
		<flag hostile="1"/>
		<flag illusionable="1"/>
		<flag convinceable="1"/>
		<flag pushable="0"/>
		<flag canpushitems="1"/>
		<flag canpushcreatures="0"/>
		<flag targetdistance="1"/>
		<flag staticattack="90"/>
		<flag runonhealth="0"/>
	</flags>
	<attacks>
		<attack name="physical" interval="0833" chance="34" range="7" min="-25" max="-55">
			<attribute key="shootEffect" value="smallstone"/>
		</attack>
		<attack name="Moves" interval="500" />
	</attacks>
	<defenses armor="10" defense="45"/>
	<elements>
	</elements>
	<voices interval="5000" chance="10">
		<voice sentence="GOLEM!"/>
	</voices>
	<script>
		<event name="bossReward"/>
	</script>
</monster>
```

Check that the shoot effect name is valid before you use it:
`grep -n '"smallstone"' server/src/tools.cpp`. If it is wrong, the console prints
`[Warning - Monsters::deserializeSpell] … Unknown shootEffect: …` (`monsters.cpp:841`).

**`data/monster/monsters.xml`**, after line 905 (`Kirby`):

```xml
	<monster name="Rock Titan" file="Boss/golem.xml"/>
```

**`data/lib/ps/systems/021-boss.lua`**, inside `BOSSES`, after the `Kirby` entry (line 218):

```lua
    ["Rock Titan"] = {
        level = BOSS_LEVEL_IDS.HARD,
        spawns = {{x = 4198, y = 217, z = 11}}, -- replace with a walkable tile you checked with /goto
        messages = {
            "The ground is shaking.",
            "A living mountain is rolling down the hills."
        }
    },
```

**`bossReward.lua`**, after `REWARDS["Kirby"]` (line 171):

```lua
REWARDS["Rock Titan"] = {
    {itemid = 18757, count = 1, chance = (CHANCE_MAX / 36), unique = false}, -- mastery stone
    {itemid = 14463, count = 1, chance = (CHANCE_MAX / 18), unique = false}, -- rare candy
    {itemid = 12234, count = 5, chance = (CHANCE_MAX / 18), unique = false}, -- stone plate
    {itemid = 2160, count = 2, chance = CHANCE_MAX, unique = false}, -- gold bar
}
```

The ids come from real entries: 18757 and 14463 are used by every boss, Stone Plate is
`items.xml:18177`, and 2160 is the gold bar used by every boss.

## 9. Registration steps

1. Create the Pokémon config file (§8).
2. Create the monster XML and register it in `monsters.xml`.
3. Add the `BOSSES` entry.
4. Add the `REWARDS` entry. **Do not skip this step.** Without it, `onPrepareDeath` logs
   `bossReward - Unknown reward.` and returns `true` (`bossReward.lua:193-196`). The boss
   then dies like a normal monster and drops its XML loot.
5. Run the validation in §13.
6. Restart the server. Monsters, `BOSSES` and the start-up schedule are only read at start
   (see §17 about `/reload`).

## 10. Database requirements

No schema change. The system uses:

| What | Where | Notes |
|------|-------|-------|
| Last boss name / date of the level | `global_storage` keys 6104 / 6105 | written by `doBossSpawn` (`021-boss.lua:248-249`) |
| Reward cooldown | `player_storage` key 8381 (Unix time) | per player |
| Spawn log | `datalog_boss_spawns` | `world_id, name, posx, posy, posz, date` |
| Reward log | `datalog_boss_rewards` | `player_id, item_id, count, date` |

To get the next boss sooner on a dev server, stop the server and remove the level's last
date. Global storages are kept in memory and saved by the server, so do not edit them while
it runs:

```sql
DELETE FROM global_storage WHERE `key` IN (6104, 6105);
```

With no date, `doBossStart` treats "now" as the last spawn (lines 263-266). The 3-day
minimum is then still added. In practice you test with `/m` instead (§14).

## 11. Client requirements

None, as long as the look type and the reward items already exist in the client. A new look
type or a new artifact item needs client sprites (`add-client-asset.md`).

## 12. Server requirements

* `worldType = "pvp"` in `config.lua` (BUG-01). Otherwise your Pokémon cannot attack.
* The MariaDB schema `psoul_extra_mysql.sql` must be imported (it creates the datalog tables).
* The boss position must be on the loaded map. `doCreateMonster` fails on a missing tile.

## 13. Validation steps

```bash
bash tools/check_syntax.sh                     # Lua and XML syntax, including the new files
python3 tools/check_references.py > /tmp/refs-after.txt
grep -n 'Rock Titan' /tmp/refs-after.txt       # must be empty: the monster file and the event name resolve
for f in server/data/lib/ps/systems/021-boss.lua server/data/lib/ps/events/creaturescripts/boss/bossReward.lua \
         server/data/monster/monsters.xml; do grep -c '"Rock Titan"' "$f"; done   # 1 each
```

`check_references.py` checks `monsters.xml` file paths (`monsters.xml.file`), the `<event
name>` against `creaturescripts.xml`, and spell and attack names. It does **not** check the
`BOSSES`/`REWARDS` names or the reward item ids.

Console lines at start-up:

```
>> Loading Bosses...
>> Scheduled Boss Spawn: <one boss name> in <N hours, M minutes, …>
> Done in 0.00 seconds
```

Only **one** name is printed, because `doBossStart` picks one random boss of the HARD level
per start (`021-boss.lua:270`). Your boss is in the pool, but it will not appear every time.
You should see no `[Warning - Monsters::loadMonster]` or
`[Warning - Monster::Monster] Unknown event name` line mentioning your file.

## 14. Test steps

Use **GM Admin** to spawn. Any character with a strong Pokémon can fight; GM Pokémon never spend
energy (BUG-05, fixed), so use **Tester** (`admin`/`admin`) or **Trainer** (`player`/`player`) for
a fight that should feel like a normal player's.

1. As GM Admin, go next to Tester and say `/m Rock Titan`. The boss appears with a skull
   icon. If the name is wrong, you get `Sorry, not possible.` (`creature.lua:17-19`).
   `/m` creates the boss at **your** position. It does not use `spawns` and does not
   broadcast; only the scheduled spawn does that.
2. As Tester, check the cooldown first: `/boss` →
   `You are able to receive another World Boss reward.` (`bossRewardCheck.lua:4`).
3. Fight the boss with Tester's Pokémon and deal at least 10 % of its damage
   (`REQUIRED_DAMAGE_RATIO`, `bossReward.lua:2`).
4. When it dies:
   * 12 energy-ball effects around it (lines 213-215), and no corpse;
   * Tester receives one item from `REWARDS["Rock Titan"]`;
   * `server/logs/Info - <dd-mm-YYYY>.log` gets a line
     `bossReward - Killer / Ratio / CanReceiveReward` with the ratio (line 201).
5. As Tester, `/boss` again →
   `You must wait 6 days, 23 hours, … to be able to receive another World Boss reward.`
6. Spawn and kill a second one → no item, and the same "You must wait" message.
7. Check the logs in the database:

   ```sql
   SELECT * FROM datalog_boss_rewards ORDER BY id DESC LIMIT 5;
   ```

8. Reset the cooldown as GM Admin: `/storage Tester,8381,-1`.

To test the **scheduled** spawn path (broadcast, `spawns`, `datalog_boss_spawns`), temporarily
remove the other bosses from the pool on a local branch, or wait for the random pick. Do not
commit such a change.

## 15. Common mistakes

* The name differs in one of the five places (for example `Rock titan` in `REWARDS`). The
  boss then dies normally, drops its XML loot, and `bossReward - Unknown reward.` is logged.
* No final `chance = CHANCE_MAX` entry. Some kills give nothing, and the 7-day cooldown is not
  set for those players.
* Using `level = BOSS_LEVEL_IDS.EASY` or `MEDIUM`. Those levels are commented out
  (`021-boss.lua:11-18`). `BOSSES_BY_LEVEL[...]` exists for them (lines 221-224), but the
  boss is never scheduled, and `broadcast` would index `LEVELS[nil]`.
* Skill levels below 100 are fine, but skills **above** the monster's level are never used.
* Expecting the boss to respawn after it dies. It is scheduled once per server start.
* Putting the boss in `map-spawn.xml`.
* Copying the `<loot>` block and expecting drops.

## 16. Failure symptoms

| Symptom | Cause |
|---------|-------|
| `[Warning - Monsters::loadMonster] Cannot load monster (Rock Titan) file (…).` | Wrong `file=` path, or a case mismatch on Linux |
| `[Error - Monsters::loadMonster] Malformed monster (Rock Titan) file (…).` | XML syntax error (`check_syntax.sh` shows it) |
| `[Warning - Monsters::loadMonster] Duplicate registered monster with name: …` | The name is already in `monsters.xml` |
| `[Warning - Monster::Monster] Unknown event name - bossReward` | The `creaturescripts.xml:53` entry is missing or misspelled |
| `Sorry, not possible.` after `/m` | The name is not in `monsters.xml` |
| `[Error - Spell Interface]` with `attempt to index … nil` from `Moves.lua` | No `POKEMON["<name>"]` entry (`pokemon.lua:1371`), or a skill name that is not a move |
| `doBossSpawn - Can't spawn boss at position.` in `server/logs/Error - <date>.log` | The `spawns` tile is missing, blocked or occupied |
| `[Error - CreatureScript Interface] … Player not found` when a player on cooldown kills a boss | Known defect: `bossReward.lua:206` calls `__L(cid, …)` with the **boss** id. The message is still sent, but not translated |
| Boss drops a corpse with loot | `REWARDS` entry missing or the name differs |

## 17. Rollback advice

* `git checkout -- <files>` (uncommitted) or `git revert <commit>`. Remove all five pieces
  together. A `BOSSES` entry without a monster makes the scheduled spawn fail with
  `doBossSpawn - Can't spawn boss at position.` on the day it is picked.
* `/reload` cannot apply or undo this change safely:
  * `/reload monsters` re-reads monster XML, but not `BOSSES` or the schedule;
  * `/reload creaturescripts` reloads `bossReward.lua` (rewards only);
  * `021-boss.lua` lives in `lib/` and is only loaded into the interfaces when they are
    created. The schedule is set by `doBossStart` at start-up.

  Restart the server.
* Rewards already given stay with the players. The `datalog_boss_rewards` rows record them.
* If the boss was the last spawned one, `global_storage` key 6104 still holds its name. That
  is harmless: the value is only compared with the next random pick (lines 269-277).
