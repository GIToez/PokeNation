# Add a Pokémon species

This tutorial adds a new species. It uses **Eevee** as the model because Eevee touches almost
every subsystem: five evolutions (stones, Soothe Bell, day/night), egg data, field abilities,
TMs and a variant ("RC Eevee"). The steps list every file Eevee appears in, explain what reads
each field, and show what a new species needs in each of those places.

All paths are relative to `server/` unless they start with `docs/`, `tools/` or `client/`.
`<Name>` is the species name (case-sensitive, e.g. `Eevee`) and `<N>` is its national number
(e.g. `133`). Values written in angle brackets are placeholders that you must pick with the
commands in section 5; no new number in this document is a real free ID.

Related tutorials: [edit-pokemon.md](edit-pokemon.md) (change an existing species),
[add-evolution.md](add-evolution.md), [add-move.md](add-move.md), [add-tm.md](add-tm.md),
[edit-catch-rate.md](edit-catch-rate.md), [add-spawn.md](add-spawn.md),
[add-client-asset.md](add-client-asset.md).

---

## 1. How a species is put together

One species is joined by **name** across five layers. If any layer misses the name, or
spells it differently, that subsystem silently stops working for the species:

```
data/lib/ps/config/pokemon/<name>.lua      POKEMON["<Name>"] = { ... }          stats, moves, evolutions, ids
data/lib/ps/config/pokemonsNumbers.lua     ["<Name>"] = <N>  and  [<N>] = "<Name>"
data/lib/ps/config/pokemonsNames.lua       "<Name>" in NORMAL_1ST / NORMAL_2ND / NORMAL_3RD
data/monster/monsters.xml                  <monster name="<Name>" file="Pokemons/<name>.xml"/>
data/monster/Pokemons/<name>.xml           health, looktype, corpse, level range, wild AI
client/modules/gamelib/pokemon.lua         {name = "<Name>", iconItemId = <fastcallPortrait>}
```

Load order matters. `data/lib/999-ps.lua` loads `config/pokemonsNumbers.lua` and
`config/pokemonsNames.lua` **before** `config/pokemon.lua`. `config/pokemon.lua:21-22` then runs
`dodirectory(PS_LIB_CONFIG_DIR .. "pokemon/")`, which loads every `*.lua` file in that directory
in sorted order. The loader is not recursive and stops at the first file that fails
(`src/luascript.cpp:721-740`). After that, `config/pokemon.lua` post-processes the table
(lines 24-53 and 1056-1727) and renames it to the local `POKEMONS`. All the getters at lines
1271-1609 read from that table.

This whole `data/lib/` tree is loaded **once per Lua state** (actions, talkactions, spells,
creaturescripts, movements, globalevents, npc, weapons; `LuaScriptInterface::initState`,
`src/luascript.cpp:836-845`). An error in your file therefore shows up several times at startup.

---

## 2. Files to edit

| # | File | What you add |
|---|------|--------------|
| 1 | `data/lib/ps/config/pokemon/<name>.lua` (new file) | `POKEMON["<Name>"] = { ... }` (section 6) |
| 2 | `data/lib/ps/config/pokemonsNumbers.lua` | `["<Name>"] = <N>` in `pokemonsNumbers` (Eevee: line 163) **and** `[<N>] = "<Name>"` in `pokemonNameByNumber` (Eevee: line 967). If `<N>` > 386, raise `POKEMON_NUMBER` (line 1) |
| 3 | `data/lib/ps/config/pokemonsNames.lua` | `"<Name>",` in `NORMAL_1ST` (line 1), `NORMAL_2ND` (181) or `NORMAL_3RD` (284). Eevee is at line 160 |
| 4 | `data/lib/ps/config/pokemon.lua` | `[<eggId>] = "<Name>",` in `POKEMON_NAME_BY_EGG_ID` (lines 1072-1259; Eevee at 1141). Optionally `POKEMONS["Shiny <Name>"].portrait/fastcallPortrait = …` (lines ~76-1054) if a shiny exists |
| 5 | `data/monster/Pokemons/<name>.xml` (new file) | the wild monster (section 6.2) |
| 6 | `data/monster/monsters.xml` | `<monster name="<Name>" file="Pokemons/<name>.xml"/>` (Eevee: line 138) |
| 7 | `data/items/items.xml` | entries for the new portrait item and the egg item, if you create new ones (section 5) |
| 8 | `data/world/map-spawn.xml` or a globalevent | where the species appears in the wild ([add-spawn.md](add-spawn.md)) |
| 9 | `client/modules/gamelib/pokemon.lua` | `POKEMON[#POKEMON + 1] = {name = "<Name>", iconItemId = <fastcallPortrait>}` (Eevee: line 257), plus `["<Name>"] = <N>` (Eevee: line 723) and `[<N>] = "<Name>"` (Eevee: line 1390) |
| 10 | `client/data/images/pictures/<N>.png`, `client/data/images/pokeicons/<NNN>.png`, `client/data/images/staticPortraits/<N>.png` | Pokédex picture (100×100), family icon (32×32, three digits), level-up window portrait (96×96) |

