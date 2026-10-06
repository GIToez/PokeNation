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
#include "partyduel.h"

#include "player.h"
#include "chat.h"
#include "game.h"
#include "configmanager.h"
#include "actions.h"
#include "iodatalog.h"

extern Game g_game;
extern Chat g_chat;
extern ConfigManager g_config;
extern Actions* g_actions;

PartyDuel::PartyDuel(Player* _leaderA, uint8_t _maxMembers, uint8_t _maxPokemon, bool _cancelable, TournamentBattle* _tournamentBattle, uint32_t _bet)
{
#ifdef __DEBUG__
    std::cout << "[PartyDuel::Partyduel]Creating object" << std::endl;
#endif
    maxMembers = _maxMembers;
	maxPokemon = _maxPokemon;
	teamAReady = teamBReady = working = ended = betRemoved = false;
	checkOnThinkTimeout = true;
	cancelable = _cancelable;
	startTimer = 3;
	eventStartDuel = eventRemaingTime = 0;
	leaderB = NULL;
	tournamentBattle = _tournamentBattle;
	teamATimeout = teamBTimeout = ((maxMembers >= 2) ? 120 : 60);
	bet = _bet;
    
    if(_leaderA)
	{
		leaderA = _leaderA;
		leaderA->setPartyDuel(this);
		leaderA->sendTextMessage(MSG_INFO_DESCR, "Your party duel has been created.");
		updateIcons(leaderA);
		memberListA.push_back(leaderA);
		userList.push_back(leaderA);
		checkReady();
	}
	else
	    leaderA = NULL;
}

