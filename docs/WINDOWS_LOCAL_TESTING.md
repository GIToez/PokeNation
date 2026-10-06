# Testing PokeNation on Windows (step by step)

This guide is for people who **do not program**. You need about 2 GB of free disk space and an
internet connection for the downloads. Everything runs on your own PC, and nobody else can connect.

> **Development build.** Local testing only. The passwords below are public and must never be
> used on a server that other people can reach.

What you will do:

1. Install MariaDB (the database) once.
2. Download and extract the two PokeNation packages.
3. Set up the database once.
4. Start the server, then the client, and play.

---

## 1. Install MariaDB (once)

1. Open <https://mariadb.org/download/>, choose the latest **MariaDB Server** "MSI Package" for
   Windows x86_64, and run the installer.
2. When it asks for a **root password**, choose one and write it down. You need it once in step 3.
3. Keep **"Install as service"** ticked (service name `MariaDB`, port `3306`), then finish the
   installation.

MariaDB now starts automatically with Windows. If it ever stops, right-click
`Start-MariaDB.bat` (in the server folder) and choose "Run as administrator".

## 2. Download the packages

The packages are built by GitHub Actions from the source code in this repository. Nothing comes
from the original 2014 archive.

1. On GitHub, open the repository → **Actions** → workflow **"Build development packages"** →
   the newest run with a green check mark.
2. Under **Artifacts**, download:
   - `PokeNation-Server-Windows` (contains `PokeNation-Server-Windows-Dev.zip` + `.sha256`)
   - `PokeNation-LegacyClient-Windows` (contains `PokeNation-LegacyClient-Windows-Dev.zip` + `.sha256`)
   You must be logged in to GitHub to download artifacts. Artifacts are deleted after 14 days.
3. *(Optional, recommended)* check that the downloads are intact. In PowerShell:
   `Get-FileHash .\PokeNation-Server-Windows-Dev.zip -Algorithm SHA256`. The value must equal the
   first word inside `PokeNation-Server-Windows-Dev.zip.sha256`.
4. Extract **both** zips into the **same** folder, for example `C:\PokeNation-Test\`. You get:

```
C:\PokeNation-Test\PokeNation\server\   PokeNationServer.exe, data\, database\, *.bat ...
C:\PokeNation-Test\PokeNation\client\   PokeNationLegacyClient.exe, data\, modules\, *.bat ...
```

Windows SmartScreen may say the program is from an unknown publisher, because the builds are not
code-signed. Choose "More info" → "Run anyway", but only for files you downloaded from this
repository's Actions page.

## 3. Set up the database (once)

Double-click **`server\Setup-PokeNation-Database.bat`** and type the MariaDB root password from
step 1. Expected output:

```
[ OK ] MariaDB client: C:\Program Files\MariaDB 11.x\bin\mysql.exe
[ OK ] MariaDB is running on 127.0.0.1:3306
[ OK ] logged in as 'root'
[ OK ] database 'psoul' and user 'psoul' ready
       importing database\mysql.sql ...
       importing database\psoul_extra_mysql.sql ...
       importing database\psoul_dev_seed.sql ...
[ OK ] schema and development accounts imported
[ OK ] 97 tables; accounts: 1,admin,player
[ OK ] config.lua created from config.example.lua
```

Running it again is safe, because it skips what already exists. To start over with fresh characters,
open PowerShell in the server folder and run
`powershell -ExecutionPolicy Bypass -File .\Setup-PokeNation-Database.ps1 -Reset`.

## 4. Start the server

Double-click **`server\Start-PokeNation-Server.bat`**. It first checks everything:

```
[ OK ] package files present
[ OK ] config.lua: database 'psoul' on 127.0.0.1:3306, ports 7564/8548
[ OK ] MariaDB is running
[ OK ] database 'psoul' is initialised (3 accounts)
[ OK ] ports 7564 (login) and 8548 (game) are free
```

Then the server loads. That takes 15-30 seconds, and the map alone takes about 7 seconds. It is
ready when you see:

```
> Local ports: 7564	8548
>> All modules were loaded, server is starting up...
>> Cristal server Online!
```

Lines you can ignore. They are explained in [STARTUP_AUDIT.md](STARTUP_AUDIT.md):

- `Unknown, version Unknown (Unknown)`: an inherited placeholder.
- `> Broadcasted message: "The Pro tournament ... will begin in 2 hours! ..."`: normal.
- `[Warning - Tournaments::getTournament] Tournament 2 not found.` and the matching
  `[Error - Npc interface] ... tournament.lua ... Tournament not found` (also for tournament 3):
  a known harmless bug (BUG-20).

**Keep this window open** while you play. To stop the server, close the window. Typing `/shutdown`
as GM saves everything, but the window then has to be closed by hand (BUG-72).

## 5. Start the client and log in

Double-click **`client\Start-PokeNation-Client.bat`**. It checks the client files and that the
server is listening, then opens the game window, titled "PSoul" (the original client's name).

Alternatively, **`server\Start-PokeNation-Local.bat`** does steps 4 and 5 together: it opens the
server in its own window, waits until it is online, and starts the client.

Log in with one of these development accounts:

| Account | Password | Characters |
|---|---|---|
| `player` | `player` | **Trainer**: a brand-new player (no Pokémon yet) |
| `admin` | `admin` | **GM Admin**: game master, can use commands such as `/goto`, `/m`, `/i`. **Tester**: a normal player |

Press **OK** on the message of the day, then choose a character and press **OK** (or Enter).

You should see the map, your character in the middle, the **Health Info** window (HP, "Balls",
"Respect") and **Inventory** on the right, the minimap, and the chat at the bottom with the
Default / Server Log / Wiki Chat / Help tabs.

## 6. A first test session

### 6.1 Get your first Pokémon (Trainer)

Trainer starts in the tutorial town. **Professor Oak** stands close to the start (map position
5020,788, floor 7).

1. Walk next to Oak: use the arrow keys, or click on the ground.
2. In the **Default** chat tab type `hi`, then `charmander` (or `squirtle` / `bulbasaur`), then
   `yes`, then `male` or `female`.
3. Expected: `You received a Charmander` in the chat. The Pokémon appears in the **Pokémon bar**,
   the small picture with "100%" at the left edge of the game window.

If you cannot find Oak, open a **second** client window (run `Start-PokeNation-Client.bat`
again), log in as `admin` → GM Admin and type `/send Trainer;5020,789,7`. This teleports
Trainer to Oak. *(The automated test uses this teleport, so the walking route itself has not
been tested.)*

### 6.2 Summon, move, fight, catch, return

1. **Summon:** click the Pokémon's picture in the Pokémon bar. Your trainer says one of the call
   phrases, for example `Charmander, I choose you!`, and Charmander appears next to you. In towns (protection zones) the game does not allow battles,
   so leave town first.
2. **Move:** walk with the arrow keys. Your Pokémon follows you.
3. **Fight:** click a wild Pokémon in the battle list, or right-click it → Attack. Use moves from
   the move bar (keyboard shortcuts or by clicking). The chat shows `Your Charmander deals N damage …`.
   (A GM can create a test opponent next to you with `/m Magikarp`. Wild levels are random within
   the species' range, and Magikarp, levels 1-5, is the only one a level-5 starter always beats.)
4. **Catch:** when the wild Pokémon is defeated it leaves a corpse. Open your bag (the pokebag in
   the inventory), right-click a **Poke Ball** → "Use with…" → click the corpse. Expected:
   `Gotcha!` (caught) or a message that the ball broke. Catching is random.
5. **Return:** click the Pokémon's picture in the Pokémon bar again. Expected for example
   `Charmander, that's enough!` and it disappears.

