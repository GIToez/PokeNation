# Phase 1 report — import, audit, translate, build, run, verify

Scope of Phase 1 was deliberately limited: get the original PSoul / PokeAimar server into a
safe repository, understand it, translate player-facing Portuguese, make it build and run on
Linux, and verify the core Pokémon loop over the real protocol. **No modernization was done**:
no engine upgrade, no C++ standard port beyond what GCC needed to compile, no formula or
protocol changes, no client conversion, no renames.

Detailed documents: `SOURCE_AUDIT.md`, `BUILDING.md`, `TRANSLATION.md`, `SECURITY_AUDIT.md`,
`LARGE_FILES.md`, `original/README.md`.

---

## 1. Original base

* Archive `Projeto.rar` (277,469,662 bytes, Google Drive id `1V0CHaBpqVtnwxzvZjQI-X7F985_kduE2`,
  contents dated 2020-08-04). Every file is listed with its SHA-256 in
  `original/ARCHIVE_MANIFEST.sha256`; the archive itself is not in Git.
* Server: **The Forgotten Server 0.3.6** (OTServ lineage, `db_version` 23) with extensive
  PSoul customisation (party duels, PvP arenas, tournaments, polls, market, datalog, player
  statistics, localization, TV, OTClient extensions). Dev-C++/MinGW project, Lua 5.1, MySQL.
* Client: **OTClient 0.6.x** fork "Poke Aimar" (C++ source + Lua modules), protocol version
  **312** over 8.54-shaped packets, 308 MB sprite file.
* Also included: a Remere's Map Editor build with PSoul's 8.54 item profile (source imported to
  `tools/rme`), Portuguese design documents (`original/design-docs`), the packager's logs.
* Repository layout: `original/` (untouched reference copy, no binaries), `server/` (working
  server), `client/` (working client text assets + C++ source), `tools/` (RME source, import
  script, syntax checker, Portuguese scanner, protocol probe), `docs/`.

## 2. Build status — **builds**

* Toolchain: Ubuntu 24.04, GCC 13.3 (`-std=gnu++11`), CMake 3.28, Boost 1.83, Lua 5.1,
  libxml2 2.9, GMP 6.3, libmysqlclient 8.0, SQLite 3.45, OpenSSL 3.0.
* `server/CMakeLists.txt` was added (the archive had only `Makefile.win`); it mirrors the
  original defines (`__USE_MYSQL__ __USE_SQLITE__ __ENABLE_SERVER_DIAGNOSTIC__
  __EMERGENCY_SAVE__ __CONSOLE__`).
* Eight one-line source fixes were needed (Boost TR1 header removal, enum-as-integer,
  array-from-string initialisation, stream misuse, pointer/bool return, dangling reference,
  two off-by-one array bounds). Each is listed with file and reason in `BUILDING.md §2.1`;
  none changes behaviour.
* Output: `server/psoul-server`. Warnings remain (2010-era code under `-Wall`), zero errors.
* Not built: the client (Visual Studio 2013 project; not in Phase 1 scope), RME.

## 3. Runtime status — **runs, stable through all tests**

Startup (verified, log `>> Cristal server Online!`): config loads, SHA-256 mode, RSA key,
MySQL connection, Database Manager, items, groups, vocations, polls, localization
(`pt_br.loc`), script systems (actions, creaturescripts, globalevents, movements, NPCs,
spells, talkactions, weapons, raids), chat channels, outfits, stages, 1,418 monsters,
tournaments, map 5879×3541 (~6 s), houses, 902 NPCs, PSoul `onStartup` (arenas, highscores,
berry trees, bosses, quest spawns, Tiger Kelsey, ball pillars, 60 citizens, surprise boxes),
listening on **7564 (login)** and **8548 (game)** at `127.0.0.1`.

Only console noise left: `Tournament 2/3 not found` warnings because the original
`tournaments.xml` disables them while `npc/scripts/tournament.lua` still queries them. Original
behaviour, documented, not changed.

Runtime problems fixed in Phase 1 (all were missing-database issues, no code changes):

