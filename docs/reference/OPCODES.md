# Protocol reference — PokeNation (PSoul / PokeAimar on TFS 0.3.6, OTClient 0.6 fork)

Every entry gives direction, opcode, payload, the server sender/parser and the client
parser/sender with `file:line`, and whether the packet was seen working in the graphical client
(test **P2-34** / **P2-33** in [`../PHASE_2_TEST_MATRIX.md`](../PHASE_2_TEST_MATRIX.md)).
Line numbers are against the current working tree and were re-read for this document; where they
differ from [`../SOURCE_AUDIT.md`](../SOURCE_AUDIT.md) §2 the correction is listed in §9.

Paths: `server/src/…` is the server, `client/src-cpp/src/client/…` the client C++ (a second,
unused copy exists under `client/src-cpp/vc12/`), `client/modules/…` the client Lua.
Byte types: `U8/U16/U32/U64` little-endian, `string` = `U16 length + bytes`.

"GUI" column: **yes** = rendered without desync in P2-33/P2-34; **wire** = decoded by
`tools/protocol_probe.py` only; **no** = never exercised (source reading only).

Related: system inventory [`../FULL_SOURCE_AUDIT.md`](../FULL_SOURCE_AUDIT.md), feature list
[`FEATURES.md`](FEATURES.md).

---

## 1. Transport and gating

| Item | Value | Evidence |
|---|---|---|
| Frame | `U16 len, U32 adler32, payload`; after login XTEA (32 rounds) | `server/src/protocol.cpp`, `client/src-cpp/src/framework/net/protocol.cpp` |
| RSA | OTServ 1024-bit key, `e = 65537` | `server/src/otserv.cpp:648-651`, `client/modules/gamelib/const.lua` (`OTSERV_RSA`) |
| Protocol version | `CLIENT_VERSION_MIN = MAX = 312` (8.54 packet shapes) | `server/src/resources.h`; client sends 312 at `client/modules/gamelib/protocollogin.lua:38` |
| OTClient OS ids | legacy client: `0x0A` Windows, `0x0B` Linux, `0x0C` Mac. PokeNation client (Phase 3): `0x14` Windows, `0x15` Linux, `0x16` Mac, `0x17` Android | `server/src/enums.h` (`isLegacyOtclientOs`, `isPokeNationClientOs`, `isOtclientOs`) |
| Gate | most PSoul extensions are sent only when `player->isUsingOtclient()` (OS in `0x0A..0x0C` or `0x14..0x17`); 14 call sites in `server/src/*.cpp` | e.g. `protocolgame.cpp:2794`, `:4307`, `:4313`, `:1837` |
| Client features forced | `GameMagicEffectU16`, `GameCreatureIcons`, `GameSpritesAlphaChannel`, `GamePlayerMarket` | `client/modules/gamelib/protocollogin.lua:29-32` |
| PokeNation client profile | explicit `psoul312` profile: internal client version 854, wire version 312, OS `0x14..0x17`, OTServ RSA, feature `GamePSoulProtocol` (137) plus the features above; no version detection | `client-pokenation/modules/gamelib/pokenation.lua`; see §10 |
| Status protocol `0xFF` (service) | not registered (`otserv.cpp:877` commented) | SOURCE_AUDIT §2.1 (re-confirmed) |

---

## 2. Login server (`protocollogin.cpp` ↔ `gamelib/protocollogin.lua`)

### 2.1 C→S `0x01` enter account

| Field | Server read | Client write |
|---|---|---|
| `U8 0x01` | — | `protocollogin.lua:36` |
| `U16 os` | `protocollogin.cpp:83` | `:37` |
| `U16 version` (312) | `:84`; checked at `:116` | `:38` |
| **custom `U8 language`** (only legacy OS ids `0x0A..0x0C` and version ≥ 293; never sent by the PokeNation client) | `protocollogin.cpp:86-93` | `:39` (`client_locales.getCurrentLocale().id`) |
| `U32 dat, U32 spr, U32 pic` signatures | skipped `:91` (`SkipBytes(12)`) | `:45-47` |
| RSA block: `U8 0`, `4×U32 xtea` | `:92-101` | `:55-64` |
| `string account`, `string password` | `:103` | `:67-73` (account names feature) |
| extended login data string (optional) | not read | `:75-78` |

