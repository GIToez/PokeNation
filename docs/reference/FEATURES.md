# Feature reference

One row per player-facing system. Status values:
**VERIFIED WORKING** (PASS in [`../PHASE_2_TEST_MATRIX.md`](../PHASE_2_TEST_MATRIX.md)),
**IMPLEMENTED / UNVERIFIED**, **PARTIAL**, **BROKEN**, **DISABLED**, **WEBSITE DEPENDENT**,
**CLIENT DEPENDENT**, **HISTORICAL** (several may apply). Background, loading details and
evidence for every status: [`../FULL_SOURCE_AUDIT.md`](../FULL_SOURCE_AUDIT.md) (section in the
"Audit" column). Protocol details: [`OPCODES.md`](OPCODES.md). Bugs: [`../BUG_TRIAGE.md`](../BUG_TRIAGE.md)
(BUG-58…BUG-72 were added in Phase 2A; evidence in FULL_SOURCE_AUDIT §17).

Paths: `sys/` = `server/data/lib/ps/systems/`, `ev/` = `server/data/lib/ps/events/`,
`npc/` = `server/data/npc/scripts/`, `cl/` = `client/modules/`.

Other catalogs: [COMMANDS](COMMANDS.md) · [POKEMON](POKEMON.md) · [MOVES](MOVES.md) ·
[POKEBALLS](POKEBALLS.md) · [ITEMS](ITEMS.md) · [NPCS](NPCS.md) · [QUESTS](QUESTS.md) ·
[ACHIEVEMENTS](ACHIEVEMENTS.md) · [DATABASE](DATABASE.md) · [BROKEN_REFERENCES](../BROKEN_REFERENCES.md)

## Core progression

| Feature | Status | Evidence | Main source | How the player reaches it | Bugs | Audit |
|---|---|---|---|---|---|---|
| Login, MOTD, character list | VERIFIED WORKING, CLIENT DEPENDENT | P2-01, P2-33 | `server/src/protocollogin.cpp`, `cl/client_entergame` | client login | BUG-08, BUG-09, BUG-62 | §11 |
| Account / character creation | WEBSITE DEPENDENT | matrix §2.19 | `protocollogin.cpp:198-201` | website (missing); dev seed SQL | — | §13 |
| Starter Pokémon | VERIFIED WORKING | P2-02 | `npc/quest_professorOak.lua` | Professor Oak | BUG-24 | §5 |
| Gameplay tutorial / guide | IMPLEMENTED / UNVERIFIED, CLIENT DEPENDENT | `login.lua:69-86` | `gameplayTutorial_*`, `cl/game_guide` (`0x32` ids 8/9) | first login | — | §5.1 |
| Call / return, Pokémon bar | VERIFIED WORKING, CLIENT DEPENDENT | P2-04 | `sys/006-fastcall.lua`, `cl/game_pokebar` | use ball / bar | BUG-11 | §5 |
| Catching | VERIFIED WORKING | P2-09 | `ev/actions/balls`, `lib/ps/config/balls.lua` | use ball on corpse | BUG-22 | §5 |
| Ball counter | VERIFIED WORKING | P2-09 | `sys/020-ballCounter.lua` | automatic | — | §5 |
| Ball seals | IMPLEMENTED / UNVERIFIED | matrix §2.3 | `sys/019-ballSeal.lua`, `ev/actions/ballSeal.lua` | seal items | BUG-21 | §5 |
| Leveling / experience | VERIFIED WORKING | P2-05, P2-15 | `onGainExperience.lua`, `/exp` | wild battles | BUG-07, BUG-13 | §5 |
| Level-up popup | IMPLEMENTED / UNVERIFIED, CLIENT DEPENDENT | `0xFF 0x19` | `cl/game_advanceeffect` | level up | BUG-60 | §11 |
| Faint / revive | VERIFIED WORKING | P2-10 | `onPokemonDeath.lua` | — | BUG-48 | §5 |
| Pokémon Center heal | VERIFIED WORKING | P2-07 | `npc/nurse_joy.lua` | Nurse Joy | — | §5.1 |
| Evolution | VERIFIED WORKING | P2-11 | `ev/actions/evolve.lua`, `elementalStone.lua` | stone / evolve icon | BUG-46, BUG-47 | §5 |
| Nickname | VERIFIED WORKING | P2-12 | `npc/soulTrade.lua` | Soul Trade NPC | BUG-26 | §5.1 |
| Sex / gender | IMPLEMENTED / UNVERIFIED | matrix §2.1 | `server/src/monster.cpp:95-98` | automatic | — | §3 |
| Shiny Pokémon | IMPLEMENTED / UNVERIFIED | `spawn.cpp:310` | `shinyAppearChance` | wild spawns | — | §3 |
| Hunger / feeding | PARTIAL | P2-08 | `sys/047-pokemonFood.lua` | feed items | BUG-19 | §5 |
| Pokédex | PARTIAL, CLIENT DEPENDENT | P2-09, P2-34 | `sys/010-pokedex.lua`, `cl/game_pokedex` | Pokédex item | BUG-35 | §5 |
| Status conditions | VERIFIED WORKING (poison) | P2-13 | `sys/008-conditions.lua`, `cl/game_statusbar` | moves | BUG-27 | §5 |
| Player commands | VERIFIED WORKING | P2-14 | `talkactions.xml:5-41` | chat | — | §7 |

