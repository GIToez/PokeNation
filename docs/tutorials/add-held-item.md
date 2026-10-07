# Add a held item (and a vitamin)

This tutorial adds a held item: an item the player puts on a ball so the Pokémon's moves of one
element hit harder, levelling up with the Pokémon's experience. The model is **Black Belt**
(server id **23513**, +5% … +20% to Fighting moves). Section 17 covers the similar **vitamin**
system (model: **Calcium**, 23450).

All paths are relative to `server/` unless they start with `docs/`, `tools/` or `client/`.
`<NAME>` is the upper-case key, `<ID>` the new server item id.

Related: [add-item.md](add-item.md), [edit-item.md](edit-item.md), [add-move.md](add-move.md)
(`damageType` decides which held item applies).

---

## 1. How a held item works end to end

```
systems/046-heldItem.lua:9-28      HELD_IDS.BLACK_BELT = 0                    (number stored on the ball)
systems/046-heldItem.lua:38-51     HELDS[HELD_IDS.BLACK_BELT] = {name, itemId = 23513, values, onApply, getDescription}
actions.xml:78                     itemid="23513-23531" → events/actions/heldItem.lua → PokemonHeldItem.onUse
items.xml:26168                    <item id="23513" name="held black belt" sellprice="80000"> …
```

1. **Install.** The player uses the item on a ball with the Pokémon inside.
   `PokemonHeldItem.onUse` (`046-heldItem.lua:478-523`) finds the held with `HELD_BY_ITEMID`
   (built from `itemId`, lines 392-395), checks the conditions, stores held id, level 1 and
   experience 0 **on the ball** (`setBallHeld`, `setBallHeldLevel`, `setBallHeldExperience`),
   says "Your Pokemon received the Black Belt held item!" and removes the item.
2. **Call.** `PokemonHeldItem.onPokemonCall` (`:541-553`, called from `functions/others.lua:746`)
   runs `onApply(pokemon, level, ballUid)`. Black Belt stores `values[level]` and
   `ELEMENT_FIGHT` in creature storages (`setPokemonHeldMovePowerModifier`,
   `setPokemonHeldMovePowerType`, `functions/pokemon.lua:334-352`).
3. **Damage.** `getMovePowerModifier` (`:525-539`) returns `1 + values[level] / 100` when the
   move's `damageType` equals the stored type; it is applied at `systems/004-skillDamage.lua:272`.
4. **Levelling.** `onGainExperience` (`:424-476`, called from `functions/player.lua:431`) adds the
   Pokémon's experience to the held item. The thresholds are `EXP_TABLE` (lines 32-35: the
   experience for Pokémon level 20, 30, 40, 50, 55, 60, 65), up to `MAX_LEVEL = 7` (line 30).
   On level-up: "Congratulations! Your <Pokémon> held item advanced from level N to level N+1."

---

## 2. Files to edit

| # | File | Change |
|---|------|--------|
| 1 | `data/lib/ps/systems/046-heldItem.lua` | `HELD_IDS.<NAME> = 20` (after line 28) and `HELDS[HELD_IDS.<NAME>] = { … }` (before line 392) |
| 2 | `items.otb` + client `data.dat`/`data.spr` | a new item id ([add-item.md](add-item.md)) |
| 3 | `data/items/items.xml` | `<item id="<ID>" article="a" name="held <name>" sellprice="…">` + description |
| 4 | `data/actions/actions.xml` | bind `<ID>` to `heldItem.lua` (line 78 is the range `23513-23531`; add `;<ID>` or a new line) |
| 5 | NPC / loot / quest files | to make it obtainable |

---

## 3. Files NOT to edit

* `HELD_IDS` numbers that already exist: balls store the number (`getBallHeld`).
* The Elemental Stone range hack (`046-heldItem.lua:397-401`, ids 24724-25047). It maps a
  block of item ids to `HELD_IDS.ELEMENTAL_STONE`; do not put a new held id inside it.