Language handling: stored into `accounts.lang_id` when it differs; values above `LANG_LAST` (2)
are ignored (BUG-08, fixed). The PokeNation client (OS `0x14..0x17`) sends the stock 8.54 packet
without this byte and reports its language after the game login with extended opcode 1 (§8,
BUG-09, fixed). The charlist extras and the poll byte below are sent to both client families.
GUI: **yes** (P2-01, P2-33).

### 2.2 S→C responses

| Opcode | Payload | Server | Client | GUI |
|---|---|---|---|---|
| `0x0A` | `string error` | `protocollogin.cpp:62-63` (`disconnectClient`) | `protocollogin.lua:128` | yes (wrong password) |
| `0x14` | `string "motdId\nmotd"` | `:209-213` | `:133` | yes |
| `0x64` | character list, see below | `:226-298` | `:166-199` | yes |

`0x64` layout:

```
U8  count                                  protocollogin.cpp:229 / :236   lua:166
per character:
  string name, string world (or "Online"/"Offline" if onOrOffCharlist), U32 ip, U16 port   :241-253   lua:169-172
  -- custom, OTClient OS only (protocollogin.cpp:263-287):
  U16 level, U8 vocation,                                                  :265-266   lua:173-174
  U16 lookType, U8 head, U8 body, U8 legs, U8 feet, U8 addons,             :275-280   lua:176-181
  U8 pokemonCount, pokemonCount × (U16 number, string description)         :282-286   lua:183-186
U16 premiumDays (65535 = free premium)                                    :290-294   lua:197
-- custom, OTClient OS only:
U8 pollAvailable                                                          :296-298   lua:199 (game_poll.doPreparePollIconShow)
```

**Defect (new):** when `accountManager = true` the "Account Manager" row is written at
`protocollogin.cpp:227-234` *without* the custom OTC fields, while the client always reads them
(`protocollogin.lua:173-186`) → character list desync. Latent: `accountManager = false`
(`config.example.lua:4`).

---

## 3. Game server login

| Step | Dir | Payload | Server | Client | GUI |
|---|---|---|---|---|---|
| challenge `0x1F` | S→C (unencrypted) | `U32 timestamp` (random 0..0xFFFF), `U8 random` (the same bytes as before Phase 3: `U16 rand, U16 0, U8 rand`) | `protocolgame.cpp` `onConnect`, values kept in `m_challengeTimestamp` / `m_challengeRandom` | stock `parseChallenge` | yes |
| enter game `0x0A` | C→S | `U16 os, U16 312`, RSA: `U8 0, 4×U32 xtea, U8 gamemaster, string account, string character, string password`, then challenge `U32 + U8` (client) | `parseFirstPacket` `protocolgame.cpp`; since Phase 3 the echoed challenge must equal the sent one, otherwise `login challenge mismatch` is logged and the connection closed (BUG-68) | `protocolgamesend.cpp:51-112` | yes |
| self login `0x0A` | S→C | `U32 playerId, U16 0x32 (beat), U8 canReportBugs`, **custom `U16 realLightHour` (OTC only)** | `protocolgame.cpp:2790-2796` | `protocolgameparse.cpp:482-499` (always reads `lightHour`, forwards to `g_game.onLightHour` → `game_time/time.lua:87`) | yes |
| error `0x14` | S→C | `string` | `disconnectClient` | stock | yes |

Language of the game session comes from `accounts.lang_id` (`protocolgame.cpp:294`), passed
through `Localization::sanitize`. Right after login the server sends extended opcode 0
(ACTIVATE, empty payload) to every OTClient-family client, which enables the client's `0x32`
sending (Redemption gates it on this).
The server also registers a creature event named `"ExtendedOpcode"` at login
(`protocolgame.cpp:302-304`) that no XML defines (BUG-38).

---

## 4. Game packets changed versus stock 8.54

### 4.1 Server → client

