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

#include "ioplayerstatistics.h"
#include "database.h"

uint32_t IOPlayerStatistics::saveStatistic(uint32_t playerGUID, PlayerStatistic_t statistic, uint32_t value)
{
    Database* db = Database::getInstance();
	DBQuery query;
	query << "INSERT INTO `player_statistics` (`player_id`, `key`, `value`) VALUES ('" <<
            playerGUID << "', '" << uint16_t(statistic) << "', '" << value <<
            "') ON DUPLICATE KEY UPDATE `value`=`value`+" << value;
            
	if (db->executeQuery(query.str())) {
	    DBResult* result = NULL;
	    query.str("");
	    query << "SELECT `value` FROM `player_statistics` WHERE `player_id` = " <<
                playerGUID << " AND `key` = " << statistic << " LIMIT 1";
                
	    if(!(result = db->storeQuery(query.str()))) {
		    return 0;
        }
		
        uint32_t value = result->getDataInt("value");
	    result->free();
	    return value;
    }
    
    return 0;
}
