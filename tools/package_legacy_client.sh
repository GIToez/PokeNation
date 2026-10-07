#!/usr/bin/env bash
# Package the frozen legacy client for the current platform (see tools/package.sh for the layout).
#   tools/package_legacy_client.sh [--no-archive]      BUILD_TYPE=development|release|debug
exec "$(dirname "${BASH_SOURCE[0]}")/package.sh" client "$@"
