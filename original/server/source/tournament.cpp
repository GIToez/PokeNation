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
#include "tournament.h"

#include "player.h"
#include "game.h"
#include "chat.h"
#include "iotournament.h"
#include "iodatalog.h"
#include "iologindata.h"

extern Game g_game;
extern Chat g_chat;
extern ConfigManager g_config;
extern CreatureEvents* g_creatureEvents;

/* Tournament Reward */
TournamentReward::TournamentReward(uint16_t itemId, uint16_t count, rewardReason_t reason, bool unique) :
        m_itemId(itemId), m_count(count), m_reason(reason), m_unique(unique)
{
#ifdef __DEBUG_TOURNAMENT__
    std::cout << "[TournamentReward::TournamentReward]Creating object" << std::endl;
#endif
}

void TournamentReward::give(Player* player)
{
#ifdef __DEBUG_TOURNAMENT__
    std::cout << "[TournamentReward::give]player: " << (player ? player->getName() : "NULL") << std::endl;
#endif
    if(Item* item = Item::CreateItem(m_itemId, m_count))
    {
        if(m_unique)
            item->setUniqueOwner(player->getGUID());
        
        if(Depot* depot = player->getDepot(0, true))
            g_game.internalMoveItem(player, item->getParent(), depot, INDEX_WHEREEVER, item, item->getItemCount(), NULL, FLAG_NOLIMIT);
            
        if (m_unique && item->getUniqueOwner() == 0) {
            std::cout << "[TournamentReward::give]Failed item unique owner setting. Player: " << player->getName() << " - ITEM_ID: " << m_itemId << " - COUNT: " << m_count << std::endl;
        }
    }
}

/* Tournament Battle */
TournamentBattle::TournamentBattle(Tournament* _tournament, Player* _playerA, Player* _playerB)
{
#ifdef __DEBUG_TOURNAMENT__
    //std::cout << "[TournamentBattle::TournamentBattle]Creating object: " << _playerA->getName() << ", " << _playerB->getName() << std::endl;
    std::cout << "[TournamentBattle::TournamentBattle]Creating object" << std::endl;
#endif
    tournament = _tournament;
    playerA = _playerA;
    playerB = _playerB;
    started = false;
    arena = NULL;
}
        
bool TournamentBattle::check()
{
#ifdef __DEBUG_TOURNAMENT__
    std::cout << "[TournamentBattle::check]" << std::endl;
#endif
    return playerA && playerB && arena && !arena->getInUse();
}

bool TournamentBattle::lookForArena(ArenaVector* arenas)
{
#ifdef __DEBUG_TOURNAMENT__
    std::cout << "[TournamentBattle::lookForArena]arenas: ..." << std::endl;
#endif
     /*for(ArenaVector::iterator it = arenas->begin(); it != arenas->end(); ++it)
     {
         if(!(*it)->getInUse())
         {
             arena = (*it);
             return true;
         }
     }
     return false;*/
     
     ArenaVector aux;
     for (ArenaVector::iterator it = arenas->begin(); it != arenas->end(); ++it) {
         if (!(*it)->getInUse()) {
             aux.push_back(*it);
         }   
     }
     
     if (aux.size() > 0) {
         random_shuffle(aux.begin(), aux.end());
         arena = (*aux.begin());
         aux.clear();
         return true;
     }
     
     aux.clear();
     return false;
}

void TournamentBattle::onEnd(Player* winner, bool bothLose)
{
#ifdef __DEBUG_TOURNAMENT__
    std::cout << "[TournamentBattle::onEnd]winner: " << (winner ? winner->getName() : "NULL") << ", bothLose: " << bothLose << std::endl;
#endif
    if (arena) {
        arena->setInUse(false);
    }
    tournament->onBattleEnd(this, winner, (winner == playerA ? playerB : playerA), bothLose);
}

void TournamentBattle::onPlayerLeave(Player* player)
{
#ifdef __DEBUG_TOURNAMENT__
    std::cout << "[TournamentBattle::onPlayerLeave]player: " << (player ? player->getName() : "NULL") << std::endl;
#endif
    if (player) {
        onEnd((player == playerA ? playerB : playerA));
    }
    else { // Timeout
        if (playerA->getDuelPokemonRemaing() < playerB->getDuelPokemonRemaing()) {
            onEnd(playerB);
        }
        else if (playerA->getDuelPokemonRemaing() > playerB->getDuelPokemonRemaing()) {
            onEnd(playerA);
        }
        else { // Both lose
            onEnd(playerA, true);
        }
    }
}

void TournamentBattle::setStarted(bool _started)
{
#ifdef __DEBUG_TOURNAMENT__
    std::cout << "[TournamentBattle::setStarted]_started: " << _started << std::endl;
#endif
    started = _started;
    if(arena && started)
        arena->setInUse(true);
}

/* Tournament Arena */
TournamentArena::TournamentArena()
{
#ifdef __DEBUG_TOURNAMENT__
    std::cout << "[TournamentArena::TournamentArena]Creating object" << std::endl;
#endif
    inUse = false;
}

/* Tournament */

Tournament::Tournament(uint16_t id) : m_id(id)                          
{
#ifdef __DEBUG_TOURNAMENT__
    std::cout << "[Tournament::Tournament]Creating object" << std::endl;
#endif
    running = loaded = started = startingBattles = false;
    event = currentRound = m_minLevel = m_maxLevel = m_capacity = m_interval = m_minTrainerLevel = 0;
    m_inscriptionPrice = freeCapacity = 0;
    m_number = 1;
    m_date = time(NULL);
    m_name = "Tournament";
    priorityPlayer = NULL;
    m_type = TOURNAMENTTYPE_DEFAULT;
}

