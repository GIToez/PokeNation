#!/usr/bin/env python3
"""Stage A assets for the PokeNation client: copy the legacy client's data.dat / data.spr
unchanged into client-pokenation/data/things/854/Tibia.{dat,spr}, plus the legacy PSoul UI images
(client/data/images/<dir>) into client-pokenation/data/images/psoul/<dir> and the Pokemon cries into
client-pokenation/data/sounds/psoul/cries. The Pokemon UI modules (game_pokebar, game_pokedex, ...)
read them through PokeNation.IMAGES = '/images/psoul/'.

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
IMAGE_SOURCE = ROOT / "client" / "data" / "images"
IMAGE_TARGET = ROOT / "client-pokenation" / "data" / "images" / "psoul"
IMAGE_DIRS = ("ui", "types", "moveCategories", "optionstab", "advances", "pokeicons", "staticPortraits",
              "pictures", "tips", "slotMachine", "messages", "icons")
SOUND_SOURCE = ROOT / "client" / "data" / "sounds" / "cries"
SOUND_TARGET = ROOT / "client-pokenation" / "data" / "sounds" / "psoul" / "cries"


def signature(path: Path) -> int:
    with path.open("rb") as f:
        head = f.read(len(LFS_POINTER_PREFIX))
        if head.startswith(LFS_POINTER_PREFIX):
            raise SystemExit(f"{path} is a Git LFS pointer; run: git lfs pull --include {path.relative_to(ROOT)}")
        return struct.unpack("<I", head[:4])[0]


def stage_tree(src: Path, dst: Path, link: bool) -> int:
    copied = 0
    for path in sorted(src.rglob("*")):
        if not path.is_file() or path.suffix.lower() == ".psd":
            continue
        out = dst / path.relative_to(src)
        if out.exists() and out.stat().st_size == path.stat().st_size:
            continue
        out.parent.mkdir(parents=True, exist_ok=True)
        if out.exists():
            out.unlink()
        if link:
            os.link(path, out)
        else:
            shutil.copyfile(path, out)
        copied += 1
    return copied


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

    for name in IMAGE_DIRS:
        src = IMAGE_SOURCE / name
        if not src.is_dir():
            print(f"missing {src}", file=sys.stderr)
            return 1
        copied = stage_tree(src, IMAGE_TARGET / name, args.link)
        print(f"images      {(IMAGE_TARGET / name).relative_to(ROOT)}  {copied} file(s) copied")
    if SOUND_SOURCE.is_dir():
        copied = stage_tree(SOUND_SOURCE, SOUND_TARGET, args.link)
        print(f"sounds      {SOUND_TARGET.relative_to(ROOT)}  {copied} file(s) copied")
    return 0


if __name__ == "__main__":
    sys.exit(main())
