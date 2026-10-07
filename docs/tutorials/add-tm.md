# Add a Technical Machine (TM)

This tutorial adds a TM item that teaches an existing move to a Pokémon in its ball. The model
is **TM 06 "Toxic"**, server item id **17342**.

All paths are relative to `server/` unless they start with `docs/`, `tools/` or `client/`.
`<MOVE>` is the move name (a `MOVES[...]` key), `<NAME>` the upper-case `TM_IDS` key.

Related: [add-move.md](add-move.md) (the move must exist first), [add-item.md](add-item.md)
(new item ids), [edit-pokemon.md](edit-pokemon.md) (`learnableTms`).

---

## 1. How a TM works end to end

```
others/constants.lua:451-549              TM_IDS.TOXIC = 6                         (number stored on balls)
systems/018-technicalMachine.lua:38-43    TMS[TM_IDS.TOXIC] = {move = "Toxic", group = …, itemid = 17342, requiredLevel = 20}
items.xml:22487                           <item id="17342" name="TM 06" sellprice="30000"> …
actions.xml:52                            itemid="17337-17384;18912-18931;24716-24723;29157-29172" → events/actions/tm.lua
config/pokemon/eevee.lua:28               learnableTms = { …, TM_IDS.TOXIC, … }
```

1. The player uses the TM on the ball that holds the Pokémon. `events/actions/tm.lua` calls
   `onCreatureUseTm` (`018-technicalMachine.lua:648-684`). It finds the TM with `TM_BY_ITEMID`
   (built from `itemid`, lines 586-589) and checks `canLearn` (lines 619-646).
2. It sends the TM window (`doPlayerSendTmWindow`, `0xFF 0x0D`) with the **client icon id** of
   the new move and of every current move except Tackle, and says "Select the move that will be
   replaced by Toxic. (Shift + Click on move icon to details)".
3. The client answers `/tc <clientIconId>` (`talkactions.xml:21` →
   `events/talkactions/client/tmChoose.lua`) → `onTmChoose` (lines 714-814). That function checks
   the replaced move and the TM group rules, stores the TM **id** and slot on the ball
   (`setBallTm`, `config/balls.lua:1926`), says the "Poof!" line and removes the TM item.
4. From then on `getPokemonSkills` (`config/pokemon.lua:1377-1384`) puts `getTmMove(tm)` in that
   slot, so the move name is read **live** from `TMS`.

---

## 2. Files to edit

| # | File | Change |
|---|------|--------|
| 1 | `data/lib/ps/others/constants.lua` | `TM_IDS.<NAME> = <next number>` at the end of `TM_IDS` (lines 451-549) |
| 2 | `data/lib/ps/systems/018-technicalMachine.lua` | `[TM_IDS.<NAME>] = { … }` inside `TMS` (lines 7-583) |
| 3 | `items.otb` + client `data.dat`/`data.spr` | a new item id for the TM ([add-item.md](add-item.md)) |
| 4 | `data/items/items.xml` | `<item id="<ID>" article="a" name="TM <nn>" sellprice="…">` with a description |
| 5 | `data/actions/actions.xml:52` | add `;<ID>` to the TM `itemid` list |
| 6 | `data/lib/ps/config/pokemon/<species>.lua` | add `TM_IDS.<NAME>` to `learnableTms` of each species that may learn it (not needed with `allLearn = true`) |
| 7 | NPC / quest / loot files | wherever the TM should be obtainable |

---

## 3. Files NOT to edit

* The commented TMs in `TMS` (e.g. Whirlwind, `018-technicalMachine.lua:26-31`, and Pay Day,
  lines 98-103) and the commented `--[[ WHIRLWIND = 4, ]]` in `TM_IDS`. Their item 17340
  ("TM 04") still exists and is bound in `actions.xml`, but using it only logs
  `onCreatureUseTm - Unknown item.itemid`.
* `docs/reference/*`, `original/`, historical trees.
* **Existing `TM_IDS` numbers.** Balls store the number (`getBallTm`/`getBallTmSlot`); renumbering
  silently changes the move of every Pokémon that learned a TM.

---

## 4. Authoritative source paths

`TMS` entry fields (all read in `018-technicalMachine.lua`):

