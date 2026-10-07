# Database changes (tables, columns, storages, seed data)

PSoul keeps characters, accounts, achievements, market data and logs in a MariaDB database.
The schema comes from three SQL files that `tools/setup_database.sh` imports **once**. There is
no migration runner: changing a `.sql` file in git does **not** change a database that already
exists. This tutorial covers adding a table or column safely, applying it to a dev database,
editing storages, and backing up and restoring.

The worked example is a real gap: the C++ parcel log writes to a `parcels` table that no
schema file creates (`src/iologindata.cpp:1239-1245`). `tools/check_references.py:129` already
lists it as a known issue.

Paths are relative to `server/` unless they start with `tools/` or `docs/`.

---

## 1. The chain

```
tools/setup_database.sh [--reset]
   sources tools/dev_env.sh       DB_NAME psoul, DB_USER psoul, DB_HOST localhost, DB_PORT 3306 (36-39)
                                  DB_PASS = $PSOUL_DB_PASS or sqlPass from server/config.lua or "psoul-dev" (64-65)
   --reset → DROP DATABASE IF EXISTS `psoul`                       (17-20)
   CREATE DATABASE / CREATE USER / GRANT                           (21-27)
   only if table `accounts` does NOT exist                         (29-39):
        src/schemas/mysql.sql              stock TFS 0.3.6, db_version 23 (DROPs first!)
        src/schemas/psoul_extra_mysql.sql  PSoul tables + columns (idempotent)
        src/schemas/psoul_dev_seed.sql     dev accounts admin/admin, player/player
   otherwise prints "Tables already exist - skipping schema import (use --reset to start over)"
   creates server/config.lua from config.example.lua if missing    (44-55)

server start (src/otserv.cpp:653-683)
   ">> Starting SQL connection"
   ">> Running Database Manager"
   DatabaseManager::updateDatabase() (src/databasemanager.cpp:188-…)
        only the STOCK TFS upgrades 1 → 23, keyed on server_config.db_version.
        It knows nothing about psoul_extra_mysql.sql.
   then Lua and C++ run queries; a query on a missing table/column prints
        "mysql_real_query(): <query> - MYSQL ERROR: <message> (<errno>)"   (src/databasemysql.cpp:132)
```

Lua reaches the database through `db.executeQuery`, `db.storeQuery`, `db.escapeString`,
`db.lastInsertId` (`src/luascript.cpp:2860-2875`) and the wrapper `db.getResult`
(`data/lib/004-database.lua:110`).

## 2. Files to edit

| File | When |
|---|---|
| `src/schemas/psoul_extra_mysql.sql` | every new PSoul table or column. This is what a fresh setup imports. |
| `src/schemas/migrations/<YYYY-MM-DD>_<what>.sql` (new folder, proposed convention) | the **same** change as a standalone idempotent file, so existing databases can apply it. |
| `src/schemas/psoul_dev_seed.sql` | only if the dev accounts need new starting data. |
| the Lua/C++ file that issues the query | it is the reason the table exists; cite it in the SQL comment. |

## 3. Files NOT to edit

- `src/schemas/mysql.sql`. This is the stock TFS schema. It starts with 27 `DROP TABLE IF EXISTS` lines
  (lines 7-33, e.g. `player_storage` at 16 and `global_storage` at 26) and five `DROP TRIGGER` lines (1-5).
  Re-running it on a live database **wipes every character**. Put changes in `psoul_extra_mysql.sql`.
- `src/schemas/pgsql.sql` and `src/schemas/sqlite.sql`. These are unused because `sqlType = "mysql"` (`config.example.lua:118`).
- `src/databasemanager.cpp`. It holds the stock upgrade steps. Adding PSoul steps there means
  changing C++ and bumping `VERSION_DATABASE`, which is out of scope.
- `server/config.lua`. It is git-ignored and local. Change `config.example.lua` only if a new
  config key is needed.
