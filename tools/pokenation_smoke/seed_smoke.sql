-- State expected by tools/pokenation_client_smoke.py --shop / --pokemon (dev database only).
-- Applied after psoul_dev_seed.sql; safe to re-run before every smoke run.

-- --shop: the admin account starts with 20 Soul Coins and no shop history.
UPDATE `accounts` SET `soulcoins` = 20 WHERE `name` = 'admin';
DELETE FROM `datalog_shop_purchases` WHERE `account_id` = (SELECT `id` FROM `accounts` WHERE `name` = 'admin');

-- --pokemon: GM Admin back to the seed inventory (the smoke creates Venusaur 100 and Rattata 1
-- with /mypokemon), at the seed position, with enough Rattata ball_counter tries that every
-- poke ball has a 50% catch chance (empty.lua getCatchChance).
DELETE FROM `player_items` WHERE `player_id` = 2;
INSERT INTO `player_items` (`player_id`, `pid`, `sid`, `itemtype`, `count`, `attributes`) VALUES
	(2,   1, 101, 13206,   1, ''),
	(2,   2, 110, 13204,   1, ''),
	(2,   5, 102, 12280,   1, ''),
	(2,   6, 103, 12281,   1, ''),
	(2,  10, 104, 12282,   1, ''),
	(2, 104, 105, 12157, 100, ''),
	(2, 104, 106,  2687, 100, ''),
	(2, 104, 107, 12244,  20, ''),
	(2, 104, 108,  2120,   1, ''),
	(2, 104, 109, 12292,   1, '');
UPDATE `players` SET `posx` = 3307, `posy` = 307, `posz` = 7 WHERE `id` = 2;
REPLACE INTO `ball_counter` (`player_id`, `pokemon_id`, `poke`) VALUES (2, 19, 10);

-- Poll UI: one open multiple-choice poll and one open free-text poll, no votes yet. The server
-- reloads polls every 10 s and offers the lowest open id the account has not answered, so one
-- smoke run answers 901 and then 902. Option ids travel as U8 and must stay below 256.
DELETE FROM `poll_votes` WHERE `poll_id` IN (901, 902);
DELETE FROM `poll_texts` WHERE `poll_id` IN (901, 902);
DELETE FROM `poll_options` WHERE `poll_id` IN (901, 902);
REPLACE INTO `polls` (`id`, `name`, `question`, `deadline`, `text_mode`) VALUES
	(901, 'pn-smoke-choice', 'Which region should PokeNation open next?', NOW() + INTERVAL 7 DAY, 0),
	(902, 'pn-smoke-text', 'What should we improve first?', NOW() + INTERVAL 7 DAY, 1);
INSERT INTO `poll_options` (`id`, `poll_id`, `name`) VALUES
	(201, 901, 'Johto'),
	(202, 901, 'Hoenn'),
	(203, 901, 'Sinnoh');