| Field | Required | Read at | Meaning |
|-------|----------|---------|---------|
| `move` | yes | `getTmMove` (:591), window, "Poof!" message, `getPokemonSkills` | A `MOVES[...]` key; its `clientIconId` is sent in the window |
| `itemid` | yes | `TM_BY_ITEMID` (:586-589), `getTmItemId` | Server id of the TM item |
| `requiredLevel` | yes | `canLearn` (:638-639) | "Your Pokemon level isn't enough to learn this Move, its required at least level 20." |
| `group` | yes | `onTmChoose` (:753-780), `canTmReplaceMove` (:692) | `TM_GROUP_IDS.OFFENSIVE` 0, `SUPPORT` 1, `HEAL` 2 (lines 1-5). Two TMs of the same group cannot be on one ball; a `HEAL` TM is refused if the Pokémon already has a heal move |
| `unique` | optional | `getTmUnique`, `onTmChoose` (:799-805), `checkTm` (:817+) | Learning it makes the ball **unique** (bound to the player) |
| `allLearn` | optional | `getTmAllLearn` → `getPokemonTmLearnable` (`config/pokemon.lua:1596-1601`) | Every species can learn it |

Species side: `learnableTms` is a list of `TM_IDS` values, or a boolean (`true` = all TMs,
`false` = none), `config/pokemon.lua:1596-1601`.

A ball can hold **two** TMs (slots 1 and 2).

---

## 5. Required IDs and how to find free ones

| ID | Toxic | Rule |
|----|-------|------|
| `TM_IDS.<NAME>` | 6 | Next number after the highest (today `OVERHEAT = 94`, so **95**). The gaps 4, 16, 28 and 30 are unused, but do not fill gaps: an old ball may still carry such a number |
| TM item id | 17342 | A new server id. Every id inside the `actions.xml:52` ranges is already a TM, except 17340 (disabled Whirlwind) and 17384 ("shallow water", `items.xml:22655`, wrongly inside the range) |
| `TM <nn>` item name | "TM 06" | Display text only; it does not have to equal the `TM_IDS` number (e.g. "TM 16" Submission is `TM_IDS.SUBMISSION = 17`) |

```bash
# highest TM_IDS value
sed -n '/^TM_IDS = {/,/^}/p' server/data/lib/ps/others/constants.lua | rg -o '= \d+' | awk '{print $2}' | sort -n | tail -1
# is the move already taught by a TM?
rg -n 'move = "Toxic"' server/data/lib/ps/systems/018-technicalMachine.lua
# TM item ids in use
rg -o 'itemid = \d+' server/data/lib/ps/systems/018-technicalMachine.lua | sort | uniq -d     # duplicates; prints 17352 today only because the commented Pay Day entry reuses it
```

---

## 6. Related dependencies

* The move must exist with a valid `clientIconId` (Toxic: 15743), otherwise the window shows a
  wrong icon and `/tc` cannot find it.
* `tm_remover` NPC (`npc/scripts/tm_remover.lua`) removes or swaps TMs on balls.
* The client TM window (`client/modules/game_tmchoose`) only shows move icons; it has no TM list.
* `docs/reference/*` lists TMs; regenerate with `tools/gen_reference.py` after the change.

---

## 7. Example code

```38:43:server/data/lib/ps/systems/018-technicalMachine.lua
    [TM_IDS.TOXIC] = {
        move = "Toxic",
        group = TM_GROUP_IDS.OFFENSIVE,
        itemid = 17342,
        requiredLevel = 20
    },
```

```22487:22490:server/data/items/items.xml
	<item id="17342" article="a" name="TM 06" sellprice="30000">
		<attribute key="description" value="This Technical Machine can teach the move Toxic. Category: Offensive. Required Level: 20." />
		<attribute key="rareEffect" value="1" />
	</item>
```

New TM (template):

```lua
-- others/constants.lua, last entry of TM_IDS (add a comma after OVERHEAT = 94)
    <NAME> = 95
-- systems/018-technicalMachine.lua, inside TMS
    [TM_IDS.<NAME>] = {
        move = "<MOVE>",
        group = TM_GROUP_IDS.SUPPORT,
        itemid = <ID>,
        requiredLevel = 40
    },
-- config/pokemon/<species>.lua
    learnableTms = { …, TM_IDS.<NAME> },
```

```xml
<item id="<ID>" article="a" name="TM 95" sellprice="50000">
    <attribute key="description" value="This Technical Machine can teach the move <MOVE>. Category: Support. Required Level: 40." />
    <attribute key="rareEffect" value="1" />
</item>
```

---

## 8. Registration steps

1. Confirm the move works ([add-move.md](add-move.md)).
2. Add `TM_IDS.<NAME>` and the `TMS` entry.
3. Add the item (OTB, sprite, `items.xml`) and append `;<ID>` to `actions.xml:52`.
4. Add `TM_IDS.<NAME>` to the `learnableTms` of each species.
5. Restart.

---

## 9. Database requirements

None. Learned TMs are ball item attributes (`player_items.attributes`).