Optional: `data/lib/ps/systems/011-highscore.lua` has one block per species
(`HIGHSCORE_ID_CAUGHT_EEVEE = 134` at line 134, its storage `16133` at line 915, its name at
line 1306, its text global storage `5134` at line 1697). Without these entries the species
just has no "Caught <Name>" highscore.

---

## 3. Files NOT to edit

| Path | Why |
|------|-----|
| `data/lib/ps/config/_pokemon/` | Historical snapshot of the species configs. It is never loaded. `docs/HISTORICAL_CODE_DIFF.md` Tree 1 |
| `data/lib/ps/others/pokemon_backup/` | Historical backup, never loaded |
| `data/lib/ps/others/moves_disabled/`, `data/lib/ps/systems/disabled/` | Disabled trees, never loaded |
| `original/` | Untouched import of the upstream archive, for reference only |
| `docs/reference/POKEMON.md` | Generated by `tools/gen_reference.py`. Regenerate it, do not edit it by hand |
| `server/logs/*` | Runtime output |

`check_references.py` reports findings in these trees as `HISTORICAL BACKUP`, not as errors.

---

## 4. Authoritative source paths

* Species data: `data/lib/ps/config/pokemon/*.lua` (432 files; some define several keys, e.g.
  `eevee.lua:32-34` defines `RC Eevee` with `table.deepcopy`).
* Post-processing and getters: `data/lib/ps/config/pokemon.lua`.
* Numbers and names: `data/lib/ps/config/pokemonsNumbers.lua`, `pokemonsNames.lua`.
* Constants used by the fields: `data/lib/ps/others/constants.lua` (`ELEMENT_*` 75-95,
  `POKEMON_ABILITIES` 368-385, `TM_IDS` 451-549, `POKEMON_SPECIAL_ABILITY_IDS` 551+,
  `POKEMON_EGG_GROUP_*` ~1260-1300, `WORLD_LIGHT_STATE_*` 1342-1345).
* Evolution item constants: `ITEMS.*` at `data/lib/ps/config/pokemon.lua:1-19`. The table is
  cleared after loading, so `ITEMS.FIRE_STONE` exists only while the species files load.
* Wild monster: `data/monster/monsters.xml` and `data/monster/Pokemons/*.xml`, parsed by
  `src/monsters.cpp`.

---

## 5. Required IDs and how to find free ones

| Field | Kind | Eevee | Rule |
|-------|------|-------|------|
| `<N>` national number | number | 133 | Unique per base species. Variants such as `Shiny Eevee` and `RC Eevee` reuse it (`pokemonsNumbers.lua:552`). It is also the key of `ball_counter.pokemon_id` and of the client pictures |
| `dexStorage` | player storage | 10133 | Always `10000 + <N>` in the live data (max 10386). Holds the Pokédex status of that species |
| `catchStorage` | player storage | 16133 | `16000 + <N>`, or `-1` to let `config/pokemon.lua:27-29` compute it |
| `portrait` | **server** item id | 12834 | The item put into the portrait slot when the Pokémon is out (`functions/player.lua:606`). `-1` → `28149 + <N>` (`pokemon.lua:32-34`) |
| `fastcallPortrait` | **client** item id | 10767 | The client id of the same picture. It is sent raw to the Pokémon bar and the move bar (`systems/006-fastcall.lua:34`, `functions/player.lua:402`) |
| `dexPortrait` | server item id | 13634 | Not read by any server Lua except the `-1` auto-fill (`28013 + <N>`, `pokemon.lua:37-39`). The client Pokédex computes its own icon (section 9) |
| `eggId` | server item id | 14044 "eevee egg" (`items/items.xml:20615`) | Created by the daycare (`npc/scripts/daycareFemale.lua:332`). Must also be mapped back in `POKEMON_NAME_BY_EGG_ID` |
| looktype | client outfit id | 484 (`Pokemons/eevee.xml:4`) | Must exist in `client/data/things/data.dat` (2587 outfits) |
| corpse | server item id | 11521 | A container item; the engine writes `pokemon`, `level`, `sex` onto it (`src/monster.cpp:1308-1312`) |

**Server id vs client id.** `portrait` 12834 and `fastcallPortrait` 10767 are the same picture:
12834 is the server id and 10767 is its client id in `items.otb`. Background is in
`docs/DEVELOPER_HANDBOOK.md` §7.1. To convert ids, paste this snippet. It is read-only and
parses `items.otb`:

