# Add (or change) an evolution

This tutorial adds an evolution to an existing species. The examples are real:

* **Eevee** (`data/lib/ps/config/pokemon/eevee.lua:14-20`): five branches using stones,
  Soothe Bell, and day/night;
* **Wurmple** (`wurmple.lua:15-16`): a random branch;
* **Nincada** (`nincada.lua:15-16`): an extra Pokémon (Shedinja) given on evolution.

All paths are relative to `server/` unless they start with `docs/`, `tools/` or `client/`.

---

## 1. How an evolution is triggered

```
player uses the evolve icon 13204 (inventory slot 2, or the client's right-click "Evolve")
  → data/actions/actions.xml:34  <action itemid="13204" … value="../../lib/ps/events/actions/evolve.lua"/>
  → lib/ps/events/actions/evolve.lua:7-83 onUse
        getPokemonEvolutions(name)            config/pokemon.lua:1438-1443
        check requiredItems / requiredTime / requiredLevel   (lines 26-37)
        pick one branch (random / single)                    (lines 39-61)
        getMonsterInfo(target) must exist                    (line 63)
        remove requiredItems, give extraPokemon              (lines 64-75)
  → lib/ps/functions/pokemon.lua:175-215 doPokemonEvolve
        set ball name, re-roll special ability if needed, 3 messages, doPokemonUpdate
```

Wild Pokémon whose monster XML has `<attack name="Evolve" …/>` (`spells.xml:4` →
`lib/ps/events/spells/Evolve.lua`) evolve by themselves. This happens when their HP is
below 10% and `requiredLevel - level <= 20`, and only if the creature was flagged evolvable
(`canWildPokemonEvolve`, `functions/pokemon.lua:278-280`). Wild evolution **ignores**
`requiredItems` and `requiredTime`.

---

## 2. Files to edit

| File | Change |
|------|--------|
| `data/lib/ps/config/pokemon/<from>.lua` | add an entry to `evolutions = { … }` |
| `data/lib/ps/config/pokemon.lua:1-19` | only if you need a new evolution item constant in `ITEMS` |
| `data/lib/ps/config/pokemon/<to>.lua`, `pokemonsNumbers.lua`, `pokemonsNames.lua`, `monster/monsters.xml` | only if the target species is new ([add-pokemon.md](add-pokemon.md)) |
| `data/monster/Pokemons/<from>.xml` | optional: `<attack name="Evolve" interval="…"/>` for wild evolution |
| `data/items/items.xml` | only for a new evolution item ([add-item.md](add-item.md)) |

---

## 3. Files NOT to edit

`data/lib/ps/config/_pokemon/` (historical copy, never loaded), `others/pokemon_backup/`,
`original/`, and the generated `docs/reference/POKEMON.md`. Do not add `evolutionStone` to a
species: `getPokemonEvolutionNeededStones` (`config/pokemon.lua:1445-1450`) reads it, but no
file defines it and nothing calls the getter.

---

## 4. Authoritative source paths

* Branch fields: `lib/ps/events/actions/evolve.lua` (the only consumer of `requiredItems`,
  `requiredTime`, `random`, `extraPokemon`).
* Evolution result: `lib/ps/functions/pokemon.lua:175-215`.
* Pruning of impossible branches: `config/pokemon.lua:1062-1070` deletes any branch whose
  target is not a loaded species, e.g. a shiny without portraits.
* Prior-evolution map (used by families, egg moves, `getPokemonEvolveLevel`):
  `EVOLVE_FROM`, `config/pokemon.lua:1261-1268`.

---

## 5. Required IDs and how to find free ones

| Field | Value type | Real values |
|-------|------------|-------------|
| `name` | species name (exact case) | `"Flareon"` |
| `requiredLevel` | integer, **mandatory** (compared at `evolve.lua:35`) | `30` |
| `requiredItems` | list of **server** item ids, usually `ITEMS.*` | `{ ITEMS.FIRE_STONE }` = `{ 18083 }` |
| `requiredTime` | `WORLD_LIGHT_STATE_DAY` (0), `_NIGHT` (1), `_SUNSET` (2), `_SUNRISE` (3) (`others/constants.lua:1342-1345`) | Espeon `DAY`, Umbreon `NIGHT` |
| `random` | `true` | Wurmple → Silcoon/Cascoon |
| `extraPokemon` | `true` (this branch is the bonus, not the evolution) | Nincada → Shedinja |

Evolution items defined in `ITEMS` (`config/pokemon.lua:1-19`): FIRE_STONE 18083, LEAF_STONE
18086, MOON_STONE 18084, SUN_STONE 18085, THUNDERSTONE 18087, WATER_STONE 18088, UPGRADE 18089,
DRAGON_SCALE 18090, KINGS_ROCK 18091, METAL_COAT 18092, SOOTHE_BELL 18093, PUNCH_MACHINE 18094,
KICK_MACHINE 18095, SPIN_MACHINE 18096, DEEPSEATOOTH 28893, DEEPSEASCALE 28892, PRISM_SCALE
28914. `ITEMS` is cleared at `config/pokemon.lua:74-75`, so it exists only inside species files.