* `npc/scripts/testserver_held.lua`: a test-server NPC.
* `docs/reference/*`, `original/`.

---

## 4. Authoritative source paths

`HELDS` entry fields:

| Field | Required | Read by |
|-------|----------|---------|
| `name` | yes | install message, `getHeldName` (ball description, `config/balls.lua:2046`) |
| `itemId` | yes | `HELD_BY_ITEMID` (:392-395), `getHeldItemId` (`held_remove` NPC gives it back) |
| `values` | by convention, 7 entries (one per level) | `onApply`, `getDescription` |
| `onApply(cid, level, ballUid)` | yes | `onPokemonCall`, level-up |
| `getDescription(uid)` | yes | Pokédex "Held:" block (`systems/010-pokedex.lua:458`), trade window (`onTradeRequestAccept.lua:45`) |
| `getName(ballUid)`, `canInstall(ballUid, heldUid)`, `onInstall(ballUid, heldUid)` | optional | Elemental Stone only (`:324-390`) |

Other readers:

* `/held` (`talkactions.xml:14` → `events/talkactions/heldExperience.lua` →
  `doSendPlayerExpMessage`, `:589-606`).
* `held_remove` NPC (`npc/scripts/held_remove.lua`) → `doResetBall` (`:570-587`).
* Knock Off / Thief / Covet check `getPokemonHeldMovePowerType` on the target
  (`events/spells/scripts/Knock Off.lua:8`).

---

## 5. Required IDs and how to find free ones

| ID | Black Belt | Rule |
|----|------------|------|
| `HELD_IDS.<NAME>` | 0 | Next number: `ELEMENTAL_STONE = 19` is the highest, so **20** |
| item id | 23513 | New server id. `23513-23531` is full (19 helds); 25048 is the Elemental Stone; 24724-25047 are reserved by the hack |
| element | `ELEMENT_FIGHT` | An `ELEMENT_*` constant (`others/constants.lua:76-94`) |

```bash
rg -n "^HELD_IDS\.\w+ = " server/data/lib/ps/systems/046-heldItem.lua | tail -1
rg -n "itemId = " server/data/lib/ps/systems/046-heldItem.lua | awk '{print $NF}' | sort | uniq -d
rg -n "setPokemonHeldMovePowerType\(cid, ELEMENT_\w+" -o server/data/lib/ps/systems/046-heldItem.lua   # element of each held
```

The last command shows Dragon Fang with `ELEMENT_FIRE` (`046-heldItem.lua:89`), which looks like a
copy-paste error (Charcoal is the Fire held item).

---

## 6. Related dependencies

* Moves: the bonus applies to moves whose `damageType` equals the held element
  ([add-move.md](add-move.md)).
* Pokémon experience: `doPlayerPokemonAddExperience` (`functions/player.lua:420-480`) feeds the
  held item.
* Ball description is rebuilt by `doBallUpdateDescription`.

---

## 7. Example code

```38:51:server/data/lib/ps/systems/046-heldItem.lua
HELDS[HELD_IDS.BLACK_BELT] = {
    name = "Black Belt",
    itemId = 23513,
    values = {5, 7, 10, 13, 15, 18, 20},
    onApply = function(cid, level, ballUid)
        setPokemonHeldMovePowerModifier(cid, HELDS[HELD_IDS.BLACK_BELT].values[level])
        setPokemonHeldMovePowerType(cid, ELEMENT_FIGHT)
    end,
    getDescription = function(uid)
        local level = getBallHeldLevel(uid)
        return string.concat("Level ", level, " ", HELDS[HELD_IDS.BLACK_BELT].name, " +",
            HELDS[HELD_IDS.BLACK_BELT].values[level], "%")
    end
}
```

```26168:26171:server/data/items/items.xml
	<item id="23513" article="a" name="held black belt" sellprice="80000">
		<attribute key="description" value="Boosts the power of Fighting-type moves when held." />
		<attribute key="rareEffect" value="1" />
	</item>
```

