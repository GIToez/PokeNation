#!/usr/bin/env python3
"""Server-wide EXP event (/doubleexp) test against a running development server.

Every phase heals Trainer's Charmander at the Pewter Nurse Joy, lets GM Admin set the event state,
spawns a wild Magikarp and lets Charmander kill it. The kill's EXP is checked exactly against the
existing formulas with the event multiplier applied once at the end:

  R        = 5 * (1 + Magikarp level)          (monster experience 5, wild experienceRate 1.0)
  A        = (stage(trainer level) + extraExpRate) * 1.5 (stamina)
  trainer  = floor(r * A * event)                for each attacker share r of R
  Pokemon  = e = trunc(r) * pokemonStage(Charmander level) * 1.25;  e += floor(e * extraExpRate);  e * event

extraExpRate is 0.15 while the XP Boost potion (item 29131, 60 minutes) is active, else 0.
R is split by damage share between Charmander and Trainer's own melee hits (Creature::getDamageRatio),
so the trainer can receive two messages per kill. Checked: the trainer messages add up to
floor(R * A * event) (-1 for the two roundings), and the Pokemon EXP equals the formula for an
integer share k <= R whose trainer message is floor(r * A * event) for some r in [k, k + 1).

Phases: normal 1x, /doubleexp 2h, /doubleexp 3x 2h, 2x + XP Boost potion, /doubleexp off with a
normal player trying /doubleexp (must be ignored), and a timed /doubleexp 1m that must expire
by itself. Broadcasts and /expevent replies are checked in each phase.

Prerequisite: Trainer owns the Charmander starter (tools/smoke_test.py on a fresh database).
The test leaves the event off. Server restart persistence is not covered here (see
docs/reference/FEATURES.md, "Server EXP event"). Exit status: 0 = all passed, 1 = a check failed.
Usage:  python3 tools/exp_event_test.py [--host 127.0.0.1] [--skip-timed]
"""
import argparse
import math
import re
import subprocess
import sys
import threading
from pathlib import Path

PROBE = Path(__file__).with_name("protocol_probe.py")
NURSE_POS = (3307, 297, 7)
FIELD_POS = (3307, 305, 7)
POTION_POS = (3307, 306, 7)
SPAWN_POS = (3307, 309, 7)
CHARMANDER_ICON = 10638
XP_BOOST_SID, XP_BOOST_CID = 29131, 27887

# data/XML/stages.xml (NORMAL EXP) and doPlayerPokemonAddExperience (data/lib/ps/functions/player.lua)
TRAINER_STAGES = [(10, 5.25), (15, 4.5), (20, 3.0), (30, 2.25), (50, 1.5), (70, 0.75), (100, 0.375)]
POKEMON_STAGES = [(10, 42), (15, 30), (20, 16), (25, 9), (30, 5), (50, 3), (70, 2)]


def stage(table, level, last):
    return next((m for top, m in table if level <= top), last)


def trainer_factor(trainer_level, boost):
    return 1.0 * (stage(TRAINER_STAGES, trainer_level, 0.225) + (0.15 if boost else 0.0))


def trainer_exp(raw, trainer_level, event, boost):
    t = float(raw)
    t *= trainer_factor(trainer_level, boost)
    t *= 1.5
    t *= event
    return int(t)


def pokemon_exp(raw_int, pokemon_level, event, boost):
    p = raw_int * stage(POKEMON_STAGES, pokemon_level, 1.5)
    p = p * 1.25
    p = p + math.floor(p * (0.15 if boost else 0.0))
    return p * event


def check_kill(kill, event, boost):
    """Returns (trainer_ok, pokemon_ok, explanation)."""
    total = 5 * (1 + kill["magikarp"])
    want = trainer_exp(total, kill["trainer_level"], event, boost)
    got = sum(kill["trainer_exp"])
    trainer_ok = want - 1 <= got <= want
    share = next((k for k in range(total + 1)
                  if pokemon_exp(k, kill["pokemon_level"], event, boost) == kill["pokemon_exp"]), None)
    pokemon_ok = share is not None and any(
        trainer_exp(share, kill["trainer_level"], event, boost) <= t <= trainer_exp(share + 1, kill["trainer_level"], event, boost)
        for t in kill["trainer_exp"])
    why = (f"R={total}, trainer {kill['trainer_exp']} (sum {got}, expected {want - 1}..{want}), "
           f"Pokemon {kill['pokemon_exp']:g} (share k={share})")
    return trainer_ok, pokemon_ok, why


def probe(host, *args, timeout=150):
    cmd = [sys.executable, "-u", str(PROBE), "--host", host, *args]
    return subprocess.run(cmd, capture_output=True, text=True, timeout=timeout).stdout