Tournament::~Tournament()
{
#ifdef __DEBUG_TOURNAMENT__
    std::cout << "[Tournament::Tournament]Destroying object (" << m_name << ")" << std::endl;
#endif
    clear();
}

void Tournament::check()
{
#ifdef __DEBUG_TOURNAMENT__
    std::cout << "[Tournament::check] (" << m_name << ")" << std::endl;
#endif
    if(!loaded || running)
        return;
        
    if (int32_t(difftime(m_date, time(NULL))) < 0) {
        return;
    }
        
    running = true;
    prepareStart();
}

void Tournament::prepareStart()
{    
#ifdef __DEBUG_TOURNAMENT__
    std::cout << "[Tournament::prepareStart] (" << m_name << ")" << std::endl;
#endif
    int32_t remaingTime = int32_t(difftime(m_date, time(NULL)));
#ifdef __DEBUG_TOURNAMENT__
    std::cout << "[Tournament::prepareStart] remaingTime: " << remaingTime << " (" << m_name << ")" << std::endl;
#endif
    if (remaingTime <= 0) {
        start();
        return;
    }
    
    if (remaingTime > (3 * 60 * 60)) { // Show messages only when remaing 3< hours
#ifdef __DEBUG_TOURNAMENT__
    std::cout << "[Tournament::prepareStart] added for when 3< hours  (" << m_name << ")" << std::endl;
#endif
        updateEvent(Scheduler::getInstance().addEvent(createSchedulerTask((remaingTime - (3 * 60 * 60)) * 1000, boost::bind(&Tournament::prepareStart, this))));
        return;
    }
    
    int32_t rem = remaingTime / (60 * 60);
    if (rem > 0) {
        char buffer[150];
        sprintf(buffer, "The %s tournament (Pokemon Level %d - %d) will begin in %d hour%s! Visit Joey at PvP area for more information.", m_name.c_str(), m_minLevel, m_maxLevel, rem, (rem > 1 ? "s" : ""));
        broadcastGlobalMessage(buffer);
        updateEvent(Scheduler::getInstance().addEvent(createSchedulerTask((rem > 1 ? 60 : 15) * 60 * 1000, boost::bind(&Tournament::prepareStart, this))));
        return;
    }
    
    rem = remaingTime / (15 * 60);
    if (rem > 0) {
        char buffer[150];
        sprintf(buffer, "The %s tournament (Pokemon Level %d - %d) will begin in %d minutes! Visit Joey at PvP area for more information.", m_name.c_str(), m_minLevel, m_maxLevel, rem * 15);
        broadcastGlobalMessage(buffer);
        updateEvent(Scheduler::getInstance().addEvent(createSchedulerTask((rem > 1 ? 15 : 5) * 60 * 1000, boost::bind(&Tournament::prepareStart, this))));
        return;
    }
    
    rem = remaingTime / (5 * 60);
    if (rem > 0) {
        char buffer[150];
        sprintf(buffer, "The %s tournament (Pokemon Level %d - %d) will begin in %d minutes! Visit Joey at PvP area for more information.", m_name.c_str(), m_minLevel, m_maxLevel, rem * 5);
        broadcastGlobalMessage(buffer);
        updateEvent(Scheduler::getInstance().addEvent(createSchedulerTask((rem > 1 ? 5 : 1) * 60 * 1000, boost::bind(&Tournament::prepareStart, this))));
        return;
    }
    
    rem = remaingTime / 60;
    if (rem > 0) {
        char buffer[150];
        sprintf(buffer, "The %s tournament (Pokemon Level %d - %d) will begin in %d minute%s! Visit Joey at PvP area for more information.", m_name.c_str(), m_minLevel, m_maxLevel, rem, (rem > 1 ? "s" : ""));
        broadcastGlobalMessage(buffer);
        updateEvent(Scheduler::getInstance().addEvent(createSchedulerTask(60 * 1000, boost::bind(&Tournament::prepareStart, this))));
        return;
    }
    
    updateEvent(Scheduler::getInstance().addEvent(createSchedulerTask(remaingTime * 1000, boost::bind(&Tournament::prepareStart, this))));
}

void Tournament::stopEvent()
{
#ifdef __DEBUG_TOURNAMENT__
    std::cout << "[Tournament::stopEvent] (" << m_name << ")" << std::endl;
#endif
    if(!event || event == 0)
        return;
        
    Scheduler::getInstance().stopEvent(event);
	event = 0;
}

void Tournament::start()
{
#ifdef __DEBUG_TOURNAMENT__
    std::cout << "[Tournament::start] (" << m_name << ")" << std::endl;
#endif
    if(!loaded || !running)
        return;
        
    if ((m_capacity - freeCapacity) < 2) {
        char buffer[150];
        sprintf(buffer, "The %s tournament cannot be started due to lack of inscriptions!", m_name.c_str());
        broadcastMessage(buffer);
        running = false;
        return;
    }
    
    started = true;
        
    //load online players
    for(PlayerMap::iterator it = players.begin(); it != players.end(); ++it)
    {
        if(Player* player = g_game.getPlayerByGuid(it->first))
            it->second = player;
    }

    //bans and erases
    for(PlayerMap::iterator it = players.begin(); it != players.end();)
    {
        if(!it->second || !it->second->getTournamentReady())
        {
            // Temporary disabled IOTournament::getInstance()->ban(it->first, uint64_t(time(NULL)) + (86400 * 15));
            IOTournament::getInstance()->leave(it->first);
            players.erase(it++);
        } else {
            ++it;
        }
    }
    
    for(PlayerMap::iterator it = players.begin(); it != players.end(); ++it) {
        TVChannel* tv = g_chat.getTVChannel(it->second);
        if (!tv) {
            ChatChannel* channel = g_chat.createChannel(it->second, CHANNEL_TV);
            if (channel) {
                tv = channel->getTVChannel();
            }
        }
        if (tv) {
            char buffer[100];
            sprintf(buffer, "*[Tournament]%s", it->second->getName().c_str());
            tv->setName(buffer);
            tv->setPassword("");
            tv->setTournamentChannel(true); 
        }
                            
        it->second->setTournament(this);
        CreatureEventList events = it->second->getCreatureEvents(CREATURE_EVENT_TOURNAMENT_START);
    	for (CreatureEventList::iterator itt = events.begin(); itt != events.end(); ++itt) {
    		(*itt)->executeTournamentStart(it->second, m_id);
        }
    }

    if(sortBattles())
        prepareStartRound();
    else
        end();
}

