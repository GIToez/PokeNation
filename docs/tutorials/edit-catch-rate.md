# Edit catch rates

This tutorial explains how a catch is decided and which number to change for each kind of
balance change: one species harder or easier, one ball stronger, or the whole server easier.
The worked example is **Eevee** (`chance = 200`, `config/pokemon/eevee.lua:9`) thrown at with a
**poke ball** (`CATCH_RATE["poke"] = 1`, `config/balls.lua:1665`).

All paths are relative to `server/` unless they start with `docs/`, `tools/` or `client/`.

Related: [add-pokeball.md](add-pokeball.md), [edit-pokemon.md](edit-pokemon.md).

---

## 1. The formula

`emptyBall` (`data/lib/ps/functions/ball/empty.lua:163-243`):

1. Counts this throw first: `doPlayerIncreaseWastedBalls` (line 198) adds 1 to the player's
   `ball_counter` row for this species number and ball.
2. Rolls `getCatchChance(cid, pokemonName, …) <= getBallCatchRate(<ball>)` (line 225).

`getCatchChance` (`empty.lua:52-74`):

```
catchChance = chance / (rateCatch + extraCatchRate)
if species.ignoreBallCounter: return random(1, catchChance)
tries       = Σ over useCounter balls of CATCH_RATE[ball] × wasted[ball]      (020-ballCounter.lua:101-106)
triesFactor = tries / catchChance
if triesFactor <= 0.25: return 1000                                           -- never catches
skill       = min(player catching skill, 100)
chanceMax   = ceil(catchChance - skill/10 - (triesFactor > 1 and (triesFactor - 1) × catchChance or 0))
if chanceMax < 5: chanceMax = (0 < catchChance < 5) and catchChance or 5
return random(1, chanceMax)
```

The catch succeeds when that random number is **≤ the ball's CATCH_RATE**. So the chance per
throw is `CATCH_RATE / chanceMax` (capped at 100%).

Inputs:

| Input | Where | Default / example |
|-------|-------|-------------------|
| `chance` | species file (`POKEMON["Eevee"].chance`, read by `getPokemonCatchChance`, `config/pokemon.lua:1334-1339`) | Eevee 200, Rattata 2 (`config/pokemon/rattata.lua:9`) |
| `rateCatch` | `server/config.lua` (not in git; copied from `config.example.lua`, line 341 `rateCatch = 1.0`), read once at `empty.lua:1-5` | 1.0. If missing, the Error log gets `config value 'rateCatch' can't be found!` and 1.0 is used |
| extra catch rate | player storage `playersStorages.extraCatchRateValue` (`config/playersStorages.lua:79`), `systems/053-extraCatchRate.lua:10-13` | 0. Set by `doExtraCatchRateStart` (e.g. the Halloween faction reward NPC) |
| `CATCH_RATE[<ball>]` | `config/balls.lua:1664-1688` | poke 1, great 2, ultra 3, safari 4, coloured 2.5; missing → 1 (`getBallCatchRate`, `:1692-1694`) |
| `ignoreBallCounter` | species field (18 species, e.g. `POKEMON["Easter Charmander"].ignoreBallCounter = true`, `config/pokemon/charmander.lua:34`) | nil |
| catching skill | `PLAYER_SKILL_CATCHING` (`others/constants.lua:1363`), max `PLAYER_SKILL_CATCHING_MAX = 100` (`:17`) | grows on every miss by `ceil(50 / (skill + 1))` tries (`empty.lua:81-82`) |

The `ballId` and `pokemonLevel` parameters of `getCatchChance` are not used.

---

## 2. Worked example: Eevee with poke balls

`chance = 200`, `rateCatch = 1.0`, no bonus, skill 0, so `catchChance = 200`.

| Accumulated tries (this throw included) | `chanceMax` | Chance per poke ball |
|-----------------------------------------|-------------|----------------------|
| 1-50 | — (`triesFactor ≤ 0.25`) | **0%** |
| 51-200 | 200 | 1/200 = 0.5% |
| 300 | `ceil(200 - 0.5 × 200)` = 100 | 1% |
| 390 | 10 | 10% |
| 395 and more | 5 (the floor) | 20% |

* Great ball (rate 2) adds 2 tries per throw and wins on a roll ≤ 2: throws 1-25 always fail,
  then 1% per throw, and 40% once the floor is reached.
* Ultra ball (rate 3): throws 1-16 fail, then 1.5%, and 60% at the floor.
* Skill 100 lowers `chanceMax` by 10 (200 → 190).
* `rateCatch = 2.0` halves `catchChance` to 100: the guaranteed-fail zone is 25 tries and the
  floor is reached at 195 tries.

Rattata (`chance = 2`): from the first throw `triesFactor = 0.5`, `chanceMax = 2`, so a poke ball
catches 50% of the time and a great ball always. This matches P2-09, where one throw caught and
another broke.

The counter is per **player and species number** (`ball_counter.pokemon_id`), so Eevee variants
that share number 133 share the counter. A successful catch deletes the row
(`doPlayerResetWastedBalls`, `020-ballCounter.lua:52-63`). Throws with balls that have no
`useCounter` are stored in the `poke` column (`020-ballCounter.lua:29-31`).

---

## 3. Files to edit

| Goal | File and field |
|------|----------------|
| One species harder/easier | `data/lib/ps/config/pokemon/<species>.lua` `chance` |
| One species without the tries ramp (flat random) | `ignoreBallCounter = true` in the species file |
| One ball stronger/weaker | `data/lib/ps/config/balls.lua` `CATCH_RATE["<ball>"]`, **and** the "The catch rate of this ball is Nx." description of its empty item in `items.xml` (poke: `items.xml:17996-17998`) |
| Whole server easier/harder | `server/config.lua` `rateCatch` (higher = easier) |
| Temporary per-player bonus | call `doExtraCatchRateStart(cid, seconds, value)` (`053-extraCatchRate.lua:40-50`); value 0.2 = "+20%" |
| The 25% / floor-of-5 rules themselves | `functions/ball/empty.lua:52-74` (affects every species and ball) |