def gm(host, *commands):
    args = ["enter", "--account", "admin", "--password", "admin", "--character", "GM Admin", "--settle", "1.5"]
    for c in commands:
        args += ["--say", c]
    return probe(host, *args, "--sleep", "1")


def pos_hex(x, y, z):
    return f"{x & 0xFF:02x}{x >> 8:02x}{y & 0xFF:02x}{y >> 8:02x}{z:02x}"


def run_trainer(host, before_kill, phase_gm, field_gm, verbose):
    """One Trainer session: heal, let GM set the event, kill a Magikarp. Returns the transcript."""
    args = ["enter", "-v", "--account", "player", "--password", "player", "--character", "Trainer",
            "--settle", "2",
            "--wait-pos", f"{NURSE_POS[0]},{NURSE_POS[1]}:40", "--say", "hi", "--sleep", "3",
            "--wait-pos", f"{FIELD_POS[0]},{FIELD_POS[1]}:40", "--sleep", "1", "--say", "/expevent", "--sleep", "4",
            *before_kill,
            "--call-poke", str(CHARMANDER_ICON), "--sleep", "5",
            "--attack", "Magikarp", "--wait-dead", "Magikarp:150", "--sleep", "2",
            "--say", "/expevent", "--sleep", "1",
            "--call-poke", str(CHARMANDER_ICON), "--sleep", "2"]
    proc = subprocess.Popen([sys.executable, "-u", str(PROBE), "--host", host, *args],
                            stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True)
    lines = []

    def reader():
        for line in proc.stdout:
            lines.append(line)
            if verbose:
                print("   T|", line, end="")
            if f"to be at ({NURSE_POS[0]}, {NURSE_POS[1]})" in line:
                gm(host, f"/send Trainer;{NURSE_POS[0]},{NURSE_POS[1]},{NURSE_POS[2]}")
            elif f"to be at ({FIELD_POS[0]}, {FIELD_POS[1]})" in line:
                gm(host, *phase_gm, f"/send Trainer;{FIELD_POS[0]},{FIELD_POS[1]},{FIELD_POS[2]}")
            elif f"arrived at ({FIELD_POS[0]}, {FIELD_POS[1]}" in line:
                gm(host, *field_gm, f"/goto {SPAWN_POS[0]},{SPAWN_POS[1]},{SPAWN_POS[2]}", "/m Magikarp")

    t = threading.Thread(target=reader, daemon=True)
    t.start()
    try:
        proc.wait(timeout=360)
    except subprocess.TimeoutExpired:
        proc.kill()
    t.join(5)
    return "".join(lines)