## Moves and Pokémon development

| Feature | Status | Evidence | Main source | How reached | Bugs | Audit |
|---|---|---|---|---|---|---|
| Moves (m1–m16) | VERIFIED WORKING (players and GM; `tools/energy_test.py`) | P2-06 | `sys/003-skill.lua`, `ev/spells/scripts` (459) | move bar / `m1` | BUG-05 | §5 |
| Damage model | PARTIAL | matrix §2.2 | `sys/004-skillDamage.lua` | battles | BUG-33 | §5 |
| Cooldowns | VERIFIED WORKING | P2-06 | `sys/007-cooldown.lua` | moves | BUG-34 | §5 |
| TMs | VERIFIED WORKING, CLIENT DEPENDENT | P2-16 | `sys/018-technicalMachine.lua`, `cl/game_tmchoose` | use TM | BUG-21, BUG-57 | §5 |
| TM / held / vitamin / sketch tutors | IMPLEMENTED / UNVERIFIED | — | `npc/{tm_remover,held_remove,vitamin_reset,sketch_reset}.lua` | NPCs | — | §5.1 |
| Held items | VERIFIED WORKING | P2-17 | `sys/046-heldItem.lua` | use held item | BUG-28 | §5 |
| Vitamins | VERIFIED WORKING | P2-18 | `sys/040-vitamin.lua` | use vitamin | — | §5 |
| Pokémon abilities (passive) | IMPLEMENTED / UNVERIFIED | — | `sys/039-pokemonAbility.lua`, `sys/017-specialAbilities.lua` | automatic | — | §5 |
| Pokémon addons | PARTIAL | P2-22 | `sys/038-pokemonAddon.lua`, `/addon` | addon items | — | §5 |
| Eggs / incubators | VERIFIED WORKING | P2-19 | `sys/045-pokemonEgg.lua`, `ev/actions/eggIncubator` | incubator | BUG-29, BUG-34 | §5 |
| Breeding / daycare / egg moves | IMPLEMENTED / UNVERIFIED | matrix §2.5 | `npc/daycare{Female,Male}.lua`, `npc/eggmove_*.lua` | daycare NPCs (lvl 85, premium) | — | §5.1 |
| Mastery | IMPLEMENTED / UNVERIFIED | matrix §2.10 | `sys/014-mastery.lua`, `npc/mastery_*.lua` (9) | mastery NPCs | — | §5 |
| Extra exp / loot / catch / egg rates | IMPLEMENTED / UNVERIFIED | matrix §2.20 | `sys/012`, `052`, `053`, `054` | boost items | — | §5 |

## Field abilities and world

