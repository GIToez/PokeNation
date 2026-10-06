# Local client testing (Phase 2)

How the PokeAimar/PSoul OTClient in `client/` is configured for a server running on the same
machine, where every address/port/version lives, what the original toolchain was, how the
client is compiled now, and what was changed to make it run.

Everything below was verified by compiling the client from `client/src-cpp` on Linux and
logging into the local server with it (see `PHASE_2_REPORT.md §1`).

---

## 1. Development connection settings

| Setting | Value | Where it is configured |
|---------|-------|------------------------|
| Login host | `127.0.0.1` | `client/modules/client_entergame/entergame.lua:191` (`G.host = '127.0.0.1'`) |
| Login port | `7564` | `entergame.lua:192` (`G.port = 7564`); fallback when settings are empty: `entergame.lua:93` |
| Packet layout | 854 | `entergame.lua:193` (`protocolVersion = 854`) selects OTClient's 8.54 packet shapes; it is **not** sent on the wire |
| Version field on the wire | `312` | login packet `client/modules/gamelib/protocollogin.lua:38` (`msg:addU16(312)`); game-world login `client/src-cpp/src/client/protocolgamesend.cpp:57` (`msg->addU16(312)`) |
| Server accepts | `312..312` | `server/src/resources.h:79-80` (`CLIENT_VERSION_MIN/MAX`), checked in `server/src/protocollogin.cpp:116` |
| OS id | `10` Windows / `11` Linux / `12` macOS | `client/src-cpp/src/client/game.cpp:1648-1659` (`Game::getOs`, unless `g_game.setCustomOs` was called). Server treats `>= 0x0A` as OTClient: `server/src/player.cpp:5502` (`isUsingOtclient`), enum `server/src/enums.h:61-63` |
| Game host / port | from the character list | the server sends them in the charlist (`server/src/protocollogin.cpp:263-298`): `ip`/`gamePort` from `server/config.lua` |
| Server advertised IP | `127.0.0.1` | `server/config.lua:88` (`ip = "127.0.0.1"`), `loginPort = 7564` (`:90`), `gamePort = 8548` (`:91`). `config.example.lua` carries the same values |
| RSA key | OTServ public key | `client/modules/gamelib/game.lua:23-39` (`g_game.chooseRsa`: any host that is not `*.tibia.com` gets `OTSERV_RSA`) |
| Language byte | current client locale id | `protocollogin.lua:39`; the server stores it in `accounts.lang_id` on each login (`server/src/protocollogin.cpp:162-165`) |

Nothing in the C++ client had to be changed for the addresses: the archive's `entergame.lua`
already hard-codes `127.0.0.1:7564` (it is byte-identical to `original/client/.../entergame.lua`),
and the server's `config.lua` was already set to `127.0.0.1` in Phase 1. The character-list
`worldIp` is therefore `127.0.0.1` and the client connects to `127.0.0.1:8548` for the game.

### 1.1 Original production values (for reference only)

| Item | Production value | Where |
|------|------------------|-------|
| Server `ip` | `191.179.192.219` / `khjyr.servegame.com` | comment on `server/config.lua:88` and `config.example.lua` |
| Client server-list entry | `192.99.251.233` | `client/data/servers.xml` (unused by the login flow, see `SECURITY_AUDIT.md`) |
| Website links in the client | `http://pokenordic.com/accounts/create`, `.../lostAccount` | `client/modules/client_entergame/entergame.otui:80-87` |
| Character list buttons | `http://www.psoul.net/players/createCharacter`, `.../accounts/donate` | `client/modules/client_entergame/newcharacterlist.otui:223,232` |
| Outdated-client message | `http://www.psoul.net` | `server/src/resources.h:81` |

The ports `7564`/`8548` were the production ports as well.

### 1.2 Changing the target server

Edit `G.host`/`G.port` in `client/modules/client_entergame/entergame.lua:191-192` (Lua, no
recompilation needed) and `ip`/`loginPort`/`gamePort` in `server/config.lua`. The client stores
the last used host/port in its settings file (`~/.psoul/config.otml` on Linux,
`%APPDATA%\psoul\config.otml` on Windows) but `doLogin()` overrides them with the constants
above on every login.

---

## 2. Original toolchain (what the archive expected)

