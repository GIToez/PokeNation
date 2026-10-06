# Edit an item

This tutorial changes an existing item's name, description, price, loot glow or behaviour.
The examples are **Fire Stone** (server id 18083, a plain item used by evolutions),
**Calcium** (23450, a vitamin) and the **pokemon health potion** family (12244-12247).

All paths are relative to `server/` unless they start with `docs/`, `tools/` or `client/`.

Related: [add-item.md](add-item.md) (how items are defined), [add-evolution.md](add-evolution.md),
[add-held-item.md](add-held-item.md) (held items and vitamins), [edit-catch-rate.md](edit-catch-rate.md)
(balls), [add-tm.md](add-tm.md).

---

## 1. Where each property lives

| Property | Where | Fire Stone | Calcium | Health potion |
|----------|-------|------------|---------|---------------|
| Name, article | `items.xml` `<item name= article=>` | `items.xml:24355` | `items.xml:25983` | `items.xml:18211` |
| Look description | `<attribute key="description">` | `items.xml:24356` | `items.xml:25984` | `items.xml:18212` |
| NPC sell price fallback | `<item sellprice=>` | 35000 | — | — |
| Loot glow | `<attribute key="rareEffect" value="1"/>` | yes | yes | no |
| Shop buy/sell price | the NPC XML `shop_buyable` / `shop_sellable` | `npc/Keir Jez.xml:10` (no price → `sellprice`) | — | `npc/Alison.xml:14` (10) |
| What it does | Lua | evolution entries `requiredItems = { ITEMS.FIRE_STONE }` (`config/pokemon/eevee.lua:17`; `ITEMS.FIRE_STONE = 18083` at `config/pokemon.lua:2`) | `VITAMINS[VITAMIN_IDS.CALCIUM]` (`systems/040-vitamin.lua:71-85`) | `HEALTH_POTIONS[12244]` (`events/actions/potions/healthPotions.lua:30`) |
| Sprite, stackable, weight | `items.otb` + client `data.dat` | client 16688 | client 22107 | client 11205 |

---

## 2. Files to edit

| Change | File |
|--------|------|
| Name / description / `sellprice` / `rareEffect` | `data/items/items.xml` |
| Shop prices | `data/npc/<Npc>.xml` (every NPC that lists the id; see section 5) |
| Loot chance | `data/monster/**/<species>.xml` `<loot>` lines |
| Potion power or duration | `data/lib/ps/events/actions/potions/healthPotions.lua` (constants at lines 1-3, conditions at 5-27, table at 29-34) |
| Vitamin bonus or limits | `data/lib/ps/systems/040-vitamin.lua` (`values`, optional `maxApplies`; global limits at lines 18-20) |
| Which stone an evolution needs | the species file (`requiredItems`), see [add-evolution.md](add-evolution.md) |
| Market name | `client/modules/gamelib/items.lua` `ITEM_NAME_BY_ID[<client id>]` (Fire Stone: line 754) |

The item description text repeats game numbers in prose (Calcium: "Adds extra (5%, 8%, 10%) special attack…").
Update the text when you change the numbers.

---

## 3. Files NOT to edit

* `data/lib/ps/tools/generateLoot.lua`: a generator with its own price list
  (`["Fire Stone"] = { id = 18083, price = 22500 }`, line 7626). Not loaded at runtime.
* `docs/reference/*`: generated.
* `data/lib/ps/events/actions/quests/legendaryChest.lua:16`: commented-out reward line.
* `original/`, historical trees (`docs/DEVELOPER_HANDBOOK.md` §2.2).
* `items.otb` for a name or description change; names are not taken from the OTB.

---

## 4. Authoritative source paths

* `items.xml` parsing: `src/items.cpp:515-1755`; `sellprice` at :542-544, `rareEffect` at :776-778.
* `sellprice` is used by NPC `shop_sellable` lines that have no price
  (`npc/lib/npcsystem/modules.lua:940-944`) and returned by the Lua function `getItemSellPrice`.
* `rareEffect` makes a corpse that contains the item show a coloured effect (`src/monster.cpp:1497`).
* The item **name** is also used:
  * by the Pokédex evolution text (`systems/010-pokedex.lua:241` `getItemNameById`);
  * by `/i <name>` (`talkactions/scripts/createitem.lua:13` `getItemIdByName`);
  * as the visible name in NPC shop lines. The shop shows the first field of the line, not the
    `items.xml` name.