| Opcode | Change | Server | Client | GUI |
|---|---|---|---|---|
| `0x61`/`0x62` creature (inside `0x6A`, map, `0x6B`) | after stock fields (id, name, health %, dir, outfit, light, `U16` speed, skull, shield, `U8` emblem when unknown) PSoul appends: **`U8 icon` (OTC)**, `U8 impassable`, **`U8 isMySummon` (OTC)**, **`U8 canDoCombat` (OTC)** | `AddCreature` `protocolgame.cpp:4267-4318` (extras `:4307-4317`) | `getCreature` `protocolgameparse.cpp:2243-2370` (extras `:2325-2346`) | yes |
| creature name | monsters: `"Nickname [level]"`, empty if hidden; players: nickname or empty | `protocolgame.cpp:4275-4283` | stock | yes ("Rattata [3]") |
| `0x83` magic effect | effect id **`U16`** (`type + 1`) instead of `U8` | `AddMagicEffect` `protocolgame.cpp:4251-4256` | `parseMagicEffect` `protocolgameparse.cpp:941-950` (`GameMagicEffectU16`) | yes |
| `0x85` distance effect | unchanged `U8` | `:4258-4265` | stock | yes |
| `0xAB` channel list | count **`U16`** (stock `U8`), entries `U16 id, string name` | `sendChannelsDialog` `:2082-2103`; PS variant with explicit ids `:2105-2134`; TV list `sendTVChannelsDialog` `:2136-2168` (`CHANNEL_TV` placeholder entry when empty) | `parseChannelList` `protocolgameparse.cpp:1383-1394` (reads `U16`) | yes (channel list), TV list no |
| `0xF1` quest line | additional `sendCustomQuestInfo` variant: `U16 questId, U8 n, n×(string name, string description)` (same shape as stock `0xF1` at `:4165`) | `:4750-4765` | stock `parseQuestLine` | no |
| `0x1E` ping | sent for both ping and ping-back | `sendPing` `:2577`, `sendPingBack` `:4904-4912` | stock | yes (implicit) |
| TV start/end | re-sends map description of the TV owner | `sendTVStart` `:4710`, `sendTVEnd` `:4725` | stock map parse | no |
| `0xF6`–`0xF9` market | §6 | | | no |
| `0xFF` | PSoul family, §5 | | | partly |

The `U16` `0xAB` count is written unconditionally (not gated on OTC), so the cipsoft 8.54 client
cannot read the channel list — irrelevant while only OTClient is supported.

### 4.2 Client → server

| Opcode | Payload | Server parser | Client sender | GUI |
|---|---|---|---|---|
| `0x1D` ping-back | — | `protocolgame.cpp:871` → `playerReceivePingBack` | `protocolgamesend.cpp` (feature-gated) | no |
| `0x1E` ping response | — | `:613` | stock | yes |
| `0x32` extended opcode | `U8 id, string buffer` | `:872` → `parseExtendedOpcode` `:1825-1832` → `Game::parsePlayerExtendedOpcode` `game.cpp:7714-7730` | `sendExtendedOpcode` `protocolgamesend.cpp:38-48` (the "enabled" gate is commented at `:40`) | — |
| `0xF4`–`0xF8` market | §6 | `:864-868` | `game_market/marketprotocol.lua:178-226` | no |
| `0xFA` request poll window | — | `:869` → `parseRequestPollWindow` `:1803` | `protocolgamesend.cpp:853-860` | no |
| `0xFB` poll vote | `U8 option` **or** `string text` | `:870` → `parsePollVote` `:1808-1823` | `protocolgamesend.cpp:862-874` | no |
| unknown byte | banishment if `autoBanishUnknownBytes = true` (`configmanager.cpp:237`, default/config `false` `config.example.lua:52`) | `:874-912` | — | — |

---

## 5. `0xFF` PSoul sub-opcode family (S→C)

Envelope `U8 0xFF, U8 sub`. Client enum `Proto::GameServerPSoul = 255` and sub-ids
`client/src-cpp/src/client/protocolcodes.h:151-181`; dispatch
`protocolgameparse.cpp:62-183`. **The inner switch has no `default`:** an unknown sub-id is
silently dropped and the rest of the message is then parsed as normal opcodes (likely
"unhandled opcode" exception at `:470-471`). Server functions are in `protocolgame.cpp`; the
line given is the function definition (the `AddByte(0xFF)` follows within ~10 lines). Lua
`doPlayerSend…` bindings are registered in `server/src/luascript.cpp` around `:1600-1700` and
`:2750-2810`.

