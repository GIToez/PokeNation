#!/usr/bin/env bash
# Run every PokeNation client GUI smoke scenario against a running local server and collect the
# screenshots, client logs and RESULT lines in one directory (the CI artifact
# PokeNation-Phase3-Screenshots). Each scenario starts from tools/pokenation_smoke/seed_smoke.sql.
#
#   tools/pokenation_gui_smoke_ci.sh [--client BIN] [--out DIR]
#
# Scenarios: default login + polls (Tester), --shop (Tester), --pokemon and --market (GM Admin),
# and the two-client TV round trip (GM Admin records on :97, Trainer watches on :98).
# The Pokemon scenario depends on random catch/battle rolls, so a failed run is retried once.
# Exit code 0 only when every scenario reports RESULT PASS.
set -uo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/dev_env.sh"

CLIENT="$ROOT_DIR/build/client-pokenation/linux-development/bin/otclient"
OUT="$ROOT_DIR/build/client-pokenation/gui-smoke"
while [ $# -gt 0 ]; do
  case "$1" in
    --client) CLIENT="$2"; shift 2 ;;
    --out) OUT="$2"; shift 2 ;;
    *) die "unknown argument: $1" ;;
  esac
done

SMOKE="$ROOT_DIR/tools/pokenation_client_smoke.py"
SEED="$ROOT_DIR/tools/pokenation_smoke/seed_smoke.sql"
mkdir -p "$OUT"
SUMMARY="$OUT/results.txt"
: > "$SUMMARY"
failed=0

reseed() { mysql_app "$DB_NAME" < "$SEED"; }

record() {
  local name="$1" log="$2" rc="$3"
  local line
  line="$(grep -E '^RESULT ' "$log" | tail -n1)"
  [ -n "$line" ] || line="RESULT FAIL no result (exit $rc)"
  printf '%-10s %s\n' "$name" "$line" | tee -a "$SUMMARY"
  [ "$rc" = 0 ] || failed=1
}

# scenario NAME ATTEMPTS ARGS...
scenario() {
  local name="$1" attempts="$2"; shift 2
  local dir="$OUT/$name" rc=1 attempt
  for attempt in $(seq 1 "$attempts"); do
    reseed
    say "scenario $name (attempt $attempt)"
    python3 "$SMOKE" --client "$CLIENT" --out "$dir" "$@" > "$dir.log" 2>&1 && rc=0 || rc=$?
    cat "$dir.log"
    [ "$rc" = 0 ] && break
  done
  rm -rf "$dir/run" "$dir/home"
  mv "$dir.log" "$dir/result.log"
  record "$name" "$dir/result.log" "$rc"
}

scenario default 1
scenario shop 1 --shop
scenario pokemon 2 --pokemon --character "GM Admin"
scenario market 1 --market --character "GM Admin"

reseed
say "scenario tv (record on :97, watch on :98)"
python3 "$SMOKE" --client "$CLIENT" --out "$OUT/tv-record" --display :97 --tv record --character "GM Admin" \
  > "$OUT/tv-record.log" 2>&1 &
recorder=$!
sleep 20
python3 "$SMOKE" --client "$CLIENT" --out "$OUT/tv-watch" --display :98 --tv watch \
  --account player --password player --character Trainer > "$OUT/tv-watch.log" 2>&1 && wrc=0 || wrc=$?
wait "$recorder" && rrc=0 || rrc=$?
for side in record watch; do
  rc="$rrc"; [ "$side" = watch ] && rc="$wrc"
  cat "$OUT/tv-$side.log"
  rm -rf "$OUT/tv-$side/run" "$OUT/tv-$side/home"
  mv "$OUT/tv-$side.log" "$OUT/tv-$side/result.log"
  record "tv-$side" "$OUT/tv-$side/result.log" "$rc"
done

echo "---- summary ----"
cat "$SUMMARY"
exit "$failed"
