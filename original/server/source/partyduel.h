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

#ifndef __PARTYDUEL__
#define __PARTYDUEL__
#include "player.h"
#include "tournament.h"

enum EndMode
{
	END_DEFAULT = 0,
	END_PLAYERWITHOUTBALL = 1,
    END_TEAMA_WIN = 2,
    END_TEAMB_WIN = 3,
    END_TIMEOUT = 4,
    END_PLAYERWITHOUTMONEY = 5
};

enum Team
{
	TEAM_NONE = 0,
	TEAM_A = 1,
	TEAM_B = 2
};

typedef std::vector<Player*> PlayerVector;
typedef std::map<Player*, bool> PlayerStatusMap;

class Player;
class PartyDuel;
class TournamentBattle;

class PartyDuel
{
	public:
		PartyDuel(Player* _leaderA, uint8_t _maxMembers, uint8_t _maxPokemon, bool _cancelable = true, TournamentBattle* _tournamentBattle = NULL, uint32_t _bet = 0);
		virtual ~PartyDuel() {}

		Player* getLeaderA() const {return leaderA;}
		void setLeaderA(Player* _leaderA) {leaderA = _leaderA;}
		
		Player* getLeaderB() const {return leaderB;}
		void setLeaderB(Player* _leaderB) {leaderB = _leaderB;}

		void disband(EndMode endMode = END_DEFAULT, Player* violator = NULL/* This is used on tournaments disclassifications */);

		bool invitePlayer(Player* player, Team team);
		void revokeInvitation(Player* player, Team team);
		bool removeInvite(Player* player, Team team = TEAM_NONE);
		bool join(Player* player, Team team);
		bool leave(Player* player);

		void updateAllIcons(bool end = false);
		void updateIcons(Player* player, bool end = false);
		void broadcastMessage(MessageClasses messageClass, const std::string& text, bool sendToInvitations = false);
		
		bool isPlayerMember(const Player* player, bool result = false, Team team = TEAM_NONE) const;
		bool isPlayerInvited(const Player* player, bool result = false, Team team = TEAM_NONE) const;
		bool isPlayerUser(const Player* player, bool result = false) const;
		
        uint8_t getMaxMembers() {return maxMembers;}
        void setMaxMembers(uint8_t _maxMembers) {maxMembers = _maxMembers;}
        
        uint8_t getMaxPokemon() {return maxPokemon;}
        void setMaxPokemon(uint8_t _maxPokemon) {maxPokemon = _maxPokemon;}
        
        uint32_t getBet() {return bet;}
        
        void checkReady();
        void prepareStartDuel();
        void startDuel();
        void broadcastAnimatedText(uint8_t textColor, const std::string& text, Team team = TEAM_NONE);
        bool onPlayerLost(Player* player);
        bool checkBattle();
        void stopEvents();
        
        Team getPlayerTeam(Player* player);
        Team getPlayerTeam(const Player* _player);
        
        bool getCancelable() const {return cancelable;}
        void startBattleTimer(uint32_t time);
        void doBattleTimer();
        
        PlayerVector getPartners(Player* player);
        
        void onThink();
        
        bool getEnded() const;        

	private:
        void payBet(Player* player, uint32_t value);
        
        bool getBetRemoved() const;
        void setBetRemoved(bool value);           
 
            	
		PlayerVector memberListA;
		PlayerVector memberListB;
		PlayerVector inviteListA;
		PlayerVector inviteListB;
		PlayerVector userList; // This include memberListA + memberListB
		PlayerStatusMap statusMapA;
		PlayerStatusMap statusMapB;

		Player* leaderA;
		Player* leaderB;
		
		uint8_t maxMembers;
		uint8_t maxPokemon;
		uint8_t startTimer;
		uint8_t teamATimeout;
		uint8_t teamBTimeout;
		
		uint32_t eventStartDuel;
		uint32_t eventRemaingTime;
		uint32_t eventPokemonCheck;
		
		uint32_t bet;
		
		bool teamAReady;
		bool teamBReady;
		
		bool cancelable;
		bool checkOnThinkTimeout;
		bool working;
		bool ended;
		bool betRemoved;
		
		TournamentBattle* tournamentBattle;
};
#endif
