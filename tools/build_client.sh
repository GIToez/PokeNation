#!/usr/bin/env bash
# Build the frozen legacy PSoul/PokeAimar client (OTClient 0.6 fork, client/src-cpp) with CMake.
#   tools/build_client.sh [--clean] [extra cmake -D options]
#   BUILD_TYPE=development|release|debug   (default development)
# Output: build/<platform>-<type>/client/psoulclient[.exe]
# Build settings only; the client's behaviour is frozen (docs/LEGACY_CLIENT_REFERENCE.md).
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/dev_env.sh"

CLEAN=0
if [ "${1:-}" = "--clean" ]; then CLEAN=1; shift; fi

OUT="$BUILD_DIR/client"
[ "$CLEAN" = 1 ] && { say "Cleaning $OUT"; rm -rf "$OUT"; }
mkdir -p "$OUT"

ARGS=(-DCMAKE_BUILD_TYPE="$CMAKE_BUILD_TYPE" -DUSE_STATIC_LIBS=ON -DLUAJIT=OFF -DENCRYPTED_ASSETS=OFF -Wno-dev)
if [ "$PLATFORM" = windows ]; then
  ARGS+=(-G Ninja)
else
  export CC="${CC:-gcc}" CXX="${CXX:-g++}"
  # Debian/Ubuntu ship libphysfs.a without an archive index, which breaks static linking;
  # prefer the shared library when it exists.
  for so in /usr/lib/x86_64-linux-gnu/libphysfs.so /usr/lib64/libphysfs.so /usr/lib/libphysfs.so; do
    if [ -e "$so" ]; then ARGS+=("-DPHYSFS_LIBRARY=$so"); break; fi
  done
fi

say "Configuring legacy client ($PLATFORM, $BUILD_TYPE -> $CMAKE_BUILD_TYPE) in ${OUT#$ROOT_DIR/}"
cmake -S "$CLIENT_DIR/src-cpp" -B "$OUT" "${ARGS[@]}" "$@" || die "CMake configure failed (missing dependencies? see docs/BUILDING.md section 1)"
say "Compiling legacy client"
cmake --build "$OUT" -j"$(njobs)" || die "Client compilation failed"
[ -x "$CLIENT_BIN" ] || die "Build finished but $CLIENT_BIN is missing"
say "Client binary: ${CLIENT_BIN#$ROOT_DIR/} (run with tools/start_client.sh)"