PokeNation client: all 26 sub-ids are parsed in
`client-pokenation/src/client/protocolgameparsepsoul.cpp` and fire the same Lua events; an unknown
sub-id throws, so Redemption logs the opcode with a hex dump and drops the rest of the message
instead of desyncing. The U16 counts of `0x14` and `0x19` are read as U16.

| Sub | Server function (`protocolgame.cpp`) | Payload | Client parser (`protocolgameparse.cpp`) → Lua event → module | GUI |
|---:|---|---|---|---|
| `0x01` | `sendPokemonSkills` `:3053` | `U16 iconItemId, U8 n, n×U16 moveIconId` | `parseMoveBarUpdate` `:1810` → `onPokemonMoves` → `game_pokemoves/pokemoves.lua:191` | **yes** |
| `0x02` | `sendPokemonSkillContainerClose` `:3076` | — | `parseMoveBarClose` `:1823` → `onMoveBarClose` — **no listener** (module connects `onPokemonMovesClose`, `pokemoves.lua:250`) | no (never sent by any script) |
| `0x03` | `sendPokemonSkillContainerOpen` `:3090` | — | `parseMoveBarOpen` `:1828` → `onMoveBarOpen` (**no listener**) + `onPokemonBarOpen` | no; sent by `lib/ps/events/actions/openSkillWindow.lua:2` |
| `0x04` | `sendPokemonWindowAddPokemonIcon` `:3104` | `U16 itemId, U16 fastcall, U8 color, string text` | `parsePokemonBarAdd` `:1834` → `game_pokebar/pokebar.lua:263` | yes (P2-04, P2-33) |
| `0x05` | `sendPokemonWindowRemovePokemonIcon` `:3122` | `U16 fastcall` | `:1844` → pokebar | yes |
| `0x06` | `sendPokemonWindowUpdatePokemonIcon` `:3137` | `U16 fastcall, U8 color, string text` | `:1850` → pokebar | yes |
| `0x07` | `sendPokemonWindowOpen` `:3154` | — | `:1859` → pokebar | yes |
| `0x08` | `sendPokemonWindowClose` `:3168` | — | `:1864` → pokebar | wire |
| `0x09` | `sendPokemonSkillCooldown` `:3182` | `U16 moveIconId, U8 seconds` | `parseMoveCooldown` `:1869` → `pokemoves.lua:150` | **yes** |
| `0x0A` | `sendPokedexStatus` `:3198` | `U16 n, n×U8 status` | `:1876` (reads `U16` correctly) → `game_pokedex/pokedex.lua:402` | **yes** |
| `0x0B` | `sendPokedexOpen` `:3218` | — | `:1888` → pokedex | **yes** |
| `0x0C` | `sendPokedexItemUpdate` `:3232` | `U16 number, U8 status` | `:1893` → pokedex | **yes** |
| `0x0D` | `sendTmWindow` `:3267` | `U16 tmMoveItemId, U8 n, n×U16 moves` | `parseTmChoose` `:1900` → `game_tmchoose/tmchoose.lua:91` | **yes** (P2-16) |
| `0x0E` | `sendPokemonStatusAdd` `:3289` | `U16 itemId, U8 cooldown` | `:1913` → `game_statusbar/statusbar.lua:261` | **yes** (P2-13) |
| `0x0F` | `sendPokemonStatusRemove` `:3307` | `U16 itemId` | `:1920` → statusbar | **yes** |
| `0x10` | `sendPokemonStatusClear` `:3324` | — | `:1925` → statusbar | **yes** |
| `0x11` | `sendPokedexInfo` `:3248` | `U16 number, string details, string moves, string effectiveness, string families` | `:1930` → pokedex | **yes** |
| `0x12` | `sendCreatureJump` `:3339` | `U32 creatureId` | `parseCreatureJump` `:1941` → C++ `creature->jump(20, 450)` | no |
| `0x13` | `sendCreatureEffect` `:3355` | `U32 creatureId, U8 effectId, U32 var` | `:1951` → creature `onEffect` → `game_effects/effects.lua:16` | **yes** |
| `0x14` | `sendDollCaseStatus` `:4776` | `U16 n, n×U8 status` | `parseDollCaseStatus` `:1963-1973` → `game_dollcase/dollcase.lua:330` — **reads the `U16` into a `uint8_t` and loops with a `uint8_t` index** | no |
| `0x15` | `sendDollCaseUpdate` `:4796` | `U16 number, U8 status` | `:1975` → dollcase | no |
| `0x16` | `sendSlotMachine` `:4814` | `3×U8 reel` | `:1983` → `game_slotmachine/slotmachine.lua:173` | no |
| `0x17` | `sendTip` `:4833` | `U8 tipId` | `:1992` → `game_tips/tips.lua:50` | no |
| `0x18` | `sendPollWindow` `:4850` | `string question, U8 textMode`; if `textMode == 0`: `U8 n, n×(U8 optionId, string text)` — option id truncated to one byte at `:4871` (BUG-52) | `parsePollWindow` `:1999-2019` → `game_poll/poll.lua:126` | no |
| `0x19` | `sendPokemonLevelUp` `:4880` | `U16 number, U8 level, U16 n, n×U16 moveIconId` | `parsePokemonLevelUp` `:2021-2034` → `game_advanceeffect/advanceeffect.lua:276` — **`uint8_t count = getU16()`** | no |
| `0x1A` | `sendLootList` `:4914` (OTC only) | `U8 n, n×(U16 clientId, U8 count)` | `:2036` → `game_lootlist/lootlist.lua:93` | **yes** |