- The usual content folders still apply: `data/lib/ps/config/_pokemon`, `others/pokemon_backup`,
  `others/moves_disabled`, `systems/disabled`, `original/` and generated `tmpCitizen_*.xml`. Never
  "fix" a query inside those copies.

## 4. Authoritative source paths

| What | Where |
|---|---|
| Table and column list | `src/schemas/mysql.sql` + `src/schemas/psoul_extra_mysql.sql` |
| Idempotency rules | `psoul_extra_mysql.sql:15-17` (header) |
| Extra columns on stock tables | `psoul_extra_mysql.sql:25-30` (`accounts`) and `35-42` (`players`) |
| Table clones | `CREATE TABLE IF NOT EXISTS … LIKE …` at `psoul_extra_mysql.sql:179`, `625`, `651-657` |
| World-1 rows | `INSERT IGNORE` at `psoul_extra_mysql.sql:782-783` |
| Player storages | `player_storage` (`mysql.sql:185-192`). The `value` is VARCHAR(255) and is loaded at `src/iologindata.cpp:722`. On every save it is **deleted and rewritten** (`iologindata.cpp:992-999`). |
| Global storages | `global_storage` (`mysql.sql:357-363`). It is loaded and saved by `ScriptEnviroment::loadGameState/saveGameState` (`src/luascript.cpp:129-151`, load at 154): `DELETE … WHERE world_id` then re-insert from memory, when `saveGlobalStorage = true` (`config.example.lua:214`). |
| Schema checker | `tools/check_references.py:1390-1420` (`check_sql`). It flags any Lua/C++ query on a table missing from the two schema files. |
| Common import errors | `docs/BUILDING.md` §8.6 (lines 343-349) |

## 5. Real examples

A table cited next to its users (`psoul_extra_mysql.sql:78-83`). It is used by
`data/lib/ps/systems/023-achievement.lua:1154` (SELECT) and `:1166` (INSERT).

```sql
CREATE TABLE IF NOT EXISTS `player_achievements`
(
	`player_id` INT NOT NULL,
	`key` INT UNSIGNED NOT NULL,
	PRIMARY KEY (`player_id`, `key`)
) ENGINE = InnoDB;
```

A column added to a stock table (`psoul_extra_mysql.sql:32-42`). It is read by
`src/iologindata.cpp:405-410` and written by `:830-900`.

```sql
ALTER TABLE `players`
	ADD COLUMN IF NOT EXISTS `hidden` TINYINT(1) NOT NULL DEFAULT 0,
	…
	ADD COLUMN IF NOT EXISTS `lasteggtime` INT UNSIGNED NOT NULL DEFAULT 0;
```

An upsert from Lua (`data/lib/051-accountStorage.lua:11-27`): `INSERT … ON DUPLICATE KEY UPDATE`
against the primary key `(account_id, key)` declared at `psoul_extra_mysql.sql:49-55`.

## 6. Required IDs and how to find free ones

SQL changes need names, not numeric IDs:

```bash
# is the table name free?
grep -n 'CREATE TABLE.*`parcels`' server/src/schemas/*.sql          # → nothing: free (and needed)
# who uses it?
grep -rn '`parcels`' server/src server/data --include='*.cpp' --include='*.lua'
# is the column name already used on that table?
grep -n 'ADD COLUMN IF NOT EXISTS `lasteggtime`' server/src/schemas/psoul_extra_mysql.sql
```

If you store data as a **storage** instead of a table, the key must be free. See
`add-quest.md` §6, and grep both `player_storage` users and the `LAST STORAGE` comments in
`data/lib/ps/systems/`.

## 7. Related dependencies

- MariaDB 10.0.2+ for `ADD COLUMN IF NOT EXISTS` (`psoul_extra_mysql.sql:16-17`, `docs/BUILDING.md:27,106-108`).
  On MySQL that statement fails with ERROR 1064.
