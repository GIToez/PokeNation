#!/usr/bin/env bash
# Build the PSoul/PokeNation game server from server/ with CMake.
#   tools/build_server.sh [--clean] [extra cmake -D options]
#   BUILD_TYPE=development|release|debug   (default development)
# Output: build/<platform>-<type>/server/psoul-server[.exe]  (Linux, or Windows inside MSYS2 MINGW64)
# The server is started with server/ as working directory (tools/start_server.sh).
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/dev_env.sh"

CLEAN=0
if [ "${1:-}" = "--clean" ]; then CLEAN=1; shift; fi

OUT="$BUILD_DIR/server"
[ "$CLEAN" = 1 ] && { say "Cleaning $OUT"; rm -rf "$OUT"; }
mkdir -p "$OUT"

ARGS=(-DCMAKE_BUILD_TYPE="$CMAKE_BUILD_TYPE")
if [ "$PLATFORM" = windows ]; then
  # Ninja is what CI uses; ROOT_PERMISSION is a POSIX-only check.
  ARGS+=(-G Ninja -DROOT_PERMISSION=OFF)
else
  export CC="${CC:-gcc}" CXX="${CXX:-g++}"   # some images point c++ at a broken alternative
fi

say "Configuring server ($PLATFORM, $BUILD_TYPE -> $CMAKE_BUILD_TYPE) in ${OUT#$ROOT_DIR/}"
cmake -S "$SERVER_DIR" -B "$OUT" "${ARGS[@]}" "$@" || die "CMake configure failed (missing dependencies? see docs/BUILDING.md section 1)"
say "Compiling server"
cmake --build "$OUT" -j"$(njobs)" || die "Server compilation failed"
[ -x "$SERVER_BIN" ] || die "Build finished but $SERVER_BIN is missing"
say "Server binary: ${SERVER_BIN#$ROOT_DIR/}"