bool Tournament::load()
{
#ifdef __DEBUG_TOURNAMENT__
    std::cout << "[Tournament::load]" << std::endl;
#endif
     if(loaded || running)
         return false;
     
     loaded = IOTournament::getInstance()->load(this);
     return loaded;
}

bool Tournament::leave(Player* player)
{
#ifdef __DEBUG_TOURNAMENT__
    std::cout << "[Tournament::leave]player: " << (player ? player->getName() : "NULL") << " (" << m_name << ")" << std::endl;
#endif
    if (started) {
	    return false;
    }
	
	if (IOTournament::getInstance()->leave(player->getGUID())) {
	    PlayerMap::iterator it = players.find(player->getGUID());
	    if (it != players.end()) {
		    players.erase(it);
        }
        
        freeCapacity++;
	    return true;
    }
	
	return false;
}

bool Tournament::join(uint32_t playerGUID, uint32_t accountId, bool fromLoad)
{   
#ifdef __DEBUG_TOURNAMENT__
    std::cout << "[Tournament::join]playerGUID: " << playerGUID << ", accountId: " << accountId << ", fromLoad: " << fromLoad << " (" << m_name << ")" << std::endl;
#endif
    if(freeCapacity == 0 || started || (!fromLoad && !loaded))
		return false;

    if(!fromLoad && !IOTournament::getInstance()->join(m_id, playerGUID, accountId))
        return false;

    players[playerGUID] = NULL;
    freeCapacity--;
	return true;
}

void Tournament::startBattles()
{
#ifdef __DEBUG_TOURNAMENT__
    std::cout << "[Tournament::startBattles] (" << m_name << ")" << std::endl;
#endif
    if (startingBattles) { // This occur when we are starting battles and one of them has forced a queue lookup
        return;
    }
    
    startingBattles = true;
    
    for (BattlesVector::iterator it = battles.begin(); it != battles.end(); ++it) {
        if (!started) { // This occur when the last started battle ended the tournament, if we execute the next, a crash will ocurr.
            break;
        }    
                  
        if (!(*it)->getStarted()) {
            startBattle(*it);
        }
    }
    
    startingBattles = false;
}

void Tournament::startBattle(TournamentBattle* battle)
{
#ifdef __DEBUG_TOURNAMENT__
    std::cout << "[Tournament::startBattle] (" << m_name << ")" << std::endl;
#endif
    if (!battle->check()) {
        battle->lookForArena(&arenas);
    }

    if (battle->check()) {
        battle->setStarted(true);
        // Check if any leaves the tournament room
        bool AReady = battle->getPlayerA()->getTournamentReady();
        bool BReady = battle->getPlayerB()->getTournamentReady();
        
        if (!AReady && !BReady) {
            battle->onPlayerLeave(NULL); // Both lose
            return;
        }

        else if (!AReady && BReady) {
            battle->onPlayerLeave(battle->getPlayerA()); // B Wins
            return;
        }
            
        else if (AReady && !BReady) {
            battle->onPlayerLeave(battle->getPlayerB()); // A Wins
            return;
        }
        
        preparePlayer(battle->getPlayerA());
        g_game.internalTeleport(battle->getPlayerA(), battle->getArena()->getPlayerAPosition(), false);
        g_game.internalCreatureTurn(battle->getPlayerA(), EAST);
        
        preparePlayer(battle->getPlayerB());
        g_game.internalTeleport(battle->getPlayerB(), battle->getArena()->getPlayerBPosition(), false);
        g_game.internalCreatureTurn(battle->getPlayerB(), WEST);    
  
        g_game.partyDuelCreate(battle->getPlayerA()->getID(), 1, 6, false, battle);
        g_game.partyDuelInvite(battle->getPlayerA()->getID(), battle->getPlayerB()->getID());
        g_game.partyDuelJoin(battle->getPlayerA()->getID(), battle->getPlayerB()->getID());
        
        if (battle->getPlayerA()->getPartyDuel()) {
            battle->getPlayerA()->getPartyDuel()->startBattleTimer(13 * 60);
        }
        
        char buffer[100];
        sprintf(buffer, "The battle between %s and %s begun on the %s Arena!", battle->getPlayerA()->getName().c_str(), battle->getPlayerB()->getName().c_str(), battle->getArena()->getName().c_str());    
        broadcastMessage(buffer);
    }
}