void PartyDuel::disband(EndMode endMode, Player* violator)
{
#ifdef __DEBUG__
    std::cout << "[PartyDuel::disband]leaderA: " << leaderA->getName() << ", leaderB: " << leaderB->getName() << ", endMode: " << endMode << std::endl;
#endif
    working = false;
    
    if(endMode == END_PLAYERWITHOUTBALL)
    {
	    broadcastMessage(MSG_INFO_DESCR, "The duel can't start if any of the duelists were without a pokemon ball in the ball slot! Duel canceled!");
	    if(tournamentBattle && violator)
	        tournamentBattle->onPlayerLeave(violator);
    }
    
    else if (endMode == END_PLAYERWITHOUTMONEY) {
        broadcastMessage(MSG_INFO_DESCR, "The duel can't start if any of the duelists were without enough money to bet! Duel canceled!");
	    if (tournamentBattle && violator) {
	        tournamentBattle->onPlayerLeave(violator);
        }
    }
    
    else if(endMode == END_TEAMA_WIN)
    {
        for (PlayerVector::iterator it = memberListA.begin(); it != memberListA.end(); ++it) {
            (*it)->addSkillAdvance(SKILL_FIST, (uint32_t)((*it)->getVocation()->getReqSkillTries(SKILL_FIST, (*it)->getSkill(SKILL_FIST,
			    SKILL_LEVEL) + 1) - (*it)->getSkill(SKILL_FIST, SKILL_TRIES)), false);
			g_game.playerAddStatistic(*it, DEFEAT_PLAYER, 1);
			
			if (bet > 0) {
                payBet(*it, (bet * 2));
            }
        }
        
        broadcastMessage(MSG_INFO_DESCR, "Team A win!");
        broadcastAnimatedText(TEXTCOLOR_LIGHTGREEN, "WIN", TEAM_A);
		
		for(PlayerVector::iterator it = memberListB.begin(); it != memberListB.end(); ++it)
            (*it)->addSkillAdvance(SKILL_CLUB, (uint32_t)((*it)->getVocation()->getReqSkillTries(SKILL_CLUB, (*it)->getSkill(SKILL_CLUB,
			SKILL_LEVEL) + 1) - (*it)->getSkill(SKILL_CLUB, SKILL_TRIES)), false);
        
        broadcastMessage(MSG_INFO_DESCR, "Team B loss!");
        broadcastAnimatedText(TEXTCOLOR_RED, "LOSS", TEAM_B);
        
        if(tournamentBattle)
            tournamentBattle->onEnd(leaderA);
    }
    
    else if(endMode == END_TEAMB_WIN)
    {
        for (PlayerVector::iterator it = memberListB.begin(); it != memberListB.end(); ++it) {
            (*it)->addSkillAdvance(SKILL_FIST, (uint32_t)((*it)->getVocation()->getReqSkillTries(SKILL_FIST, (*it)->getSkill(SKILL_FIST,
			    SKILL_LEVEL) + 1) - (*it)->getSkill(SKILL_FIST, SKILL_TRIES)), false);
			g_game.playerAddStatistic(*it, DEFEAT_PLAYER, 1);
			
		    if (bet > 0) {
                payBet(*it, (bet * 2));
            }
        }
        
        broadcastMessage(MSG_INFO_DESCR, "Team B win!");
        broadcastAnimatedText(TEXTCOLOR_LIGHTGREEN, "WIN", TEAM_B);
		
		for(PlayerVector::iterator it = memberListA.begin(); it != memberListA.end(); ++it)
            (*it)->addSkillAdvance(SKILL_CLUB, (uint32_t)((*it)->getVocation()->getReqSkillTries(SKILL_CLUB, (*it)->getSkill(SKILL_CLUB,
			SKILL_LEVEL) + 1) - (*it)->getSkill(SKILL_CLUB, SKILL_TRIES)), false);
        
        broadcastMessage(MSG_INFO_DESCR, "Team A loss!");
        broadcastAnimatedText(TEXTCOLOR_RED, "LOSS", TEAM_A);
        
        if(tournamentBattle)
            tournamentBattle->onEnd(leaderB);
    }
    
    else if(endMode == END_TIMEOUT)
    {
        for (PlayerVector::iterator it = memberListA.begin(); it != memberListA.end(); ++it) {
            (*it)->addSkillAdvance(SKILL_CLUB, (uint32_t)((*it)->getVocation()->getReqSkillTries(SKILL_CLUB, (*it)->getSkill(SKILL_CLUB,
			    SKILL_LEVEL) + 1) - (*it)->getSkill(SKILL_CLUB, SKILL_TRIES)), false);
			    
            if (bet > 0) {
                payBet(*it, bet); // Give back
            }
        }
			
		for (PlayerVector::iterator it = memberListB.begin(); it != memberListB.end(); ++it) {
            (*it)->addSkillAdvance(SKILL_CLUB, (uint32_t)((*it)->getVocation()->getReqSkillTries(SKILL_CLUB, (*it)->getSkill(SKILL_CLUB,
			    SKILL_LEVEL) + 1) - (*it)->getSkill(SKILL_CLUB, SKILL_TRIES)), false);
			    
            if (bet > 0) {
                payBet(*it, bet); // Give back
            }
        }
			
		broadcastMessage(MSG_INFO_DESCR, "Duel timeout!");
        broadcastAnimatedText(TEXTCOLOR_RED, "LOSS", TEAM_A);
        broadcastAnimatedText(TEXTCOLOR_RED, "LOSS", TEAM_B);
        
        if(tournamentBattle)
	        tournamentBattle->onPlayerLeave(violator);
    }
    
    else if (endMode == END_DEFAULT && bet > 0) {
         for (PlayerVector::iterator it = userList.begin(); it != userList.end(); ++it) {
             payBet(*it, bet); // Give back when someone logout
	    }
    }

	for(PlayerVector::iterator it = inviteListA.begin(); it != inviteListA.end(); ++it)
		(*it)->removePartyDuelInvitation(this);
	inviteListA.clear();
	
	for(PlayerVector::iterator it = inviteListB.begin(); it != inviteListB.end(); ++it)
		(*it)->removePartyDuelInvitation(this);
	inviteListB.clear();
		
	updateAllIcons(true);

	for(PlayerVector::iterator it = userList.begin(); it != userList.end(); ++it)
	{
		(*it)->setPartyDuel(NULL);
		(*it)->setDueling(false);
		(*it)->setDuelPokemonRemaing(0);
		(*it)->setNoMove(false);
		(*it)->sendTextMessage(MSG_INFO_DESCR, "Your party duel has been disbanded.");
	}

	stopEvents();
    memberListA.clear();
	memberListB.clear();
	userList.clear();
	statusMapA.clear();
	statusMapB.clear();
	leaderA = NULL;
	leaderB = NULL;
	ended = true;
}

bool PartyDuel::leave(Player* player)
{
#ifdef __DEBUG__
    std::cout << "[PartyDuel::leave]player: " << player->getName() << std::endl;
#endif	
    if(!isPlayerUser(player))
		return false;
	
	disband();
	return true;
}

