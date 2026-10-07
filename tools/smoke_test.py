#!/usr/bin/env python3
"""Gameplay smoke test against a running development server.

Requires a database freshly initialised from the seed (tools/init_dev_database.sh --reset)
because it plays the new-player path of the seeded character "Trainer":

  1. login of every seeded account (admin, player) and rejection of a wrong password; the
     login-protocol guards: out-of-range language byte (BUG-08), PokeNation client OS without a
     language byte (BUG-09), wrong login challenge (BUG-68), ACTIVATE/LOCALE extended opcodes
  2. Trainer enters the game; GM Admin teleports him to Professor Oak
  3. Oak gives the Charmander starter
  4. GM Admin teleports Trainer outside the Pewter protection zone and spawns a wild Magikarp
  5. Trainer summons Charmander from the Pokemon bar (the starter ball lands in the pokebag,
     not in the ball slot), attacks, uses moves m1/m2, waits for the kill
  6. Trainer throws a Poke Ball at the corpse (a catch *attempt*; success is random)
  7. Trainer returns Charmander and logs out

Each step is checked against the exact server messages verified in Phase 2
(docs/PHASE_2_TEST_MATRIX.md P2-01, P2-02, P2-04, P2-05, P2-06, P2-09).
Exit status: 0 = every check passed; 1 = at least one check failed; 2 = no failures, but the
starter fainted before the kill (a random battle outcome), so the defeat and catch checks were
skipped. Run it again on a fresh database to cover them.
Usage:  python3 tools/smoke_test.py [--host 127.0.0.1]
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
WILD_POS = (3307, 308, 7)
# Wild levels are random within minLevel..maxLevel of the monster XML. Magikarp (20 hp, melee 10,
# levels 1-5) is the only species that can never outlevel the level-5 starter; a Rattata (the
# Phase 2 P2-09 opponent) or a level-9 Caterpie sometimes knocked Charmander out first.
WILD = "Magikarp"
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

    def skip(name, reason):
        results.append((name, None))
        print(f"[SKIP] {name} - {reason}")

    out = probe(a.host, "login", "--account", "admin", "--password", "admin")
    check("login admin/admin lists GM Admin and Tester", "'GM Admin'" in out and "'Tester'" in out, out[-300:])
    out = probe(a.host, "login", "--account", "player", "--password", "player")
    check("login player/player lists Trainer", "'Trainer'" in out, out[-300:])
    out = probe(a.host, "login", "--account", "admin", "--password", "not-the-password")
    check("wrong password is rejected", "Invalid password" in out, out[-300:])
    out = probe(a.host, "login", "--account", "admin", "--password", "admin", "--lang", "99")
    check("out-of-range language byte is ignored (BUG-08)", "'GM Admin'" in out, out[-300:])
    out = probe(a.host, "--os", "0x14", "login", "--account", "admin", "--password", "admin")
    check("PokeNation client OS logs in without a language byte (BUG-09)",
          "'GM Admin'" in out and "level=100" in out, out[-300:])
    out = probe(a.host, "enter", "--account", "admin", "--password", "admin", "--character", "GM Admin",
                "--settle", "1.5", "--bad-challenge")
    check("wrong login challenge is refused (BUG-68)", "<< in game:" not in out, out[-300:])
    out = probe(a.host, "--os", "0x14", "enter", "--account", "admin", "--password", "admin",
                "--character", "GM Admin", "--settle", "1.5", "-v",
                "--ext", "1:9", "--ext", "1:xx", "--ext", "1:1", "--ext", "1:0", "--say", "/online")
    check("PokeNation client gets ACTIVATE and survives malformed LOCALE opcodes",
          "extended opcode 0: ''" in out and "<< in game:" in out and "connection closed" not in
          out.split(">> logout")[0], out[-300:])

    trainer_args = [
        "enter", "--account", "player", "--password", "player", "--character", "Trainer",
        "--wait-pos", f"{OAK_POS[0]},{OAK_POS[1]}:40",
        "--say", "hi", "--npc", "charmander", "--npc", "yes", "--npc", "male",
        "--wait-text", "You received a Charmander:15",
        "--wait-pos", f"{FIELD_POS[0]},{FIELD_POS[1]}:40",
        "--call-poke", CHARMANDER_ICON,
        "--sleep", "8",
        "--attack", WILD,
        "--say", "m1", "--sleep", "2", "--say", "m2", "--sleep", "2", "--say", "m1",
        "--wait-dead", f"{WILD}:120",
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
                gm(a.host, f"/goto {WILD_POS[0]},{WILD_POS[1]},{WILD_POS[2]}", f"/m {WILD}")

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
    # POKEMON_CALL_MESSAGES in data/lib/ps/functions/others.lua (one is picked at random)
    check("summon Charmander", re.search(r"Charmander, (go!|I choose you!|it's time to work!|I need your help!|it's the battle time!)", log) is not None)
    check("move used (m1/m2)", re.search(r"Charmander, (Tackle|Scratch|Ember|Growl)!", log) is not None)
    won = f"Loot of a {WILD}" in log
    # The fight itself is random (wild level, damage rolls). A starter that faints first leaves its
    # bar icon marked FNT; that is a game outcome, not a server fault, so it is reported as SKIP.
    fainted = "'FNT')" in log or "This ball is discharged." in log
    if not won and fainted and re.search(r"Your Charmander deals \d+ damage", log):
        reason = "Charmander fainted before the kill (random battle outcome); damage was dealt"
        skip(f"wild {WILD} defeated", reason)
        skip("catch attempt resolved", "no corpse to throw the ball at")
    else:
        check(f"wild {WILD} defeated", won)
        check("catch attempt resolved", re.search(r"Gotcha!|Your poke ball broke|wasted \d+ poke ball", log) is not None)
    # POKEMON_BACK_MESSAGES in data/lib/ps/functions/ball/inUse.lua
    check("return Charmander", re.search(r"Charmander, (thanks!|back!|nice work!|that's enough)", log) is not None)
    check("logout", ">> logout" in log)

    failed = [n for n, ok in results if ok is False]
    skipped = [n for n, ok in results if ok is None]
    if not a.verbose and (failed or skipped):
        print("---- Trainer transcript ----")
        print(log)
    passed = len(results) - len(failed) - len(skipped)
    print(f"\n{passed}/{len(results)} checks passed" + (f", {len(skipped)} skipped" if skipped else ""))
    return 1 if failed else (2 if skipped else 0)


if __name__ == "__main__":
    sys.exit(main())