| Symptom | Cause | Fix |
|---------|-------|-----|
| `Failed to load motd!` / `Failed to load players record!` | no `world_id = 1` rows in `server_motd` / `server_record` | rows added by `psoul_extra_mysql.sql` |
| `Table 'polls' / 'tournaments' / 'berry_trees' / 'poketrader_offerts' / 'ball_pillars' / 'market_*' / 'datalog_online' doesn't exist`, NPC `Tiger Kelsey` failing to load (`poketrader.lua`) | website-managed tables never shipped | 69 tables reconstructed in `psoul_extra_mysql.sql` |
| Lua error on login `010-pokedex.lua:546 attempt to index field '?'` | characters created directly in SQL have no Pokédex/pokebag/order icon (the website used to create them) | starting inventory in `psoul_dev_seed.sql` |
| Stock account `1`/`1` cannot log in | plain-text password vs `sha256` | seed account `admin` with `SHA2()` |

Logins and logouts of both seeded characters leave no errors in the console.

## 4. Database status — **initialises cleanly**

* MariaDB 10.11, database `psoul`, user `psoul` (password only in git-ignored `server/config.lua`;
  `server/config.example.lua` holds the original placeholders).
* Files: `src/schemas/mysql.sql` (stock, 29 tables) → `src/schemas/psoul_extra_mysql.sql`
  (12 added columns on `accounts`/`players`, 69 tables, world-1 rows) →
  `src/schemas/psoul_dev_seed.sql` (dev account/characters). Result 97 tables, `db_version 23`.
* Column types were inferred from how the code reads/writes them; each block in the SQL file
  cites the C++/Lua source it was derived from.
* Not reconstructable: stored procedure `update_rank()` (website ranking; only called when
  `updateHighscores = true`, which is `false` in the shipped config) and the website itself
  (account/character creation, shop, polls admin).
* Obsolete SQL: none had to be changed; the engine's own queries run unchanged on MariaDB 10.11.

## 5. Translation status

* The code base is English-first with runtime Portuguese via `pt_br.loc` / `__L()` (6,928
  pairs), so hard-coded Portuguese was limited. All of it on the English path was translated:
  MOTD/login message, Help-channel lines, periodic broadcasts, `/shutdown` broadcasts,
  Professor Tommy (starter NPC, previously bilingual every line), isolated sentences in quests,
  events, egg-move NPC, and the client shop module. Portuguese lines removed from scripts were
  moved into `pt_br.loc` so the Portuguese language option keeps working.
* **Remaining Portuguese (intentional):** the player-selectable `'Português'` branch of the
  Wiki Chat help tree (168 lines), Portuguese NPC keyword *aliases* (`sim/nao/vender/…`, 53
  lines in 34 files, input only), `pt_br.loc` itself, Portuguese developer comments, Portuguese
  design documents under `original/`.
* Estimated player-facing coverage on the default English path: **~100 %** (scanner
  `tools/find_portuguese.py` reports 0 lines outside the intentional categories). Verified
  in-game: login text, achievements, NPC speech, combat, catch and level-up messages were all
  English.
* Syntax: `tools/check_syntax.sh` → 0 Lua / 0 XML errors after the edits.

## 6. Working Pokémon systems (verified over the real protocol)

All checks were made with `tools/protocol_probe.py`, a headless client implementing the PSoul
wire protocol, against the running Linux build. "Verified" means the server sent the packets
and messages a graphical client would render.