bool PartyDuel::join(Player* player, Team team)
{   
#ifdef __DEBUG__
    std::cout << "[PartyDuel::join]player: " << player->getName() << ", team: " << team << std::endl;
#endif
    if(isPlayerUser(player) || !isPlayerInvited(player, false, team))
		return false;
    
    if((uint8_t)(6 - floor(player->getFreeCapacity())) < maxPokemon)
    {
        player->sendTextMessage(MSG_INFO_DESCR, "You don't have the minimum required pokemon number to join this duel.");
        return false;
    }
    
    if(!leaderB)
	{
		if(team == TEAM_A)
		{
			PlayerVector::iterator it = std::find(inviteListA.begin(), inviteListA.end(), player);
			if(it != inviteListA.end())
				inviteListA.erase(it);
		}
		else // TEAM_B
		{
			PlayerVector::iterator it = std::find(inviteListB.begin(), inviteListB.end(), player);
			if(it != inviteListB.end())
				inviteListB.erase(it);
		}
        
        leaderB = player;
		memberListB.push_back(leaderB);
		userList.push_back(player);
		player->setPartyDuel(this);
		player->removePartyDuelInvitation(this);
		
		char buffer[200];
	    sprintf(buffer, "%s has joined to the team B.", player->getName().c_str());
	    broadcastMessage(MSG_INFO_DESCR, buffer);
		
		updateIcons(player);
		checkReady();
        return true;
	}
	
	Player* leader = NULL;
	if(team == TEAM_A)
	{
		if(memberListA.size() >= maxMembers)
        {
            player->sendTextMessage(MSG_INFO_DESCR, "Team A is full.");
            return false;
        }
        
        memberListA.push_back(player);
		
		PlayerVector::iterator it = std::find(inviteListA.begin(), inviteListA.end(), player);
		if(it != inviteListA.end())
			inviteListA.erase(it);
			
		leader = leaderA;
		
		char buffer[200];
	    sprintf(buffer, "%s has joined to the team A.", player->getName().c_str());
	    broadcastMessage(MSG_INFO_DESCR, buffer);
	}
	else // TEAM_B
	{
		if(memberListB.size() >= maxMembers)
        {
            player->sendTextMessage(MSG_INFO_DESCR, "Team B is full.");
            return false;
        }
        
        memberListB.push_back(player);
		
		PlayerVector::iterator it = std::find(inviteListB.begin(), inviteListB.end(), player);
		if(it != inviteListB.end())
			inviteListB.erase(it);
			
		leader = leaderB;
		
		char buffer[200];
	    sprintf(buffer, "%s has joined to the team B.", player->getName().c_str());
	    broadcastMessage(MSG_INFO_DESCR, buffer);
	}
		
	userList.push_back(player);
	
	player->setPartyDuel(this);
	player->removePartyDuelInvitation(this);
	
	char buffer[200];
    sprintf(buffer, "You have joined %s'%s party duel.", leader->getName().c_str(), (leader->getName()[leader->getName().length() - 1] == 's' ? "" : "s"));
    player->sendTextMessage(MSG_INFO_DESCR, buffer);

    updateIcons(player);
    checkReady();
	return true;
}

bool PartyDuel::removeInvite(Player* player, Team team/* = TEAM_NONE*/)
{
#ifdef __DEBUG__
    std::cout << "[PartyDuel::removeInvite]player: " << player->getName() << ", team: " << team << std::endl;
#endif
    if(!isPlayerInvited(player, false, team))
		return false;

    if(team == TEAM_A)
	{
		PlayerVector::iterator it = std::find(inviteListA.begin(), inviteListA.end(), player);
		if(it != inviteListA.end())
			inviteListA.erase(it);
    }
	else if(team == TEAM_B)
	{
		PlayerVector::iterator it = std::find(inviteListB.begin(), inviteListB.end(), player);
		if(it != inviteListB.end())
			inviteListB.erase(it);
	}
	else
	{
        PlayerVector::iterator itA = std::find(inviteListA.begin(), inviteListA.end(), player);
		if(itA != inviteListA.end())
			inviteListA.erase(itA);
			
		PlayerVector::iterator itB = std::find(inviteListB.begin(), inviteListB.end(), player);
		if(itB != inviteListB.end())
			inviteListB.erase(itB);
    }

	player->removePartyDuelInvitation(this);
	return true;
}