void Tournament::broadcastBattles()
{    
#ifdef __DEBUG_TOURNAMENT__
    std::cout << "[Tournament::broadcastBattles] (" << m_name << ")" << std::endl;
#endif
    for(BattlesVector::iterator it = battles.begin(); it != battles.end(); ++it)
    {
        char bufferA[100];
        sprintf(bufferA, "Next opponent: %s", (*it)->getPlayerB()->getName().c_str());
        (*it)->getPlayerA()->sendTextMessage(MSG_STATUS_WARNING, bufferA);
        
        char bufferB[100];
        sprintf(bufferB, "Next opponent: %s", (*it)->getPlayerA()->getName().c_str());
        (*it)->getPlayerB()->sendTextMessage(MSG_STATUS_WARNING, bufferB);
        
    }
}

void Tournament::prepareStartRound()
{
#ifdef __DEBUG_TOURNAMENT__
    std::cout << "[Tournament::prepareStartRound] (" << m_name << ")" << std::endl;
#endif
    currentRound++;
    char buffer[100];
    sprintf(buffer, "Round %d will start in 60 seconds. Be ready!", currentRound);
    broadcastMessage(buffer);
    broadcastBattles();    
    updateEvent(Scheduler::getInstance().addEvent(createSchedulerTask(60 * 1000, boost::bind(&Tournament::startBattles, this))));
}

void Tournament::broadcastMessage(const std::string& text)
{
#ifdef __DEBUG_TOURNAMENT__
    std::cout << "[Tournament::broadcastMessage]text: " << text << " (" << m_name << ")" << std::endl;
#endif
    if(ChatChannel* channel = g_chat.getChannelById(CHANNEL_TOURNAMENT))
        channel->internalTalk("Tournament", text, SPEAK_CHANNEL_O);
}

void Tournament::broadcastGlobalMessage(const std::string& text)
{
#ifdef __DEBUG_TOURNAMENT__
    std::cout << "[Tournament::broadcastGlobalMessage]text: " << text << " (" << m_name << ")" << std::endl;
#endif
    g_game.broadcastMessage(text, MSG_STATUS_WARNING);
}

void Tournament::preparePlayer(Player* player)
{
#ifdef __DEBUG_TOURNAMENT__
    std::cout << "[Tournament::preparePlayer]player: " << (player ? player->getName() : "NULL") << " (" << m_name << ")" << std::endl;
#endif
    if(player->getPartyDuel())
        player->getPartyDuel()->leave(player);
        
    /*if(player->getSummonCount())
    {
        const std::list<Creature*>& summons = player->getSummons();
   	    CreatureList::const_iterator it = summons.begin();
        for(uint32_t i = 1; it != summons.end(); ++it, ++i)
            g_game.removeCreature((*it));
    }*/
    /*if (player->getSummonCount() > 0) {
        player->killSummons();
    }*/
    
    player->setNoMove(true);
    player->setDisconnectAtExit(false);
}

bool Tournament::sortBattles()
{
#ifdef __DEBUG_TOURNAMENT__
    std::cout << "[Tournament::sortBattles] (" << m_name << ")" << std::endl;
#endif
     if(players.size() < 2)
         return false;
     
     PlayerVector aux;
     for(PlayerMap::iterator it = players.begin(); it != players.end(); ++it)
     {
         if(it->second)
             aux.push_back(it->second);
     }
      
     if (priorityPlayer) { // This player doenst got a battle at the last round
         bool lookBattle = true;
         for (PlayerVector::iterator it = aux.begin(); it != aux.end();) {
             if (*it == priorityPlayer) {
                 it = aux.erase(it);
             }
             else if (lookBattle) {
                 battles.push_back(new TournamentBattle(this, *it, priorityPlayer));
                 it = aux.erase(it);
                 lookBattle = false;
             }
             else {
                 ++it;
             }
         }
         priorityPlayer = NULL;
     }
     
     uint32_t auxSize = (aux.size() / 2);
     for(uint16_t i = 0; i < auxSize; i++)
     {      
         random_shuffle(aux.begin(), aux.end());
         Player* A;
         Player* B;
         
         PlayerVector::iterator playerAIT = aux.begin();
         A = *playerAIT;
         aux.erase(aux.begin());
         
         PlayerVector::iterator playerBIT = aux.begin();
         B = *playerBIT;
         aux.erase(aux.begin());
         
         if(A != B)
             battles.push_back(new TournamentBattle(this, A, B));
         else
             return battles.size() > 0;
     }
     
     if (aux.size() > 0) {
         priorityPlayer = *aux.begin();
     }
     
     aux.clear();
     return true;
}

