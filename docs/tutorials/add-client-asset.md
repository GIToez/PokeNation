# Add a client asset (image, sprite, item graphic)

> **The client is a frozen reference.** `/client` is the legacy PSoul/PokeAimar OTClient fork.
> Its gameplay, UI and protocol code are not changed (`docs/LEGACY_CLIENT_REFERENCE.md:1-7`).
> Change client files **only when a server feature explicitly requires it**, and record why
> in the commit message. Where the server can reuse an existing graphic, reuse it.

This tutorial covers the asset types the server depends on: PNG images that modules load by
number, the sprite files `data.dat`/`data.spr`, and the server-only `items.otb` that links
server item ids to client sprites.

Paths are relative to the repository root.

---

## 1. Where the client reads its files

`client/data/` is mounted as the root of the client's virtual file system, so
`/images/pokeicons/025.png` means `client/data/images/pokeicons/025.png`. **The paths are
case-sensitive on Linux** (PhysFS), but not on Windows. Three case mismatches had to be
fixed for Linux (`docs/LOCAL_CLIENT_TESTING.md` §3.3, the last row of the table).

| Directory | Content | Loaded by |
|-----------|---------|-----------|
| `client/data/things/` | `data.dat` (object metadata), `data.spr` (pixels, **Git LFS**), `things.otml` (opacity per id), `data.otfi` (sprite-editor project settings) | `client/modules/game_things/things.lua:20-48` |
| `client/data/images/pokeicons/` | `%03d.png`, 32×32 RGBA, e.g. `025.png`; Unown forms `201a.png` … | `game_pokedex/pokedex.lua:254` |
| `client/data/images/staticPortraits/` | `<number>.png` without zero padding, 96×96, e.g. `25.png`; `0.png` is the default | `game_advanceeffect/advanceeffect.lua:170`, `.otui:19` |
| `client/data/images/types/` | `<element id>.png` (0-17), 32×32; `square/` and `arrow/` variants | `game_pokedex/pokedex.lua:213, 235, 243, 324` |
| `client/data/images/moveCategories/` | `0.png` physical, `1.png` special, `2.png` status | `pokedex.lua:219`; ids in `gamelib/types.lua:54-58` |
| `client/data/images/…` (others) | UI art: `ui/`, `game/`, `topbuttons/`, `trainerCards/`, … | the modules' `.otui` and `.lua` files |
| `client/data/fonts`, `styles`, `cursors`, `shaders`, `sounds`, `locales` | standard OTClient resources | `client/init.lua`, modules |

The client has **no `items.otb`**. That file is used only by the server
(`server/data/items/items.otb`) and RME (`tools/rme/data/854/items.otb`, byte-identical).

## 2. Files to edit

| Asset | Files |
|-------|-------|
| Pokémon icon / portrait | `client/data/images/pokeicons/NNN.png`, `client/data/images/staticPortraits/N.png` |
| Item, outfit, effect or missile graphic | `client/data/things/data.dat` **and** `data.spr` (always together) |
| A new item's server ↔ client link | `server/data/items/items.otb` + `tools/rme/data/854/items.otb` (identical copies), `server/data/items/items.xml` + `tools/rme/data/854/items.xml` |
| Transparency for one id | `client/data/things/things.otml` |
| A new name in a client lookup table (only if a module needs it) | `client/modules/gamelib/pokemon.lua` (`POKEMON[...]`, `pokemonNameByNumber` at line 1257), `gamelib/items.lua`, `gamelib/moves.lua` |

## 3. Files NOT to edit

* `client/src-cpp/`: no C++ change for assets. The only allowed client source changes are
  build fixes (`LEGACY_CLIENT_REFERENCE.md:6-7`).
* `client/src-cpp/vc12/`: stale copy that nothing builds.
* `client/data/images/*.psd`: Photoshop masters (LFS); edit them only to re-export a PNG.
* `original/client/`: archive copy.
* The protocol or opcode tables (`docs/reference/OPCODES.md`): an asset never needs them.

## 4. Authoritative source paths

| Topic | Location |
|-------|----------|
| dat/spr loading | `client/modules/game_things/things.lua:21` enables `GameSpritesU32`; `24-33` loads `/things/data.dat` and `/things/data.spr`; `37` loads `things.otml` |
| Sprite file format | `client/data/things/data.otfi`: `extended: true`, `transparency: true`, `frame-durations: false`, `frame-groups: false` |
| Signatures | `data.dat` `0x4B1E2CAA`, `data.spr` `0x4B1E2C87`. They match the 8.54 profile in `tools/rme/data/clients.xml:166` |
| Counts (header of `data.dat`) | 28,778 items, 2,587 outfits, 1,139 effects, 121 missiles; `data.spr` holds 209,927 sprites (32-bit count) |
| Encryption | `client/src-cpp/CMakeLists.txt:24-29` (`option(ENCRYPTED_ASSETS … OFF)` at line 26); `tools/build_client.sh:17` passes `-DENCRYPTED_ASSETS=OFF`; `docs/LOCAL_CLIENT_TESTING.md` §4 |
| Item name lookup in the client | `client/modules/gamelib/items.lua` (`ITEM_NAME_BY_ID`) |