void PartyDuel::revokeInvitation(Player* player, Team team)
{
#ifdef __DEBUG__
    std::cout << "[PartyDuel::revokeInvitation]player: " << player->getName() << ", team: " << team << std::endl;
#endif
    if(!player || player->isRemoved())
		return;

	Player* leader = NULL;
	if(team == TEAM_A)
		leader = leaderA;
	else // TEAM_B
		leader = leaderB;
	
	char buffer[150];
	sprintf(buffer, "%s has revoked %s party duel invitation.", leader->getName().c_str(), (leader->getSex(false) ? "his" : "her"));
	player->sendTextMessage(MSG_INFO_DESCR, buffer);

	sprintf(buffer, "Invitation for %s party duel has been revoked.", player->getName().c_str());
	leader->sendTextMessage(MSG_INFO_DESCR, buffer);
	removeInvite(player, team);
}

bool PartyDuel::invitePlayer(Player* player, Team team)
{
#ifdef __DEBUG__
    std::cout << "[PartyDuel::invitePlayer]player: " << player->getName() << ", team: " << team << std::endl;
#endif
    if(isPlayerInvited(player, true, team))
		return false;
		
	if(team == TEAM_A)
	{
		if(leaderB)
		{
			if(memberListA.size() >= maxMembers)
			{
				leaderA->sendTextMessage(MSG_INFO_DESCR, "You can't invite more partners.");
				return false;
			}
		}
		else
		{
			if(inviteListA.size() > 0)
			{
				leaderA->sendTextMessage(MSG_INFO_DESCR, "Before add your partners you need wait your opponent accept your duel.");
				return false;
			}
		}

		inviteListA.push_back(player);
		player->addPartyDuelInvitation(this);

		char buffer[150];
		sprintf(buffer, "%s has been invited.", player->getName().c_str());
		leaderA->sendTextMessage(MSG_INFO_DESCR, buffer);

		sprintf(buffer, "%s has invited you to %s party duel.\n[Pokemon: %i x %i][Player: %i x %i][Bet: $%i]", leaderA->getName().c_str(), (leaderA->getSex(false) ? "his" : "her"), maxPokemon, maxPokemon, maxMembers, maxMembers, bet);
		player->sendTextMessage(MSG_INFO_DESCR, buffer);
	}
	else // TEAM_B
	{
		if(leaderA)
		{
			if(memberListB.size() >= maxMembers)
			{
				leaderB->sendTextMessage(MSG_INFO_DESCR, "You can't invite more partners.");
				return false;
			}
		}
		else
		{
			if(inviteListB.size() > 0)
			{
				leaderB->sendTextMessage(MSG_INFO_DESCR, "Before add your partners you need wait your opponent accept your duel.");
				return false;
			}
		}

		inviteListB.push_back(player);
		player->addPartyDuelInvitation(this);

		char buffer[150];
		sprintf(buffer, "%s has been invited.", player->getName().c_str());
		leaderB->sendTextMessage(MSG_INFO_DESCR, buffer);

		sprintf(buffer, "%s has invited you to %s party duel.\n[Pokemon: %i x %i][Player: %i x %i][Bet: $%i]", leaderB->getName().c_str(), (leaderB->getSex(false) ? "his" : "her"), maxPokemon, maxPokemon, maxMembers, maxMembers, bet);
		player->sendTextMessage(MSG_INFO_DESCR, buffer);
	}
	
	if (bet > 0) {
        player->sendFYIBox("WARNING! You're invited to a duel with financial bet! Pay attention to the value before accepting the invitation!");
    }
	
	return true;
}

void PartyDuel::updateIcons(Player* player, bool end)
{
#ifdef __DEBUG__
    std::cout << "[PartyDuel::updateIcons]player: " << player->getName() << ", end: " << end << std::endl;
#endif
    if(!player || player->isRemoved())
		return;

    player->setSkull((end ? SKULL_NONE : SKULL_WHITE));
    g_game.updateCreatureSkull(player);
}

void PartyDuel::updateAllIcons(bool end)
{
#ifdef __DEBUG__
    std::cout << "[PartyDuel::updateAllIcons]end: " << end << std::endl;
#endif
    for(PlayerVector::iterator it = userList.begin(); it != userList.end(); ++it)
	{
        (*it)->setSkull((end ? SKULL_NONE : SKULL_WHITE));
		g_game.updateCreatureSkull(*it);
    }
}

