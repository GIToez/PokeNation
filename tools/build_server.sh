#!/usr/bin/env bash
# Build the PSoul server with CMake into build/server/. The binary is written to
# server/psoul-server (the server resolves config.lua and data/ relative to its CWD).
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/dev_env.sh"

export CC="${CC:-gcc}" CXX="${CXX:-g++}"   # some images point c++ at a broken alternative
mkdir -p "$BUILD_DIR/server"
say "Configuring server (build/server)"
cmake -S "$SERVER_DIR" -B "$BUILD_DIR/server" -DCMAKE_BUILD_TYPE="${BUILD_TYPE:-RelWithDebInfo}" "$@"
say "Compiling server"
cmake --build "$BUILD_DIR/server" -j"$(nproc)"
say "Server binary: $SERVER_BIN"
