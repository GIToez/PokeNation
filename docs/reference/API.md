# PokeNation client Lua API (`client-pokenation/`)

The Lua functions and events the PokeNation client adds on top of stock OTClient Redemption
4.1. Wire formats are in [`OPCODES.md`](OPCODES.md); module roles in
[`CLIENT_MODULES.md`](CLIENT_MODULES.md). Server Lua is documented with the systems that use it
(for example [`SOUL_COINS.md`](SOUL_COINS.md)).

## 1. `g_game` events raised by the PSoul parser

Connect with `connect(g_game, { onPokemonMoves = fn, ... })`. Raised from
`src/client/protocolgameparsepsoul.cpp`.

| Event | Arguments | Sub-opcode |
|---|---|---|
| `onPokemonMoves` | `iconItemId, moves` (list of move icon ids) | `0xFF 0x01` |
| `onMoveBarClose` / `onMoveBarOpen` | — | `0x02` / `0x03` |
| `onPokemonBarAdd` | `itemId, fastcall, textColor, text` | `0x04` |
| `onPokemonBarRemove` | `fastcall` | `0x05` |
| `onPokemonBarUpdate` | `fastcall, textColor, text` | `0x06` |
| `onPokemonBarOpen` / `onPokemonBarClose` | — | `0x07` / `0x08` (`0x03` also opens) |
| `onPokemonMoveCooldown` | `moveIconId, seconds` | `0x09` |
| `onPokedexStatus` | list of status bytes | `0x0A` |
| `onPokedexOpen` | — | `0x0B` |
| `onPokedexUpdate` | `number, status` | `0x0C` |
| `onTmChoose` | `tmMoveItemId, moves` | `0x0D` |
| `onStatusBarAdd` / `onStatusBarRemove` / `onStatusBarClear` | `itemId, seconds` / `itemId` / — | `0x0E` / `0x0F` / `0x10` |
| `onPokedexInfo` | `number, details, moves, effectiveness, families` | `0x11` |
| creature `onEffect` (via `game_effects`) | `effectId, value` | `0x13` |
| `onDollCaseStatus` / `onDollCaseUpdate` | list / `number, status` | `0x14` / `0x15` (no listener yet) |
| `onSlotMachine` | `reel1, reel2, reel3` | `0x16` (no listener yet) |
| `onTip` | `tipId` | `0x17` (no listener yet) |
| `onPollWindow` | `question, options` (map option id → text) or `question, true` for a free-text poll | `0x18` |
| `onPokemonLevelUp` | `number, level, newMoves` (list of move icon ids) | `0x19` |
| `onLootList` | map `clientItemId → count` | `0x1A` |
| `onLightHour` | `hour` | self-login light byte |
| `onExtendedOpcodeEnabled` | — | ext opcode 0 ACTIVATE |
| `onMarketEnter` | `items, offerCount, balance, vocation` | `0xF6` (PSoul `U64` balance) |

`0xFF 0x12` (creature jump) is handled in C++ and raises no event.

## 2. `g_game` functions added in Lua (`modules/gamelib/pokenation.lua`)

| Function | Sends |
|---|---|
| `g_game.requestPollWindow()` | `0xFA` |
| `g_game.doPollVote(optionId)` | `0xFB` with an option id (U8) |
| `g_game.doPollVoteText(text)` | `0xFB` with free text |

## 3. `PokeNationProtocol` (`modules/gamelib/pokenation.lua`)

| Function | Returns |
|---|---|
| `isSelected()` | `PokeNationConfig.protocolProfile == "psoul312"` |
| `isActive()` | the `GamePSoulProtocol` feature is on (set by `apply` for 854 when the profile is selected) |
| `osId()` | the PokeNation OS id sent at login (`0x14`–`0x17` by platform) |
| `serverLanguageId(locale)` | `0` en, `1` pt, `2` es, for ext opcode 1 |
| `apply(version)` | enables the profile's features (`GamePSoulProtocol`, `GamePlayerMarket`, …) |

## 4. `PokeNation` helpers (`modules/pokenation_lib/`)

| Function / value | Meaning |
|---|---|
| `PokeNation.say(text)` | says a hidden PSoul talk command such as `/cp 1` or `m3` (default channel); false when offline |
| `PokeNation.moveKey(i)` | key combo of move *i*: `F1`…`F12`, then `Shift+F1`…`Shift+F4` |
| `PokeNation.moveKeysEnabled()` | the setting `PokeNation.MOVE_KEYS_SETTING` (`pokemoves-function-keys`), default on |
| `PokeNation.isMoveBarKey(combo)` | true if `combo` is one of the 16 move keys and they are enabled |
| `PokeNation.image(path)` | `/images/psoul/<path>` (legacy PSoul images staged into the client) |
| `PokeNation.loadWidgetPosition(widget, key)` | restores a saved widget position |

Tables: `pokenation_lib/pokemon.lua`, `moves.lua`, `types.lua`, `const.lua` (for example
`getPokemonNameByNumber`, `getMoveNameByIconItemId`).

## 5. Module functions

Public functions of the PokeNation modules (`modules.<name>.<function>`). The `get*` functions
are read-only state for tests (the GUI smoke uses them) and for other modules.

| Module | Actions | State |
|---|---|---|
| `game_pokebar` | `summon(fastcall)`, `returnPokemon()`, `toggle(fastcall)`, `requestDetails(fastcall)`, `switchOrientation()` | `getSlots()`, `getInUse()`, `getWidget()` |
| `game_pokemoves` | `useMove(index)`, `requestDetails(index)`, `switchOrientation()` | `getMoves()`, `isActive()`, `getWidget()` |
| `game_pokedex` | `show()`, `hide()` | `getState()`, `getWindow()` |
| `game_pokemondetails` | `request(fastcall, itemId, name)` | `getLast()`, `getWindow()` |
| `game_tmchoose` | `confirm()`, `cancel()` | `getState()`, `getWindow()` |
| `game_statusbar` | — | `getStatuses()`, `getWidget()` |
| `game_advanceeffect` | — | `getLastPokemonLevelUp()`, `getPopup(kind)` (`'level'`, `'skill'`, `'pokemon'`) |
| `game_effects` | — | `getReceived(effectId)`, `getEffectIds()` (counts since login) |
| `game_lootlist` | — | `getState()` |
| `game_poll` | `vote()`, `cancel()`, `selectOptionById(id)`, `setText(text)` | `getState()`, `getWindow()` |
| `game_shop` | `show()`, `hide()`, `toggle()`, `purchase(productId, quantity)`, `requestHistory()`, `selectOfferById(id)` | `getState()` (`visible`, `catalogLoaded`, `balance`, `offerCount`, `selectedOffer`, `historyCount`, `lastMessage`), `getWindow()` |

`game_shop.purchase` sends only the product id and quantity; the server decides the price.

## 6. Extended ids (`modules/gamelib/const.lua`)

`ExtendedIds.Activate = 0`, `ExtendedIds.Locale = 1`, `ExtendedIds.PokeNationShop = 201`.
