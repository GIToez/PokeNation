# Changes to OTClient Redemption in `client-pokenation/`

`client-pokenation/` is OTClient Redemption 4.1 (baseline in
[`REDEMPTION_BASELINE.md`](REDEMPTION_BASELINE.md)). This page lists **every** change made to the
stock tree, why, and the legacy-client behaviour each one reproduces. Anything not listed here is
stock Redemption. Packet layouts are in [`reference/OPCODES.md`](reference/OPCODES.md); the
legacy client in `client/` is the behavioural reference and is not modified.

Rule for new changes: PSoul-specific parsing is gated on the `GamePSoulProtocol` feature, so the
tree still behaves like stock Redemption when the profile is off, and the change is added to this
page in the same commit.

---

## 1. Protocol profile `psoul312`

The PSoul engine speaks the Tibia 8.54 game protocol with PSoul extensions and requires the number
**312** in both login packets (`server/src/resources.h`). Redemption rejects versions below 740 and
derives message modes and features from the version, so the client runs as **8.54 internally**
and writes 312 on the wire.

| Item | Value | Where |
|---|---|---|
| Selection | explicit: `PokeNationConfig.protocolProfile = "psoul312"` in `init.lua`. No version detection | `client-pokenation/init.lua` |
| Applied by | `PokeNationProtocol.apply(version)` at the end of `game_features` `onClientVersionChange` | `modules/gamelib/pokenation.lua`, `modules/game_features/features.lua` |
| Internal versions | client version 854, protocol version 854 (things, message modes, 8.54 feature set) | `Servers_init` entry `protocol = 854` |
| Wire version | `g_game.setWireProtocolVersion(312)`; written by the login-server packet (Lua) and the game login (C++) | `src/client/game.h`, `modules/gamelib/protocollogin.lua`, `src/client/protocolgamesend.cpp` |
| OS id | `g_game.setCustomOs`: `0x14` Windows, `0x15` Linux, `0x16` Mac, `0x17` Android (`g_platform.isMobile()`) | `pokenation.lua` `osId()`; server `enums.h` |
| RSA | OTServ key (`OTSERV_RSA`, same 309-digit modulus as the legacy client), forced by the profile | `pokenation.lua`, `modules/gamelib/const.lua` |
| Wrong version | the profile is not applied and a warning is logged when the selected client version is not 854 | `pokenation.lua` |

### 1.1 Features

Stock `game_features` enables the 8.54 set (`GameLooktypeU16`, `GameMessageStatements`,
`GameLoginPacketEncryption`, `GamePlayerAddons`, `GamePlayerStamina`, `GameNewFluids`,
`GameMessageLevel`, `GamePlayerStateU16`, `GameNewOutfitProtocol`, `GameWritableDate`,
`GameProtocolChecksum`, `GameAccountNames`, `GameDoubleFreeCapacity`, `GameChallengeOnLogin`,
`GameMessageSizeCheck`, `GameTileAddThingWithStackpos`, `GameCreatureEmblems`, plus
`GameSoul`, `GameLevelU16`, `GameAllowPreWalk`, `GameMapCache`). These match the legacy client's
reads at 8.54 (legacy `game.cpp:1465-1506`, `protocolgame.cpp:59` first-message size check,
`protocolgameparse.cpp:691` tile stack position). The profile changes:

| Feature | Profile | Reason / legacy reference |
|---|---|---|
| `GamePSoulProtocol` (new, id 137) | on | gates every PSoul read below |
| `GameMagicEffectU16` | on | server writes `U16` effect ids (`AddMagicEffect`); legacy forces it in `protocollogin.lua:29` |
| `GameCreatureIcons` | on | server writes `U8 icon` for OTClient OS ids; legacy `protocollogin.lua:30` |
| `GameSpritesU32` | on | legacy `data.otfi` `extended: true`; legacy `things.lua` forces it |
| `GameSpritesAlphaChannel` | on | legacy `data.otfi` `transparency: true`; legacy `protocollogin.lua:31` |
| `GamePlayerMarket` | on | backported 9.x market (§4); legacy `protocollogin.lua:32` |
| `GameChargeableItems` | on | legacy enables it for 780–854 |
| `GameBlueNpcNameColor`, `GameDiagonalAnimatedText` | on | legacy enables them always (display only) |
| `GameFormatCreatureName` | **off** | legacy has it commented out; Pokémon names (`"Rattata [3]"`) stay as the server sends them |

## 2. Login