void Tournament::onBattleEnd(TournamentBattle* battle, Player* winner, Player* loser, bool bothLose)
{
#ifdef __DEBUG_TOURNAMENT__
    std::cout << "[Tournament::onBattleEnd]winner: " << (winner ? winner->getName() : "NULL") << ", loser: " << (loser ? loser->getName() : "NULL") << " (" << m_name << ")" << std::endl;
#endif
    if(!bothLose)
    {
        //broadcast
        char buffer[100];
        sprintf(buffer, "%s won %s", winner->getName().c_str(), loser->getName().c_str());    
        broadcastMessage(buffer);
        //reset player (teleport...)
        winner->destroySummons(); // prevent another player to see the winner Pokemon Team
        g_game.internalTeleport(winner, securePosition, false);
        g_game.internalCreatureSay(winner, SPEAK_SAY, "hi",	false);
        //winner->setTournamentReady(false);
        exitPlayer(loser);
        //rewards
        winner->addTournamentScore(m_gainScore);
        winner->addTournamentWeeklyScore(m_gainScore);
        
        for(RewardVector::iterator it = rewards.begin(); it != rewards.end(); ++it)
        {
            if((*it)->getReason() == REWARDREASON_WINBATTLE)
                (*it)->give(winner);
        }
    
        for(RewardVector::iterator it = rewards.begin(); it != rewards.end(); ++it)
        {
            if((*it)->getReason() == REWARDREASON_LOSSBATTLE)
                (*it)->give(loser);
        }
        
        if (IODatalog::getInstance()->logTournamentHistory(IOTournament::getInstance()->getTournamentId(getId()), winner->getGUID(), loser->getGUID(), time(NULL), currentRound)) {
            g_creatureEvents->tournamentHistory(IODatalog::getInstance()->getLastTournamentHistory(winner->getGUID(), loser->getGUID()), winner, loser);
        }
        
        //clean   
        for(BattlesVector::iterator it = battles.begin(); it != battles.end(); ++it)
        {
            if((*it) == battle)
            {
                battles.erase(it);
                break;
            }
        }
        delete battle;

        for(PlayerMap::iterator it = players.begin(); it != players.end(); ++it)
        {
            if(it->second == loser)
            {
                players.erase(it);
                break;
            }
        }
    }
    else
    {
        //broadcast
        char buffer[100];
        sprintf(buffer, "The battle between %s and %s has timed out! Both disqualified.", winner->getName().c_str(), loser->getName().c_str());    
        broadcastMessage(buffer);
        //reset player (teleport...)
        exitPlayer(winner);
        exitPlayer(loser);
        //rewards    
        for(RewardVector::iterator it = rewards.begin(); it != rewards.end(); ++it)
        {
            if ((*it)->getReason() == REWARDREASON_LOSSBATTLE) {
                (*it)->give(loser);
                (*it)->give(winner);
            }
        }
        //clean   
        for(BattlesVector::iterator it = battles.begin(); it != battles.end(); ++it)
        {
            if((*it) == battle)
            {
                battles.erase(it);
                break;
            }
        }
        delete battle;

        for(PlayerMap::iterator it = players.begin(); it != players.end();)
        {
            if(it->second == winner || it->second == loser) {
                players.erase(it++);
            } else {
                ++it;
            }
        }
    }
    
    //procede
    if (battles.size() == 0) {
        if (players.size() <= 1) {
            end(winner, loser);
        }
        else {
            sortBattles();
            prepareStartRound();
        }
    }
    else { //look for queued battles
        startBattles();
    }
}

void Tournament::setDate(time_t date)
{
#ifdef __DEBUG_TOURNAMENT__
    std::cout << "[Tournament::setDate]date: " << date << " (" << m_name << ")" << std::endl;
#endif
    if(!m_date || m_date < date)
    {
        m_date = date;
        IOTournament::getInstance()->setNextDate(m_id, m_date);
    }
}

void Tournament::end(Player* winner, Player* loser)
{
#ifdef __DEBUG_TOURNAMENT__
    std::cout << "[Tournament::end]winner: " << (winner ? winner->getName() : "NULL") << ", loser: " << (loser ? loser->getName() : NULL) << " (" << m_name << ")" << std::endl;
#endif
    if(!players.empty())
    {
        for(PlayerMap::iterator it = players.begin(); it != players.end(); ++it)
            exitPlayer(it->second);
    }
    
    if(winner && loser)
    {
        char buffer[150];
        sprintf(buffer, "%s won the %s tournament!", winner->getName().c_str(), m_name.c_str());    
        broadcastGlobalMessage(buffer);
    
        for(RewardVector::iterator it = rewards.begin(); it != rewards.end(); ++it)
        {
            if((*it)->getReason() == REWARDREASON_WINTOURNAMENT)
                (*it)->give(winner);
        }
        
        time_t timeNow = time(NULL);
        struct tm * theTime = localtime(&timeNow);
        
        /*if(Item* item = Item::CreateItem(((theTime->tm_wday == 0 || theTime->tm_wday == 6) ?
            ITEM_TOURNAMENT_WEEKEND_GOLDEN_GLOBET : ITEM_TOURNAMENT_WEEKDAY_GOLDEN_GLOBET), 1))
        {
            char desc[100];
            sprintf(desc, "Prize of #%d %s Tournament! First place - %s.", m_number, m_name.c_str(), winner->getName().c_str()); 
            
            item->setSpecialDescription(desc);
            
            if(Depot* depot = winner->getDepot(0, true))
                g_game.internalMoveItem(winner, item->getParent(), depot, INDEX_WHEREEVER, item, item->getItemCount(), NULL, FLAG_NOLIMIT);
        }
        
        if(Item* item = Item::CreateItem(((theTime->tm_wday == 0 || theTime->tm_wday == 6) ?
            ITEM_TOURNAMENT_WEEKEND_SILVER_GLOBET : ITEM_TOURNAMENT_WEEKDAY_SILVER_GLOBET), 1))
        {
            char desc[100];
            sprintf(desc, "Prize of #%d %s Tournament! Second place - %s.", m_number, m_name.c_str(), loser->getName().c_str()); 
            
            item->setSpecialDescription(desc);
            
            if(Depot* depot = loser->getDepot(0, true))
                g_game.internalMoveItem(loser, item->getParent(), depot, INDEX_WHEREEVER, item, item->getItemCount(), NULL, FLAG_NOLIMIT);
        }*/
        
        IODatalog::getInstance()->logTournamentWin(IOTournament::getInstance()->getTournamentId(getId()), winner->getGUID(), time(NULL));
        restart(winner->getGUID());
        g_game.playerAddStatistic(winner, WIN_TOURNAMENT, 1);
        
    }
    else
    {
        char buffer[100];
        sprintf(buffer, "Nobody won the %s tournament!", m_name.c_str());    
        broadcastMessage(buffer);
        restart(0);
    }
    
    IODatalog::getInstance()->showTournamentHistory(IOTournament::getInstance()->getTournamentId(getId()));
}

