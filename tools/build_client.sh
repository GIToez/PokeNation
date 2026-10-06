#!/usr/bin/env bash
# Build the PokeAimar/PSoul OTClient with CMake into build/client/psoulclient.
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/dev_env.sh"

export CC="${CC:-gcc}" CXX="${CXX:-g++}"
mkdir -p "$BUILD_DIR/client"

EXTRA=()
# Debian/Ubuntu ship libphysfs.a without an archive index, which breaks static linking;
# prefer the shared library when it exists.
for so in /usr/lib/x86_64-linux-gnu/libphysfs.so /usr/lib64/libphysfs.so /usr/lib/libphysfs.so; do
  if [ -e "$so" ]; then EXTRA+=("-DPHYSFS_LIBRARY=$so"); break; fi
done

say "Configuring client (build/client)"
cmake -S "$CLIENT_DIR/src-cpp" -B "$BUILD_DIR/client" \
  -DCMAKE_BUILD_TYPE="${BUILD_TYPE:-RelWithDebInfo}" -DUSE_STATIC_LIBS=ON -DLUAJIT=OFF \
  -DENCRYPTED_ASSETS=OFF "${EXTRA[@]}" "$@" -Wno-dev
say "Compiling client"
cmake --build "$BUILD_DIR/client" -j"$(nproc)"
say "Client binary: $CLIENT_BIN (run with tools/start_client.sh)"