- `mysql.sql` defines triggers (`DELIMITER |` at line 410; `ondelete_accounts` at 412, `oncreate_players` at 438).
  MySQL 8 with binary logging refuses them (ERROR 1419, `docs/BUILDING.md:349`).
- `players.id` is the key everything else joins on. `player_storage` has `ON DELETE CASCADE`
  (`mysql.sql:191`). PSoul tables in `psoul_extra_mysql.sql` have **no** foreign keys, so deleting a
  player leaves orphan rows there.

## 8. Example: add the missing `parcels` table

The query being satisfied (`src/iologindata.cpp:1243`):

```cpp
query << "INSERT INTO `parcels` (`from_player_id`, `to_player_id`, `date`) VALUES ('" << tmp->getGUID() << "', '" << player->getGUID() << "', '" << time(NULL) << "')";
```

**8.1** Append to `src/schemas/psoul_extra_mysql.sql`, before the per-world `INSERT IGNORE` block that starts at line 776:

```sql
-- (`from_player_id`, `to_player_id`, `date`) - src/iologindata.cpp:1243 (IOLoginData::playerMail, "PS - Parcel log")
CREATE TABLE IF NOT EXISTS `parcels`
(
	`id` INT NOT NULL AUTO_INCREMENT,
	`from_player_id` INT NOT NULL,
	`to_player_id` INT NOT NULL,
	`date` INT UNSIGNED NOT NULL,
	PRIMARY KEY (`id`),
	KEY (`from_player_id`),
	KEY (`to_player_id`)
) ENGINE = InnoDB;
```

The types follow the code: GUIDs are `INT` like `players.id`, and `time(NULL)` is a unix timestamp,
stored as `INT UNSIGNED` like every `datalog_*` `date` column.

**8.2** Put the identical block in a migration file for existing databases:

```bash
mkdir -p server/src/schemas/migrations
$EDITOR server/src/schemas/migrations/2026-10-06_parcels.sql   # same CREATE TABLE IF NOT EXISTS block
```

**8.3** A column instead of a table looks the same. It must be idempotent, so it is safe to run twice:

```sql
-- data/lib/ps/systems/0xx-foo.lua:NN reads/writes `players`.`foo_points`
ALTER TABLE `players`
	ADD COLUMN IF NOT EXISTS `foo_points` INT NOT NULL DEFAULT 0;
```

A real case is a new Pokéball with `useCounter = true`. `systems/020-ballCounter.lua:3-7`
turns every such ball key into a column name of `ball_counter` (`psoul_extra_mysql.sql:107-129`).
The new ball needs
``ALTER TABLE `ball_counter` ADD COLUMN IF NOT EXISTS `<ball key>` INT UNSIGNED NOT NULL DEFAULT 0;``.

Always give a `DEFAULT`. `IOLoginData::savePlayer` builds its own `UPDATE`, and the account
web flow that created characters is not in the archive (`psoul_dev_seed.sql:50-51`). A
`NOT NULL` column without a default breaks every `INSERT INTO players` that does not name it.

Idempotent patterns, and what to avoid:

| Use | Avoid |
|---|---|
| `CREATE TABLE IF NOT EXISTS` | `DROP TABLE …; CREATE TABLE …` |
| `ALTER TABLE … ADD COLUMN IF NOT EXISTS` | plain `ADD COLUMN` (fails the second time: ERROR 1060 Duplicate column) |
| `CREATE INDEX IF NOT EXISTS` / `ADD KEY IF NOT EXISTS` (MariaDB) | unnamed `ADD KEY` (creates `foo_2`, `foo_3` …) |
| `INSERT IGNORE` / `INSERT … ON DUPLICATE KEY UPDATE` | plain `INSERT` of fixed ids |
| `ALTER TABLE … MODIFY COLUMN …` (same result every time) | `CHANGE` that renames (second run: unknown column) |

Data fixes (`UPDATE`/`DELETE`) also go in a migration file with a `WHERE` that makes them
safe to repeat. Never type them only into a live console.

## 9. Registration steps

