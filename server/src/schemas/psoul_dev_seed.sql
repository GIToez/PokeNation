-- Development seed data for a LOCAL PSoul server.
--
-- Creates two DEVELOPMENT-ONLY accounts in world 1 (never use these on a public server):
--   account  "admin"  / password "admin"     (no premium limits: 65535 days)
--     player "GM Admin"  - group 6 (God, access 5) - can use /i, /m, /goto, /reload ...
--     player "Tester"    - group 1 (regular trainer) on the GM account, handy for quick checks
--   account  "player" / password "player"    (plain player account, 65535 premium days)
--     player "Trainer"   - group 1 (regular trainer), the account to use for "normal player" tests
--
-- Passwords are stored as SHA-256 because config.lua uses
-- encryptionType = "sha256". Change the password before exposing the server:
--   UPDATE accounts SET password = SHA2('new-password', 256) WHERE name = 'admin';
--
-- Apply after mysql.sql and psoul_extra_mysql.sql:
--   mysql -u <user> -p <database> < src/schemas/psoul_dev_seed.sql
--
-- "GM Admin" and "Tester" spawn at newPlayerSpawnPos* / newPlayerTownId from
-- config.lua (3307,300,7 / town 3). "Trainer" starts like a brand-new
-- character is meant to: in the Tutorial town (34, temple 5000,806,6), where
-- Professor Oak (5020,788,7) hands out the starter Pokemon (Charmander /
-- Squirtle / Bulbasaur) and the main items (quest_professorOak.lua). The login
-- script gives a level-1 character +4 levels on the first login.
-- Outfits 611/612 are the default "Trainer" outfits from data/XML/outfits.xml.

INSERT INTO `accounts` (`id`, `name`, `password`, `premdays`, `lastday`, `email`, `key`, `blocked`, `warnings`, `group_id`)
VALUES (2, 'admin', SHA2('admin', 256), 65535, 0, '', '0', 0, 0, 1),
       (3, 'player', SHA2('player', 256), 65535, 0, '', '0', 0, 0, 1)
ON DUPLICATE KEY UPDATE `name` = `name`;

INSERT INTO `players`
	(`id`, `name`, `world_id`, `group_id`, `account_id`, `level`, `vocation`, `health`, `healthmax`, `experience`,
	 `lookbody`, `lookfeet`, `lookhead`, `looklegs`, `looktype`, `lookaddons`, `maglevel`, `mana`, `manamax`, `manaspent`,
	 `soul`, `town_id`, `posx`, `posy`, `posz`, `conditions`, `cap`, `sex`, `lastlogin`, `lastip`, `save`, `skull`,
	 `skulltime`, `rank_id`, `guildnick`, `lastlogout`, `blessings`, `online`)
VALUES
	(2, 'GM Admin', 1, 6, 2, 100, 1, 1000, 1000, 0,
	 68, 76, 78, 39, 612, 0, 0, 0, 0, 0,
	 100, 3, 3307, 300, 7, '', 400, 1, 0, 0, 1, 0,
	 0, 0, '', 0, 0, 0),
	(3, 'Tester', 1, 1, 2, 1, 1, 10, 10, 0,
	 68, 76, 78, 39, 611, 0, 0, 0, 0, 0,
	 100, 3, 3307, 300, 7, '', 400, 0, 0, 0, 1, 0,
	 0, 0, '', 0, 0, 0),
	(4, 'Trainer', 1, 1, 3, 1, 1, 10, 10, 0,
	 68, 76, 78, 39, 611, 0, 0, 0, 0, 0,
	 100, 34, 5000, 806, 6, '', 400, 0, 0, 0, 1, 0,
	 0, 0, '', 0, 0, 0)
ON DUPLICATE KEY UPDATE `name` = `name`;

-- Starting inventory. The original project created characters (and their
-- items) from a website that is not part of the archive. The PSoul inventory
-- slots are remapped in data/lib/ps/others/constants.lua:1366-1375:
--   1 = order icon (13206 "order icon off"), 5 = badge case (12280),
--   6 = pokedex (12281, required by doPokedexStatusSend on login),
--   10 = pokebag (12282) containing the items from doPlayerAddMainItems()
--   (data/lib/ps/functions/player.lua:717).
-- pid = slot id for equipped items, or the sid of the parent container.
DELETE FROM `player_items` WHERE `player_id` IN (2, 3, 4);
INSERT INTO `player_items` (`player_id`, `pid`, `sid`, `itemtype`, `count`, `attributes`) VALUES
	(2,   1, 101, 13206,   1, ''),
	(2,   5, 102, 12280,   1, ''),
	(2,   6, 103, 12281,   1, ''),
	(2,  10, 104, 12282,   1, ''),
	(2, 104, 105, 12157, 100, ''),
	(2, 104, 106,  2687, 100, ''),
	(2, 104, 107, 12244,  20, ''),
	(2, 104, 108,  2120,   1, ''),
	(2, 104, 109, 12292,   1, ''),
	(3,   1, 101, 13206,   1, ''),
	(3,   5, 102, 12280,   1, ''),
	(3,   6, 103, 12281,   1, ''),
	(3,  10, 104, 12282,   1, ''),
	(3, 104, 105, 12157, 100, ''),
	(3, 104, 106,  2687, 100, ''),
	(3, 104, 107, 12244,  20, ''),
	(3, 104, 108,  2120,   1, ''),
	(3, 104, 109, 12292,   1, ''),
	(4,   1, 101, 13206,   1, ''),
	(4,   5, 102, 12280,   1, ''),
	(4,   6, 103, 12281,   1, ''),
	(4,  10, 104, 12282,   1, ''),
	(4, 104, 105, 12157, 100, ''),
	(4, 104, 106,  2687, 100, ''),
	(4, 104, 107, 12244,  20, ''),
	(4, 104, 108,  2120,   1, ''),
	(4, 104, 109, 12292,   1, '');

-- Skills rows (the engine updates them with UPDATE statements, so they must exist).
INSERT IGNORE INTO `player_skills` (`player_id`, `skillid`, `value`, `count`)
SELECT `p`.`id`, `s`.`skillid`, 10, 0
FROM `players` `p`
JOIN (SELECT 0 AS `skillid` UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6) `s`
WHERE `p`.`id` IN (2, 3, 4);
