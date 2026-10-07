# OTClient Redemption baseline (client-pokenation/)

`client-pokenation/` is the new PokeNation client. It starts from an unmodified import of
OTClient Redemption and keeps upstream's layout, so upstream fixes can be compared and merged
file by file. The frozen legacy client stays in `client/` ([LEGACY_CLIENT_REFERENCE.md](LEGACY_CLIENT_REFERENCE.md));
no file is shared between the two (no symlinks, no common sources).

## 1. Upstream

| Item | Value |
|---|---|
| Repository | https://github.com/opentibiabr/otclient |
| Tag | `4.1` (lightweight tag) |
| Commit | `dd5641492a71e966b96b8a91398b44bb3df67d88` (2026-08-15, "fix(game_bot): defensive nil checks in looting/analyzer and fix money exchange (#1809)") |
| Import date | 2026-10-07 |
| Import commit | `17e40d7` ("Import OTClient Redemption 4.1 (dd56414) into client-pokenation/ (stock, unmodified)") |
| License | MIT, `client-pokenation/LICENSE` (kept unchanged), authors in `client-pokenation/AUTHORS` |
| vcpkg baseline | `cd61e1e26a038e82d6550a3ebbe0fbbfe7da78e3` (`client-pokenation/vcpkg.json`) |

### 1.1 What the import excluded or renamed

| Path | Action | Why |
|---|---|---|
| `browser/include/lua51/liblua.a` | not imported | prebuilt static library (untrusted binary); only the WebAssembly build uses it, and PokeNation does not ship a browser client |
| `.gitignore` | renamed `.gitignore.upstream` | upstream ignores folders it also tracks (`mods/game_bot`, `vc18/…`); the root `.gitignore` plus a small `client-pokenation/.gitignore` cover build output instead. Same convention as `client/.gitignore.upstream` |
| `.git/` | not imported | the history lives upstream; the tag and commit above identify the source |

Everything else (3,563 tracked files, 62 MB) is byte-identical to the tag; check with
`git diff --stat 17e40d7 -- client-pokenation/` against later commits.

### 1.2 Binaries in the import

| File | Status |
|---|---|
| `android/gradle/wrapper/gradle-wrapper.jar` | verified: sha256 `498495120a03b9a6ab5d155f5de3c8f0d986a449153702fb80fc80e134484f17` equals Gradle's published wrapper checksum for 8.9 (the wrapper jar is version-independent; it downloads the 8.14.2 distribution named in `gradle-wrapper.properties`, which Gradle verifies itself) |
| `*.bat` (`android/gradlew.bat`, `src/protobuf/generate.bat`, `tools/generate_git_version.bat`) | text scripts, read; not run by any PokeNation build |
| images, sounds, fonts under `data/`, `modules/`, `mods/` | assets, not executable |

## 2. Upstream build instructions (as shipped)

Upstream builds with CMake presets and vcpkg in manifest mode (`CMakePresets.json`,
`.github/workflows/reusable-build-*.yml`, `docs/building/`):

| Platform | Upstream recipe |
|---|---|
| Linux | Ubuntu 24.04, GCC 14, Ninja, vcpkg; `cmake --preset linux-release`, `cmake --build --preset linux-release` |
| Windows | Visual Studio (MSVC), Ninja, vcpkg triplet `x64-windows-static-release` (overlay in `cmake/triplets/`); preset `windows-release` |
| Android | JDK 17, Android SDK 36, NDK `29.0.13599879`, CMake 3.22.1, vcpkg triplet `arm64-android`, LuaJIT built by `build_luajit_android.sh`; `android/gradlew :app:assembleRelease`; the game data is packed into `android/app/src/main/assets/data.zip` |
| macOS, browser | presets exist; not PokeNation targets |

## 3. Stock build results (before any PokeNation change)

| Platform | Result | Notes |
|---|---|---|
| Linux x64 | **builds and starts** (2026-10-07, local, Ubuntu 24.04, GCC 14.2, CMake 3.28, Ninja) | `tools/build_pokenation_client.sh`; 34 vcpkg ports built from source (release-only triplet `x64-linux-release`). The stock binary started under Xvfb + Mesa llvmpipe and logged `OTClient - Redemption 4.x rev 0.000 (desenv)` and `Startup done :]` |
| Windows x64 | **builds** in CI (`.github/workflows/pokenation-client.yml`, run 37563373089, `PokeNation-Client-Windows-x64.zip` produced; with the PokeNation changes and Stage A assets: run 37566367616) | not run on Windows: no Windows machine available locally |
| Android arm64 | **builds** in CI (same run, `PokeNation-Android.apk` produced) | not installed on a device or emulator yet |

## 4. How PokeNation builds it

| Platform | Command | Output |
|---|---|---|
| Linux | `tools/build_pokenation_client.sh` (`BUILD_TYPE=development\|release\|debug`) | `build/client-pokenation/linux-<type>/bin/` |
| Windows | `tools\windows\Build-PokeNationClient-Windows.ps1 [-BuildType ...] [-Clean]` (Visual Studio 2022/2026 C++ workload; imports VsDevCmd itself) | `build\client-pokenation\windows-<type>\bin\` |
| Android | `tools/build_pokenation_android.sh` (JDK 17, SDK 36, NDK 29.0.13599879, `VCPKG_ROOT`) | `build/client-pokenation/android/PokeNation-Android.apk` |
| Package (Linux/Windows) | `tools/package_pokenation_client.py linux\|windows` | `dist/<platform>/client-pokenation/`, `dist/PokeNation-Client-Linux.tar.gz` / `dist/PokeNation-Client-Windows-x64.zip` + `.sha256` |

Runtime data (`data/`, `mods/`, `modules/`, `init.lua`, `otclientrc.lua`, `cacert.pem`,
`config.ini`) is collected by `tools/pack_pokenation_data.py`, for both the desktop packages and
the APK's `assets/data.zip`. The legacy client's `dist/<platform>/client` and
`PokeNation-LegacyClient-*` archives are never written by these tools.

CI (`.github/workflows/pokenation-client.yml`) runs only when the new client or its tools change
and is independent of `build.yml`, so a new-client failure cannot remove the server or legacy
client artifacts. vcpkg binaries are cached between runs as files archives. Each job also stages
the Stage A assets (`git lfs pull --include client/data/things/data.spr`, cached on the LFS object
id, then `tools/stage_pokenation_assets.py`) so the packages and the APK carry
`data/things/854/Tibia.dat/.spr`.

`VCPKG_ROOT` defaults to `~/.cache/pokenation/vcpkg` (cloned at the baseline above on first use).
Built vcpkg packages are cached in `~/.cache/pokenation/vcpkg-archives` (or wherever
`VCPKG_BINARY_SOURCES` points), so later builds only compile the client.

## 5. Upstream build problems (kept separate from PokeNation changes)

| Problem | Effect | Handling |
|---|---|---|
| Passing `-DVCPKG_BUILD_TYPE=release` on the command line does not reach vcpkg's triplet | every dependency is built twice (debug + release) | use vcpkg's `x64-linux-release` community triplet instead |
| `cmake/SharedBuildCache.cmake:1118` refuses a `VCPKG_INSTALLED_DIR` outside the build tree | cannot share one installed tree between build types | left as is; the binary cache gives the same reuse |

## 6. PokeNation modifications

Every change to upstream files is listed in [REDEMPTION_CHANGES.md](REDEMPTION_CHANGES.md), with
the reason and the PSoul source it reproduces.
