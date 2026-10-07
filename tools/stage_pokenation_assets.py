#!/usr/bin/env python3
"""Stage A assets for the PokeNation client: copy the legacy client's data.dat / data.spr
unchanged into client-pokenation/data/things/854/Tibia.{dat,spr}.

The files are not remapped or converted (docs/REDEMPTION_CHANGES.md section 5). The target
directory is git-ignored; packaging (tools/package_pokenation_client.py, tools/pack_pokenation_data.py)
picks it up when present. data.spr is a Git LFS object: run `git lfs pull --include
client/data/things/data.spr` first, the script refuses LFS pointer files.

Usage: tools/stage_pokenation_assets.py [--link]
  --link  hard-link instead of copying (same filesystem only; saves 300 MB locally)
"""
import argparse
import os
import shutil
import struct
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SOURCE = ROOT / "client" / "data" / "things"
TARGET = ROOT / "client-pokenation" / "data" / "things" / "854"
FILES = (("data.dat", "Tibia.dat"), ("data.spr", "Tibia.spr"))
LFS_POINTER_PREFIX = b"version https://git-lfs"


def signature(path: Path) -> int:
    with path.open("rb") as f:
        head = f.read(len(LFS_POINTER_PREFIX))
        if head.startswith(LFS_POINTER_PREFIX):
            raise SystemExit(f"{path} is a Git LFS pointer; run: git lfs pull --include {path.relative_to(ROOT)}")
        return struct.unpack("<I", head[:4])[0]


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("--link", action="store_true", help="hard-link instead of copying")
    args = parser.parse_args()

    TARGET.mkdir(parents=True, exist_ok=True)
    for src_name, dst_name in FILES:
        src = SOURCE / src_name
        dst = TARGET / dst_name
        if not src.is_file():
            print(f"missing {src}", file=sys.stderr)
            return 1
        sig = signature(src)
        if dst.exists() and dst.stat().st_size == src.stat().st_size and signature(dst) == sig:
            print(f"up to date  {dst.relative_to(ROOT)}  signature 0x{sig:08X}")
            continue
        if dst.exists():
            dst.unlink()
        if args.link:
            os.link(src, dst)
        else:
            shutil.copyfile(src, dst)
        print(f"staged      {dst.relative_to(ROOT)}  {src.stat().st_size} bytes  signature 0x{sig:08X}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
