#!/usr/bin/env bash
# Build the PokeNation client (OTClient Redemption 4.1 based, client-pokenation/) on Linux.
#   tools/build_pokenation_client.sh [--clean] [extra cmake -D options]
#   BUILD_TYPE=development|release|debug   (default development)
#   VCPKG_ROOT=<vcpkg checkout>             (default ~/.cache/pokenation/vcpkg, cloned on first use)
# Output: build/client-pokenation/linux-<type>/bin/ (see docs/REDEMPTION_BASELINE.md §4)
# Windows uses tools/windows/Build-PokeNationClient-Windows.ps1 (MSVC), Android tools/build_pokenation_android.sh.
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/dev_env.sh"
[ "$PLATFORM" = linux ] || die "this script builds on Linux; on Windows use tools/windows/Build-PokeNationClient-Windows.ps1"

CLEAN=0
if [ "${1:-}" = "--clean" ]; then CLEAN=1; shift; fi

SRC="$ROOT_DIR/client-pokenation"
OUT="$ROOT_DIR/build/client-pokenation/linux-$BUILD_TYPE"
VCPKG_BASELINE="$(python3 -c 'import json,sys; print(json.load(open(sys.argv[1]))["builtin-baseline"])' "$SRC/vcpkg.json")"
export VCPKG_ROOT="${VCPKG_ROOT:-$HOME/.cache/pokenation/vcpkg}"
export VCPKG_DEFAULT_BINARY_CACHE="${VCPKG_DEFAULT_BINARY_CACHE:-$HOME/.cache/pokenation/vcpkg-archives}"
mkdir -p "$VCPKG_DEFAULT_BINARY_CACHE"

if [ ! -x "$VCPKG_ROOT/vcpkg" ]; then
  say "Bootstrapping vcpkg $VCPKG_BASELINE into $VCPKG_ROOT"
  [ -d "$VCPKG_ROOT/.git" ] || git clone -q https://github.com/microsoft/vcpkg.git "$VCPKG_ROOT" || die "cannot clone vcpkg"
  git -C "$VCPKG_ROOT" fetch -q origin "$VCPKG_BASELINE" || true
  git -C "$VCPKG_ROOT" checkout -q "$VCPKG_BASELINE" || die "cannot check out vcpkg baseline $VCPKG_BASELINE"
  "$VCPKG_ROOT/bootstrap-vcpkg.sh" -disableMetrics >/dev/null || die "vcpkg bootstrap failed"
fi

# Redemption needs GCC >= 14 (C++23); Ubuntu 24.04: apt install gcc-14 g++-14.
if [ -z "${CXX:-}" ]; then
  if command -v g++-14 >/dev/null; then export CC=gcc-14 CXX=g++-14; else export CC=gcc CXX=g++; fi
fi
command -v ninja >/dev/null || die "ninja is missing (apt install ninja-build)"

[ "$CLEAN" = 1 ] && { say "Cleaning $OUT"; rm -rf "$OUT"; }
mkdir -p "$OUT"

say "Configuring PokeNation client (linux, $BUILD_TYPE -> $CMAKE_BUILD_TYPE) in ${OUT#$ROOT_DIR/}"
cmake -S "$SRC" -B "$OUT" -G Ninja \
  -DCMAKE_TOOLCHAIN_FILE="$VCPKG_ROOT/scripts/buildsystems/vcpkg.cmake" \
  -DVCPKG_TARGET_TRIPLET=x64-linux-release -DVCPKG_HOST_TRIPLET=x64-linux-release \
  -DVCPKG_INSTALL_OPTIONS="--clean-packages-after-build;--clean-buildtrees-after-build" \
  -DCMAKE_BUILD_TYPE="$CMAKE_BUILD_TYPE" -DOTCLIENT_BUILD_TESTS=OFF -DOPTIONS_ENABLE_IPO=OFF \
  -DTOGGLE_BIN_FOLDER=ON -Wno-dev "$@" || die "CMake configure failed (vcpkg log: $OUT/vcpkg-manifest-install.log)"
say "Compiling PokeNation client"
cmake --build "$OUT" -j"$(njobs)" || die "PokeNation client compilation failed"
BIN="$(find "$OUT/bin" -maxdepth 1 -type f -executable \( -name PokeNationClient -o -name otclient \) | head -n1)"
[ -n "$BIN" ] || die "Build finished but no client executable in ${OUT#$ROOT_DIR/}/bin"
say "PokeNation client binary: ${BIN#$ROOT_DIR/}"
