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

#ifndef __TOURNAMENT__
#define __TOURNAMENT__
#include "player.h"

class Player;
class Tournament;
class TournamentBattle;
class TournamentArena;
class TournamentReward;
class Tournaments;

enum rewardReason_t
{
    REWARDREASON_WINBATTLE,
    REWARDREASON_LOSSBATTLE,
    REWARDREASON_WINTOURNAMENT
};

enum tournamentType_t
{
    TOURNAMENTTYPE_DEFAULT = 0,
    TOURNAMENTTYPE_RANDOM,
    TOURNAMENTTYPE_MASTERY
};

typedef std::vector<Player*> PlayerVector;
typedef std::map<uint32_t, Player*> PlayerMap;
typedef std::vector<TournamentBattle*> BattlesVector;
typedef std::vector<TournamentArena*> ArenaVector;
typedef std::map<uint32_t, Tournament*> TournamentsMap;
typedef std::vector<TournamentReward*> RewardVector;

class TournamentReward
{
    public:
        TournamentReward(uint16_t itemId = 0, uint16_t count = 1, rewardReason_t reason = REWARDREASON_WINBATTLE, bool unique = false);
        virtual ~TournamentReward() {};
        
        void give(Player* player);
        
        uint16_t getItemId() const {return m_itemId;}
        uint16_t getCount() const {return m_count;}
        rewardReason_t getReason() const {return m_reason;}
        
    private:
        uint16_t m_itemId;
        uint16_t m_count;
        rewardReason_t m_reason;
        bool m_unique;
};

class TournamentArena
{
    public:
        TournamentArena();
        virtual ~TournamentArena() {};
        
        Position getPlayerAPosition() const {return playerAPosition;}
        void setPlayerAPosition(const Position& pos) {playerAPosition = pos;}
        
        Position getPlayerBPosition() const {return playerBPosition;}
        void setPlayerBPosition(const Position& pos) {playerBPosition = pos;}
        
        std::string& getName() {return name;}
        void setName(const std::string& newName) {name = newName;}
        
        bool getInUse() {return inUse;}
        void setInUse(bool _inUse) {inUse = _inUse;}
        
    private:
        Position playerAPosition;
        Position playerBPosition;
        std::string name;
        
        bool inUse;
};

class TournamentBattle
{
    public:
        TournamentBattle(Tournament* _tournament, Player* _playerA, Player* _playerB);
        virtual ~TournamentBattle() {};
        
        bool lookForArena(ArenaVector* arenas);
        bool check();
        void onEnd(Player* winner, bool bothLose = false);
        
        void setArena(TournamentArena* _arena) {arena = _arena;}
        TournamentArena* getArena() {return arena;}
        
        Player* getPlayerA() {return playerA;}
        Player* getPlayerB() {return playerB;}
        
        bool getStarted() const {return started;}
        void setStarted(bool _started);
        
        void onPlayerLeave(Player* player);
        
    private:
        Player* playerA;
        Player* playerB;
        TournamentArena* arena;
        Tournament* tournament;
        bool started;
};

class Tournament
{
	public:
		Tournament(uint16_t id);		
		virtual ~Tournament();
		
		void check();
		void prepareStart();
		void stopEvent();
		void start();
		bool load();
		void end(Player* winner = NULL, Player* loser = NULL);

		bool join(uint32_t playerGUID, uint32_t accountId = 0, bool fromLoad = false);
		bool leave(Player* player);
		void broadcastMessage(const std::string& text);
		void broadcastGlobalMessage(const std::string& text);
		
		void registerArena(TournamentArena* arena) {arenas.push_back(arena);}
		void registerReward(TournamentReward* reward) {rewards.push_back(reward);}
		
		void onBattleEnd(TournamentBattle* battle, Player* winner, Player* loser, bool bothLose = false);
		void onPlayerLeave(Player* player);
        
        uint16_t getId() const {return m_id;}
        std::string& getName() {return m_name;}
        uint8_t getCapacity() const {return m_capacity;}
        uint8_t getInverval() const {return m_interval;}
        time_t getDate() const {return m_date;}
        uint16_t getMinLevel() const {return m_minLevel;}
        uint16_t getMaxLevel() const {return m_maxLevel;}
        uint32_t getInscriptionPrice() const {return m_inscriptionPrice;}
        uint16_t getNumber() const {return m_number;}
        uint8_t getFreeCapacity() const {return freeCapacity;}
        uint16_t getGainScore() const {return m_gainScore;}
        tournamentType_t getType() const {return m_type;}
        uint16_t getMinTrainerLevel() const {return m_minTrainerLevel;}
        
        void setName(const std::string& name) {m_name = name;}
        void setCapacity(uint8_t capacity) {m_capacity = capacity; freeCapacity = m_capacity;}
        void setInterval(uint8_t interval) {m_interval = interval;}
        void setDate(time_t date);
        void setMinLevel(uint8_t minLevel) {m_minLevel = minLevel;}
        void setMaxLevel(uint8_t maxLevel) {m_maxLevel = maxLevel;}
        void setInscriptionPrice(uint32_t inscriptionPrice) {m_inscriptionPrice = inscriptionPrice;}
        void setSecurePosition(const Position& pos) {securePosition = pos;}
        void setExitPosition(const Position& pos) {exitPosition = pos;}
        void setNumber(uint16_t number) {m_number = number;}
        void setGainScore(uint16_t gainScore) {m_gainScore = gainScore;}
        void setType(tournamentType_t type) {m_type = type;}
        void setMinTrainerLevel(uint16_t minTrainerLevel) {m_minTrainerLevel = minTrainerLevel;}
        
        bool getStarted();

	private:
        void startBattles();
        void startBattle(TournamentBattle* battle);
        void broadcastBattles();
        void prepareStartRound();
        void preparePlayer(Player* player);
        bool sortBattles();
        void clear();
        void restart(uint32_t lastWinner);
        void exitPlayer(Player* player);
        void updateEvent(uint32_t newEvent);
            
        uint16_t m_id;
        std::string m_name;
        uint8_t m_capacity;
        uint8_t m_interval;
        time_t m_date;
        uint16_t m_minLevel;
        uint16_t m_maxLevel;
        uint32_t m_inscriptionPrice;
        uint16_t m_number;
        uint16_t m_gainScore;
        tournamentType_t m_type;
        uint16_t m_minTrainerLevel;
        
        bool running;
        bool loaded;
        bool started;
        bool startingBattles;
        
        uint8_t freeCapacity;
        uint32_t event;
        uint8_t currentRound;
        
        Position securePosition;
        Position exitPosition;
        
        PlayerMap players;
        BattlesVector battles;
        ArenaVector arenas;
        RewardVector rewards;
        Player* priorityPlayer;
};

class Tournaments
{
    public:
		virtual ~Tournaments() {clear();}
		static Tournaments* getInstance()
		{
			static Tournaments instance;
			return &instance;
		}

		bool loadFromXML();
		bool parseTournamentNode(xmlNodePtr p);
		bool checkWeeklyWinner();

		Tournament* getTournament(uint16_t tournamentId);
		uint16_t getLastTournamentId() const {return lastTournamentId;};

	private:
		TournamentsMap tournamentsMap;

		Tournaments() {lastTournamentId = 0;};
		void clear();
		
		uint16_t lastTournamentId;
};
#endif
