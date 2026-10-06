#!/usr/bin/env bash
# Build the legacy client for windows. Run inside an MSYS2 MINGW64 shell, or use tools/windows/Build-PokeNation-Windows.ps1 from PowerShell.
#   tools/build_legacy_client_windows.sh [--clean] [cmake options]      BUILD_TYPE=development|release|debug
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/dev_env.sh"
[ "$PLATFORM" = windows ] || die "this script builds for windows but this shell is $PLATFORM"
exec "$ROOT_DIR/tools/build_client.sh" "$@"
