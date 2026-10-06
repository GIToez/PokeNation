# Historical / duplicate code trees vs. active data

Scope: the four non-loaded trees under `server/data/lib/ps/` compared against the active
Pokémon, move and system definitions. Nothing was modified or deleted; this is a read-only
analysis. "Verified" statements come from reading loaders/files or from a scripted comparison;
"Inference" statements are marked as such.

Method: file sets were compared with Python `filecmp`; because `pokemon_backup/` uses a compact
one-line layout, a plain `diff` flags almost everything, so every `*.lua` was additionally
evaluated with `lua5.1` using placeholder globals (`TM_IDS.X`, `POKEMON_ABILITIES.X`, ...) and
the resulting `POKEMON[...]` tables were compared field by field ("semantic" comparison below).
File mtimes were preserved by the import and are used as the only dating evidence (git history is
a single import commit `dc9fb02`; no version comments exist in any of the four trees).

## Summary table

| Tree | Files | Identical to active | Changed | Only in old | Only in active | Loaded at runtime? | Recommendation |
|---|---|---|---|---|---|---|---|
| 1. `config/_pokemon/` | 432 | 84 (textual = semantic) | 348 (all: `learnableTms` only, +1 level fix) | 0 files / 0 entries | 0 | No | Archive then remove; nothing to merge |
| 2. `others/pokemon_backup/` | 304 | 1 textual (`ditto.lua`), 44 semantic | 253 files / 410 entries | 7 files, 8 entries | 135 files (gen 3) | No | Archive; merge back 5 Halloween boss entries |
| 3. `others/moves_disabled/` | 9 | 0 (no active `MOVES[...]` for any) | n/a | 9 move configs | n/a | No | Archive; only `clientIconId`s and cooldown storages reusable |
| 4. `systems/disabled/005-task.lua` | 1 | n/a (no active counterpart) | n/a | 1 | n/a | No | Archive; superseded by Ranger Club + `DEFEAT_POKEMON` quests |

Entry counts: active config defines 594 `POKEMON[...]` entries from 432 files; `_pokemon` also
594/432; `pokemon_backup` 469 unique entries (471 definitions; `Deoxys` is defined three times).

## A. Loader verification (what is actually loaded)

Verified from `server/data/lib/999-ps.lua` and the engine:

- `server/src/luascript.cpp:844` loads `data/lib/` via `loadDirectory`.
  `loadDirectory` (`luascript.cpp:721-740`) iterates one directory level, skips sub-directories
  (`!boost::filesystem::is_directory(...)`, line 728) and only takes `*.lua`. It is **not recursive**.
  `dodirectory` (`luascript.cpp:11565`) is the Lua binding of the same function.
- `999-ps.lua:10-12` loads exactly three files from `others/`: `constants.lua`, `logger.lua`,
  `outfits.lua`. `others/pokemon_backup/` and `others/moves_disabled/` are never referenced.
- `999-ps.lua:21` -> `config/pokemon.lua:22`: `dodirectory(PS_LIB_CONFIG_DIR .. "pokemon/")`.
  Only `config/pokemon/` is iterated; `config/_pokemon/` is never referenced.
- `999-ps.lua:24` -> `config/skill.lua:52`: `dodirectory(PS_LIB_CONFIG_DIR .. "moves/")`.
- `999-ps.lua:40`: `dodirectory(PS_LIB_SYSTEMS_DIR)`; because `loadDirectory` is non-recursive,
  `systems/disabled/005-task.lua` is skipped. `005-task.lua:1` even prints
  `"IF YOU SEEING THIS, THE OLD TASK SYSTEM IS BEEING LOADED"` as a guard.
- A `ripgrep` over all of `server/data/` (excluding the trees themselves) for `_pokemon/`,
  `pokemon_backup`, `moves_disabled`, `systems/disabled`, `005-task` returns no hits.

Conclusion (verified): none of the four trees is loaded or referenced at runtime.

## Tree 1: `config/_pokemon/` (432 files)

File set: identical to `config/pokemon/` (same 432 names, 0 only-old, 0 only-active).
Textual: 84 files byte-identical, 348 differ. Semantic: 104 entries identical, 490 changed.
mtimes: 2016-12-19 .. 2017-07-10 (active: 2016-12-19 .. 2017-08-18).

Kinds of differences (verified by field comparison):

| Category | Entries affected |
|---|---|
| `learnableTms` list extended in active | 490 (active is a strict superset in every case; nothing removed) |
| `skills` level fix | 1 (`Whiscash`: `"Fissure", 55` -> `"Fissure", 60`, `whiscash.lua:16`) |
| stats, types, evolutions, abilities, eggMoves, specialAbilities, new/removed fields, formatting | 0 |