| Feature | Evidence |
|---------|----------|
| Login protocol | wrong password → `0x0A` error; right password → MOTD + character list with PSoul extras (level, vocation, outfit, Pokémon team list, premium 65535, poll flag) |
| Enter world | `0x1F` challenge, self-login with `U16` light hour, GM flags, full 18×14 map, 6 inventory slots, stats (level 100 / 1000 HP), skills, VIP, Pokémon window/Pokédex packets, achievements "The First!" and "I am a V.I.P!", record message, English login message |
| Non-GM login | character `Tester` (group 1) enters, receives first-login exp and VIP achievement, logs out cleanly |
| Movement | `0x65` north moves with map slices; blocked move → "There is not enough room." cancel |
| Containers / inventory | pokebag opens (`0x6E`, "simple pokebag"), items move bag ↔ slot 8 (`0x78`), server updates `0x70/0x72/0x78/0x79` |
| GM commands | `/i 12157`, `/m Rattata` (spawns "Rattata [n]"), `/mypokemon Charizard,50`, `/mypokemon Rattata,2` |
| Summon | use charged ball in slot 8 → "Charizard, it's the battle time!" / "I need your help!", summon creature appears, ball `12159 → 12158`, `0xFF 0x01` move bar and `0xFF 0x04` window icon |
| Return | use in-use ball → "Charizard, back!" / "nice work!", summon removed, ball `→ 12159` |
| Attack / combat | `0xA1` on wild Rattata: repeated "Your Charizard deals N damage to a Rattata." (`0xB4`), health `0x8C` decreasing, death, corpse `11407` added, "Loot of a Rattata: a bitten apple." / "nothing.", corpse later transforms |
| Experience | "Your Charizard received 206.25 experience points." / "+EXP" animated text |
| Level-up | level-2 Rattata killed a wild Rattata: "Your Rattata received 1575 experience points." then "Congratulations! Your Rattata advanced from level 2 to level 6." |
| Catch | empty poke ball (`12157`) used on the corpse: "Poke ball, go!", then "Gotcha! You caught a male Rattata (level 3).", new ball in bag, Pokédex `0xFF 0x0C` update, "You earned 100 experience points by discovering Rattata!", achievements "This is a Pokedex!" and "Be a part of my team!", ball counter "You've wasted 2 poke balls to catch it." |
| NPC interaction | Nurse Joy's idle greeting; `hi` → "One second... Alright, it's here. Remember that you can also change your {hometown} here…"; `bye` closes |
| Server stability | ~15 login/logout cycles plus all of the above with no Lua or C++ errors in the console |

## 7. Broken or unverified Pokémon systems

Nothing tested was found broken. The following were **not** exercised and must be treated as
unverified:

* Evolution, TM learning, held items, vitamins, addons, ball seals, egg/daycare, berry
  planting, fishing, headbutt, dive/surf/fly/ride field abilities, safari zone, PvP arena,
  party duel, tournaments (1 is enabled, scheduled), Elite Four, Ranger Club, Rocket battles,
  gym `NpcBattle` fights, quests beyond the dialogue layer, market, Poketrader auctions,
  polls, TV, slot machine, doll/badge cases, mastery, seasonal events, boss schedule
  (one boss is scheduled 3 days ahead), citizens' behaviour, surprise boxes.
* Nurse Joy's `heal` keyword gave no reply in the probe (it may require the player to have a
  Pokémon out / be adjacent; not investigated).
* Anything that depends on the website/stored procedure (`update_rank`, soul-coin shop,
  referral exchange, coupon creation).
* Rendering-side features (sounds, particles, shaders, Pokémon window UI) — no client was run.
* Inherited oddities kept as-is: Pokémon level-up threshold uses `level` where the player
  formula uses `level-1`; `balls.lua` duplicate `yereblu` entry and `EFFECT_SILVERBALL_US`
  typo; three XML script references point to missing files but are already commented out.

## 8. Client protocol

Summary (full tables in `SOURCE_AUDIT.md §2`): Tibia 8.54 packet shapes; version field 312;
Adler-32 checksum; OTServ RSA + XTEA; `0x1F` challenge; OS ids `0x0A-0x0C` mark OTClient and
unlock every PSoul extension. Differences from stock 8.54: login language byte, character-list
extras + poll byte, `U16` light hour on self-login, `U16` magic-effect id, four extra creature
bytes (icon, impassable, isSummon, canAttack), extended opcode `0x32`, backported market
`0xF4-0xF9`, poll `0xFA/0xFB`, TV channel list, and the `0xFF` PSoul family. Status protocol
and admin protocol are disabled in the shipped source.

## 9. Custom opcodes

