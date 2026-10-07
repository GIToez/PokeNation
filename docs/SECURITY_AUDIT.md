# Security audit of the imported PSoul / PokeAimar package

Scope: the Google Drive archive `Projeto.rar` (277,469,662 bytes) as recorded in
`original/ARCHIVE_MANIFEST.sha256`, and the working copies under `/server`, `/client`,
`/tools/rme`. Method: static inspection only. **No binary from the archive was executed**, and no
shell script from the archive was run. The server used for verification was compiled from the
imported C++ source with the build described in `BUILDING.md`.

## 1. Executables and libraries found in the archive (all treated as untrusted)

None of these files was imported into the repository; `.gitignore` also blocks `*.exe`, `*.dll`,
`*.rar`, `*.7z`, `*.zip`. Hashes (SHA-256) are in `original/ARCHIVE_MANIFEST.sha256`.

| Archive path | Kind | Decision / reason |
|--------------|------|-------------------|
| `PSOUL/PS.exe` (5.6 MB) and `PSOUL/Source Server/dev-cpp/PS.exe` (different hash) | prebuilt Windows server | **Excluded.** Rebuilt from source instead, so nothing depends on them. Hashes: `5c39a174…`, `e05deedb…`. |
| `PSOUL/*.dll` (`iconv`, `libeay32`, `libgcc_s_dw2-1`, `libgmp-3`, `libgmpxx-4`, `libiconv-2`, `libiconv2`, `libmysql`, `libsqlite3-0`, `libssp-0`, `libxml2`, `libxml2-2`, `lua5.1`, `lua51`, `mysql`, `sqlite3`, `zlib1`) | MinGW / MySQL / OpenSSL / libxml2 / Lua runtime DLLs | **Excluded.** Replaced by distribution packages on Linux. |
| `PSOUL/Large Address Aware.exe` | third-party PE patcher (sets the LAA flag on `PS.exe`) | **Excluded.** Not needed on 64-bit Linux. Hash `7c8f166f…`. |
| `Client/Poke Aimar.exe` (6.3 MB) | prebuilt OTClient fork | **Excluded.** The client C++ source was imported (`client/src-cpp`) for later rebuilding. Hash `78067728…`. |
| `Client/d3dcompiler_43.dll`, `d3dx9_43.dll`, `libEGL.dll`, `libGLESv2.dll` | DirectX / ANGLE redistributables | **Excluded.** |
| `RME - PSoul/Remeres Map Editor By Senhor/RME.exe`, `archive.dll`, `iconv.dll`, `libxml2.dll`, `zlib1.dll`, `dependencies/` | prebuilt map editor | **Excluded.** The RME source tree and the PSoul 8.54 item profile were imported into `tools/rme`. |
| `Sources/Source client/vc12/Debug/*` (`.obj`, `.pdb`, `.idb`, `.tlog`) | Visual Studio intermediates | **Excluded** (build artefacts). |
| `PSOUL/Source Server/dev-cpp/obj/*.o`, `project/PO_private.res` | MinGW objects / compiled resource | **Excluded.** |
| `Client/modules/corelib.rar`, `RME - PSoul/tutoriais/Por Hora.rar` | nested archives | **Excluded.** Both were opened and compared: `corelib.rar` is a stale copy of `modules/corelib/`; `Por Hora.rar` duplicates the extracted folder next to it. |
| `PSOUL/Source Server/.git/` | nested Git repository (remote `bitbucket.org/romulo_junges/pokespace-source`, one commit) | **Excluded** as a repository; the diff between that commit and the shipped tree is preserved as `original/server/source-uncommitted-vs-bitbucket-77be843.patch`. The remote URL recorded during import (`original/README.md`) carries no embedded credentials. |

Script files in the archive: `Source Server/autogen.sh` (`autoreconf -vfi`),
`Source Server/debianfix.sh` (public-domain OTServ helper that rewrites Boost includes with
`sed`), `RME/tools/convert_png2cpp.py` (upstream RME asset tool). All three were read; none was
executed; none does anything beyond its stated purpose. No `.bat`, `.cmd`, `.vbs`, `.ps1`
files exist in the archive.

## 2. Network behaviour of the server source

