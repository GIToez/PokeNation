# original/ — untouched reference copy

This directory preserves the PSoul / PokeAimar package exactly as it was received
(`Projeto.rar`, Google Drive id `1V0CHaBpqVtnwxzvZjQI-X7F985_kduE2`, 277,469,662 bytes,
archive contents dated 2020-08-04). **Nothing in this directory is ever edited.**
The working copies live in `/server`, `/client` and `/tools/rme`.

| Path | Origin inside the archive | Notes |
|------|---------------------------|-------|
| `server/source/` | `Projeto/PSOUL/Source Server/` | C++ server source, Dev-C++/Code::Blocks project files, SQL schemas, mods, docs. Excludes `dev-cpp/obj/*.o`, `PS.exe`, `project/PO_private.res`, nested `.git/`. |
| `server/source-uncommitted-vs-bitbucket-77be843.patch` | derived | The nested `.git` held one commit (`77be843 "iniciando projeto"`, 2020-06-10, remote `bitbucket.org/romulo_junges/pokespace-source`). This is the whitespace-insensitive diff between that commit and the shipped working tree. |
| `server/data/` | `Projeto/PSOUL/data/` | All scripts, XML, monsters, NPCs, items, spawns, houses. Excludes `.idea/` and `world/map.otbm` (130 MB; stored once in `/server/data/world/` via Git LFS). |
| `server/config.lua`, `pt_br.loc`, `settings.sav` | `Projeto/PSOUL/` | Original runtime configuration, Portuguese localization table, saved GUI settings. |
| `server/logs/` | `Projeto/PSOUL/logs/` | Logs from the packager's last run (2020-08-04); useful as a reference of what the original binary printed at startup. |
| `client/` | `Projeto/Client/` | OTClient-based "Poke Aimar" client: `init.lua`, `modules/`, `data/` **text parts only** (no `things/`, `images/`, `sounds/`). Excludes `Poke Aimar.exe`, DLLs, `libtest.a`, and `modules/corelib.rar` (a stale duplicate of `modules/corelib/`). |
| `client/src-cpp/` | `Projeto/Sources/Source client/` | OTClient C++ source + VS2013 project. Excludes `vc12/Debug/`, `otclient.sdf` (134 MB IntelliSense cache), `*.user`. |
| `design-docs/` | `Projeto/RME - PSoul/*.docx,*.xlsx,*.txt,tutoriais/` | Original Portuguese design documents (balancing spreadsheet, TM list, PvP/GvG rules, tutorials). Excludes `tutoriais/Por Hora.rar` (duplicate of the extracted `Por Hora/` folder). |
| `ARCHIVE_MANIFEST.sha256` | derived | SHA-256 of **every** file in the archive, including the binaries that were intentionally not imported. |

Binaries that were present in the archive and intentionally **not** imported
(hashes are in `ARCHIVE_MANIFEST.sha256`; see `docs/SECURITY_AUDIT.md`):

* `PSOUL/PS.exe`, `PSOUL/Source Server/dev-cpp/PS.exe` — prebuilt Windows server (two different builds).
* `PSOUL/*.dll` — MinGW/MySQL/OpenSSL/libxml2/Lua runtime DLLs for the Windows binary.
* `PSOUL/Large Address Aware.exe` — third-party PE patcher.
* `Client/Poke Aimar.exe`, `Client/*.dll` — prebuilt client and ANGLE/DirectX DLLs.
* `RME - PSoul/Remeres Map Editor By Senhor/RME.exe`, `*.dll`, `dependencies/` — prebuilt map editor; the editor source and the PSoul 8.54 item profile were imported to `/tools/rme`.
* `Sources/Source client/vc12/Debug/` — Visual Studio intermediate files.