Read the counts yourself with:

```bash
python3 -c "
import struct
d=open('client/data/things/data.dat','rb').read(12)
print('dat %08X' % struct.unpack('<I',d[:4])[0], 'items/outfits/effects/missiles', struct.unpack('<HHHH',d[4:12]))
s=open('client/data/things/data.spr','rb').read(8)
print('spr %08X' % struct.unpack('<I',s[:4])[0], 'sprites', struct.unpack('<I',s[4:8])[0])"
```

Expected output: `dat 4B1E2CAA items/outfits/effects/missiles (28778, 2587, 1139, 121)` and
`spr 4B1E2C87 sprites 209927`.

### 4.1 Encrypted assets

The original release AES-encrypted every `.lua .png .otmod .otfont .otps .otui .ogg .frag
.spr .dat` file. The repository holds the **unencrypted** development copies. Builds read
them as they are, because `ENCRYPTED_ASSETS` is OFF by default
(`LOCAL_CLIENT_TESTING.md:125-142`). So:

* save new files **unencrypted** (a PNG must start with `\x89PNG`);
* never turn on `-DENCRYPTED_ASSETS=ON` for testing. With unencrypted files the client aborts
  in `readFileContents` (`std::length_error`) on the first Lua file.

## 5. Real examples

* Pikachu: `client/data/images/pokeicons/025.png` (32×32 RGBA) and
  `client/data/images/staticPortraits/25.png` (96×96). Number 25 comes from the server
  (`server/data/lib/ps/config/pokemonsNumbers.lua`) and the client name table
  (`client/modules/gamelib/pokemon.lua:1257-1617`, `[1] = "Bulbasaur"` … `[386] = "Deoxys"`).
* Stone Plate: server id 12234 → client id 11195 in `items.otb`; `items.xml:18177` names it.
* Grisly Mind artifacts: server id 18114 → client id 16761.
* Opacity: `things.otml` sets `opacity:0.7` for creatures such as look type 48.

## 6. Required IDs and how to find free ones

| Id | Next free | How to find it |
|----|-----------|----------------|
| Client item id (in `data.dat`) | **28779** | item count in the `data.dat` header (§4) + 1 |
| Server item id (in `items.otb`) | **30136** | highest id in `items.otb` and `items.xml` + 1; see the command below |
| Pokédex number for images | number of the Pokémon | `grep -n '"Pikachu"' server/data/lib/ps/config/pokemonsNumbers.lua` |

```bash
grep -o 'id="[0-9]*"' server/data/items/items.xml | tr -dc '0-9\n' | sort -n | tail -1    # 30135
```

`items.otb` and `items.xml` both top out at 30135 today. Use the same new id in both.

## 7. Related dependencies

* A server item that should be visible needs: an `items.otb` entry mapping its server id to
  a client id, a sprite for that client id in `data.dat`/`data.spr`, and an `items.xml` entry
  (name, attributes). See the item checklist in `CHECKLISTS.md`.
* Pokémon look types (outfits) are in `data.dat` too. A monster's `<look type="…"/>` must be
  ≤ 2587 (the outfit count) unless you add outfits.
* RME uses the same `items.otb` and reads the client files (`edit-map-content.md` §8.2, with
  its known sprite-format limitation).
* Packaging: `tools/package_legacy_client.sh` and `tools/package-files/` decide what ships.
  Check that a new top-level directory is included.

## 8. Example A: icon and portrait for a new Pokédex number

For a Pokémon added on the server as number 387 (`add-pokemon.md`):

1. Draw or export `387.png` at 32×32 RGBA → `client/data/images/pokeicons/387.png`.
2. Export a 96×96 PNG → `client/data/images/staticPortraits/387.png`.
3. Check the names: three-digit, zero-padded for `pokeicons`; plain number for
   `staticPortraits`; lower-case `.png`.
4. Only if a client module must show the name (Pokédex family list,
   `pokedex.lua:258` → `getPokemonNameByNumber`): add `[387] = "<Name>",` to
   `pokemonNameByNumber` in `client/modules/gamelib/pokemon.lua`. This is a client code change;
   it is allowed only when the feature requires it (see the note at the top).

## 9. Example B: graphic for a new item

1. **Sprites.** Open `client/data/things/data.dat` + `data.spr` in a sprite editor that
   supports the 8.54 format with **extended** (32-bit) sprite ids and transparency. No such
   tool is in the repository. Object Builder is the usual choice; `data.otfi` holds its
   project settings. Add one item; it becomes client id 28779. Save in the same format.
2. **Check the files** with the script in §4. The signatures must be unchanged, the item count
   must be 28779, and the sprite count must have grown.