| Finding | Location | Assessment |
|---------|----------|------------|
| Remote fetch of `http://forgottenserver.otland.net/blacklist.xml` (stock TFS IP blacklist) | `src/game.cpp:6052` (`Game::fetchBlacklist`), call site `src/otserv.cpp:625-640` | **Disabled**: the call site is inside a `/* … */` block in the original source. Verified at runtime: startup makes no outbound request. Left as is. |
| Status protocol (`0xFF`, server-list info) | `src/otserv.cpp:877` | **Disabled** in the original (commented out). No listener on `statusPort`. |
| Admin protocol (`0xFE`) with `data/XML/admin.xml`: `enabled="1"`, `onlylocalhost="0"`, `loginrequired="1"`, `loginpassword="159753"`, no encryption | `data/XML/admin.xml`, `src/admin.cpp` | **Not compiled** (`__OTADMIN__` undefined in the Makefile and in `CMakeLists.txt`); verified: only ports 7564 and 8548 listen. The weak hard-coded admin password is still in the data tree. **Recommendation:** if the admin protocol is ever enabled, change the password, set `onlylocalhost="1"` and require RSA encryption. |
| Multi-world server list with a hard-coded public IP `192.99.251.233:7172` ("Yellow") and a commented second world `192.254.73.118` | `data/XML/servers.xml` | Only read when compiled with `__LOGIN_SERVER__` (not the case). Historical hosting address of the original project; harmless but should be replaced before any multi-world deployment. |
| Original author's public IP and dyndns name in a comment: `ip = "127.0.0.1"--"191.179.192.219"--"khjyr.servegame.com"` | `server/config.example.lua:88` | Comment only; nothing connects to it. Kept for provenance, flagged here. |
| `system("pause")` | `src/otserv.cpp:257` | Windows-only console helper inside `#ifdef`. |
| Lua `loadstring` | `data/lib/002-wait.lua` (stock TFS coroutine helper), `data/lib/ps/functions/others.lua:566` (`executeInArea`, evaluates code strings written by script authors) | Not reachable from player input; no talkaction evaluates arbitrary Lua. |
| Lua `os.exit()` | `data/talkactions/scripts/shutdown.lua` | Part of the staff `/shutdown` command (access-restricted). |
| Player-input SQL | `data/npc/scripts/*`, `data/lib/ps/**`, `src/iodatalog.cpp` | Free-text input that reaches SQL is escaped (`coupon.lua` uses `db.escapeString(param)`; C++ datalog uses `escapeString`/`escapeBlob`); everything else interpolates numbers (GUIDs, positions, item ids). One defence-in-depth gap: `systems/049-eliteFour.lua:273` interpolates the Pokémon nickname without escaping, but nicknames are restricted to `[a-z ]` (4–20 chars) by `isNickAcceptable` in `soulTrade.lua`, so it is not exploitable as shipped. Left unchanged, recorded for Phase 2. |
| No `os.execute`, `io.popen`, `package.loadlib`, sockets or HTTP clients in server Lua | — | — |

## 3. Client source (`/client`)

| Finding | Location | Assessment |
|---------|----------|------------|
| Website links opened in the system browser: `pokenordic.com/accounts/create`, `pokenordic.com/accounts/lostAccount`, `psoul.net/players/createCharacter`, `psoul.net/accounts/donate` | `modules/client_entergame/*.otui` | Static `g_platform.openUrl` calls; the sites belong to the original project and are presumably dead. Replace with your own URLs before shipping a client. |
| "Remember password": account and password stored in `config.otml` encrypted with a per-machine UUID (`g_crypt.encrypt`) | `modules/client_entergame/entergame.lua:38,108-109` | Standard OTClient behaviour, local only; nothing is sent anywhere except the game server. |
| Machine UUID generation | `modules/client/client.lua:93-96` | Standard OTClient; used only as the key above. |
| Login/game port defaults `7564`, protocol version `312` | `modules/client_entergame/entergame.lua`, `modules/gamelib/protocollogin.lua` | Expected. |
| No auto-updater, no file downloads, no telemetry, no remote Lua loading | searched `g_http`, `HttpRequest`, `downloadFile`, `autoupdate`, `updater` | none present (OTClient 0.6 has no HTTP stack). |
| Extended-opcode id `103` registered by `game_shop/shop.lua` outside the documented id table | `modules/game_shop/shop.lua` | Functional oddity, not a security issue. |
| **Hard-coded AES key and IV for the "encrypted assets" layer** (added in Phase 2) | `src-cpp/src/framework/util/crypt.cpp:516-517` (`Crypt::__aesDecrypt`), compiled only with `-DENCRYPTED_ASSETS=ON`; see `LOCAL_CLIENT_TESTING.md §4` | The key/IV literals are in the public source, so the asset encryption is obfuscation only. Our builds do not enable `ENCRYPTED_ASSETS` and ship plain data files. Do not reuse the key for anything; drop the layer or move to a build-time secret if asset protection is ever wanted. The literal values are intentionally not reproduced in the docs. Tracked as BUG-56 in `BUG_TRIAGE.md`. |

