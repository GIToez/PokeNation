#!/usr/bin/env bash
# Build the server for linux. Run on Linux (Ubuntu 24.04 tested).
#   tools/build_server_linux.sh [--clean] [cmake options]      BUILD_TYPE=development|release|debug
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/dev_env.sh"
[ "$PLATFORM" = linux ] || die "this script builds for linux but this shell is $PLATFORM"
exec "$ROOT_DIR/tools/build_server.sh" "$@"
