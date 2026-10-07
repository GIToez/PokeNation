#!/usr/bin/env bash
# Reproducible import of the original PSoul / PokeAimar package into this repository.
#
# Usage:
#   tools/import_original.sh /path/to/extracted/Projeto
#
# The archive (Projeto.rar, Google Drive id 1V0CHaBpqVtnwxzvZjQI-X7F985_kduE2) must be
# extracted first, e.g.:   7z x Projeto.rar -o/tmp/extract
#
# What this script does (see docs/SOURCE_AUDIT.md "Import layout" for the rationale):
#   original/   untouched reference copy of source/data (text + small binaries only)
#   server/     working copy of the game server (C++ source, data, config)
#   client/     working copy of the OTClient-based "Poke Aimar" client (Lua modules, data, C++ source)
#   tools/rme/  Remere's Map Editor fork used by the project (source + PSoul 8.54 item profile)
#
# It deliberately EXCLUDES: *.exe, *.dll, *.a, *.lib, *.res, *.pdb, *.sdf, object files,
# nested .git directories, IDE caches, and redundant nested archives (corelib.rar, Por Hora.rar).
set -euo pipefail

SRC="${1:?path to extracted Projeto directory}"
REPO="$(cd "$(dirname "$0")/.." && pwd)"

[ -d "$SRC/PSOUL" ] || { echo "not an extracted Projeto directory: $SRC" >&2; exit 1; }

BIN_EXCLUDES=(
  --exclude='*.exe' --exclude='*.dll' --exclude='*.a' --exclude='*.lib' --exclude='*.res'
  --exclude='*.pdb' --exclude='*.idb' --exclude='*.sdf' --exclude='*.opensdf' --exclude='*.o' --exclude='*.obj'
  --exclude='*.tlog' --exclude='*.suo' --exclude='*.user' --exclude='.git/' --exclude='.idea/'
  --exclude='Thumbs.db' --exclude='desktop.ini'
)

mkdir -p "$REPO/original/server" "$REPO/original/client" "$REPO/server" "$REPO/client" "$REPO/tools"

echo "== server source"
rsync -a "${BIN_EXCLUDES[@]}" --exclude='dev-cpp/obj/' \
  "$SRC/PSOUL/Source Server/" "$REPO/original/server/source/"
rsync -a "${BIN_EXCLUDES[@]}" --exclude='dev-cpp/obj/' \
  "$SRC/PSOUL/Source Server/" "$REPO/server/src/"

echo "== server data"
# The 130 MB map is stored once (server/data/world, tracked by Git LFS); original/ keeps a hash manifest instead.
rsync -a "${BIN_EXCLUDES[@]}" --exclude='world/map.otbm' \
  "$SRC/PSOUL/data/" "$REPO/original/server/data/"
rsync -a "${BIN_EXCLUDES[@]}" \
  "$SRC/PSOUL/data/" "$REPO/server/data/"

echo "== server root files"
for f in config.lua pt_br.loc settings.sav; do
  cp -p "$SRC/PSOUL/$f" "$REPO/original/server/$f"
  cp -p "$SRC/PSOUL/$f" "$REPO/server/$f"
done
rsync -a "$SRC/PSOUL/logs/" "$REPO/original/server/logs/"

echo "== client (runtime package: lua modules + data)"
rsync -a "${BIN_EXCLUDES[@]}" --exclude='modules/corelib.rar' --exclude='libtest.def' \
  "$SRC/Client/" "$REPO/client/"
# reference copy of the text parts of the client only (no sprites/images/sounds)
rsync -a "${BIN_EXCLUDES[@]}" --exclude='modules/corelib.rar' --exclude='libtest.def' \
  --exclude='data/things/' --exclude='data/images/' --exclude='data/sounds/' \
  "$SRC/Client/" "$REPO/original/client/"

echo "== client C++ source"
rsync -a "${BIN_EXCLUDES[@]}" --exclude='vc12/Debug/' --exclude='vc12/Release/' \
  "$SRC/Sources/Source client/" "$REPO/client/src-cpp/"
rsync -a "${BIN_EXCLUDES[@]}" --exclude='vc12/Debug/' --exclude='vc12/Release/' \
  "$SRC/Sources/Source client/" "$REPO/original/client/src-cpp/"

echo "== map editor (source + PSoul 8.54 profile only)"
RME="$SRC/RME - PSoul/Remeres Map Editor By Senhor"
rsync -a "${BIN_EXCLUDES[@]}" --exclude='dependencies/' --exclude='data/' \
  "$RME/" "$REPO/tools/rme/"
mkdir -p "$REPO/tools/rme/data"
cp -p "$RME/data/clients.xml" "$RME/data/menubar.xml" "$REPO/tools/rme/data/"
rsync -a "$RME/data/854/" "$REPO/tools/rme/data/854/"

echo "== design documents"
rsync -a --exclude='Remeres Map Editor By Senhor/' --exclude='*.rar' \
  "$SRC/RME - PSoul/" "$REPO/original/design-docs/"

echo "== neutralise nested upstream .gitignore files (they would hide *.xml/*.otb/*.spr/etc.)"
find "$REPO/original" "$REPO/server" "$REPO/client" "$REPO/tools/rme" -name .gitignore -type f \
  -exec sh -c 'mv -f "$1" "$1.upstream"' _ {} \;

echo "done"