## 4. Credentials and secrets

| Item | Status |
|------|--------|
| Original `config.lua` database credentials | `sqlUser = "root"`, **`sqlPass = ""`** (empty), database `genesis`. No real secret was present in the archive. The file is preserved verbatim in `original/server/config.lua`; the working `server/config.lua` is git-ignored and `server/config.example.lua` keeps the empty placeholder. |
| Stock `mysql.sql` account `1` / password `1` | Inert: stored in plain text while the server requires SHA-256, and `accountManager = false`. Documented in `BUILDING.md`; safe to delete. |
| `psoul_dev_seed.sql` account `admin` / `admin` | Development-only seed with an obvious password, clearly labelled; must be changed or not imported on anything reachable from the internet. |
| `data/XML/admin.xml` password `159753` | Weak default from the original package (see §2). |
| Password hashing | TFS 0.3.6 `encryptionType = "sha256"`: unsalted SHA-256 of the password. Adequate for a private test server, weak by modern standards; changing it is a Phase 2+ decision because the website/account tooling must agree. |
| RSA key | The well-known public OTServ 1024-bit key is hard-coded (`src/otserv.cpp:648-651`). Every OT client knows the public half; the private half is public knowledge too, so the "encryption" of the login packet protects nothing against an active attacker. This is inherent to the 8.x OT protocol and shared by all TFS 0.3 servers. |
| Logs in the archive (`PSOUL/logs/`) | Contain player names and in-game actions from the packager's last run; no passwords. Kept only under `original/`. |

## 5. Indicators searched for and **not** found

Cryptocurrency miners or mining pools, obfuscated/encoded Lua (`\ddd` escape blobs, base64
payloads), remote code loading, callbacks to third-party hosts, hidden GM/backdoor accounts in
scripts (privileged talkactions are gated by the `access` attribute in `talkactions.xml`, 28 of
them at access 4–5; no command evaluates arbitrary Lua or SQL), credential exfiltration,
keyloggers, registry/startup persistence, hidden files. The only outbound network references in
the whole tree are the disabled blacklist fetch, static website links in the client UI, and
URLs inside player-facing help messages.

## 6. Quarantine and exclusion policy applied

* Nothing from the archive was deleted; the archive itself stays outside the repository (it is
  matched by `.gitignore`) and every file in it is accounted for by hash in
  `original/ARCHIVE_MANIFEST.sha256`, including the excluded binaries.
* Binaries, caches and intermediates were **excluded from import** rather than quarantined
  inside the repo, because the repo contains everything needed to rebuild them from source.
* Suspicious-looking but inert configuration (admin password, hard-coded IPs) was **left in
  place and documented** here rather than silently edited, so the baseline still matches the
  original behaviour.

## 7. Recommendations before any public deployment (not done in Phase 1)

1. Change or remove the seed `admin` account and the `admin.xml` password.
2. Replace `servers.xml` / `config.lua` addresses and the website URLs in client modules and
   `globalMessages.lua`.
3. Run the server as an unprivileged user (`-DROOT_PERMISSION=OFF`) behind a firewall that
   exposes only `loginPort` and `gamePort`.
4. Review the unsalted SHA-256 password storage together with whatever account-creation
   frontend replaces the original website.
