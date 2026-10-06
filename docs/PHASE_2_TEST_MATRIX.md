# Phase 2 — gameplay test matrix

Status of every Pokémon/game system of the PSoul (PokeAimar) baseline, as **observed** on the
locally built server and client. Nothing in this document is marked working because its source
code exists; a feature is `PASS` only when the observable behaviour was reproduced on
`127.0.0.1:7564/8548` with a client we compiled ourselves (graphical client
`build/client/psoulclient`, or the protocol probe `tools/protocol_probe.py`, which speaks the same
version-312 protocol).

Statuses: **PASS** (behaviour verified end to end) · **PARTIAL** (part of the flow verified, the
rest not reachable or not exercised) · **FAIL** (verified broken) · **BLOCKED** (could not be
exercised because of a prerequisite that is itself a finding) · **NOT TESTED** (code inspection
only; see the "Suspected" columns for what to look for).

Priorities follow `docs/BUG_TRIAGE.md`: P0 prevents server/client running · P1 breaks core
Pokémon gameplay · P2 breaks a major system · P3 minor gameplay/content bug · P4 cosmetic/cleanup.

## 0. Test environment

| Item | Value |
|---|---|
| Server | `server/psoul-server` (CMake build tree `build/server/`, `tools/build_server.sh`) built from `server/` (commit range `0db5da0`..HEAD), run from `server/` with the git-ignored `server/config.lua` (copy of `server/config.example.lua`, local DB password) |
| World type | `worldType = "pvp"` (changed from the archive's `no-pvp`, see test **P2-29** and BUG-01) |
| Database | MariaDB 10.11, `mysql.sql` + `psoul_extra_mysql.sql` + `psoul_dev_seed.sql` (`tools/setup_database.sh`) |
| Accounts | `admin`/`admin` → **GM Admin** (group 6, Pewter 3307,300,7) and **Tester** (group 1); `player`/`player` → **Trainer** (group 1, Beginner Island 5000,806,6). Dev-only passwords, not production. |
| Clients | `psoulclient` (OTClient 0.6 fork, `client/src-cpp`) on X display `:1`; `python3 -u tools/protocol_probe.py enter …` for scripted runs |
| Evidence | probe transcripts `t01`…`t23` (kept outside the repo during the session), server console (`tmux` session `psoul-server`), GUI screenshots. Quoted strings below are verbatim server output. |

Probe conventions used in the "Exact test" column: `--say` = normal talk, `--npc` = NPC channel
talk after `--approach`, `--use-slot N` = use the item in inventory slot N, `--open N` = open the
container in slot N, `--use-on-slot SID:N` / `--use-on SID:NAME` / `--use-on-tile SID:self[:STACK]`
= "use with" on an inventory slot / creature / map tile, `--catch` = throw the empty ball on the
last corpse, `--wait-dead NAME` = block until that creature dies. Inventory slots: 1 order icon,
2 evolve icon, 3 (hidden by the client UI) backpack, 5 badge case, 6 Pokédex, 7 portrait, 8 ball,
10 pokebag.

GM characters have infinite mana (groups 4–6, `server/src/player.cpp`), which PSoul uses as
Pokémon *energy*; the result is that **GM Pokémon cannot use moves at all** ("Sorry, your Pokemon
has insufficient energy (12).", test P2-06). Everything that needs moves was therefore run with
the group-1 characters **Trainer** or **Tester** (Tester was raised to level 100 and given a
level-100 Pidgeot by SQL for the NPC-battle test only).

---

## 1. Executed tests

### Core progression

**P2-01 · Account login, MOTD, character list, world entry — PASS**
- Exact test: GUI: start `tools/start_client.sh`, account `player`/`player`, OK, OK on the MOTD, Enter on the character list. Probe: `enter --account admin --password admin --character "GM Admin"`.
- Expected: character list from the login server (7564), game connection (8548), map + inventory + "Welcome to Genesis World!" messages.
- Actual: both clients enter the game; server prints `Trainer has logged in.`; the three welcome texts (`text 0x18`) and the Help/Wiki Chat channel greetings arrive; health 50/50, Balls 399 (after a few tests), Respect 100 shown in the GUI.
- Source: `server/src/protocollogin.cpp`, `server/src/protocolgame.cpp:280-420`, `server/data/creaturescripts/scripts/login.lua`, `client/modules/client_entergame`.
- Errors: none. Priority: –.

**P2-02 · Starter Pokémon from Professor Oak (new player) — PASS**
- Exact test (Trainer, level 5, no Pokémon): GM `/send Trainer;5020,789,7`; Trainer `--say hi --npc charmander --npc yes --npc male`.
- Expected: Oak dialogue, a Charmander ball added, Pokémon bar icon.
- Actual: "You can choose a {Charmander} or a {Squirtle} or a {Bulbasaur}. What is your choice?" → "You really want a Charmander?" → "Your Pokemon will be {female} or {male}?" → "You received a Charmander." and "Good choice! Congratulations, here is your first {Pokemon}!…"; bar icon item 10638 `100%`.
- Source: `server/data/npc/scripts/professorTommy.lua` (Professor Oak XML), `lib/ps/config/balls.lua doCreatePokemonBall`.
- Errors: none. Note: Beginner Island / `login.lua:48-60` "+4 levels" branch does not apply to seed characters (they start with bag 12282, not the locked bag 13499). Priority: –.

**P2-03 · Starting kit (Pokédex, Pokébag, order icon, ball support, evolve icon) — PASS (after seed fix)**
- Exact test: inventory dump on login for all three characters; open slot 10.
- Expected: slot 1 order icon, 5 badge case, 6 Pokédex, 10 pokebag with 100 empty balls, 100 pokemon food, 20 potions, a rod and misc; evolve icon in slot 2.
- Actual: slots 1/5/6/10 present (`13206`, `12280`, `12281`, `12282`), bag contents `12157x100, 2687x100, 12244x20, 2120, 12292`. Slot 2 was **empty** in the Phase 1 seed → the client's right-click "Evolve" and the evolve action could not be used. Fixed in commit `73b854c` (`psoul_dev_seed.sql` now adds `13204` to slot 2 for the three characters); re-imported seed verified (`inventory slot 2 = 13204`).
- Source: `server/src/schemas/psoul_dev_seed.sql:59-90`, `lib/ps/functions/player.lua:717-723 doPlayerAddMainItems`.
- Errors: none. Priority: P3 (fixed).

**P2-04 · Call / return Pokémon, Pokémon bar, order icon swap — PASS**
- Exact test: `--use-slot 8` with a charged ball (12159); `--call-poke <icon>` (sends `/cp N`); `--use-slot 8` again while out.
- Expected: speech "X, go!" (random variants), bar icon `USE`/`100%`/`FNT`, order icon 13206 ↔ 7730, "X, back!" variants.
- Actual: "Charmander, go!", "Charmander, I choose you!", "Flareon, it's the battle time!", "Flareon, I need your help!" (GUI screenshot shows the full set), "Charmander, back!"; bar icon text alternates `USE` ↔ `100%` ↔ `FNT`; slot 1 shows 7730 while the Pokémon is out.
- Source: `lib/ps/functions/others.lua:699-898 doPokemonCall`, `lib/ps/functions/ball/{charged,inUse}.lua`, `lib/ps/functions/player.lua:616-641 setPlayerIcons`, `client/modules/game_pokebar`.
- Errors: none. Priority: –.

**P2-05 · Wild battle, damage, experience, Pokémon level-up, loot message — PASS**
- Exact test (Trainer, Charmander lvl 5): `--attack "Caterpie"` / `--attack "Rattata"` then `--say m1 --say m2 --wait-dead …` outside the PZ at Pewter (3307,304,7; GM spawned the targets with `/m Rattata`).
- Expected: damage lines, exp for the Pokémon, player exp, level-up message, loot line.
- Actual: "Your Charmander deals 94 damage to a Rattata.", "Your Charmander received 1050 experience points.", "Congratulations! Your Charmander advanced from level 5 to level 6.", "You received 157 experience point(s).", "Loot of a Rattata: a mouldy cheese, a bitten apple."; player exp 878 → 1035; `/exp` → "Your Charmander is at level 6 and has 2375 experience points, he needs more 225(20%) experience points to advance to level 7."
- Source: `lib/ps/systems/004-skillDamage.lua`, `lib/ps/functions/player.lua:420-480 doPlayerPokemonAddExperience`, `server/src/monsters.cpp` loot.
- Errors: none. Priority: –.

**P2-06 · Moves (m1–m6), energy cost, cooldown, PZ restriction — PASS for players, FAIL for GM characters**
- Exact test: Trainer `--say m1` (Tackle) / `--say m2` (Scratch) in combat; GM Admin the same with Charmander and with Flareon; Trainer `--say m1` inside the PZ.
- Expected: "X, Tackle!" speech, energy drop, cooldown packet `0xFF 0x09`, PZ refusal.
- Actual: Trainer: "Charmander, Tackle!", "Charmander, Scratch!", energy 150/150 → 0/0 while fighting (regenerates), cooldown packets seen; inside PZ: "Your Pokemon can't use moves while you're in the protection zone." GM Admin: every move → "Sorry, your Pokemon has insufficient energy (12)." / "(30)" because GM energy is reported `0/0` (infinite mana flag). Wild Pokémon moves work (`Rattata: QUICK ATTACK`, `Tentacool: POISON STING`, `BUBBLEBEAM`, `Caterpie: BUG BITE`).
- Source: `lib/ps/systems/003-skill.lua:70-95`, `lib/ps/events/talkactions/skill.lua`, `server/src/player.cpp` (`hasFlag(PlayerFlag_HasInfiniteMana)` → mana shown as 0), `server/data/XML/groups.xml`.
- Errors: none. Suspected cause: PSoul reuses mana as energy but never special-cases the infinite-mana flag. Priority: P3 (BUG-05; dev/GM only).

**P2-07 · Pokémon Center heal (Nurse Joy) — PASS**
- Exact test: Trainer with a fainted (`FNT`) Charmander at Pewter PC: `--say hi` next to Nurse Joy.
- Expected: Pokémon healed, ball back to charged.
- Actual: "One second... Alright, it's here. Remember that you can also change your {hometown} here. If you want to restore your pokemon again, just say {heal}."; bar icon `FNT` → `100%`; ball 12160 → 12159; "Nurse Joy's Chansey: Chansey! Chansey!".
- Source: `server/data/npc/scripts/nurse_joy.lua:199`, `lib/ps/config/balls.lua:2053-2067 doBallHeal`.
- Errors: none. Priority: –.

**P2-08 · Feeding / hunger — PARTIAL**
- Exact test: GM `--use-on 2687:Charmander` (pokemon food on own Pokémon) right after calling it.
- Expected: hunger messages over time; food accepted when hungry, refused when full.
- Actual: "Your Pokemon is full." immediately after a call; the GUI session later showed "Your Flareon is hungry!" once per minute (14:25–14:31). Feeding a *hungry* Pokémon was not exercised.
- Source: `lib/ps/events/actions/pokemonFood.lua`, `lib/ps/systems/*hunger*` (`lib/ps/functions/pokemon.lua` hunger storage).
- Errors: none. Priority: P4 (message spam every minute is player-visible; see BUG-19).

**P2-09 · Catching, ball break, ball counter, Pokédex catch XP — PASS**
- Exact test: `--wait-dead "Rattata" --catch` (uses empty ball 12157 on the corpse) as GM and as Trainer.
- Expected: "Gotcha!" or "Ouch! Your poke ball broke.", ball-counter message, Pokédex XP.
- Actual (GM, lvl-8 Rattata): "Gotcha! You caught a male Rattata (level 8).", "You received a Rattata.", "You earned 80 experience points by catching Rattata!", "You've wasted 1 poke ball to catch it.", new bar icon. Actual (Trainer, lvl-3 Rattata): "Ouch! Your poke ball broke.", "You've wasted 1 poke ball trying to catch Rattata."
- Source: `lib/ps/functions/ball/empty.lua:163-243`, `lib/ps/systems/020-ballCounter.lua`, `lib/ps/systems/010-pokedex.lua:112-129`; DB `ball_counter`.
- Errors: none. Priority: –.

**P2-10 · Faint, discharged ball, revive path — PASS**
- Exact test: GM Dragonite (lvl 100, no moves) vs NPC Golem; Tester's Pidgeot vs the trainer's second Pokémon; Trainer `--use-slot 8` on a discharged ball.
- Expected: Pokémon removed, "back!", `FNT`, ball 12160, "This ball is discharged." on use, Nurse Joy restores.
- Actual: "Golem hit Dragonite −381" lines until faint, "Dragonite, back!" style message, bar `FNT`, slot 8 = 12160; using it → "This ball is discharged."; healed by Nurse Joy (P2-07).
- Source: `lib/ps/events/creaturescripts/onPokemonDeath.lua`, `lib/ps/functions/ball/discharged.lua`.
- Errors: none. Priority: –.

**P2-11 · Evolution (stone + evolve icon) — PASS**
- Exact test: GM `/mypokemon Eevee,30`, `/i 18083,1` (Fire Stone), evolve icon 13204 in a container, call Eevee, `--use-item 13204`.
- Expected: three-stage message sequence and a Flareon.
- Actual: "Something is happening!" → "Your Pokemon is evolving!" → "Your Eevee has evolved into a Flareon!"; `/exp` now reports Flareon, bar icon changed to 10770, nickname kept afterwards (P2-12). Items created by `/i` land in the slot-3 backpack, which the client UI hides (BUG-12) – the first attempt (`t10c`) failed only because the probe looked in the pokebag.
- Source: `lib/ps/events/actions/evolve.lua`, `lib/ps/functions/pokemon.lua:175-215 doPokemonEvolve`, `lib/ps/config/pokemon/eevee.lua`.
- Errors: none. Not exercised: day/night-gated evolutions (suspected precedence bug `evolve.lua:35`), extra-Pokémon evolutions (Nincada), wild "Evolve" attack. Priority: –.

**P2-12 · Nickname (Soul Trade NPC) — PASS**
- Exact test: GM at Richard (4733,130,7) with 1 Soul Coin (`/i 6500,1`): `hi`, `nick change`, `Flamey`, `yes`; call; `nick remove`, `yes`.
- Expected: paid rename, speech uses the nick, free removal.
- Actual: "I can create or change your Pokemon nickname for 1 Soul Coins. What nickname you want?" → "Flamey, are you sure?" → "Thanks! Your Pokemon nickname has been changed successfully!"; call → "Flamey, it's the battle time!"; `/exp` → "Your Flamey is at level 30…"; removal → "Thanks! Your Pokemon nickname has been removed successfully!". Island Soul Trade NPC Erik (4411,1745,6) answers "You do not have enough access to deal here!" (Orange Archipelago gating, expected).
- Source: `server/data/npc/scripts/soulTrade.lua:479-596`, `lib/ps/config/balls.lua:1861-1867`.
- Errors: none. Not exercised: species-name nick (`pokemonsNames.lua:857` case bug, BUG-26). Priority: –.

**P2-13 · Status conditions (poison) and status bar packets — PASS**
- Exact test: Trainer's Charmander attacked by a Tentacool (`/m Tentacool` by GM).
- Expected: condition applied, `0xFF 0x0E` status-add with icon id and seconds.
- Actual: `Tentacool: POISON STING` → `[status icon add] item 16718 cooldown 16` (POISON, 16 s, matches `008-conditions.lua`); "You lose 50 hitpoints due to an attack by a Tentacool." for the trainer. GUI: status icons render above the Pokémon bar (Rattata [3] with icons in the screenshot).
- Source: `lib/ps/systems/008-conditions.lua`, `server/src/protocolgame.cpp:3289-3337`, `client/modules/game_statusbar`.
- Errors: none. Not exercised: PROTECT/ENDURE/MIRACLE EYE subid bugs (BUG-27). Priority: –.

**P2-14 · Player commands — PASS (mixed content)**
- Exact test: GM `--say` each of `/held /addon /boss /autoloot /time /afk /dv /find /lang /cupom test /list /tvlist /help`.
- Actual replies in order: "Your Pokemon doesn't have a Held item." · "You must call your Pokemon first." · "You are able to receive another World Boss reward." · "Auto Loot OFF!" (see P2-24) · "The time now is 17:51 (day)." · "AFK ON!" · "First get your Pokemon." (`/dv` without a dexed id / `/find`) · "Incorrect language! Please type 'english' or 'portugues'." · "Sorry, not possible." ×3 (`/cupom test` – no `coupons` row; `/list` – not in a guild; `/tvlist` – no channel) · `/help` silent.
- Source: `server/data/talkactions/talkactions.xml`, `lib/ps/events/talkactions/*`.
- Errors: none. Priority: –.

**P2-15 · `/exp` and experience display — PASS** ("Your Squirtle is at level 10 and has 9300 experience points, he needs more 3700(100%) experience points to advance to level 11."). Source `lib/ps/events/talkactions/pokemonExperience.lua`.

### Moves, TMs, held items, vitamins

**P2-16 · TM use and move replacement window — PASS**
- Exact test: GM Flareon (in ball), TM Toxic 17342 in slot-3 backpack: `--open 3 --use-on-slot 17342:8`; the probe then answers the window with `/tc <clientIconId>` of Quick Attack.
- Expected: `0xFF 0x0D` window, "Poof!" message, moves list updated.
- Actual: `[PS] TM window move=15743 replaceable=[11749, 12034, …]`, "Select the move that will be replaced by Toxic. (Shift + Click on move icon to details)" → "1, 2, and ... ... ... Poof! Flareon forgot Quick Attack. And... Machine Set! Flareon learned Toxic!"; next call lists `15743` instead of `11749`.
- Source: `lib/ps/systems/018-technicalMachine.lua:648-814`, `lib/ps/events/actions/tm.lua`, `client/modules/game_tmchoose`.
- Errors: one `[Error - Action Interface] …/tm.lua:onUse (luaGetItemAttribute) Item not found` when the TM was used on a ball while the Pokémon was *out* (cancel branch without `return`, BUG-21). Priority: P4.

**P2-17 · Held item (Black Belt) — PASS**
- Exact test: `--use-on-slot 23513:8` with Flareon inside the ball; `/held`.
- Actual: "Your Pokemon received the Black Belt held item!", `/held` → "Your Pokemon Held item is at level 1 and has 0 experience points, he needs more 98800(100%) experience points to advance to level 2."
- Source: `lib/ps/systems/046-heldItem.lua:478-606`. Not exercised: damage modifier, held level-up (suspected nil compare at level 6→7, BUG-28). Priority: –.

**P2-18 · Vitamin (Calcium) — PASS**
- Exact test: `--use-on-slot 23450:8`.
- Actual: "Your Pokemon received the Calcium vitamin! Now he have got 1 Calcium's (+5% Special Attack) and a total of 1 vitamin."
- Source: `lib/ps/systems/040-vitamin.lua:169-220`. Not exercised: 3-per-kind / 10-total limits, stat effect. Priority: –.

### Eggs, field abilities, addons

**P2-19 · Egg incubator (empty → hatching → hatched after 60 min) — PASS**
- Exact test: GM `/i 14009` (Ponyta egg), `/i 14048` (incubator); `--open 3 --drop 14009` then `--use-on-tile 14048:self:3` (incubator on the dropped egg); `--open 3 --use-item 14049` one minute later and again 61 minutes later.
- Expected: incubator becomes 14049, "hatching now" message; full incubator reports remaining time; hatch after 60 min with the new Pokémon's ball delivered.
- Actual: "Your Ponyta egg is hatching now! Use this incubator again after 60 minutes." (effect 31), container now holds `14049`; using it early: "Sorry, not possible." + "Remaing 60 minutes (1 days) for this egg to hatch." Using it at +61 min: "Congratulations! Your Ponyta egg hatches!" and "Congratulations! You received a Ponyta, this ball will be teleported directly to the pokemon center."; the incubator was consumed (backpack now holds only the evolve icons) and `player_depotitems` gained a charged ball `12159` inside the depot chest (`2589` → `2594` → `12159`).
- Source: `lib/ps/events/actions/eggIncubator/{emptyIncubator,fullIncubator}.lua`, `lib/ps/systems/045-pokemonEgg.lua`, `lib/ps/config/balls.lua:2140-2158` (`forceToDepot` path).
- Errors: none. Findings: "(1 days)" for a 60-minute timer and the typo "Remaing" (P4, BUG-29); the incubator used on the *ground* (stackpos 0) says "You can only use the incubator in an Pokemon egg." because `Actions::executeUse` resolves the target by exact stackpos. Daycare (level 85 + premium) NOT TESTED. Priority: P4.

**P2-20 · Ride — PASS**
- Exact test: Trainer-independent, GM with Ponyta out: `--use-on-tile 7730:self`; `/up`; `--use-on-tile 7730:self` again.
- Actual: "Ponyta , let's ride!" (outfit changed to the ride lookType), `/up` → "Sorry, not possible." (correct while riding), second use → "Ponyta, I'm tired of riding!".
- Source: `lib/ps/events/actions/abilities.lua:200-221`, `lib/ps/functions/abilities.lua:349-387`.

**P2-21 · Fly, `/up`, `/down` — PASS**
- Exact test: GM with Pidgeot out: `--use-on-tile 7730:self`, `--say /up`, `--say /down`, `--use-on-tile 7730:self`.
- Actual: "Pidgeot, let's fly!"; `/up` → "Pidgeot, go up!" and the player moves to floor 6 on a VOID tile (sid 460); `/down` → "Pidgeot , go down!"; dismount → "Pidgeot, I'm tired of flying!".
- Source: `abilities.lua:223-256`, `lib/ps/events/talkactions/flyUp.lua`, `flyDown.lua`.
- Not exercised: Surf, Dive, Cut, Dig, Rock Smash, Headbutt, Strength (typo `"Strenght"` in 11 species, BUG-30), Teleport, Find, fishing, ski, sandboard, oxygen mask.

**P2-22 · Pokémon addon item and `/addon` — PARTIAL**
- Exact test: GM Bulbasaur out, `--use-on 29562:Bulbasaur` (Blue Cap); `--say /addon`.
- Expected: addon stored on the ball and the outfit window offering it.
- Actual: both commands make the server send opcode `0xC8` (outfit/addon window, 114 and 33 bytes); the window content was not inspected and no choice was sent back, so the "Your Pokemon received the %s addon." path is unverified.
- Source: `lib/ps/systems/038-pokemonAddon.lua:2154-2216`, `creaturescripts/scripts/onCustomOutfit.lua`.
- Errors: none. Priority: –.

### NPC battles, quests, social, economy

**P2-23 · Wiki Chat channel — PASS**
- Exact test: open channel 449 (`--raw 98 c1 01`), speak `english` (raw `96 07 c1 01 …`).
- Actual: greeting "Welcome to the Wiki Chat! … Your options are: 'English' and 'Português'." on open; `english` → "Select a category to continue: 'essential', 'basic', 'intermediate' or 'advanced'."; own line not echoed.
- Source: `lib/ps/systems/031-wikiChat.lua`, `lib/ps/config/002-wikiChat.lua`, `creaturescripts/onTalkChannel.lua`.
- Note: speaking with type `0x05` (private) gets no answer; the client uses `0x07` (channel). Priority: –.

**P2-24 · Autoloot toggle persistence — FAIL**
- Exact test: `--say /autoloot` once per login over four logins (t12, t18 and others).
- Expected: ON/OFF alternates and the last state survives a relog.
- Actual: every fresh login prints "Auto Loot OFF!" – the C++ default is `autoLoot = true` (`server/src/player.cpp:69`), `login.lua:183-185` only restores a saved `true`, and the OFF state is therefore never persisted; a player who turns autoloot off gets it back ON at the next login. Loot collection itself ("Loot of a Rattata: …") works.
- Source: `lib/ps/events/talkactions/autoLoot.lua`, `creaturescripts/scripts/login.lua:183-185`, `server/src/player.cpp:69`, `server/src/actions.cpp:508-534`.
- Priority: P3 (BUG-04).

**P2-25 · Town guide map marks — PASS**
- Exact test: GM at Guide Emil (3301,303,7): `hi`, `mark`.
- Actual: opcode `0xDD` (map marks, 237 bytes) received; "Here you go." style reply.
- Source: `server/data/npc/scripts/guide.lua`, `lib/ps/systems/026-guide.lua`. Priority: –.

**P2-26 · Quest framework (Jack Simps, deliver 25 bitten apples) — PASS**
- Exact test: GM at 3933,316,7 with `/i 12115,25`: `hi`, `quest`, `yes` (start), `hi`, `quest`, `yes` (finish).
- Actual: quest started; on hand-in "You received 5x note of hundred dollars." and 2000 exp (player exp +2000), storage 8001 finished.
- Source: `lib/ps/systems/002-quest.lua`, `lib/ps/config/003-quest.lua:28-43`, `npc/scripts/quest_default.lua`. Priority: –. Not exercised: defeat/catch quest types, daily quests (suspected wrong remaining-time maths `002-quest.lua:416-420`).

**P2-27 · Bank (deposit / withdraw / balance / history) — PASS; transfer — PARTIAL**
- Exact test: GM at Emmet Cash (4709,130,6): `deposit` → `500`; `withdraw` → `100`; `balance`; `transfer` → `100` → `Tester`.
- Actual: "Alright, it's done. Is there something else I can do for you?" after each; `balance` → "Your account balance is 400 dollar(s)."; two rows in `datalog_bank_transactions`. Transfer: after the name the NPC asks "Please retype the name of the player who will receive the amount."; the probe answered out of order and got "Sorry, any account has founded with this name." – the 4-step dialog (`bank.lua:203-240`) is the reason, not a verified defect.
- Source: `server/data/npc/scripts/bank.lua:123-263`. Content finding: the Kanto bank NPCs (Billy, Cage, Chris, Cole, Craig, Daimon, Lars, Arthur Jones, Shayne Pete) exist only in the unused `world/-spawn.xml`; on the live map ungated banks are Emmet Cash (4709,130,6), Hedley Mort (2753,2833,7), Hilary Aston (2710,2455,8); Todd Clancy answers "You do not have enough access to deal here!" (island gating). Priority: P3 content (BUG-15).

**P2-28 · Tournament scheduler broadcast — PASS (scheduling) / PARTIAL (listing)**
- Actual: server broadcast "The Starter tournament (Pokemon Level 20 - 40) will begin in 3 hours! Visit Joey at PvP area for more information." observed; startup prints `[Warning - Tournaments::getTournament] Tournament 2 not found.` / `3 not found.` plus `[Error - Npc interface] …/tournament.lua (luaGetTournamentInfo) Tournament not found` because ids 2/3 are commented out in `XML/tournaments.xml` while `npc/scripts/tournament.lua:21-30` iterates all ids. Joey's list was not opened.
- Source: `server/src/tournament.cpp`, `XML/tournaments.xml:25-66`, `npc/scripts/tournament.lua`. Priority: P4 (BUG-20).

**P2-29 · NPC trainer battle — BLOCKED under the shipped `worldType = "no-pvp"`, PASS (loss path) under `pvp`**
- Exact test: Tester (lvl 100, Pidgeot 100 by SQL) at trainer Chandra Wigington (3299,246,10): `hi`, `battle`, `yes`; `--attack "Golem"` + `--say m2..m6`; wait.
- Actual with `no-pvp` (archive default): the duel starts but every attack is refused with "You may not attack this creature." while the NPC's Golem hits back ("Golem hit Dragonite −381"); the player cannot even log out ("You can't logout while you're battleing."). Cause: `Combat::canDoCombat` (`server/src/combat.cpp:298-331`) refuses, under `WORLD_TYPE_NO_PVP`, any attack on a creature that has a master (line 313) *before* reaching the NPC-opponent exception (322-326). Fix applied for the dev environment only: `worldType = "pvp"` in `server/config.example.lua` (with a comment) and in the local config; player-vs-player remains blocked by `combat.cpp:272-284` (duel/arena only).
- Actual with `pvp`: attacks accepted; "Your Pidgeot received 1153.125 experience points.", "You received 345 experience point(s).", "So you aren't so weak." after the first NPC Pokémon, 922.5 exp after the second; Pidgeot then fainted → "You have been defeated by Chandra Wigington!" and "Your battle loss has increased to 11.". The *win* path (reward, respect, badge) was not reached.
- Source: `lib/ps/systems/001-npcBattle.lua:427-800`, `server/src/combat.cpp:298-331`, `server/config.example.lua:58-63`.
- Errors: when the probe disconnected during a battle: 4× `[Error - CreatureScript Interface] …/onLogout.lua:onLogout` (`Player not found when requesting player info #18`, `Thing not found`, `Creature not found` ×2). Priority: P1 config (BUG-01), P4 fractional exp text (BUG-07), P3 onLogout errors (BUG-06). Gyms (Brock 3309,279,10 etc.) NOT TESTED.

**P2-30 · Pokémon Market NPC (Jack Eden, 4733,141,6) — PARTIAL**
- Exact test: `hi`, `list`, `buy`, `bye`.
- Actual: "Welcome to the Pokemon Market! Here you can {buy} or {sell} Pokemon. You can also {list} or {cancel} your offerts." · `list` → "You don't have any offerts!" · `buy` → "Please tell me the Pokemon name that you want to buy. If you want to list all shinies, enter {shiny}!". Selling/buying a Pokémon not exercised (suspected unpaid-seller path `shop_pokemonMarket.lua:163-185`, BUG-31).
- Source: `server/data/npc/scripts/shop_pokemonMarket.lua`; DB `pokemon_market`.

**P2-31 · PokeTrader auction NPC (Tiger Kelsey) — PARTIAL**
- Exact test: locate the NPC (created at a random town at startup, found at Pewter 3358,294,7 this run); `hi`, `offer`, `bid`.
- Actual: "Hello GM Admin! I'm the PokeTrader! …" · `offer` → "Mmm... Let me see, oh here is! These are my offerts." · `bid` → "Argh, you do not have any bid offert now! Please take a look at my {offerts}."; `poketrader_offerts` has 4 rows generated at startup (deadline +7 days). A bid was not placed (suspected `getPlayerBoughtOnPokeTrader` always-true bug, BUG-32). Phase 1 note: before `psoul_extra_mysql.sql` was imported the startup printed `(luaDoCreateNpc) Npc with name 'Tiger Kelsey' not found` because `poketrader.lua` failed to load without its tables.
- Source: `server/data/npc/scripts/poketrader.lua`, `globalevents/scripts/start.lua:143-156`.

**P2-32 · Anniversary seasonal event — PARTIAL (auto-start observed, not played)**
- Exact test: watch the console for ≥1 h after boot; `/goto 5307,312,6` 20 min after a restart.
- Actual: in the earlier long-running session the console printed `> Broadcasted message: "Cake Minions".` (raid `anniversary` fired by `globalevents.xml:13` one hour after boot) – the event **is live on a non-anniversary server**; the boss area was empty at +20 min (expected). Minion kills, surprise bags and the "Mad Big Cake" boss were not played. No permanent switch was changed.
- Source: `lib/ps/systems/048-anniversaryEvent.lua:594-600`, `globalevents/globalevents.xml:13`, `creaturescripts/onKill.lua:8`, `start.lua:159`.
- Priority: P3 (BUG-14). Other events (Easter, Halloween, Christmas, July Vacation) are switched off by commented hook lines and were only inspected, see §2.9.

### Client (GUI) checks

**P2-33 · Graphical client: login flow, world render, inventory, channels, Pokémon bar, move bar, Pokédex — PASS with UI defects**
- Exact test: `tools/start_client.sh` on display `:1`; login as `player` and as `admin`; open the channel list; summon a Pokémon; hover a move; open the Pokédex; right-click an own Pokémon.
- Actual: the client we compiled (`build/client/psoulclient`, after the Boost.Asio port in `acc55e9`) logs in, draws the map, minimap, health/energy bars, "Balls"/"Respect" counters, inventory (Order, Badges, Dex, bag, ball, portrait), the channel list (`0xAB`), the Pokémon bar with HP % and the move bar with tooltips, the Pokédex window with entries, monster speech bubbles ("Rattata [3]") and status icons.
- Defects seen: the Pokémon bar overlaps the move bar at the bottom-left of the game window (BUG-11); inventory hides slots 2 (evolve icon) and 3 (backpack), so items created with `/i` are invisible (BUG-12); the StaticText crash on monster yells was fixed in Phase 2 (`client/src-cpp` Lua-stack fix); console still prints the harmless `CAST ERROR … TPoint<int>` lines (see `docs/LOCAL_CLIENT_TESTING.md §5.2`).
- Automation note: `xdotool type` only reaches the client after `xdotool windowfocus --sync <id>`; use `xdotool key --window <id> …`.

**P2-34 · Protocol sanity in the graphical client — PASS**
- Custom `0xFF` sub-opcodes decoded by the probe and rendered by the client without desync: `0x01` skills list, `0x09` cooldown, `0x0A/0x0B/0x0C` Pokédex, `0x0D` TM window, `0x0E/0x0F/0x10` status add/remove/clear, `0x11` Pokédex info, `0x13` creature effect, `0x1A` loot list; standard `0xAB` channel list, `0xC8` outfit window, `0xDD` map marks. No packet was redesigned.

---

## 2. Code-inspection sections (NOT TESTED unless stated)

Each entry: what the feature is, how a player reaches it, what to expect, what looked wrong while
reading, and whether a website is involved. File paths are relative to `server/data/` unless they
start with `src/` or `client/`.

### 2.1 Sex / gender — NOT TESTED (observed indirectly: "You caught a **male** Rattata")
- Source: `src/monster.cpp:95-98,1566-1587` (random sex, skull colour), `lib/ps/config/balls.lua:2109-2112`, `lib/ps/functions/others.lua:757-770` (repairs a missing sex on call and logs "Fixing Pokemon Sex").
- Expected: red/black/yellow skull on wild Pokémon, "It's female/male/sexless, level N." on corpses, Captivate/Rivalry/daycare checks.
- Suspected: silent random re-roll of a lost sex attribute masks data loss (P4).

### 2.2 Move damage model — PARTIAL (damage lines, STAB/typing not measured)
- Source: `lib/ps/systems/004-skillDamage.lua:194-332`, `lib/ps/config/skill.lua`, `lib/ps/functions/pokemon.lua:1452-1470`.
- Suspected: `functions/pokemon.lua:227` `bonusDef` reads the attack bonus (P3, BUG-33); `007-cooldown.lua:1-4` day-of-year clock wraps at New Year (P3, BUG-34); no per-move accuracy, misses only through LOWACCURACY/CONFUSION.

### 2.3 Ball seals — NOT TESTED; ball counter — PASS (P2-09)
- Source: `lib/ps/systems/019-ballSeal.lua`, `lib/ps/events/actions/ballSeal.lua:2-4` (cancel without `return`, P4).

### 2.4 Pokédex — PARTIAL (catch XP and client window PASS; corpse/TM/trainer-card uses not exercised)
- Source: `lib/ps/systems/010-pokedex.lua`; suspected `DEX_BY_ITEMID[getPlayerPokedex(cid).itemid]` nil-index when no Pokédex is equipped (P3, BUG-35); evolution never registers the evolved species (P4).

### 2.5 Daycare / egg moves / extra egg rate — NOT TESTED
- Reach: daycare NPC pair, level ≥85 + premium (`npc/scripts/daycareFemale.lua:505-514`); `egg status`, `withdraw`.
- Suspected: incubators use the yday clock (see 2.2); `pokemon/nidorina.lua:19 eggId = 0`.

### 2.6 Surf / Dive / Cut / Dig / Rock Smash / Headbutt / Strength / Teleport / Find / Fishing / Ski / Sandboard / Oxygen mask — NOT TESTED
- Source: `lib/ps/events/actions/abilities.lua`, `lib/ps/functions/abilities.lua`, `lib/ps/systems/036-headbutt.lua`, `043-fishing.lua`, `032-ski.lua`, `042-sandboard.lua`, `033-oxygenMask.lua`, talkactions `/tp`, `/find`.
- Suspected: `"Strenght"` typo in 11 species files (P3, BUG-30); Mudkip/Latias/Latios have Dive but no `OUTFIT_DIVE_*`/`DIVE_SPEED` entry (P3); cranes lack `fishingTime`.

### 2.7 Gyms, badges, badge case — NOT TESTED
- Reach: Brock 3309,279,10 (needs 7 route trainers), Misty 3915,285,10, Lt. Surge 3926,665,5; `hi`, `battle`, `yes`.
- Suspected: badge placeholders (`BADGES[].oldItemId`) are created by nothing in the repo and the seeded badge case is empty, so `doPlayerGiveBadge` (`001-npcBattle.lua:500-502`) may transform nothing (P2, BUG-16); `"[%x]"` hex format in reward text (`001:760`, `050:551`, P4); duplicate Brock/Misty spawns at z=6 share storages.

### 2.8 PvP arena, duels, party duels — NOT TESTED
- Suspected runtime error every 10 min once an arena has users: `009-pvpArena.lua:199-211` passes the arena *table* to `getPvpArenaUsers` and `table.random` on empty `itemRaids.positions` ("TODO POS FIX") (P2, BUG-17). Duel icon 13016; bets 50–30000 via channel 447.

### 2.9 Seasonal events — Anniversary PARTIAL (P2-32); Easter, Halloween, Christmas, July Vacation NOT TESTED
| Event | Gate (all plain Lua, no date check, no config flag) | State |
|---|---|---|
| Easter `030` | `onKill.lua:9`, `onSpawn.lua:2-4` commented; egg/machine/shoe actions always registered | OFF |
| Halloween `037` | `onKill.lua:7`, `onSpawn.lua:7`, `globalevents.xml:21`, `raids.xml:6-11` commented; NPCs Trevor/Hermitwo/Selam on the live map | OFF (NPCs live) |
| Anniversary `048` | `onKill.lua:8` **active**, `globalevents.xml:13` **every 3600 s**, `start.lua:159` resets state | **ON** |
| Christmas `051` | `onKill.lua:10`, `onSpawn.lua:6`, `raids.xml:14-17` commented | OFF |
| July Vacation `055` | `onStaminaChange.lua:2` commented; Walter John not spawned | OFF |
- Safest way to look at an OFF event without enabling it permanently: `/i <reward item>` (egg 18794, Halloween box 28071, present 14639, chest 29117) and use it; or `/raid <name>` once after a temporary `raids.xml` edit on a scratch copy; never flip `enabled="yes"` or `globalevents.xml` in the shared tree. Nothing was changed in Phase 2.
- Suspected: `anniversary_onDeath.lua:5-6` drops the `killer` parameter for plain "Minion Cake" kills (no token, P3, BUG-18).

### 2.10 Safari Zone, Ranger Club, Elite Four, Team Rocket, World Boss, Dungeons, Mastery — NOT TESTED
- Reach: Jeffrey 3920,792,7 (`safari`, 1000 $, level 30); Dan Lambert 3941,471,7 (`join`); Drogo Toby 3115,590,7 (`elite`, level 95 + all badges); `/boss`; Ader 4709,259,6.
- Suspected: `001-rangerClub.lua:30,39,48` duplicated rank ids (P3); `021-boss.lua:266` `sotrageLastBoss` typo (P3); `050-rocketBattle.lua:510-626` reward code commented → no rewards (P3); `028-dungeons.lua` reset removes all creatures including players (P2 if dungeons are used); `014-mastery.lua:453/461` duplicate function.

### 2.11 Highscores, achievements, referral, coupons, surprise box, slot machine, citizens — NOT TESTED (citizens observed: ~60 `tmpCitizen_*` NPC files are regenerated in `data/npc/` at every start)
- `config.lua updateHighscores = false` keeps `player_highscores` static; `start.lua` would call a stored procedure `update_rank()` that no schema defines.
- Suspected: `022-highscores.lua` id 8 without name (P4); `034-surpriseBox.lua MAP_MAX_WIDTH = 2048` vs map width ≈5600 (P3); coupon types ≠0 consume the code without reward (P3).

### 2.12 Item Market (binary market UI) — NOT TESTED
- Reach only through NPC Jaron Jewell (`npc/scripts/market.lua`), **not spawned** on the live map; `doPlayerSendMarketEnter`.
- Suspected: `src/protocolgame.cpp:3617-3624` returns before `setInMarket(true)` when the player has no depot → dead window (P2, BUG-36); `src/game.cpp:7466-7484` deletes bought items when the depot add fails (P2, BUG-37); market config keys absent from `config.lua` (premium-only by default).

### 2.13 Guilds, houses — NOT TESTED
- Guild creation only via Soul Trade NPC (5 Soul Coins, level 40); `!createguild` commented. Houses: `/house buy` at a door (premium + level 50). No guild-war code or tables.

### 2.14 TV system — NOT TESTED (`/tvlist` answered "Sorry, not possible." with no channel)
- Record item 14359 (premium); viewer needs a map-placed TV (`watch.lua` rejects GM-created TVs).

### 2.15 Polls — NOT TESTED (hard website dependency: rows in `polls`/`poll_options`/`poll_texts`; server only writes `poll_votes`; option id truncated to one byte `protocolgame.cpp:4871`).

### 2.16 Statistics / datalog — PASS (passive): `datalog_online` (19 rows), `datalog_bank_transactions`, login rows are written; no player-facing `/stats`.

### 2.17 Doll case, badge case — NOT TESTED (`dollBox.lua:14-15` duplicate Scyther entry, P4).

### 2.18 Shop / premium / Soul Coins — PARTIAL (nick change with a GM-created Soul Coin PASS)
- Coins and premium days come from `accounts.soulcoins` / `accounts.premdays`, written by the missing website; `/coupon` needs `coupons` rows. Client `game_shop` module is dead (not loaded, opcode 103 never sent).

### 2.19 Account / character creation — NOT POSSIBLE IN GAME (by design): `accountManager = false`, login only; the seed SQL is the local substitute.

### 2.20 Extra rates (exp/loot/catch/egg) — NOT TESTED
- Only started by items/events (`xpBoostPotion.lua` 29131, Halloween faction NPC); no GM command or config switch.

---

## 3. Status summary

| Area | PASS | PARTIAL | FAIL | BLOCKED | NOT TESTED |
|---|---|---|---|---|---|
| Core progression (login, starter, kit, call/return, battle, exp, heal, catch, faint, evolution, nickname, status, commands) | 13 | 1 (feeding) | 1 (GM energy) | – | sex internals |
| Moves / TMs / held / vitamins | 3 | 1 (damage model) | – | – | limits, modifiers |
| Eggs / abilities / addons | 3 (incubator + hatch, Ride, Fly) | 1 (addon) | – | – | daycare, Surf/Dive/Cut…, seals |
| NPC battles / gyms / quests | 1 (quest) | 1 (NPC battle loss path) | – | 1 under `no-pvp` | gyms, badges |
| Economy / social | 3 (bank, Wiki Chat, guide) | 3 (transfer, Pokémon Market, PokeTrader) | 1 (autoloot persistence) | – | market UI, guilds, houses, TV, polls, shop |
| Events / meta | 1 (tournament broadcast) | 1 (anniversary) | – | – | 4 events, safari, ranger, elite four, rocket, boss, dungeons, mastery, highscores… |
| Client / protocol | 2 | – | – | – | – |

Everything in the NOT TESTED column is intentionally **not** claimed to work; it is the backlog
for Phase 3 testing and is already annotated with the most likely defects.
