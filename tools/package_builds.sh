#!/usr/bin/env bash
# Kept for older docs: same as tools/package.sh all (the platform argument is detected automatically).
[ "${1:-}" = linux ] || [ "${1:-}" = windows ] && shift
exec "$(dirname "${BASH_SOURCE[0]}")/package.sh" all "$@"