Apply the change. **Stop the server first** if the change touches storages or player rows
(see §15).

```bash
source tools/dev_env.sh

# 1. back up
mysqldump -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" -p"$DB_PASS" \
  --single-transaction --routines --triggers "$DB_NAME" > /tmp/psoul-$(date +%F-%H%M).sql

# 2a. existing database: apply only the migration
mysql_app "$DB_NAME" < server/src/schemas/migrations/2026-10-06_parcels.sql

# 2b. or throw the dev database away and rebuild from all three files
bash tools/setup_database.sh --reset     # = tools/init_dev_database.sh --reset
```

`--reset` deletes **all** characters, including anything you created while testing. The seed
recreates only "GM Admin", "Tester" (account `admin`) and "Trainer" (account `player`)
(`psoul_dev_seed.sql:25-48`).

Without `--reset`, `setup_database.sh` sees `accounts` and skips every schema file
(`setup_database.sh:29-39`). Your new table is **not** created. This is the most common
"I changed the SQL but nothing happened".

## 10. Database requirements

This whole page is the database requirement. Check it in the database:

```bash
source tools/dev_env.sh
mysql_app "$DB_NAME" -e "SHOW CREATE TABLE parcels\G"
mysql_app "$DB_NAME" -e "SHOW COLUMNS FROM players LIKE 'foo_points';"
mysql_app -N "$DB_NAME" -e "SELECT value FROM server_config WHERE config='db_version';"   # 23
```

## 11. Client requirements

None. The client never talks to the database.

## 12. Server requirements

- A new table or column needs **no rebuild** if only Lua uses it.
- C++ queries are compiled into the binary, so changing the query text needs a server rebuild
  (`tools/build_server.sh`).
- Lua that uses a new column needs `/reload libs` or a restart (see `add-quest.md` §17 for the reload matrix).
- Start-up must still show `>> Running Database Manager` with no
  `Couldn't estabilish connection to SQL database!` (`src/otserv.cpp:683`; the typo is in the source).

## 13. Validation steps

```bash
bash tools/check_syntax.sh                     # Lua / XML still parse
python3 tools/check_references.py > /tmp/refs-after.txt
grep -n 'sql.table' /tmp/refs-after.txt        # the `parcels` entry is gone once the table is in the schema
grep -n 'SQL tables in mysql.sql' /tmp/refs-after.txt   # count went up by one
```

Then test the file on a throw-away database, **twice**. The second run proves it is idempotent:

```bash
source tools/dev_env.sh
mysql_admin -e "DROP DATABASE IF EXISTS psoul_mig; CREATE DATABASE psoul_mig CHARACTER SET utf8mb4; GRANT ALL ON psoul_mig.* TO '$DB_USER'@'localhost';"
for f in mysql.sql psoul_extra_mysql.sql psoul_dev_seed.sql; do mysql_app psoul_mig < server/src/schemas/$f || echo "FAIL $f"; done
mysql_app psoul_mig < server/src/schemas/psoul_extra_mysql.sql && echo "extra: re-run OK"
mysql_app psoul_mig < server/src/schemas/migrations/2026-10-06_parcels.sql && echo "migration: re-run OK"
mysql_admin -e "DROP DATABASE psoul_mig;"
```

## 14. Test steps

1. Start the server, then log in as "GM Admin" (`admin`/`admin`) and, in a second client, as "Trainer" (`player`/`player`).
2. Send a parcel from one to the other through a mailbox. This runs `IOLoginData::playerMail`.
3. Before the change, the console shows
   `mysql_real_query(): INSERT INTO \`parcels\` … - MYSQL ERROR: Table 'psoul.parcels' doesn't exist (1146)`.
   After the change there is no error, and:

```bash
mysql_app "$DB_NAME" -e "SELECT * FROM parcels ORDER BY id DESC LIMIT 1;"
```

