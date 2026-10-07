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
#include "pvparena.h"

#include "player.h"
#include "game.h"
#include "chat.h"

extern Game g_game;
extern Chat g_chat;

PvpArena::PvpArena(uint8_t _id, const Position& _blueSpawn, const Position& _redSpawn, const Position& _exit, uint32_t _maxLevel, uint16_t _blueChannel, uint16_t _redChannel)
{
#ifdef __DEBUG__
    std::cout << "[PvpArena::PvpArena]Creating object" << std::endl;
#endif
    id = _id;
    blueSpawn = _blueSpawn;
    redSpawn = _redSpawn;
    exit = _exit;
    maxLevel = _maxLevel;
    blueChannel = _blueChannel;
    redChannel = _redChannel;
    
	blueOutfit.lookFeet = 87;
	blueOutfit.lookLegs = 87;
	blueOutfit.lookBody = 87;
	blueOutfit.lookHead = 87;
	blueOutfit.lookType = 514;
    
	redOutfit.lookFeet = 94;
	redOutfit.lookLegs = 94;
	redOutfit.lookBody = 94;
	redOutfit.lookHead = 94;
	redOutfit.lookType = 514;
}

PvpArena::~PvpArena()
{
#ifdef __DEBUG__
    std::cout << "[PvpArena::PvpArena]Destroying object" << std::endl;
#endif
    memberListBlue.clear();
    memberListRed.clear();
    userList.clear();
}

bool PvpArena::leave(Player* player, bool teleport)
{
#ifdef __DEBUG__
    std::cout << "[PvpArena::leave]player: " << player->getName() << ", teleport: " << teleport << std::endl;
#endif
    if(!player || player->isRemoved() || !isPlayerUser(player))
	    return false;
	
	char buffer[200];
    if(getPlayerTeam(player) == PVPTEAM_BLUE)
	{
        PlayerVector::iterator it = std::find(memberListBlue.begin(), memberListBlue.end(), player);
	    if(it != memberListBlue.end())
		    memberListBlue.erase(it);
	    
	    sprintf(buffer, "PvP Arena: %s left the blue team.", player->getName().c_str());
	    g_chat.removeUserFromChannel(player, blueChannel);
    }
    else // PVPTEAM_RED
    {
        PlayerVector::iterator it = std::find(memberListRed.begin(), memberListRed.end(), player);
	    if(it != memberListRed.end())
		    memberListRed.erase(it);
		    
	    sprintf(buffer, "PvP Arena: %s left the red team.", player->getName().c_str());
	    g_chat.removeUserFromChannel(player, redChannel);
    }
    
    broadcastMessage(MSG_EVENT_DEFAULT, buffer);
    
    PlayerVector::iterator it = std::find(userList.begin(), userList.end(), player);
    if(it != userList.end())
        userList.erase(it);
    
	player->setPvpArena(NULL);
	player->setPvpArenaTeam(PVPTEAM_NONE);
	player->removeCondition(CONDITION_OUTFIT);
	if(teleport)
		g_game.internalTeleport(player, exit, false);
	return true;
}

bool PvpArena::join(Player* player, pvpArenaTeam_t team)
{   
#ifdef __DEBUG__
    std::cout << "[PvpArena::join]player: " << player->getName() << ", team: " << team << std::endl;
#endif
    if(isPlayerUser(player) || (maxLevel && player->getLevel() > maxLevel))
		return false;
    
    char buffer[200];
    if(team == PVPTEAM_BLUE)
    {
        if (g_game.internalTeleport(player, blueSpawn, false) == RET_NOERROR) {
	        player->setPvpArenaTeam(PVPTEAM_BLUE);
	        sprintf(buffer, "PvP Arena: %s joined the blue team.", player->getName().c_str());
	        memberListBlue.push_back(player);
	        if(ConditionOutfit* outfit = new ConditionOutfit(CONDITIONID_COMBAT, CONDITION_OUTFIT, -1, false, 0))
	        {
                outfit->addOutfit(blueOutfit);
                player->addCondition(outfit);
            }
            g_chat.addUserToChannel(player, blueChannel, true);
            player->sendChannel(blueChannel, "PvP Arena - Blue Team");
        }
    }
    else
    {
        if (g_game.internalTeleport(player, redSpawn, false) == RET_NOERROR) {
	        player->setPvpArenaTeam(PVPTEAM_RED);
	        sprintf(buffer, "PvP Arena: %s joined the red team.", player->getName().c_str());
	        memberListRed.push_back(player);
	        if(ConditionOutfit* outfit = new ConditionOutfit(CONDITIONID_COMBAT, CONDITION_OUTFIT, -1, false, 0))
	        {
                outfit->addOutfit(redOutfit);
                player->addCondition(outfit);
            }
            g_chat.addUserToChannel(player, redChannel, true);
            player->sendChannel(redChannel, "PvP Arena - Red Team");
        }
    }
    
    player->setPvpArena(this);
    broadcastMessage(MSG_EVENT_DEFAULT, buffer);
    userList.push_back(player);

	return true;
}