```bash
cd /path/to/PokeNation      # repository root
python3 - 12834 13806 <<'EOF'
import sys
d = open("server/data/items/items.otb", "rb").read()
s2c, stack, i = {}, [], 4
while i < len(d):
    b = d[i]
    if b == 0xFE: stack.append(bytearray()); i += 1
    elif b == 0xFF:
        n = stack.pop(); i += 1
        if len(stack) == 1 and len(n) >= 5:
            k, sid, cid = 5, None, None
            while k + 3 <= len(n):
                a, l = n[k], n[k+1] | n[k+2] << 8; v = n[k+3:k+3+l]; k += 3 + l
                if a == 0x10: sid = v[0] | v[1] << 8
                if a == 0x11: cid = v[0] | v[1] << 8
            if sid: s2c[sid] = cid
    elif b == 0xFD: stack[-1].append(d[i+1]); i += 2
    else:
        if stack: stack[-1].append(b)
        i += 1
for q in map(int, sys.argv[1:]):
    print(q, "->", s2c.get(q, "NOT IN items.otb"))
EOF
# 12834 -> 10767
# 13806 -> 12026
```

Finding free values:

```bash
# national numbers in use (base species); the highest is POKEMON_NUMBER = 386
rg -o '\[(\d+)\] = "' server/data/lib/ps/config/pokemonsNumbers.lua | sort -t[ -k2 -n | tail -3
# is a storage key free? (dexStorage / catchStorage of the new number)
K=10387; rg -n "\b$K\b" server/data --glob '*.{lua,xml}' --glob '!**/_pokemon/**' --glob '!**/pokemon_backup/**'
# portrait items: the "pokemon portrait" range and the explicit portraits of every species
rg -n 'name="pokemon portrait"' server/data/items/items.xml
rg -o 'portrait = \d+' server/data/lib/ps/config/pokemon | sort -t= -k2 -n | uniq -d   # duplicates?
# looktypes already used by monsters
rg -o '<look type="\d+"' server/data/monster -r '' --no-filename | sort -u | wc -l
rg -n '<look type="484"' server/data/monster      # who uses a given looktype
# egg item id
rg -n 'name="[a-z]+ egg"' server/data/items/items.xml | tail -3
```

For a free item id, see [add-item.md](add-item.md) §5. Ids 30001-30099 in `items.xml` cannot be
used: `Items::parseItemNode` maps them onto ids 1-99 (`src/items.cpp:520-527`). Also watch out
for ids computed by formulas. `28149 + <N>` and `28013 + <N>` have no `items.xml` entry for
many numbers, but they are still "used" by the `-1` auto-fill.

---

## 6. Example code

### 6.1 Species config (real file)

```1:34:server/data/lib/ps/config/pokemon/eevee.lua
POKEMON["Eevee"] = {
    pTypes = { ELEMENT_NORMAL },
    dexStorage = 10133,
    atk = 55,
    def = 50,
    spAtk = 45,
    spDef = 65,
    energy = 100,
    chance = 200,
    portrait = 12834,
    dexPortrait = 13634,
    fastcallPortrait = 10767,
    catchStorage = 16133,
    evolutions = {
        { name = "Vaporeon", requiredLevel = 30, requiredItems = { ITEMS.WATER_STONE } },
        { name = "Jolteon", requiredLevel = 30, requiredItems = { ITEMS.THUNDERSTONE } },
        { name = "Flareon", requiredLevel = 30, requiredItems = { ITEMS.FIRE_STONE } },
        { name = "Espeon", requiredLevel = 30, requiredItems = { ITEMS.SOOTHE_BELL }, requiredTime = WORLD_LIGHT_STATE_DAY },
        { name = "Umbreon", requiredLevel = 30, requiredItems = { ITEMS.SOOTHE_BELL }, requiredTime = WORLD_LIGHT_STATE_NIGHT }
    },
    description = "An extremely rare POKEMON that may evolve in a number of different ways depending on stimuli.",
    skills = { "Tackle", 1, "Quick Attack", 5, "Sand-Attack", 10, "Bite", 15, "Headbutt", 20, "Agility", 25 },
    abilities = { POKEMON_ABILITIES.DIG, "Headbutt", "Find" },
    eggGroup = { POKEMON_EGG_GROUP_FIELD },
    eggId = 14044,
    eggChance = 1,
    specialAbilities = { POKEMON_SPECIAL_ABILITY_IDS.RUN_AWAY, POKEMON_SPECIAL_ABILITY_IDS.ADAPTABILITY },
    learnableTms = { TM_IDS.SOFTBOILED, TM_IDS.MUD_SLAP, TM_IDS.SHADOW_BALL, TM_IDS.IRON_TAIL, TM_IDS.RAIN_DANCE, TM_IDS.HEADBUTT, TM_IDS.TOXIC, TM_IDS.BODY_SLAM, TM_IDS.TAKE_DOWN, TM_IDS.DOUBLE_EDGE, TM_IDS.RAGE, TM_IDS.MIMIC, TM_IDS.DOUBLE_TEAM, TM_IDS.REFLECT, TM_IDS.BIDE, TM_IDS.SWIFT, TM_IDS.SKULL_BASH, TM_IDS.REST, TM_IDS.SUBSTITUTE },
    eggMoves = { "Captivate", "Charm", "Covet", "Curse", "Detect", "Endure", "Fake Tears", "Flail", "Natural Gift", "Stored Power", "Synchronoise", "Tickle", "Wish", "Yawn" }
}

POKEMON["RC Eevee"] = table.deepcopy(POKEMON["Eevee"])
POKEMON["RC Eevee"].pTypes = { ELEMENT_POISON, ELEMENT_NORMAL }
POKEMON["RC Eevee"].blockTransform = true
```

