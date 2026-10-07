#!/usr/bin/env python3
"""Collect the PokeNation client runtime data (Lua modules, data, mods, init scripts).

  tools/pack_pokenation_data.py --android <out/data.zip>   # zip for the Android APK assets
  tools/pack_pokenation_data.py --dir <out/dir>            # plain copy for desktop packages

Only runtime files are taken from client-pokenation/: data/, mods/, modules/ and the
top-level init.lua, otclientrc.lua, cacert.pem, config.ini. Large game assets that are not
tracked in Git (data/things/<version>/, data/sounds/<x>/) are included when present locally.
"""
import argparse
import shutil
import sys
import zipfile
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SRC = ROOT / "client-pokenation"
DIRS = ("data", "mods", "modules")
FILES = ("init.lua", "otclientrc.lua", "cacert.pem", "config.ini")
SKIP_NAMES = {".gitignore", ".gitkeep", ".DS_Store", "Thumbs.db"}


def runtime_files(src: Path):
    for d in DIRS:
        root = src / d
        if not root.is_dir():
            sys.exit(f"missing runtime directory: {root}")
        for path in sorted(root.rglob("*")):
            if path.is_file() and path.name not in SKIP_NAMES:
                yield path
    for name in FILES:
        path = src / name
        if path.is_file():
            yield path


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    mode = ap.add_mutually_exclusive_group(required=True)
    mode.add_argument("--android", metavar="ZIP", type=Path, help="write a data.zip for the APK")
    mode.add_argument("--dir", metavar="DIR", type=Path, help="copy the runtime files into DIR")
    ap.add_argument("--src", type=Path, default=SRC, help="client source tree (default: client-pokenation/)")
    args = ap.parse_args()

    src = args.src.resolve()
    files = list(runtime_files(src))
    if args.android:
        args.android.parent.mkdir(parents=True, exist_ok=True)
        with zipfile.ZipFile(args.android, "w", zipfile.ZIP_DEFLATED) as zf:
            for path in files:
                zf.write(path, path.relative_to(src).as_posix())
        print(f"wrote {args.android} ({len(files)} files, {args.android.stat().st_size} bytes)")
    else:
        for path in files:
            dest = args.dir / path.relative_to(src)
            dest.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(path, dest)
        print(f"copied {len(files)} files into {args.dir}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
