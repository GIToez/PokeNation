#!/usr/bin/env python3
"""Pokemon energy regression test (BUG-05) against a running development server.

Pokemon energy is the trainer's mana. GM groups (4-6) have PlayerFlag_HasInfiniteMana, so their
mana never changes; before the fix every move failed with "insufficient energy" and the client
showed 0/0. This test checks:

  1. GM Admin's summoned Venusaur passes the energy check for moves m1-m7 (no "insufficient
     energy"; without a target, m1-m6 are either used (area moves) or stop at the later
     "First get a target" check), the stats
     packet reports full energy (N/N, N > 0) while it is out, and the move cooldown still applies
     (m7, Sleep Powder, needs no target; the second m7 is answered with "exhaust").
  2. The normal player "Trainer" still spends energy: after a move the stats packet shows less
     than the maximum.

Prerequisites: GM Admin owns a healthy Venusaur (one is created with /mypokemon if not) and Trainer
owns the Charmander starter (run tools/smoke_test.py on a fresh database first; check 2 is
skipped otherwise). Exit status: 0 = all checks passed, 1 = a check failed, 2 = check 2 skipped.
Usage:  python3 tools/energy_test.py [--host 127.0.0.1]
"""
import argparse
import ast
import re
import subprocess
import sys
import time
from pathlib import Path

PROBE = Path(__file__).with_name("protocol_probe.py")
FIELD_POS = (3307, 305, 7)
GM_POS = (3307, 308, 7)
CHARMANDER_ICON = 10638
GM_POKEMON = "Venusaur,100"
VENUSAUR_ICON = 10637


def probe(host, *args, timeout=120):
    cmd = [sys.executable, "-u", str(PROBE), "--host", host, *args]
    return subprocess.run(cmd, capture_output=True, text=True, timeout=timeout).stdout


def gm(host, *extra):
    return probe(host, "enter", "--account", "admin", "--password", "admin", "--character", "GM Admin",
                 "--settle", "1.5", *extra)


def bar_icons(out):
    m = re.search(r"=== Pokémon bar icons === (\{.*\})", out)
    return ast.literal_eval(m.group(1)) if m else {}


def healthy_icon(out, wanted=None):
    for icon, state in bar_icons(out).values():
        if state.endswith("%") and (wanted is None or icon == wanted):
            return icon
    return None


def energies(out):
    return [(int(a), int(b)) for a, b in re.findall(r"player stats .* energy=(\d+)/(\d+)", out)]


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--host", default="127.0.0.1")
    a = ap.parse_args()

    results = []

    def check(name, ok, detail=""):
        results.append((name, ok))
        print(f"[{'PASS' if ok else 'FAIL'}] {name}" + (f" - {detail}" if detail and not ok else ""))

    # 1. GM Pokemon energy
    out = gm(a.host, "--say", f"/goto {GM_POS[0]},{GM_POS[1]},{GM_POS[2]}", "--sleep", "1")
    icon = healthy_icon(out, VENUSAUR_ICON)
    if icon is None:
        out = gm(a.host, "--say", f"/mypokemon {GM_POKEMON}", "--sleep", "2")
        icon = healthy_icon(out, VENUSAUR_ICON)
    check("GM Admin has a healthy Venusaur", icon is not None, str(bar_icons(out)))
    if icon is not None:
        moves = []
        for i in range(1, 7):
            moves += ["--say", f"m{i}", "--sleep", "0.8"]
        out = gm(a.host, "-v", "--call-poke", str(icon), "--sleep", "4", *moves,
                 "--say", "m7", "--sleep", "1", "--say", "m7", "--sleep", "1",
                 "--call-poke", str(icon), "--sleep", "2")
        answers = re.findall(r"text 0x1A: '([^']*)'", out)
        check("GM moves pass the energy check", "insufficient energy" not in out,
              "; ".join(a for a in answers if "insufficient" in a))
        said = re.findall(r"'GM Admin' \(lvl \d+\) says type=0x13: 'Venusaur, ([^']+)!'", out)
        # area moves need no target and are used; the others stop at the later target check
        check("GM moves m1-m6 get past the energy check", len(said) + answers.count("First get a target.") >= 6,
              f"used={said} answers={answers}")
        # Sleep Powder's cooldown is ~100 s; a rerun inside that window finds it still cooling down
        check("GM Pokemon used a move (or it is still cooling down)", bool(said) or "is exhaust (" in out)
        check("GM move cooldown still applies", "is exhaust (" in out, str(answers))
        full = [e for e in energies(out) if e[1] > 0]
        check("GM energy shown as full while summoned", bool(full) and all(e == m for e, m in full), str(full[:5]))

    # 2. normal player energy is still spent
    out = probe(a.host, "enter", "--account", "player", "--password", "player", "--character", "Trainer", "--settle", "1")
    if healthy_icon(out, CHARMANDER_ICON) is None:
        results.append(("Trainer spends energy", None))
        print("[SKIP] Trainer spends energy - Trainer has no healthy Charmander (run tools/smoke_test.py first)")
    else:
        trainer = subprocess.Popen(
            [sys.executable, "-u", str(PROBE), "--host", a.host, "enter", "-v", "--account", "player",
             "--password", "player", "--character", "Trainer", "--settle", "2",
             "--call-poke", str(CHARMANDER_ICON), "--sleep", "10", "--attack", "Magikarp",
             "--say", "m1", "--sleep", "1", "--say", "m2", "--sleep", "1.5",
             "--stop-attack", "--call-poke", str(CHARMANDER_ICON), "--sleep", "2"],
            stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True)
        time.sleep(3)
        gm(a.host, "--say", f"/send Trainer;{FIELD_POS[0]},{FIELD_POS[1]},{FIELD_POS[2]}",
           "--say", f"/goto {GM_POS[0]},{GM_POS[1]},{GM_POS[2]}", "--say", "/m Magikarp", "--sleep", "1")
        log = trainer.communicate(timeout=120)[0]
        used = re.search(r"'Trainer' \(lvl \d+\) says type=0x13: 'Charmander, [^']+!'", log) is not None
        spent = [e for e in energies(log) if 0 < e[1] and e[0] < e[1]]
        check("Trainer Charmander used a move", used)
        check("Trainer spends energy", used and bool(spent), str(energies(log)[-5:]))

    failed = [n for n, ok in results if ok is False]
    skipped = [n for n, ok in results if ok is None]
    print(f"\n{len(results) - len(failed) - len(skipped)}/{len(results)} checks passed"
          + (f", {len(skipped)} skipped" if skipped else ""))
    return 1 if failed else (2 if skipped else 0)


if __name__ == "__main__":
    sys.exit(main())
