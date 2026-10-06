#!/usr/bin/env bash
# Start the locally compiled PokeAimar/PSoul client. Builds it first if missing.
# The client must run with client/ as the working directory (init.lua, data/, modules/).
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/dev_env.sh"

[ -x "$CLIENT_BIN" ] || "$ROOT_DIR/tools/build_client.sh"

if [ "$(stat -c %s "$CLIENT_DIR/data/things/data.spr" 2>/dev/null || echo 0)" -lt 1000000 ]; then
  die "client/data/things/data.spr is an LFS pointer. Run: git lfs install && git lfs pull"
fi

[ -n "${DISPLAY:-}" ] || die "DISPLAY is not set - the client needs an X11 display"

# OpenAL Soft aborts on machines without a sound device; fall back to its null backend.
if [ -z "${ALSOFT_DRIVERS:-}" ] && ! { [ -e /dev/snd ] || pgrep -x pulseaudio >/dev/null || pgrep -x pipewire >/dev/null; }; then
  export ALSOFT_DRIVERS=null
  warn "No sound device detected - running with ALSOFT_DRIVERS=null"
fi

say "Starting client (connects to 127.0.0.1:$LOGIN_PORT, protocol version 312)"
cd "$CLIENT_DIR"
exec "$CLIENT_BIN" "$@"