void PvpArena::broadcastMessage(MessageClasses messageClass, const std::string& text)
{
#ifdef __DEBUG__
    std::cout << "[PvpArena::broadcastMessage]messageClass: " << player->getName() << ", text: " << text << std::endl;
#endif
	PlayerVector::iterator it;
	if(!userList.empty())
	{
		for(it = userList.begin(); it != userList.end(); ++it)
			(*it)->sendTextMessage(messageClass, text);
	}
}

bool PvpArena::isPlayerMember(const Player* player, pvpArenaTeam_t team/* = PVPTEAM_NONE*/) const
{
#ifdef __DEBUG__
    std::cout << "[PvpArena::isPlayerMember]player: " << player->getName() << ", team: " << team << std::endl;
#endif
    if(!player || player->isRemoved())
		return false;
		
	if(team == PVPTEAM_BLUE)
		return std::find(memberListBlue.begin(), memberListBlue.end(), player) != memberListBlue.end();
		
	if(team == PVPTEAM_RED)
		return std::find(memberListRed.begin(), memberListRed.end(), player) != memberListRed.end();

	return std::find(memberListBlue.begin(), memberListBlue.end(), player) != memberListBlue.end() ||
		   std::find(memberListRed.begin(), memberListRed.end(), player) != memberListBlue.end();
}

bool PvpArena::isPlayerUser(const Player* player) const
{
#ifdef __DEBUG__
    std::cout << "[PvpArena::isPlayerUser]player: " << player->getName() << std::endl;
#endif
    if(!player || player->isRemoved())
		return false;

	return std::find(userList.begin(), userList.end(), player) != userList.end();
}

void PvpArena::onKill(Player* player, Player* victim)
{
#ifdef __DEBUG__
    std::cout << "[PvpArena::onKill]player: " << player->getName() << ", victim: " << victim->getName() << std::endl;
#endif
    char buffer[200];
    sprintf(buffer, "PvP Arena: %s of the %s team defeated %s of the %s team.", player->getName().c_str(), (getPlayerTeam(player) == PVPTEAM_BLUE ? "blue" : "red"), victim->getName().c_str(), (getPlayerTeam(victim) == PVPTEAM_BLUE ? "blue" : "red"));
    broadcastMessage((getPlayerTeam(player) == PVPTEAM_BLUE ? MSG_STATUS_CONSOLE_BLUE : MSG_STATUS_CONSOLE_RED), buffer);
    player->setPvpArenaFrags(player->getPvpArenaFrags() + 1);
    player->setPvpArenaHotFrags(player->getPvpArenaHotFrags() + 1);
    checkKills(player);
}

void PvpArena::onDeath(Player* player)
{
#ifdef __DEBUG__
    std::cout << "[PvpArena::onDeath]player: " << player->getName() << std::endl;
#endif
     player->setPvpArenaDeaths(player->getPvpArenaDeaths() + 1);
     player->setPvpArenaHotFrags(0);
     g_game.internalTeleport(player, (getPlayerTeam(player) == PVPTEAM_BLUE ? blueSpawn : redSpawn), false);
}

pvpArenaTeam_t PvpArena::getPlayerTeam(Player* player)
{
#ifdef __DEBUG__
    std::cout << "[PvpArena::getPlayerTeam]player: " << player->getName() << std::endl;
#endif
    if(std::find(memberListBlue.begin(), memberListBlue.end(), player) != memberListBlue.end())
		return PVPTEAM_BLUE;
	if(std::find(memberListRed.begin(), memberListRed.end(), player) != memberListRed.end())
		return PVPTEAM_RED;
	return PVPTEAM_NONE;
}

pvpArenaTeam_t PvpArena::getPlayerTeam(const Player* _player)
{
#ifdef __DEBUG__
    std::cout << "[PvpArena::getPlayerTeam]player: " << player->getName() << std::endl;
#endif
    if(Player* player = const_cast<Player*>(_player))
        return getPlayerTeam(player);
	return PVPTEAM_NONE;
}

void PvpArena::checkKills(Player* player)
{
#ifdef __DEBUG__
    std::cout << "[PvpArena::checkKills]player: " << player->getName() << std::endl;
#endif
    uint16_t kills = player->getPvpArenaHotFrags();
    if(kills % 5 == 0)
    {
        uint8_t effect;
        switch(random_range(0, 5))
        { 
            case 5:
            {
                effect = 18;
                break;
            }
            case 4:
            {
                effect = 81;
                break;
            }
            case 3:
            {
                effect = 155;
                break;
            }
            case 2:
            {
                effect = 173;
                break;
            }
            case 1:
            {
                effect = 197;
                break;
            }
            default:
            {
                effect = 17;
                break;
            }
        }
        char buffer[200];   
        sprintf(buffer, "PvP Arena: %s is on a killing spree.", player->getName().c_str());
        broadcastMessage((getPlayerTeam(player) == PVPTEAM_BLUE ? MSG_STATUS_CONSOLE_BLUE : MSG_STATUS_CONSOLE_RED), buffer);
        g_game.addMagicEffect(player->getPosition(), effect);
    }
}

PlayerVector PvpArena::getUsers()
{
    return userList;
}
