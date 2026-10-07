# Legacy client reference (frozen)

`/client` is the **frozen legacy PSoul/PokeAimar reference client**. It is kept and built so that
the server can be played and tested exactly as the original project shipped it, and so that a
future client can be checked against the real behaviour. Its gameplay, UI and protocol code are
**not changed** in Phase 2A or Phase 3. The only changes allowed are build fixes for current
compilers and libraries and crash fixes that keep the original behaviour (§8); all of them are
listed in [LOCAL_CLIENT_TESTING.md §3.3](LOCAL_CLIENT_TESTING.md).

## 1. Identity

| | |
|---|---|
| Base | OTClient 0.6.x fork (edubart/otclient, 2013-2014 era). `VERSION="0.6.3"` in the original VS2013 project |
| Application name | `PSoul` / compact name `psoul` (hard-coded in `client/src-cpp/src/main.cpp:33-34`) |
| Source | `client/src-cpp/src/` (current). `client/src-cpp/vc12/` is an older, stale copy that no project compiles (HISTORICAL) |
| Build system | `client/src-cpp/CMakeLists.txt` (upstream layout). The VS2013 `vc12/*.vcxproj` is HISTORICAL and needs an unavailable 2014 library bundle |
| Licence | MIT (`client/LICENSE`, packaged as `LICENSE-client.txt`) |
| Packaged exe | `PokeNationLegacyClient.exe` (Windows), `psoulclient` (Linux). The name does not matter: the client finds its work dir by looking for `init.lua` |

## 2. Protocol

| | |
|---|---|
| Packet layout | Tibia 8.54 (`protocolVersion = 854`, `client/modules/client_entergame/entergame.lua:193`) |
| Version on the wire | `312` (`client/modules/gamelib/protocollogin.lua:38`, `client/src-cpp/src/client/protocolgamesend.cpp:57`). The server accepts exactly 312 (`server/src/resources.h:79-80`) |
| Login | `127.0.0.1:7564`, hard-coded in `entergame.lua:191-192` |
| Game | host/port from the character list (`config.lua` `ip`, `gamePort = 8548`) |
| Encryption | RSA (OTServ key, `gamelib/game.lua:23-39`) + XTEA, standard 8.54 |
| OS byte | 10/11/12 (OTClient), which the server uses to detect OTClient (`server/src/player.cpp` `isUsingOtclient`) |
| PSoul extensions | server opcode `0xFF` + sub-opcode (`GameServerPSoulOpcodes`, `client/src-cpp/src/client/protocolcodes.h:154-181`): move bar, Pokémon bar, cooldowns, Pokédex, TM chooser, status bar, creature jump/effect, doll case, slot machine, tips, poll window, level up, loot list. Also extended opcodes (`ExtendedIds`, `client/modules/gamelib/const.lua:241-253`) and the `0x64` character-list extras |

The full opcode catalogue, with server and client locations, is in
[reference/OPCODES.md](reference/OPCODES.md).

## 3. Where things live

| What | Where |
|---|---|
| Packet parsing (server → client) | `client/src-cpp/src/client/protocolgameparse.cpp`: dispatch at `:62` (`case Proto::GameServerPSoul`, then a switch on the sub-opcode), handlers from `:1810` (`parseMoveBarUpdate`, `parsePokemonBar*`, …) |
| Packet sending (client → server) | `client/src-cpp/src/client/protocolgamesend.cpp` |
| Opcode numbers | `client/src-cpp/src/client/protocolcodes.h` |
| Lua bindings for C++ | `client/src-cpp/src/client/luafunctions.cpp`, `framework/luafunctions.cpp` |
| Startup script | `client/init.lua` (search paths, module load order 0-99 libs, 100-499 client, 500-999 game, 1000+ mods) |
| UI modules | `client/modules/` (`client_*` = login/options/topmenu, `game_*` = in-game windows; PSoul-specific: `game_pokebar`, `game_pokemoves`, `game_pokedex`, `game_badgecase`, `game_dollcase`, `game_tmchoose`, `game_slotmachine`, `game_lootlist`, `game_shop`, `game_tutorial`, `game_guide`, `game_tips`) |
| Constants / shared Lua | `client/modules/gamelib/`, `client/modules/corelib/` |
| Sprites / items | `client/data/things/data.spr` (Git LFS) + `data.dat` (loaded by `modules/game_things/things.lua:24-25`) |
| Images, fonts, sounds, styles | `client/data/images`, `fonts`, `sounds`, `styles`, `particles`, `shaders` |
| Translations | `client/modules/client_locales/` + `client/data/locales` |
| Settings and log at runtime | `~/.psoul/config.otml` + `~/psoul.log` (Linux), `%USERPROFILE%\psoul\config.otml` + `%USERPROFILE%\psoul.log` (Windows) |