Both trees share the identical field schema (26 keys incl. the typo field `blocTraknsform` in 2
entries and `price` in 1). No formatting-only differences exist.

TMs added in active (count of entries): BRICK_BREAK 208, FOCUS_PUNCH 176, SHOCK_WAVE 165,
LIGHT_SCREEN 149, SAFEGUARD 131, SANDSTORM 128, HAIL 124, TAUNT 117, ROAR 109, CALM_MIND 72,
BULLET_SEED 58, OVERHEAT 54, BULK_UP 35, DRAGON_CLAW 30. These are the gen-3 TMs defined in
`systems/018-technicalMachine.lua` (e.g. `FOCUS_PUNCH` at line 484, `LIGHT_SCREEN` 533,
`BRICK_BREAK` 545, `SHOCK_WAVE` 551).

Representative diff (`diff config/_pokemon/pikachu.lua config/pokemon/pikachu.lua`, line 22, TM_IDS prefix stripped):

```
<  ..., REST, THUNDER_WAVE, SUBSTITUTE },
>  ..., REST, THUNDER_WAVE, SUBSTITUTE, FOCUS_PUNCH, LIGHT_SCREEN, BRICK_BREAK, SHOCK_WAVE },
```

Side finding in the **active** tree only (not present in `_pokemon`): the TM additions introduced
misspelled identifiers that evaluate to `nil` at runtime, so the TM is silently not learnable:
`TM_IDS.FOCUS_PUNHC` (11 entries), `LIGHT_SCRREN` (3), `SHOKC_WAVE` (2), `SHOCK__WAVE`,
`ROARBRICK_BREAK`, `SANDSTORMONIX`, `CARVANHA`, `JUMPLUFF` (1 each). Files:
`config/pokemon/{bagon,blastoise,carvanha,cleffa,igglybuff,jumpluff,lickitung,pichu,raticate,regice,squirtle,wartortle}.lua`.
Inference: `_pokemon/` is the snapshot taken immediately before the gen-3 TM bulk edit
(2017-07) and is otherwise the same generation of data as the active tree.

## Tree 2: `others/pokemon_backup/` (304 files)

File set vs `config/pokemon/`: 297 in both; 7 only in backup
(`castform_{normal,fire,ice,water}.lua`, `deoxys_{atk,def,speed}.lua`); 135 only in active
(all 3rd-generation Pokémon, `absol.lua` .. `zigzagoon.lua`, plus `castform.lua`, `deoxys.lua`).
Textual: 1 identical (`ditto.lua`), 296 differ. Semantic: 44 files / 51 entries identical
(so 43 files differ by formatting only), 253 files / 410 entries changed, 8 entries only in old.
mtimes: 2013-02-18 .. 2017-04-28. Layout is the older compact style
(e.g. `pikachu.lua:2` holds 12 fields on one line); active uses one field per line.

Kinds of differences (verified; entries affected):

| Category | Entries | Notes |
|---|---|---|
| Formatting only | 51 entries / 43 files | e.g. bosses `smaug.lua`, `kirby.lua`, `team rocket.lua`, test Pokémon |
| `learnableTms` | 400 | 203 active-superset, 32 active-subset, 163 mixed. Added: same gen-3 TMs as tree 1. Removed in active: `TM_IDS.EGG_BOMB` from 195 entries (still defined at `018-technicalMachine.lua:224`) |
| `skills` (moveset) | 358 | 321 changed move sets, 37 only level/order. Most added in active: Last Resort 19, Iron Tail 18, Swift/Air Slash/Assurance 13 each. Most removed: Scary Face 10, Confuse Ray 8, Take Down/Disable/Rage/Defense Curl/Water Gun 7 each |
| `specialAbilities` | 20 | active adds a second ability (e.g. `Chinchou` +ILLUMINATE, `Grimer`/`Muk` +STICKY_HOLD, `Igglybuff`/`Wigglytuff` +COMPETITIVE) |
| `allowedBall` removed | 18 | all `Christmas <X>` variants had `allowedBall = "christmas"`; active comments it out (`bulbasaur.lua:40`) |
| `chance` | 5 | `Easter {Bulbasaur,Charmander,Pikachu,Squirtle}` 100 -> 150; `Deoxys` 300 -> 1000 |
| base stats | 1 | `Deoxys` atk/spAtk 95 -> 150, def/spDef 90 -> 50 (backup `deoxys_speed.lua` wins load order; `deoxys_atk.lua` has 180/20) |
| `evolutions` | 1 | `Wartortle` -> Blastoise `requiredLevel` 50 -> 55 (`wartortle.lua:3` vs active `:14`) |
| `abilities` | 4 | `Castform` +HEADBUTT, `Deoxys` +BLINK/TELEPORT; `Mewtwo`/`Final Mewtwo` `"Rock Smash"` -> `"RockMSmash"` (typo introduced in active `mewtwo.lua`) |
| `portrait`/`fastcallPortrait` | 1 | `Deoxys` placeholders (`-1`, `x`) filled in active |
| New / removed fields | 0 | identical 26-key schema in both trees |

