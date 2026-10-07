# Redemption module audit — PokeNation client (`client-pokenation/`)

Every module directory of the PokeNation client (OTClient Redemption 4.1, internal version 854,
`psoul312` profile): the 88 directories under `modules/` and the 7 under `mods/`, 95 in total.
Each one has a single decision. The decision for a disabled module is applied in
`client-pokenation/init.lua` (`PokeNationConfig.disabledModules` / `developerModules`, see
[`reference/CLIENT_MODULES.md`](reference/CLIENT_MODULES.md)); no module files were deleted.

Decisions:

| Decision | Meaning | Count |
|---|---|---:|
| KEEP ACTIVE | Loads in every profile and is used (or inert and harmless) at 854 | 64 |
| REPURPOSE FOR POKENATION | Stock module rewritten for a PokeNation feature, keeps its name and load slot | 1 |
| REPLACE WITH POKENATION MODULE | Disabled; a PokeNation module does its job | 3 |
| KEEP BUT DISABLE FOR NOW | Disabled or never loaded; a later phase may adapt it | 9 |
| REMOVE FROM PRODUCTION LOAD | Disabled; Tibia 10.x–15.x system or automation with no PSoul counterpart | 13 |
| DEVELOPER ONLY | Loads only with `POKENATION_PROFILE=development` | 4 |
| UNKNOWN | Not loaded; usefulness not established | 1 |

