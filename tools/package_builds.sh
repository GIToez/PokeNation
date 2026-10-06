#!/usr/bin/env bash
# Assemble self-contained development packages from the compiled binaries.
#   tools/package_builds.sh linux    -> dist/PokeNation-{server,client}-linux-x64.tar.gz
#   tools/package_builds.sh windows  -> dist/PokeNation-{server,client}-windows-x64.zip  (run inside MSYS2)
# Only binaries compiled from this repository are packaged; the original archive's
# precompiled executables are never used.
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/dev_env.sh"

PLATFORM="${1:-linux}"
DIST="$ROOT_DIR/dist"
rm -rf "$DIST" && mkdir -p "$DIST"

copy_server_payload() {  # $1 = destination dir
  local dst="$1"
  mkdir -p "$dst/src/schemas" "$dst/logs"
  cp -r "$SERVER_DIR/data" "$dst/"
  cp "$SERVER_DIR"/*.loc "$dst/" 2>/dev/null || true
  cp "$SERVER_DIR/config.example.lua" "$dst/"
  cp "$SERVER_DIR"/src/schemas/*.sql "$dst/src/schemas/"
  cp "$ROOT_DIR/docs/BUILDING.md" "$dst/README-BUILDING.md"
  # Never ship a real config.lua (local secrets); the start script creates it from the example.
  rm -f "$dst/config.lua"
}

copy_client_payload() {  # $1 = destination dir
  local dst="$1"
  mkdir -p "$dst"
  cp -r "$CLIENT_DIR/data" "$CLIENT_DIR/modules" "$dst/"
  cp "$CLIENT_DIR/init.lua" "$dst/"
  cp "$ROOT_DIR/docs/LOCAL_CLIENT_TESTING.md" "$dst/README-CLIENT.md" 2>/dev/null || true
}

copy_mingw_dlls() {  # $1 = exe, $2 = destination dir ; copies every /mingw64 DLL the exe needs
  local exe="$1" dst="$2"
  ldd "$exe" | awk '/mingw64/ {print $3}' | sort -u | while read -r dll; do
    cp -n "$dll" "$dst/"
  done
}

case "$PLATFORM" in
  linux)
    S="$DIST/PokeNation-server-linux-x64"; C="$DIST/PokeNation-client-linux-x64"
    copy_server_payload "$S"
    cp "$SERVER_BIN" "$S/psoul-server"
    cp "$ROOT_DIR/tools/dist/start_server.sh" "$ROOT_DIR/tools/dist/setup_database.sh" "$ROOT_DIR/tools/dist/start_database.sh" "$S/"
    copy_client_payload "$C"
    cp "$CLIENT_BIN" "$C/psoulclient"
    cp "$ROOT_DIR/tools/dist/start_client.sh" "$C/"
    chmod +x "$S"/*.sh "$C"/*.sh "$S/psoul-server" "$C/psoulclient"
    (cd "$DIST" && tar czf PokeNation-server-linux-x64.tar.gz PokeNation-server-linux-x64 && tar czf PokeNation-client-linux-x64.tar.gz PokeNation-client-linux-x64)
    ;;
  windows)
    S="$DIST/PokeNation-server-windows-x64"; C="$DIST/PokeNation-client-windows-x64"
    copy_server_payload "$S"
    cp "$SERVER_DIR/psoul-server.exe" "$S/PokeNationServer.exe"
    copy_mingw_dlls "$S/PokeNationServer.exe" "$S"
    cp "$ROOT_DIR/tools/dist/"*.bat "$S/"
    rm -f "$S/start_client.bat"
    copy_client_payload "$C"
    cp "$BUILD_DIR/client/psoulclient.exe" "$C/PokeNationClient.exe"
    copy_mingw_dlls "$C/PokeNationClient.exe" "$C"
    cp "$ROOT_DIR/tools/dist/start_client.bat" "$C/"
    (cd "$DIST" && zip -qr PokeNation-server-windows-x64.zip PokeNation-server-windows-x64 && zip -qr PokeNation-client-windows-x64.zip PokeNation-client-windows-x64)
    ;;
  *) die "unknown platform '$PLATFORM' (linux|windows)";;
esac

say "Packages written to $DIST:"
ls -la "$DIST"/*.tar.gz "$DIST"/*.zip 2>/dev/null || true
