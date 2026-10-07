-- PSoul / PokeAimar extra schema for MySQL / MariaDB
--
-- The original archive only shipped the stock TFS 0.3.6 schema (mysql.sql,
-- db_version 23). Every table and column below is referenced by the PSoul
-- C++ sources (src/io*.cpp) or by the Lua data layer (data/lib/ps/**,
-- data/npc/scripts/**) but was never included in the archive. This file was
-- reconstructed from those queries; the source location of each query is
-- noted next to the table. Column types were chosen to fit the values the
-- code writes (unix timestamps as INT, item attribute blobs as BLOB, etc).
--
-- Apply AFTER mysql.sql:
--   mysql -u <user> -p <database> < src/schemas/mysql.sql
--   mysql -u <user> -p <database> < src/schemas/psoul_extra_mysql.sql
--
-- The script is idempotent for tables (CREATE TABLE IF NOT EXISTS). The ALTER
-- TABLE statements use "ADD COLUMN IF NOT EXISTS", which requires MariaDB
-- 10.0.2+ (on MySQL, drop the IF NOT EXISTS or run them once).

-- ---------------------------------------------------------------------------
-- Extra columns on stock tables
-- ---------------------------------------------------------------------------

-- src/iologindata.cpp:50 (loadAccount), :103/:118 (language), :126 (client id)
-- data/lib/ps/systems/035-referral.lua:52-82, data/npc/scripts/soulTrade.lua:130
ALTER TABLE `accounts`
	ADD COLUMN IF NOT EXISTS `lang_id` TINYINT UNSIGNED NOT NULL DEFAULT 0,
	ADD COLUMN IF NOT EXISTS `client_id` INT UNSIGNED NOT NULL DEFAULT 0,
	ADD COLUMN IF NOT EXISTS `referral` INT NOT NULL DEFAULT 0,
	ADD COLUMN IF NOT EXISTS `referral_points` INT NOT NULL DEFAULT 0,
	ADD COLUMN IF NOT EXISTS `soulcoins` INT NOT NULL DEFAULT 0;

-- src/iologindata.cpp:71-73 (`hidden`), :405-410 (loadPlayer), :830-900 (savePlayer)
-- data/lib/ps/functions/player.lua:726 (`firstpokemon`)
-- data/npc/scripts/daycareFemale.lua:180-189 (`lasteggtime`)
ALTER TABLE `players`
	ADD COLUMN IF NOT EXISTS `hidden` TINYINT(1) NOT NULL DEFAULT 0,
	ADD COLUMN IF NOT EXISTS `pvparenafrags` INT NOT NULL DEFAULT 0,
	ADD COLUMN IF NOT EXISTS `pvparenadeaths` INT NOT NULL DEFAULT 0,
	ADD COLUMN IF NOT EXISTS `tournament_score` INT NOT NULL DEFAULT 0,
	ADD COLUMN IF NOT EXISTS `tournament_weekly_score` INT NOT NULL DEFAULT 0,
	ADD COLUMN IF NOT EXISTS `firstpokemon` INT NOT NULL DEFAULT 0,
	ADD COLUMN IF NOT EXISTS `lasteggtime` INT UNSIGNED NOT NULL DEFAULT 0;

-- ---------------------------------------------------------------------------
-- Account / player side tables
-- ---------------------------------------------------------------------------

-- data/lib/051-accountStorage.lua (INSERT ... ON DUPLICATE KEY UPDATE)
CREATE TABLE IF NOT EXISTS `account_storage`
(
	`account_id` INT NOT NULL,
	`key` INT UNSIGNED NOT NULL,
	`value` VARCHAR(255) NOT NULL DEFAULT '0',
	PRIMARY KEY (`account_id`, `key`)
) ENGINE = InnoDB;

-- src/ioplayerstatistics.cpp:26-33 (INSERT ... ON DUPLICATE KEY UPDATE)
CREATE TABLE IF NOT EXISTS `player_statistics`
(
	`player_id` INT NOT NULL,
	`key` SMALLINT UNSIGNED NOT NULL,
	`value` BIGINT NOT NULL DEFAULT 0,
	PRIMARY KEY (`player_id`, `key`)
) ENGINE = InnoDB;

-- src/iologindata.cpp:1867 (character list pokemon preview),
-- data/lib/ps/events/creaturescripts/onLogout.lua:95
CREATE TABLE IF NOT EXISTS `player_pokemon`
(
	`player_id` INT NOT NULL,
	`slot` TINYINT UNSIGNED NOT NULL,
	`pokemon_number` SMALLINT UNSIGNED NOT NULL DEFAULT 0,
	`description` TEXT NOT NULL,
	PRIMARY KEY (`player_id`, `slot`)
) ENGINE = InnoDB;

-- data/lib/ps/systems/023-achievement.lua:1154-1166
CREATE TABLE IF NOT EXISTS `player_achievements`
(
	`player_id` INT NOT NULL,
	`key` INT UNSIGNED NOT NULL,
	PRIMARY KEY (`player_id`, `key`)
) ENGINE = InnoDB;

-- data/lib/ps/systems/022-highscores.lua:39-104, data/lib/ps/functions/others.lua:202
CREATE TABLE IF NOT EXISTS `player_highscores`
(
	`player_id` INT NOT NULL,
	`score_id` INT UNSIGNED NOT NULL,
	`value` BIGINT NOT NULL DEFAULT 0,
	PRIMARY KEY (`player_id`, `score_id`)
) ENGINE = InnoDB;

-- data/lib/ps/functions/others.lua:15-45 (items kept while in an event/arena)
CREATE TABLE IF NOT EXISTS `player_stored_items`
(
	`id` INT NOT NULL AUTO_INCREMENT,
	`player_id` INT NOT NULL,
	`item_type` INT UNSIGNED NOT NULL,
	`count` INT NOT NULL DEFAULT 1,
	`attributes` BLOB NOT NULL,
	PRIMARY KEY (`id`),
	KEY (`player_id`)
) ENGINE = InnoDB;

-- data/lib/ps/systems/020-ballCounter.lua. One column per ball that has
-- useCounter = true in data/lib/ps/config/balls.lua (the script builds the
-- column name from the ball key, hence the `white easter` column).
CREATE TABLE IF NOT EXISTS `ball_counter`
(
	`player_id` INT NOT NULL,
	`pokemon_id` SMALLINT UNSIGNED NOT NULL,
	`poke` INT UNSIGNED NOT NULL DEFAULT 0,
	`great` INT UNSIGNED NOT NULL DEFAULT 0,
	`ultra` INT UNSIGNED NOT NULL DEFAULT 0,
	`safari` INT UNSIGNED NOT NULL DEFAULT 0,
	`coloured` INT UNSIGNED NOT NULL DEFAULT 0,
	`avalanche` INT UNSIGNED NOT NULL DEFAULT 0,
	`blaze` INT UNSIGNED NOT NULL DEFAULT 0,
	`gaia` INT UNSIGNED NOT NULL DEFAULT 0,
	`heremit` INT UNSIGNED NOT NULL DEFAULT 0,
	`hurricane` INT UNSIGNED NOT NULL DEFAULT 0,
	`spectrum` INT UNSIGNED NOT NULL DEFAULT 0,
	`vital` INT UNSIGNED NOT NULL DEFAULT 0,
	`voltagic` INT UNSIGNED NOT NULL DEFAULT 0,
	`zen` INT UNSIGNED NOT NULL DEFAULT 0,
	`christmas` INT UNSIGNED NOT NULL DEFAULT 0,
	`white easter` INT UNSIGNED NOT NULL DEFAULT 0,
	PRIMARY KEY (`player_id`, `pokemon_id`)
) ENGINE = InnoDB;

-- data/npc/scripts/daycareFemale.lua:5-29
CREATE TABLE IF NOT EXISTS `egg_counter`
(
	`player_id` INT NOT NULL,
	`pokemon_id` SMALLINT UNSIGNED NOT NULL,
	`tries` INT UNSIGNED NOT NULL DEFAULT 0,
	PRIMARY KEY (`player_id`, `pokemon_id`)
) ENGINE = InnoDB;

-- data/npc/scripts/daycareFemale.lua:56-83
CREATE TABLE IF NOT EXISTS `daycare_plates`
(
	`player_id` INT NOT NULL,
	`item_id` INT UNSIGNED NOT NULL,
	PRIMARY KEY (`player_id`)
) ENGINE = InnoDB;

-- data/npc/scripts/daycareMale.lua:47-226, daycareFemale.lua:157-273.
-- The current code stores the whole ball as `attributes`; the pokemon_* columns
-- after `attributes` are legacy columns that the scripts still read for
-- "older trains" (daycareMale.lua: "Fix to older trains").
CREATE TABLE IF NOT EXISTS `daycare_male`
(
	`id` INT NOT NULL AUTO_INCREMENT,
	`player_id` INT NOT NULL,
	`date` INT UNSIGNED NOT NULL DEFAULT 0,
	`ball_id` INT UNSIGNED NOT NULL DEFAULT 0,
	`max_training_minutes` INT UNSIGNED NOT NULL DEFAULT 0,
	`pokemon_name` VARCHAR(255) NOT NULL DEFAULT '',
	`pokemon_level` INT NOT NULL DEFAULT 0,
	`attributes` BLOB,
	`pokemon_experience` BIGINT NOT NULL DEFAULT 0,
	`pokemon_energy` INT NOT NULL DEFAULT 0,
	`pokemon_maxenergy` INT NOT NULL DEFAULT 0,
	`pokemon_nickname` VARCHAR(255) NOT NULL DEFAULT '',
	`pokemon_sex` TINYINT NOT NULL DEFAULT 0,
	`pokemon_extrapoints` INT NOT NULL DEFAULT 0,
	`pokemon_specialability` INT NOT NULL DEFAULT 0,
	`pokemon_tm1` INT NOT NULL DEFAULT 0,
	`pokemon_tm1_slot` INT NOT NULL DEFAULT 0,
	`pokemon_tm2` INT NOT NULL DEFAULT 0,
	`pokemon_tm2_slot` INT NOT NULL DEFAULT 0,
	`ball_seal` INT NOT NULL DEFAULT 0,
	PRIMARY KEY (`id`),
	KEY (`player_id`)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `daycare_female` LIKE `daycare_male`;

-- ---------------------------------------------------------------------------
-- World state
-- ---------------------------------------------------------------------------

-- data/lib/ps/systems/015-berry.lua:505-577
CREATE TABLE IF NOT EXISTS `berry_trees`
(
	`id` INT NOT NULL AUTO_INCREMENT,
	`world_id` TINYINT(2) UNSIGNED NOT NULL DEFAULT 0,
	`positionx` INT NOT NULL,
	`positiony` INT NOT NULL,
	`positionz` INT NOT NULL,
	`itemid` INT UNSIGNED NOT NULL,
	`growdate` INT UNSIGNED NOT NULL DEFAULT 0,
	PRIMARY KEY (`id`),
	KEY (`world_id`)
) ENGINE = InnoDB;

-- data/globalevents/scripts/start.lua:168-220,
-- data/lib/ps/events/actions/ballPillar/{attach,detach}.lua
CREATE TABLE IF NOT EXISTS `ball_pillars`
(
	`id` INT NOT NULL AUTO_INCREMENT,
	`world_id` TINYINT(2) UNSIGNED NOT NULL DEFAULT 0,
	`positionx` INT NOT NULL,
	`positiony` INT NOT NULL,
	`positionz` INT NOT NULL,
	`attributes` BLOB,
	`ball_id` INT UNSIGNED NOT NULL DEFAULT 0,
	`creature_name` VARCHAR(255) NOT NULL DEFAULT '',
	`creature_sex` TINYINT NOT NULL DEFAULT 0,
	PRIMARY KEY (`id`),
	KEY (`world_id`)
) ENGINE = InnoDB;

-- data/lib/ps/systems/049-eliteFour.lua:164-273
CREATE TABLE IF NOT EXISTS `elite_four_champions`
(
	`id` INT NOT NULL AUTO_INCREMENT,
	`player_id` INT NOT NULL,
	`date` INT UNSIGNED NOT NULL DEFAULT 0,
	`lookbody` INT NOT NULL DEFAULT 0,
	`lookfeet` INT NOT NULL DEFAULT 0,
	`lookhead` INT NOT NULL DEFAULT 0,
	`looklegs` INT NOT NULL DEFAULT 0,
	`looktype` INT NOT NULL DEFAULT 136,
	`lookaddons` INT NOT NULL DEFAULT 0,
	PRIMARY KEY (`id`)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `elite_four_champion_pokemons`
(
	`id` INT NOT NULL AUTO_INCREMENT,
	`player_id` INT NOT NULL,
	`name` VARCHAR(255) NOT NULL,
	`level` INT NOT NULL DEFAULT 1,
	`nickname` VARCHAR(255) NOT NULL DEFAULT '',
	`sex` TINYINT NOT NULL DEFAULT 0,
	`extra_points` INT NOT NULL DEFAULT 0,
	`special_ability` INT NOT NULL DEFAULT 0,
	`moveset` VARCHAR(255) NOT NULL DEFAULT '',
	PRIMARY KEY (`id`),
	KEY (`player_id`)
) ENGINE = InnoDB;

-- data/lib/ps/systems/035-referral.lua:70-94
CREATE TABLE IF NOT EXISTS `referral_friends`
(
	`account_referral` INT NOT NULL,
	`account_friend` INT NOT NULL,
	PRIMARY KEY (`account_referral`, `account_friend`)
) ENGINE = InnoDB;

-- data/lib/ps/events/talkactions/coupon.lua (type 0 = premium days)
CREATE TABLE IF NOT EXISTS `coupons`
(
	`id` INT NOT NULL AUTO_INCREMENT,
	`code` VARCHAR(64) NOT NULL,
	`type` TINYINT UNSIGNED NOT NULL DEFAULT 0,
	`reward` INT NOT NULL DEFAULT 0,
	`expires` INT UNSIGNED NOT NULL DEFAULT 0,
	PRIMARY KEY (`id`),
	UNIQUE (`code`)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `coupon_uses`
(
	`coupon_id` INT NOT NULL,
	`account_id` INT NOT NULL,
	`date` INT UNSIGNED NOT NULL DEFAULT 0,
	PRIMARY KEY (`coupon_id`, `account_id`)
) ENGINE = InnoDB;

-- ---------------------------------------------------------------------------
-- Trading: PokeTrader NPC auction, Pokemon Market NPC, in-client market
-- ---------------------------------------------------------------------------

-- data/npc/scripts/poketrader.lua (also used by the NPC "Tiger Kelsey")
CREATE TABLE IF NOT EXISTS `poketrader_offerts`
(
	`id` INT NOT NULL AUTO_INCREMENT,
	`item_id` INT UNSIGNED NOT NULL,
	`count` INT NOT NULL DEFAULT 1,
	`min_bid` INT NOT NULL DEFAULT 0,
	`created` INT UNSIGNED NOT NULL DEFAULT 0,
	`deadline` INT UNSIGNED NOT NULL DEFAULT 0,
	`world_id` TINYINT(2) UNSIGNED NOT NULL DEFAULT 0,
	PRIMARY KEY (`id`),
	KEY (`world_id`)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `poketrader_bids`
(
	`id` INT NOT NULL AUTO_INCREMENT,
	`player_id` INT NOT NULL,
	`offert_id` INT NOT NULL,
	`created` INT UNSIGNED NOT NULL DEFAULT 0,
	`bid` INT NOT NULL DEFAULT 0,
	PRIMARY KEY (`id`),
	KEY (`offert_id`),
	KEY (`player_id`)
) ENGINE = InnoDB;

-- data/npc/scripts/shop_pokemonMarket.lua
CREATE TABLE IF NOT EXISTS `pokemon_market`
(
	`id` INT NOT NULL AUTO_INCREMENT,
	`player_id` INT NOT NULL,
	`date` INT UNSIGNED NOT NULL DEFAULT 0,
	`pokemon_name` VARCHAR(255) NOT NULL,
	`pokemon_level` INT NOT NULL DEFAULT 1,
	`pokemon_extrapoints` INT NOT NULL DEFAULT 0,
	`pokemon_sex` TINYINT NOT NULL DEFAULT 0,
	`pokemon_specialability` INT NOT NULL DEFAULT 0,
	`ball_id` INT UNSIGNED NOT NULL DEFAULT 0,
	`attributes` BLOB,
	`value` INT NOT NULL DEFAULT 0,
	`pokemon_eggmove` VARCHAR(255) NOT NULL DEFAULT '',
	PRIMARY KEY (`id`),
	KEY (`player_id`),
	KEY (`pokemon_name`)
) ENGINE = InnoDB;

-- src/iomarket.cpp (TFS 1.x style market, offer id = created << 16 | counter)
CREATE TABLE IF NOT EXISTS `market_offers`
(
	`id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
	`player_id` INT NOT NULL,
	`sale` TINYINT(1) NOT NULL DEFAULT 0,
	`itemtype` INT UNSIGNED NOT NULL,
	`amount` SMALLINT UNSIGNED NOT NULL,
	`created` BIGINT UNSIGNED NOT NULL,
	`anonymous` TINYINT(1) NOT NULL DEFAULT 0,
	`price` INT UNSIGNED NOT NULL DEFAULT 0,
	PRIMARY KEY (`id`),
	KEY (`sale`, `itemtype`),
	KEY (`created`),
	KEY (`player_id`)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `market_history`
(
	`id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
	`player_id` INT NOT NULL,
	`sale` TINYINT(1) NOT NULL DEFAULT 0,
	`itemtype` INT UNSIGNED NOT NULL,
	`amount` SMALLINT UNSIGNED NOT NULL,
	`price` INT UNSIGNED NOT NULL DEFAULT 0,
	`expires_at` BIGINT UNSIGNED NOT NULL,
	`inserted` BIGINT UNSIGNED NOT NULL,
	`state` TINYINT UNSIGNED NOT NULL,
	PRIMARY KEY (`id`),
	KEY (`player_id`, `sale`)
) ENGINE = InnoDB;

-- ---------------------------------------------------------------------------
-- Polls (src/iopoll.cpp). `deadline` is read through UNIX_TIMESTAMP().
-- ---------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `polls`
(
	`id` INT NOT NULL AUTO_INCREMENT,
	`name` VARCHAR(255) NOT NULL,
	`question` TEXT NOT NULL,
	`deadline` DATETIME NOT NULL,
	`text_mode` TINYINT(1) NOT NULL DEFAULT 0,
	PRIMARY KEY (`id`)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `poll_options`
(
	`id` INT NOT NULL AUTO_INCREMENT,
	`poll_id` INT NOT NULL,
	`name` VARCHAR(255) NOT NULL,
	PRIMARY KEY (`id`),
	KEY (`poll_id`)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `poll_votes`
(
	`poll_id` INT NOT NULL,
	`account_id` INT NOT NULL,
	`poll_option_id` INT NOT NULL,
	PRIMARY KEY (`poll_id`, `account_id`)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `poll_texts`
(
	`poll_id` INT NOT NULL,
	`account_id` INT NOT NULL,
	`text` TEXT NOT NULL,
	PRIMARY KEY (`poll_id`, `account_id`)
) ENGINE = InnoDB;

-- ---------------------------------------------------------------------------
-- Tournaments (src/iotournament.cpp, src/iodatalog.cpp:153-171,
-- data/lib/ps/events/creaturescripts/onTournamentHistory.lua)
-- ---------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `tournaments`
(
	`id` INT NOT NULL AUTO_INCREMENT,
	`tournament_id` INT NOT NULL,
	`world_id` TINYINT(2) UNSIGNED NOT NULL DEFAULT 0,
	`name` VARCHAR(255) NOT NULL,
	`min_level` INT NOT NULL DEFAULT 1,
	`max_level` INT NOT NULL DEFAULT 1,
	`last_winner` INT NOT NULL DEFAULT 0,
	`last_date` INT UNSIGNED NOT NULL DEFAULT 0,
	`number` INT NOT NULL DEFAULT 0,
	`next_date` INT UNSIGNED NOT NULL DEFAULT 0,
	PRIMARY KEY (`id`),
	UNIQUE (`tournament_id`, `world_id`)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `tournament_inscriptions`
(
	`id` INT NOT NULL AUTO_INCREMENT,
	`tournament_id` INT NOT NULL,
	`player_id` INT NOT NULL,
	`account_id` INT NOT NULL,
	`world_id` TINYINT(2) UNSIGNED NOT NULL DEFAULT 0,
	PRIMARY KEY (`id`),
	KEY (`tournament_id`, `world_id`),
	KEY (`player_id`)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `tournament_bans`
(
	`id` INT NOT NULL AUTO_INCREMENT,
	`player_id` INT NOT NULL,
	`expires` INT UNSIGNED NOT NULL DEFAULT 0,
	PRIMARY KEY (`id`),
	KEY (`player_id`)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `tournament_histories`
(
	`id` INT NOT NULL AUTO_INCREMENT,
	`tournament_id` INT NOT NULL,
	`winner` INT NOT NULL,
	`loser` INT NOT NULL,
	`date` INT UNSIGNED NOT NULL DEFAULT 0,
	`round` INT NOT NULL DEFAULT 0,
	`show` TINYINT(1) NOT NULL DEFAULT 0,
	PRIMARY KEY (`id`),
	KEY (`tournament_id`)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `tournament_history_pokemon`
(
	`id` INT NOT NULL AUTO_INCREMENT,
	`tournament_history_id` INT NOT NULL,
	`player_id` INT NOT NULL,
	`pokemon_number` SMALLINT UNSIGNED NOT NULL DEFAULT 0,
	`description` TEXT NOT NULL,
	PRIMARY KEY (`id`),
	KEY (`tournament_history_id`)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `tournament_weekly_winners`
(
	`id` INT NOT NULL AUTO_INCREMENT,
	`player_id` INT NOT NULL,
	`date` INT UNSIGNED NOT NULL DEFAULT 0,
	PRIMARY KEY (`id`)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `tournament_winners`
(
	`id` INT NOT NULL AUTO_INCREMENT,
	`tournament_id` INT NOT NULL,
	`winner` INT NOT NULL,
	`date` INT UNSIGNED NOT NULL DEFAULT 0,
	PRIMARY KEY (`id`)
) ENGINE = InnoDB;

-- ---------------------------------------------------------------------------
-- Datalog tables (append-only logs; src/iodatalog.cpp and
-- data/lib/ps/systems/025-datalog.lua). Nothing reads them except
-- datalog_player_items, datalog_colosseum_arena, datalog_poketrader_boughts
-- and datalog_bank_transactions.
-- ---------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `datalog_caughts`
(
	`id` INT NOT NULL AUTO_INCREMENT,
	`player_id` INT NOT NULL,
	`pokemon_number` SMALLINT UNSIGNED NOT NULL,
	`tries` INT NOT NULL DEFAULT 0,
	`date` INT UNSIGNED NOT NULL,
	PRIMARY KEY (`id`)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `datalog_player_items`
(
	`id` INT NOT NULL AUTO_INCREMENT,
	`player_id` INT NOT NULL,
	`on_logout_count` INT DEFAULT NULL,
	`on_logout_date` INT UNSIGNED DEFAULT NULL,
	`on_login_count` INT DEFAULT NULL,
	`on_login_date` INT UNSIGNED DEFAULT NULL,
	PRIMARY KEY (`id`),
	KEY (`player_id`)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `datalog_logins`
(
	`id` INT NOT NULL AUTO_INCREMENT,
	`player_id` INT NOT NULL,
	`date` INT UNSIGNED NOT NULL,
	`ip` INT UNSIGNED NOT NULL DEFAULT 0,
	PRIMARY KEY (`id`)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `datalog_online`
(
	`id` INT NOT NULL AUTO_INCREMENT,
	`world_id` TINYINT(2) UNSIGNED NOT NULL DEFAULT 0,
	`date` INT UNSIGNED NOT NULL,
	`online` INT NOT NULL DEFAULT 0,
	PRIMARY KEY (`id`)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `datalog_boss_spawns`
(
	`id` INT NOT NULL AUTO_INCREMENT,
	`world_id` TINYINT(2) UNSIGNED NOT NULL DEFAULT 0,
	`name` VARCHAR(255) NOT NULL,
	`posx` INT NOT NULL,
	`posy` INT NOT NULL,
	`posz` INT NOT NULL,
	`date` INT UNSIGNED NOT NULL,
	PRIMARY KEY (`id`)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `datalog_ping`
(
	`id` INT NOT NULL AUTO_INCREMENT,
	`player_id` INT NOT NULL,
	`date` INT UNSIGNED NOT NULL,
	`ping` INT NOT NULL DEFAULT 0,
	PRIMARY KEY (`id`)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `datalog_poke_nick_change`
(
	`id` INT NOT NULL AUTO_INCREMENT,
	`player_id` INT NOT NULL,
	`old_nickname` VARCHAR(255) NOT NULL DEFAULT '',
	`new_nickname` VARCHAR(255) NOT NULL DEFAULT '',
	`date` INT UNSIGNED NOT NULL,
	PRIMARY KEY (`id`)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `datalog_egg_generate`
(
	`id` INT NOT NULL AUTO_INCREMENT,
	`player_id` INT NOT NULL,
	`egg` VARCHAR(255) NOT NULL,
	`date` INT UNSIGNED NOT NULL,
	`tries` INT NOT NULL DEFAULT 0,
	PRIMARY KEY (`id`)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `datalog_player_ups`
(
	`id` INT NOT NULL AUTO_INCREMENT,
	`player_id` INT NOT NULL,
	`from_level` INT NOT NULL,
	`to_level` INT NOT NULL,
	`date` INT UNSIGNED NOT NULL,
	`posx` INT NOT NULL,
	`posy` INT NOT NULL,
	`posz` INT NOT NULL,
	PRIMARY KEY (`id`)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `datalog_pokemon_ups`
(
	`id` INT NOT NULL AUTO_INCREMENT,
	`player_id` INT NOT NULL,
	`pokemon_number` SMALLINT UNSIGNED NOT NULL,
	`from_level` INT NOT NULL,
	`to_level` INT NOT NULL,
	`date` INT UNSIGNED NOT NULL,
	`posx` INT NOT NULL,
	`posy` INT NOT NULL,
	`posz` INT NOT NULL,
	PRIMARY KEY (`id`)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `datalog_duel_bet`
(
	`id` INT NOT NULL AUTO_INCREMENT,
	`leader_a` INT NOT NULL,
	`leader_b` INT NOT NULL,
	`player_id` INT NOT NULL,
	`amount` BIGINT NOT NULL DEFAULT 0,
	`date` INT UNSIGNED NOT NULL,
	PRIMARY KEY (`id`)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `datalog_map_items`
(
	`id` INT NOT NULL AUTO_INCREMENT,
	`itemtype` INT UNSIGNED NOT NULL,
	`count` INT NOT NULL DEFAULT 1,
	`attributes` BLOB,
	`date` INT UNSIGNED NOT NULL,
	PRIMARY KEY (`id`)
) ENGINE = InnoDB;

-- (`date`, `player_id`, `use`, `amount`) - 025-datalog.lua:2 and :14
CREATE TABLE IF NOT EXISTS `datalog_coin_uses`
(
	`id` INT NOT NULL AUTO_INCREMENT,
	`date` INT UNSIGNED NOT NULL,
	`player_id` INT NOT NULL,
	`use` VARCHAR(255) NOT NULL DEFAULT '',
	`amount` INT NOT NULL DEFAULT 0,
	PRIMARY KEY (`id`)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `datalog_token_bought` LIKE `datalog_coin_uses`;

-- PokeNation Shop purchases (opcode 201) - 057-soulShop.lua logPurchase/sendHistory
CREATE TABLE IF NOT EXISTS `datalog_shop_purchases`
(
	`id` INT NOT NULL AUTO_INCREMENT,
	`date` INT UNSIGNED NOT NULL,
	`account_id` INT NOT NULL,
	`player_id` INT NOT NULL,
	`product_id` VARCHAR(64) NOT NULL,
	`product_name` VARCHAR(255) NOT NULL DEFAULT '',
	`quantity` INT NOT NULL DEFAULT 1,
	`price` INT NOT NULL,
	`balance_after` INT NOT NULL DEFAULT -1,
	PRIMARY KEY (`id`),
	KEY `account_id` (`account_id`)
) ENGINE = InnoDB;

-- (`seller`, `buyer`, `date`, `ball_id`, `attributes`, `value`) - 025-datalog.lua:26
CREATE TABLE IF NOT EXISTS `datalog_pokemon_market`
(
	`id` INT NOT NULL AUTO_INCREMENT,
	`seller` INT NOT NULL,
	`buyer` INT NOT NULL,
	`date` INT UNSIGNED NOT NULL,
	`ball_id` INT UNSIGNED NOT NULL DEFAULT 0,
	`attributes` BLOB,
	`value` INT NOT NULL DEFAULT 0,
	PRIMARY KEY (`id`)
) ENGINE = InnoDB;

-- (`player_id`, `item_id`, `count`, `date`) - reward/drop logs in 025-datalog.lua
CREATE TABLE IF NOT EXISTS `datalog_boss_rewards`
(
	`id` INT NOT NULL AUTO_INCREMENT,
	`player_id` INT NOT NULL,
	`item_id` INT UNSIGNED NOT NULL,
	`count` INT NOT NULL DEFAULT 1,
	`date` INT UNSIGNED NOT NULL,
	PRIMARY KEY (`id`)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `datalog_rangerclub_boss_rewards` LIKE `datalog_boss_rewards`;
CREATE TABLE IF NOT EXISTS `datalog_christmas_drops` LIKE `datalog_boss_rewards`;
CREATE TABLE IF NOT EXISTS `datalog_easter_drops` LIKE `datalog_boss_rewards`;
CREATE TABLE IF NOT EXISTS `datalog_surprise_box` LIKE `datalog_boss_rewards`;
CREATE TABLE IF NOT EXISTS `datalog_anniversary_drops` LIKE `datalog_boss_rewards`;
CREATE TABLE IF NOT EXISTS `datalog_halloween_drops` LIKE `datalog_boss_rewards`;
CREATE TABLE IF NOT EXISTS `datalog_julyvacation_drops` LIKE `datalog_boss_rewards`;

-- (`player_id`, `task_id`, `date`) - 025-datalog.lua:50
CREATE TABLE IF NOT EXISTS `datalog_rangerclub_task`
(
	`id` INT NOT NULL AUTO_INCREMENT,
	`player_id` INT NOT NULL,
	`task_id` INT NOT NULL,
	`date` INT UNSIGNED NOT NULL,
	PRIMARY KEY (`id`)
) ENGINE = InnoDB;

-- (`player_id`, `boss_id`, `date`) - 025-datalog.lua:62
CREATE TABLE IF NOT EXISTS `datalog_rangerclub_boss`
(
	`id` INT NOT NULL AUTO_INCREMENT,
	`player_id` INT NOT NULL,
	`boss_id` INT NOT NULL,
	`date` INT UNSIGNED NOT NULL,
	PRIMARY KEY (`id`)
) ENGINE = InnoDB;

-- (`player_id`, `name`, `date`) - 025-datalog.lua:122
CREATE TABLE IF NOT EXISTS `datalog_referral_exchange`
(
	`id` INT NOT NULL AUTO_INCREMENT,
	`player_id` INT NOT NULL,
	`name` VARCHAR(255) NOT NULL,
	`date` INT UNSIGNED NOT NULL,
	PRIMARY KEY (`id`)
) ENGINE = InnoDB;

-- (`date`, `player_id`, `item_id`, `count`, `tokens`) - 025-datalog.lua:134 and :170
CREATE TABLE IF NOT EXISTS `datalog_mastery_token_bought`
(
	`id` INT NOT NULL AUTO_INCREMENT,
	`date` INT UNSIGNED NOT NULL,
	`player_id` INT NOT NULL,
	`item_id` INT UNSIGNED NOT NULL,
	`count` INT NOT NULL DEFAULT 1,
	`tokens` INT NOT NULL DEFAULT 0,
	PRIMARY KEY (`id`)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `datalog_casino_token_bought` LIKE `datalog_mastery_token_bought`;

-- (`date`, `player_id`, `gain`) - 025-datalog.lua:146
CREATE TABLE IF NOT EXISTS `datalog_slot_machine`
(
	`id` INT NOT NULL AUTO_INCREMENT,
	`date` INT UNSIGNED NOT NULL,
	`player_id` INT NOT NULL,
	`gain` INT NOT NULL DEFAULT 0,
	PRIMARY KEY (`id`)
) ENGINE = InnoDB;

-- (`player_id`, `item_id`, `count`, `bid`, `date`) - 025-datalog.lua:158, poketrader.lua:12
CREATE TABLE IF NOT EXISTS `datalog_poketrader_boughts`
(
	`id` INT NOT NULL AUTO_INCREMENT,
	`player_id` INT NOT NULL,
	`item_id` INT UNSIGNED NOT NULL,
	`count` INT NOT NULL DEFAULT 1,
	`bid` INT NOT NULL DEFAULT 0,
	`date` INT UNSIGNED NOT NULL,
	PRIMARY KEY (`id`),
	KEY (`player_id`, `item_id`)
) ENGINE = InnoDB;

-- (`date`, `player_id`, `pokemon_name`, `pokemon_level`, `pokemon_extrapoints`, `egg_move`[, `from_egg`])
CREATE TABLE IF NOT EXISTS `datalog_egg_move_generate`
(
	`id` INT NOT NULL AUTO_INCREMENT,
	`date` INT UNSIGNED NOT NULL,
	`player_id` INT NOT NULL,
	`pokemon_name` VARCHAR(255) NOT NULL,
	`pokemon_level` INT NOT NULL DEFAULT 1,
	`pokemon_extrapoints` INT NOT NULL DEFAULT 0,
	`egg_move` VARCHAR(255) NOT NULL DEFAULT '',
	`from_egg` TINYINT(1) NOT NULL DEFAULT 0,
	PRIMARY KEY (`id`)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `datalog_egg_move_regenerate`
(
	`id` INT NOT NULL AUTO_INCREMENT,
	`date` INT UNSIGNED NOT NULL,
	`player_id` INT NOT NULL,
	`pokemon_name` VARCHAR(255) NOT NULL,
	`pokemon_level` INT NOT NULL DEFAULT 1,
	`pokemon_extrapoints` INT NOT NULL DEFAULT 0,
	`egg_move` VARCHAR(255) NOT NULL DEFAULT '',
	PRIMARY KEY (`id`)
) ENGINE = InnoDB;

-- (`date`, `account_id`) - 025-datalog.lua:209, data/npc/scripts/wavearena.lua:37
CREATE TABLE IF NOT EXISTS `datalog_colosseum_arena`
(
	`id` INT NOT NULL AUTO_INCREMENT,
	`date` INT UNSIGNED NOT NULL,
	`account_id` INT NOT NULL,
	PRIMARY KEY (`id`),
	KEY (`account_id`, `date`)
) ENGINE = InnoDB;

-- (`action_id`, `sender`, `receiver`, `amount`, `date`) - 025-datalog.lua:233, bank.lua:85
CREATE TABLE IF NOT EXISTS `datalog_bank_transactions`
(
	`id` INT NOT NULL AUTO_INCREMENT,
	`action_id` INT NOT NULL,
	`sender` INT NOT NULL,
	`receiver` INT NOT NULL,
	`amount` BIGINT NOT NULL DEFAULT 0,
	`date` INT UNSIGNED NOT NULL,
	PRIMARY KEY (`id`),
	KEY (`sender`),
	KEY (`receiver`)
) ENGINE = InnoDB;

-- ---------------------------------------------------------------------------
-- Per-world rows for the stock tables. config.lua uses worldId = 1 but
-- mysql.sql only seeds world 0, which produced
-- "> ERROR: Failed to load motd!" / "Failed to load players record!".
-- ---------------------------------------------------------------------------

INSERT IGNORE INTO `server_motd` (`id`, `world_id`, `text`) VALUES (1, 1, 'Welcome to Pokemon Genesis World, Trainer!');
INSERT IGNORE INTO `server_record` (`record`, `world_id`, `timestamp`) VALUES (0, 1, 0);