```bash
rg -n 'id="18083"' server/data/items/items.xml          # Fire Stone, items.xml:24355
rg -n '\b18083\b' server/data/actions/actions.xml       # nothing: stones need no action
rg -n 'ITEMS\.[A-Z_]+' -o --no-filename server/data/lib/ps/config/pokemon | sort | uniq -c
```

Evolution items are only **counted** in the inventory (`getPlayerItemCount`, `evolve.lua:28`)
and removed (`evolve.lua:1-5`, `:64-66`). They need an `items.xml`/`items.otb` entry but no
`actions.xml` registration.

---

## 6. Example code

```14:20:server/data/lib/ps/config/pokemon/eevee.lua
    evolutions = {
        { name = "Vaporeon", requiredLevel = 30, requiredItems = { ITEMS.WATER_STONE } },
        { name = "Jolteon", requiredLevel = 30, requiredItems = { ITEMS.THUNDERSTONE } },
        { name = "Flareon", requiredLevel = 30, requiredItems = { ITEMS.FIRE_STONE } },
        { name = "Espeon", requiredLevel = 30, requiredItems = { ITEMS.SOOTHE_BELL }, requiredTime = WORLD_LIGHT_STATE_DAY },
        { name = "Umbreon", requiredLevel = 30, requiredItems = { ITEMS.SOOTHE_BELL }, requiredTime = WORLD_LIGHT_STATE_NIGHT }
    },
```

```14:17:server/data/lib/ps/config/pokemon/wurmple.lua
    evolutions = {
        { name = "Silcoon", requiredLevel = 15, random = true },
        { name = "Cascoon", requiredLevel = 15, random = true },
    },
```

```14:17:server/data/lib/ps/config/pokemon/nincada.lua
    evolutions = {
        { name = "Ninjask", requiredLevel = 35 },
        { name = "Shedinja", requiredLevel = 35, extraPokemon = true },
    },
```

Adding a branch, e.g. a Sunset-only Leaf Stone branch on an existing species, uses the same
fields:

```lua
        { name = "<Target>", requiredLevel = 30, requiredItems = { ITEMS.LEAF_STONE }, requiredTime = WORLD_LIGHT_STATE_SUNSET },
```

Branch selection rules from `evolve.lua:21-61`:

* Branches are checked in list order with `ipairs`.
* If **two non-random branches** pass (for example the player carries a Water Stone and a
  Fire Stone), the evolution is refused with "You need to carry the items of only one
  evolution to evolve this Pokemon."
* All passing `random` branches are pooled and one is picked at random.
* An `extraPokemon` branch is never "the" evolution. It needs another passing branch, a free
  capacity ≥ 1 and an empty poke ball (12157) in the inventory (`evolve.lua:69-75`);
  otherwise it is skipped silently.

---

## 7. Related dependencies

* The target needs a species config **and** a monster (`getMonsterInfo(evolve.name, false)`
  at `evolve.lua:63`, and `getMonsterInfo(toPokemon, false).outfit.lookType` at
  `functions/pokemon.lua:190`).
* `Shiny <Name>` gets a copy of the branches with `"Shiny "` prepended (`config/pokemon.lua:50-52`).
  If `Shiny <Target>` does not exist, that branch is pruned (`:1062-1070`).
* Egg moves of the evolved form are overwritten from the lowest form (`config/pokemon.lua:1705-1716`),
  and the family strip in the Pokédex is rebuilt from `evolutions` (`:1611-1655`).
* The evolve icon (13204) must be in the player's inventory. The dev seed puts it in slot 2
  (BUG-10, `docs/PHASE_2_TEST_MATRIX.md` P2-03).

---

## 8. Registration steps

1. Add the branch to `evolutions` of the base species.
2. Make sure the target is in `config/pokemon/`, `pokemonsNumbers.lua`, `pokemonsNames.lua` and
   `monsters.xml`.
3. New evolution item: add it to `items.xml`/`items.otb` and, optionally, to `ITEMS` in
   `config/pokemon.lua:1-19`. A raw id in `requiredItems` also works.
4. Optional wild evolution: add `<attack name="Evolve" interval="2000" chance="…"/>` to the
   monster XML. Spell `Evolve` is at `spells.xml:4`. Write `interval`, not the `inverval` typo
   found in 631 files (BUG-47).

No `actions.xml` change: the evolve icon action (`actions.xml:34`) already handles every
species.

---

## 9. Client requirements

None for the evolution itself. The evolved form's `fastcallPortrait` (client id) must be in
`data.dat` and in `client/modules/gamelib/pokemon.lua`, as for any species. The evolve
animation uses the target's looktype (`doSendCreatureEffect(… CREATURE_EFFECTS.EVOLVE, lookType)`,
`functions/pokemon.lua:190`).

