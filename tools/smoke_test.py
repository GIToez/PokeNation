#!/usr/bin/env python3
"""Gameplay smoke test against a running development server.

Requires a database freshly initialised from the seed (tools/init_dev_database.sh --reset)
because it plays the new-player path of the seeded character "Trainer":

  1. login of every seeded account (admin, player) and rejection of a wrong password
  2. Trainer enters the game; GM Admin teleports him to Professor Oak
  3. Oak gives the Charmander starter
  4. GM Admin teleports Trainer outside the Pewter protection zone and spawns a wild Rattata
  5. Trainer summons Charmander from the Pokemon bar (the starter ball lands in the pokebag,
     not in the ball slot), attacks, uses moves m1/m2, waits for the kill
  6. Trainer throws a Poke Ball at the corpse (a catch *attempt*; success is random)
  7. Trainer returns Charmander and logs out

Each step is checked against the exact server messages verified in Phase 2
(docs/PHASE_2_TEST_MATRIX.md P2-01, P2-02, P2-04, P2-05, P2-06, P2-09).
Exit status 0 = every check passed. Usage:  python3 tools/smoke_test.py [--host 127.0.0.1]
"""
import argparse
import re
import subprocess
import sys
import threading
import time
from pathlib import Path

PROBE = Path(__file__).with_name("protocol_probe.py")
OAK_POS = (5020, 789, 7)
# outside the Pewter protection zone; the same tiles as Phase 2 test t09 (P2-09)
FIELD_POS = (3307, 305, 7)
RATTATA_POS = (3307, 308, 7)
# client item id of Charmander's Pokemon-bar icon; clicking it sends "/cp N" (summon / return)
CHARMANDER_ICON = "10638"


def probe(host, *args, timeout=90):
    cmd = [sys.executable, "-u", str(PROBE), "--host", host, *args]
    return subprocess.run(cmd, capture_output=True, text=True, timeout=timeout).stdout


def gm(host, *commands):
    args = ["enter", "--account", "admin", "--password", "admin", "--character", "GM Admin", "--settle", "1.5"]
    for c in commands:
        args += ["--say", c]
    return probe(host, *args)


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--host", default="127.0.0.1")
    ap.add_argument("-v", "--verbose", action="store_true", help="print the full Trainer transcript")
    a = ap.parse_args()

    results = []

    def check(name, ok, detail=""):
        results.append((name, ok))
        print(f"[{'PASS' if ok else 'FAIL'}] {name}" + (f" - {detail}" if detail and not ok else ""))

    out = probe(a.host, "login", "--account", "admin", "--password", "admin")
    check("login admin/admin lists GM Admin and Tester", "'GM Admin'" in out and "'Tester'" in out, out[-300:])
    out = probe(a.host, "login", "--account", "player", "--password", "player")
    check("login player/player lists Trainer", "'Trainer'" in out, out[-300:])
    out = probe(a.host, "login", "--account", "admin", "--password", "not-the-password")
    check("wrong password is rejected", "Invalid password" in out, out[-300:])

    trainer_args = [
        "enter", "--account", "player", "--password", "player", "--character", "Trainer",
        "--wait-pos", f"{OAK_POS[0]},{OAK_POS[1]}:40",
        "--say", "hi", "--npc", "charmander", "--npc", "yes", "--npc", "male",
        "--wait-text", "You received a Charmander:15",
        "--wait-pos", f"{FIELD_POS[0]},{FIELD_POS[1]}:40",
        "--call-poke", CHARMANDER_ICON,
        "--sleep", "8",
        "--attack", "Rattata",
        "--say", "m1", "--sleep", "2", "--say", "m2", "--sleep", "2", "--say", "m1",
        "--wait-dead", "Rattata:120",
        "--open", "10", "--catch", "12157", "--sleep", "3",
        "--call-poke", CHARMANDER_ICON, "--sleep", "2",
    ]
    proc = subprocess.Popen([sys.executable, "-u", str(PROBE), "--host", a.host, *trainer_args],
                            stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True)
    lines = []

    def reader():
        for line in proc.stdout:
            lines.append(line)
            if a.verbose:
                print("   T|", line, end="")
            if f"to be at ({OAK_POS[0]}, {OAK_POS[1]})" in line:
                gm(a.host, f"/send Trainer;{OAK_POS[0]},{OAK_POS[1]},{OAK_POS[2]}")
            elif f"to be at ({FIELD_POS[0]}, {FIELD_POS[1]})" in line:
                gm(a.host, f"/send Trainer;{FIELD_POS[0]},{FIELD_POS[1]},{FIELD_POS[2]}")
            elif f"arrived at ({FIELD_POS[0]}, {FIELD_POS[1]}" in line:
                gm(a.host, f"/goto {RATTATA_POS[0]},{RATTATA_POS[1]},{RATTATA_POS[2]}", "/m Rattata")

    t = threading.Thread(target=reader, daemon=True)
    t.start()
    try:
        proc.wait(timeout=300)
    except subprocess.TimeoutExpired:
        proc.kill()
    t.join(5)
    log = "".join(lines)

    check("Trainer enters the game", "<< in game:" in log)
    check("GM /send reaches Professor Oak", f"arrived at ({OAK_POS[0]}, {OAK_POS[1]}" in log)
    check("Oak gives the starter", "You received a Charmander" in log)
    check("summon Charmander", re.search(r"Charmander, (go|I choose you|it's the battle time|I need your help)", log) is not None)
    check("move used (m1/m2)", re.search(r"Charmander, (Tackle|Scratch|Ember|Growl)!", log) is not None)
    check("wild Rattata defeated", "Loot of a Rattata" in log)
    check("catch attempt resolved", re.search(r"Gotcha!|Your poke ball broke|wasted \d+ poke ball", log) is not None)
    # POKEMON_BACK_MESSAGES in data/lib/ps/functions/ball/inUse.lua
    check("return Charmander", re.search(r"Charmander, (thanks!|back!|nice work!|that's enough)", log) is not None)
    check("logout", ">> logout" in log)

    if not a.verbose and not all(ok for _, ok in results):
        print("---- Trainer transcript ----")
        print(log)
    failed = [n for n, ok in results if not ok]
    print(f"\n{len(results) - len(failed)}/{len(results)} checks passed")
    return 1 if failed else 0


if __name__ == "__main__":
    sys.exit(main())