void PartyDuel::broadcastMessage(MessageClasses messageClass, const std::string& text, bool sendToInvitations/* = false*/)
{
#ifdef __DEBUG__
    std::cout << "[PartyDuel::broadcastMessage]messageClass: " << messageClass << ", text: " << text << ", sendToInvitations: " << sendToInvitations << std::endl;
#endif
    PlayerVector::iterator it;
	if(!userList.empty())
	{
		for(it = userList.begin(); it != userList.end(); ++it)
			(*it)->sendTextMessage(messageClass, text);
	}
	    
	if(!sendToInvitations || inviteListA.empty() || inviteListB.empty())
		return;

	for(it = inviteListA.begin(); it != inviteListA.end(); ++it)
		(*it)->sendTextMessage(messageClass, text);
		
	for(it = inviteListB.begin(); it != inviteListB.end(); ++it)
		(*it)->sendTextMessage(messageClass, text);
}

bool PartyDuel::isPlayerMember(const Player* player, bool result/* = false*/, Team team/* = TEAM_NONE*/) const
{
#ifdef __DEBUG__
    std::cout << "[PartyDuel::isPlayerMember]player: " << player->getName() << ", result: " << result << ", team: " << team << std::endl;
#endif
    if(!player || player->isRemoved())
		return result;
		
	if(team == TEAM_A)
		return std::find(memberListA.begin(), memberListA.end(), player) != memberListA.end();
		
	if(team == TEAM_B)
		return std::find(memberListB.begin(), memberListB.end(), player) != memberListB.end();

	return std::find(memberListA.begin(), memberListA.end(), player) != memberListA.end() ||
		   std::find(memberListB.begin(), memberListB.end(), player) != memberListB.end();
}

bool PartyDuel::isPlayerInvited(const Player* player, bool result/* = false*/, Team team/* = TEAM_NONE*/) const
{
#ifdef __DEBUG__
    std::cout << "[PartyDuel::isPlayerInvited]player: " << player->getName() << ", result: " << result << ", team: " << team << std::endl;
#endif
    if(!player || player->isRemoved())
		return result;
		
	if(team == TEAM_A)
		return std::find(inviteListA.begin(), inviteListA.end(), player) != inviteListA.end();
		
	if(team == TEAM_B)
		return std::find(inviteListB.begin(), inviteListB.end(), player) != inviteListB.end();

	return std::find(inviteListA.begin(), inviteListA.end(), player) != inviteListA.end() ||
		   std::find(inviteListB.begin(), inviteListB.end(), player) != inviteListB.end();
}

bool PartyDuel::isPlayerUser(const Player* player, bool result/* = false*/) const
{
#ifdef __DEBUG__
    std::cout << "[PartyDuel::isPlayerUser]player: " << player->getName() << ", result: " << result << std::endl;
#endif
    if(!player || player->isRemoved())
		return result;

	return std::find(userList.begin(), userList.end(), player) != userList.end();
}

void PartyDuel::checkReady()
{
#ifdef __DEBUG__
    std::cout << "[PartyDuel::checkReady]" << std::endl;
#endif
    if(!teamAReady)
	{
        if(memberListA.size() >= maxMembers)
		{
			teamAReady = true;
			broadcastMessage(MSG_INFO_DESCR, "Team A is ready!", true);	
		}
	}
	
	if(!teamBReady)
	{
        if(memberListB.size() >= maxMembers)
		{
			teamBReady = true;
			broadcastMessage(MSG_INFO_DESCR, "Team B is ready!", true);	
		}
	}	
	
	if(teamAReady && teamBReady) {
		prepareStartDuel();
	}
}

void PartyDuel::prepareStartDuel()
{
#ifdef __DEBUG__
    std::cout << "[PartyDuel::prepareStartDuel]" << std::endl;
#endif
    if(startTimer > 0)
    {
        char secBuffer[10];
        sprintf(secBuffer, "%i", startTimer);
        
        char messageBuffer[50];
        sprintf(messageBuffer, "The duel will start in %i second%s!", startTimer, (startTimer > 1 ? "s" : ""));
        
        broadcastMessage(MSG_INFO_DESCR, messageBuffer);
        broadcastAnimatedText(TEXTCOLOR_LIGHTGREEN, secBuffer);        
	    
	    eventStartDuel = Scheduler::getInstance().addEvent(createSchedulerTask(1000, boost::bind(&PartyDuel::prepareStartDuel, this)));
	    startTimer--;
    }
    else
        startDuel();
}