| Item | Value | Evidence |
|------|-------|----------|
| IDE / toolset | Visual Studio 2013, toolset `v120`, Win32 only | `client/src-cpp/vc12/otclient.vcxproj:29-48` |
| Language | C++11 (`-std=c++0x` in CMake, VS2013 subset) | `client/src-cpp/src/framework/CMakeLists.txt:161-163` |
| Defines | `WIN32 _CRT_SECURE_NO_WARNINGS _WIN32_WINNT=0x0501 BOT_PROTECTION CLIENT CRASH_HANDLER FW_GRAPHICS FW_NET FW_SOUND FW_XML VERSION="0.6.3"` | `otclient.vcxproj:89` |
| Include path | `E:\otclient_psoul\src` (absolute path on the author's machine) | `otclient.vcxproj:91` |
| Lua | **LuaJIT** (`luajit.lib`) in the VS build; plain Lua 5.1 is the CMake default (`LUAJIT=OFF`) — same C API | `otclient.vcxproj:96`, `framework/CMakeLists.txt:141` |
| OpenGL | OpenGL 1.1/2.0 via `opengl32.lib` + GLEW (`glew32.lib`) | `otclient.vcxproj:96` |
| Boost | `>= 1.48`, components `system filesystem chrono` (+ `thread` on Windows) | `framework/CMakeLists.txt:209` |
| PhysFS | `physfs.lib` (virtual filesystem for `data/` and `modules/`) | `otclient.vcxproj:96` |
| Audio | OpenAL (`openal32.lib`) + Ogg/Vorbis (`libogg_static`, `libvorbis_static`, `libvorbisfile_static`) | same |
| Images | built-in APNG loader (`framework/graphics/apngloader.cpp`) over zlib (`zlib1.lib`) | same |
| Networking | Boost.Asio + OpenSSL 1.0.x (`libeay32MD.lib`, for RSA/SHA) | same |
| Crash handler | `dbghelp.lib` | same |
| Runtime DLLs of a VS build | `glew32.dll`, `zlib1.dll`, `libeay32.dll`, `physfs.dll`, `OpenAL32.dll`, `lua51.dll` (LuaJIT) | the archive's `Poke Aimar` folder shipped exactly these next to the exe (`SECURITY_AUDIT.md §2`); none of them was imported |
| Asset paths | `<workdir>/data`, `<workdir>/modules`, `<workdir>/init.lua`; things from `/things/data.dat` + `/things/data.spr` (`client/modules/game_things/things.lua:24-25`) | `client/init.lua:15-20` |
| Startup working directory | the folder that contains `init.lua` (`g_resources.getWorkDir()` searches the CWD, then the executable's directory) | `framework/core/resourcemanager.cpp` |
| User settings | `~/.psoul/` (Linux) / `%APPDATA%\psoul\` (Windows): `config.otml`, `psoul.log` | `client/init.lua:5-8`, `client/src-cpp/src/main.cpp:34` |
| Two source copies | `src-cpp/src/` is the current one (has `GameServerPSoulLootList = 26`); `src-cpp/vc12/client/` is a stale copy not referenced by the project (`.vcxproj` compiles `..\src\...`) | `protocolcodes.h` diff, `otclient.vcxproj:164+` |

The VS2013 project was not used: it depends on a 2014-era prebuilt library bundle
("otclient-msvc13-libs") that is no longer distributed, on an absolute include path, and on
OpenSSL 1.0 and LuaJIT binaries that would have to be rebuilt by hand. The project's own
`CMakeLists.txt` (upstream OTClient 0.6 layout) is the supported path and is what both the local
build and the GitHub Actions workflow use.

---

## 3. Building the client now

### 3.1 Linux (what was done in this environment)

```bash
sudo apt install build-essential cmake libboost-system-dev libboost-filesystem-dev \
  libboost-chrono-dev liblua5.1-0-dev libphysfs-dev libopenal-dev libglew-dev libvorbis-dev \
  libogg-dev libssl-dev zlib1g-dev libgl1-mesa-dev libglu1-mesa-dev libx11-dev
tools/build_client.sh          # -> build/client/psoulclient
tools/start_client.sh          # runs it from client/ (needs DISPLAY)
```

`tools/build_client.sh` passes `CXX=g++`, `-DUSE_STATIC_LIBS=ON -DLUAJIT=OFF
-DENCRYPTED_ASSETS=OFF` and, on Debian/Ubuntu, `-DPHYSFS_LIBRARY=/usr/lib/.../libphysfs.so`
(the distro's static `libphysfs.a` has no archive index and cannot be linked).

### 3.2 Windows (GitHub Actions)

`.github/workflows/build.yml` builds the same CMake project under MSYS2 MinGW-w64 with the
distro packages for every dependency, then packages `PokeNationClient.exe` together with the
DLLs reported by `ldd`, `data/`, `modules/` and `init.lua`. See `BUILDING.md §8` for how to
download it.

### 3.3 Source changes required (all in `client/src-cpp`, no protocol or gameplay code touched)

| File | Change | Why |
|------|--------|-----|
| `framework/stdext/shared_object.h:75-79` | converting constructor excluded for `U == T` | GCC ≥ 7 refuses `std::is_convertible` on the incomplete element type; the original check never disabled the overload anyway |
| `framework/ui/uilayout.h:34`, `uilayout.cpp` | constructor moved out of line | same incomplete-type problem for `UIWidget` |
| `framework/util/crypt.cpp:317-390, 439-545` | OpenSSL 1.1 accessor API (`RSA_set0_key`, `RSA_get0_*`, `EVP_CIPHER_CTX_new/free`) | `RSA`/`EVP_CIPHER_CTX` are opaque since OpenSSL 1.1; behaviour unchanged |
| `framework/net/connection.{h,cpp}`, `framework/net/server.cpp`, `framework/stdext/net.cpp` | `io_service` → `io_context`, `deadline_timer` → `steady_timer` (`expires_after`), `resolver::iterator` → `results_type`, `address_v4::from_string/to_ulong` → `make_address_v4/to_uint` | the deprecated Asio API was removed in Boost ≥ 1.87 (MSYS2); the replacements exist since Boost 1.66, so Ubuntu 24.04 (1.83) builds the same code. Verified by logging in with the rebuilt client |
| `framework/util/point.h:80` | `getLength()` → `length()` | the method never existed; GCC 15 now rejects it inside the template body |
| `CMakeLists.txt:2` | `cmake_minimum_required(VERSION 3.5)` | CMake 4 refuses projects declaring compatibility with < 3.5 |
| `framework/platform/unixcrashhandler.cpp:33` | `#include <csignal>` | `siginfo_t`/`SIGSEGV` not pulled in transitively any more |
| `framework/graphics/apngloader.cpp:168` | `unpack(z_stream&, …)` by reference | zlib ≥ 1.2.9 rejects a by-value `z_stream` copy; every PNG decoded to zeros (noise textures) |
| `framework/core/resourcemanager.cpp:193-204`, `CMakeLists.txt:24-30` | AES asset decryption behind `ENCRYPTED_ASSETS` (default OFF) | see §4 |
| `modules/game_duelmessage/duelmessage.lua:44`, `modules/game_lootlist/lootlist.lua:96`, `data/images/topbuttons/emerald_shop.PNG → .png` | case-correct file names | Windows is case-insensitive, PhysFS on Linux is not. A scan of every `loadUI/displayUI/importStyle/dofile` and `/images/...` reference found only these three mismatches |

---

## 4. The asset-encryption layer

`ResourceManager::readFileContents` in the shipped source AES-decrypts every `.lua .png .otmod
.otfont .otps .otui .ogg .frag .spr .dat` it reads, with a key and IV hard-coded in
`Crypt::__aesDecrypt` (`crypt.cpp`). This is the release-packaging obfuscation of the original
project: the distributed `Poke Aimar.exe` expected encrypted files, and `spritemanager.cpp:50`
even keeps the plain `openFile()` path for the `.spr` with the encrypted variant commented out.

The assets in this repository (`client/data`, `client/modules`) are the **unencrypted
development copies** (`init.lua` is readable, `data.dat` starts with its normal signature, PNGs
start with `\x89PNG`). With the decrypt active the client aborted in `readFileContents`
(`std::length_error`) on the first Lua file. The layer is now a CMake option so that:

* development builds (`ENCRYPTED_ASSETS=OFF`, the default) read the files as they are;
* a release build can still be produced with `-DENCRYPTED_ASSETS=ON` plus an encryption step
  for the assets (not part of this repository), exactly as the original.

Security note: the key in the binary provides obfuscation only; see `SECURITY_AUDIT.md`.

---

## 5. Running and testing locally

```
tools/start_database.sh      # 1. database (MariaDB)
tools/start_server.sh        # 2. server, wait for ">> Cristal server Online!"
tools/start_client.sh        # 3. client window
                             # 4. log in: admin / admin  ->  "GM Admin" or "Tester"
                             #            player / player -> "Trainer"
```

Development-only credentials; see `BUILDING.md §7`.

What the compiled client was verified to do against the local server (screenshots in
`PHASE_2_REPORT.md`): login (MOTD), the PSoul character list with level/outfit/Pokémon team icons
(`0x64` extras), entering the world, map rendering with lights, the Pokémon bar, Health Info
with Balls/Respect counters, inventory with the PSoul slots (order icon, Pokédex, Pokébag),
minimap, NPC chat.

### 5.1 Headless machines

* No sound device: the client aborts inside OpenAL (`alcOpenDevice`). `tools/start_client.sh`
  sets `ALSOFT_DRIVERS=null` automatically when no `/dev/snd`, PulseAudio or PipeWire is found.
* No X display: run under `xvfb-run -a -s "-screen 0 1280x800x24"`; the CI smoke test does this.
  Mesa's `llvmpipe` software renderer is enough (OpenGL 4.5 compatibility profile was reported).
* Driving the client with `xdotool`: mouse clicks arrive, but keystrokes are dropped until the
  window has X input focus. Use `W=$(xdotool search --name '^PSoul$' | head -1); xdotool
  windowfocus --sync $W; xdotool key --window $W a b c Tab Return` (per-key `key`, not `type`).
  Account/password fields: click the account field, type, `Tab`, type, `Return`; `Return` again
  on the MOTD and on the character list.

### 5.2 Known client-side log noise (not fixed, harmless)

* `CAST ERROR: failed to cast value of type 'std::string' to type 'TPoint<int>'` twice at
  startup — an `.otui` style passes a string where a point is expected; cosmetic.
* `Locale 'pl' is missing 1 translations.` — upstream OTClient locale file.
* `[ALSOFT] (EE) Could not query RTKit` — OpenAL on a machine without a session bus.

### 5.3 Why the login works without `servers.xml`

The server-list module (`client/modules/client_serverlist`) and `client/data/servers.xml` are
not part of the login flow; `EnterGame.doLogin()` uses the constants in §1 directly. The status
protocol the server list would ping is disabled in the server (`SOURCE_AUDIT.md §7`).
