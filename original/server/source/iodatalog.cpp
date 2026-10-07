////////////////////////////////////////////////////////////////////////
// OpenTibia - an opensource roleplaying game
////////////////////////////////////////////////////////////////////////
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
////////////////////////////////////////////////////////////////////////
#include "otpch.h"

#include "iodatalog.h"
#include "database.h"

#include "container.h"

bool IODatalog::logCaught(uint32_t playerGUID, uint16_t pokemonNumber, uint32_t tries)
{
    Database* db = Database::getInstance();
	DBQuery query;
	query << "INSERT INTO `datalog_caughts` (`player_id`, `pokemon_number`, `tries`, `date`) VALUES ('" <<
            playerGUID << "', '" << pokemonNumber << "', '" << tries << "', '" << time(NULL) << "')";
	return db->executeQuery(query.str());
}

bool IODatalog::logPlayerItems(uint32_t playerGUID, uint32_t itemCount, bool isLogin)
{
    Database* db = Database::getInstance();
    DBQuery query;
    
    if (isLogin) {
	    DBResult* result;

	    query << "SELECT `player_id` FROM `datalog_player_items` WHERE `player_id` = " << playerGUID <<
                " AND `on_login_count` IS NULL LIMIT 1";
	    if (!(result = db->storeQuery(query.str()))) {
		    return false;
        }
        else {
            result->free();
            
            query.str("");
	        query << "UPDATE `datalog_player_items` SET `on_login_count` = " << itemCount << ", `on_login_date` = " << time(NULL) <<
                    " WHERE `player_id` = " << playerGUID << " AND `on_login_count` IS NULL LIMIT 1";
            return db->executeQuery(query.str());
            
        }
    }
    else {
	    query << "INSERT INTO `datalog_player_items` (`player_id`, `on_logout_count`, `on_logout_date`) VALUES ('" <<
            playerGUID << "', '" << itemCount << "', '" << time(NULL) << "')";
	    return db->executeQuery(query.str());
    }
    
    return false;
}

bool IODatalog::logLogin(uint32_t playerGUID, uint64_t date, uint32_t IP)
{
    Database* db = Database::getInstance();
	DBQuery query;
	query << "INSERT INTO `datalog_logins` (`player_id`, `date`, `ip`) VALUES ('" <<
            playerGUID << "', '" << date << "', '" << IP << "')";
	return db->executeQuery(query.str());
}

bool IODatalog::logOnlinePlayers(uint16_t worldId, uint64_t date, uint32_t online)
{
    Database* db = Database::getInstance();
	DBQuery query;
	query << "INSERT INTO `datalog_online` (`world_id`, `date`, `online`) VALUES ('" <<
            worldId << "', '" << date << "', '" << online << "')";
	return db->executeQuery(query.str());
}

bool IODatalog::logBossSpawn(uint16_t worldId, const std::string& name, const Position& pos, uint64_t date)
{
    Database* db = Database::getInstance();
	DBQuery query;
	query << "INSERT INTO `datalog_boss_spawns` (`world_id`, `name`, `posx`, `posy`, `posz`, `date`) VALUES ('" <<
            worldId << "', " << db->escapeString(name) << ", '" << pos.x << "', '" << pos.y << "', '" << pos.z << "', '" << date << "')";
	return db->executeQuery(query.str());
}
/*
bool IODatalog::logPing(uint32_t playerGUID, uint64_t date, uint16_t ping)
{
    Database* db = Database::getInstance();
	DBQuery query;
	query << "INSERT INTO `datalog_ping` (`player_id`, `date`, `ping`) VALUES ('" <<
            playerGUID << "', '" << date << "', '" << ping << "')";
	return db->executeQuery(query.str());
}
*/
bool IODatalog::logPokeNickChange(uint32_t playerGUID, std::string const &oldNickname, std::string const &newNickname, uint64_t date)
{
    Database* db = Database::getInstance();
	DBQuery query;
	query << "INSERT INTO `datalog_poke_nick_change` (`player_id`, `old_nickname`, `new_nickname`, `date`) VALUES ('" <<
            playerGUID << "', " << db->escapeString(oldNickname) << ", " << db->escapeString(newNickname) << ", '" << date << "')";
	return db->executeQuery(query.str());
}

bool IODatalog::logEggGenerate(uint32_t playerGUID, std::string const &egg, uint64_t date, uint16_t tries)
{
    Database* db = Database::getInstance();
	DBQuery query;
	query << "INSERT INTO `datalog_egg_generate` (`player_id`, `egg`, `date`, `tries`) VALUES ('" <<
            playerGUID << "', " << db->escapeString(egg) << ", '" << date << "', '" << tries << "')";
	return db->executeQuery(query.str());
}

bool IODatalog::logPlayerLevelUp(uint32_t playerGUID, uint32_t fromLevel, uint32_t toLevel, uint64_t date, const Position& pos)
{
    Database* db = Database::getInstance();
	DBQuery query;
	query << "INSERT INTO `datalog_player_ups` (`player_id`, `from_level`, `to_level`, `date`, `posx`, `posy`, `posz`) VALUES ('" <<
            playerGUID << "', '" << fromLevel << "', '" << toLevel << "', '" << date << "', '" << pos.x << "', '" <<
            pos.y << "', '" << pos.z << "')";
	return db->executeQuery(query.str());
}