The 64 KEEP ACTIVE modules include the 12 PokeNation modules ported from the legacy client
(§2). Production start-up logs `PokeNation build profile 'production', 28 module(s) disabled`
(24 disabled modules + 4 developer modules) and no warning or error line (CI artifact
`PokeNation-Phase3-Screenshots`, every scenario's `otclient.log`).

How a module is loaded: `init.lua` discovers all `*.otmod`, calls `g_modules.setModuleDisabled`
for the lists above, then loads the library band (autoload priority ≤ 99), `client` (its
`load-later` list), `game_interface` (its `load-later` list) and `client_mods` (the `mods/`
loader). A disabled module is skipped by autoload, `ensureModuleLoaded`, `load-later` and as a
dependency (`modulemanager.cpp`).

"Startup warnings" means lines the module itself logs during a production start and login at
854. "none" was checked in the GUI smoke logs; it does not mean the module has been exercised.

---

## 1. Stock Redemption modules

Abbreviations: LL-client = `client.otmod` load-later, LL-game = `game_interface.otmod`
load-later, lib = library band in `init.lua`.

| Module | Purpose | Autoload / load path | Packets / opcodes | PSoul support | Startup warnings | Useful assets | Possible PokeNation use | Decision |
|---|---|---|---|---|---|---|---|---|
| client | Main window, loads client_* | `ensureModuleLoaded` | none | n/a | none | — | base | KEEP ACTIVE |
| client_assets | Downloads missing Tibia assets over HTTP | dependency of client_entergame | HTTP only if `Services.clientAssets.enabled` (false) | n/a | none | — | none; inert | KEEP ACTIVE |
| client_background | Login background | LL-client | none | n/a | none | background art | PokeNation art later | KEEP ACTIVE |
| client_bottommenu | Login bottom bar (news, status) | LL-client | HTTP only with `Services.status` (unset) | n/a | none | news/event layout | server news | KEEP ACTIVE (client_entergame calls it unguarded) |
| client_debug_info | FPS / stats overlay | LL-client | none | n/a | none | — | debugging | DEVELOPER ONLY |
| client_entergame | Login, character list, enter game | LL-client | login `0x01`, game login | yes (PSoul charlist extras, poll flag, OS id, challenge) | none | — | login | KEEP ACTIVE |
| client_locales | Language selection | LL-client | ext opcode 1 Locale after ACTIVATE | yes (server sets `accounts.lang_id`) | none | — | en / pt / es | KEEP ACTIVE |
| client_options | Options window | LL-client | none (the legacy client's ext opcode 10 DashWalking toggle is not in Redemption) | n/a | none | — | options | KEEP ACTIVE |
| client_serverlist | Saved server list | LL-client | none | n/a | none | — | multi-server | KEEP ACTIVE |
| client_styles | Fonts and OTUI styles | LL-client | none | n/a | none | fonts, styles | base | KEEP ACTIVE |
| client_terminal | Lua terminal | LL-client | none | n/a | none | — | debugging | DEVELOPER ONLY |
| client_topmenu | Top menu bar | LL-client | none | n/a | none | toggle buttons | base | KEEP ACTIVE |
| corelib | Lua standard library (UI, json, HTTP, keyboard) | lib | none | n/a | none | — | base | KEEP ACTIVE |
| dev_otui | Live OTUI editor | autoload 9999 | none | n/a | none | — | UI work | DEVELOPER ONLY |
| game_actionbar | Spell / item action bars | LL-game | uses items/hotkeys (`0x82`, talk) | yes | none | action bar UI | items and orders on bars; move keys reserved (§3) | KEEP ACTIVE |
| game_analyser | Hunt / XP / loot analysers | autoload 9999 (needs game_cyclopedia) | party analyser packets (10.x+) | no | — | analyser windows | hunt analyser fed from PSoul loot/exp messages | KEEP BUT DISABLE FOR NOW |
| game_attachedeffects | Auras / wings data | LL-game | none | feature off at 854 | none | effect registry | Pokémon auras | KEEP ACTIVE (game_outfit calls it) |
| game_battle | Battle list | LL-game | attack / follow | yes | none | — | battle list | KEEP ACTIVE |
| game_blessing | Blessings dialog | LL-game | 10.x store packets | no | — | images | none | REMOVE FROM PRODUCTION LOAD |
| game_bugreport | Bug report (Ctrl+Z) | LL-game | stock bug report packet (user action) | not verified | none | — | bug reports | KEEP ACTIVE |
| game_console | Chat, channels | LL-game | talk, channels, `0xAB` (U16 count under the profile) | yes | none | — | chat, TV channel tab | KEEP ACTIVE |
| game_containers | Container windows | LL-game | container packets | yes | none | — | bags | KEEP ACTIVE |
| game_cooldown | Tibia spell cooldown icons | LL-game | receives 8.7+ cooldown packets | not sent at 854; inert | none | — | none (move cooldowns are in game_pokemoves) | KEEP ACTIVE |
| game_creatureinformation | Creature name / bar rendering | LL-game | none | yes | none | — | names, bars | KEEP ACTIVE |
| game_cyclopedia | Bestiary, bosstiary, houses (13+) | autoload 9999 + LL-game | 13.x packets | no | — | ~190 images, also referenced by other modules' paths | Pokédex replaces it; keep the images on disk | REPLACE WITH POKENATION MODULE (game_pokedex) |
| game_features | Protocol features per version + PokeNation profile | dependency of client_entergame | none | yes | none | — | profile | KEEP ACTIVE |
| game_forge | Exaltation forge (13+) | LL-game | forge packets | no | — | images | none | REMOVE FROM PRODUCTION LOAD |
| game_healthcircle | Health / mana arcs around the map | autoload 1000 + LL-game | none | yes | none | arc images | trainer HP / Pokémon energy | KEEP ACTIVE |
| game_healthinfo | HP / mana / condition panel | LL-game | none | yes | none | — | trainer vitals | KEEP ACTIVE |
| game_highscore | Highscore window (13.x packets) | LL-game | `requestHighscore` (13.x) | no packet; PSoul has a highscore system (`lib/ps/systems/011-highscore.lua`) | — | window | highscores over an extended opcode | KEEP BUT DISABLE FOR NOW |
| game_hotkeys | Hotkey manager | LL-game | talk / use | yes | none | — | hotkeys; move keys reserved (§3) | KEEP ACTIVE |
| game_htmlsample | HTML UI sample | none (manual) | none | n/a | none | — | reference | DEVELOPER ONLY |
| game_imbuementtracker | Imbuement durations (11+) | LL-game | auto request only ≥ 1100 | no | — | — | none | REMOVE FROM PRODUCTION LOAD |
| game_imbuing | Imbuing window | LL-game | imbuing packets | no | — | images | none | REMOVE FROM PRODUCTION LOAD |
| game_inspect | Inspection (12.8+) | LL-game | inspect packets | no | — | — | none | REMOVE FROM PRODUCTION LOAD |
| game_interface | In-game root UI, loads game_* | `ensureModuleLoaded` | look / use / move / attack | yes | none | — | base | KEEP ACTIVE |
| game_inventory | Equipment, fight modes | LL-game | inventory / fight modes | yes | none | slot art | trainer slots (Order, Dex, Badges) | KEEP ACTIVE |
| game_joystick | On-screen walk stick | LL-game | walk | yes | none | — | Android | KEEP ACTIVE |
| game_lootsplitter | Party loot splitter | autoload 9999 | none | no data source | — | — | party loot | KEEP BUT DISABLE FOR NOW |
| game_mainpanel | Right panel, toggle buttons, Store button | LL-game | none | yes | none | panel layout | hosts the PokeNation Shop button | KEEP ACTIVE |
| game_market | Market window | LL-game | `0xF4–0xF9` (PSoul 9.x backport) | yes; item list needs market data the 8.54 `.dat` lacks | none | market UI | player market | KEEP ACTIVE (UI PARTIAL, see matrix) |
| game_minimap | Minimap | LL-game | none | yes | none | — | minimap | KEEP ACTIVE |
| game_modaldialog | Server modal dialogs | LL-game | 9.7+ modal dialog | not sent | none | — | — | KEEP ACTIVE |
| game_notifications | Pop-up notifications | LL-game | none | yes | none | 31 images | notices | KEEP ACTIVE |
| game_npctrade | NPC trade window | LL-game | NPC trade | yes | none | — | shops | KEEP ACTIVE |
| game_outfit | Outfit dialog | LL-game | outfit | yes | none | — | outfits | KEEP ACTIVE |
| game_paperdolls | Paperdoll attachments | LL-game | none | feature off | — | — | Pokémon addons | KEEP BUT DISABLE FOR NOW |
| game_playerdeath | Death dialog | LL-game | none | yes | none | — | death | KEEP ACTIVE |
| game_playermount | Mount toggle | LL-game | mount (errors without GamePlayerMounts) | no (PSoul rides use orders) | — | — | ride / fly toggle | KEEP BUT DISABLE FOR NOW |
| game_playertrade | Player trade | LL-game | trade | yes | none | — | trade | KEEP ACTIVE |
| game_prey | Prey (11+) | LL-game | prey packets | no | — | — | none | REMOVE FROM PRODUCTION LOAD |
| game_proficiency | Weapon proficiency (15+) | autoload 1200 + LL-game | proficiency packets | no | — | images | none | REMOVE FROM PRODUCTION LOAD |
| game_questlog | Quest log | LL-game | `0xF0` / `0xF1` | yes | none | — | quests | KEEP ACTIVE |
| game_quickloot | Quick loot (12+) | LL-game | quick loot | no (PSoul autoloot is `0xFF 0x1A`, game_lootlist) | — | — | none | REMOVE FROM PRODUCTION LOAD |
| game_rewardwall | Daily reward wall (11.4+) | LL-game | reward packets | no | — | images | daily reward over an extended opcode | KEEP BUT DISABLE FOR NOW |
| game_ruleviolation | Rule violation report | LL-game | rule violation (user action) | not verified | none | — | reports | KEEP ACTIVE |
| game_shaders | Map shaders | `ensureModuleLoaded` + LL-game | none | n/a | none | shaders | effects | KEEP ACTIVE |
| game_shop | Was a 201 JSON shop with Tibia Coins and an automatic fetch at login | LL-game | ext opcode 201 POKENATION_SHOP, only when the window opens | yes (server `057-soulShop.lua`) | none | shop UI, category icons | PokeNation Shop (Soul Coins) | REPURPOSE FOR POKENATION |
| game_shortcuts | Mobile shortcut buttons | LL-game | none | yes | none | — | Android | KEEP ACTIVE |
| game_skills | Skills window | LL-game | none | yes (PSoul meanings shown by game_pokenation_hud) | none | — | skills | KEEP ACTIVE |
| game_spelllist | Spell list (8.70+) | LL-game | none | no spells at 854 | — | — | game_pokemoves shows moves | REPLACE WITH POKENATION MODULE (game_pokemoves) |
| game_stash | Supply stash (11.8+) | LL-game | stash packets | no | — | — | none | REMOVE FROM PRODUCTION LOAD |
| game_store | CipSoft store | LL-game | `0xFA`/`0xFB` store opcodes = PSoul poll request / vote | conflicts | — | store UI | PokeNation Shop replaces it | REPLACE WITH POKENATION MODULE (game_shop) |
| game_taskboard | Task / bounty board (15+) | autoload 9999 + LL-game | 15.x packets | no packet; PSoul has NPC tasks | — | images | task board over an extended opcode | KEEP BUT DISABLE FOR NOW |
| game_textmessage | Centre / status messages | LL-game | text messages | yes | none | — | messages | KEEP ACTIVE |
| game_textwindow | Text / list windows | LL-game | text window | yes | none | — | books, lists | KEEP ACTIVE |
| game_things | Loads `.dat` / `.spr` | dependency of client_entergame | none | yes (Stage A legacy assets) | none | — | assets | KEEP ACTIVE |
| game_tutorial | Vocation tutorial (15.2+) | LL-game | tutorial packets | no (legacy PSoul tutorial is ext opcodes 8/9, not ported) | — | images | none | REMOVE FROM PRODUCTION LOAD |
| game_unjustifiedpoints | Unjustified points (10.53+) | LL-game | none | no | — | — | none | KEEP BUT DISABLE FOR NOW |
| game_viplist | VIP list | LL-game | VIP packets | yes | none | — | friends | KEEP ACTIVE |
| game_walk | Keyboard walking | LL-game | walk | yes | none | — | walking (WASD only with chat off) | KEEP ACTIVE |
| game_wheel | Wheel of Destiny (13.1+) | LL-game | wheel packets | no | — | styles | none | REMOVE FROM PRODUCTION LOAD |
| gamelib | Game Lua API, protocol tables, PokeNation profile, poll senders | lib | `0xFA`/`0xFB` polls from Lua | yes | none | — | base | KEEP ACTIVE |
| modulelib | Controller helper | lib | none | n/a | none | — | base | KEEP ACTIVE |
| startup | Early window setup | lib | none | n/a | none | — | base | KEEP ACTIVE |
| updater | HTTP self-updater | only if `Services.updater` is set (unset) | HTTP | n/a | — | — | client patching later | KEEP BUT DISABLE FOR NOW |

## 2. PokeNation modules (ported from the legacy client)

| Module | Purpose | Autoload / load path | Packets / opcodes | PSoul support | Startup warnings | Decision |
|---|---|---|---|---|---|---|
| pokenation_lib | Shared constants, Pokémon / move / type tables, image paths, `PokeNation.say`, move-key helpers | autoload 90 (lib) | none | yes | none | KEEP ACTIVE |
| game_pokebar | Team bar | LL-game | receives `0xFF 0x04–0x08`; sends `/cp N`, `/pd N` | yes | none | KEEP ACTIVE |
| game_pokemoves | Move bar m1–m16, F1–F12 / Shift+F1–F4 | LL-game | receives `0xFF 0x01–0x03`, `0x09`; sends `mN`, `/sd` | yes | none | KEEP ACTIVE |
| game_pokenation_hud | Trainer HP, Pokémon energy, levels, Respect, Balls | LL-game | stock stats with PSoul meanings | yes | none | KEEP ACTIVE |
| game_statusbar | Status / potion icons with countdown | LL-game | receives `0xFF 0x0E–0x10` | yes | none | KEEP ACTIVE |
| game_pokemondetails | `/pd` details window | LL-game | parses the `/pd` text message | yes | none | KEEP ACTIVE |
| game_pokedex | Pokédex list and entry | LL-game | receives `0xFF 0x0A–0x0C`, `0x11`; sends `/dv` | yes | none | KEEP ACTIVE |
| game_tmchoose | TM move chooser | LL-game | receives `0xFF 0x0D`; sends `/tc` | yes | none | KEEP ACTIVE |
| game_advanceeffect | Trainer level, skill and Pokémon level-up pop-ups | LL-game | receives `0xFF 0x19`; stock level / skill events | yes | none | KEEP ACTIVE |
| game_effects | Creature colour effects (fade in / out, copy) | LL-game | receives `0xFF 0x13` | yes | none | KEEP ACTIVE |
| game_lootlist | Autoloot strip | LL-game | receives `0xFF 0x1A` | yes | none | KEEP ACTIVE |
| game_poll | Poll window (choice and free text) | LL-game | receives `0xFF 0x18`; sends `0xFA` / `0xFB` | yes | none | KEEP ACTIVE |

Legacy PSoul modules with no port yet: `game_badgecase`, `game_dollcase` (`0xFF 0x14/0x15` are
parsed and raise `onDollCaseStatus/Update`, nothing listens), `game_slotmachine` (`0xFF 0x16`,
`onSlotMachine`), `game_tips` (`0xFF 0x17`, `onTip`), `game_guide` (ext opcodes 8/9),
`game_duelmessage`, `game_time`, `game_environment`, the legacy `game_tutorial`. See
[`PHASE_3B_REPORT.md`](PHASE_3B_REPORT.md) "Next Phase".

## 3. `mods/`

`client_mods` is loaded by `init.lua` (`ensureModuleLoaded('client_mods')`) and load-laters
`client_profiles`, `game_buttons`, `game_itemselector`, `client_textedit`, `game_bot`.

| Module | Purpose | Autoload / load path | Packets / opcodes | PSoul support | Startup warnings | Possible PokeNation use | Decision |
|---|---|---|---|---|---|---|---|
| client_mods | Mod loader | `ensureModuleLoaded` | none | n/a | none | loader | KEEP ACTIVE |
| client_profiles | Per-profile settings directories | autoload + client_mods | none | n/a | none | settings | KEEP ACTIVE |
| client_textedit | Text editor window | client_mods | none | n/a | none | text input | KEEP ACTIVE |
| game_itemselector | Item picker (UIItem calls it when present) | client_mods | none | n/a | none | item selection | KEEP ACTIVE |
| game_bot | OTClientV8 bot (automation) | client_mods | anything a script sends | not allowed on PokeNation | — | none | REMOVE FROM PRODUCTION LOAD |
| game_buttons | Button window for the bot | client_mods | none | — | — | none | REMOVE FROM PRODUCTION LOAD |
| game_tasks | Task window on ext opcode 215 JSON | none (not in any load list, no autoload) | ext opcode 215 | no server handler | — | not checked against PSoul NPC tasks | UNKNOWN |

## 4. Key reservation (move bar versus hotkeys)

`game_pokemoves` owns F1–F12 and Shift+F1–Shift+F4 (`PokeNation.moveKey`). `game_hotkeys`
refuses to add or capture those combos and `game_actionbar` drops them from its CipSoft default
layout and its assignment dialogs, because corelib's `g_keyboard.unbindKeyDown(combo)` with a nil
callback removes every callback of the combo, including the move bar's. The GUI smoke checks
that the 16 move keys are bound only by `game_pokemoves` and WASD / arrows only by walking. The
setting `pokemoves-function-keys` (`PokeNation.MOVE_KEYS_SETTING`) turns the reservation off.

## 5. Repurpose candidates (disabled now)

| Module | Candidate use | What it needs |
|---|---|---|
| game_highscore | PokeNation highscores | server extended opcode that serves `011-highscore.lua` data |
| game_taskboard | Pokémon hunt tasks | server task data over an extended opcode; strip 15.x layout |
| game_rewardwall | Daily login reward | server reward state over an extended opcode |
| game_analyser | Hunt / exp analyser | client-side parsing of PSoul loot and exp messages |
| game_playermount | Ride / fly toggle | map to the PSoul order system |
| game_paperdolls | Pokémon addons | addon data per Pokémon |
| game_cyclopedia (images) | Pokédex art and icons | images only; the module stays disabled |
| updater | Client patching | an update server (`Services.updater`) |
