PokeNation legacy client for Windows (PSoul/PokeAimar reference client)
=======================================================================

DEVELOPMENT BUILD - compiled from the PokeNation repository source (client/src-cpp).
No executable from the original PSoul/PokeAimar archive is included.
Version and source commit: see VERSION.txt / version.json in this folder.

Start
  1. Start the server first (..\server\Start-PokeNation-Server.bat) and wait for
     ">> Cristal server Online!" in the server window.
  2. Double-click Start-PokeNation-Client.bat
  3. Log in with   account: player   password: player   -> character "Trainer"
     (or admin / admin -> "GM Admin" or "Tester")

The client always connects to 127.0.0.1:7564 (this computer). It needs a graphics driver
with OpenGL 2.0 or newer. Settings and the log file (psoul.log) are kept in your user folder
(C:\Users\<you>\psoul.log and C:\Users\<you>\psoul\).

Full guide: docs/WINDOWS_LOCAL_TESTING.md in the PokeNation repository.
Licence of the OTClient engine (MIT): LICENSE-client.txt