New held item (template; copy the Black Belt shape and change the key, name, id and element):

```lua
HELD_IDS.<NAME> = 20

HELDS[HELD_IDS.<NAME>] = {
    name = "<Name>",
    itemId = <ID>,
    values = {5, 7, 10, 13, 15, 18, 20},
    onApply = function(cid, level, ballUid)
        setPokemonHeldMovePowerModifier(cid, HELDS[HELD_IDS.<NAME>].values[level])
        setPokemonHeldMovePowerType(cid, ELEMENT_<TYPE>)
    end,
    getDescription = function(uid)
        local level = getBallHeldLevel(uid)
        return string.concat("Level ", level, " ", HELDS[HELD_IDS.<NAME>].name, " +",
            HELDS[HELD_IDS.<NAME>].values[level], "%")
    end
}
```

```xml
<action itemid="<ID>" event="script" value="../../lib/ps/events/actions/heldItem.lua" allowfaruse="1" />
```

---

## 8. Registration steps

1. Item (OTB, sprite, `items.xml`).
2. `HELD_IDS.<NAME>` and the `HELDS` entry. `HELD_BY_ITEMID` is built automatically.
3. `actions.xml` binding.
4. Make it obtainable (NPC, loot, quest).
5. Restart.

---

## 9. Database requirements

None. Held id, level and experience are ball attributes.

---

## 10. Client requirements

> The client is a frozen reference (`docs/LEGACY_CLIENT_REFERENCE.md`). Change client files
> only when the feature needs it (new sprites, the data-table lines listed here), and say why
> in the commit message. See [add-client-asset.md](add-client-asset.md).

The item sprite. There is no client held-item table. Add a market name line in
`client/modules/gamelib/items.lua` if needed.

---

## 11. Server requirements

Restart (`046-heldItem.lua` is in `data/lib`).

---

## 12. Validation steps

```bash
tools/check_syntax.sh server/data/lib/ps/systems
tools/check_syntax.sh server/data/actions
python3 tools/check_references.py          # xml.itemid for the new actions.xml id
```

No startup message is specific to held items. A wrong field name in `HELDS` shows up at use or
call time, in `server/logs/Error - <date>.log` or as an `[Error - Action Interface]` /
`[Error - TalkAction Interface]` block on the console.

---

## 13. Test steps

Strings from P2-17. Use GM or Trainer.