| Feature | Status | Evidence | Main source | How reached | Bugs | Audit |
|---|---|---|---|---|---|---|
| Ride | VERIFIED WORKING | P2-20 | `ev/actions/abilities.lua`, `lib/ps/functions/abilities.lua` | order on self | — | §5 |
| Fly, `/up`, `/down` | VERIFIED WORKING | P2-21 | same, `ev/talkactions/flyUp.lua`, `flyDown.lua` | order / command | — | §5 |
| Surf | IMPLEMENTED / UNVERIFIED | matrix §2.6 | `ev/actions/abilities.lua` | order on water | — | §5 |
| Dive / oxygen mask | IMPLEMENTED / UNVERIFIED | matrix §2.6 | `abilities.lua`, `sys/033-oxygenMask.lua` | order / mask | BUG-50 | §5 |
| Cut / Dig / Rock Smash / Strength | IMPLEMENTED / UNVERIFIED | matrix §2.6 | `abilities.lua` | order on obstacle | BUG-30 | §5 |
| Teleport `/tp`, `/find` | IMPLEMENTED / UNVERIFIED | matrix §2.6 | `ev/talkactions/teleport.lua`, `find.lua` | command | — | §7 |
| Fishing | IMPLEMENTED / UNVERIFIED | matrix §2.6 | `sys/043-fishing.lua`, `ev/actions/fishing.lua` | rod | — | §5 |
| Safari fishing | DISABLED | `actions.xml:36` | `ev/actions/safariFishing.lua` | — | — | §6.2 |
| Headbutt | IMPLEMENTED / UNVERIFIED | matrix §2.6 | `sys/036-headbutt.lua` | order on tree | — | §5 |
| Ski / sandboard | IMPLEMENTED / UNVERIFIED | matrix §2.6 | `sys/032-ski.lua`, `sys/042-sandboard.lua` | equipment | — | §5 |
| Berry trees | IMPLEMENTED / UNVERIFIED | — | `sys/015-berry.lua`, `ev/actions/berries` | plant seeds | — | §5 |
| Surprise boxes | IMPLEMENTED / UNVERIFIED | matrix §2.11 | `sys/034-surpriseBox.lua` | map spawns | BUG-41 | §5 |
| Town guide / map marks | VERIFIED WORKING | P2-25 | `sys/026-guide.lua` | guide NPC | — | §5 |
| Travel (boats/trains) | IMPLEMENTED / UNVERIFIED | — | `npc/travels.lua` | travel NPCs | — | §5.1 |
| Citizens (random NPCs) | IMPLEMENTED / UNVERIFIED | observed at start | `sys/027-citizens.lua` | world | — | §5 |
| Day / night | IMPLEMENTED / UNVERIFIED, CLIENT DEPENDENT | `protocolgame.cpp:2794-2796` | `server/src/game.cpp:5180`, `cl/game_time` | automatic | — | §3, §10 |
| Weather / ambient sound / map shaders | DISABLED, CLIENT DEPENDENT | module not loaded | `cl/game_environment` | — | BUG-69 | §10 |
| Wild respawn events (Eevee, Sudowoodo) | IMPLEMENTED / UNVERIFIED | `globalevents.xml` | `ev/globalevents/eeveeRespawn.lua` | world | — | §6.4 |

## Battles and challenges

| Feature | Status | Evidence | Main source | How reached | Bugs | Audit |
|---|---|---|---|---|---|---|
| Wild battles | VERIFIED WORKING | P2-05 | monsters, `sys/004` | world | BUG-13 | §5 |
| NPC trainer battles | PARTIAL | P2-29 | `sys/001-npcBattle.lua`, `npc/npcbattle_*` (199) | talk `battle` | BUG-01 | §5 |
| Gyms and badges | IMPLEMENTED / UNVERIFIED | matrix §2.7 | `npc/npcbattle_{brock,misty,ltsurge,erika,koga,sabrina,blaine,giovanni}.lua`, `ev/actions/gyms/vermilion.lua` | gym leaders | BUG-16 | §5 |
| Badge case | IMPLEMENTED / UNVERIFIED, CLIENT DEPENDENT | matrix §2.17 | `sys/024-badgeCase.lua`, `cl/game_badgecase` | badge case item | BUG-16 | §5 |
| Elite Four | IMPLEMENTED / UNVERIFIED | matrix §2.10 | `sys/049-eliteFour.lua`, `npc/elitefour_enter.lua` | Drogo Toby (lvl 95, badges) | BUG-64 | §5 |
| Team Rocket battles | PARTIAL (no rewards) | matrix §2.10 | `sys/050-rocketBattle.lua`, `npc/npcbattle_rocket*` | Rocket NPCs | BUG-44 | §5 |
| World Boss | IMPLEMENTED / UNVERIFIED | `/boss` P2-14 | `sys/021-boss.lua` | `/boss`, spawns | BUG-43 | §5 |
| Dungeons | IMPLEMENTED / UNVERIFIED | matrix §2.10 | `sys/028-dungeons.lua` | dungeon entrances | BUG-45 | §5 |
| Ranger Club | IMPLEMENTED / UNVERIFIED | matrix §2.10 | `sys/029-rangerClub.lua`, `npc/rangerClub.lua` | Dan Lambert | BUG-42 | §5 |
| Safari Zone | IMPLEMENTED / UNVERIFIED | matrix §2.10 | `sys/016-safariZone.lua`, `npc/saffariZone{Enter,Leave}.lua` | Jeffrey (1000 $, lvl 30) | — | §5 |
| Frontier Island trainers | IMPLEMENTED / UNVERIFIED | not in earlier docs | `npc/npcbattle_fi_*.lua` (48) | Frontier Island | — | §5.1 |
| Battle Tower | IMPLEMENTED / UNVERIFIED | — | `npc/fi_battletower.lua` | Rafael Townson | — | §5.1 |
| Stadium Arena (Gladiator, Cooperative Elite/Titan, Survive / Hardcore) | IMPLEMENTED / UNVERIFIED | — | `npc/lib/frontierisland/stadiumarena/*.lua`, `npc/fi_stadiumarena.lua` | Kurt Petrillose | — | §5.1 |
| Wave Arena | IMPLEMENTED / UNVERIFIED | — | `npc/lib/wavearena.lua`, `npc/wavearena.lua` | Leroi Bradley | — | §5.1 |
| Tournaments | PARTIAL | P2-28 | `server/src/tournament.cpp`, `npc/tournament.lua` | tournament NPC | BUG-20 | §3 |
| PvP arenas | IMPLEMENTED / UNVERIFIED | matrix §2.8 | `sys/009-pvpArena.lua`, `server/src/pvparena.cpp` | arena tiles | BUG-17 | §5 |
| Duels / party duels | IMPLEMENTED / UNVERIFIED | matrix §2.8 | `ev/actions/duel.lua`, `cl/game_duelmessage` | duel icon 13016 | — | §5.1 |
| Quests | VERIFIED WORKING (framework) | P2-26 | `sys/002-quest.lua`, `npc/quest_*` (73), `ev/actions/quests` | quest NPCs | BUG-53 | §5 |