## 4. Assets

- Assets in the repository are the **unencrypted development copies**. The original release
  AES-encrypted them, and the decrypt layer is now behind `-DENCRYPTED_ASSETS=OFF` (default), see
  [LOCAL_CLIENT_TESTING.md §4](LOCAL_CLIENT_TESTING.md). The hard-coded key is BUG-56.
- `data.spr` (≈ 100+ MB) is in Git LFS. If it is a 130-byte pointer file, the client cannot start,
  and every launcher checks for this.
- `*.psd` (Photoshop sources, LFS) are never loaded and are excluded from packages.

## 5. Build

| Platform | Command | Output |
|---|---|---|
| Linux | `tools/build_legacy_client_linux.sh` (= `tools/build_client.sh`) | `build/linux-development/client/psoulclient` |
| Windows (MSYS2 MINGW64) | `tools/build_legacy_client_windows.sh`, or `tools\windows\Build-PokeNation-Windows.ps1 -Component client` | `build/windows-development/client/psoulclient.exe` → packaged as `PokeNationLegacyClient.exe` |

CMake options: `-DUSE_STATIC_LIBS=ON -DLUAJIT=OFF -DENCRYPTED_ASSETS=OFF`. See [BUILDING.md](BUILDING.md).

## 6. Verified working (Phase 2, local server)

Verified with the client compiled from this repository (see [PHASE_2_TEST_MATRIX.md](PHASE_2_TEST_MATRIX.md) P2-33/P2-34):
login and MOTD, PSoul character list with team icons, entering the world, map and lights,
minimap, health/energy bars, Balls/Respect counters, inventory with PSoul slots, channel list
and NPC chat, Pokémon bar (summon/return), move bar with tooltips and cooldowns, Pokédex window,
status icons, monster speech bubbles, loot list. No protocol desync was seen.

## 7. Known broken or limited (not fixed: client is frozen)

| Issue | Bug |
|---|---|
| Pokémon bar overlaps the move bar at the bottom-left | BUG-11 |
| Inventory hides slots 2 (evolve icon) and 3 (backpack), so items created with `/i` are invisible | BUG-12 |
| `CAST ERROR … TPoint<int>` console noise; `tmchoose.lua` connect/disconnect leak | BUG-57 |
| Hard-coded AES key/IV in source | BUG-56 |
| "Create account"/"Lost account"/"Donate" buttons open the original websites (offline) | WEBSITE-DEPENDENT |
| `game_shop` module not loaded (opcode 103 never sent) | DISABLED |
| `client_serverlist` / `data/servers.xml` not used by the login flow | UNUSED |
| No sound device → OpenAL aborts unless `ALSOFT_DRIVERS=null` (Linux launcher sets it) | environment |
| Crash 2-3 s after start when the GPU's maximum texture size is below 1920 (GPU-less VMs, Windows "GDI Generic" OpenGL 1.1): the animated 1920x1080 background is rejected and `AnimatedTexture::updateAnimation()` reads an empty vector. Workaround: Mesa `opengl32.dll` with `GALLIUM_DRIVER=llvmpipe` | BUG-73 |
| `Assertion failed! … eventdispatcher.cpp Line: 85 Expression: delay >= 0` when a move makes the target jump (Headbutt). Only development builds have active asserts; the original Release exe never showed it. Fixed by clamping the delay in `Creature::updateJump()`; older packages: press Ignore | BUG-75 (fixed) |

## 8. Why the client stays unchanged in Phase 3

1. **Reference behaviour.** It is the only executable description of what the original players
   saw: packet order, the meaning of every `0xFF` sub-opcode, and UI flows. Changing it would
   destroy the baseline that a new client (or a protocol upgrade) must be compared against.
2. **Server work is testable against a fixed counterpart.** Server-side fixes in Phase 3 can be
   verified with an unchanged client (and `tools/protocol_probe.py`, which speaks the same
   protocol). Changing both sides at once would hide regressions.
3. **The codebase is an old OTClient fork.** Modernising it (protocol, rendering, Lua API) is a
   separate project with its own risks, and it is planned as a replacement, not as edits here.
4. **Licensing and provenance stay simple.** It remains the MIT OTClient fork as imported, plus
   documented build fixes.

Allowed changes: build fixes for new compilers and libraries, launcher and packaging files
outside `client/`, and crash fixes that keep the original behaviour (BUG-03, BUG-75). Every such change must be listed in LOCAL_CLIENT_TESTING.md §3.3.