Client-side count truncation (new, see FULL_SOURCE_AUDIT §10):

* `0x14`: the server sends one byte per species that has a doll
  (`server/data/lib/ps/systems/041-dollCase.lua:537-544`; `DOLLS_NUMBER = 250`, `:9`). With
  `n ≤ 254` it works; at `n ≥ 256` the client desyncs and at `n == 255` the `uint8_t` loop never
  terminates. Latent for the current 250-doll set; triggers as soon as Gen 3 dolls are added.
* `0x19`: same truncation; harmless while fewer than 256 new moves are announced.

---

## 6. Market (backported 9.x, OTC `GamePlayerMarket`)

| Dir | Opcode | Payload | Server | Client | GUI |
|---|---|---|---|---|---|
| S→C | `0xF6` enter | `U64 balance, U8 offerCount, U16 n, n×(U16 itemId, U16 count)` | `sendMarketEnter` `protocolgame.cpp:3600` (`AddByte` `:3612`); returns early without depot (BUG-36) | `marketprotocol.lua:40-57` | no |
| S→C | `0xF7` leave | — | `:3697` (`:3709`) | `:59` | no |
| S→C | `0xF8` detail | `U16 itemId`, attribute strings (mostly empty), statistics | `sendMarketDetail` `:3903` (`:3915`) | `:64` | no |
| S→C | `0xF9` browse / accept / own offers / cancel / own history | `U16 var` (item id, `0xFFFE` own offers, `0xFFFF` history) + buy and sell offer lists | `:3713`, `:3749`, `:3785`, `:3821`, `:3857` | `marketprotocol.lua` (registered at `:151-154`) | no |
| C→S | `0xF4` leave | — | `protocolgame.cpp:864` | `marketprotocol.lua:178-226` | no |
| C→S | `0xF5` browse | `U16 spriteId` / `0xFFFE` / `0xFFFF` | `:865` | same | no |
| C→S | `0xF6` create | `U8 type, U16 spriteId, U16 amount, U32 price, U8 anonymous` | `:866` | same | no |
| C→S | `0xF7` cancel | `U32 timestamp, U16 counter` | `:867` | same | no |
| C→S | `0xF8` accept | `U32 timestamp, U16 counter, U16 amount` | `:868` | same | no |

Client opcode enums: `protocolcodes.h:145-148` (S→C 246-249) and `:276-280` (C→S 244-248).
Market config keys (`marketOfferDuration`, `premiumToCreateMarketOffer`, …) are read by
`configmanager.cpp:301-304` but absent from `config.lua` (BUG-52).

---

## 7. Polls

| Dir | Opcode | Payload | Server | Client | GUI |
|---|---|---|---|---|---|
| S→C | `0x64` charlist trailer | `U8 pollAvailable` | `protocollogin.cpp:296-298` | `protocollogin.lua:199` | yes (byte read) |
| C→S | `0xFA` | — | `protocolgame.cpp:869`, `:1803` | `protocolgamesend.cpp:853-860` | no |
| S→C | `0xFF 0x18` | §5 | `:4850` | `:1999` | no |
| C→S | `0xFB` | `U8 optionId` or `string text` | `:870`, `:1808-1823`; minimum level `minimumLevelToPollVote` (`configmanager.cpp:305`, absent from config → 25) | `protocolgamesend.cpp:862-874` | no |