---

## 10. Database requirements

None. The ball's `pokemonName` attribute is rewritten (`setBallPokemonName`,
`functions/pokemon.lua:186`) and saved with the player.

---

## 11. Server requirements

Restart the server. The evolve action runs in the actions Lua state, but the species table is
loaded in every state (`docs/DEVELOPER_HANDBOOK.md` §10.3). `/reload actions` would update
only the actions copy.

---

## 12. Validation steps

```bash
tools/check_syntax.sh server/data/lib/ps/config/pokemon
python3 tools/check_references.py --all | rg 'pokemon\.evolution'
```

`check_references.py` reports `pokemon.evolution` when a target is not a `POKEMON[...]`
species (with a "case differs" hint), and `pokemon.evolution.item` when an `ITEMS.X` key is
undefined or the item id is not in `items.xml`/`items.otb`.

Startup: `>> Cristal server Online!`, and no `getPokemonEvolutions - Unknown poke name.` in
`server/logs/Error - <date>.log`.

---

## 13. Test steps

Verified flow (`docs/PHASE_2_TEST_MATRIX.md` P2-11), GM Admin:

1. `/mypokemon Eevee,30` gives "You received an Eevee.".
2. `/i 18083,1` (Fire Stone). It lands in the hidden slot-3 backpack, which is still counted
   (BUG-12).
3. Call Eevee (Pokémon bar icon), then use the evolve icon 13204 (right-click "Evolve" in the
   client).
4. Expect, in order: "Something is happening!" → (3 s) "Your Pokemon is evolving!" →
   (9.5 s) "Your Eevee has evolved into a Flareon!". The bar icon changes to Flareon's
   fastcall (10770) and the Fire Stone is gone.

Negative tests:

* Level too low: `/mypokemon Eevee,29` + Fire Stone → "Your Pokemon can't evolve right now."
* Two stones: carry 18083 and 18088 (Water Stone) → "You need to carry the items of only one
  evolution to evolve this Pokemon."
* Day/night: say `/time` ("The time now is HH:MM (day)." or `(night)`, `(sunset)`,
  `(sunrise)`). With Soothe Bell 18093, Eevee becomes Espeon only during `day` and Umbreon only
  during `night`. During `sunset`/`sunrise` neither branch passes.
* No evolution: a Flareon → "Your Pokemon can no longer evolve."
* Pokémon not called / in a battle or duel → the default "Sorry, not possible." cancel
  (`evolve.lua:8-11`).
* Extra Pokémon: `/mypokemon Nincada,35`, keep an empty poke ball 12157 → "Congratulations, you
  received an extra Pokemon: Shedinja!" plus the Ninjask evolution.

---

## 14. Common mistakes

* Missing `requiredLevel`: `getPlayerPokemonLevel(cid) < nil` raises a Lua error in the
  evolve action.
* Target name typo or wrong case. The branch is pruned at load (if no species has that name)
  or fails at `evolve.lua:63` (no monster).
* Two plain branches with the same items (or none). Players can never evolve, because both
  pass and trigger the "only one evolution" message. Use `random = true` for the Wurmple
  pattern.
* An `extraPokemon` branch as the only branch: it never evolves anything.
* Expecting `requiredItems` or `requiredTime` to gate wild evolution. `Evolve.lua` ignores them.
* Note: `evolve.lua:35` mixes `and`/`or` without full parentheses. BUG-46 suspects that a
  level check can bypass the day/night gate, but tracing the expression shows it can only set
  `canEvolve` to `false`, so the gate holds. Do not "fix" it in a content change.
* A latent hazard: pruning sets `evolutions[k] = nil` (`config/pokemon.lua:1066`), and
  `evolve.lua:21` iterates with `ipairs`. A pruned branch in the **middle** of the list hides
  every later branch. No current species is affected (checked for all shiny families), but
  keep branches whose target might not exist at the end of the list.

---

## 15. Failure symptoms

| Message / log | Cause |
|---------------|-------|
| "Your Pokemon can't evolve right now." | No branch passed (level, items, time), or the target monster does not exist (`evolve.lua:63,79`) |
| "Your Pokemon can no longer evolve." | `evolutions` is empty after pruning (`havePokemonEvolution`, `config/pokemon.lua:1567-1569`) |
| "You need to carry the items of only one evolution to evolve this Pokemon." | More than one non-random branch passed |
| `[Error - Action Interface] … evolve.lua:onUse … attempt to compare nil with number` | Branch without `requiredLevel` |
| Evolved, but the bar icon is wrong or empty | Target's `fastcallPortrait` or client `gamelib/pokemon.lua` entry is wrong |

---

## 16. Rollback advice

`git checkout -- server/data/lib/ps/config/pokemon/<from>.lua`, then restart. Pokémon that have
already evolved stay evolved (the ball name changed). To revert one, edit the ball with the
server stopped ([database-changes.md](database-changes.md)) or give the player a new ball with
`/mypokemon`.