void Tournament::clear()
{
#ifdef __DEBUG_TOURNAMENT__
    std::cout << "[Tournament::clear] (" << m_name << ")" << std::endl;
#endif
    stopEvent();
    
    for(BattlesVector::iterator it = battles.begin(); it != battles.end(); ++it)
        delete (*it);
        
    for(ArenaVector::iterator it = arenas.begin(); it != arenas.end(); ++it)
        delete (*it);
    
    players.clear();
    battles.clear();
    arenas.clear();
    rewards.clear();
}

void Tournament::restart(uint32_t lastWinner)
{
#ifdef __DEBUG_TOURNAMENT__
    std::cout << "[Tournament::restart]lastWinner: " << lastWinner << " (" << m_name << ")" << std::endl;
#endif
    stopEvent();
    for(BattlesVector::iterator it = battles.begin(); it != battles.end(); ++it)
        delete (*it);
        
    players.clear();
    battles.clear();
    
    IOTournament::getInstance()->restart(m_id, lastWinner, m_date, m_number + 1, (m_date + (/*m_interval * 7 * */86400)));
    running = started = false;
    currentRound = 0;
    freeCapacity = m_capacity;
}

void Tournament::exitPlayer(Player* player)
{
#ifdef __DEBUG_TOURNAMENT__
    std::cout << "[Tournament::exitPlayer]player: " << (player ? player->getName() : "NULL") << " (" << m_name << ")" << std::endl;
#endif
    if (player->getTournamentReady() && !player->getLeaving()) {
        g_game.internalTeleport(player, exitPosition, false);
    }
    player->setTournamentReady(false);
    player->setTournament(NULL);
    player->setDisconnectAtExit(true);
    
    if(player->getRecordingTV())
    {  
        if(TVChannel* tvChannel = g_chat.getTVChannel(player))
        {
            char buffer[100];
            sprintf(buffer, "%s's TV Channel", player->getName().c_str());
            tvChannel->setName(buffer);
            tvChannel->setTournamentChannel(false);
        }
    }
}

void Tournament::onPlayerLeave(Player* player)
{
#ifdef __DEBUG_TOURNAMENT__
    std::cout << "[Tournament::onPlayerLeave]player: " << (player ? player->getName() : "NULL") << " (" << m_name << ")" << std::endl;
#endif
    //check battles
    for(BattlesVector::iterator it = battles.begin(); it != battles.end(); ++it)
    {
        if(player == (*it)->getPlayerA() || player == (*it)->getPlayerB())
        {
            (*it)->onPlayerLeave(player);
            return;
        }
    }
    
    for(PlayerMap::iterator it = players.begin(); it != players.end(); ++it)
    {
        if(it->second == player)
        {
            players.erase(it);
            break;
        }
    }
    
    if (priorityPlayer == player) {
        priorityPlayer = NULL;
    }
}

void Tournament::updateEvent(uint32_t newEvent)
{
#ifdef __DEBUG_TOURNAMENT__
    std::cout << "[Tournament::updateEvent]newEvent: " << newEvent << " (" << m_name << ")" << std::endl;
#endif
    stopEvent();
    event = newEvent;
}

/* Tournaments */
void Tournaments::clear()
{
	for(TournamentsMap::iterator it = tournamentsMap.begin(); it != tournamentsMap.end(); ++it)
		delete it->second;

	tournamentsMap.clear();
}

bool Tournaments::loadFromXML()
{ 
	xmlDocPtr doc = xmlParseFile(getFilePath(FILE_TYPE_XML,"tournaments.xml").c_str());
	if(!doc)
	{
		std::cout << "[Warning - Tournaments::loadFromXml] Cannot load tournaments file." << std::endl;
		std::cout << getLastXMLError() << std::endl;
		return false;
	}

	xmlNodePtr p, root = xmlDocGetRootElement(doc);
	if(xmlStrcmp(root->name,(const xmlChar*)"tournaments"))
	{
		std::cout << "[Error - Tournaments::loadFromXml] Malformed tournaments file." << std::endl;
		xmlFreeDoc(doc);
		return false;
	}

	for(p = root->children; p; p = p->next)
		parseTournamentNode(p);
		
	for(TournamentsMap::iterator it = tournamentsMap.begin(); it != tournamentsMap.end(); ++it)
	{
	    it->second->load();
        it->second->check();
    }

	xmlFreeDoc(doc);
	IOTournament::getInstance()->clearBans();
	return true;
}