Poll content exists only in `polls` / `poll_options` / `poll_texts` rows that the (missing)
website wrote; the server only inserts `poll_votes`.

---

## 8. Extended opcode `0x32` ids

C++ constants: `server/src/extendedopcodes.h` (`ExtendedOpcode_t`, ids 0–99 reserved for the
engine and the clients, `EXTENDED_OPCODE_MAX_PAYLOAD` = 4096 bytes). `Game::parsePlayerExtendedOpcode`
rejects larger payloads, handles 1 and 10 itself with validation, ignores client-sent
server→client ids (0, 8, 9) and passes everything else to Lua `onExtendedOpcode` creature events.
Server Lua constants `EXTENDED_IDS` `server/data/lib/ps/others/constants.lua:33-45`; client
`ExtendedIds` `client/modules/gamelib/const.lua:241-253`. Server Lua sender:
`doSendPlayerExtendedOpcode` (`luascript.cpp:2761`, impl `:13641-13649`) →
`ProtocolGame::sendExtendedOpcode` `protocolgame.cpp:1834` (OTC only). Client Lua receive:
`ProtocolGame.registerExtendedOpcode` via `client/modules/gamelib/protocolgame.lua:14-19`; C++
`parseExtendedOpcode` `protocolgameparse.cpp:1782-1793` handles id 0 (enable send) and 2
(ping-back) itself.

| Id | Name | S→C sender | C→S sender | Client handler | Server handler | Status |
|---:|---|---|---|---|---|---|
| 0 | Activate | `protocolgame.cpp` after login (Phase 3), empty payload; arrives after the map description | — | C++ `:1787-1788` (legacy); PokeNation client `parseExtendedOpcode` enables sending and fires Lua `g_game.onExtendedOpcodeEnabled` | — | ACTIVE (verified with the PokeNation client, C-05) |
| 1 | Locale | none | PokeNation client on `onExtendedOpcodeEnabled` and on language change (`client-pokenation/modules/client_locales/locales.lua`); legacy: commented (`client_locales/locales.lua:8-15`) | — | `game.cpp parsePlayerExtendedOpcode`: payload exactly one char `"0"`…`"2"` (en, pt-BR, es), else ignored; sets the session language and `accounts.lang_id` | ACTIVE (verified with the PokeNation client, C-05) |
| 2 | Ping | none | `protocolgamesend.cpp:128-131` only with `GameExtendedClientPing` (not enabled) | C++ `:1789-1790` | none | UNUSED |
| 3 | Sound | none | — | none (would be `game_environment`, not loaded) | — | UNUSED |
| 4 | Game | none | — | none | — | UNUSED |
| 5 | Particles | none | — | none | — | UNUSED |
| 6 | MapShader | none | — | none | — | UNUSED |
| 7 | NeedsUpdate | none | — | none | — | UNUSED |
| 8 | GameplayTutorialText | `creaturescripts/scripts/login.lua:69`, `quest_professorOak.lua:115`, `gameplayTutorial_shop.lua:14`, `quest_red.lua:40-53`, `lib/ps/config/003-quest.lua:169,202`, `gameplayTutorial_onKill.lua:8-14`, `activationTile.lua:1132-1149` | — | `game_guide/guide.lua:43` | — | ACTIVE, not GUI-verified |
| 9 | GameplayTutorialImage | `login.lua:70` and the same scripts | — | `game_guide/guide.lua:44` | — | ACTIVE, not GUI-verified |
| 10 | DashWalking | — | `client_options/options.lua:97,275` | — | C++ `game.cpp parsePlayerExtendedOpcode`, payload `"0"`/`"1"` only | ACTIVE, not GUI-verified |
| 103 | (shop purchase failed, ad hoc) | none | — | `game_shop/shop.lua:3` (module **not loaded**) | — | UNUSED |

Any other id reaching the server would go to Lua `onExtendedOpcode`
(`creatureevent.cpp:2690`), but no script registers such an event — dead path.

