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

#ifndef __IOPLAYERSTATISTICS__
#define __IOPLAYERSTATISTICS__
#include "otsystem.h"

// Dont change any ID
enum PlayerStatistic_t
{
	HOOKED_FISH = 0,
	EVOLVE_POKEMON = 1,
	VISIT_KANTO_SAFARI = 2,
	CHANGE_POKEMON_NICKNAME = 3,
	SELL_POKEMON = 4,
	GENERATE_POKEMON_EGG = 5,
	CATCH_POKEMON_1ST_GEN = 6,
	CATCH_POKEMON_2ND_GEN = 7,
	CATCH_SHINY_POKEMON = 8,
	EARN_ACHIEVEMENT = 9,
	DEFEAT_NPC = 10,
	DEFEAT_PLAYER = 11,
	WIN_FRONTIER_ISLAND = 12,
	PLANT_BERRY = 13,
	COMPLETE_QUEST = 14,
	COMPLETE_TASK = 15,
	COMPLETE_DAILY_QUEST = 16,
	WIN_TOURNAMENT = 17,
	COMPLETE_RANGERCLUB_TASK = 18,
	COMPLETE_RANGERCLUB_BOSS = 19,
	USE_POKE_TRANSFORMATION = 20,
	PLAY_SLOT_MACHINE = 21,
	BID_ON_POKETRADER = 22,
	USE_VITAMIN = 23
};

class IOPlayerStatistics
{
	public:
		virtual ~IOPlayerStatistics() {}
		static IOPlayerStatistics* getInstance()
		{
			static IOPlayerStatistics instance;
			return &instance;
		}
		
		uint32_t saveStatistic(uint32_t playerGUID, PlayerStatistic_t statistic, uint32_t value);

	private:
		IOPlayerStatistics() {}
};
#endif