---

## 4. Files NOT to edit

* `data/lib/ps/tools/catchTest.lua`: an offline simulator with a simplified formula (no tries
  factor, lines 1-64 are commented out). It is not registered in `talkactions.xml` (`/x` is
  `animationeffect.lua`, `talkactions.xml:78`), so it cannot be run in game.
* `config.example.lua` when you mean to change the running server (`server/config.lua` is the
  live one).
* `docs/reference/*`, `original/`.

---

## 5. Authoritative source paths

* Catch roll: `functions/ball/empty.lua:52-74` and `:225`.
* Tries: `systems/020-ballCounter.lua:101-106`; SQL table `ball_counter`
  (`src/schemas/psoul_extra_mysql.sql:105-128`).
* Ball rates: `config/balls.lua:1664-1694`.
* Safari Zone uses the same `getCatchChance` with `getBallCatchRate("safari")`
  (`systems/016-safariZone.lua:265`); the Jarrod quest uses it with `"coloured"`
  (`events/actions/quests/jarrodCatchItems.lua:96`).
* Soul ball ignores the roll (`empty.lua:206-214`).

---

## 6. Required IDs

None. Balls are referenced by their key (`"poke"`), species by name.

---

## 7. Related dependencies

* `chance` is also the default **sell price** of the Pokémon at the Pokémon shop NPC:
  `getPokemonPrice` = `price` or `chance × 8 × 1.25` (×2 for shiny), `config/pokemon.lua:1523-1526`,
  used by `npc/scripts/shop_pokemonShop.lua:266-348`. Eevee sells for 2000 today. Set `price`
  in the species file if you want to change the catch rate without changing the price.
* Safari Zone bait/rock maths use `chance` too (`016-safariZone.lua:18`).
* Catch experience is `experience × level × 2` (`empty.lua:34`), independent of `chance`.

---

## 8. Example code

```9:9:server/data/lib/ps/config/pokemon/eevee.lua
    chance = 200,
```

```1664:1669:server/data/lib/ps/config/balls.lua
local CATCH_RATE = {
    ["poke"] = 1,
    ["great"] = 2,
    ["ultra"] = 3,
    ["safari"] = 4,
    ["blue"] = 1,
```

Making Eevee twice as easy: `chance = 100`. Also add `price = 2000,` to keep its shop price.

---

## 9. Registration steps

None.

---

## 10. Database requirements

None for rate changes. Existing `ball_counter` rows keep their wasted counts, and the new
`CATCH_RATE` is applied to them (tries are recomputed on every throw). To test a threshold on a
**development** database you can set a row directly:

```sql
INSERT INTO ball_counter (player_id, pokemon_id, poke) VALUES (<guid>, 133, 394)
  ON DUPLICATE KEY UPDATE poke = 394;
```

---

## 11. Client requirements

None. The ball's catch-rate text is the server `items.xml` description.

---

## 12. Server requirements

Restart. `RATE_CATCH` is read once when `data/lib` loads (`empty.lua:1`), and `/reload config`
does not re-run that line. `CATCH_RATE` and species `chance` are also in `data/lib`.

---

## 13. Validation steps

```bash
tools/check_syntax.sh server/data/lib/ps/config
python3 tools/check_references.py
rg -n "rateCatch" server/config.lua          # present and numeric
```

Startup and first catch: no `config value 'rateCatch' can't be found!` in
`server/logs/Error - <date>.log`.

---

## 14. Test steps

As Trainer or GM, with empty balls (`/i 12157,20`):

1. `/m Rattata`, kill it, throw: "Poke ball, go!", then "Gotcha! You caught a male Rattata (level N)."
   and "You've wasted 1 poke ball to catch it.", or "Ouch! Your poke ball broke." and
   "You've wasted 1 poke ball trying to catch Rattata." (P2-09).
2. For a high-`chance` species, check that the first `chance / 4` tries always fail and that the
   wasted-ball message counts up.
3. With the SQL row from section 10 set to 394, the next poke ball throw at Eevee has a 20%
   chance (`chanceMax` = 5).

---

## 15. Common mistakes

* Lowering `CATCH_RATE` without changing the empty ball's description.
* Expecting `rateCatch` below 1 to make catching "a bit harder": it raises `catchChance`, which
  also widens the 25% always-fail zone.
* Setting `chance` to a very small number: `chanceMax` then becomes `catchChance` itself, and a
  great ball (rate 2) always catches when `catchChance ≤ 2`.
* Forgetting that `chance` changes the shop price.
* Adding a ball to `CATCH_RATE` under a different key than in `balls` (e.g. `"dark purple"` vs
  `"dark"`); the lookup falls back to 1.

---

## 16. Failure symptoms

| Symptom | Cause |
|---------|-------|
| Nobody can catch a species, even after many balls | `chance` very high; the first 25% of `chance` tries never catch |
| Every throw catches | `chance` very low, or `ignoreBallCounter` with a tiny `chance` |
| `[Error][…]: getPokemonCatchChance - Unknown poke name.` in the Error log | The corpse's `pokemon` attribute names a species that is not in `POKEMONS` |
| Catch rate unchanged | Server not restarted |

---

## 17. Rollback advice

`git checkout -- server/data/lib/ps/config/pokemon/<species>.lua server/data/lib/ps/config/balls.lua`
(and `server/config.lua` if you changed `rateCatch`; it is a local file, so keep your own copy).
Restart. `ball_counter` rows written during testing can stay; they are reset on the next catch.