What reads each field. Line numbers are in `data/lib/ps/config/pokemon.lua` unless stated.

| Field | Required? | Read by | Effect |
|-------|-----------|---------|--------|
| `pTypes` | yes | `getPokemonTypes` 1271 | Type effectiveness, ball `allowedElements` check (`functions/ball/empty.lua:188-190`), Pokédex |
| `dexStorage` | yes | `getPokemonDexStorage` 1288 → `systems/010-pokedex.lua:74-87` | Pokédex status per player |
| `atk`, `def`, `spAtk`, `spDef` | yes | 1295-1325, `getPokemonAtk/Def/SpAtk/SpDef` 1452-1470 | `(base + extra) × level × 0.05 × modifiers` |
| `energy` | yes | `getPokemonBaseEnergy` 1327 → `config/balls.lua` `doCreatePokemonBall` | Ball energy = `energy + POKEMON_GAIN_ENERGY × level`. Shiny copies get 200 (line 46) |
| `chance` | yes | `getPokemonCatchChance` 1334 → `functions/ball/empty.lua:53` | Catch difficulty ([edit-catch-rate.md](edit-catch-rate.md)); also the default market price, `getPokemonPrice` 1523-1526 |
| `portrait` | yes | `getPokemonPortraitId` 1341 → `functions/player.lua:606` | Portrait item in the player's portrait slot |
| `fastcallPortrait` | yes | 1355 → `006-fastcall.lua:34`, `player.lua:402` | Pokémon bar and move bar icon (client id) |
| `dexPortrait` | yes (may be `-1`) | 1348; no live caller | Kept for completeness |
| `catchStorage` | yes (may be `-1`) | 1501 → `functions/player.lua:756-765` | Per-species catch count |
| `evolutions` | **yes, at least `{}`** | the shiny loop at line 50 runs `pairs(...evolutions)` for every species; `evolve.lua` | A missing field breaks loading of `config/pokemon.lua` |
| `description` | yes | 1362 → Pokédex | Text |
| `skills` | **yes** | 1369-1430, `doCheckPokemonSkills` 1729-1738 | Flat list `"Move", level, "Move", level …`. The first entry is the Tackle slot (sketch moves start at slot 2, line 1395) |
| `abilities` | yes | `getPokemonAbilityAvailable` 1607 | Field abilities; values must equal the `POKEMON_ABILITIES` strings (`"Headbutt"` = `POKEMON_ABILITIES.HEADBUTT`) |
| `eggGroup` | yes | 1479 → `canPokemonBreed` 1571, Pokédex 010:210 | Breeding |
| `eggId` | yes for breeding | `getPokemonEggId` 1486 → `npc/scripts/daycareFemale.lua:332` | The egg item the daycare gives |
| `eggChance` | optional (default 10, line 1498) | `daycareFemale.lua:41` | Egg rate |
| `specialAbilities` | optional (default `{}`) | 1508-1521 | Rolled on spawn/catch/evolve |
| `learnableTms` | yes (a list, or `true` for "all") | 1596-1605, `018-technicalMachine.lua:626` | TM compatibility |
| `eggMoves` | optional | 1553, pruned by `doUpdatePokemonEggMovesList` 1659-1717 | Only the **lowest form's** list is kept; evolutions copy it (1705-1716) |
| `blockTransform`, `allowedBall`, `ignoreBallCounter`, `price` | optional | 1532, 1557, 1561, 1523 | Ditto/Transform block, ball restriction, catch formula bypass, fixed price |

`evolutionStone` (getter at 1445-1450) does not exist in any species file and nothing calls the
getter. Do not add it.

### 6.2 Monster XML (real file, abridged)

```2:24:server/data/monster/Pokemons/eevee.xml
<monster name="Eevee" nameDescription="an Eevee" shiny="Shiny Eevee" race="blood" experience="7" speed="255" manacost="0" minLevel="20" maxLevel="30">
	<health now="55" max="55"/>
	<look type="484" head="0" body="0" legs="0" feet="0" corpse="11521"/>
	...
	<attacks>
		<attack name="melee" interval="1818" skill="24" attack="55"/>
		<attack name="Moves" interval="500"/>
		<attack name="Berries" inverval="60000" chance="1" target="1"/>
	</attacks>
```

* `name` must equal the `POKEMON[...]` key exactly.
* `shiny` is the name of the shiny monster (`src/monsters.cpp:935-938`). Lua uses it in
  `getMonsterInfo(name).shiny` (eggs, fishing, headbutt). The spawner instead tries
  `"Shiny " + name` (`src/spawn.cpp:310-312`).
* `minLevel`/`maxLevel` are PSoul attributes (`src/monsters.cpp:971-979`).
* `health max` + 300 is the trainer-owned base HP (`getPokemonBaseHealth`, `pokemon.lua:1472-1477`).
* `experience` × level × 2 is the catch XP (`functions/ball/empty.lua:34`), and × 20 is the
  Pokédex discovery XP (`010-pokedex.lua:119`).