* Vitamins: the **count** is stored on the ball (`getBallVitaminCalcium`), and the bonus is
  recomputed from `values[count]` every time the Pokémon is called (`Vitamin.onPokemonCall`,
  `040-vitamin.lua:222-229`, called from `functions/others.lua:745`). `values` is the total bonus
  at that count, not an increment: 1 Calcium = +5%, 2 = +8%, 3 = +10%.
* Potions: nothing is stored; the table is read on every use.

---

## 5. Required IDs

Edits keep the id. To find every place that uses an id:

```bash
ID=18083
rg -n "\b$ID\b" server/data --glob '!**/_pokemon/**' --glob '!**/pokemon_backup/**' --glob '!**/moves_disabled/**' | rg -v generateLoot
rg -n "ITEMS.FIRE_STONE" server/data/lib/ps/config/pokemon | wc -l     # evolutions that use it
rg -ln "\b$ID\b" server/data/npc/*.xml                                   # NPCs that trade it
```

Do **not** change a server id. Players own items by id in `player_items` / `player_depotitems`.

---

## 6. Related dependencies

* Fire Stone: evolution entries in species files; Ranger Club rewards
  (`config/001-rangerClub.lua:761`); loot of the Arcanine monster files; stone-buyer NPCs
  (Keir Jez, Alton Dane, Jaxon Amias, Indiana Graeme).
* Calcium: the action binding `actions.xml:74` (`itemid="23450-23457"` → `events/actions/vitamin.lua`),
  `VITAMIN_BY_ITEMID` (built from `itemId` at `040-vitamin.lua:151-154`), the Pokédex
  "Vitamins:" block and the trade window (`Vitamin.getBallDescription`).
* Potions: `iconItemId` (client id) for the status bar; the NPC shop lines.

---

## 7. Example code

Fire Stone today:

```24355:24358:server/data/items/items.xml
	<item id="18083" article="a" name="Fire Stone" sellprice="35000">
		<attribute key="description" value="A stone used for making certain kinds of pokemon evolve." />
		<attribute key="rareEffect" value="1" />
	</item>
```

Lower the NPC buy-back price: change `sellprice="35000"`. `npc/Keir Jez.xml:10` has
`Fire Stone, 18083;` without a price and therefore follows it. An NPC line with its own price
(`name, id, price;`) ignores `sellprice`.

Calcium today:

```71:85:server/data/lib/ps/systems/040-vitamin.lua
VITAMINS[VITAMIN_IDS.CALCIUM] = {
    name = "Calcium",
    itemId = 23450,
    values = {0.05, 0.08, 0.10},
    getApplyCountFunction = getBallVitaminCalcium,
    setApplyCountFunction = setBallVitaminCalcium,
    onApply = function(cid, count)
        setMonsterVarPokeStat(cid, MONSTER_POKE_STATS.SPECIALATTACK, VITAMINS[VITAMIN_IDS.CALCIUM].values[count] or
                VITAMINS[VITAMIN_IDS.CALCIUM].values[1])
    end,
    getDescription = function(count)
        return string.concat("+", (VITAMINS[VITAMIN_IDS.CALCIUM].values[count] or VITAMINS[VITAMIN_IDS.CALCIUM].values[1]) * 100,
            "% Special Attack")
    end
}
```

To allow 4 Calcium on one Pokémon, add `maxApplies = 4` (read at `040-vitamin.lua:202`) **and**
a fourth entry in `values`; otherwise the fourth use falls back to `values[1]` (+5%) and the
Pokémon gets weaker. The global limits are `MAX_TOTAL_APPLIES = 10`, `MAX_SINGLE_APPLIES = 3`
and `VITAMIN_SLOT_PER_LEVEL = 10` (level required = vitamins already used × 10) at lines 18-20.

Health potion power: `math.floor(3000 / HEALTH_TICKS)` per 5-second tick for 60 s
(`healthPotions.lua:1-7`, 12 ticks → 250 HP per tick). Change the number in both the condition
(line 7) and the table entry (line 30, the first tick when not replacing).

---

## 8. Registration steps