void PartyDuel::startDuel()
{
#ifdef __DEBUG__
    std::cout << "[PartyDuel::startDuel]" << std::endl;
#endif
    eventStartDuel = 0;
    
    if(!userList.empty())
    {
        for(PlayerVector::iterator it = userList.begin(); it != userList.end(); ++it)
	    {
		    (*it)->setDueling(true); // This need be here to script work on use action
		    (*it)->setDuelPokemonRemaing(maxPokemon);
	    }
        
        for(PlayerVector::iterator it = userList.begin(); it != userList.end(); ++it)
        {
            if (bet > 0 && g_game.getMoney(*it) < bet) {
                disband(END_PLAYERWITHOUTMONEY, (*it));
                return;
            }
            
            if((*it)->getSummonCount() == 0)
            {
                if(Item* item = (*it)->getInventoryItem(SLOT_FEET))
                {
                    if(g_actions->useItem(*it, (*it)->getPosition(), 0, item, true))
                    {
                        if((*it)->getSummonCount() > 0)
                        {
                            (*it)->setNoMove(true);
                        }
                        else
                        {
                            disband(END_PLAYERWITHOUTBALL, (*it));
                            return;
                        }
                    }
                    else
                    {
                        disband(END_PLAYERWITHOUTBALL, (*it));
                        return;
                    }
               }
               else
               {
                   disband(END_PLAYERWITHOUTBALL, (*it));
                   return;
               }
			}   
			else
			{
				disband(END_PLAYERWITHOUTBALL, (*it));
				return;
			}
        }
   	}
    
    statusMapA.clear();
    for(PlayerVector::iterator it = memberListA.begin(); it!= memberListA.end(); ++it)
        statusMapA[*it] = true;
		
	statusMapB.clear();
    for(PlayerVector::iterator it = memberListB.begin(); it!= memberListB.end(); ++it)
        statusMapB[*it] = true;
        
    for (PlayerVector::iterator it = userList.begin(); it != userList.end(); ++it) {
        if (bet > 0) {
            if (!g_game.removeMoney(*it, bet)) {
                std::cout << "[ERROR]PartyDuel::startDuel - Can not remove money from player: " << (*it)->getName() << ", value: " << bet << std::endl;
                disband(END_PLAYERWITHOUTMONEY, (*it));
                return;
            }
        }
    }
    setBetRemoved(true);
        
    /*    
    SpectatorVec pokemonA;
    for(PlayerVector::iterator it = memberListA.begin(); it != memberListA.end(); ++it) {
        if (Monster* tmpMonster = (*it)->getFirstSummon()) {
            pokemonA.push_back(tmpMonster);
        }
    }
    
    SpectatorVec pokemonB;
    for(PlayerVector::iterator it = memberListB.begin(); it != memberListB.end(); ++it) {
        if (Monster* tmpMonster = (*it)->getFirstSummon()) {
            pokemonB.push_back(tmpMonster);
        }
    }
    
    for(PlayerVector::iterator it = memberListA.begin(); it != memberListA.end(); ++it) {
        for(SpectatorVec::iterator cit = pokemonA.begin(); cit != pokemonA.end(); ++cit) {
            (*it)->sendCreatureSkull((*cit), SKULL_WHITE);
        }
    }

    
    for(PlayerVector::iterator it = memberListB.begin(); it != memberListB.end(); ++it) {
        for(SpectatorVec::iterator cit = pokemonB.begin(); cit != pokemonB.end(); ++cit) {
            (*it)->sendCreatureSkull((*cit), SKULL_WHITE);
        }
    }
    */
        
    broadcastMessage(MSG_INFO_DESCR, "The duel has begun!");
    broadcastAnimatedText(TEXTCOLOR_RED, "GO!");
    working = true;
}

void PartyDuel::broadcastAnimatedText(uint8_t textColor, const std::string& text,  Team team/* = TEAM_NONE*/)
{
#ifdef __DEBUG__
    std::cout << "[PartyDuel::broadcastAnimatedText]textColor: " << textColor << ", text: " << text << ", team: " << team << std::endl;
#endif
    if(team == TEAM_NONE)
	{	
		if(!userList.empty())
		{
			for(PlayerVector::iterator it = userList.begin(); it != userList.end(); ++it)
				g_game.addAnimatedText((*it)->getPosition(), textColor, text);
		}
	}
	else if(team == TEAM_A)
	{
		if(!memberListA.empty())
		{
			for(PlayerVector::iterator it = memberListA.begin(); it != memberListA.end(); ++it)
				g_game.addAnimatedText((*it)->getPosition(), textColor, text);
		}
	}
	else // TEAM_B
	{
		if(!memberListB.empty())
		{
			for(PlayerVector::iterator it = memberListB.begin(); it != memberListB.end(); ++it)
				g_game.addAnimatedText((*it)->getPosition(), textColor, text);
		}
	}
}