bool Tournaments::parseTournamentNode(xmlNodePtr p)
{
	std::string strValue;
	int32_t intValue;
	if(xmlStrcmp(p->name, (const xmlChar*)"tournament"))
		return false;

	if(!readXMLInteger(p, "id", intValue))
	{
		std::cout << "[Error - Tournament::parseTournamentNode] Missing tournament id." << std::endl;
		return false;
	}
	
	/*if(intValue > lastTournamentId + 1)
	{
        std::cout << "[Error - Tournament::parseTournamentNode] Too high tournament id. (Last: " << lastTournamentId << ")" << std::endl;
		return false;
    }*/

	Tournament* tournament = new Tournament(intValue);
	
	if(readXMLString(p, "enabled", strValue))
	{
		if(!booleanString(strValue))
		{
            delete tournament;
            return true;
        }
    }	
	
	if (readXMLString(p, "name", strValue)) {
		if (strValue.size() <= 20) {
            tournament->setName(strValue);
        }
        else {
            std::cout << "[Error - Tournament::parseTournamentNode] Name cant be higher then 20 characters." << std::endl;
		    delete tournament;
            return false;
        }
    }

	if(readXMLInteger(p, "capacity", intValue))
	{
		if(intValue < 4)
		{
            std::cout << "[Error - Tournament::parseTournamentNode] Capacity cant be less then 4. (Capacity: " << intValue << ")" << std::endl;
		    delete tournament;
            return false;
        }
        tournament->setCapacity(intValue);
    }
		
	if(readXMLInteger(p, "interval", intValue))
		tournament->setInterval(intValue);
		
	if(readXMLInteger(p, "hour", intValue))
	{
        uint8_t hour = intValue;
        
        if (readXMLString(p, "days", strValue)) {
            std::vector<int32_t> intVector;
            if (!parseIntegerVec(strValue, intVector)) {
    			std::cout << "[Warning - Tournaments::parseTournamentNode] Invalid days - '" << strValue << "'" << std::endl;
    			return false;
    		}
    		
    		time_t rawtime;
            tm * timeinfo;
            time(&rawtime);
            timeinfo = localtime(&rawtime);
            int addDays = -1;
    		
    		for (size_t i = 0, size = intVector.size(); i < size; ++i) {
                int tmpAddDays = -1;
                if (intVector[i] == timeinfo->tm_wday) {
                    tmpAddDays = 0;
                }
                else if (timeinfo->tm_wday < intVector[i]) {
                    tmpAddDays = intVector[i] - timeinfo->tm_wday;
                }
                else { // timeinfo->tm_wday > intVector[i]
                    tmpAddDays = 6 - (timeinfo->tm_wday - intVector[i]);
                }
                        
                if (addDays == -1 || tmpAddDays < addDays) {
                    addDays = tmpAddDays;
                }
    		}
    		
    		time_t timeNow = time(NULL);
            struct tm * theTime = localtime(&timeNow);
    		    
            theTime->tm_hour = hour;
            theTime->tm_min = 0;
            theTime->tm_sec = 0;
            time_t newTime = mktime(theTime);
            
            if (addDays > 0) {
                newTime += addDays * 86400;
            }
    		    
            int32_t diff = int32_t(difftime(newTime, timeNow));
            if (diff > 0) {   
                tournament->setDate(newTime);
                //newTime = newTime + ((addDays != -1 ? addDays : 1) * 86400);
            }		    
        }
        
        if (readXMLInteger(p, "day", intValue)) {
            time_t timeNow = time(NULL);
		    struct tm * theTime = localtime(&timeNow);
		    /*
            uint8_t day = intValue;
            int32_t extraDays = 0;
		    
		    if(theTime->tm_wday > day)
			    extraDays = 7 - (theTime->tm_wday - day);
		    else if(theTime->tm_wday < day)
			    extraDays = day - theTime->tm_wday;
            */
		    
		    theTime->tm_hour = hour;
		    theTime->tm_min = 0;
		    theTime->tm_sec = 0;
		    time_t newTime = mktime(theTime);
		    
		    int32_t diff = int32_t(difftime(newTime, timeNow));
            if (diff <= 0) {
                newTime = newTime + (/*extraDays * */86400);
            }		    
		    
		    tournament->setDate(newTime);
            /*
            time_t rawTime;
            struct tm * newTime;
            time(&rawTime);
            newTime = localtime(&rawTime);
            newTime->tm_hour = hour;
            newTime->tm_wday = day;
        
            tournament->setDate(mktime(newTime));
            */
        }
    }
		
	if(readXMLInteger(p, "minLevel", intValue))
		tournament->setMinLevel(intValue);
		
	if(readXMLInteger(p, "maxLevel", intValue))
		tournament->setMaxLevel(intValue);
		
	if(readXMLInteger(p, "inscriptionPrice", intValue))
		tournament->setInscriptionPrice(intValue);
		
	if(readXMLInteger(p, "gainScore", intValue))
		tournament->setGainScore(intValue);
		
	if (readXMLInteger(p, "type", intValue)) {
		tournament->setType((tournamentType_t)intValue);
    }
    
	if (readXMLInteger(p, "minTrainerLevel", intValue)) {
		tournament->setMinTrainerLevel(intValue);
    }
		
	Position securePosition;
    if(!readXMLInteger(p, "securePositionX", intValue))
        return false;
    securePosition.x = intValue;
            
    if(!readXMLInteger(p, "securePositionY", intValue))
        return false;
    securePosition.y = intValue;
            
    if(!readXMLInteger(p, "securePositionZ", intValue))
        return false;
    securePosition.z = intValue;
    
    Position exitPosition;
    if(!readXMLInteger(p, "exitPositionX", intValue))
        return false;
    exitPosition.x = intValue;
            
    if(!readXMLInteger(p, "exitPositionY", intValue))
        return false;
    exitPosition.y = intValue;
            
    if(!readXMLInteger(p, "exitPositionZ", intValue))
        return false;
    exitPosition.z = intValue;
    
    tournament->setSecurePosition(securePosition);
    tournament->setExitPosition(exitPosition);

	for(xmlNodePtr configNode = p->children; configNode; configNode = configNode->next)
	{
		if(!xmlStrcmp(configNode->name, (const xmlChar*)"arena"))
		{            			    
            Position playerAPosition;
            if(!readXMLInteger(configNode, "playerAPositionX", intValue))
                return false;
            playerAPosition.x = intValue;
            
            if(!readXMLInteger(configNode, "playerAPositionY", intValue))
                return false;
            playerAPosition.y = intValue;
            
            if(!readXMLInteger(configNode, "playerAPositionZ", intValue))
                return false;
            playerAPosition.z = intValue;
            
            Position playerBPosition;
            if(!readXMLInteger(configNode, "playerBPositionX", intValue))
                return false;
            playerBPosition.x = intValue;
            
            if(!readXMLInteger(configNode, "playerBPositionY", intValue))
                return false;
            playerBPosition.y = intValue;
            
            if(!readXMLInteger(configNode, "playerBPositionZ", intValue))
                return false;
            playerBPosition.z = intValue;
            
            TournamentArena* arena = new TournamentArena();
            
            arena->setPlayerAPosition(playerAPosition);
            arena->setPlayerBPosition(playerBPosition);
            
            if(readXMLString(configNode, "name", strValue))
			    arena->setName(strValue);
            
            tournament->registerArena(arena);
		}
		
		else if(!xmlStrcmp(configNode->name, (const xmlChar*)"reward"))
		{
            uint16_t itemId = 0, count = 0;
            rewardReason_t reason = REWARDREASON_WINBATTLE;
            bool unique = false;
            
            if(readXMLInteger(configNode, "itemid", intValue))
		        itemId = intValue;
		        
            if(readXMLInteger(configNode, "count", intValue))
                count = intValue;
                
            if(readXMLInteger(configNode, "reason", intValue))
                reason = rewardReason_t(intValue);
                
            if(readXMLString(configNode, "unique", strValue))
	        {
		        if(booleanString(strValue))
		            unique = true;
            }
            
            if(TournamentReward* reward = new TournamentReward(itemId, count, reason, unique))
                tournament->registerReward(reward);
        }
	}

    tournamentsMap[tournament->getId()] = tournament;
    lastTournamentId = tournament->getId();
	return true;
}

