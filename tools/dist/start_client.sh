#!/usr/bin/env bash
# Start the packaged PokeNation (PSoul) client. It connects to 127.0.0.1:7564.
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"
[ -x ./psoulclient ] || chmod +x ./psoulclient
if [ -z "${ALSOFT_DRIVERS:-}" ] && ! { [ -e /dev/snd ] || pgrep -x pulseaudio >/dev/null || pgrep -x pipewire >/dev/null; }; then
  export ALSOFT_DRIVERS=null   # no sound device: avoid the OpenAL abort
fi
exec ./psoulclient "$@"