For storages: `/storage Tester,8381` shows a value, and `/storage Tester,8381,-1` resets it
(`data/talkactions/talkactions.xml:74`). This is the safe way to change a storage while the
server runs. It changes memory, and the next save writes it.

## 15. Common mistakes

- **Editing `player_storage` while the character is online.** The server holds storages in
  memory and on save does `DELETE FROM player_storage WHERE player_id = …` followed by a full
  re-insert (`iologindata.cpp:992-999`). Your `UPDATE` is silently overwritten at the next
  save or logout. Use `/storage`, or stop the server (or at least kick the player) first.
- **Editing `global_storage` while the server runs.** The same thing happens server-wide:
  `saveGameState` deletes and re-inserts every key for the world (`luascript.cpp:129-151`) on
  each `/save` (`talkactions.xml:97`) and at shutdown.
- Changing `psoul_extra_mysql.sql` and expecting the running dev database to change (§9).
- Re-importing `mysql.sql` into a database that has data. It starts with `DROP TABLE`.
- Hand-typing SQL into a live console with no `.sql` file in git. Nobody can reproduce or
  review it, and the next `--reset` loses it.
- `world_id`: `config.lua` uses world 1, but `mysql.sql` seeds world 0. Rows in
  `server_motd`/`server_record`/`global_storage` need `world_id = 1`
  (`psoul_extra_mysql.sql:776-783`).
- Building SQL from player text without `db.escapeString` (`luascript.cpp:2869`).
- Using MySQL-only or Postgres syntax. The project targets MariaDB (`docs/BUILDING.md:27`).

## 16. Failure symptoms

| Symptom | Cause |
|---|---|
| `mysql_real_query(): … - MYSQL ERROR: Table 'psoul.<t>' doesn't exist (1146)` | table not in the database (§9, no `--reset`, migration not applied) |
| `… MYSQL ERROR: Unknown column '<c>' in 'field list' (1054)` | column missing |
| `ERROR 1060 (42S21): Duplicate column name` while applying | plain `ADD COLUMN` run twice; use `IF NOT EXISTS` |
| `ERROR 1064 … near 'IF NOT EXISTS'` | running on MySQL, not MariaDB (`docs/BUILDING.md:348`) |
| `ERROR 1419 … SUPER privilege and binary logging` | MySQL 8 + binlog importing triggers (`docs/BUILDING.md:349`) |
| `Failed connecting to database - MYSQL ERROR: Access denied for user 'psoul'@'localhost'` (`src/databasemysql.cpp:215`), then `Couldn't estabilish connection to SQL database!` | `sqlPass` in `config.lua` differs from the DB user. Re-run `setup_database.sh`, which resets the password (lines 23-24). |
| `The database you specified in config.lua is empty, please import schemas/<dbengine>.sql …` (`src/otserv.cpp:662`) | wrong `sqlDatabase` or the import never ran |
| `> ERROR: Failed to load motd!` (`src/game.cpp:6301`) | missing world-1 rows (`psoul_extra_mysql.sql:776-783`) |
| Storage edit "does not stick" | edited while online (§15) |

## 17. Rollback advice

- **Schema files**: `git checkout -- server/src/schemas/` (or `git revert <commit>`).
- **Database**: restore the dump from §9. Stop the server first.

```bash
source tools/dev_env.sh
mysql_admin -e "DROP DATABASE IF EXISTS \`$DB_NAME\`; CREATE DATABASE \`$DB_NAME\` CHARACTER SET utf8mb4;"
mysql_app "$DB_NAME" < /tmp/psoul-YYYY-MM-DD-HHMM.sql
```

- Undo a single new table: `DROP TABLE IF EXISTS parcels;`. Undo a column:
  `ALTER TABLE players DROP COLUMN IF EXISTS foo_points;`. Write these in a migration
  file too, because they destroy data.
- Dev database only: `bash tools/setup_database.sh --reset` gives a clean, seeded database.
- `/reload` never touches the database. A server restart re-reads storages from the
  database, and they are only as good as the last save.