| Step | Change | Files |
|---|---|---|
| Login packet | `U16 os` (PokeNation id), `U16 312`; **no language byte** (the server reads it only for the legacy OS ids `0x0A..0x0C`, BUG-09) | `protocollogin.lua` |
| Character list `0x64` | per character, under `GamePSoulProtocol`: `U16 level, U8 vocation, U16 looktype, 4×U8 colours, U8 addons, U8 n × (U16 number, string description)` into `character.level`, `.vocation`, `.outfit`, `.pokemonTeam` (the legacy field names) | `protocollogin.lua` `parseCharacterList` |
| Poll flag | `U8` after the premium days into `account.hasPoll`, and `g_game.onPollAvailable(bool)` (legacy: `game_poll.doPreparePollIconShow`) | `protocollogin.lua` |
| Game login challenge | stock Redemption echo (`U32 timestamp, U8 random`); the server validates it since BUG-68 | stock |
| Self login `0x0A` | reads the PSoul `U16` light hour after `canReportBugs` and fires `g_game.onLightHour(minutes)` after `processLogin` (legacy `protocolgameparse.cpp:482-499`) | `src/client/protocolgameparse.cpp` `parseLogin` |

## 3. Game packets

| Packet | Change | Files |
|---|---|---|
| Creature (`0x61`/`0x62`) | after `unpass`: `U8 localPlayerSummon`, `U8 attackable`; stored on the creature, Lua `Creature:isLocalPlayerSummon()` / `isAttackable()` (legacy names) | `protocolgameparse.cpp` `getCreature`, `creature.h`, `luafunctions.cpp` |
| `0xAB` channel list | `U16` count | `protocolgameparse.cpp` `parseChannelList` |
| `0x83` magic effect | stock `GameMagicEffectU16` path (`U16`), enabled by the profile | stock |
| `0x85`, `0x86`, `0xDD` | stock 8.54 paths match the server (`U8` missile, `U32 id + U8 colour` square, position + `U8` + string mark) | stock |
| `0xFF` PSoul family | new dispatcher `ProtocolGame::parsePSoulMessage`, sub-opcodes 1–26, same payloads and the same `g_game` Lua events as the legacy client (table in OPCODES.md §5). Differences: the `U16` counts of `0x14` and `0x19` are read as `U16` (the legacy client truncates them to `uint8_t`, OPCODES.md §5); an unknown sub-opcode throws, so the parse error is logged with the packet dump instead of desynchronising silently | `src/client/protocolgameparsepsoul.cpp` (new), `protocolcodes.h`, `protocolgame.h`, `CMakeLists.txt`, `vc18/otclient.vcxproj` |
| `0x12` jump / `0x13` creature effect | `creature->jump(20, 450)` / creature Lua `onEffect(effectId, var)` as in the legacy client | `protocolgameparsepsoul.cpp` |
| `0xF6` market enter | under the profile `parsePSoulMarketEnter`: `U64 balance, U8 offerCount, U16 n, n×(U16 itemId, U16 count)` as the server writes it (stock `parseMarketEnterOld` reads `U32 balance + U8 vocation` below version 981/950, which would desync); vocation passed to Lua is the local player's | `protocolgameparsepsoul.cpp`, `protocolgameparse.cpp` dispatch |
| `0xF7` market leave | stock had no handler (marked unused); now an empty packet that fires `g_game.onMarketLeave`, for every version (Tibia 9.x semantics). The PSoul server sends it when a non-premium player creates an offer on a premium-only market | `protocolgameparsepsoul.cpp` `parseMarketLeave` |
| C→S `0xF6` create offer | under the profile the price is written as `U32` (server `parseMarketCreateOffer`), clamped; stock writes `U64` | `protocolgamesend.cpp` `sendMarketCreateOffer` |
| `0xF8` detail, `0xF9` browse, C→S `0xF4`/`0xF5`/`0xF7`/`0xF8` | stock paths at 854 already match the server (15 attribute strings, `U32` statistics, `U16` browse var, `U32` prices) | stock |
| C→S `0xFA` poll request, `0xFB` poll vote (`U8 optionId` or `string text`) | written in Lua with `OutputMessage` + `ProtocolGame:send`, exposed as `g_game.requestPollWindow()`, `g_game.doPollVote(id)`, `g_game.doPollVoteText(text)` (the legacy C++ binding names, so the legacy `game_poll` module can be ported unchanged). Only sent while the profile is active; the option id is range-checked | `modules/gamelib/pokenation.lua` |

## 4. Extended opcodes