bool PartyDuel::onPlayerLost(Player* player) // When the player pokemon remaing number equal to 0
{
#ifdef __DEBUG__
    std::cout << "[PartyDuel::onPlayerLost]player: " << player->getName() << std::endl;
#endif
    if (!working) { // This duel already ended, if we dont stop here, a crash possibly will ocurr
        return false;
    }
    
    Team team = getPlayerTeam(player);
	if(team == TEAM_A)
	{
		PlayerStatusMap::iterator it = statusMapA.find(player);
		if(it != statusMapA.end())
			it->second = false;
	}
	else // TEAM_B
	{
		PlayerStatusMap::iterator it = statusMapB.find(player);
		if(it != statusMapB.end())
			it->second = false;
	}
	
	char buffer[105];
	sprintf(buffer, "%s was defeated.", player->getName().c_str());
	broadcastMessage(MSG_INFO_DESCR, buffer);
	g_game.addAnimatedText(player->getPosition(), TEXTCOLOR_DARKBROWN, "DOWN!");
    
    return checkBattle();
}

bool PartyDuel::checkBattle()
{
#ifdef __DEBUG__
    std::cout << "[PartyDuel::checkBattle]" << std::endl;
#endif
    if (!working) { // This duel already ended, if we dont stop here, a crash possibly will ocurr
        return false;
    }
    
    bool lostA = true;	
    for(PlayerStatusMap::iterator it = statusMapA.begin(); it != statusMapA.end(); ++it)
    {
        if(it->second)
        {
            lostA = false;
            break;
        }
    }
	if(lostA)
	{
		disband(END_TEAMB_WIN);
		return true;
    }
	
	bool lostB = true;	
    for(PlayerStatusMap::iterator it = statusMapB.begin(); it != statusMapB.end(); ++it)
    {
        if(it->second)
        {
            lostB = false;
            break;
        }
    }
	if(lostB)
	{
		disband(END_TEAMA_WIN);
		return true;
    }
    
    return false;
}

Team PartyDuel::getPlayerTeam(Player* player)
{
#ifdef __DEBUG__
    std::cout << "[PartyDuel::getPlayerTeam]player: " << player->getName() << std::endl;
#endif
    if(std::find(memberListA.begin(), memberListA.end(), player) != memberListA.end())
		return TEAM_A;
	if(std::find(memberListB.begin(), memberListB.end(), player) != memberListB.end())
		return TEAM_B;
	return TEAM_NONE;
}

Team PartyDuel::getPlayerTeam(const Player* _player)
{
#ifdef __DEBUG__
    std::cout << "[PartyDuel::getPlayerTeam]player: " << player->getName() << std::endl;
#endif
    if(Player* player = const_cast<Player*>(_player))
	{    
        if(std::find(memberListA.begin(), memberListA.end(), player) != memberListA.end())
		    return TEAM_A;
	    if(std::find(memberListB.begin(), memberListB.end(), player) != memberListB.end())
		    return TEAM_B;
    }
	return TEAM_NONE;
}

void PartyDuel::stopEvents()
{
#ifdef __DEBUG__
    std::cout << "[PartyDuel::stopEvents]" << player->getName() << std::endl;
#endif
    if(eventStartDuel || eventStartDuel > 0)
    {
        Scheduler::getInstance().stopEvent(eventStartDuel);
	    eventStartDuel = 0;
    }
    
    if(eventRemaingTime || eventRemaingTime > 0)
    {
        Scheduler::getInstance().stopEvent(eventRemaingTime);
        eventRemaingTime = 0;
    }
}

void PartyDuel::startBattleTimer(uint32_t time)
{
#ifdef __DEBUG__
    std::cout << "[PartyDuel::startBattleTimer]time: " << time << std::endl;
#endif
     if(time > 0)
         eventRemaingTime = Scheduler::getInstance().addEvent(createSchedulerTask(time * 1000, boost::bind(&PartyDuel::doBattleTimer, this)));
}