None. Every example is already bound (`actions.xml:74`, `:112`; evolutions by `ITEMS`).
If you change Calcium's `itemId`, it must stay inside the `actions.xml:74` range.

---

## 9. Database requirements

None. Existing vitamin counts on balls stay as they are. If you lower `maxApplies`, Pokémon that
already have more keep them; the extra count then reads `values[count]` (nil) and falls back to
`values[1]`.

---

## 10. Client requirements

> The client is a frozen reference (`docs/LEGACY_CLIENT_REFERENCE.md`). Change client files
> only when the feature needs it (new sprites, the data-table lines listed here), and say why
> in the commit message. See [add-client-asset.md](add-client-asset.md).

None for names, descriptions or numbers; the client shows what the server sends. Exceptions:
the market name table (`client/modules/gamelib/items.lua`) and sprite changes (`data.dat`,
[add-client-asset.md](add-client-asset.md)).

---

## 11. Server requirements

Restart. `/reload items` does nothing (console: `[Notice - Game::reloadInfo] Reload type does not work.`,
`src/game.cpp:6438-6441`). `/reload actions` reloads `healthPotions.lua`; `040-vitamin.lua`
is in `data/lib` and needs a restart. `/reload npcs` reloads NPC shop lines.

---

## 12. Validation steps

```bash
tools/check_syntax.sh server/data/items
tools/check_syntax.sh server/data/lib/ps/systems
tools/check_syntax.sh server/data/npc
python3 tools/check_references.py          # npc.shop.itemid, xml.itemid, pokemon.evolution.item
```

At startup: no `[Warning - Items::loadFromXml] Unknown key value …` (typo in an attribute key,
`items.cpp:1751`) and no `Duplicate registered item with id …`.

---

## 13. Test steps

1. GM: `/i 18083,1,true` (drops on your tile, avoiding the hidden backpack of BUG-12). Look at
   it: name and description must match.
2. Sell it to Keir Jez (`hi`, `trade`): the price must be the new `sellprice`.
3. Evolution still works (P2-11): `/mypokemon Eevee,30`, `/i 18083,1`, use the evolve icon
   with Eevee out: "Your Eevee has evolved into a Flareon!".
4. Calcium (P2-18): `/i 23450,1,true`, pick it up into your backpack (used from the floor it
   answers "You must pick up this item first."), then, with the Pokémon **inside** the ball, use
   it on the ball in the feet slot:
   "Your Pokemon received the Calcium vitamin! Now he have got 1 Calcium's (+5% Special Attack) and a total of 1 vitamin."
   With the Pokémon out: "You can not do it while you have a Pokemon out of the ball."
   After 3: "Your Pokemon has already received the maximum of 3 Calcium vitamins."
5. Potion: use it on your called Pokémon and watch the "HEAL +1" text and the regeneration.

---

## 14. Common mistakes

* Changing the number in the description but not in Lua, or the reverse.
* Expecting `sellprice` to change NPC prices that are written in the NPC line.
* Renaming an item and forgetting the NPC lines (they keep the old visible name) and the
  client market table.
* Adding `maxApplies` without extending `values`.
* Changing `itemId` in `VITAMINS` or `HEALTH_POTIONS` without changing `items.xml` and
  `actions.xml`.

---

## 15. Failure symptoms

| Symptom | Cause |
|---------|-------|
| Look text unchanged | Server not restarted |
| `[Warning - Items::loadFromXml] Unknown key value <key>` | Attribute key typo |
| `[Warning - Items::loadFromXml] Cannot load items file.` then `Unable to load items (XML)! Continue? (y/N)` (`src/items.cpp:380`, `src/otserv.cpp:697`) | `items.xml` is no longer well-formed; run `tools/check_syntax.sh server/data/items` |
| "Sorry, not possible." when using Calcium | Target is not a ball with a Pokémon, or `VITAMIN_BY_ITEMID` has no entry for the id |
| Evolution says nothing / does not happen | The stone id in `requiredItems` no longer matches the item the player holds |

---

## 16. Rollback advice

`git checkout -- server/data/items/items.xml` (and the Lua or NPC file you changed), then
restart. Vitamin counts written to balls while testing stay on those balls; they are only
counts, so a rollback of `values` changes their effect at the next call.