| Id | Change | Files |
|---|---|---|
| 0 ACTIVATE | stock enables sending; additionally fires `g_game.onExtendedOpcodeEnabled()`. The PSoul server sends ACTIVATE after the map description, i.e. after `onGameStart`, so anything that sends `0x32` at game start must wait for this event | `protocolgameparse.cpp` `parseExtendedOpcode`; `ProtocolGame:isExtendedOpcodeEnabled()` binding in `protocolgame.h`, `luafunctions.cpp` |
| 1 LOCALE | under the profile the payload is the numeric server language (`"0"` en, `"1"` pt, `"2"` es; any other locale sends `"0"`), sent on `onExtendedOpcodeEnabled` and on every locale change. Stock sends the locale name at `onGameStart` | `modules/client_locales/locales.lua`, `PokeNationProtocol.serverLanguageId` |
| 201 POKENATION_SHOP | `ExtendedIds.PokeNationShop = 201`. Stock `game_shop` sent its catalog request on `onGameStart`, before ACTIVATE ("extended opcodes are not enabled" in the log); it now sends `fetch` only when the window is opened. JSON layout in OPCODES.md §8.1 | `modules/gamelib/const.lua`, `modules/game_shop/` (§7) |

Difference to the legacy client: the legacy locale files map `de`, `pl` and `sv` to id 2, which
the server treats as Spanish. The new client sends English for them.

Old flow (legacy, OS `0x0A..0x0C`): language byte in the login-server packet → `accounts.lang_id`.
New flow (OS `0x14..0x17`): no byte at login; after game login the server sends ACTIVATE, the
client answers `0x32` id 1 with `"0".."2"` → `player->setLanguage` + `accounts.lang_id`
(`server/src/game.cpp` `parsePlayerExtendedOpcode`). Server validation is BUG-08.

## 5. Assets (Stage A)

The legacy `client/data/things/data.dat` and `data.spr` are used unchanged as
`client-pokenation/data/things/854/Tibia.dat` / `Tibia.spr` (stock Redemption file names).
`tools/stage_pokenation_assets.py` copies them (or hard-links with `--link`); the directory is
git-ignored. CI pulls only the `data.spr` LFS object (cached) and stages before packaging.

The same script stages the legacy PSoul UI images and sounds (`client/data/images`,
`client/data/sounds`) into `client-pokenation/data/images/psoul/` and `data/sounds/psoul/`
(git-ignored, packaged). The Pokémon modules load them through `PokeNation.image(path)`, which
prefixes `/images/psoul/`.

Not carried over yet: the legacy `things.otml` per-thing opacity table (creatures, effects,
missiles, items at 0.7–0.9). Redemption has no equivalent loader; tracked as a UI parity item.

## 6. Configuration (`init.lua`) and module control

| Item | Change |
|---|---|
| `Services.clientAssets.enabled` | `false`: never download CipSoft assets from GitHub `dudantas/tibia-client` |
| `Servers_init` | single local entry `127.0.0.1:7564`, `protocol = 854`, no HTTP login, no authenticator (the login screen then shows a fixed server) |
| `PokeNationConfig.protocolProfile` | `"psoul312"` |
| `PokeNationConfig.buildProfile` | `"production"` unless the environment variable `POKENATION_PROFILE=development` is set |
| `PokeNationConfig.disabledModules` | 24 Redemption modules the PSoul 8.54 server has no counterpart for (CipSoft store, prey, imbuing, forge, wheel, cyclopedia, …, the bundled bot). Off in every profile |
| `PokeNationConfig.developerModules` | `client_debug_info`, `client_terminal`, `dev_otui`, `game_htmlsample`; off unless the build profile is `development` |

`init.lua` applies the two lists with `g_modules.setModuleDisabled(name, true)` right after
`discoverModules()` and logs `PokeNation build profile 'production', 28 module(s) disabled`.
The decision for every module is in [`REDEMPTION_MODULE_AUDIT.md`](REDEMPTION_MODULE_AUDIT.md);
how to add or remove one is in [`reference/CLIENT_MODULES.md`](reference/CLIENT_MODULES.md) §2.

| Framework change | Why | Files |
|---|---|---|
| `ModuleManager::setModuleDisabled / isModuleDisabled / getDisabledModules` (Lua `g_modules.*`) | a disabled module must stay unloaded on every path (autoload, `ensureModuleLoaded`, `load-later`, dependency) without deleting or editing its `.otmod`; the set survives rediscovery | `src/framework/core/modulemanager.{h,cpp}`, `src/framework/luafunctions.cpp` |
| `Module::load` returns early for a disabled module | single check point for all load paths | `src/framework/core/module.cpp` |
| Lua `Module:isEnabled()` binding | lets tests and tools tell "disabled" from "failed to load" | `src/framework/luafunctions.cpp` |
| `mainpanel.lua` `toggleStore` | nil-checks `modules.game_store` / `modules.game_shop` (the store is disabled); tooltip "PokeNation Shop" (the word "Store" is part of the button image `images/options/store_large.png`, not yet replaced) | `modules/game_mainpanel/mainpanel.lua` |

## 7. Pokémon UI and repurposed stock modules