`0xFF` + sub-opcode (26 defined): move bar `0x01-0x03`, Pokémon window `0x04-0x08`, move
cooldown `0x09`, Pokédex `0x0A-0x0C, 0x11`, TM window `0x0D`, status icons `0x0E-0x10`,
creature jump/effect `0x12/0x13`, doll case `0x14/0x15`, slot machine `0x16`, tip `0x17`,
poll window `0x18`, level-up `0x19`, loot list `0x1A`. Extended opcode (`0x32`) ids `0-10`
plus the client shop's ad-hoc `103`. Exact payloads: `SOURCE_AUDIT.md §2.5`.

## 10. Redemption migration notes

Not started (out of scope). What a later port must do is listed in `SOURCE_AUDIT.md §2.7`:
version 312 + OTClient OS id, forced features (MagicEffectU16, CreatureIcons, PlayerMarket,
SpritesAlphaChannel, addons, stamina, emblems, challenge), parse the charlist extras and the
light hour, read the four extra creature bytes, implement the `0xFF` family and the `0x32` ids
with their Lua UI, port market/poll opcodes, reuse `data.dat`/`data.spr` (8.54 format) and
PSoul's `items.otb`. `tools/protocol_probe.py` doubles as an executable specification of the
login/enter/combat packet flow.

## 11. Security findings

Full detail in `SECURITY_AUDIT.md`. Headlines: no binary from the archive was executed and none
was imported (`PS.exe` ×2, `Poke Aimar.exe`, `RME.exe`, `Large Address Aware.exe`, 26 DLLs,
VS/MinGW intermediates, two nested RARs — all excluded, all hashed). No miners, obfuscation,
remote code loading, telemetry or credential exfiltration were found. Dormant items documented
and left in place: disabled remote blacklist fetch, disabled status/admin services, weak
`admin.xml` password `159753`, hard-coded hosting IPs in `servers.xml` and a config comment,
static website links in the client. The original `config.lua` had an **empty** DB password, so
no real secret was ever in the archive; the working `config.lua` is git-ignored. Password
hashing is unsalted SHA-256 (TFS standard). One defence-in-depth gap noted
(`049-eliteFour.lua` nickname interpolation, not exploitable due to `[a-z ]` validation).

## 12. Large files

`LARGE_FILES.md` lists everything above 5 MB. Git LFS holds `server/data/world/map.otbm`
(130 MB), `client/data/things/data.spr` (308 MB) and five `.psd` sources (≈17 MB). Nothing
above 50 MB is a normal Git object. Excluded from import: `otclient.sdf` (134 MB IntelliSense
cache), VS `Debug/` intermediates (≈40 MB), the executables. Client PNG/OGG assets (≈122 MB,
largest file 3 MB) are normal objects. Upstream `.gitignore` files that would have hidden
`*.xml/*.otb/*.spr/*.dat/*.otbm` were renamed to `.gitignore.upstream`.

## 13. Remaining issues (prioritised)

1. **Account/character creation path** — only SQL seeds exist. A minimal account manager or
   website replacement is needed before anyone but a developer can play (`accountManager` is
   `false` in the original config; the stock TFS account manager was never tested with the
   PSoul login scripts).
2. **Verify the untested systems in §7**, starting with evolution, gym `NpcBattle`, quests,
   TM/held items and the daycare, since they touch the reconstructed tables whose column types
   were inferred.
3. **`update_rank()` stored procedure** is missing; either reconstruct a ranking procedure or
   keep `updateHighscores = false`.
4. **Client**: nothing runs yet on Linux; the Redemption port (Phase 2+) or rebuilding the
   original VS2013 client is required to see the UI. `tools/protocol_probe.py` covers protocol
   regression testing until then.
5. **Credentials and addresses**: change the seed `admin` password and `admin.xml` password,
   replace `servers.xml`/config/client URLs before any public exposure.
6. **Translation polish**: Portuguese developer comments; awkward original English strings
   that are also `pt_br.loc` keys (must be changed on both sides).
7. **Inherited code defects**: level-up formula inconsistency, `balls.lua` duplicate key/typo,
   missing `/tvbanlist` script, `eliteFour` unescaped nickname — all low impact, listed for the
   next phase.
8. **Build hygiene**: enable `-Werror`-clean build or at least triage the `-Wall` warnings;
   decide whether `__ENABLE_SERVER_DIAGNOSTIC__` and `__ROOT_PERMISSION__` stay on.