* `<attack name="Moves">` makes the wild Pokémon use its `skills` (spell "Moves",
  `data/spells/spells.xml:5` → `lib/ps/events/spells/Moves.lua`). `"Evolve"` (spells.xml:4) lets a
  wild Pokémon evolve (`lib/ps/events/spells/Evolve.lua`); Charmander has it, Eevee does not.
* The `inverval` typo on `Berries` is present in hundreds of files (BUG-47). Do not copy it;
  write `interval`.
* Catchable is the default. `<flag catchable="0"/>` (`src/monsters.cpp:1031-1032`) makes the
  corpse unusable for balls.

### 6.3 Registration lines (real)

```138:138:server/data/monster/monsters.xml
	<monster name="Eevee" file="Pokemons/eevee.xml"/>
```

```163:163:server/data/lib/ps/config/pokemonsNumbers.lua
    ["Eevee"] = 133,
```

```1141:1141:server/data/lib/ps/config/pokemon.lua
    [14044] = "Eevee",
```

```257:257:client/modules/gamelib/pokemon.lua
POKEMON[#POKEMON + 1] = {name = "Eevee", iconItemId = 10767}
```

### 6.4 Template for a new species

Copy an existing file with the same evolution shape and change every value. Each `<…>` must
be replaced with a value you checked in section 5:

```lua
POKEMON["<Name>"] = {
    pTypes = { ELEMENT_NORMAL },
    dexStorage = <10000 + N>,
    atk = 55, def = 50, spAtk = 45, spDef = 65,
    energy = 100,
    chance = 200,
    portrait = <server id of the portrait item, or -1>,
    dexPortrait = -1,
    fastcallPortrait = <client id of that portrait>,
    catchStorage = -1,
    evolutions = { },
    description = "<Pokédex text>",
    skills = { "Tackle", 1, "Quick Attack", 5 },
    abilities = { },
    eggGroup = { POKEMON_EGG_GROUP_FIELD },
    eggId = <server id of the egg item>,
    eggChance = 10,
    specialAbilities = { POKEMON_SPECIAL_ABILITY_IDS.RUN_AWAY },
    learnableTms = { TM_IDS.TOXIC },
    eggMoves = { }
}
```

---

## 7. Related dependencies

* **Moves:** every name in `skills` and `eggMoves` must be a `MOVES[...]` key in
  `data/lib/ps/config/moves/` with a `script_<Move>` spell ([add-move.md](add-move.md)).
* **Evolutions:** each `evolutions[].name` must be a loaded species, and its monster must be
  in `monsters.xml`. Otherwise you get "Your Pokemon can't evolve right now."
  ([add-evolution.md](add-evolution.md)).
* **TMs:** `TM_IDS.X` must exist in `others/constants.lua:451-549`. A misspelling evaluates to
  `nil` and is silently dropped (`docs/HISTORICAL_CODE_DIFF.md`, 8 such typos in the live tree).
* **Field abilities:** Ride/Fly/Surf also need an outfit and a speed. For example Ponyta has
  `OUTFIT_RIDE_PONYTA` (`others/outfits.lua:73`, lookType 566 at line 463) and
  `RIDE_SPEED` Ponyta 120 (`functions/abilities.lua:9-10`). Without them the ability fails
  (compare BUG-50 for Dive).
* **Shiny:** an automatic `Shiny <Name>` config copy is created (`pokemon.lua:43-52`) and then
  deleted unless you set its `portrait`/`fastcallPortrait` (`pokemon.lua:1056-1060`). A wild
  shiny additionally needs a `Shiny <Name>` monster in `monsters.xml`.
* **Variants** (`RC <Name>`, `Christmas <Name>`, `Easter <Name>`) are extra keys in the same
  file plus their own monster XML. They are not in `pokemonsNames`, so `isPokemonName`
  rejects them and they cannot be caught with normal balls (`functions/ball/empty.lua:187`).

---

## 8. Registration steps

1. Create `data/lib/ps/config/pokemon/<name>.lua` (section 6.4).
2. Add both number lines to `pokemonsNumbers.lua`. If `<N>` > 386, set `POKEMON_NUMBER = <N>`
   (line 1). This is also the Pokédex size in `systems/010-pokedex.lua:2-5`.
3. Add `"<Name>"` to the right generation array in `pokemonsNames.lua`. That array drives
   `isPokemonName`, the Pokédex list (`pokemonNamesWithoutShiny`) and
   `getPokemonGenerationByName`.
4. Add `[<eggId>] = "<Name>"` to `POKEMON_NAME_BY_EGG_ID` in `config/pokemon.lua`.
5. Create `data/monster/Pokemons/<name>.xml` and register it in `data/monster/monsters.xml`.
6. Add `items.xml` entries for any new portrait or egg item ([add-item.md](add-item.md)).
7. Make it appear in the wild: add `<monster name="<Name>" …/>` blocks to
   `data/world/map-spawn.xml` ([add-spawn.md](add-spawn.md)), or use a globalevent like
   `lib/ps/events/globalevents/eeveeRespawn.lua` (`globalevents.xml:8`, interval 10800 s).
   Eevee has **no** entry in `map-spawn.xml` and appears only through that script.
