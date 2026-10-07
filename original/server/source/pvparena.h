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

#ifndef __PVPARENA__
#define __PVPARENA__
#include "player.h"

enum pvpArenaTeam_t
{
	PVPTEAM_NONE = 0,
	PVPTEAM_BLUE = 1,
	PVPTEAM_RED = 2
};

typedef std::vector<Player*> PlayerVector;

class Player;
class PvpArena;

class PvpArena
{
	public:
		PvpArena(uint8_t _id, const Position& _blueSpawn, const Position& _redSpawn, const Position& _exit, uint32_t _maxLevel, uint16_t _blueChannel, uint16_t _redChannel);		
		virtual ~PvpArena();

		bool join(Player* player, pvpArenaTeam_t team);
		bool leave(Player* player, bool teleport = true);

		void broadcastMessage(MessageClasses messageClass, const std::string& text);
		//void broadcastAnimatedText(uint8_t textColor, const std::string& text, pvpArenaTeam_t team = TEAM_NONE);
		
		bool isPlayerMember(const Player* player, pvpArenaTeam_t team = PVPTEAM_NONE) const;
		bool isPlayerUser(const Player* player) const;
        
        void onKill(Player* player, Player* victim);
        void onDeath(Player* player);
        
        pvpArenaTeam_t getPlayerTeam(Player* player);
        pvpArenaTeam_t getPlayerTeam(const Player* _player);
        
        uint8_t getId() {return id;}
        uint16_t getBlueUsersCount() {return memberListBlue.size();}
        uint16_t getRedUsersCount() {return memberListRed.size();}
        
        void checkKills(Player* player);
        
        PlayerVector getUsers();

	private:
        uint8_t id;
        uint16_t blueChannel, redChannel;
        uint32_t maxLevel;
        
        Position blueSpawn;
        Position redSpawn;
        Position exit;
        
        Outfit_t blueOutfit;
        Outfit_t redOutfit;
            	
		PlayerVector memberListBlue;
		PlayerVector memberListRed;
		PlayerVector userList; // This include memberListBlue + memberListRed
};
#endif