Representative excerpts:

1. `pikachu.lua` moveset and TM (backup line 5/8 vs active 16/22):
```
old: ..., "Thunderbolt", 25, "Electro Ball", 30 }      learnableTms = { ..., TM_IDS.EGG_BOMB, TM_IDS.SKULL_BASH, ... }
new: ..., "Thunderbolt", 25, "Agility", 30 }           learnableTms = { ..., TM_IDS.SKULL_BASH, ..., TM_IDS.SHOCK_WAVE }
```
2. `aipom.lua` moveset expanded from 9 to 14 moves:
```
old: "Tickle", 20, "Swift", 25, "Agility", 30, "Double Hit", 35, "Nasty Plot", 40
new: "Swift", 20, "Astonish", 25, "Low Sweep", 30, "Shadow Claw", 35, "Rest", 40, "Agility", 45, "Brick Break", 50, "Uproar", 55, "Iron Tail", 60, "Last Resort", 65
```
3. `alakazam.lua`: `"Disable", 25 ... "Reflect", 55` -> `"Reflect", 25 ... "Psyshock", 55, "Miracle Eye", 60, "Dazzling Gleam", 65, "Future Sight", 70`.
4. `bulbasaur.lua` Christmas variant: `POKEMON["Christmas Bulbasaur"].allowedBall = "christmas"` (backup :27) vs commented out (active :40). `allowedBall` is enforced in `functions/ball/empty.lua:193`, so in the active data Christmas Pokémon can be caught with any ball.
5. `deoxys_atk.lua` / `deoxys_def.lua` / `deoxys_speed.lua`: three form drafts all assigning `POKEMON["Deoxys"]`, with `portrait = -1`, `fastcallPortrait = x` (undefined global -> nil). Active `deoxys.lua` is a single merged entry with real portrait ids.
6. `castform_fire.lua` (and `_ice`, `_water`): separate `POKEMON["Castform Fire"]` entries with mono-type, `learnableTms = { --[[ TODO ]] }`, `fastcallPortrait = x`. Active has only `POKEMON["Castform"]`; `FORECAST` in `systems/017-specialAbilities.lua:645-648` is description-only (no form switching implemented).

Entries that exist ONLY in the backup (verified):

| Entry | Backup file | Referenced by active data? |
|---|---|---|
| `Charculla` | `charizard.lua:35-43` | yes: `monster/monsters.xml:846`, `monster/Quest/charculla.xml`, `npc/scripts/quest_halloween_will_kid.lua:46` |
| `Darkeon` | `jolteon.lua:16-24` | yes: `monsters.xml:845`, `Quest/darkeon.xml`, `quest_halloween_will_kid.lua:46`, `spells.xml:506` |
| `Maskmar` | `magmar.lua:19-27` | yes: `monsters.xml:844`, `Quest/maskmar.xml`, `quest_halloween_will_kid.lua:46`, `spells.xml:504-505` |
| `Cursed Gengar` | `gengar.lua:19-25` | yes: `monsters.xml:843`, `quest_halloween_will_kid.lua:22` |
| `White Gengar` | `gengar.lua:27-33` | yes: `monsters.xml:842`, `quest_halloween_will_kid.lua:22`, `movements/events/halloween/cursedBedsheet.lua:7` |
| `Castform Fire/Ice/Water` | `castform_*.lua` | no |

The five Halloween bosses are `table.deepcopy` variants with `blockTransform = true`,
`specialAbilities = { SUMMI }`, custom Dark dual-typing/movesets and x3 (Maskmar def x6) stats.
The NPC `Will Kid` (`npc/Will Kid.xml` -> `quest_halloween_will_kid.lua`) still calls
`npcBattle:setPokemons({ "Charculla", "Darkeon", "Maskmar" })`; `systems/001-npcBattle.lua:576`
then calls `getPokemonTypes(nil, pokemon1)`, which logs an error and indexes `nil` for an unknown
name (`config/pokemon.lua:1282-1285`). Inference: the Halloween Will Kid battle would error at
runtime in the active data unless these five entries are restored.

