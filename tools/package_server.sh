#!/usr/bin/env bash
# Package the server for the current platform (see tools/package.sh for the layout).
#   tools/package_server.sh [--no-archive]      BUILD_TYPE=development|release|debug
exec "$(dirname "${BASH_SOURCE[0]}")/package.sh" server "$@"
