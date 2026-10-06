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

#ifndef __IODATALOG__
#define __IODATALOG__
#include "otsystem.h"

class IODatalog
{
	public:
		virtual ~IODatalog() {}
		static IODatalog* getInstance()
		{
			static IODatalog instance;
			return &instance;
		}

        bool logCaught(uint32_t playerGUID, uint16_t pokemonNumber, uint32_t tries);
        bool logPlayerItems(uint32_t playerGUID, uint32_t itemCount, bool isLogin = true);
        bool logMapItems(std::vector<Item*> items);
        bool logLogin(uint32_t playerGUID, uint64_t date, uint32_t IP);
        bool logOnlinePlayers(uint16_t worldId, uint64_t date, uint32_t online);
        bool logBossSpawn(uint16_t worldId, const std::string& name, const Position& pos, uint64_t date);
       /* bool logPing(uint32_t playerGUID, uint64_t date, uint16_t ping); */
        bool logPokeNickChange(uint32_t playerGUID, std::string const &oldNickname, std::string const &newNickname, uint64_t date);
        bool logEggGenerate(uint32_t playerGUID, std::string const &egg, uint64_t date, uint16_t tries);
        bool logPlayerLevelUp(uint32_t playerGUID, uint32_t fromLevel, uint32_t toLevel, uint64_t date, const Position& pos);
        bool logPokemonLevelUp(uint32_t playerGUID, uint16_t pokemonNumber, uint32_t fromLevel, uint32_t toLevel,
                               uint64_t date, const Position& pos);
        bool logDuelBet(uint32_t leaderA, uint32_t leaderB, uint32_t playerGUID, uint32_t amount, uint64_t date);
        bool logTournamentWin(uint16_t tournamentId, uint32_t winner, uint64_t date);
        bool logTournamentHistory(uint16_t tournamentId, uint32_t winner, uint32_t loser, uint64_t date, uint16_t round);
        bool showTournamentHistory(uint16_t tournamentId);
        
        uint32_t getLastTournamentHistory(uint32_t winner, uint32_t loser);

	private:
		IODatalog() {}
};
#endif
