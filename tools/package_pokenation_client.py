#!/usr/bin/env python3
"""Package the PokeNation client (client-pokenation/) into a runtime-only archive.

  tools/package_pokenation_client.py linux   [--build-type development]
  tools/package_pokenation_client.py windows [--build-type development]

Input : build/client-pokenation/<platform>-<type>/bin/{PokeNationClient,otclient}[.exe]
Stage : dist/<platform>/client-pokenation/   (executable + runtime data, nothing else)
Output: dist/PokeNation-Client-Linux.tar.gz        + .sha256
        dist/PokeNation-Client-Windows-x64.zip     + .sha256
The legacy client packages (dist/<platform>/client, PokeNation-LegacyClient-*) are never touched.
"""
import argparse
import hashlib
import os
import shutil
import subprocess
import sys
import tarfile
import zipfile
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
EXE_NAMES = ("PokeNationClient", "otclient", "OTClient")
ARCHIVES = {"linux": "PokeNation-Client-Linux.tar.gz", "windows": "PokeNation-Client-Windows-x64.zip"}


def find_exe(bin_dir: Path, platform: str) -> Path:
    suffix = ".exe" if platform == "windows" else ""
    for name in EXE_NAMES:
        path = bin_dir / f"{name}{suffix}"
        if path.is_file():
            return path
    sys.exit(f"no client executable in {bin_dir} (build it first)")


def sha256(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("platform", choices=sorted(ARCHIVES))
    ap.add_argument("--build-type", default=os.environ.get("BUILD_TYPE", "development"))
    args = ap.parse_args()

    bin_dir = ROOT / "build" / "client-pokenation" / f"{args.platform}-{args.build_type}" / "bin"
    exe = find_exe(bin_dir, args.platform)
    stage = ROOT / "dist" / args.platform / "client-pokenation"
    if stage.exists():
        shutil.rmtree(stage)
    stage.mkdir(parents=True)

    target = stage / ("PokeNationClient.exe" if args.platform == "windows" else "PokeNationClient")
    shutil.copy2(exe, target)
    if args.platform == "linux":
        target.chmod(0o755)
        if shutil.which("strip") and args.build_type != "debug":
            subprocess.run(["strip", "--strip-debug", str(target)], check=False)
    subprocess.run([sys.executable, str(ROOT / "tools" / "pack_pokenation_data.py"), "--dir", str(stage)], check=True)
    for doc in ("LICENSE",):
        src = ROOT / "client-pokenation" / doc
        if src.is_file():
            shutil.copy2(src, stage / "LICENSE-OTClient-Redemption.txt")

    archive = ROOT / "dist" / ARCHIVES[args.platform]
    top = "PokeNation-Client"
    if args.platform == "linux":
        with tarfile.open(archive, "w:gz") as tf:
            tf.add(stage, arcname=top)
    else:
        with zipfile.ZipFile(archive, "w", zipfile.ZIP_DEFLATED) as zf:
            for path in sorted(stage.rglob("*")):
                if path.is_file():
                    zf.write(path, f"{top}/{path.relative_to(stage).as_posix()}")
    digest = sha256(archive)
    Path(f"{archive}.sha256").write_text(f"{digest}  {archive.name}\n")
    print(f"{archive.relative_to(ROOT)}  {archive.stat().st_size} bytes  sha256 {digest}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
