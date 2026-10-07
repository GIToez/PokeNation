# PokeNation tutorials

Step-by-step guides for changing game content. They are written for readers who can edit text
files and run scripts but do not know TFS, OTClient, Lua, C++ or SQL in depth. Every tutorial
uses real repository examples with `file:line` references, and every one has the same sections:
files to edit and not to edit, IDs and how to find free ones, dependencies, example code,
registration, database/client/server requirements, validation, test steps, common mistakes,
failure symptoms and rollback.

Background for all of them: [`docs/DEVELOPER_HANDBOOK.md`](../DEVELOPER_HANDBOOK.md). In
particular, §7.1 explains server ids vs client ids, §8.2 explains that a Pokémon lives inside
its ball item, §9 covers testing, and §10.3 says what `/reload` can and cannot do.

Unless a tutorial says otherwise, paths are relative to `server/`, except paths that start with
`docs/`, `tools/` or `client/`.

---

## Pokémon, moves and evolutions

| Tutorial | What it covers |
|----------|----------------|
| [add-pokemon.md](add-pokemon.md) | Add a new species (model: Eevee): config file, monster XML, numbers, portraits, Pokédex, client data; ends with a dependency checklist |
| [edit-pokemon.md](edit-pokemon.md) | Change an existing species safely: what is stored on the ball vs read live, why `skills` is append-only |
| [add-evolution.md](add-evolution.md) | Add or change an evolution (level, stone, time of day, random, extra Pokémon) and how the evolve icon decides |
| [add-move.md](add-move.md) | Add a move (model: Tackle, Earthquake, Agility): config, spell script, `spells.xml`, species list, client icon; ends with a dependency checklist |
| [edit-move.md](edit-move.md) | Change a move's power, energy (×0.75 rule), cooldown, range or element without breaking existing balls |
| [add-tm.md](add-tm.md) | Add a Technical Machine (model: TM 06 Toxic, 17342): `TM_IDS`, `TMS`, item, `learnableTms`, the replace-move window |

## Items, balls and catching

| Tutorial | What it covers |
|----------|----------------|
| [add-item.md](add-item.md) | Add an item (model: pokemon health potion 12244): `items.otb`, sprite, `items.xml`, action script, shops; finding free ids; ends with a dependency checklist |
| [edit-item.md](edit-item.md) | Change names, descriptions, prices, loot glow and behaviour of existing items (Fire Stone 18083, Calcium 23450, potions) |
| [add-held-item.md](add-held-item.md) | Add a held item (model: Black Belt 23513) that boosts one element and levels up, plus the vitamin system (Calcium) |
| [add-pokeball.md](add-pokeball.md) | Add a ball type (model: poke ball 12157-12160): the four item states, `balls`, `CATCH_RATE`, action/movement bindings, `ball_counter` column; ends with a dependency checklist |
| [edit-catch-rate.md](edit-catch-rate.md) | How a catch is decided (species `chance`, ball rate, tries, skill, `rateCatch`) with a worked Eevee example, and which number to change |

## NPCs, quests and progression

| Tutorial | What it covers |
|----------|----------------|
| [add-npc.md](add-npc.md) | Add a talking NPC (models: Nurse Joy, Jack Simps) and place it on the map |
| [add-trainer.md](add-trainer.md) | Add an NPC trainer that battles the player (model: Chandra Wigington, a Pewter gym trainer) |
| [add-gym-leader.md](add-gym-leader.md) | Add a gym leader: badge, required gym trainers, rewards (model: Brock) |
| [add-quest.md](add-quest.md) | Add an NPC quest as data in `003-quest.lua`, with an optional quest-log entry (model: Jack Simps) |
| [edit-quest.md](edit-quest.md) | Change an existing quest that players may have started: safe edits and edits that need a data migration |
| [add-achievement.md](add-achievement.md) | Add an achievement: definition, granting call, `player_achievements` rows, quest-log display |

## World and events

| Tutorial | What it covers |
|----------|----------------|
| [add-spawn.md](add-spawn.md) | Add a wild Pokémon or NPC spawn in `map-spawn.xml` (model: a Rattata spawn) |
| [edit-map-content.md](edit-map-content.md) | Edit the map, spawns and houses (`map.otbm` with RME, `map-spawn.xml`, `map-house.xml`) |
| [add-dungeon.md](add-dungeon.md) | Add a mastery dungeon (timed, per player), with the legendary dungeon pattern as a reference |
| [add-boss.md](add-boss.md) | Add a World Boss: spawn, broadcast, damage-share rewards (model: Grisly Mind) |

## Commands, client and database

| Tutorial | What it covers |
|----------|----------------|
| [add-command.md](add-command.md) | Add a chat command (talkaction), for players or GMs with an access level (model: `/autoloot`) |
| [add-client-asset.md](add-client-asset.md) | Add a client image, sprite or item graphic, and the rule that the legacy client is a frozen reference |
| [database-changes.md](database-changes.md) | Change the database safely: schema files, `ALTER TABLE` on existing databases, item/player data, backups |
| [CHECKLISTS.md](CHECKLISTS.md) | All dependency checklists in one place, for reviewing a change before it is committed |

---

## Shared tools

| Tool | Use |
|------|-----|
| `tools/check_syntax.sh [subtree]` | Lua and XML syntax check. Ends with `Lua: N files, N with syntax errors; XML: N files, N malformed` |
| `python3 tools/check_references.py` | Cross-file reference check (items, moves, TMs, evolutions, scripts, shops, spawns, SQL tables). Options `--all`, `--markdown`, `--json`, `--strict` |
| `tools/start_server.sh`, `tools/start_client.sh` | Run the stack for test steps (`docs/DEVELOPER_HANDBOOK.md` §9) |
| `docs/PHASE_2_TEST_MATRIX.md` | The tested GM/player flows whose exact messages the tutorials quote (P2-xx) |
| `docs/BUG_TRIAGE.md` | The BUG-xx numbers referenced in the tutorials |

GM test characters: **GM Admin** creates things (`/i`, `/m`, `/mypokemon`). Its Pokémon can use
moves but never spend energy (infinite-mana GM groups, BUG-05 fixed). Use **Tester**
(`admin`/`admin`) or **Trainer** (`player`/`player`) whenever energy costs matter. Items created with `/i` land in a hidden backpack (BUG-12); use
`/i <id>,<count>,true` to drop them on your tile instead.