New modules (ported from the legacy client; reference: [`reference/CLIENT_MODULES.md`](reference/CLIENT_MODULES.md) §4):
`pokenation_lib` (library band, priority 90), `game_pokenation_hud`, `game_pokebar`,
`game_pokemoves`, `game_statusbar`, `game_pokemondetails`, `game_pokedex`, `game_tmchoose`,
`game_advanceeffect`, `game_effects`, `game_lootlist`, `game_poll`. They are added to the
`load-later` list of `modules/game_interface/interface.otmod`; that list entry is the only edit
to the stock interface module. Layout uses anchors and reusable widgets (no absolute screen
positions), so the windows follow the map panel on any resolution, Android included.

Behaviour that is specific to the PokeNation port:

| Module | Behaviour | Reason |
|---|---|---|
| `game_pokemoves` | move keys `F1`–`F12`, `Shift+F1`–`Shift+F4` only; no letter keys | Redemption binds WASD walking when chat is off; letters would fire both |
| `game_statusbar` | one 38 px row of 36 px slots anchored to the top-right corner of the map panel | follows the map on any resolution instead of a fixed position |
| `game_advanceeffect` | all level-up pop-ups in one vertical stack; more than two new moves shown as an icon grid; move count read as U16 | pop-ups no longer overlap, and a 14-move level-up fits (BUG-60) |
| `game_pokebar` | fainted portraits at 35 % opacity; the summoned slot is highlighted, and clicking it returns the Pokémon by using the ball in the feet slot (server `PLAYER_SLOT_BALL`) | `/cp N` on the summoned slot makes the server return and re-call it |
| Window modules (`game_pokedex`, `game_pokemondetails`, `game_tmchoose`, `game_poll`, `game_advanceeffect`) | titles and headings in `terminus-14px-bold` | one heading font across the Pokémon windows |

Stock modules changed for PokeNation:

| Module | Change | Files |
|---|---|---|
| `game_hotkeys` | `addKeyCombo` and the capture dialog refuse the 16 move-bar keys (`PokeNation.isMoveBarKey`); depends on `pokenation_lib` | `hotkeys_manager.lua`, `hotkeys_manager.otmod` |
| `game_actionbar` | assignment dialogs and `isHotkeyConflicting` refuse the move-bar keys; depends on `pokenation_lib` | `logics/ActionHotkeys.lua`, `logics/ApiJson.lua`, `game_actionbar.otmod` |
| `game_shop` | repurposed as the **PokeNation Shop** on extended opcode 201: catalog, prices and balance come from the server; the client sends only action, product id and quantity; Tibia products, gift / coin transfer and name-change windows and the bundled `serverSIDE/` scripts removed. Rules: [`reference/SOUL_COINS.md`](reference/SOUL_COINS.md) | `modules/game_shop/` |
| `game_market` | `onMarketEnter` stores the `0xF6` balance with `setResourceBalance(BANK_BALANCE, …)` before showing the window; pre-10.x servers send no resource-balance packet, so the window showed 0 | `modules/game_market/t_market.lua` |

## 8. Verification

`tools/pokenation_client_smoke.py` logs the built client into the local server under Xvfb through
the normal login UI (mod `tools/pokenation_smoke/pn_smoke`, copied into a temporary run directory,
never packaged). `tools/pokenation_gui_smoke_ci.sh` runs every scenario (default, shop, Pokémon,
market, TV record + watch) from a fresh seed; CI job `gui-smoke` in
`.github/workflows/pokenation-client.yml` runs it against a real server and uploads the
screenshots and logs as `PokeNation-Phase3-Screenshots`. Results are in
[`PHASE_3_TEST_MATRIX.md`](PHASE_3_TEST_MATRIX.md) (rows C-xx packets, U-xx UI).

## 9. Known gaps (next steps)

| Gap | Status |
|---|---|
| Market item list | window opens and shows the `0xF6` balance (U-11); the item list is empty because 8.54 `.dat` files have no market attribute (BUG-78, the legacy client has the same limit). The Tibia-coin "Get" button is still shown |
| TV viewer | works end to end (U-12); the viewer sees the recorder twice and logs "invalid stackpos" on join and leave (BUG-77, server `sendTVStart`) |
| Status bar | the Redemption top status bar shows 9999999999 in its right gauge for a character without a Pokémon (BUG-79) |
| Legacy modules not ported | `game_badgecase`, `game_dollcase` (`0xFF 0x14/0x15`), `game_slotmachine` (`0x16`), `game_tips` (`0x17`), `game_guide` (ext 8/9), `game_duelmessage`, `game_time`, `game_environment`, legacy `game_tutorial`. The C++ parser already fires the events for 0x14–0x17 |
| `things.otml` opacity table | not loaded (§5) |
| Account Manager character entry without PSoul extras (server, OPCODES.md §2.2) | latent, `accountManager = false` |