1. `/mypokemon Machop,20` (any Pokémon), keep it **inside** the ball in the feet slot.
2. `/i <ID>,1,true`, pick the item up into the backpack (from the floor it answers "You must
   pick up this item first."), and use it on the ball.
   Expect "Your Pokemon received the <Name> held item!".
3. `/held`: "Your Pokemon Held item is at level 1 and has 0 experience points, he needs more 98800(100%) experience points to advance to level 2."
4. Again on the same ball: "Your Pokemon already have got a Held Item."
5. With the Pokémon out: "You can not do it while you have a Pokemon out of the ball."
6. Damage (as Tester, BUG-05): compare the damage line of a move of that element before and
   after installing ("Your <Pokémon> deals N damage to a Rattata.").
7. Remove it at the held remover NPC (`npc/scripts/held_remove.lua`): say `hi`, `remove`, `yes`.

---

## 14. Common mistakes

* Copying an entry and forgetting to rename `HELDS[HELD_IDS.BLACK_BELT]` inside `onApply` /
  `getDescription`: the new item silently uses Black Belt's values.
* Fewer than 7 `values`: `values[level]` becomes nil at higher levels, and `onApply` /
  `getDescription` then work with nil (no bonus, broken description or a Lua error).
* Wrong element constant (as Dragon Fang today).
* An item id inside 24724-25047: it is treated as an Elemental Stone.

---

## 15. Failure symptoms

| Symptom | Cause |
|---------|-------|
| "Sorry, not possible." on use | Id not in `HELD_BY_ITEMID`, or the target is not a ball with a Pokémon |
| "You cannot use this object." | Id not in `actions.xml` |
| Error log `PokemonHeldItem.onPokemonCall - Unknown heldId` | A ball stores a held id whose `HELDS` entry was removed |
| No damage bonus | Element in `onApply` differs from the move's `damageType`, or the Pokémon was not re-called after install |
| `attempt to compare nil with number` in `046-heldItem.lua` `onGainExperience` | BUG-28: the level-up loop reads `EXP_TABLE[8]` (nil) when one experience gain jumps past the level-7 threshold while the item is below level 7 (`:446-449`) |

---

## 16. Rollback advice

`git checkout -- server/data/lib/ps/systems/046-heldItem.lua server/data/actions/actions.xml server/data/items/items.xml`
and restart. Balls that already got the new held item keep its id; after rollback they log
`Unknown heldId` on every call and show "None." in the Pokédex. Remove the held item from those
balls with the held remover NPC first, or keep the `HELDS` entry.

---

## 17. Vitamins (Calcium)

Vitamins are the same pattern with a count instead of a level
(`systems/040-vitamin.lua`):

| Part | Calcium |
|------|---------|
| Key | `VITAMIN_IDS.CALCIUM = 3` (lines 8-15; next free 8) |
| Entry | `VITAMINS[VITAMIN_IDS.CALCIUM]` (lines 71-85): `name`, `itemId = 23450`, `values = {0.05, 0.08, 0.10}`, `getApplyCountFunction = getBallVitaminCalcium`, `setApplyCountFunction = setBallVitaminCalcium`, `onApply`, `getDescription`, optional `maxApplies` |
| Action | `actions.xml:74` `itemid="23450-23457"` → `events/actions/vitamin.lua` |
| Item | `items.xml:25983` "calcium vitamin" |
| Limits | `MAX_TOTAL_APPLIES = 10`, `MAX_SINGLE_APPLIES = 3`, `VITAMIN_SLOT_PER_LEVEL = 10` (lines 18-20) |

A new vitamin also needs a **new ball attribute** for its count: a new `ballsAttributes` key
(Calcium: `vitaminCalcium = base + 48`, `config/balls.lua:49`; the table is lines 1-74) and a
`getBallVitamin<Name>` / `setBallVitamin<Name>` pair like `getBallVitaminCalcium`
(`config/balls.lua:2403-2414`). Pick a key that is not used by
`ballsAttributes`, `ITEM_ATTRIBUTES` or any move `cooldownStorage` ([add-move.md](add-move.md) §5).

Test (P2-18): use it on the ball: "Your Pokemon received the Calcium vitamin! Now he have got 1 Calcium's (+5% Special Attack) and a total of 1 vitamin."
Limits: "Your Pokemon has already received the maximum of 3 Calcium vitamins.",
"Your Pokemon need at least level 10 to receive another vitamin.",
"Your Pokemon has already received the maximum of 10 total vitamins."

---

## 18. Dependency checklist

- [ ] `HELD_IDS.<NAME>` = next number (20), existing numbers untouched
- [ ] `HELDS[HELD_IDS.<NAME>]` with `name`, `itemId`, 7 `values`, `onApply` (correct `ELEMENT_*`), `getDescription`, all referring to `HELD_IDS.<NAME>`
- [ ] Item id outside 23513-23531 and 24724-25048, in `items.otb` with a sprite
- [ ] `items.xml` entry ("held <name>", description, `sellprice`)
- [ ] `actions.xml` → `heldItem.lua`
- [ ] Obtainable (NPC / loot / quest)
- [ ] `tools/check_syntax.sh` clean; `check_references.py` no new REAL ERROR
- [ ] Test: install message, `/held`, duplicate refusal, damage bonus as Tester, removal NPC