8. Client: add the three `gamelib/pokemon.lua` lines and the three PNG files (section 9).

No `actions.xml`, `spells.xml` or `talkactions.xml` change is needed for a species.

---

## 9. Client requirements

> The client is a frozen reference (`docs/LEGACY_CLIENT_REFERENCE.md`). Change client files
> only when the feature needs it (new sprites, the data-table lines listed here), and say why
> in the commit message. See [add-client-asset.md](add-client-asset.md).

| What | Where | Why |
|------|-------|-----|
| Outfit (looktype) sprites | `client/data/things/data.dat` + `data.spr` | Without them the creature is invisible or shows as a different outfit |
| Portrait / fastcall item sprite | `data.dat` + `data.spr` (client id = `fastcallPortrait`) and `server/data/items/items.otb` (server id = `portrait`) | Pokémon bar, move bar, portrait slot |
| `{name, iconItemId}` | `client/modules/gamelib/pokemon.lua` `POKEMON` list (line 257 for Eevee) | `getPokemonNameByIconItemId` → Pokémon bar tooltip (`game_pokebar/pokebar.lua:188`) |
| number tables | `gamelib/pokemon.lua:563+` (`pokemonsNumbers`) and `:1257+` (`pokemonNameByNumber`) | Pokédex window titles and family tooltips |
| `images/pictures/<N>.png` | `client/data/images/pictures/` (393 files) | Pokédex picture (`game_pokedex/pokedex.lua:229`), character list (`client_entergame/characterlist.lua:224`) |
| `images/pokeicons/<NNN>.png` | `client/data/images/pokeicons/` (`%03d`) | Pokédex family strip (`game_pokedex/pokedex.lua:254`) |
| `images/staticPortraits/<N>.png` | `client/data/images/staticPortraits/` | Level-up / new-move window (`game_advanceeffect/advanceeffect.lua:170`) |
| Pokédex grid icon | computed in `game_pokedex/pokedex.lua:52-58` | `11873 + N` (≤151), `15798 - 151 + N` (≤251), `27108 - 251 + N` (above). The client id must exist in `data.dat`; the server `dexPortrait` is not used |

Sprite editing is described in [add-client-asset.md](add-client-asset.md). The client has no
`items.otb`. It uses client ids directly, so an existing sprite can be reused by pointing a
new server id at the same client id in `items.otb`.

---

## 10. Database requirements

None for the schema. Per-player data is created on demand:

* `player_storage` rows for `dexStorage` (Pokédex status) and `catchStorage` (catch count);
* `ball_counter` rows keyed by `pokemon_id = <N>` (`systems/020-ballCounter.lua:33-49`);
* the Pokémon itself lives in item attributes of the ball (`player_items.attributes`,
  `docs/DEVELOPER_HANDBOOK.md` §8.2).

Never renumber an existing species: old `ball_counter` rows, storages and every Pokédex keep
the old number.

---

## 11. Server requirements

A full restart is required. `/reload` cannot load a new species consistently: the species
table lives in every Lua state, and `/reload monsters` alone does not rebuild the Lua tables
(`docs/DEVELOPER_HANDBOOK.md` §10.3). No C++ change and no `config.lua` change.

---

## 12. Validation steps

```bash
tools/check_syntax.sh server/data/lib/ps/config   # expect "... 0 with syntax errors ..."
tools/check_syntax.sh server/data/monster         # expect "... 0 malformed"
python3 tools/check_references.py                 # compare the REAL ERROR list with a run saved before the change
python3 tools/check_references.py --all | rg -i '<Name>'
```

`check_references.py` validates `pokemon.evolution` (targets are species),
`pokemon.evolution.item` (`ITEMS.*` exists and the item exists), `pokemon.move`
(`skills` entries are moves), `pokemon.eggMove.*`, `pokemon.ability` (strings match
`POKEMON_ABILITIES`), `pokemon.tm` (`TM_IDS` keys), `pokemon.itemid` (portrait/egg ids in
`items.xml`/`items.otb`) and `monsters.xml.file`/`monsters.xml.duplicate`.

Start the server (`tools/start_server.sh`) and check:

* The console reaches `>> Cristal server Online!` with no new `[Error - …]` lines.
  `[Error - LuaScriptInterface::loadFile] data/lib/ps/config/pokemon/<name>.lua:…` means a
  syntax or runtime error in your file.
* No `Unknown Pokemon Move: <Name> - <move>` line on the console. This is printed by
  `doCheckPokemonSkills` (`pokemon.lua:1734`) when a `skills` entry is not a move.
