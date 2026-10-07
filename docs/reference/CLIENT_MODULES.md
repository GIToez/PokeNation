# PokeNation client modules (`client-pokenation/`)

How modules are loaded and switched off in the PokeNation client, and what each PokeNation
module does. The decision for every Redemption module is in
[`../REDEMPTION_MODULE_AUDIT.md`](../REDEMPTION_MODULE_AUDIT.md). The frozen legacy client
(`client/`) is not covered here.

## 1. Load order

`client-pokenation/init.lua`:

1. `g_modules.discoverModules()` finds every `*.otmod` under `modules/` and `mods/`.
2. The PokeNation module control (§2) marks modules disabled.
3. Library band: `autoLoadModules(99)`, then `corelib`, `gamelib`, `modulelib`, `startup`.
   `pokenation_lib` is in this band (autoload priority 90).
4. `autoLoadModules(999)`, `game_shaders`.
5. `client` and its `load-later` list (`modules/client/client.otmod`).
6. `game_interface` and its `load-later` list (`modules/game_interface/interface.otmod`), which
   holds every in-game module including the PokeNation ones.
7. `client_mods` and its `load-later` list (`mods/client_mods/mods.otmod`).

A sandboxed module only sees another module's globals at `init()` if it declares that module in
`dependencies:` (for example `game_hotkeys` and `game_actionbar` depend on `pokenation_lib`).

## 2. Profile-based module control

```lua
PokeNationConfig = {
    protocolProfile = "psoul312",
    buildProfile = os.getenv("POKENATION_PROFILE") or "production",
    disabledModules = { ... },   -- off in every profile
    developerModules = { ... },  -- off unless buildProfile == "development"
}
```

`init.lua` calls `g_modules.setModuleDisabled(name, true)` for each name before any module
loads. A disabled module is skipped by autoload, `ensureModuleLoaded`, `load-later` and as a
dependency; its files stay on disk. Start-up logs one line:

```
PokeNation build profile 'production', 28 module(s) disabled
```

| Profile | How to select | Loads |
|---|---|---|
| production | default | everything except `disabledModules` and `developerModules` |
| development | `POKENATION_PROFILE=development ./PokeNationClient` | also `client_debug_info`, `client_terminal`, `dev_otui`, `game_htmlsample` |

To disable a module: add its name to `disabledModules` with a comment saying why, then check
that no loaded module calls `modules.<name>.*` without a nil check (the audit lists the known
callers). To re-enable: remove the name and test the module's packets against the server.

`game_store` must stay disabled: its CipSoft store opcodes `0xFA`/`0xFB` are PSoul's poll request
and vote.

## 3. Extended opcodes used by the client

| Id | Name | Direction | Module |
|---:|---|---|---|
| 0 | Activate | S→C | C++ (enables sending, fires `g_game.onExtendedOpcodeEnabled`) |
| 1 | Locale | C→S | `client_locales` |
| 201 | POKENATION_SHOP | both | `game_shop` (`ExtendedIds.PokeNationShop`) |

No module sends an extended opcode on its own at login. The shop sends `fetch` only when its
window is opened ([`OPCODES.md`](OPCODES.md) §8.1).

## 4. PokeNation modules

| Module | Window / widget | Server input | Client output | Smoke check |
|---|---|---|---|---|
| `pokenation_lib` | — | — | `PokeNation.say`, `PokeNation.moveKey`, tables | used by all |
| `game_pokebar` | team bar under the map | `0xFF 0x04–0x08` | `/cp N` (summon / return), `/pd N` | team bar, summon, switch |
| `game_pokemoves` | move bar m1–m16 | `0xFF 0x01–0x03`, `0x09` | `mN`, `/sd <move icon id>` | move bar filled, cooldown, key census |
| `game_pokenation_hud` | vitals panel top-left of the map | stock stats (mana = energy, magic level = Pokémon level, soul = Respect, free cap = Balls) | — | screenshots |
| `game_statusbar` | status icons with countdown | `0xFF 0x0E–0x10` | — | potion icon drawn |
| `game_pokemondetails` | details window | `/pd` text reply | — | `/pd` window |
| `game_pokedex` | Pokédex | `0xFF 0x0A–0x0C`, `0x11` | `/dv <number>` | `/dv` entry |
| `game_tmchoose` | TM chooser | `0xFF 0x0D` | `/tc <move icon id>` | open, cancel |
| `game_advanceeffect` | level-up pop-ups in one stack over the map | `0xFF 0x19`, stock level / skill changes | — | pop-up drawn, 14-move grid |
| `game_effects` | creature colour effects | `0xFF 0x13` (U32 creature id, U8 effect id, U32 value) | — | fade-in, fade-out |
| `game_lootlist` | autoloot strip | `0xFF 0x1A` | — | strip filled |
| `game_poll` | poll window | `0xFF 0x18` | `0xFA` request, `0xFB` vote | choice and text vote |
| `game_shop` (repurposed) | PokeNation Shop | ext 201 `catalog`, `balance`, `history`, `msg` | ext 201 `fetch`, `purchase`, `history` | shop round trip |

### Move keys

`PokeNation.moveKey(i)` is `F1`…`F12` for moves 1–12 and `Shift+F1`…`Shift+F4` for 13–16.
`PokeNation.isMoveBarKey(combo)` is true for those 16 combos while the setting
`pokemoves-function-keys` is on (default). `game_hotkeys` and `game_actionbar` refuse them, so
one key never fires two actions. WASD walking is only bound with chat off, and the move bar
never binds letters.

### Level-up pop-ups

`game_advanceeffect` puts every pop-up in one vertical stack (`AdvanceStack`, 300 px wide,
anchored 40 px below the top of the map). A Pokémon level-up with up to two new moves shows
named rows; with more it shows "New Moves (n)" and a grid of 32×32 move icons with the move name
as tooltip. Fourteen moves fit in two rows; the move count is read as U16 (BUG-60).

## 5. Tests

`tools/pokenation_client_smoke.py` runs the real client under Xvfb with the test mod
`tools/pokenation_smoke/pn_smoke` (copied into the run directory, never packaged).
`tools/pokenation_gui_smoke_ci.sh` runs every scenario from `tools/pokenation_smoke/seed_smoke.sql`
and is what CI runs (job `gui-smoke`, artifact `PokeNation-Phase3-Screenshots`).
