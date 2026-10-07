# Translation report (Brazilian Portuguese → American English)

## 1. How the original handles language

The PSoul server was already written **English-first**: almost every player-facing string in
Lua, XML and C++ is English, and Portuguese is produced at runtime by the engine's
localization layer:

* `server/pt_br.loc` — 6,928 lines of `English text@Texto em português` pairs, loaded by
  `Localization` (`src/localization.cpp:295`) at startup.
* Lua calls `__L(cid, "English text")` and the C++ side calls `Localization::t(lang, text)`;
  the lookup returns the Portuguese line when the account's `lang_id` is `1` (pt_BR) and the
  English source text otherwise. The language is chosen by the OTClient login packet
  (`protocollogin.cpp:86-89`) and stored in `accounts.lang_id` (default `0` = en_US).
* The Wiki Chat help channel (`data/lib/ps/config/002-wikiChat.lua`) is a dialogue tree where
  the player explicitly chooses `'English'` or `'Português'` as the first keyword; both
  branches exist in the file.

Consequently the amount of hard-coded Portuguese was small and concentrated in a few places
that bypassed `__L()`. Those were translated in three commits so that a player with the
default (English) account language never sees Portuguese.

## 2. What was changed

| Commit | Files | What |
|--------|-------|------|
| Translate core server messages | `server/config.example.lua` | `motd` ("Sejá bem vindo ao Pokemon Genesis World, Treinador(a)") and `loginMessage` → English (verified on login: the message is delivered as text 0xB4) |
| | `data/lib/ps/events/creaturescripts/onJoinChannel.lua` | three bilingual "PT / EN" Help-channel lines → English only |
| | `data/lib/ps/events/globalevents/globalMessages.lua` | eight periodic broadcast messages were "Portuguese-English" (literal translations); rewritten as natural English |
| | `data/talkactions/scripts/shutdown.lua` | `/shutdown` broadcast was sent twice (PT then EN); now one English broadcast per step |
| Translate NPC and quest dialogue | `data/npc/Professor Tommy.xml` | greeting `"Olá …, já capturou … / Hello …, already catched …"` → `"Hello |PLAYERNAME|, have you caught your first {Pokemon} yet?"` |
| | `data/npc/scripts/professorTommy.lua` | the starter NPC said every line twice with `{PT-BR}:` / `{EN-US}:` prefixes; now says the English line once. The Portuguese lines were **not lost**: they were added to `pt_br.loc` so the `__L()` mechanism can still serve them |
| | `server/pt_br.loc` | +21 `English@Português` pairs for the lines above and the Help-channel lines |
| | `data/lib/ps/config/002-wikiChat.lua` | the greeting offered `'Português' e 'English'`; both English nodes fixed to natural English |
| Translate remaining player-facing text | `data/lib/ps/config/003-quest.lua`, `config/skill.lua`, `events/actions/activationTile.lua`, `events/actions/quests/emptyMasterBallPrototype.lua`, `systems/055-julyVacationEvent.lua`, `npc/scripts/eggmove_regenerator.lua`, `npc/scripts/event_julyVacation.lua` | isolated Portuguese or Portuguese-flavoured sentences ("catched", "more then", "re-peat", Portuguese words inside English text) |
| | `client/modules/game_shop/shop.lua` | two Portuguese message-box strings in the client shop module ("Você não tem emerald.", "Você comprou seu item com sucesso.") → English |

Rules applied:

* Identifiers, function names, DB column names, protocol ids, storage keys, event names, file
  names, Pokémon names and move names were not touched.
* `%s %d %u %.2f`, `|PLAYERNAME|`, `{keyword}` NPC highlights, `\n`, and colour codes were
  preserved exactly; keyword braces still match the words the NPC scripts listen for.
* Where an NPC accepted Portuguese *keywords* (`'sim'`, `'nao'`, `'vender'`, `'comprar'`,
  `'voltar'`, `'cidade'`, `'pokebola'`, …) next to the English ones, the aliases were kept —
  they are input matchers, not output, and removing them would change behaviour for players
  who learned the Portuguese commands.
* Every edited Lua file was re-checked with `luac5.1 -p` and every XML file with `xmllint`
  (`tools/check_syntax.sh`: 0 syntax errors across `server/data`), and the server was restarted
  after each batch.

## 3. Coverage

Scanner: `tools/find_portuguese.py` (heuristic: Portuguese-specific words inside string
literals / XML attributes; files decoded as UTF-8 with Latin-1 fallback because the original
mixes both encodings).

| Scope | Result |
|-------|--------|
| `server/data/**/*.lua`, `*.xml`, `config.example.lua` — strings sent to players | **0 remaining lines** outside the two intentional categories below |
| Intentional Portuguese: Wiki Chat `'Português'` branch (`002-wikiChat.lua`, 168 lines) | kept — it is the player-selectable Portuguese help; the English branch is complete |
| Intentional Portuguese: NPC keyword aliases (`'nao'`, `'sim'`, `'vender'`, `'comprar'`, `'voltar'`, `'falar'`, `'cidade'`, `'pokebola'`, `'carta'`, `'missao'`, `'dia das bruxas'`, `'presente'`; 53 lines in 34 files) | kept as input aliases |
| `server/pt_br.loc` | by design Portuguese (runtime translation table) — untouched except for the 21 added pairs |
| Developer comments | Portuguese comments remain in several Lua/C++ files (e.g. `-- PS: …` notes, `balls.lua`, `luascript.cpp`). They are not player-facing and were left for a later pass; a few that explained behaviour next to edited lines were translated |
| C++ source strings | all English in the original (`resources.h`, `protocolgame.cpp`, `talkaction.cpp`); nothing to translate |
| `original/design-docs/` | Portuguese design documents (DOCX/XLSX/TXT) — reference material, intentionally untranslated |
| Client (`client/modules`, `client/data/locales`) | OTClient `tr()` system with locale files (`client/data/locales/{en,pt,es,de,pl,sv}.lua`); UI source strings are English. Only `game_shop/shop.lua` had hard-coded Portuguese (fixed) |

Estimated player-facing coverage: **~100 % for the English language path**. Players who pick
`pt_BR` in the client keep receiving Portuguese through `pt_br.loc`, exactly as before.

## 4. Known rough edges left on purpose

* `pt_br.loc` is Latin-1 encoded (as the engine expects); do not re-save it as UTF-8.
* Some original English strings are stylistically awkward ("Loot of a Rattata: nothing.",
  "You've wasted 2 poke balls to catch it."). They were not reworded because they are the keys
  of `pt_br.loc`; changing them would silently break the Portuguese lookup. A later pass can
  reword both sides together.
* Portuguese developer comments remain (see above).