* No new `[Warning - Monsters::loadMonster]` line.
* `server/logs/Info - <dd-mm-YYYY>.log` gets a new batch of `Planting random seeds...` lines
  (`data/lib/999-ps.lua:43`), one per Lua state that finished loading the lib. Compare the
  count with a previous start. `server/logs/Error - <date>.log` should get no
  `getPokemon… - Unknown poke name.` entries.

---

## 13. Test steps

Use **GM Admin** for GM commands and **Tester** or **Trainer** for anything that uses moves
(GM Pokémon always get "Sorry, your Pokemon has insufficient energy", BUG-05,
`docs/BUILDING.md` §8.3). Items created with `/i` land in the hidden slot-3 backpack (BUG-12).

1. **Summon:** `/mypokemon <Name>,20`. An unknown name gives "Invalid Pokemon name."
   (`talkactions/scripts/pokemon.lua:8-10`; the name check is exact-case). Expect
   "You received <nameDescription>." Then click the bar icon and expect "<Name>, go!" or one
   of the call variants (P2-04). Check that the bar icon is your `fastcallPortrait` and the
   portrait slot shows the `portrait` item.
2. **Combat:** as Tester, `/m Rattata` (from the GM), attack and say `m1`. Expect
   "<Name>, Tackle!" and "Your <Name> deals N damage to a Rattata." (P2-05).
3. **Wild form:** GM `/m <Name>` spawns it with a level between `minLevel` and `maxLevel`.
4. **Catch:** defeat it and use an empty poke ball (12157) on the corpse. Expect
   "Gotcha! You caught a male <Name> (level L)." or "Ouch! Your poke ball broke.", then
   "You've wasted 1 poke ball …" (P2-09). With `chance = 200` the first ~50 poke balls
   always fail (see [edit-catch-rate.md](edit-catch-rate.md)).
5. **Pokédex:** use the Pokédex (12281) on the wild Pokémon. Expect "You earned X experience
   points by discovering <Name>!" (`010-pokedex.lua:122`). Using it on yourself shows
   "Pokedex status: [x/386]." (`010-pokedex.lua:618`).
6. **Level-up:** fight until "Congratulations! Your <Name> advanced from level L to level L+1."
   New moves from `skills` appear on the move bar only when the level is reached
   (`functions/player.lua:387-393`).
7. **Evolution:** see [add-evolution.md](add-evolution.md) §13.
8. **TM:** see [add-tm.md](add-tm.md) §13.

---

## 14. Common mistakes

* Missing `evolutions = {}` or `skills`. The post-processing loops index them for every
  species and break the load of `config/pokemon.lua`.
* The name differs between config, `monsters.xml`, `pokemonsNumbers.lua` and
  `pokemonsNames.lua` (e.g. `Nidoran F` vs `Nidoran♀`).
* Swapping server and client ids: `portrait` is a server id, `fastcallPortrait` is a client id.
* Forgetting the reverse table `pokemonNameByNumber`. Then the Pokédex and `ball_counter`
  messages break for that number.
* Typos in `TM_IDS.X`, `POKEMON_ABILITIES.X` (a nil value) or in ability strings
  (BUG-30 "Strenght").
* Putting egg moves on an evolved form. They are overwritten from the lowest form
  (`pokemon.lua:1705-1716`).
* Copying `catchStorage`/`eggId` from another file. `mawile.lua:13` has
  `catchStorage = 28559`, which is its egg item id; it works only because
  `011-highscore.lua:1143` copied the same number.
* Editing `config/_pokemon/` instead of `config/pokemon/`.

---

## 15. Failure symptoms

| Symptom | Cause |
|---------|-------|
| `[Error - LuaScriptInterface::loadFile] …/config/pokemon/<file>.lua:…` repeated about 9 times, then `Failed to load directory data/lib/ps/config/pokemon/.` (under a `[Lua Error]` or `[Error - <interface>]` header, `luascript.cpp:791-816`, `:11570`) | Syntax/runtime error in a species file. The loader stops, so **every species whose file sorts after it is missing** (`luascript.cpp:735-737`) |
| `[Warning - LuaScriptInterface::initState] Cannot load data/lib/` | A later lib error caused by the above; nothing PSoul-related works |
| `Unknown Pokemon Move: <Name> - <move>` (console and `logs/Print - …`) | A `skills` entry is not a move |
| `[Warning - Monsters::loadMonster] Cannot load monster (<Name>) file (…).` / `[Error - Monsters::loadMonster] Malformed monster (<Name>) file (…).` | Bad path or XML in `monsters.xml` / the monster file (`src/monsters.cpp:900`, `:909`) |
| `[Error - Monsters::deserializeSpell] … - Unknown spell name: …` | An `<attack name="…">` that is not a spell (`src/monsters.cpp:818`) |
| `[Warning - Monsters::loadMonster] Duplicate registered monster with name: <name>` | Name registered twice (`src/monsters.cpp:874`) |
| "Invalid Pokemon name." on `/mypokemon` | Not in `pokemonsNames.lua` or wrong case |
| "Sorry, not possible." when throwing a ball at the corpse | Not in `pokemonsNames.lua` (`functions/ball/empty.lua:187,239`), or `catchable="0"` |
| `[Error][…]: getPokemonDexStorage - Unknown poke name.` in `logs/Error - <date>.log`, followed by `attempt to index field '?' (a nil value)` | Monster exists but no config key with exactly that name |
| Invisible wild Pokémon / wrong sprite | Looktype missing in `data.dat` |
| Blank or unrelated icon on the Pokémon bar | `fastcallPortrait` is a server id or not in `data.dat` |
| "Your Pokedex can not register this Pokemon! Please, upgrade your Pokedex." | `<N>` > `POKEMON_NUMBER` (`010-pokedex.lua:108-115`) |

