#!/usr/bin/env bash
# Syntax-check every Lua and XML file under server/ (and optionally other paths).
# Usage: tools/check_syntax.sh [paths...]      (default: server/data server/config.example.lua)
# Requires: luac5.1 (apt: lua5.1) and xmllint (apt: libxml2-utils).
set -u
paths=("$@"); [ ${#paths[@]} -eq 0 ] && paths=(server/data server/config.example.lua)
lua_fail=0; xml_fail=0; lua_n=0; xml_n=0
while IFS= read -r -d '' f; do
  lua_n=$((lua_n+1))
  if ! luac5.1 -p "$f" 2>/tmp/luac.err; then lua_fail=$((lua_fail+1)); echo "LUA  $(cat /tmp/luac.err)"; fi
done < <(find "${paths[@]}" -type f -name '*.lua' -print0)
while IFS= read -r -d '' f; do
  xml_n=$((xml_n+1))
  if ! xmllint --noout "$f" 2>/tmp/xml.err; then xml_fail=$((xml_fail+1)); echo "XML  $f: $(head -1 /tmp/xml.err)"; fi
done < <(find "${paths[@]}" -type f -name '*.xml' -print0)
echo "Lua: $lua_n files, $lua_fail with syntax errors; XML: $xml_n files, $xml_fail malformed"
[ $((lua_fail+xml_fail)) -eq 0 ]