## Economy and social

| Feature | Status | Evidence | Main source | How reached | Bugs | Audit |
|---|---|---|---|---|---|---|
| Bank | VERIFIED WORKING (transfer PARTIAL) | P2-27 | `npc/bank.lua` | bank NPC | BUG-15, BUG-51 | §5.1 |
| Item market | IMPLEMENTED / UNVERIFIED, CLIENT DEPENDENT | matrix §2.12 | `server/src/iomarket.cpp`, `cl/game_market` | Jaron Jewell (not spawned) | BUG-23, BUG-36, BUG-37, BUG-52 | §3 |
| Pokémon Market | PARTIAL | P2-30 | `npc/shop_pokemonMarket.lua` | Jack Eden | BUG-31 | §5.1 |
| PokeTrader (auctions) | PARTIAL | P2-31 | `npc/poketrader.lua` | Tiger Kelsey | BUG-32 | §5.1 |
| Premium shop / Soul Coins | PARTIAL, WEBSITE DEPENDENT | matrix §2.18 | `npc/soulTrade.lua` | Soul Trade NPC | — | §13 |
| Client shop window | HISTORICAL (module not loaded) | `game_shop` | `cl/game_shop` | — | BUG-38 | §10 |
| Casino / slot machine | IMPLEMENTED / UNVERIFIED, CLIENT DEPENDENT | — | `sys/044-slotMachine.lua`, `npc/casinoMerchant.lua`, `cl/game_slotmachine` | casino | — | §5 |
| Autoloot | PARTIAL | P2-24 FAIL (OFF not saved) | `ev/talkactions/autoLoot.lua`, `cl/game_lootlist` | `/autoloot` | BUG-04 | §5 |
| TV (spectating) | IMPLEMENTED / UNVERIFIED | matrix §2.14 | `ev/actions/tv`, `ev/talkactions/tv` | record item 14359, `/tv*` | — | §5.1 |
| Polls | IMPLEMENTED / UNVERIFIED, WEBSITE DEPENDENT, CLIENT DEPENDENT | matrix §2.15 | `server/src/polls.cpp`, `cl/game_poll` | poll icon | BUG-52 | §3 |
| Guilds | IMPLEMENTED / UNVERIFIED | matrix §2.13 | Soul Trade (create), `!joinguild` | NPC / command | — | §7 |
| Houses | IMPLEMENTED / UNVERIFIED | matrix §2.13 | `/house buy` (`talkactions.xml:129-135`) | house door | — | §7 |
| Wiki Chat | VERIFIED WORKING | P2-23 | `sys/031-wikiChat.lua` | channel | BUG-55 | §5 |
| Referrals | IMPLEMENTED / UNVERIFIED, WEBSITE DEPENDENT | — | `sys/035-referral.lua` | website | — | §13 |
| Coupons | PARTIAL, WEBSITE DEPENDENT | matrix §2.11 | `ev/talkactions/coupon.lua` | `/coupon` | BUG-54 | §13 |
| Highscores | IMPLEMENTED / UNVERIFIED, WEBSITE DEPENDENT | matrix §2.11 | `sys/011`, `sys/013`, `sys/022` | website | BUG-25 | §5 |
| Achievements | IMPLEMENTED / UNVERIFIED | — | `sys/023-achievement.lua` | automatic | — | §5 |
| Doll case | IMPLEMENTED / UNVERIFIED, CLIENT DEPENDENT | matrix §2.17 | `sys/041-dollCase.lua`, `cl/game_dollcase` | doll case item | BUG-59 | §5 |
| Clothes showcase / clothes kit | IMPLEMENTED / UNVERIFIED | — | `ev/actions/clotheShowcase.lua`, `clothesKit.lua` | item | — | §5 |
| Statistics / datalog | VERIFIED WORKING (passive) | matrix §2.16 | `sys/025-datalog.lua`, `server/src/iodatalog.cpp` | automatic | — | §5 |
| Localization (en/pt/es) | IMPLEMENTED / UNVERIFIED, CLIENT DEPENDENT | — | `server/src/localization.cpp`, `/lang`, `cl/client_locales` | login / `/lang` | BUG-08, BUG-09 | §3 |
| Gameplay tips | IMPLEMENTED / UNVERIFIED, CLIENT DEPENDENT | `0xFF 0x17` | `cl/game_tips` | automatic | — | §10 |