3. **items.otb.** Add server id 30136 → client id 28779 with an OTB editor. Copy the file to
   `tools/rme/data/854/items.otb` as well, and check with `cmp` that both are identical.
4. **items.xml.** Add `<item id="30136" article="a" name="…"/>` (copy the style of
   `items.xml:24431`) to both `server/data/items/items.xml` and
   `tools/rme/data/854/items.xml`.
5. Continue with the server side of the item (actions, loot, shops) from the item
   tutorial and `CHECKLISTS.md`.

## 10. Database requirements

None.

## 11. Client requirements

* `git lfs pull` (data.spr is ~308 MB; a pointer file makes the client show
  `Unable to load spr file, please place a valid spr in '…'`, `things.lua:32`).
* Rebuild the client only if you changed C++ (you should not). Data files are read at run
  time; restart the client to pick them up.

## 12. Server requirements

* New items: the server must be restarted after `items.otb`/`items.xml` changes.
  `/reload items` does nothing: it prints
  `[Notice - Game::reloadInfo] Reload type does not work.` (`server/src/game.cpp:6438-6444`).
* PNG-only changes need nothing on the server.

## 13. Validation steps

```bash
file client/data/images/pokeicons/387.png client/data/images/staticPortraits/387.png   # PNG image data, 32 x 32 / 96 x 96
python3 tools/check_references.py > /tmp/refs-after.txt
grep -n 'client.literal\|client.path' /tmp/refs-after.txt | head    # literal /images/... paths are checked case-sensitively
cmp server/data/items/items.otb tools/rme/data/854/items.otb && echo otb-in-sync
cmp server/data/items/items.xml tools/rme/data/854/items.xml && echo xml-in-sync
git lfs status                                            # data.spr staged as an LFS object
```

`check_references.py` also reports `client modules (loaded/total)` (48/51 today;
`client_serverlist`, `game_environment` and `game_shop` are never loaded). Make sure the
count does not drop.

Server start-up must not print `[Warning - Items::loadFromXml]` or `Unknown itemtype` lines.

## 14. Test steps

1. Start the client (`tools/start_client.sh`) and log in as Tester.
2. **Portrait**: level up a Pokémon with that Pokédex number. The level-up window
   (`onPokemonLevelUp`, `advanceeffect.lua:264-265`) shows `staticPortraits/<n>.png`.
3. **Icon**: open the Pokédex entry of a Pokémon in the same family. The family row shows
   `pokeicons/NNN.png`.
4. **Item**: as GM Admin, `/i 30136,1` (`talkactions/scripts/createitem.lua`; the default
   count is 100). The item appears in your backpack with its sprite. Look at it: the name
   from `items.xml` is shown. `Couldn't add item: 30136` means the item could not be created
   or placed. With an id the server does not know, the console also prints
   `[Warning - Items::getItemType] Unknown itemtype with id 30136, using defaults.`
   (`server/src/items.cpp:1801`). `Item wich such name does not exists.` only appears when you
   pass a **name** instead of an id.
5. Watch the client terminal and `client/crash_report.log` for missing-file messages.

## 15. Common mistakes

* Wrong case: `387.PNG` works on Windows and is missing on Linux.
* Saving `data.dat`/`data.spr` in the non-extended (16-bit) format. The client then shows
  garbage for every sprite above 65,535, which is almost all of them (209,927 sprites).
* Saving only one of `data.dat`/`data.spr`. They must always be saved together.
* Updating `server/data/items/items.otb` but not the RME copy, or the reverse.
* Committing a re-exported PNG with a different size. The `.otui` layouts assume the sizes in
  §1.
* Encrypting the new file.

## 16. Failure symptoms

| Symptom | Cause |
|---------|-------|
| Client error box `Unable to load dat file, please place a valid dat in '…'` | `data.dat` missing or corrupt (`things.lua:28-30`) |
| `Unable to load spr file, please place a valid spr in '…'` | `data.spr` missing, an LFS pointer, or corrupt (`things.lua:31-33`) |
| Every sprite shows garbage | dat/spr saved non-extended, or dat and spr from different saves |
| Empty square instead of an icon | file missing or wrong case/padding |
| Item invisible in game | no client id in `items.otb`, or the client id is above the `data.dat` item count. Example: `items.otb` maps server id 29134 to client id 29130, but `data.dat` only defines 28,778 items |
| Client aborts with `std::length_error` in `readFileContents` | client built with `ENCRYPTED_ASSETS=ON` |

## 17. Rollback advice

* `git checkout -- client/data/…` or `git revert <commit>`. LFS restores the previous
  `data.spr`.
* Restart the client; it reads assets at start (and the dat/spr when the protocol version is
  set, `things.lua:5`).
* If `items.otb` changed, revert it together with `items.xml`, the RME copies and any map
  that already uses the new id (`edit-map-content.md`). A map saved with item ids missing
  from `items.otb` stops the server with `> FATAL: OTBM Loader - This map needs an updated items.otb.`