bool IODatalog::logPokemonLevelUp(uint32_t playerGUID, uint16_t pokemonNumber, uint32_t fromLevel, uint32_t toLevel,
                                  uint64_t date, const Position& pos)
{
    Database* db = Database::getInstance();
	DBQuery query;
	query << "INSERT INTO `datalog_pokemon_ups` (`player_id`, `pokemon_number`, `from_level`, `to_level`, `date`, `posx`, `posy`, `posz`) VALUES ('" <<
            playerGUID << "', '" << pokemonNumber << "', '" << fromLevel << "', '" << toLevel << "', '" << date << "', '"
            << pos.x << "', '" << pos.y << "', '" << pos.z << "')";
	return db->executeQuery(query.str());
}

bool IODatalog::logDuelBet(uint32_t leaderA, uint32_t leaderB, uint32_t playerGUID, uint32_t amount, uint64_t date)
{
    Database* db = Database::getInstance();
	DBQuery query;
	query << "INSERT INTO `datalog_duel_bet` (`leader_a`, `leader_b`, `player_id`, `amount`, `date`) VALUES ('" <<
            leaderA << "', '" << leaderB << "', '" << playerGUID << "', '" << amount << "', '" << date << "')";
	return db->executeQuery(query.str());
}

bool IODatalog::logTournamentWin(uint16_t tournamentId, uint32_t winner, uint64_t date)
{
    Database* db = Database::getInstance();
	DBQuery query;
	query << "INSERT INTO `tournament_winners` (`tournament_id`, `winner`, `date`) VALUES ('" <<
            tournamentId << "', '" << winner << "', '" << date << "')";
	return db->executeQuery(query.str());
}

bool IODatalog::logTournamentHistory(uint16_t tournamentId, uint32_t winner, uint32_t loser, uint64_t date, uint16_t round)
{
    Database* db = Database::getInstance();
	DBQuery query;
	query << "INSERT INTO `tournament_histories` (`tournament_id`, `winner`, `loser`, `date`, `round`) VALUES ('" <<
            tournamentId << "', '" << winner << "', '" << loser << "', '" << date << "', '" << round << "')";
	return db->executeQuery(query.str());
}

bool IODatalog::showTournamentHistory(uint16_t tournamentId)
{
    Database* db = Database::getInstance();
	DBQuery query;
	query << "UPDATE `tournament_histories` SET `tournament_histories`.`show`=1 WHERE `tournament_id`='" << tournamentId << "'";
	return db->executeQuery(query.str());
}

bool IODatalog::logMapItems(std::vector<Item*> items)
{
    Database* db = Database::getInstance();
    DBInsert query_insert(db);
    query_insert.setQuery("INSERT INTO `datalog_map_items` (`itemtype`, `count`, `attributes`, `date`) VALUES ");

	Item* item = NULL;
	std::list<Container*> stackList;
	
	for (std::vector<Item*>::iterator it = items.begin(); it != items.end(); ++it) {
		item = *it;

		PropWriteStream propWriteStream;
		item->serializeAttr(propWriteStream);

		uint32_t attributesSize = 0;
		const char* attributes = propWriteStream.getStream(attributesSize);
		char buffer[attributesSize * 3 + 100]; //MUST be (size * 2), else people can crash server when filling writable with native characters

		sprintf(buffer, "%d, %d, %s, %d", item->getID(), (int32_t)item->getSubType(), db->escapeBlob(attributes, attributesSize).c_str(), time(NULL));
		if (!query_insert.addRow(buffer)) {
			return false;
        }

		if (Container* container = item->getContainer()) {
			stackList.push_back(container);
        }
	}

	while (stackList.size() > 0) {
		Container* container = stackList.front();
		stackList.pop_front();

		for (uint32_t i = 0; i < container->size(); ++i) {
			item = container->getItem(i);
			if (!item) {
                std::cout << "WARNING - IOLoginData::saveItems Unknown item at index " << i << std::endl;       
                continue;
            }
			
			if (Container* subContainer = item->getContainer()) {
				stackList.push_back(subContainer);
            }

			PropWriteStream propWriteStream;
			item->serializeAttr(propWriteStream);

			uint32_t attributesSize = 0;
			const char* attributes = propWriteStream.getStream(attributesSize);
			char buffer[attributesSize * 3 + 100]; //MUST be (size * 2), else people can crash server when filling writable with native characters

			sprintf(buffer, "%d, %d, %s, %d", item->getID(), (int32_t)item->getSubType(), db->escapeBlob(attributes, attributesSize).c_str(), time(NULL));
			if (!query_insert.addRow(buffer)) {
				return false;
            }
		}
	}

	return query_insert.execute();
}

uint32_t IODatalog::getLastTournamentHistory(uint32_t winner, uint32_t loser)
{
    Database* db = Database::getInstance();
	DBResult* result;

	DBQuery query;
	query << "SELECT `id` FROM `tournament_histories` WHERE `winner` = " << winner << " AND `loser` = " << loser << " ORDER BY `date` DESC LIMIT 1";
	if (!(result = db->storeQuery(query.str()))) {
		return 0;
    }

	uint32_t r = result->getDataInt("id");
	result->free();
	return r;
}
