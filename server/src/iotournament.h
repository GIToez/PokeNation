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

#ifndef __IOTOURNAMENT__
#define __IOTOURNAMENT__
#include "otsystem.h"

#include "player.h"
#include "tournament.h"
class IOTournament
{
	public:
		virtual ~IOTournament() {}
		static IOTournament* getInstance()
		{
			static IOTournament instance;
			return &instance;
		}

        bool load(Tournament* tournament);
        bool ban(uint32_t playerGUID, uint64_t expires);
        bool join(uint16_t tournamentId, uint32_t playerGUID, uint32_t accountId);
        bool leave(uint32_t playerGUID);
        bool setNextDate(uint16_t tournamentId, uint64_t nextDate);
        bool restart(uint16_t tournamentId, uint32_t lastWinner, uint64_t lastDate, uint16_t number, uint64_t nextDate);
        bool isInscribed(uint32_t playerGUID);
        uint16_t getPlayerTournamentId(uint32_t playerGUID);
        bool clearBans();
        uint32_t getTournamentId(uint16_t tournamentRankId) const;
        uint32_t getHighestWeeklyPlayer() const;
        uint32_t getLastHighestWeeklyPlayer() const;
        bool doRegisterWeeklyWinner(uint32_t playerGuid);
        bool doResetWeeklyScore();

	private:
		IOTournament() {}
};
#endif