### 6.3 Log out

Use the logout button (top-right of the window) or press **Ctrl+L**, and confirm. The server
window shows `Trainer has logged out.` Your character is saved.

These steps match the automated smoke test (`tools/smoke_test.py`), which CI runs against the
packaged Windows server on every build.

---

## 7. Troubleshooting

Every launcher prints `[FAIL]` with the reason and what to do. Common cases:

| Message | What to do |
|---|---|
| `mysql.exe (MariaDB client) was not found` | Install MariaDB (step 1). If it is installed somewhere unusual, add its `bin` folder to PATH. |
| `MariaDB is not running on 127.0.0.1:3306` | Start the "MariaDB" service: `Start-MariaDB.bat` as administrator, or the Windows "Services" app. |
| `cannot log in to MariaDB as 'root'` | The root password is wrong. Use the one from the MariaDB installation. |
| `config.lua is missing` | Run `Setup-PokeNation-Database.bat` first. |
| `database 'psoul' is missing or cannot be read` | Run `Setup-PokeNation-Database.bat` (or `-Reset`). |
| `port 7564 is already in use by …` | A server is already running. Close that window first. |
| `no server is listening on 127.0.0.1:7564` (client) | Start the server first and wait for `>> Cristal server Online!`. |
| `the client closed immediately` | Usually a graphics driver without OpenGL 2.0 (old GPU, remote desktop, virtual machine). Update the graphics driver. The script prints the end of `%USERPROFILE%\psoul.log`. If that log contains `loading texture with size 1920x1080 failed`, Windows is using its basic software renderer and the client crashes on it (BUG-73). Install the real GPU driver, or see "Without a GPU" below. |
| `this folder is not a PokeNation server/client package` | Extract the whole zip, and start the scripts from inside `server\` or `client\`. |
| `data\world\map.otbm is missing or incomplete` | The download is broken; download the package again. |
| Login screen says the account or password is wrong | Use exactly `player` / `player` or `admin` / `admin` (lower case). |

**Without a GPU** (virtual machine, Remote Desktop without GPU acceleration). This is how CI
runs the client on a GPU-less Windows runner. It is meant for testing only, and it is slow.

1. Get Mesa's software `opengl32.dll` from a source you trust. CI takes it from the MSYS2 package
   `mingw-w64-x86_64-mesa`, together with `libgallium_wgl.dll` and the DLLs those two need.
2. Copy the DLLs next to `PokeNationLegacyClient.exe`. Use a copy of the `client` folder; Mesa is
   not part of the package.
3. Start the client from a command prompt in that folder:
   `set GALLIUM_DRIVER=llvmpipe` and then `PokeNationLegacyClient.exe`. Without that variable Mesa
   may choose its d3d12 driver, which closed the client on the CI runner.

Files written by the programs:

- Server: `server\config.lua` (your local settings and DB password, never share it) and `server\logs\`.
- Client: `%USERPROFILE%\psoul.log` (log) and `%USERPROFILE%\psoul\config.otml` (settings).

## 8. What has been verified on Windows

See [PHASE_2A_REPORT.md](PHASE_2A_REPORT.md), section "Windows runtime evidence". It describes
exactly what the Windows CI runner proved, and what it did not:

- **Proved:** database setup, the launcher checks, server start, logins and the gameplay smoke
  test, on every build.
- **Client:** it crashes on the runner's basic renderer (BUG-73), and it starts and shows the
  language and login screen with Mesa llvmpipe.
- **Not yet done on Windows:** the walking route to Oak and a graphical play session (section 6).
  They need a person at a Windows PC.
