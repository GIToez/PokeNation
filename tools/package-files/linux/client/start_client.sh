#!/usr/bin/env bash
# Start the packaged legacy PokeNation (PSoul) client. It connects to 127.0.0.1:7564.
# Start the server first (start_server.sh in the server package).
set -uo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"
fail() { echo "[FAIL] $*" >&2; exit 1; }

[ -f ./psoulclient ] || fail "psoulclient missing - this folder is not a complete client package"
[ -f init.lua ] && [ -d modules ] || fail "init.lua/modules missing - run this script from the client package folder"
[ "$(wc -c < data/things/data.spr 2>/dev/null || echo 0)" -gt 1000000 ] || fail "data/things/data.spr missing or incomplete"
[ -n "${DISPLAY:-}${WAYLAND_DISPLAY:-}" ] || fail "no graphical display (DISPLAY is not set)"
(echo >/dev/tcp/127.0.0.1/7564) 2>/dev/null || echo "[WARN] nothing is listening on 127.0.0.1:7564 - start the server first, or login will fail"

if [ -z "${ALSOFT_DRIVERS:-}" ] && ! { [ -e /dev/snd ] || pgrep -x pulseaudio >/dev/null || pgrep -x pipewire >/dev/null; }; then
  export ALSOFT_DRIVERS=null   # no sound device: avoid the OpenAL abort
fi
chmod +x ./psoulclient
exec ./psoulclient "$@"