## Seasonal events

| Feature | Status | Evidence | Main source | How reached | Bugs | Audit |
|---|---|---|---|---|---|---|
| Anniversary | PARTIAL (always on) | P2-32 | `sys/048-anniversaryEvent.lua`, `globalevents.xml:13` | hourly raid, drops | BUG-14, BUG-18 | §6.5 |
| Halloween | DISABLED (NPCs live) | `onKill.lua:7` | `sys/037-halloweenEvent.lua`, `ev/actions/events/halloween` | — | — | §6.5 |
| Easter | DISABLED | `onKill.lua:9` | `sys/030-easterEvent.lua` | — | — | §6.5 |
| Christmas | DISABLED | `onKill.lua:10` | `sys/051-christmasEvent.lua`, `npc/event_santaClaus.lua` | — | — | §6.5 |
| July Vacation | DISABLED | `onStaminaChange.lua:2` | `sys/055-julyVacationEvent.lua` | — | — | §6.5 |
| Birthday / respect boxes | IMPLEMENTED / UNVERIFIED | — | `ev/actions/events/{birthdayBox,respectBox}.lua` | item | — | §5 |

## Not player-facing / historical

| Feature | Status | Evidence | Main source | Audit |
|---|---|---|---|---|
| Old task system | HISTORICAL, DISABLED | not loaded | `sys/disabled/005-task.lua` | §4.1 |
| Developer tools (`/gl` loot generator, catch test, balance calculator) | HISTORICAL | `talkactions.xml:46` commented | `lib/ps/tools/` | §4.1 |
| Test-server NPCs (Pokémon Creator…) | HISTORICAL | not spawned | `npc/testserver_*.lua` | §5.1 |
| Account manager | DISABLED | `accountManager = false` | `protocollogin.cpp:227-234` | §15 |
| Advanced save | DISABLED (and mis-named) | `advancedSave = false` | `login.lua:22-24` | §6.3 |
| Server save / clean globalevents | DISABLED | `globalevents.xml:17-22` | `globalevents/scripts/{save,clean}.lua` | §6.4 |
| Stock TFS commands (`/uptime`, `!frags`, …) | DISABLED | commented | `talkactions/scripts/*` | §6.2 |

## Status counts (rows above)

| Status | Rows |
|---|---|
| VERIFIED WORKING | 26 |
| IMPLEMENTED / UNVERIFIED | 50 |
| PARTIAL | 15 |
| BROKEN | 0 |
| DISABLED | 11 |
| WEBSITE DEPENDENT | 6 |
| CLIENT DEPENDENT | 15 |
| HISTORICAL | 4 |

104 rows. Rows carrying more than one status are counted once per status. No row is BROKEN:
the suspected show-stoppers (BUG-16 badges, BUG-17 PvP arena, BUG-45 dungeons) are inferred
from reading and not yet reproduced.
