# Phase 3 screenshots

These are the curated screenshots of the PokeNation client (`client-pokenation/`) and the frozen
legacy client (`client/`), both connected to the local PSoul server. The images are in
[`../images/phase3/`](../images/phase3/), converted to JPEG (quality 80) to keep the repository
small. Every image comes from a real run against the real server, never from a mock-up.

## Where they come from

| Source | How to reproduce | What you get |
|---|---|---|
| CI artifact `PokeNation-Phase3-Screenshots` (job `gui-smoke`, workflow `pokenation-client.yml`) | every push | all scenarios as PNG, each with `otclient.log`, `client-console.log`, `result.log`, plus `results.txt` and `server.log` |
| Local run | start the server, then `tools/pokenation_gui_smoke_ci.sh --client <PokeNationClient> --out /tmp/gui-smoke` | the same files under `/tmp/gui-smoke/<scenario>/` |
| Legacy client (images 40–42) | manual run of `build/linux-development/client/psoulclient` from a temporary copy of `client/` with an auto-login script appended to `init.lua`. Commands were typed into the chat with `xdotool`, because the legacy client blocks `g_game.talk` from Lua as bot protection. Not automated | screenshots only |

Each scenario starts from `tools/pokenation_smoke/seed_smoke.sql`. Account `admin`/`admin` gets
20 Soul Coins. GM Admin gets a bank balance of 12345 and 5 red apples in the depot. The test
polls are inserted, and the shop and market history is cleared.

## Images

All images show the PokeNation client unless the caption says legacy. "Check" names the smoke
check that passed in the same run (`result.log`).

| File | Shows | Check |
|---|---|---|
| `01-login.jpg` | Enter Game window, fixed local server | — |
| `02-charlist.jpg` | character list with PSoul level, vocation and outfit | `charlist parsed with PSoul extras` |
| `03-world.jpg` | Tester in the world, legacy sprites (Stage A assets) | `local player placed` |
| `04-poll-choice.jpg` | poll window, option poll | `poll choice sent from the window (0xFB)` |
| `05-poll-text.jpg` | poll window, text poll | `poll text answer sent from the window (0xFB)` |
| `06-shop.jpg` | PokeNation Shop: server catalog, 20 Soul Coins | `opcode 201 fetch answered by catalog + balance` |
| `07-shop-purchase.jpg` | after buying Stamina recover: "You bought 1x … for 1 Soul Coins", balance 19 | `opcode 201 purchase charged by server` |
| `08-shop-history.jpg` | purchase history from `datalog_shop_purchases` | `opcode 201 history lists the purchase` |
| `09-market.jpg` | market window at Jaron Jewell with the `0xF6` balance 12,345; item list empty (BUG-78); Tibia-coin "Get" button still shown | `market window shows the 0xF6 balance` |
| `10-teambar.jpg` | team bar with Venusaur and Rattata, vitals panel; right gauge of the top status bar reads 9999999999 (BUG-79) | `team bar shows the team (0xFF 0x04)` |
| `11-summoned.jpg` | Venusaur summoned, move bar filled (14 moves) | `/cp summon marks the slot in use`, `move bar filled` |
| `12-combat.jpg` | Venusaur fighting a GM-spawned Rattata; move bar with F-key labels and a cooldown | `combat: used move shows its cooldown (0xFF 0x09)` |
| `13-catch.jpg` | wild Rattata caught; team bar grows from 2 to 3 | `catch: wild Pokemon caught and added to the team bar` |
| `14-details.jpg` | Pokémon details window (`/pd`) | `/pd Pokemon details window` |
| `15-pokedex.jpg` | Pokédex entry (`/dv`) for Rattata | `/dv Pokedex entry shown (0xFF 0x11)` |
| `16-returned.jpg` | Pokémon returned via the ball slot; move bar dimmed | `ball-slot use returns the Pokemon and dims the move bar` |
| `17-tm-confirm.jpg` | TM chooser (`0xFF 0x0D`) | `TM chooser opened` |
| `18-caught-summoned.jpg` | the level 1 Rattata summoned with its single move | `/cp summon the level 1 Pokemon` |
| `19-statusbar.jpg` | potion status icon with countdown, top right of the map | `status icon drawn` |
| `20-levelup.jpg` | Pokémon level-up pop-up (real `0xFF 0x19` from the server) | `Pokemon level-up popup drawn` |
| `21-loot.jpg` | autoloot strip (`0xFF 0x1A`) | `autoloot list strip` |
| `23-levelup-many-moves.jpg` | level-up pop-up with 14 new moves as an icon grid inside the map. Synthetic: the event is fired locally with 14 moves (UI only, BUG-60) | `level-up popup shows all 14 new moves inside the map (UI only)` |
| `30-tv-recording.jpg` | GM Admin recording a TV channel | `TV channel created (record.lua)` |
| `31-tv-viewer-joined.jpg` | recorder side after Trainer joined | `/tvlist lists the viewer (server side)` |
| `32-tv-watching.jpg` | second client (Trainer) watching: map around the recorder, TV channel tab; GM Admin is drawn twice (BUG-77) | `watching: map re-sent around the recorder (sendTVStart)` |
| `33-tv-left.jpg` | viewer after leaving: Trainer back at its own position, TV channel tab gone. The "You've Reached Level 5" pop-up in 32 and 33 is real: on the first login of a fresh seed the server recalculates Trainer from level 1 to 5 | `logout` |
| `40-legacy-language.jpg` | legacy client: first-start language dialog and message of the day | — |
| `41-legacy-summoned.jpg` | legacy client, same server, GM Admin: team bar (Venusaur, Rattata), Rattata summoned, its move bar | — (manual) |
| `42-legacy-wild-battle.jpg` | legacy client: GM-spawned wild Rattata attacking (Quick Attack), team bar health 44 % | — (manual) |

Images 22 (second return) and the default login and walk frames of the other scenarios are only
in the CI artifact.