bool Tournaments::checkWeeklyWinner()
{
    time_t rawtime;
    tm * timeinfo;
    time(&rawtime);
    timeinfo = localtime(&rawtime);
    
    if (timeinfo->tm_wday == g_config.getNumber(ConfigManager::TOURNAMENT_WEEK_DAY_CHECK)) {
        uint32_t winner = IOTournament::getInstance()->getHighestWeeklyPlayer();// find the week winner
        if (winner > 0) {
            Player* player = g_game.getPlayerByGuidEx(winner);
            Depot* depot = player->getDepot(0/* townId */, true); // PS transfer to correct depot
            Item* parcel = Item::CreateItem(ITEM_PARCEL_STAMPED);
            Container* receiver = depot;
            
            if (parcel && g_game.internalMoveItem(NULL, parcel->getParent(), depot, INDEX_WHEREEVER, parcel, 1, NULL, FLAG_NOLIMIT) == RET_NOERROR) {
                receiver = parcel->getContainer();
            }
    
            if (receiver) {
                Item* reward = Item::CreateItem(20268);
                char desc[100];
                sprintf(desc, "Tournament Winner of the Week! %s.", player->getName().c_str()); 
                reward->setSpecialDescription(desc);
                
                reward->setExpirationTime(time(NULL) + (7 * 24 * 60 * 60));
                ReturnValue r = g_game.internalMoveItem(NULL, reward->getParent(), receiver, INDEX_WHEREEVER, reward, reward->getItemCount(), NULL, FLAG_NOLIMIT);
                
                if (r != RET_NOERROR && depot) { // If we cant send to the parcel, lets try to send directly into the depot. This problem ocurr when the player doenst open the depot and receive unique items. Unique items cant be added to a container that the player isnt carrying or isnt at the depot.
                    g_game.internalMoveItem(NULL, reward->getParent(), depot, INDEX_WHEREEVER, reward, reward->getItemCount(), NULL, FLAG_NOLIMIT);
                }
            }
            
            player->setStorage(g_config.getNumber(ConfigManager::TOURNAMENT_WEEK_WINNER_STORAGE), "1");
    
    		if (player->isVirtual()) {
    			IOLoginData::getInstance()->savePlayer(player);
    			delete player;
    		}
            
            uint32_t lastWinner = IOTournament::getInstance()->getLastHighestWeeklyPlayer();
            if (lastWinner && lastWinner != winner) {
                Player* lastWinnerPlayer = g_game.getPlayerByGuidEx(lastWinner);
                if (lastWinnerPlayer) {
                    lastWinnerPlayer->setStorage(g_config.getNumber(ConfigManager::TOURNAMENT_WEEK_WINNER_STORAGE), "0");
                    lastWinnerPlayer->doChangeRandomOutfit();
                }
                if (lastWinnerPlayer->isVirtual()) {
    			    IOLoginData::getInstance()->savePlayer(lastWinnerPlayer);
    			    delete lastWinnerPlayer;
    		    }
            }
            // remove the reward from the last winner if diff -- OR use the expiretime to auto destroy it
            // add the reward to the new winner if diff
        }
        
        
        IOTournament::getInstance()->doRegisterWeeklyWinner(winner); // store this information for the website
        IOTournament::getInstance()->doResetWeeklyScore(); // reset week scores
    }
    
    return true;
}

Tournament* Tournaments::getTournament(uint16_t tournamentId)
{
    TournamentsMap::iterator it = tournamentsMap.find(tournamentId);
	if(it != tournamentsMap.end())
		return it->second;

	std::cout << "[Warning - Tournaments::getTournament] Tournament " << tournamentId << " not found." << std::endl;
	return NULL;
}

bool Tournament::getStarted()
{
    return started;
}