---

## 10. Client requirements

> The client is a frozen reference (`docs/LEGACY_CLIENT_REFERENCE.md`). Change client files
> only when the feature needs it (new sprites, the data-table lines listed here), and say why
> in the commit message. See [add-client-asset.md](add-client-asset.md).

* The TM item sprite (new `data.dat` object, or reuse an existing TM sprite through the OTB).
* The move's icon (`clientIconId`) must exist; the window and move bar use it.
* Market name line in `client/modules/gamelib/items.lua` if needed.

---

## 11. Server requirements

Restart. `TM_IDS` and `TMS` are in `data/lib`; `/reload actions` would only reload `tm.lua`.

---

## 12. Validation steps

```bash
tools/check_syntax.sh server/data/lib/ps/systems
tools/check_syntax.sh server/data/lib/ps/others
python3 tools/check_references.py     # tm.itemid, tm.move, lua.tm (TM_IDS.* used in learnableTms), pokemon.tm
```

`check_references.py` reports a `TM_IDS.<NAME>` used in a species but missing in `TM_IDS`, a
`TMS` move that is not in `MOVES`, and a TM item id that is not in `items.xml`.

Startup: a `TMS` entry with an undefined `TM_IDS.<NAME>` key raises
`[Error - LuaScriptInterface::loadFile] … 018-technicalMachine.lua:<line>: table index is nil`
and the PSoul library stops loading.

---

## 13. Test steps

GM Admin can teach TMs (only using moves needs Tester, BUG-05). Strings from P2-16:

1. `/mypokemon Eevee,30`, keep the Pokémon **inside** the ball (feet slot).
2. `/i 17342,1` (lands in the hidden slot-3 backpack, BUG-12; with the client, use
   `/i 17342,1,true` and pick it up).
3. Use the TM on the ball. Expect "Select the move that will be replaced by Toxic. (Shift + Click on move icon to details)"
   and the window.
4. Click Quick Attack (sends `/tc <its clientIconId>`). Expect
   "1, 2, and ... ... ... Poof! Eevee forgot Quick Attack. And... Machine Set! Eevee learned Toxic!".
   The TM disappears and the move bar shows Toxic (icon 15743).
5. Negative checks:
   * Pokémon out: "You can not do it while you have a Pokemon out of the ball."
   * Level too low (`/mypokemon Eevee,10`): "Your Pokemon level isn't enough to learn this Move, its required at least level 20."
   * Species without the TM: "Your Pokemon can't learn this Technical Machine."
   * Clicking Tackle: "You can't replace the move Tackle."
   * A second TM of the same group: "You can't teach two moves that remains to the same Techinical Machine group."

---

## 14. Common mistakes

* Reusing or renumbering a `TM_IDS` value (section 3).
* Forgetting `actions.xml:52`: "You cannot use this object." when using the TM.
* Forgetting `learnableTms`: "Your Pokemon can't learn this Technical Machine." for everyone.
* Putting the move name (`"Toxic"`) into `learnableTms` instead of `TM_IDS.TOXIC`.
* Writing a `group` or `requiredLevel` in the description that differs from `TMS`.
* Expecting `requiredLevel` of the **move** file to matter; only the `TMS` value is checked.

---

## 15. Failure symptoms

| Symptom | Cause |
|---------|-------|
| "Sorry, not possible." on use, Error log `onCreatureUseTm - Unknown item.itemid` | No `TMS` entry with that `itemid` |
| `[Error - Action Interface]` + `…/tm.lua:onUse` + `(luaGetItemAttribute) Item not found` | Seen in P2-16 on the "Pokémon out" path: `tm.lua:2-4` sends a cancel but has no `return` (BUG-21). Harmless |
| Window opens, clicking a move does nothing, Error log `onTmChoose - nil slot, replacingMove can't be found on currentMoves` | The clicked icon id is not a move of this Pokémon (wrong `clientIconId`, or two moves share an icon) |
| `attempt to index field '?' (a nil value)` in `getTmMove` after a rollback | A ball still stores a `TM_IDS` value whose `TMS` entry was removed |
| `table index is nil` at startup | `TM_IDS.<NAME>` not defined in `constants.lua` |

---

## 16. Rollback advice

`git checkout -- server/data/lib/ps/others/constants.lua server/data/lib/ps/systems/018-technicalMachine.lua server/data/actions/actions.xml server/data/items/items.xml`
and the species files, then restart. **If any ball already learned the TM**, removing its `TMS`
entry breaks those balls (`getTmMove` on a missing entry). Either keep the entry, or remove the
TM from those balls first with the TM remover NPC.