void PartyDuel::doBattleTimer()
{
#ifdef __DEBUG__
    std::cout << "[PartyDuel::doBattleTimer]" << std::endl;
#endif
    disband(END_TIMEOUT);
}

PlayerVector PartyDuel::getPartners(Player* player)
{
    if (getPlayerTeam(player) == TEAM_A) {
        return memberListA;
    } else {    
        return memberListB;
    }
}

void PartyDuel::onThink()
{        
    if (!working) {
        return;
    }
    
    checkOnThinkTimeout = !checkOnThinkTimeout; // onThink interval is 0.5 seconds, we cant decrease timeout so fast
    if (checkOnThinkTimeout) {    
		bool decreaseA = true;
		for(PlayerVector::iterator it = memberListA.begin(); it != memberListA.end(); ++it) {
			if ((*it)->getSummonCount() > 0) {
				decreaseA = false;
				break;
			}
		}
		
		if (decreaseA) {
			if (teamATimeout > 0) {        
				char buffer[5];
				sprintf(buffer, "%d", teamATimeout); 
				broadcastAnimatedText(TEXTCOLOR_RED, buffer,  TEAM_A);
				teamATimeout--;
			}
            else {
				disband(END_TEAMB_WIN);
				return;
			}
		}
		
		
		bool decreaseB = true;
		for(PlayerVector::iterator it = memberListB.begin(); it != memberListB.end(); ++it) {
			if ((*it)->getSummonCount() > 0) {
				decreaseB = false;
				break;
			}
		}
		
		if (decreaseB) {
			if (teamBTimeout > 0) {        
				char buffer[5];
				sprintf(buffer, "%d", teamBTimeout); 
				broadcastAnimatedText(TEXTCOLOR_RED, buffer,  TEAM_B);
				teamBTimeout--;
			}
            else {
				disband(END_TEAMA_WIN);
				return;
			}
		}
    }

    if (maxMembers > 1) { // Only show if the duel has more then 1 member (2x2, 3x3, etc.)
        SpectatorVec pokemonA;
        for(PlayerVector::iterator it = memberListA.begin(); it != memberListA.end(); ++it) {
                if (Creature* summon = (*it)->getFirstSummon()) {
                pokemonA.push_back(summon);
            }
        }
    
        SpectatorVec pokemonB;
        for(PlayerVector::iterator it = memberListB.begin(); it != memberListB.end(); ++it) {
            if (Creature* summon = (*it)->getFirstSummon()) {
                pokemonB.push_back(summon);
            }
        }
    
        for(PlayerVector::iterator it = memberListA.begin(); it != memberListA.end(); ++it) {
            for(SpectatorVec::iterator cit = pokemonA.begin(); cit != pokemonA.end(); ++cit) {
                (*it)->sendCreatureSquare((*cit), (SquareColor_t)TEXTCOLOR_BLUE);
            }
            //for(SpectatorVec::iterator cit = pokemonB.begin(); cit != pokemonB.end(); ++cit) {
            //    (*it)->sendCreatureSquare((*cit), (SquareColor_t)TEXTCOLOR_RED);
            //}
        }

        for(PlayerVector::iterator it = memberListB.begin(); it != memberListB.end(); ++it) {
            for(SpectatorVec::iterator cit = pokemonB.begin(); cit != pokemonB.end(); ++cit) {
                (*it)->sendCreatureSquare((*cit), (SquareColor_t)TEXTCOLOR_BLUE);
            }
            //for(SpectatorVec::iterator cit = pokemonA.begin(); cit != pokemonA.end(); ++cit) {
            //    (*it)->sendCreatureSquare((*cit), (SquareColor_t)TEXTCOLOR_RED);
            //}
        }
    }
}

bool PartyDuel::getEnded() const
{
    return ended;
}

void PartyDuel::payBet(Player* player, uint32_t value)
{
    if (!getBetRemoved()) { // If the players didnt pay the bet already. This occur when the duel get canceled before it starts.
        return;
    }
    
    g_game.addMoney(player, value);
    
    char buffer[200];
    sprintf(buffer, "You received %i dollars.", value);
    player->sendTextMessage(MSG_INFO_DESCR, buffer);
    IODatalog::getInstance()->logDuelBet(leaderA->getGUID(), leaderB->getGUID(), player->getGUID(), value, time(NULL));
}

bool PartyDuel::getBetRemoved() const
{
    return betRemoved;
}

void PartyDuel::setBetRemoved(bool value)
{
    betRemoved = value;
}

