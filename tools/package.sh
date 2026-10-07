#!/usr/bin/env bash
# Assemble runnable packages from binaries compiled from this repository.
#   tools/package.sh server|client|all [--no-archive]
#   BUILD_TYPE=development|release|debug   (must match the build; default development)
#
# Output (generated, git-ignored):
#   dist/<platform>/server/   dist/<platform>/client/          development + release builds
#   dist/debug/<platform>/server/ ...                          debug builds (symbols kept)
#   dist/PokeNation-Server-<Platform>-<Dev|Release|Debug>.{zip|tar.gz} (+ .sha256)
#   dist/PokeNation-LegacyClient-<Platform>-<...>.{zip|tar.gz}          (+ .sha256)
# Archives unpack to PokeNation/server and PokeNation/client, so extracting both archives into the
# same folder gives the layout Start-PokeNation-Local expects.
#
# Never packaged: C++ sources, CMake trees, object files, server/config.lua (local secrets),
# runtime logs, and nothing at all from the original archive's precompiled executables.
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/dev_env.sh"

WHAT="${1:-all}"
ARCHIVE=1
[ "${2:-}" = "--no-archive" ] && ARCHIVE=0
case "$WHAT" in server|client|all) ;; *) die "usage: tools/package.sh server|client|all [--no-archive]";; esac

if [ "$BUILD_TYPE" = debug ]; then PKG_ROOT="$DIST_ROOT/debug/$PLATFORM"; else PKG_ROOT="$DIST_ROOT/$PLATFORM"; fi
FILES="$ROOT_DIR/tools/package-files/$PLATFORM"
PLATFORM_TITLE="$( [ "$PLATFORM" = windows ] && echo Windows || echo Linux )"
BUILD_DATE="$(date -u +%Y-%m-%dT%H:%M:%SZ)"

write_version() {  # $1 = package dir, $2 = component, $3 = executable name
  cat > "$1/version.json" <<EOF
{
  "product": "PokeNation",
  "component": "$2",
  "version": "$POKENATION_VERSION",
  "commit": "$GIT_SHA",
  "worktree_modified": $( [ -n "$GIT_DIRTY" ] && echo true || echo false ),
  "build_type": "$BUILD_TYPE",
  "cmake_build_type": "$CMAKE_BUILD_TYPE",
  "platform": "$PLATFORM-x64",
  "executable": "$3",
  "build_date": "$BUILD_DATE"
}
EOF
  printf 'PokeNation %s (%s) %s %s build\ncommit %s\nbuilt %s\n' "$POKENATION_VERSION" "$2" "$PLATFORM" "$BUILD_TYPE" "$GIT_SHA" "$BUILD_DATE" > "$1/VERSION.txt"
}

install_exe() {  # $1 = built binary, $2 = destination path
  [ -x "$1" ] || die "$1 not found - build first (tools/build_${3}.sh, BUILD_TYPE=$BUILD_TYPE)"
  cp "$1" "$2"
  # Packages for normal use carry no debug symbols; the unstripped binary stays in build/.
  if [ "$BUILD_TYPE" != debug ] && command -v strip >/dev/null; then strip --strip-debug "$2"; fi
  chmod +x "$2"
}

copy_runtime_dlls() {  # $1 = exe ; copies every MSYS2 /mingw64 DLL the exe loads (recursively via ldd)
  local exe="$1" dst; dst="$(dirname "$1")"
  ldd "$exe" | awk 'tolower($3) ~ /mingw64/ {print $3}' | sort -u | while read -r dll; do cp -n "$dll" "$dst/"; done
  local n; n=$(find "$dst" -maxdepth 1 -iname '*.dll' | wc -l)
  [ "$n" -gt 0 ] || warn "no DLLs copied next to $(basename "$exe") - static build?"
}

lfs_check() {  # $1 = file that must be a real asset, not a Git LFS pointer
  [ "$(wc -c < "$1")" -gt 1000000 ] || die "$1 is a Git LFS pointer - run: git lfs install && git lfs pull"
}

