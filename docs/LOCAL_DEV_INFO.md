# Local development information

> **DEVELOPMENT ONLY.** Every account, password and address on this page belongs to the local
> development setup created by the SQL seed. They are public in this repository. Never use them
> on a server that other people can reach. Change or delete them first (see the end of this page).

## Connection

| | |
|---|---|
| Server address | `127.0.0.1` (`ip` in `config.lua`; the client hard-codes `127.0.0.1:7564` in `client/modules/client_entergame/entergame.lua:191-192`) |
| Login port | `7564` (`loginPort`) |
| Game port | `8548` (`gamePort`) |
| Protocol | Tibia 8.54 packet layout, client version **312** (server accepts exactly 312) |
| World type | `no-pvp` (archive value; NPC battles and duels work since the BUG-01 fix) |
| Server name | `Cristal` (`serverName`; the ready line is `>> Cristal server Online!`) |

To test from another PC in your LAN, set `ip` in `config.lua` to the server PC's LAN address and
change `G.host` in the client's `modules/client_entergame/entergame.lua`. Allow ports 7564/8548
in the firewall. Do not forward these ports to the internet.

## Database

| | |
|---|---|
| Engine | MariaDB (10.11 and 11.x tested). SQLite and flat files are not used |
| Database | `psoul` |
| User | `psoul` @ `localhost` and `127.0.0.1` |
| Password | Windows package: `psoul-dev` (default of `Setup-PokeNation-Database.ps1`). Linux dev tree: generated or `psoul-dev`, stored **only** in the git-ignored `server/config.lua` |
| Schema | `mysql.sql` → `psoul_extra_mysql.sql` → `psoul_dev_seed.sql` (97 tables) |
| Create / reset | Windows: `Setup-PokeNation-Database.bat` (`-Reset` to start over). Linux: `tools/init_dev_database.sh` (`--reset`) |

## Accounts and characters

| Account | Password | Character | Group | Notes |
|---|---|---|---|---|
| `admin` | `admin` | **GM Admin** | 6 (God) | `/goto`, `/m`, `/i`, `/send`, `/reload` … see [reference/COMMANDS.md](reference/COMMANDS.md). GM Pokémon use moves without spending energy (BUG-05, fixed) |
| `admin` | `admin` | **Tester** | 1 | normal player on the GM account, spawns in Pewter (3307,300,7) |
| `player` | `player` | **Trainer** | 1 | brand-new player in the Tutorial town (temple 5000,806,6). Professor Oak (5020,788,7) gives the starter |
| `1` | `1` | none | n/a | inherited TFS account-manager account from `mysql.sql`; unused because `accountManager = false` |

Passwords are stored as SHA-256 (`encryptionType = "sha256"`).

## Executables and start order

| Platform | Server | Client |
|---|---|---|
| Windows package | `server\PokeNationServer.exe` | `client\PokeNationLegacyClient.exe` |
| Linux package | `server/psoul-server` | `client/psoulclient` |
| Source tree (build output) | `build/<platform>-development/server/psoul-server[.exe]` | `build/<platform>-development/client/psoulclient[.exe]` |

The server must run with its own folder as the working directory (it reads `config.lua`, `data/`
and `pt_br.loc` from there). The launchers take care of that.

Start order:

1. **MariaDB** (Windows service `MariaDB`, starts automatically; Linux `tools/start_database.sh`)
2. **Server** (`Start-PokeNation-Server.bat` / `tools/start_server.sh`). Wait for `>> Cristal server Online!`
3. **Client** (`Start-PokeNation-Client.bat` / `tools/start_client.sh`)

`Start-PokeNation-Local.bat` does 2 and 3 in one go.

## Files that stay local

| File | Contents |
|---|---|
| `server/config.lua` | DB password, local settings. Git-ignored, never packaged |
| `server/logs/`, `server/data/logs/` | runtime logs |
| `server/data/npc/tmpCitizen_*.xml` | regenerated at every start |
| `~/psoul.log`, `~/.psoul/` (Linux) / `%USERPROFILE%\psoul.log`, `%USERPROFILE%\psoul\` (Windows) | client log and settings |

## Before exposing a server

Before any server is reachable by others: delete or re-password every account above
(`UPDATE accounts SET password = SHA2('…', 256) WHERE name = 'admin';`, and delete account `1`),
use a strong DB password, and review [SECURITY_AUDIT.md](SECURITY_AUDIT.md).