---

## 16. Rollback advice

* Uncommitted changes: `git checkout -- server/data/lib/ps/config/pokemonsNumbers.lua …`
  for edited files, and delete new files (`git status` lists them as untracked).
* Committed: `git revert <commit>`.
* Restart the server. `/reload` (GM, `talkactions.xml:65`) cannot undo a species change
  consistently: each `/reload <type>` re-runs `data/lib` only for that one Lua state, and
  `/reload items` / `/reload all` print "Reload type does not work"
  (`src/game.cpp:6341+`, `docs/DEVELOPER_HANDBOOK.md` §10.3).
* Players who caught the new species keep balls with `pokemonName = "<Name>"`. Removing the
  species later breaks those balls, so delete them via SQL while the server is stopped
  ([database-changes.md](database-changes.md)).

---

## 17. Dependency checklist

- [ ] Species config `data/lib/ps/config/pokemon/<name>.lua` with `POKEMON["<Name>"]`
- [ ] Stats: `pTypes`, `atk`, `def`, `spAtk`, `spDef`, `energy`, `description`
- [ ] National number: `pokemonsNumbers["<Name>"] = <N>` and `pokemonNameByNumber[<N>] = "<Name>"`; `POKEMON_NUMBER` raised if `<N>` > 386
- [ ] Name in `NORMAL_1ST` / `NORMAL_2ND` / `NORMAL_3RD` (`pokemonsNames.lua`)
- [ ] `dexStorage = 10000 + <N>` and `catchStorage` (`16000 + <N>` or `-1`) free
- [ ] Monster definition `data/monster/Pokemons/<name>.xml` (`name`, `nameDescription`, `experience`, `minLevel`, `maxLevel`, `health`, `look type`, `corpse`, `Moves` attack) and registered in `monsters.xml`
- [ ] Portrait: `portrait` (server id) exists in `items.xml` + `items.otb`
- [ ] Fastcall portrait: `fastcallPortrait` (client id) exists in `data.dat`; `gamelib/pokemon.lua` `{name, iconItemId}` entry
- [ ] Sprites/assets: looktype in `data.dat`/`data.spr`; `pictures/<N>.png`, `pokeicons/<NNN>.png`, `staticPortraits/<N>.png`; Pokédex grid client id (formula in `pokedex.lua:52-58`) exists
- [ ] Moves: every `skills` and `eggMoves` entry is a `MOVES[...]` key with a `script_<Move>` spell
- [ ] Catch chance: `chance` chosen ([edit-catch-rate.md](edit-catch-rate.md)); `allowedBall` / `ignoreBallCounter` only if intended
- [ ] Evolution data: `evolutions` (at least `{}`); every target is a species with a monster
- [ ] TMs: `learnableTms` uses existing `TM_IDS.*` keys (or `true`)
- [ ] Abilities: `abilities` values match `POKEMON_ABILITIES`; Ride/Fly/Surf have outfit + speed entries
- [ ] Special abilities: `specialAbilities` uses `POKEMON_SPECIAL_ABILITY_IDS.*`
- [ ] Egg groups: `eggGroup` uses `POKEMON_EGG_GROUP_*`
- [ ] Egg: `eggId` item exists and `POKEMON_NAME_BY_EGG_ID[eggId] = "<Name>"`; `eggChance` set
- [ ] Egg moves: `eggMoves` only on the lowest form
- [ ] Spawn/quest availability: `map-spawn.xml` entry, a globalevent, or a quest/NPC reward
- [ ] Pokédex behaviour: register by use, `Pokedex status: [x/POKEMON_NUMBER]`, picture and family icons show
- [ ] Shiny (optional): `POKEMONS["Shiny <Name>"].portrait/fastcallPortrait` and a `Shiny <Name>` monster
- [ ] `tools/check_syntax.sh` clean; `python3 tools/check_references.py` shows no new REAL ERROR
- [ ] Startup: no `Unknown Pokemon Move`, no `loadFile` error, `>> Cristal server Online!`
- [ ] Summon test (`/mypokemon <Name>,20`, call, bar icon, portrait)
- [ ] Combat test (Tester: `m1` → "<Name>, Tackle!", damage line)
- [ ] Catch test ("Gotcha! You caught a …" / "Ouch! Your poke ball broke.")
- [ ] Level-up test ("Congratulations! Your <Name> advanced from level …", new move appears)
- [ ] Evolution test ([add-evolution.md](add-evolution.md))
