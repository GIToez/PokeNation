# Large files and repository safety

GitHub rejects normal Git objects larger than 100 MB and warns above 50 MB. This document
records every file in the original archive above ~5 MB, what was done with it, and why.

## Files in the archive larger than 5 MB

| Size | Archive path | Required by | Decision |
|-----:|--------------|-------------|----------|
| 308.1 MB | `Client/data/things/data.spr` | Client (sprite sheet, needed to render anything; also the asset source for the future Redemption client) | **Git LFS** → `client/data/things/data.spr` |
| 134.2 MB | `Sources/Source client/vc12/otclient.sdf` | nothing (Visual Studio IntelliSense database) | **Not imported** |
| 129.9 MB | `PSOUL/data/world/map.otbm` | Server (the game map; the server refuses to start without it) | **Git LFS** → `server/data/world/map.otbm` (stored once; `original/` holds only its hash) |
| 21.1 MB | `Sources/Source client/vc12/Debug/vc120.pdb` | nothing (debug symbols of a stale build) | **Not imported** |
| 16.1 MB | `Client/data/images/background.psd` | nothing at runtime (Photoshop master of `background.png`) | **Git LFS** (kept as an art source) |
| 11.1 MB | `Sources/Source client/vc12/Debug/vc120.idb` | nothing | **Not imported** |
| 6.8 MB | `Sources/Source client/vc12/Debug/otclient.tlog/CL.read.1.tlog` | nothing | **Not imported** |
| 6.3 MB | `Client/Poke Aimar.exe` | prebuilt client | **Not imported** (untrusted binary, see `SECURITY_AUDIT.md`) |
| 5.7 MB | `RME - PSoul/.../RME.exe` | prebuilt map editor | **Not imported** |
| 5.6 MB | `PSOUL/PS.exe`, `PSOUL/Source Server/dev-cpp/PS.exe` | prebuilt server (two different builds) | **Not imported**; rebuilt from source instead |

No file above 50 MB is stored as a normal Git object. The three LFS-tracked patterns are declared
in the root `.gitattributes`:

```
*.otbm filter=lfs diff=lfs merge=lfs -text
*.spr  filter=lfs diff=lfs merge=lfs -text
*.psd  filter=lfs diff=lfs merge=lfs -text
```

LFS objects currently tracked (7): `data.spr` (308 MB), `map.otbm` (130 MB), `background.psd` (16 MB)
and four small UI `.psd` sources. Total LFS storage ≈ 458 MB.

Checksums of the two large runtime assets (SHA-256, first 20 hex digits; full values in
`original/ARCHIVE_MANIFEST.sha256`):

* `client/data/things/data.spr` — `ece3b1a6d9f3726e408a…`
* `server/data/world/map.otbm` — `bbcdeb9c25fc8089a165…`

## Medium-sized binary assets kept as normal Git objects

* `client/data/images/**` (≈ 71 MB, 1,688 PNG files) and `client/data/sounds/**` (≈ 51 MB, 472 OGG
  files) are genuine client assets. The largest single file is 3 MB, so they are stored as normal
  objects. If repository growth becomes a problem they can be moved to LFS later with
  `git lfs migrate`, but doing so rewrites history, so the decision was made now rather than later:
  keep them as normal objects.
* `client/data/things/data.dat` (1.6 MB), `server/data/items/items.otb` and `tools/rme/data/854/items.otb`
  (1.1 MB each) are required binary data files and are stored normally.

## What is ignored

See the root `.gitignore`. In summary: downloaded archives (`*.rar`, `*.7z`, `*.zip`…), build
output (`build/`, `bin/`, `obj/`, `*.o`, `*.exe`, `*.dll`, `*.pdb`…), IDE caches (`.idea/`, `.vs/`,
`*.sdf`, `*.suo`, `*.user`), runtime logs (`server/logs/`, `*.log`), local secrets
(`server/config.lua`, `.env`), and temporary database files (`*.s3db`, `*.sqlite`, `*.dump`).

The upstream `.gitignore` files that shipped inside the archive (OTClient's, RME's and the
server's) were renamed to `.gitignore.upstream`. OTClient's ignore list contains `*.xml`,
`*.otb`, `*.spr`, `*.dat` and `*.otbm`, which would have silently excluded most of the project.

## Working with LFS

```bash
git lfs install                     # once per machine
git clone <repo>                    # pulls LFS pointers and downloads the objects
git lfs pull                        # if objects were skipped (GIT_LFS_SKIP_SMUDGE=1)
```

The LFS objects must be present before starting the server (`map.otbm`) or the client (`data.spr`).
