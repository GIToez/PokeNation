#!/usr/bin/env python3
"""Log the PokeNation client into a running local PSoul server under Xvfb and check the protocol.

The run uses the normal login UI (tools/pokenation_smoke/pn_smoke drives it), so it covers the
PSoul 312 profile end to end: login packet, charlist extras and poll flag, game login with
challenge, light hour, ACTIVATE and LOCALE, creature extras, channel list, walking and logout.
Screenshots (taken by the client itself; scrot only on timeout) and the client log land in the
output directory. Linux only (Xvfb).

  tools/pokenation_client_smoke.py [--client BIN] [--out DIR] [--account A --password P --character C] [--locale en|pt|es] [--market]

--market (GM character with access 5 and a seeded depot, see docs/PHASE_3_TEST_MATRIX.md C-14)
places the market NPC with /n, opens the market and runs enter -> create buy offer -> browse own
offers -> cancel -> leave.

Requires: the server running (tools/start_server.sh), Stage A assets staged
(tools/stage_pokenation_assets.py), a built client (tools/build_pokenation_client.sh).
Exit code 0 only when the mod reports "RESULT PASS".
"""
import argparse
import os
import shutil
import subprocess
import sys
import time
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
CLIENT_SRC = ROOT / "client-pokenation"
RUNTIME = ("data", "modules", "mods", "init.lua", "otclientrc.lua", "cacert.pem", "config.ini")
MARK = "[pn-smoke] "


def build_run_dir(run: Path, binary: Path) -> Path:
    if run.exists():
        shutil.rmtree(run)
    run.mkdir(parents=True)
    for name in RUNTIME:
        src = CLIENT_SRC / name
        if not src.exists():
            continue
        if src.is_dir():
            # Hard links keep the 300 MB Stage A sprite file from being copied.
            subprocess.run(["cp", "-al", str(src), str(run / name)], check=True)
        else:
            shutil.copy2(src, run / name)
    shutil.copytree(ROOT / "tools" / "pokenation_smoke" / "pn_smoke", run / "mods" / "pn_smoke")
    exe = run / "PokeNationClient"
    shutil.copy2(binary, exe)
    return exe


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("--client", default=str(ROOT / "build/client-pokenation/linux-development/bin/otclient"))
    parser.add_argument("--out", default=str(ROOT / "build/client-pokenation/smoke"))
    parser.add_argument("--account", default="admin")
    parser.add_argument("--password", default="admin")
    parser.add_argument("--character", default="Tester")
    parser.add_argument("--locale", default=None)
    parser.add_argument("--display", default=":97")
    parser.add_argument("--timeout", type=int, default=200)
    parser.add_argument("--market", action="store_true", help="also run the market round trip (GM character)")
    parser.add_argument("--shop", action="store_true", help="also run the PokeNation Shop round trip (seeded soulcoins)")
    parser.add_argument("--pokemon", action="store_true", help="also run the Pokemon UI round trip (GM character with a team)")
    args = parser.parse_args()

    binary = Path(args.client).resolve()
    if not binary.is_file():
        print(f"client binary not found: {binary}", file=sys.stderr)
        return 2
    if not (CLIENT_SRC / "data/things/854/Tibia.spr").is_file():
        print("Stage A assets missing: run tools/stage_pokenation_assets.py", file=sys.stderr)
        return 2

    out = Path(args.out).resolve()
    out.mkdir(parents=True, exist_ok=True)
    for old in out.glob("*.png"):
        old.unlink()
    run = out / "run"
    exe = build_run_dir(run, binary)
    home = out / "home"
    shutil.rmtree(home, ignore_errors=True)
    home.mkdir()

    env = dict(os.environ, DISPLAY=args.display, HOME=str(home),
               PN_SMOKE_ACCOUNT=args.account, PN_SMOKE_PASSWORD=args.password, PN_SMOKE_CHARACTER=args.character)
    if args.locale:
        env["PN_SMOKE_LOCALE"] = args.locale
    if args.market:
        env["PN_SMOKE_MARKET"] = "1"
    if args.shop:
        env["PN_SMOKE_SHOP"] = "1"
    if args.pokemon:
        env["PN_SMOKE_POKEMON"] = "1"
        args.timeout = max(args.timeout, 330)

    xvfb = subprocess.Popen(["Xvfb", args.display, "-screen", "0", "1280x800x24", "-nolisten", "tcp"],
                            stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    time.sleep(1.5)
    console = (out / "client-console.log").open("w")
    client = subprocess.Popen([str(exe)], cwd=run, env=env, stdout=console, stderr=subprocess.STDOUT)
    log_path = run / "otclient.log"

    result = None
    seen = 0
    deadline = time.time() + args.timeout
    def read_new_lines():
        nonlocal seen, result
        if not log_path.exists():
            return
        lines = log_path.read_text(errors="replace").splitlines()
        for line in lines[seen:]:
            if MARK not in line:
                continue
            text = line.split(MARK, 1)[1]
            print(text)
            if text.startswith("RESULT "):
                result = text
        seen = len(lines)

    try:
        while time.time() < deadline and result is None:
            time.sleep(0.3)
            exited = client.poll() is not None
            # Read after the exit check: the mod logs RESULT and quits right away.
            read_new_lines()
            if exited and result is None:
                print(f"client exited with code {client.returncode} before a result", file=sys.stderr)
                break
        if result is None:
            subprocess.run(["scrot", "-o", str(out / "99-timeout.png")], env=env, check=False)
    finally:
        try:
            client.wait(timeout=10)
        except subprocess.TimeoutExpired:
            client.kill()
        xvfb.terminate()
        console.close()
        if log_path.exists():
            shutil.copy2(log_path, out / "otclient.log")
        # The mod saves screenshots through g_app.doScreenshot into the user write dir.
        for png in home.rglob("pn-smoke-*.png"):
            shutil.copy2(png, out / png.name.removeprefix("pn-smoke-"))

    print(f"artifacts: {out}")
    if result is None:
        print("no result (timeout or crash)", file=sys.stderr)
        return 1
    return 0 if result.startswith("RESULT PASS") else 1


if __name__ == "__main__":
    sys.exit(main())