archive() {  # $1 = component dir (server|client), $2 = archive base name
  [ "$ARCHIVE" = 1 ] || return 0
  local stage; stage="$(mktemp -d)"
  mkdir -p "$stage/PokeNation"
  cp -a "$PKG_ROOT/$1" "$stage/PokeNation/$1"
  local out
  if [ "$PLATFORM" = windows ]; then
    out="$DIST_ROOT/$2.zip"; rm -f "$out"
    (cd "$stage" && zip -qr "$out" PokeNation)
  else
    out="$DIST_ROOT/$2.tar.gz"; rm -f "$out"
    tar -C "$stage" -czf "$out" PokeNation
  fi
  rm -rf "$stage"
  (cd "$DIST_ROOT" && sha256sum "$(basename "$out")" > "$(basename "$out").sha256")
  say "$(basename "$out")  sha256 $(cut -d' ' -f1 "$out.sha256")"
}

package_server() {
  local S="$PKG_ROOT/server"
  say "Packaging server -> ${S#$ROOT_DIR/}"
  lfs_check "$SERVER_DIR/data/world/map.otbm"
  rm -rf "$S"; mkdir -p "$S/database" "$S/logs"
  install_exe "$SERVER_BIN" "$S/$PKG_SERVER_EXE" server
  cp -r "$SERVER_DIR/data" "$S/"
  rm -f "$S"/data/npc/tmpCitizen_*.xml            # regenerated at every start (027-citizens.lua)
  find "$S/data" -name '*.log' -delete
  cp "$SERVER_DIR"/*.loc "$S/"
  cp "$SERVER_DIR/config.example.lua" "$S/"
  cp "$SERVER_DIR"/src/schemas/mysql.sql "$SERVER_DIR"/src/schemas/psoul_extra_mysql.sql "$SERVER_DIR"/src/schemas/psoul_dev_seed.sql "$S/database/"
  cp "$SERVER_DIR/src/doc/LICENSE" "$S/LICENSE-server.txt"
  cp -r "$FILES/server/." "$S/"
  [ "$PLATFORM" = windows ] && copy_runtime_dlls "$S/$PKG_SERVER_EXE"
  [ "$PLATFORM" = linux ] && chmod +x "$S"/*.sh
  write_version "$S" server "$PKG_SERVER_EXE"
  [ ! -e "$S/config.lua" ] || die "config.lua must never be packaged"
  archive server "PokeNation-Server-$PLATFORM_TITLE-$PKG_SUFFIX"
}

package_client() {
  local C="$PKG_ROOT/client"
  say "Packaging legacy client -> ${C#$ROOT_DIR/}"
  lfs_check "$CLIENT_DIR/data/things/data.spr"
  rm -rf "$C"; mkdir -p "$C"
  install_exe "$CLIENT_BIN" "$C/$PKG_CLIENT_EXE" client
  cp -r "$CLIENT_DIR/data" "$CLIENT_DIR/modules" "$CLIENT_DIR/init.lua" "$C/"
  find "$C/data" -iname '*.psd' -delete          # Photoshop sources, never loaded by the client
  cp "$CLIENT_DIR/LICENSE" "$C/LICENSE-client.txt"
  cp -r "$FILES/client/." "$C/"
  [ "$PLATFORM" = windows ] && copy_runtime_dlls "$C/$PKG_CLIENT_EXE"
  [ "$PLATFORM" = linux ] && chmod +x "$C"/*.sh
  write_version "$C" legacy-client "$PKG_CLIENT_EXE"
  archive client "PokeNation-LegacyClient-$PLATFORM_TITLE-$PKG_SUFFIX"
}

mkdir -p "$DIST_ROOT"
[ "$WHAT" = client ] || package_server
[ "$WHAT" = server ] || package_client
say "Done. Packages in ${PKG_ROOT#$ROOT_DIR/}/, archives in dist/"