Inference on age: the backup has no 3rd-gen Pokémon except Castform/Deoxys drafts, still has
`EGG_BOMB` TMs, pre-rebalance movesets and the Christmas `allowedBall`; it is a late-2016 /
early-2017 snapshot (file dates up to 2017-04-28) taken before the gen-3 roll-out and the 2017
moveset rebalance.

## Tree 3: `others/moves_disabled/` (9 files)

None of the nine names has a `MOVES["..."]` entry anywhere in `config/moves/` (verified by grep),
so none is a usable move today. mtimes 2017-03-17 .. 2017-04-28.

| File | Move | Active config | Active script (`events/spells/scripts/`) | `spells.xml` | What differs / state |
|---|---|---|---|---|---|
| `block.lua` | Block | none | none | none | STATS-type stub, no `functionName`, storage 15445 |
| `false swipe.lua` | False Swipe | none | none | none | verbatim copy of Tackle (description, `functionName = "Tackle"`, storage 15086 = Tackle's) |
| `feint.lua` | Feint | none | `Feint.lua` (10 lines, plain `doSkillDamage`) | line 282, `*st277` | config stub (damage 30, storage 15441); script exists but is orphaned without a `MOVES` entry |
| `final gambit.lua` | Final Gambit | none | `Final Gambit.lua` (copy of Tackle script) | line 275 | stub, damage 0, storage 15456 |
| `grudge.lua` | Grudge | none | `Grudge.lua` (copy of Tackle script) | line 483 | STATS stub, storage 15450 |
| `me first.lua` | Me First | none | `Me First.lua` (24 lines, Mimic-derived: `getPokemonLastUsedMove`) | line 281 | stub, storage 15442; the only script with real logic |
| `spikes.lua` | Spikes | none | `Spikes.lua` (copy of Tackle script) | line 348 | STATS stub but `damage = 60`, storage 15439 |
| `whirlwind.lua` | Whirlwind | none | none | none | verbatim copy of Tackle, storage 15086 |
| `wide guard.lua` | Wide Guard | none | `Wide Guard.lua` (copy of Tackle script) | line 361 | STATS stub, storage 15447 |

All `spells.xml` entries use `enabled="0"` exactly like every working move (e.g. Tackle, line
146), so that attribute does not indicate disabling. Cooldown storages 15439-15456 are unused by
any active move (active max is 15457, `skill.lua:1` notes last used 15437, which is stale);
`clientIconId`s 27654-27669 are in the same icon range the active gen-3 moves use
(`simple beam.lua` 27663, `nature power.lua` 27662), so they are probably real client sprites.
77 active Pokémon files list these names in `eggMoves`; that is harmless because
`doUpdatePokemonEggMovesList` (`config/pokemon.lua:1668`) drops moves for which
`getPokemonSkillExists` is false. No active Pokémon lists them in `skills`.

Useful only here: the reserved `cooldownStorage`/`clientIconId` values and descriptions for
Block, Feint, Final Gambit, Grudge, Me First, Spikes, Wide Guard. The two Tackle clones
(False Swipe, Whirlwind) contain nothing of value. Inference: these were work-in-progress gen-3
moves parked when their mechanics (turn-based protect/entry-hazard semantics) could not be
mapped onto the real-time combat.

## Tree 4: `systems/disabled/005-task.lua` (1 file, mtime 2015-04-16)

What it did (verified from the file): a linear chain of "defeat N of Pokémon X" tasks.
`TASKS` (lines 12-98) maps a Pokémon name to `taskStorage`, `defeatsStorage`, `defeats`,
`rewards` (item id / count pairs), `expReward`, `nextTask`. Storages are
`20000 + 1..170` (line 4). Public API: `doTaskDefeat(cid, task)` (line 146) increments the
counter and on completion gives exp + items, sets the storage to `finished` and calls
`doPlayerAddStatistic(cid, PLAYER_STATISTIC_IDS.COMPLETE_TASK, 1)` (line 138). Auto-starting the
next task is already commented out (lines 140-143). There is no `startTask` entry point exposed
(it is `local`), so it needed an NPC/script to start tasks, and none exists in the data.

Defects in the file itself: duplicate keys `Scyther`, `Venusaur`, `Tentacruel`, `Pidgeot`,
`Blastoise`, `Gengar`, `Alakazam`, `Gyarados` (later definition wins in Lua), and storage
collisions `Tentacruel.taskStorage = base+132` = `Nidoking.defeatsStorage`,
`Gyarados = base+134` = `Arcanine.defeatsStorage`, `Gengar = base+136` = `Tentacruel.defeatsStorage`.

Dependencies that may be missing: no caller of `doTaskDefeat` exists anywhere in
`server/data/` outside this file (verified); no NPC starts tasks; storage range 20001-20170 is
not declared in `config/playersStorages.lua`/`storages.lua` (verified: no hits), so re-enabling
would need a collision audit. Item ids used for rewards (12157, 12161, 12165, 12244, 12248, 2148,
2152, 12229-12245, 13807) were not checked against `items.xml`.

What replaces it in the active tree (verified):
- `systems/029-rangerClub.lua` + `config/001-rangerClub.lua`: `RangerClub.TASKS` with
  `monster = "RC <Pokémon>"`, per-task `defeatsStorage`, `getPlayerTask/TaskDefeats`, shown in
  the quest log (`events/creaturescripts/onQuestInfo.lua:28-33`).
- `systems/002-quest.lua`: `QUEST_TYPE.DEFEAT_POKEMON` (line 12, 94-95, 159, 218, 502) with
  quests in `config/003-quest.lua` ("Thanks! Your task is defeat 30 Golem.", lines 861-930).
- Orphan left behind: `PLAYER_STATISTIC_IDS.COMPLETE_TASK` (`others/constants.lua:358`) is still
  handled in `onStatisticChange.lua:48-49` (`ACHIEVEMENT_IDS.TASKS`) but nothing increments it
  any more; the "Tasks" achievement is therefore unreachable in the active data.

## Useful material found only in historical copies

1. The five Halloween boss Pokémon entries (`Charculla`, `Darkeon`, `Maskmar`, `Cursed Gengar`,
   `White Gengar`) in `pokemon_backup/{charizard,jolteon,magmar,gengar}.lua`. Their monster XMLs,
   NPC script, custom spells and outfits are still active; only the `POKEMON` table entries are
   missing. This is the one piece of content worth merging back (after re-checking the move names
   they use exist in `config/moves/`).
2. `allowedBall = "christmas"` on 18 Christmas variants (backup) vs commented out in active. Whether
   the active state is intentional cannot be verified; worth a decision by the maintainer.
3. Castform form drafts and Deoxys form drafts (stats 180/20 attack form, 95/90 speed form) as
   design reference only; no form-switching system exists.
4. `moves_disabled/`: reserved `cooldownStorage` 15439-15456 and `clientIconId` 27654-27669 for
   seven moves, usable if those moves are ever implemented.
5. `005-task.lua`: the reward/defeat progression table could seed a Ranger Club or quest chain,
   but the mechanism is fully superseded.
6. Old-mechanics evidence: `TM_IDS.EGG_BOMB` was learnable by 195 Pokémon before the gen-3 TM
   rebalance; pre-rebalance movesets for ~321 Pokémon (e.g. Pikachu `Electro Ball` at 30).

No older formula fields, stat schemas or mechanics flags were found: all three Pokémon trees use
the same 26-key schema, and `pokemon.lua`'s stat/price/egg functions do not consume anything that
exists only in the old copies.

## Recommendation

| Tree | Recommendation | Rationale |
|---|---|---|
| `config/_pokemon/` | Move to `/original` (or `docs/archive`) and drop from `server/data/` later | Differs from active only by the gen-3 TM additions and one level fix; zero unique content. Keeping it inside `config/` invites confusion with the loaded `pokemon/` directory. Before archiving, fix the 8 misspelled `TM_IDS` in the active files listed in Tree 1. |
| `others/pokemon_backup/` | Archive to `/original`; first merge back the 5 Halloween boss `POKEMON` entries into the active `charizard/jolteon/magmar/gengar.lua`; review `allowedBall = "christmas"` | Pre-gen-3 snapshot with older movesets/TMs; the boss entries are required by still-active quest content. |
| `others/moves_disabled/` | Archive to `/original`; optionally note the reserved storages/icon ids in `config/skill.lua`'s header comment | Nine stubs without implementation; the matching orphan scripts in `events/spells/scripts/` and `spells.xml` lines can be cleaned up in the same pass if the moves are not going to be implemented. |
| `systems/disabled/005-task.lua` | Archive to `/original`; remove later | Fully superseded by Ranger Club and `DEFEAT_POKEMON` quests; broken storage table; nothing calls it. Decide whether to retire or re-wire `PLAYER_STATISTIC_IDS.COMPLETE_TASK`/`ACHIEVEMENT_IDS.TASKS`. |

Nothing was deleted or moved as part of this analysis.
