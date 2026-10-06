PokeNation development server for Windows (PSoul/PokeAimar baseline)
=====================================================================

DEVELOPMENT BUILD - for local testing only. Not for a public server.
Version and source commit: see VERSION.txt / version.json in this folder.

What you need
  * Windows 10 or 11, 64-bit
  * MariaDB (free): https://mariadb.org/download/  - choose the MSI installer, remember the
    root password you set, keep "Install as service" ticked.
  * The client package (PokeNation-LegacyClient-Windows-*.zip) to play.
  Extract this zip and the client zip into the SAME folder. You get:
      PokeNation\server\   (this folder)
      PokeNation\client\

First time only
  1. Double-click Setup-PokeNation-Database.bat
     Enter the MariaDB root password when asked. It creates the database "psoul",
     the development accounts and config.lua.

Every time
  2. Double-click Start-PokeNation-Server.bat and wait for:   >> Cristal server Online!
  3. Double-click ..\client\Start-PokeNation-Client.bat
     (or use Start-PokeNation-Local.bat here, which does 2 and 3 for you)

Development accounts (local only)
  account admin   password admin    characters: GM Admin (game master), Tester
  account player  password player   character:  Trainer (new player - talk to Professor Oak)

Connection: 127.0.0.1, login port 7564, game port 8548, protocol 8.54 / client version 312.

If something goes wrong the scripts print [FAIL] with the reason and what to do.
Common ones:
  "MariaDB is not running"          -> start the "MariaDB" service (Start-MariaDB.bat as admin)
  "cannot log in to MariaDB as root" -> wrong root password typed during setup
  "config.lua is missing"           -> run Setup-PokeNation-Database.bat first
  "port 7564 is already in use"     -> a server is already running; close that window
Windows may warn that the program is from an unknown publisher (it is not code-signed):
choose "More info" -> "Run anyway" only if you downloaded it from the PokeNation GitHub
Actions artifacts and the SHA-256 checksum matches the .sha256 file.

Full guide: docs/WINDOWS_LOCAL_TESTING.md in the PokeNation repository.
Licence of the server engine (The Forgotten Server, GPL v2): LICENSE-server.txt