def parse_kill(log):
    """Levels and EXP of the Magikarp kill in a Trainer transcript."""
    attack = re.search(r">> attack 'Magikarp \[(\d+)\]'", log)
    if not attack:
        return None
    after = log[attack.end():]
    pmsg = re.search(r"Your Charmander received ([\d.]+) experience points", after)
    if not pmsg:
        return None
    window = after[pmsg.end():]
    nxt = re.search(r"Your Charmander received|>> ", window)
    window = window[:nxt.start()] if nxt else window
    trainer = [int(x) for x in re.findall(r"text 0x[0-9A-F]{2}: 'You received (\d+) experience point", window)]
    before = log[:attack.end() + pmsg.start()]
    pokemon_level = [int(x) for x in re.findall(r"Charmander \[(\d+)\]", before)]
    trainer_level = [int(x) for x in re.findall(r"player stats .* level=(\d+)", before)]
    if not (trainer and pokemon_level and trainer_level):
        return None
    return {"magikarp": int(attack.group(1)), "pokemon_level": pokemon_level[-1],
            "trainer_level": trainer_level[-1], "pokemon_exp": float(pmsg.group(1)), "trainer_exp": trainer}


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--host", default="127.0.0.1")
    ap.add_argument("--skip-timed", action="store_true", help="skip the 1-minute expiry phase")
    ap.add_argument("-v", "--verbose", action="store_true")
    ap.add_argument("--logs", default="/tmp", help="directory for the per-phase Trainer transcripts")
    a = ap.parse_args()

    results = []

    def check(name, ok, detail=""):
        results.append((name, ok))
        print(f"[{'PASS' if ok else 'FAIL'}] {name}" + (f" - {detail}" if detail and not ok else ""))

    potion_drop = [f"/goto {POTION_POS[0]},{POTION_POS[1]},{POTION_POS[2]}", f"/i {XP_BOOST_SID},1,true"]
    use_potion = ["--raw", "82" + pos_hex(*POTION_POS) + f"{XP_BOOST_CID & 0xFF:02x}{XP_BOOST_CID >> 8:02x}" + "0100",
                  "--sleep", "1.5"]
    phases = [
        {"name": "normal 1x", "gm": ["/doubleexp off"], "event": 1,
         "status": "There is no Experience Event active."},
        {"name": "/doubleexp 2h", "gm": ["/doubleexp 2h"], "event": 2,
         "broadcast": "Double Experience Event is now active for 2 hours!",
         "status": "Experience Event: 2x\nTime remaining: 1h 59m"},
        {"name": "/doubleexp 3x 2h", "gm": ["/doubleexp 3x 2h"], "event": 3,
         "broadcast": "3x Experience Event is now active for 2 hours!",
         "status": "Experience Event: 3x\nTime remaining: 1h 59m"},
        {"name": "2x + XP Boost potion", "gm": ["/doubleexp 2h"], "field_gm": potion_drop,
         "before_kill": use_potion, "event": 2, "potion": True,
         "broadcast": "Double Experience Event is now active for 2 hours!"},
        {"name": "/doubleexp off", "gm": ["/doubleexp off"], "event": 1,
         "before_kill": ["--say", "/doubleexp 3x 1d", "--sleep", "1"],
         "broadcast": "The Experience Event has been disabled.",
         "status": "There is no Experience Event active."},
    ]

    boost = False
    for ph in phases:
        print(f"--- phase: {ph['name']}")
        log = run_trainer(a.host, ph.get("before_kill", []), ph["gm"], ph.get("field_gm", []), a.verbose)
        out = Path(a.logs) / ("exp_event_" + re.sub(r"\W+", "_", ph["name"]).strip("_") + ".log")
        out.write_text(log)
        texts = re.findall(r"text 0x[0-9A-F]{2}: '((?:[^'\\]|\\.)*)'", log)
        texts = [t.encode().decode("unicode_escape") for t in texts]
        if re.search(r"Remaining \d+ minutes of bonus experience|Your 15% bonus experience has started", log):
            boost = True
        if ph.get("potion"):
            check(f"{ph['name']}: XP Boost potion active", boost, "potion not used and no active boost")
        if "broadcast" in ph:
            check(f"{ph['name']}: broadcast", ph["broadcast"] in texts, str(texts[-12:]))
        if "status" in ph:
            check(f"{ph['name']}: /expevent", ph["status"] in texts, str([t for t in texts if "Experience" in t]))
        if ph["name"] == "/doubleexp off":
            check("normal player cannot start an event", not any("Experience Event is now active" in t for t in texts))
        kill = parse_kill(log)
        if not kill:
            check(f"{ph['name']}: Magikarp kill with EXP messages", False,
                  "no kill (Charmander fainted or the Magikarp was out of reach); see -v")
            continue
        trainer_ok, pokemon_ok, why = check_kill(kill, ph["event"], boost)
        detail = (f"Magikarp [{kill['magikarp']}], trainer level {kill['trainer_level']}, Charmander "
                  f"[{kill['pokemon_level']}], boost={boost}: {why}")
        print(f"    {detail}")
        check(f"{ph['name']}: trainer EXP x{ph['event']}", trainer_ok, detail)
        check(f"{ph['name']}: Pokemon EXP x{ph['event']}", pokemon_ok, detail)

    if not a.skip_timed:
        print("--- phase: /doubleexp 1m (expiry)")
        args = ["enter", "-v", "--account", "player", "--password", "player", "--character", "Trainer",
                "--settle", "2", "--wait-text", "Double Experience Event is now active for 1 minute!:30",
                "--say", "/expevent", "--sleep", "1",
                "--wait-text", "The Double Experience Event has ended.:100",
                "--say", "/expevent", "--sleep", "1"]
        proc = subprocess.Popen([sys.executable, "-u", str(PROBE), "--host", a.host, *args],
                                stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True)
        threading.Timer(6, gm, (a.host, "/doubleexp 1m")).start()
        log = proc.communicate(timeout=200)[0]
        texts = [t.encode().decode("unicode_escape") for t in re.findall(r"text 0x[0-9A-F]{2}: '((?:[^'\\]|\\.)*)'", log)]
        check("1m: start broadcast", "Double Experience Event is now active for 1 minute!" in texts)
        check("1m: /expevent while active",
              any(re.match(r"Experience Event: 2x\nTime remaining: (\d+s|1m)$", t) for t in texts),
              str([t for t in texts if "Experience" in t]))
        check("1m: ends by itself", "The Double Experience Event has ended." in texts)
        check("1m: /expevent after expiry", texts.count("There is no Experience Event active.") >= 1,
              str([t for t in texts if "Experience" in t]))

    failed = [n for n, ok in results if not ok]
    print(f"\n{len(results) - len(failed)}/{len(results)} checks passed")
    return 1 if failed else 0


if __name__ == "__main__":
    sys.exit(main())