---

## 9. Re-verification of SOURCE_AUDIT §2

Re-confirmed: transport, RSA, OS ids, version 312, the login language byte and its position,
the charlist extras and poll byte (`protocollogin.cpp:263-298`), the `0x1F` challenge
(`protocolgame.cpp:438`), the self-login light hour (now `:2790-2796`, SOURCE_AUDIT said `:2795`),
`U16` magic effects (`:4251`), creature extras (`:4267-4318`), `U16` channel count, all `0xFF`
payloads and the `0x32` id table.

Corrections:

1. §2.3 lists "6 skipped bytes" as part of the enter-game packet. They are the challenge
   (`U32 + U8` = 5 bytes) plus one padding byte; the server skips them (`protocolgame.cpp:487`
   "841- wtf?") and **never checks the challenge value**.
2. §2.6 names the switch `banUnknownBytes`; the real config key is `autoBanishUnknownBytes`
   (`configmanager.cpp:237`), and the code range is `:874-912`, not `:874-902`.
3. §2.5 gives the doll-case and level-up payload as `U16 n`; that is what the server sends, but
   the client reads both counts into `uint8_t` (`protocolgameparse.cpp:1965`, `:2026`).
4. §2.5 lists `0x02/0x03` as "move bar visibility"; on the client they fire `onMoveBarClose` /
   `onMoveBarOpen`, which no module listens to (`pokemoves.lua:250-251` listens to
   `onPokemonMovesClose/Open`), so they have no visible effect except `0x03` also opening the
   Pokémon bar. Same in `original/client`.
5. §2.2 does not mention that the Account Manager charlist row lacks the custom fields
   (`protocollogin.cpp:227-234`).
6. §2.4 "`0xF6`–`0xF9` market … `protocolgame.cpp:3600-3695`": the market senders span
   `:3600-3940` (browse/accept/own-offers/cancel/history all use `0xF9`, detail `0xF8` at `:3915`).
7. §2.4 omits the second `0xF1` sender `sendCustomQuestInfo` (`:4750`) and the TV map re-send
   (`:4710`, `:4725`).
8. Client `0x32` sending is not gated by `m_enableSendExtendedOpcode` (commented at
   `protocolgamesend.cpp:40`), so the client sends id 10 without the server ever sending id 0.
   Since Phase 3 the server does send id 0 at login, which the Redemption client needs.

---

## 10. PokeNation client (`client-pokenation/`, Redemption 4.1)

The new client implements every packet in §2–§8 the way the legacy client reads it. Changes to
stock Redemption are listed one by one in [`../REDEMPTION_CHANGES.md`](../REDEMPTION_CHANGES.md).

| Packet | Legacy client | PokeNation client | Verified |
|---|---|---|---|
| Login `0x01` version | `312` | `g_game.getWireProtocolVersion()` = 312 (internal 854) | yes (C-01) |
| Login OS | `0x0A..0x0C` + language byte | `0x14..0x17` (`g_game.setCustomOs`), no language byte | yes (C-01) |
| Charlist extras + poll byte | `protocollogin.lua` | `modules/gamelib/protocollogin.lua` under `GamePSoulProtocol` | yes (C-02) |
| Self-login light hour `U16` | `parseLogin` | `parseLogin`, Lua event `g_game.onLightHour` | yes (C-03) |
| Creature extras `U8 summon, U8 attackable` | `getCreature` | `getCreature`, `Creature:isLocalPlayerSummon/isAttackable` | yes (C-06) |
| `0xAB` channel list `U16` count | `parseChannelList` | same, under `GamePSoulProtocol` | yes (C-07) |
| `0xFF` family | `protocolgameparse.cpp:62-183` | `protocolgameparsepsoul.cpp` (throws on unknown sub-id) | `0x0A` yes (C-08); others not yet |
| Ext opcode 0 / 1 | §8 | §8 | yes (C-05) |
| Market `0xF4-0xF9` | `marketprotocol.lua` | stock Redemption `marketprotocol.lua` | **not compared yet** |
| Polls `0xFA/0xFB` | `protocolgamesend.cpp:853-874` | **not ported yet** | no |
| TV, map marks `0xDD` | C++ | stock Redemption (shapes match at 854) | no |
