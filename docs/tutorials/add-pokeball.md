# Add a Poké Ball type

This tutorial adds a new ball type: a catching ball (with an "empty" item that players throw at
corpses) or a cosmetic ball (charged/discharged/in-use only). The model is the **poke ball**
family: empty 12157, in use 12158, charged 12159, discharged 12160.

All paths are relative to `server/` unless they start with `docs/`, `tools/` or `client/`.
`<ball>` is the lower-case key used in Lua and in the database (e.g. `poke`, `great`,
`white easter`).

Related: [edit-catch-rate.md](edit-catch-rate.md) (the catch formula), [add-item.md](add-item.md)
(new item ids), [database-changes.md](database-changes.md), `docs/DEVELOPER_HANDBOOK.md` §8.2
(the Pokémon lives in the ball's item attributes).

---

## 1. How a ball works end to end

A ball type is **four item ids** joined by one entry in `balls`:

| State | Poke ball | items.xml | Bound to | What happens |
|-------|-----------|-----------|----------|--------------|
| `empty` | 12157 | `:17996` "empty poke ball", description "The catch rate of this ball is 1x." | `actions.xml:90` → `events/actions/balls/empty.lua` → `emptyBall` (`functions/ball/empty.lua:163-243`) | used on a corpse: the catch roll |
| `charged` | 12159 | `:18002` "poke ball", `slotType` feet | `actions.xml:91` → `charged.lua` → `onUseChargedBall`; `movements.xml:5-6` Equip/DeEquip feet → `events/movements/ball.lua` | holds a healthy Pokémon; using it calls the Pokémon |
| `inUse` | 12158 | `:17999` (named "discharged poke ball", see section 14) | `actions.xml:93` → `inUse.lua` → `inUseBall` | the Pokémon is out; using it calls it back |
| `discharged` | 12160 | `:18006` "discharged poke ball" | `actions.xml:92` → `discharged.lua` → `dischargedBall` | the Pokémon fainted: "This ball is discharged." |

Flow:

1. **Catch.** `emptyBall` finds the ball key with `ballsNames[item.itemid]`, checks the corpse,
   `allowedElements` and the species' `allowedBall`, counts the throw in `ball_counter`
   (`doPlayerIncreaseWastedBalls`, line 198), says "Poke ball, go!" (line 223), and rolls
   `getCatchChance(...) <= getBallCatchRate(<ball>)` (line 225). On success it shows
   `effects.catch` and after 5.5 s creates `balls[<ball>].charged` with the Pokémon in it
   (`doCreatePokemonBall`, `config/balls.lua:2088`). On failure it shows `effects.catchMiss`
   and after 4 s says "Ouch! Your poke ball broke." (`empty.lua:85`).
2. **Call.** `functions/others.lua:869-874` shoots `projectile`, transforms the ball into `inUse`
   and shows `effects.use`.
3. **Faint.** `events/creaturescripts/onPokemonDeath.lua:29-35` transforms it into `discharged`.
4. **Heal.** `doBallHeal` (`config/balls.lua:2053-2067`) transforms it back into `charged`.

`ballsNames` (`config/balls.lua:1632-1650`) is built automatically from the four ids of every
entry; `isBall(itemid)` (`:2070`) is `ballsNames[itemid] ~= nil`.

---

## 2. Files to edit

| # | File | Change |
|---|------|--------|
| 1 | `data/items/items.otb` + `client/data/things/data.dat`/`data.spr` | four new server ids with sprites ([add-item.md](add-item.md), [add-client-asset.md](add-client-asset.md)) |
| 2 | `data/items/items.xml` | four `<item>` entries; the charged id needs `<attribute key="slotType" value="feet" />` |
| 3 | `data/lib/ps/config/balls.lua` | `balls["<ball>"] = { … }` (inside the table at lines 166-1624) |
| 4 | `data/lib/ps/config/balls.lua` | `CATCH_RATE["<ball>"]` (lines 1664-1688), for catching balls |
| 5 | `data/actions/actions.xml` | add each id to the right line: empty → line 90, charged → 91, discharged → 92, inUse → 93 |
| 6 | `data/movements/movements.xml` | add charged, discharged and inUse ids to **both** lines 5 and 6 |
| 7 | database | `useCounter = true` only: a new column in `ball_counter` (section 9) |
| 8 | `src/schemas/psoul_extra_mysql.sql` | the same column in `CREATE TABLE ball_counter` (lines 105-128) for new installs |
| 9 | `data/npc/<Npc>.xml` | `shop_buyable` line for the empty ball, if it is sold |
| 10 | species files | optional `POKEMON["<Species>"].allowedBall = "<ball>"` (e.g. `config/pokemon/bulbasaur.lua:33`) |

---

## 3. Files NOT to edit

* The commented `ballsNames = { … }` block at `config/balls.lua:81-164` and the commented
  `balls = { … }` list at `:1652-1662`. Both are dead; the live `ballsNames` is computed.
* `data/lib/ps/tools/catchTest.lua`: a test tool, not registered.
* `docs/reference/*`, `original/`, historical trees.

---

## 4. Authoritative source paths

Fields of a `balls` entry (`config/balls.lua:167-175` for poke):

| Field | Required | Read by |
|-------|----------|---------|
| `charged` | yes | catch result (`empty.lua:227`), heal (`balls.lua:2065`), `doCreatePokemonBall` when given a ball name (`:2093`), `inUse.lua` |
| `inUse` | yes | call (`others.lua:873`) |
| `discharged` | yes | faint (`onPokemonDeath.lua:29`), `inUse.lua`, revive (`events/actions/potions/pokemonRevive.lua`), NPC battles (`systems/001-npcBattle.lua`) |
| `empty` | catching balls only | `ballsNames`, `isBallWithPokemonByBallId` (`balls.lua:2079-2085`) |
| `projectile` | yes | call, call back, faint, throw (`PROJECTILE_*`, `others/constants.lua:2039-2132`; poke = `PROJECTILE_POKEBALL` 21, line 2060) |
| `effects.use` | yes | call and faint (`EFFECT_POKEBALL_USE` 68, `constants.lua:1443`) |
| `effects.catch`, `effects.catchMiss` | catching balls | `empty.lua:226,233` (`EFFECT_POKEBALL_CATCH_OK` 66, `_CATCH_FAIL` 67) |
| `useCounter` | optional | `systems/020-ballCounter.lua:3-7`: the ball gets its own `ball_counter` column and counts towards the catch bonus |
| `allowedElements` | optional | `empty.lua:188-191`: "You cannot catch this type of Pokemon with this type of ball." (e.g. avalanche `{ ELEMENT_ICE, ELEMENT_WATER }`, `balls.lua:477`) |
| `returnOnBroke` | optional | `empty.lua:89-91`: the ball comes back after a miss (xeeter, `balls.lua:772`) |

Catch rate: `CATCH_RATE["<ball>"]`, read by `getBallCatchRate` (`balls.lua:1692-1694`, default
**1** when missing). See [edit-catch-rate.md](edit-catch-rate.md) for what the number means.

Special keys handled by name in code: `"safari"` (`empty.lua:164-172`, Safari Zone only) and
`"soul"` (`empty.lua:206-214`, always catches). Do not reuse these names.

---

## 5. Required IDs and how to find free ones

| ID | Poke ball | Rule |
|----|-----------|------|
| four server ids | 12157-12160 | New OTB entries, normally above 30135 ([add-item.md](add-item.md) §5). Each id must not already be in `ballsNames` |
| four client ids | 11118-11121 | Sprites in `data.dat` |
| `projectile` | 21 | An existing `PROJECTILE_*` constant (client distance effect) |
| `effects.*` | 68 / 66 / 67 | Existing `EFFECT_*` constants (client magic effects) |
| `<ball>` key | `poke` | Unique in `balls`; also a SQL column name if `useCounter` |

```bash
# is an id already a ball?
ID=30136; rg -n "\b$ID\b" server/data/lib/ps/config/balls.lua server/data/actions/actions.xml server/data/movements/movements.xml
# all ball keys and duplicated keys
rg -o '^    \["[^"]+"\] = \{' server/data/lib/ps/config/balls.lua | sort | uniq -d
# useCounter balls (each needs a ball_counter column)
rg -n -B1 'useCounter = true' server/data/lib/ps/config/balls.lua | rg '\["'
```

The duplicate check prints `["yereblu"]` today (`balls.lua:306` and `:313`, two identical
entries; the second overwrites the first, harmless).

---

## 6. Related dependencies

* `ball_counter` table (section 9) for `useCounter` balls.
* Species `allowedBall` (`config/pokemon.lua:1557-1559`): a species with
  `allowedBall = "<ball>"` can only be caught with that ball ("You cannot catch this Pokemon
  with this type of ball.").
* NPC shops sell the **empty** id (`npc/Alison.xml:10` `empty poke ball, 12157, 8;`; 28 NPC
  files list 12157).
* Ball seals (`systems/019-ballSeal.lua`), ball pillars (`events/actions/ballPillar/attach.lua`),
  trades and the depot work with any id in `ballsNames`.
* Pokémon created by `/mypokemon` always use the poke ball (`talkactions/scripts/pokemon.lua:13`).

---

## 7. Example code

Real entries:

```167:175:server/data/lib/ps/config/balls.lua
    ["poke"] = {
        useCounter = true,
        charged = 12159,
        discharged = 12160,
        empty = 12157,
        inUse = 12158,
        projectile = PROJECTILE_POKEBALL,
        effects = { use = EFFECT_POKEBALL_USE, catch = EFFECT_POKEBALL_CATCH_OK, catchMiss = EFFECT_POKEBALL_CATCH_FAIL }
    },
```

```1664:1666:server/data/lib/ps/config/balls.lua
local CATCH_RATE = {
    ["poke"] = 1,
    ["great"] = 2,
```

```17996:18008:server/data/items/items.xml
	<item id="12157" article="an" name="empty poke ball" plural="empty poke balls">
		<attribute key="description" value="The catch rate of this ball is 1x." />
	</item>
	<item id="12158" article="a" name="discharged poke ball">
		<attribute key="weight" value="090" />
	</item>
	<item id="12159" article="a" name="poke ball">
		<attribute key="slotType" value="feet" />
		<attribute key="weight" value="090" />
	</item>	
	<item id="12160" article="a" name="discharged poke ball">
		<attribute key="weight" value="090" />
	</item>
```

Template for a new catching ball (`<E>`, `<U>`, `<C>`, `<D>` = empty, in use, charged,
discharged server ids):

```lua
-- config/balls.lua, inside balls = { … }
    ["<ball>"] = {
        useCounter = true, -- Remember to update database schema
        charged = <C>,
        discharged = <D>,
        empty = <E>,
        inUse = <U>,
        projectile = PROJECTILE_POKEBALL,
        effects = { use = EFFECT_POKEBALL_USE, catch = EFFECT_POKEBALL_CATCH_OK, catchMiss = EFFECT_POKEBALL_CATCH_FAIL }
    },
-- config/balls.lua, inside CATCH_RATE = { … }
    ["<ball>"] = 2,
```

```xml
<!-- items.xml -->
<item id="<E>" article="an" name="empty <ball> ball" plural="empty <ball> balls">
    <attribute key="description" value="The catch rate of this ball is 2x." />
</item>
<item id="<U>" article="a" name="<ball> ball (in use)"><attribute key="weight" value="090" /></item>
<item id="<C>" article="a" name="<ball> ball"><attribute key="slotType" value="feet" /><attribute key="weight" value="090" /></item>
<item id="<D>" article="a" name="discharged <ball> ball"><attribute key="weight" value="090" /></item>
```

---

## 8. Registration steps

1. OTB + sprites for the four ids.
2. `items.xml` entries.
3. `balls["<ball>"]` and `CATCH_RATE["<ball>"]` in `config/balls.lua`.
4. `actions.xml`: append `;<E>` to line 90, `;<C>` to 91, `;<D>` to 92, `;<U>` to 93. These are
   `;`-separated lists; keep the four lines in sync.
5. `movements.xml`: append `;<U>;<C>;<D>` (or a range) to the `itemid` of **both** the Equip
   (line 5) and DeEquip (line 6) entries.
6. `useCounter = true`: add the database column (section 9) **before** starting the server.
7. Shop line for the empty id.
8. Restart.

---

## 9. Database requirements

Only for `useCounter = true`. `020-ballCounter.lua` builds SQL with the ball key as a column
name (`INSERT INTO ball_counter (player_id, pokemon_id, <ball>) … ON DUPLICATE KEY UPDATE`,
lines 33-45), and `getPlayerWastedBallsMessage` reads the column of **every** `useCounter` ball on
every throw (lines 65-72). The table is created by `src/schemas/psoul_extra_mysql.sql:105-128`
with `CREATE TABLE IF NOT EXISTS`, so editing that file does not change an existing database.

```sql
ALTER TABLE `ball_counter` ADD COLUMN `<ball>` INT UNSIGNED NOT NULL DEFAULT 0;
```

Also add the same column line to `psoul_extra_mysql.sql` so new installs
(`tools/setup_database.sh`) get it. Balls without `useCounter` are counted as `poke`
(`020-ballCounter.lua:29-31`) and need no column. See [database-changes.md](database-changes.md).

---

## 10. Client requirements

> The client is a frozen reference (`docs/LEGACY_CLIENT_REFERENCE.md`). Change client files
> only when the feature needs it (new sprites, the data-table lines listed here), and say why
> in the commit message. See [add-client-asset.md](add-client-asset.md).

* Four sprites (`data.dat`/`data.spr`). The client has no ball list; it shows whatever sprite the
  server id maps to.
* `projectile` and `effects.*` ids must exist in the client's effect lists. Reuse existing
  constants unless you are also adding client effects.
* Market name lines in `client/modules/gamelib/items.lua` if the balls are tradable there.

---

## 11. Server requirements

Restart. `config/balls.lua` is in `data/lib`; `actions.xml`/`movements.xml` are reloadable,
but the `balls` table in the other Lua states is not. Items need a restart anyway
(`/reload items` does nothing).

---

## 12. Validation steps

```bash
tools/check_syntax.sh server/data/lib/ps/config
tools/check_syntax.sh server/data/actions
tools/check_syntax.sh server/data/movements
tools/check_syntax.sh server/data/items
python3 tools/check_references.py          # xml.itemid (actions/movements ids), npc.shop.itemid, sql.table
# every ball id is bound to the right action line (prints nothing when fine)
for S in empty charged discharged inUse; do
  rg -o "\b$S = \d+" server/data/lib/ps/config/balls.lua | awk '{print $3}' | while read I; do
    rg -q "\b$I\b" server/data/actions/actions.xml || echo "$S $I not in actions.xml"; done; done
```

The loop prints `discharged 18631 not in actions.xml` today: the coloured ball's discharged id
(`balls.lua:344`) is missing from `actions.xml:92` (and `items.xml:24708` names it
"discharged poke ball").

At startup look for `[Warning - Actions::registerEvent] Duplicate registered item id: <id>`
(`src/actions.cpp:108,124`) and `[Warning - MoveEvents::addEvent] Duplicate move event found: <id>`
(`src/movement.cpp:304`).

---

## 13. Test steps

Use Trainer (or GM) for catching; P2-09 verified these strings.

1. GM: `/i <E>,10` and `/m Rattata` next to the player. Kill it.
2. Use the empty ball on the corpse. Expect "<Ball> ball, go!" (first letter upper-cased), the
   projectile and then either
   * "Gotcha! You caught a male Rattata (level N).", "You received a Rattata.",
     "You earned N experience points by catching Rattata!" and "You've wasted 1 <ball> ball to catch it."; or
   * "Ouch! Your <ball> ball broke." and "You've wasted 1 <ball> ball trying to catch Rattata."
3. The new ball is `<C>` and holds the Pokémon. Put it in the feet slot: the Pokémon bar
   appears (movement event). Use it: the Pokémon comes out and the ball becomes `<U>`.
4. Let it faint: the ball becomes `<D>`; using it says "This ball is discharged.".
5. Heal at Nurse Joy: back to `<C>` (P2-07).
6. `useCounter`: check the row:
   `SELECT * FROM ball_counter WHERE player_id = <guid>;` (the row is deleted after a catch,
   `020-ballCounter.lua:52-63`).
7. `allowedElements`: throw at a species of another type: "You cannot catch this type of Pokemon
   with this type of ball."

---

## 14. Common mistakes

* Forgetting one of the four `actions.xml` lines or the movement lines. Missing movement ids:
  the ball can be put in the feet slot but no Pokémon bar / icons appear.
* `useCounter = true` without the column (section 15).
* No `effects.catch` / `effects.catchMiss` on a ball with an `empty` id: the catch fails with a
  Lua error.
* Leaving out `CATCH_RATE`: the ball silently gets rate 1.
* Copying the poke ball's `items.xml` names. `12158` is the **in-use** id but is named
  "discharged poke ball" (`items.xml:17999`), so players see "discharged" while the Pokémon is
  out; use a clearer name for your in-use item.
* Only the charged id needs `slotType` feet; the others reach the slot by transformation.

---

## 15. Failure symptoms

| Symptom | Cause |
|---------|-------|
| Using the empty ball on a corpse: "Sorry, not possible." | Corpse not owned / not a Pokémon corpse, or the id is not in `ballsNames` (no `balls` entry) |
| "You cannot use this object." | Id missing from `actions.xml` |
| Console: `mysql_real_query(): SELECT \`<ball>\` FROM \`ball_counter\` … - MYSQL ERROR: Unknown column '<ball>' in 'field list' (1054)` on **every** throw of any ball; Error log `setPlayerWastedBalls - Couldn't execute query` | `useCounter` ball without the database column (`src/databasemysql.cpp:132,156`) |
| `[Error - Action Interface]` … `empty.lua` … `attempt to index field 'effects' (a nil value)` | `effects` missing in the entry |
| Ball in the feet slot shows no Pokémon bar | charged/inUse/discharged id missing from `movements.xml` |
| Fainted Pokémon's ball cannot be used | discharged id missing from `actions.xml:92` (the coloured ball 18631 has this problem today) |

---

## 16. Rollback advice

`git checkout -- server/data/lib/ps/config/balls.lua server/data/actions/actions.xml server/data/movements/movements.xml server/data/items/items.xml`
and restart. **Do not roll back while players own the new balls**: their Pokémon live in those
items, and without a `balls` entry the balls stop working (no call, no heal). Move such
Pokémon into a poke ball first (or keep the entry). The database column can stay; dropping it
(`ALTER TABLE ball_counter DROP COLUMN \`<ball>\``) is only safe after the `balls` entry is gone.

---

## 17. Dependency checklist

- [ ] Four server ids (empty, inUse, charged, discharged) in `items.otb`, not already in `ballsNames`
- [ ] Four client sprites in `data.dat`/`data.spr`
- [ ] `items.xml` entries; charged id has `slotType` feet; empty description states the catch rate
- [ ] `balls["<ball>"]` with `charged`, `discharged`, `inUse`, `empty`, `projectile`, `effects.use`/`catch`/`catchMiss`
- [ ] Optional `useCounter`, `allowedElements`, `returnOnBroke` set on purpose
- [ ] `CATCH_RATE["<ball>"]` (otherwise 1)
- [ ] `actions.xml` lines 90 (empty), 91 (charged), 92 (discharged), 93 (inUse)
- [ ] `movements.xml` lines 5 **and** 6 contain charged, discharged and inUse ids
- [ ] `useCounter`: `ALTER TABLE ball_counter ADD COLUMN \`<ball>\` …` on every database, and the column added to `psoul_extra_mysql.sql`
- [ ] NPC shop line for the empty id
- [ ] Species `allowedBall` if the ball is exclusive
- [ ] `tools/check_syntax.sh` clean; `check_references.py` no new REAL ERROR; the actions loop prints nothing for the new ids
- [ ] Test: catch, miss message, call (inUse), faint (discharged), heal (charged), `ball_counter` row
