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
#include "chat.h"

#include "player.h"
#include "iologindata.h"

#include "configmanager.h"
#include "game.h"
#include "house.h"

extern ConfigManager g_config;
extern Game g_game;
extern Chat g_chat;

uint16_t ChatChannel::staticFlags = CHANNELFLAG_ENABLED | CHANNELFLAG_ACTIVE;

PrivateChatChannel::PrivateChatChannel(uint16_t id, std::string name, uint16_t flags):
	ChatChannel(id, name, flags), m_owner(0) {}

bool PrivateChatChannel::isInvited(const Player* player)
{
	if(player->getGUID() == getOwner())
		return true;

	return std::find(m_invites.begin(), m_invites.end(), player->getGUID()) != m_invites.end();
}

bool PrivateChatChannel::addInvited(Player* player)
{
	if(std::find(m_invites.begin(), m_invites.end(), player->getGUID()) != m_invites.end())
		return false;

	m_invites.push_back(player->getGUID());
	return true;
}

bool PrivateChatChannel::removeInvited(Player* player)
{
	InviteList::iterator it = std::find(m_invites.begin(), m_invites.end(), player->getGUID());
	if(it == m_invites.end())
		return false;

	m_invites.erase(it);
	return true;
}

void PrivateChatChannel::invitePlayer(Player* player, Player* invitePlayer)
{
	if(player == invitePlayer || !addInvited(invitePlayer))
		return;

	std::stringstream msg;
	msg << player->getName() << Localization::t(invitePlayer->getLanguage(), " invites you to ") << (player->getSex(false) ? Localization::t(invitePlayer->getLanguage(), "his").c_str() : Localization::t(invitePlayer->getLanguage(), "her").c_str()) << Localization::t(invitePlayer->getLanguage(), " private chat channel.");
	invitePlayer->sendTextMessage(MSG_INFO_DESCR, msg.str().c_str());

	msg.str("");
	msg << invitePlayer->getName() << Localization::t(player->getLanguage(), " has been invited.");
	player->sendTextMessage(MSG_INFO_DESCR, msg.str().c_str());
}

void PrivateChatChannel::excludePlayer(Player* player, Player* excludePlayer)
{
	if(player == excludePlayer || !removeInvited(excludePlayer))
		return;

	std::string msg = excludePlayer->getName();
	msg += Localization::t(player->getLanguage(), " has been excluded.");
	player->sendTextMessage(MSG_INFO_DESCR, msg.c_str());

	removeUser(excludePlayer);
	excludePlayer->sendClosePrivate(getId());
}

void PrivateChatChannel::closeChannel()
{
	for(UsersMap::iterator it = m_users.begin(); it != m_users.end(); ++it)
		it->second->sendClosePrivate(m_id);
}
/* PS - TVChannel Start */
TVChannel::TVChannel(uint16_t id, std::string name, uint16_t flags):
	ChatChannel(id, name, flags), m_owner(0)
{
#ifdef __DEBUG__ || __DEBUG_TVSYSTEM__
    std::cout << "[TVChannel::TVChannel]Creating object, name: " << name << std::endl;
#endif
    m_password = "";
    tournamentChannel = false;
}

bool TVChannel::addViewer(Player* player)
{
#ifdef __DEBUG__ || __DEBUG_TVSYSTEM__
    std::cout << "[TVChannel::addViewer]player: " << player->getName() << std::endl;
#endif
    if(std::find(m_viewers.begin(), m_viewers.end(), player) != m_viewers.end() || player->getGUID() == m_owner)
		return false;
	
	if(Player* owner = g_game.getPlayerByGuid(m_owner))
    {        
        player->setTVOwner(owner);
        m_viewers.push_back(player);
        
        std::stringstream msg;
	    msg << Localization::t(owner->getLanguage(), "New viewer: ") << player->getName() << ".";
	    owner->sendTextMessage(MSG_STATUS_DEFAULT, msg.str().c_str());
	    return true;
    }

	return false;
}

bool TVChannel::removeViewer(Player* player)
{
#ifdef __DEBUG__ || __DEBUG_TVSYSTEM__
    std::cout << "[TVChannel::removeViewer]player: " << player->getName() << std::endl;
#endif
    ViewersList::iterator it = std::find(m_viewers.begin(), m_viewers.end(), player);
	if(it == m_viewers.end())
		return false;
		
	player->setTVOwner(NULL);
    player->sendClosePrivate(m_id);
    m_viewers.erase(it);
	
	if(Player* owner = g_game.getPlayerByGuid(m_owner))
    {
        std::stringstream msg;
	    msg << player->getName() << Localization::t(owner->getLanguage(), " has left from your TV channel.");
	    owner->sendTextMessage(MSG_STATUS_DEFAULT, msg.str().c_str());
	    return true;
    }
    
	return false;
}

bool TVChannel::banViewer(Player* player)
{
#ifdef __DEBUG__ || __DEBUG_TVSYSTEM__
    std::cout << "[TVChannel::banViewer]player: " << player->getName() << std::endl;
#endif
    if (getTournamentChannel()) {
        return false;
    }
    
    uint32_t guid = player->getGUID();
    if(std::find(m_bans.begin(), m_bans.end(), guid) != m_bans.end() || guid == m_owner)
		return false;
	
	if(Player* owner = g_game.getPlayerByGuid(m_owner))
    {        
        m_bans.push_back(guid);
        if(removeUser(player)) //This happen when the player is watching this channel
        {
            std::stringstream msg;
            msg << Localization::t(player->getLanguage(), "You have been banned from ") << owner->getName() << Localization::t(player->getLanguage(), " TV channel.");
            player->sendTextMessage(MSG_STATUS_DEFAULT, msg.str().c_str());
        }
        
        std::stringstream msg;
	    msg << player->getName() << Localization::t(owner->getLanguage(), " has been banned from your TV channel.");
	    owner->sendTextMessage(MSG_STATUS_DEFAULT, msg.str().c_str());
	    return true;
    }

	return false;
}

bool TVChannel::unbanViewer(Player* player)
{
#ifdef __DEBUG__ || __DEBUG_TVSYSTEM__
    std::cout << "[TVChannel::unbanViewer]player: " << player->getName() << std::endl;
#endif
    BanList::iterator it = std::find(m_bans.begin(), m_bans.end(), player->getGUID());
	if(it == m_bans.end())
		return false;
	
	if(Player* owner = g_game.getPlayerByGuid(m_owner))
    {        
        m_bans.erase(it);
        
        std::stringstream msg1;
        msg1 << Localization::t(player->getLanguage(), "You have been unbanned from ") << owner->getName() << Localization::t(player->getLanguage(), " TV channel.");
        player->sendTextMessage(MSG_STATUS_DEFAULT, msg1.str().c_str());
        
        std::stringstream msg2;
	    msg2 << player->getName() << Localization::t(owner->getLanguage(), " has been unbanned from your TV channel.");
	    owner->sendTextMessage(MSG_STATUS_DEFAULT, msg2.str().c_str());
	    return true;
    }
    
	return false;
}

bool TVChannel::isBanned(Player* player)
{
#ifdef __DEBUG__ || __DEBUG_TVSYSTEM__
    std::cout << "[TVChannel::isBanned]player: " << player->getName() << std::endl;
#endif
    return std::find(m_bans.begin(), m_bans.end(), player->getGUID()) != m_bans.end();
}

void TVChannel::closeChannel()
{
#ifdef __DEBUG__ || __DEBUG_TVSYSTEM__
    std::cout << "[TVChannel::closeChannel]owner: " << getOwner() << std::endl;
#endif
    if(Player* owner = g_game.getPlayerByGuid(getOwner()))
        owner->setTVChannel(NULL);
    
    for(UsersMap::iterator it = m_users.begin(); it != m_users.end(); ++it)
	{
		it->second->setTVOwner(NULL);
        it->second->sendClosePrivate(m_id);
    }
}

void TVChannel::replayDistanceShoot(const Position& from, const Position& to, uint8_t type)
{
    for(ViewersList::iterator it = m_viewers.begin(); it != m_viewers.end(); ++it)
        (*it)->sendTVDistanceShoot(from, to, type);
}

void TVChannel::replayMagicEffect(const Position& pos, uint16_t type)
{
    for(ViewersList::iterator it = m_viewers.begin(); it != m_viewers.end(); ++it)
        (*it)->sendTVMagicEffect(pos, type);
}

void TVChannel::replayAnimatedText(const Position& pos, uint8_t color, std::string text)
{
    for(ViewersList::iterator it = m_viewers.begin(); it != m_viewers.end(); ++it)
        (*it)->sendTVAnimatedText(pos, color, text);
}

void TVChannel::replayCreatureHealth(const Creature* creature)
{
    for(ViewersList::iterator it = m_viewers.begin(); it != m_viewers.end(); ++it)
        (*it)->sendTVCreatureHealth(creature);
}

void TVChannel::replayCreatureTurn(const Creature* creature, int16_t stackpos)
{
    for(ViewersList::iterator it = m_viewers.begin(); it != m_viewers.end(); ++it)
        (*it)->sendTVCreatureTurn(creature, stackpos);
}
     
void TVChannel::replayCreatureSay(const Creature* creature, SpeakClasses type, const std::string& text, Position* pos)
{
    for(ViewersList::iterator it = m_viewers.begin(); it != m_viewers.end(); ++it)
        (*it)->sendTVCreatureSay(creature, type, text, pos);
}

void TVChannel::replayChangeSpeed(const Creature* creature, uint32_t speed)
{
    for(ViewersList::iterator it = m_viewers.begin(); it != m_viewers.end(); ++it)
        (*it)->sendTVChangeSpeed(creature, speed);
}

void TVChannel::replayCreatureOutfit(const Creature* creature, const Outfit_t& outfit)
{
    for(ViewersList::iterator it = m_viewers.begin(); it != m_viewers.end(); ++it)
        (*it)->sendTVCreatureOutfit(creature, outfit);
}

void TVChannel::replayCreatureSkull(const Creature* creature)
{
    for(ViewersList::iterator it = m_viewers.begin(); it != m_viewers.end(); ++it)
        (*it)->sendTVCreatureSkull(creature);
}

void TVChannel::replayCreatureShield(const Creature* creature)
{
    for(ViewersList::iterator it = m_viewers.begin(); it != m_viewers.end(); ++it)
        (*it)->sendTVCreatureShield(creature);
}

void TVChannel::replayCreatureLight(const Creature* creature)
{
    for(ViewersList::iterator it = m_viewers.begin(); it != m_viewers.end(); ++it)
        (*it)->sendTVCreatureLight(creature);
}

void TVChannel::replayWorldLight(const LightInfo& lightInfo)
{
    for(ViewersList::iterator it = m_viewers.begin(); it != m_viewers.end(); ++it)
        (*it)->sendTVWorldLight(lightInfo);
}

void TVChannel::replayAddTileItem(const Tile* tile, const Position& pos, uint32_t stackpos, const Item* item)
{
    for(ViewersList::iterator it = m_viewers.begin(); it != m_viewers.end(); ++it)
        (*it)->sendTVAddTileItem(tile, pos, stackpos, item);
}

void TVChannel::replayUpdateTileItem(const Tile* tile, const Position& pos, uint32_t stackpos, const Item* item)
{
    for(ViewersList::iterator it = m_viewers.begin(); it != m_viewers.end(); ++it)
        (*it)->sendTVUpdateTileItem(tile, pos, stackpos, item);
}

void TVChannel::replayRemoveTileItem(const Tile* tile, const Position& pos, uint32_t stackpos)
{
    for(ViewersList::iterator it = m_viewers.begin(); it != m_viewers.end(); ++it)
        (*it)->sendTVRemoveTileItem(tile, pos, stackpos);
}

void TVChannel::replayUpdateTile(const Tile* tile, const Position& pos)
{
    for(ViewersList::iterator it = m_viewers.begin(); it != m_viewers.end(); ++it)
        (*it)->sendTVUpdateTile(tile, pos);
}

void TVChannel::replayAddCreature(const Creature* creature, const Position& pos, uint32_t stackpos)
{
    for(ViewersList::iterator it = m_viewers.begin(); it != m_viewers.end(); ++it)
        (*it)->sendTVAddCreature(creature, pos, stackpos);
}

void TVChannel::replayRemoveCreature(const Creature* creature, const Position& pos, uint32_t stackpos)
{
    for(ViewersList::iterator it = m_viewers.begin(); it != m_viewers.end(); ++it)
        (*it)->sendTVRemoveCreature(creature, pos, stackpos);
}

void TVChannel::replayUpdateCreature(const Creature* creature, const Position& pos, uint32_t stackpos)
{
    for(ViewersList::iterator it = m_viewers.begin(); it != m_viewers.end(); ++it)
        (*it)->sendTVUpdateCreature(creature, pos, stackpos);
}

void TVChannel::replayMoveCreature(const Creature* creature, const Tile* newTile, const Position& newPos, uint32_t newStackpos, const Tile* oldTile, const Position& oldPos, uint32_t oldStackpos, bool teleport)
{    
    for(ViewersList::iterator it = m_viewers.begin(); it != m_viewers.end(); ++it)
        (*it)->sendTVMoveCreature(creature, newTile, newPos, newStackpos, oldTile, oldPos, oldStackpos, teleport);
}

bool TVChannel::setPassword(const std::string& password)
{
    if (getTournamentChannel()) {
        return false;
    }
    
    m_password = password;
    return true;
}

const std::string& TVChannel::getPassword() const
{
    return m_password;
}

void TVChannel::setTournamentChannel(bool value)
{
    tournamentChannel = value;
}

bool TVChannel::getTournamentChannel()
{
    return tournamentChannel;
}

/* PS - TVChannel End */
ChatChannel::ChatChannel(uint16_t id, const std::string& name, uint16_t flags, uint32_t access/* = 0*/,
	uint32_t level/* = 1*/, Condition* condition/* = NULL*/, int32_t conditionId/* = -1*/,
	const std::string& conditionMessage/* = ""*/, VocationMap* vocationMap/* = NULL*/):
	m_id(id), m_flags(flags), m_conditionId(conditionId), m_access(access), m_level(level),
		m_name(name), m_conditionMessage(conditionMessage), m_condition(condition),
		m_vocationMap(vocationMap)
{
	if(hasFlag(CHANNELFLAG_LOGGED))
	{
		m_file.reset(new std::ofstream(getFilePath(FILE_TYPE_LOG, (std::string)"chat/" + g_config.getString(
			ConfigManager::PREFIX_CHANNEL_LOGS) + m_name + (std::string)".log").c_str(), std::ios::app | std::ios::out));
		if(!m_file->is_open())
			m_flags &= ~CHANNELFLAG_LOGGED;
	}
}

bool ChatChannel::isUserIn(Player* player)
{
    UsersMap::iterator it = m_users.find(player->getID());
    if (it != m_users.end())
    {
        return true;
    }

    return false;
}

bool ChatChannel::addUser(Player* player)
{
	if(m_users.find(player->getID()) != m_users.end())
		return false;

	ChatChannel* channel = g_chat.getChannel(player, m_id);
	if(!channel)
	{
		#ifdef __DEBUG_CHAT__
		std::cout << "ChatChannel::addUser - failed retrieving channel." << std::endl;
		#endif
		return false;
	}

    if(TVChannel* tvChannel = getTVChannel())
    {
        if(tvChannel->isBanned(player) || player->getRecordingTV())
            return false;
        tvChannel->addViewer(player);
    }
    
    bool result = true;
	CreatureEventList joinEvents = player->getCreatureEvents(CREATURE_EVENT_CHANNEL_JOIN);
	for(CreatureEventList::iterator it = joinEvents.begin(); it != joinEvents.end(); ++it)
	{
		if(!(*it)->executeChannelJoin(player, m_id, m_users) && result)
		    result = false;
    }
    
    if(result)
        m_users[player->getID()] = player;
    
    return result;
}

bool ChatChannel::removeUser(Player* player)
{
	UsersMap::iterator it = m_users.find(player->getID());
	if(it == m_users.end())
		return false;

    if(TVChannel* tvChannel = getTVChannel()) {
        if(player->getGUID() != tvChannel->getOwner()) {
            tvChannel->removeViewer(player);
        }
    }
	
	CreatureEventList leaveEvents = player->getCreatureEvents(CREATURE_EVENT_CHANNEL_LEAVE);
	for(CreatureEventList::iterator it = leaveEvents.begin(); it != leaveEvents.end(); ++it)
		(*it)->executeChannelLeave(player, m_id, m_users);
		
	m_users.erase(it);

	return true;
}

bool ChatChannel::talk(Player* player, SpeakClasses type, const std::string& text, uint32_t _time/* = 0*/)
{
	UsersMap::iterator it = m_users.find(player->getID());
	if(it == m_users.end())
		return false;
		
	if(hasFlag(CHANNELFLAG_LOCKED))
	    return false;

    if (hasFlag(CHANNELFLAG_TALKEVENT)) {	    
        bool result = true;
    	CreatureEventList events = player->getCreatureEvents(CREATURE_EVENT_CHANNEL_TALK);
    	for (CreatureEventList::iterator it = events.begin(); it != events.end(); ++it) {
    		if (!(*it)->executeChannelTalk(player, m_id, text) && result) {
    		    result = false;
            }
        }
        
        if (!result) {
            return true;
        }
    }

	if(m_condition && !player->hasFlag(PlayerFlag_CannotBeMuted))
	{
		if(Condition* condition = m_condition->clone())
			player->addCondition(condition);
	}

	for(it = m_users.begin(); it != m_users.end(); ++it)
		it->second->sendToChannel(player, type, text, m_id, _time);

	if(hasFlag(CHANNELFLAG_LOGGED) && m_file->is_open())
		*m_file << "[" << formatDate() << "] " << player->getName() << ": " << text << std::endl;

	return true;
}

void ChatChannel::internalTalk(const std::string& name, const std::string& text, SpeakClasses type)
{
	for(UsersMap::iterator it = m_users.begin(); it != m_users.end(); ++it)
		it->second->sendChannelMessage(name, text, type, m_id);

	if(hasFlag(CHANNELFLAG_LOGGED) && m_file->is_open())
		*m_file << "[UNKNOWN_TIME] " << name << ": " << text << std::endl;
}

Chat::~Chat()
{
	for(GuildChannelMap::iterator it = m_guildChannels.begin(); it != m_guildChannels.end(); ++it)
		delete it->second;

	m_guildChannels.clear();
	clear();
}

void Chat::clear()
{
	for(NormalChannelMap::iterator it = m_normalChannels.begin(); it != m_normalChannels.end(); ++it)
		delete it->second;

	m_normalChannels.clear();
	for(PartyChannelMap::iterator it = m_partyChannels.begin(); it != m_partyChannels.end(); ++it)
		delete it->second;

	m_partyChannels.clear();
	for(PrivateChannelMap::iterator it = m_privateChannels.begin(); it != m_privateChannels.end(); ++it)
		delete it->second;

	m_privateChannels.clear();
	delete dummyPrivate;
	
	m_TVChannels.clear();
	delete dummyTV;
}

bool Chat::reload()
{
	clear();
	return loadFromXml();
}

bool Chat::loadFromXml()
{
	xmlDocPtr doc = xmlParseFile(getFilePath(FILE_TYPE_XML, "channels.xml").c_str());
	if(!doc)
	{
		std::cout << "[Warning - Chat::loadFromXml] Cannot load channels file." << std::endl;
		std::cout << getLastXMLError() << std::endl;
		return false;
	}

	xmlNodePtr p, root = xmlDocGetRootElement(doc);
	if(xmlStrcmp(root->name,(const xmlChar*)"channels"))
	{
		std::cout << "[Error - Chat::loadFromXml] Malformed channels file" << std::endl;
		xmlFreeDoc(doc);
		return false;
	}

	for(p = root->children; p; p = p->next)
		parseChannelNode(p);

	xmlFreeDoc(doc);
	return true;
}

bool Chat::parseChannelNode(xmlNodePtr p)
{
	int32_t intValue;
	if(xmlStrcmp(p->name, (const xmlChar*)"channel"))
		return false;

	if(!readXMLInteger(p, "id", intValue) || intValue <= CHANNEL_GUILD)
	{
		std::cout << "[Warning - Chat::loadFromXml] Invalid or not specified channel id." << std::endl;
		return false;
	}

	uint16_t id = intValue;
	std::string strValue;
	if(m_normalChannels.find(id) != m_normalChannels.end() && (!readXMLString(p, "override", strValue) || !booleanString(strValue)))
	{
		std::cout << "[Warning - Chat::loadFromXml] Duplicated channel with id: " << id << "." << std::endl;
		return false;
	}

	if(!readXMLString(p, "name", strValue))
	{
		std::cout << "[Warning - Chat::loadFromXml] Missing name for channel with id: " << id << "." << std::endl;
		return false;
	}

	std::string name = strValue;
	uint16_t flags = ChatChannel::staticFlags;
	if(readXMLString(p, "enabled", strValue) && !booleanString(strValue))
		flags &= ~CHANNELFLAG_ENABLED;

	if(readXMLString(p, "active", strValue) && !booleanString(strValue))
		flags &= ~CHANNELFLAG_ACTIVE;

	if((readXMLString(p, "logged", strValue) || readXMLString(p, "log", strValue)) && booleanString(strValue))
		flags |= CHANNELFLAG_LOGGED;
		
	if(readXMLString(p, "locked", strValue) && booleanString(strValue))
	    flags |= CHANNELFLAG_LOCKED;
	    
    if(readXMLString(p, "private", strValue) && booleanString(strValue))
        flags |= CHANNELFLAG_PRIVATE;
        
    if(readXMLString(p, "talkEvent", strValue) && booleanString(strValue))
        flags |= CHANNELFLAG_TALKEVENT;

	uint32_t access = 0;
	if(readXMLInteger(p, "access", intValue))
		access = intValue;

	uint32_t level = 1;
	if(readXMLInteger(p, "level", intValue))
		level = intValue;

	int32_t conditionId = -1;
	std::string conditionMessage = "You are muted.";

	Condition* condition = NULL;
	if(readXMLInteger(p, "muted", intValue))
	{
		conditionId = 2;
		int32_t tmp = intValue * 1000;
		if(readXMLInteger(p, "conditionId", intValue))
		{
			conditionId = intValue;
			if(conditionId < 2)
				std::cout << "[Warning - Chat::parseChannelNode] Using reserved muted condition sub id (" << conditionId << ")" << std::endl;
		}

		if((condition = Condition::createCondition(CONDITIONID_DEFAULT, CONDITION_MUTED, tmp, 0, false, conditionId)))
		{
			if(readXMLString(p, "conditionMessage", strValue))
				conditionMessage = strValue;
		}
		else
			conditionId = -1;
	}

	StringVec vocStringVec;
	VocationMap vocMap;

	std::string error;
	for(xmlNodePtr tmpNode = p->children; tmpNode; tmpNode = tmpNode->next)
	{
		if(!parseVocationNode(tmpNode, vocMap, vocStringVec, error))
			std::cout << "[Warning - Chat::loadFromXml] " << error << std::endl;
	}

	VocationMap* vocationMap = NULL;
	if(!vocMap.empty())
		vocationMap = new VocationMap(vocMap);

	switch(id)
	{
		case CHANNEL_PARTY:
		{
			partyName = name;
			break;
		}

		case CHANNEL_PRIVATE:
		{
			if(ChatChannel* newChannel = new PrivateChatChannel(CHANNEL_PRIVATE, name, flags))
				dummyPrivate = newChannel;

			break;
		}
		
		case CHANNEL_TV:
        {
             if(ChatChannel* newChannel = new TVChannel(CHANNEL_TV, name, flags))
                 dummyTV = newChannel;
                 
             break;
        }

		default:
		{
			if(ChatChannel* newChannel = new ChatChannel(id, name, flags, access, level,
				condition, conditionId, conditionMessage, vocationMap))
				m_normalChannels[id] = newChannel;

			break;
		}
	}

	return true;
}

ChatChannel* Chat::createChannel(Player* player, uint16_t channelId)
{
	if(!player || player->isRemoved() || getChannel(player, channelId))
		return NULL;

	switch(channelId)
	{
		case CHANNEL_GUILD:
		{
			ChatChannel* newChannel = NULL;
			if((newChannel = new ChatChannel(channelId, player->getGuildName(), ChatChannel::staticFlags)))
				m_guildChannels[player->getGuildId()] = newChannel;

			return newChannel;
		}

		case CHANNEL_PARTY:
		{
			ChatChannel* newChannel = NULL;
			if(player->getParty() && (newChannel = new ChatChannel(channelId, partyName, ChatChannel::staticFlags)))
				m_partyChannels[player->getParty()] = newChannel;

			return newChannel;
		}

		case CHANNEL_PRIVATE:
		{
			//only 1 private channel for each premium player
			if(!player->isPremium() || getPrivateChannel(player))
				return NULL;

			//find a free private channel slot
			for(uint16_t i = 10000; i < 20000; ++i)
			{
				if(m_privateChannels.find(i) != m_privateChannels.end())
					continue;

				uint16_t flags = 0;
				if(dummyPrivate)
					flags = dummyPrivate->getFlags();

				PrivateChatChannel* newChannel = NULL;
				if((newChannel = new PrivateChatChannel(i, player->getName() + "'s Channel", flags)))
				{
					newChannel->setOwner(player->getGUID());
					m_privateChannels[i] = newChannel;
				}

				return newChannel;
			}
		}
		
		case CHANNEL_TV:
		{
			//only 1 private channel for each premium player
			if(!player->isPremium() || getTVChannel(player) || player->getWatchingTV() || player->getRecordingTV())
				return NULL;

			//find a free private channel slot
			for(uint16_t i = 20001; i < 30000; ++i)
			{
				if(m_TVChannels.find(i) != m_TVChannels.end())
					continue;

				uint16_t flags = 0;
				if(dummyTV)
					flags = dummyPrivate->getFlags();

				TVChannel* newChannel = NULL;
				if((newChannel = new TVChannel(i, player->getName() + "'s TV Channel", flags)))
				{
					newChannel->setOwner(player->getGUID());
					m_TVChannels[i] = newChannel;
					player->setTVChannel(newChannel);
				}

				return newChannel;
			}
		}

		default:
			break;
	}

	return NULL;
}

bool Chat::deleteChannel(Player* player, uint16_t channelId)
{
	switch(channelId)
	{
		case CHANNEL_GUILD:
		{
			GuildChannelMap::iterator it = m_guildChannels.find(player->getGuildId());
			if(it == m_guildChannels.end())
				return false;

			delete it->second;
			m_guildChannels.erase(it);
			return true;
		}

		case CHANNEL_PARTY:
		{
			PartyChannelMap::iterator it = m_partyChannels.find(player->getParty());
			if(it == m_partyChannels.end())
				return false;

			delete it->second;
			m_partyChannels.erase(it);
			return true;
		}
/*		
		case CHANNEL_TV:
        {
            if (TVChannel* channel = getTVChannel(player))
            {
                channel->closeChannel();
			    if(Player* owner = g_game.getPlayerByGuid(channel->getOwner()))
                    owner->setTVChannel(NULL);
                m_TVChannels.erase(channel->getId());
                delete channel;
			    return true;
            }
        }
*/
		default:
		{
			PrivateChannelMap::iterator it = m_privateChannels.find(channelId);
			if(it != m_privateChannels.end())
			{
                it->second->closeChannel();
			    delete it->second;

			    m_privateChannels.erase(it);
			    return true;
            }
                
            TVChannelMap::iterator itt = m_TVChannels.find(channelId);
            if(itt != m_TVChannels.end())
			{
                itt->second->closeChannel();
                delete itt->second;
                   
			    m_TVChannels.erase(itt);
			    return true;
            }
                
			return false;
		}
	}

	return false;
}

ChatChannel* Chat::addUserToChannel(Player* player, uint16_t channelId, bool forced)
{
	ChatChannel* channel = getChannel(player, channelId);
	if(channel && (forced || !channel->hasFlag(CHANNELFLAG_PRIVATE)) && channel->addUser(player))
		return channel;

	return NULL;
}

bool Chat::removeUserFromChannel(Player* player, uint16_t channelId)
{
    ChatChannel* channel = getChannel(player, channelId);
	if(!channel || !channel->removeUser(player))
		return false;

	if(channel->getOwner() == player->getGUID())
		deleteChannel(player, channelId);

	return true;
}

void Chat::removeUserFromAllChannels(Player* player)
{
	if(!player)
		return;

	for(NormalChannelMap::iterator it = m_normalChannels.begin(); it != m_normalChannels.end(); ++it)
		it->second->removeUser(player);

	for(PartyChannelMap::iterator it = m_partyChannels.begin(); it != m_partyChannels.end(); ++it)
		it->second->removeUser(player);

	for(GuildChannelMap::iterator it = m_guildChannels.begin(); it != m_guildChannels.end(); ++it)
		it->second->removeUser(player);

	PrivateChatChannel* tmpPrv = NULL;
    for(PrivateChannelMap::iterator it = m_privateChannels.begin(); it != m_privateChannels.end(); ++it)
	{
		it->second->removeUser(player);
		if (it->second->getOwner() == player->getGUID()) {
            if (!tmpPrv) {
                tmpPrv = it->second;
            }
            else {
                std::cout << "[Warning - Chat::removeUserFromAllChannels]Duplicated Private Channel for player "
                    << player->getName() << std::endl;
            }
        }
	}
	
	if (tmpPrv) {
        deleteChannel(player, tmpPrv->getId());
    }
	
	TVChannel* tmpTv = NULL;
    for(TVChannelMap::iterator it = m_TVChannels.begin(); it != m_TVChannels.end(); ++it)
	{
		it->second->removeUser(player);
		if (it->second->getOwner() == player->getGUID()) {
            if (!tmpTv) {
                tmpTv = it->second;
            }
            else {
                std::cout << "[Warning - Chat::removeUserFromAllChannels]Duplicated Tv Channel for player "
                    << player->getName() << std::endl;
            }
        }
	}
	
	if (tmpTv) {
        deleteChannel(player, tmpTv->getId());
    }
}

bool Chat::talkToChannel(Player* player, SpeakClasses type, const std::string& text, uint16_t channelId)
{
    if(text.empty())
		return false;

	ChatChannel* channel = getChannel(player, channelId);
	if(!channel)
		return false;

	if(!player->hasFlag(PlayerFlag_CannotBeMuted))
	{
		if(!channel->hasFlag(CHANNELFLAG_ACTIVE))
		{
			player->sendTextMessage(MSG_STATUS_SMALL, "You may not speak into this channel.");
			return true;
		}

		if(player->getLevel() < channel->getLevel())
		{
			char buffer[100];
			sprintf(buffer, Localization::t(player->getLanguage(), "You may not speak into this channel as long as you are on level %d.").c_str(), channel->getLevel());
			player->sendCancel(buffer);
			return true;
		}

		if(channel->getConditionId() >= 0 && player->hasCondition(CONDITION_MUTED, channel->getConditionId()))
		{
			player->sendCancel(channel->getConditionMessage().c_str());
			return true;
		}
	}

	if(channelId != CHANNEL_GUILD || !g_config.getBool(ConfigManager::INGAME_GUILD_MANAGEMENT)
		|| (text[0] != '!' && text[0] != '/'))
	{
		if(channelId == CHANNEL_GUILD)
		{
			switch(player->getGuildLevel())
			{
				case GUILDLEVEL_VICE:
					return channel->talk(player, SPEAK_CHANNEL_O, text);
				case GUILDLEVEL_LEADER:
					return channel->talk(player, SPEAK_CHANNEL_RN, text);
				default:
					break;
			}
		}

		return channel->talk(player, type, text);
	}

	if(!player->getGuildId())
	{
		player->sendCancel("You are not in a guild.");
		return true;
	}

	if(!IOGuild::getInstance()->guildExists(player->getGuildId()))
	{
		player->sendCancel("It seems like your guild does not exist anymore.");
		return true;
	}

	char buffer[350];
	if(text.substr(1) == "disband")
	{
		if(player->getGuildLevel() == GUILDLEVEL_LEADER)
		{
			uint32_t guildId = player->getGuildId();
			channel->talk(player, SPEAK_CHANNEL_W, "The guild has been disbanded.");
			IOGuild::getInstance()->disbandGuild(guildId);
			
			if (House* house = Houses::getInstance()->getHouseByGuildId(guildId)) {
                house->setOwnerEx(0, true);
            }
		}
		else
			player->sendCancel("You are not the leader of your guild.");
	}
	else if(text.substr(1, 6) == "invite")
	{
		if(player->getGuildLevel() > GUILDLEVEL_MEMBER)
		{
			if(text.length() > 7)
			{
				std::string param = text.substr(8);
				trimString(param);
				Player* paramPlayer = NULL;
				if(g_game.getPlayerByNameWildcard(param, paramPlayer) == RET_NOERROR)
				{
					if(paramPlayer->getGuildId() == 0)
					{
						if(!paramPlayer->isGuildInvited(player->getGuildId()))
						{
							sprintf(buffer, Localization::t(paramPlayer->getLanguage(), "%s has invited you to join the guild, %s. You may join this guild by writing: !joinguild %s").c_str(), player->getName().c_str(), player->getGuildName().c_str(), player->getGuildName().c_str());
							paramPlayer->sendTextMessage(MSG_INFO_DESCR, buffer);
							sprintf(buffer, Localization::t(player->getLanguage(), "%s has invited %s to the guild.").c_str(), player->getName().c_str(), paramPlayer->getName().c_str());
							channel->talk(player, SPEAK_CHANNEL_W, buffer);
							paramPlayer->invitedToGuildsList.push_back(player->getGuildId());
						}
						else
							player->sendCancel("A player with that name has already been invited to your guild.");
					}
					else
						player->sendCancel("A player with that name is already in a guild.");
				}
				else if(IOLoginData::getInstance()->playerExists(param))
				{
					uint32_t guid;
					IOLoginData::getInstance()->getGuidByName(guid, param);
					if(!IOGuild::getInstance()->hasGuild(guid))
					{
						if(!IOGuild::getInstance()->isInvited(player->getGuildId(), guid))
						{
							if(IOGuild::getInstance()->guildExists(player->getGuildId()))
							{
								IOGuild::getInstance()->invitePlayer(player->getGuildId(), guid);
								sprintf(buffer, Localization::t(player->getLanguage(), "%s has invited %s to the guild.").c_str(), player->getName().c_str(), param.c_str());
								channel->talk(player, SPEAK_CHANNEL_W, buffer);
							}
							else
								player->sendCancel("Your guild does not exist anymore.");
						}
						else
							player->sendCancel("A player with that name has already been invited to your guild.");
					}
					else
						player->sendCancel("A player with that name is already in a guild.");
				}
				else
					player->sendCancel("A player with that name does not exist.");
			}
			else
				player->sendCancel("Invalid guildcommand parameters.");
		}
		else
			player->sendCancel("You don't have rights to invite players to your guild.");
	}
	else if(text.substr(1, 5) == "leave")
	{
		if(player->getGuildLevel() < GUILDLEVEL_LEADER)
		{
			sprintf(buffer, Localization::t(player->getLanguage(), "%s has left the guild.").c_str(), player->getName().c_str());
			channel->talk(player, SPEAK_CHANNEL_W, buffer);
			player->leaveGuild();
		}
		else
			player->sendCancel("You cannot leave your guild because you are the leader of it, you have to pass the leadership to another member of your guild or disband the guild.");
	}
	else if(text.substr(1, 6) == "revoke")
	{
		if(player->getGuildLevel() > GUILDLEVEL_MEMBER)
		{
			if(text.length() > 7)
			{
				std::string param = text.substr(8);
				trimString(param);
				Player* paramPlayer = NULL;
				if(g_game.getPlayerByNameWildcard(param, paramPlayer) == RET_NOERROR)
				{
					if(paramPlayer->getGuildId() == 0)
					{
						InvitedToGuildsList::iterator it = std::find(paramPlayer->invitedToGuildsList.begin(),paramPlayer->invitedToGuildsList.end(), player->getGuildId());
						if(it != paramPlayer->invitedToGuildsList.end())
						{
							sprintf(buffer, Localization::t(paramPlayer->getLanguage(), "%s has revoked your invite to %s guild.").c_str(), player->getName().c_str(), (player->getSex(false) ? "his" : "her"));
							paramPlayer->sendTextMessage(MSG_INFO_DESCR, buffer);
							sprintf(buffer, Localization::t(player->getLanguage(), "%s has revoked the guildinvite of %s.").c_str(), player->getName().c_str(), paramPlayer->getName().c_str());
							channel->talk(player, SPEAK_CHANNEL_W, buffer);
							paramPlayer->invitedToGuildsList.erase(it);
							return true;
						}
						else
							player->sendCancel("A player with that name is not invited to your guild.");
					}
					else
						player->sendCancel("A player with that name is already in a guild.");
				}
				else if(IOLoginData::getInstance()->playerExists(param))
				{
					uint32_t guid;
					IOLoginData::getInstance()->getGuidByName(guid, param);
					if(IOGuild::getInstance()->isInvited(player->getGuildId(), guid))
					{
						if(IOGuild::getInstance()->guildExists(player->getGuildId()))
						{
							sprintf(buffer, Localization::t(player->getLanguage(), "%s has revoked the guildinvite of %s.").c_str(), player->getName().c_str(), param.c_str());
							channel->talk(player, SPEAK_CHANNEL_W, buffer);
							IOGuild::getInstance()->revokeInvite(player->getGuildId(), guid);
						}
						else
							player->sendCancel("It seems like your guild does not exist anymore.");
					}
					else
						player->sendCancel("A player with that name is not invited to your guild.");
				}
				else
					player->sendCancel("A player with that name does not exist.");
			}
			else
				player->sendCancel("Invalid guildcommand parameters.");
		}
		else
			player->sendCancel("You don't have rights to revoke an invite of someone in your guild.");
	}
	else if(text.substr(1, 7) == "promote" || text.substr(1, 6) == "demote" || text.substr(1, 14) == "passleadership" || text.substr(1, 4) == "kick")
	{
		if(player->getGuildLevel() == GUILDLEVEL_LEADER)
		{
			std::string param;
			uint32_t length = 0;
			if(text[2] == 'r')
				length = 9;
			else if(text[2] == 'e')
				length = 7;
			else if(text[2] == 'a')
				length = 16;
			else
				length = 6;

			if(text.length() < length)
			{
				player->sendCancel("Invalid guildcommand parameters.");
				return true;
			}

			param = text.substr(length);
			trimString(param);
			Player* paramPlayer = NULL;
			if(g_game.getPlayerByNameWildcard(param, paramPlayer) == RET_NOERROR)
			{
				if(paramPlayer->getGuildId())
				{
					if(IOGuild::getInstance()->guildExists(paramPlayer->getGuildId()))
					{
						if(player->getGuildId() == paramPlayer->getGuildId())
						{
							if(text[2] == 'r')
							{
								if(paramPlayer->getGuildLevel() == GUILDLEVEL_MEMBER)
								{
									if(paramPlayer->isPremium())
									{
										paramPlayer->setGuildLevel(GUILDLEVEL_VICE);
										sprintf(buffer, Localization::t(player->getLanguage(), "%s has promoted %s to %s.").c_str(), player->getName().c_str(), paramPlayer->getName().c_str(), paramPlayer->getRankName().c_str());
										channel->talk(player, SPEAK_CHANNEL_W, buffer);
									}
									else
										player->sendCancel("A player with that name does not have a premium account.");
								}
								else
									player->sendCancel("You can only promote Members to Vice-Leaders.");
							}
							else if(text[2] == 'e')
							{
								if(paramPlayer->getGuildLevel() == GUILDLEVEL_VICE)
								{
									paramPlayer->setGuildLevel(GUILDLEVEL_MEMBER);
									sprintf(buffer, Localization::t(player->getLanguage(), "%s has demoted %s to %s.").c_str(), player->getName().c_str(), paramPlayer->getName().c_str(), paramPlayer->getRankName().c_str());
									channel->talk(player, SPEAK_CHANNEL_W, buffer);
								}
								else
									player->sendCancel("You can only demote Vice-Leaders to Members.");
							}
							else if(text[2] == 'a')
							{
								if(paramPlayer->getGuildLevel() == GUILDLEVEL_VICE)
								{
									const uint32_t levelToFormGuild = g_config.getNumber(ConfigManager::LEVEL_TO_FORM_GUILD);
									if(paramPlayer->getLevel() >= levelToFormGuild)
									{
										paramPlayer->setGuildLevel(GUILDLEVEL_LEADER);
										player->setGuildLevel(GUILDLEVEL_VICE);
										IOGuild::getInstance()->updateOwnerId(paramPlayer->getGuildId(), paramPlayer->getGUID());
										sprintf(buffer, Localization::t(player->getLanguage(), "%s has passed the guild leadership to %s.").c_str(), player->getName().c_str(), paramPlayer->getName().c_str());
										channel->talk(player, SPEAK_CHANNEL_W, buffer);
									}
									else
									{
										sprintf(buffer, "The new guild leader has to be at least Level %d.", levelToFormGuild);
										player->sendCancel(buffer);
									}
								}
								else
									player->sendCancel("A player with that name is not a Vice-Leader.");
							}
							else
							{
								if(player->getGuildLevel() > paramPlayer->getGuildLevel())
								{
									sprintf(buffer, Localization::t(player->getLanguage(), "%s has been kicked from the guild by %s.").c_str(), paramPlayer->getName().c_str(), player->getName().c_str());
									channel->talk(player, SPEAK_CHANNEL_W, buffer);
									paramPlayer->leaveGuild();
								}
								else
									player->sendCancel("You may only kick players with a guild rank below your.");
							}
						}
						else
							player->sendCancel("You are not in the same guild as a player with that name.");
					}
					else
						player->sendCancel("Could not find the guild of a player with that name.");
				}
				else
					player->sendCancel("A player with that name is not in a guild.");
			}
			else if(IOLoginData::getInstance()->playerExists(param))
			{
				uint32_t guid;
				IOLoginData::getInstance()->getGuidByName(guid, param);
				if(IOGuild::getInstance()->hasGuild(guid))
				{
					if(player->getGuildId() == IOGuild::getInstance()->getGuildId(guid))
					{
						if(text[2] == 'r')
						{
							if(IOGuild::getInstance()->getGuildLevel(guid) == GUILDLEVEL_MEMBER)
							{
								if(IOLoginData::getInstance()->isPremium(guid))
								{
									IOGuild::getInstance()->setGuildLevel(guid, GUILDLEVEL_VICE);
									sprintf(buffer, Localization::t(player->getLanguage(), "%s has promoted %s to %s.").c_str(), player->getName().c_str(), param.c_str(), IOGuild::getInstance()->getRank(guid).c_str());
									channel->talk(player, SPEAK_CHANNEL_W, buffer);
								}
								else
									player->sendCancel("A player with that name does not have a premium account.");
							}
							else
								player->sendCancel("You can only promote Members to Vice-Leaders.");
						}
						else if(text[2] == 'e')
						{
							if(IOGuild::getInstance()->getGuildLevel(guid) == GUILDLEVEL_VICE)
							{
								IOGuild::getInstance()->setGuildLevel(guid, GUILDLEVEL_MEMBER);
								sprintf(buffer, Localization::t(player->getLanguage(), "%s has demoted %s to %s.").c_str(), player->getName().c_str(), param.c_str(), IOGuild::getInstance()->getRank(guid).c_str());
								channel->talk(player, SPEAK_CHANNEL_W, buffer);
							}
							else
								player->sendCancel("You can only demote Vice-Leaders to Members.");
						}
						else if(text[2] == 'a')
						{
							if(IOGuild::getInstance()->getGuildLevel(guid) == GUILDLEVEL_VICE)
							{
								const uint32_t levelToFormGuild = g_config.getNumber(ConfigManager::LEVEL_TO_FORM_GUILD);
								if(IOLoginData::getInstance()->getLevel(guid) >= levelToFormGuild)
								{
									IOGuild::getInstance()->setGuildLevel(guid, GUILDLEVEL_LEADER);
									player->setGuildLevel(GUILDLEVEL_VICE);
									IOGuild::getInstance()->updateOwnerId(player->getGuildId(), guid);
									sprintf(buffer, Localization::t(player->getLanguage(), "%s has passed the guild leadership to %s.").c_str(), player->getName().c_str(), param.c_str());
									channel->talk(player, SPEAK_CHANNEL_W, buffer);
								}
								else
								{
									sprintf(buffer, Localization::t(player->getLanguage(), "The new guild leader has to be at least Level %d.").c_str(), levelToFormGuild);
									player->sendCancel(buffer);
								}
							}
							else
								player->sendCancel("A player with that name is not a Vice-Leader.");
						}
						else
						{
							sprintf(buffer, Localization::t(player->getLanguage(), "%s has been kicked from the guild by %s.").c_str(), param.c_str(), player->getName().c_str());
							channel->talk(player, SPEAK_CHANNEL_W, buffer);
							IOLoginData::getInstance()->resetGuildInformation(guid);
						}
					}
				}
				else
					player->sendCancel("A player with that name is not in a guild.");
			}
			else
				player->sendCancel("A player with that name does not exist.");
		}
		else
			player->sendCancel("You are not the leader of your guild.");
	}
	else if(text.substr(1, 4) == "nick" && text.length() > 5)
	{
		StringVec params = explodeString(text.substr(6), ",");
		if(params.size() >= 2)
		{
			std::string param1 = params[0], param2 = params[1];
			trimString(param1);
			trimString(param2);
			Player* paramPlayer = NULL;
			if(g_game.getPlayerByNameWildcard(param1, paramPlayer) == RET_NOERROR)
			{
				if(paramPlayer->getGuildId())
				{
					if(param2.length() > 2)
					{
						if(param2.length() < 21)
						{
							if(isValidName(param2, false))
							{
								if(IOGuild::getInstance()->guildExists(paramPlayer->getGuildId()))
								{
									if(player->getGuildId() == paramPlayer->getGuildId())
									{
										if(paramPlayer->getGuildLevel() < player->getGuildLevel() || (player == paramPlayer && player->getGuildLevel() > GUILDLEVEL_MEMBER))
										{
											paramPlayer->setGuildNick(param2);
											if(player != paramPlayer)
												sprintf(buffer, Localization::t(player->getLanguage(), "%s has set the guildnick of %s to \"%s\".").c_str(), player->getName().c_str(), paramPlayer->getName().c_str(), param2.c_str());
											else
												sprintf(buffer, Localization::t(player->getLanguage(), "%s has set %s guildnick to \"%s\".").c_str(), player->getName().c_str(), (player->getSex(false) ? Localization::t(player->getLanguage(), "his").c_str() : Localization::t(player->getLanguage(), "her").c_str()), param2.c_str());
											channel->talk(player, SPEAK_CHANNEL_W, buffer);
										}
										else
											player->sendCancel("You may only change the guild nick of players that have a lower rank than you.");
									}
									else
										player->sendCancel("A player with that name is not in your guild.");
								}
								else
									player->sendCancel("A player with that name's guild could not be found.");
							}
							else
								player->sendCancel("That guildnick is not valid.");
						}
						else
							player->sendCancel("That guildnick is too long, please select a shorter one.");
					}
					else
						player->sendCancel("That guildnick is too short, please select a longer one.");
				}
				else
					player->sendCancel("A player with that name is not in a guild.");
			}
			else if(IOLoginData::getInstance()->playerExists(param1))
			{
				uint32_t guid;
				IOLoginData::getInstance()->getGuidByName(guid, (std::string&)param1);
				if(IOGuild::getInstance()->hasGuild(guid))
				{
					if(param2.length() > 2)
					{
						if(param2.length() < 21)
						{
							if(isValidName(param2, false))
							{
								if(IOGuild::getInstance()->guildExists(guid))
								{
									if(player->getGuildId() == IOGuild::getInstance()->getGuildId(guid))
									{
										if(IOGuild::getInstance()->getGuildLevel(guid) < player->getGuildLevel())
										{
											IOGuild::getInstance()->setGuildNick(guid, param2);
											sprintf(buffer, Localization::t(player->getLanguage(), "%s has set the guildnick of %s to \"%s\".").c_str(), player->getName().c_str(), param1.c_str(), param2.c_str());
											channel->talk(player, SPEAK_CHANNEL_W, buffer);
										}
										else
											player->sendCancel("You may only change the guild nick of players that have a lower rank than you.");
									}
									else
										player->sendCancel("A player with that name is not in your guild.");
								}
								else
									player->sendCancel("A player with that name's guild could not be found.");
							}
							else
								player->sendCancel("That guildnick is not valid.");
						}
						else
							player->sendCancel("That guildnick is too long, please select a shorter one.");
					}
					else
						player->sendCancel("That guildnick is too short, please select a longer one.");
				}
				else
					player->sendCancel("A player with that name is not in any guild.");
			}
			else
				player->sendCancel("A player with that name does not exist.");
		}
		else
			player->sendCancel("Invalid guildcommand parameters.");
	}
	else if(text.substr(1, 10) == "removenick" && text.length() > 11) {
		std::string param = text.substr(12);
		trimString(param);
		Player* paramPlayer = NULL;
		
		// Player online
		if (g_game.getPlayerByNameWildcard(param, paramPlayer) == RET_NOERROR) {
			if (!paramPlayer->getGuildId()) {
				player->sendCancel("A player with that name is not in a guild.");
				return true;
			}
			
			if (!IOGuild::getInstance()->guildExists(paramPlayer->getGuildId())) {
				player->sendCancel("A player with that name is not in a guild.");
				return true;
			}
			
			if (player->getGuildId() != paramPlayer->getGuildId()) {
				player->sendCancel("A player with that name is not in your guild.");
				return true;
			}
			
			if (paramPlayer->getGuildLevel() >= player->getGuildLevel() || (player == paramPlayer && player->getGuildLevel() <= GUILDLEVEL_MEMBER)) {
				player->sendCancel("You may only change the guild nick of players that have a lower rank than you.");
				return true;
			}     
			
			paramPlayer->setGuildNick("");
			if (player != paramPlayer) {
				sprintf(buffer, Localization::t(player->getLanguage(), "%s has removed guildnick of %s.").c_str(), player->getName().c_str(), paramPlayer->getName().c_str());
			}
			else {
				sprintf(buffer, Localization::t(player->getLanguage(), "%s has remove %s guildnick.").c_str(), player->getName().c_str(), (player->getSex(false) ? Localization::t(player->getLanguage(), "his").c_str() : Localization::t(player->getLanguage(), "her").c_str()));
			}
			channel->talk(player, SPEAK_CHANNEL_W, buffer);                            
        }
        // Player offline
 		else if (IOLoginData::getInstance()->playerExists(param)) {
		    uint32_t guid;
			IOLoginData::getInstance()->getGuidByName(guid, (std::string&)param);
			if (!IOGuild::getInstance()->hasGuild(guid)) {
                player->sendCancel("A player with that name is not in any guild.");
                return true;
            }
            
            if (!IOGuild::getInstance()->guildExists(guid)) {
                player->sendCancel("A player with that name's guild could not be found.");
                return true;
            }
            
            if (player->getGuildId() == IOGuild::getInstance()->getGuildId(guid)) {
                player->sendCancel("A player with that name is not in your guild.");
                return true;
            }
            
            if (IOGuild::getInstance()->getGuildLevel(guid) >= player->getGuildLevel()) {
                player->sendCancel("You may only change the guild nick of players that have a lower rank than you.");
                return true;
            }
            
            IOGuild::getInstance()->setGuildNick(guid, "");
		    sprintf(buffer, Localization::t(player->getLanguage(), "%s has removed the guildnick of %s.").c_str(), player->getName().c_str(), param.c_str());
			channel->talk(player, SPEAK_CHANNEL_W, buffer);
	
		}
        else {
            player->sendCancel("A player with that name does not exist.");
            return true;
        }
    }
	else if(text.substr(1, 11) == "setrankname" && text.length() > 12)
	{
		StringVec params = explodeString(text.substr(13), ",");
		if(params.size() >= 2)
		{
			std::string param1 = params[0], param2 = params[1];
			trimString(param1);
			trimString(param2);
			if(player->getGuildLevel() == GUILDLEVEL_LEADER)
			{
				if(param2.length() > 2)
				{
					if(param2.length() < 21)
					{
						if(isValidName(param2, false))
						{
							if(IOGuild::getInstance()->getRankIdByName(player->getGuildId(), param1))
							{
								if(!IOGuild::getInstance()->getRankIdByName(player->getGuildId(), param2))
								{
									IOGuild::getInstance()->changeRank(player->getGuildId(), param1, param2);
									sprintf(buffer, Localization::t(player->getLanguage(), "%s has renamed the guildrank: \"%s\", to: \"%s\".").c_str(), player->getName().c_str(), param1.c_str(), param2.c_str());
									channel->talk(player, SPEAK_CHANNEL_W, buffer);
								}
								else
									player->sendCancel("There is already a rank in your guild with that name.");
							}
							else
								player->sendCancel("There is no such rankname in your guild.");
						}
						else
							player->sendCancel("The new guildrank contains invalid characters.");
					}
					else
						player->sendCancel("The new rankname is too long.");
				}
				else
					player->sendCancel("The new rankname is too short.");
			}
			else
				player->sendCancel("You are not the leader of your guild.");
		}
		else
			player->sendCancel("Invalid guildcommand parameters");
	}
	else if(text.substr(1, 7) == "setmotd")
	{
		if(player->getGuildLevel() == GUILDLEVEL_LEADER)
		{
			if(text.length() > 8)
			{
				std::string param = text.substr(9);
				trimString(param);
				if(param.length() > 2)
				{
					if(param.length() < 225)
					{
						IOGuild::getInstance()->setMotd(player->getGuildId(), param);
						sprintf(buffer, Localization::t(player->getLanguage(), "%s has set the Message of the Day to: %s").c_str(), player->getName().c_str(), param.c_str());
						channel->talk(player, SPEAK_CHANNEL_W, buffer);
					}
					else
						player->sendCancel("That motd is too long.");
				}
				else
					player->sendCancel("That motd is too short.");
			}
			else
				player->sendCancel("Invalid guildcommand parameters.");
		}
		else
			player->sendCancel("Only the leader of your guild can set the guild motd.");
	}
	else if(text.substr(1, 9) == "cleanmotd")
	{
		if(player->getGuildLevel() == GUILDLEVEL_LEADER)
		{
			IOGuild::getInstance()->setMotd(player->getGuildId(), "");
			sprintf(buffer, Localization::t(player->getLanguage(), "%s has cleaned the Message of the Day.").c_str(), player->getName().c_str());
			channel->talk(player, SPEAK_CHANNEL_W, buffer);
		}
		else
			player->sendCancel("Only the leader of your guild can clean the guild motd.");
	}
	else if(text.substr(1, 9) == "broadcast")
	{
		if(player->getGuildLevel() == GUILDLEVEL_LEADER)
		{
			if(text.length() > 10)
			{
				std::string param = text.substr(11);
				trimString(param);
				if(param.length() > 2)
				{
					if(param.length() < 225)
					{
						for(UsersMap::const_iterator it = channel->getUsers().begin(); it != channel->getUsers().end(); ++it)
		                    it->second->sendTextMessage(MSG_STATUS_WARNING, param.c_str());
					}
					else
						player->sendCancel("That message is too long.");
				}
				else
					player->sendCancel("That message is too short.");
			}
			else
				player->sendCancel("Invalid guildcommand parameters.");
		}
		else
			player->sendCancel("Only the leader of your guild can broadcast.");
	}
	
	else if(text.substr(1, 8) == "commands")
		player->sendToChannel(player, SPEAK_CHANNEL_W, "Guild commands with parameters: disband, leave, kick[name], revoke[name], demote[name], promote[name], passleadership[name], nick[name, nick], setrankname[oldName, newName], setmotd[text], cleanmotd, broadcast[text], list and setrank[name,rank].", CHANNEL_GUILD);
	else
		return false;

	return true;
}

std::string Chat::getChannelName(Player* player, uint16_t channelId)
{
	if(ChatChannel* channel = getChannel(player, channelId))
		return channel->getName();

	return "";
}

ChannelList Chat::getChannelList(Player* player)
{
	ChannelList list;
	if(!player || player->isRemoved())
		return list;

	ChatChannel* channel = NULL;
	if(player->getParty() && ((channel = getChannel(player, CHANNEL_PARTY)) || (channel = createChannel(player, CHANNEL_PARTY))))
		list.push_back(channel);

	if(player->getGuildId() && player->getGuildName().length() && ((channel = getChannel(
		player, CHANNEL_GUILD)) || (channel = createChannel(player, CHANNEL_GUILD))))
		list.push_back(channel);

	for(NormalChannelMap::iterator it = m_normalChannels.begin(); it != m_normalChannels.end(); ++it)
	{
		if((channel = getChannel(player, it->first)))
		{
			if(channel->hasFlag(CHANNELFLAG_ACTIVE) && !channel->hasFlag(CHANNELFLAG_PRIVATE))
                list.push_back(it->second);
        }
	}

	bool hasPrivate = false;
	PrivateChatChannel* prvChannel = NULL;
	for(PrivateChannelMap::iterator pit = m_privateChannels.begin(); pit != m_privateChannels.end(); ++pit)
	{
		if(!(prvChannel = pit->second))
			continue;

		if(prvChannel->isInvited(player))
			list.push_back(prvChannel);

		if(prvChannel->getOwner() == player->getGUID())
			hasPrivate = true;
	}

	if(!hasPrivate && player->isPremium())
		list.push_front(dummyPrivate);

	return list;
}

ChannelList Chat::getTVChannelList()
{
	ChannelList list;
	for(TVChannelMap::iterator it = m_TVChannels.begin(); it != m_TVChannels.end(); ++it)
		list.push_back(it->second);

	return list;
}

ChatChannel* Chat::getChannel(Player* player, uint16_t channelId)
{
	#ifdef __DEBUG_CHAT__
	std::cout << "Chat::getChannel - getChannel id " << channelId << std::endl;
	#endif
	if(!player || player->isRemoved())
		return NULL;

	if(channelId == CHANNEL_GUILD)
	{
		GuildChannelMap::iterator git = m_guildChannels.find(player->getGuildId());
		if(git != m_guildChannels.end())
			return git->second;

		return NULL;
	}

	if(channelId == CHANNEL_PARTY)
	{
		if(player->getParty())
		{
			PartyChannelMap::iterator it = m_partyChannels.find(player->getParty());
			if(it != m_partyChannels.end())
				return it->second;
		}

		return NULL;
	}

	NormalChannelMap::iterator nit = m_normalChannels.find(channelId);
	if(nit != m_normalChannels.end())
	{
		#ifdef __DEBUG_CHAT__
		std::cout << "Chat::getChannel - found normal channel" << std::endl;
		#endif
		ChatChannel* tmpChannel = nit->second;
		if(!tmpChannel || !tmpChannel->hasFlag(CHANNELFLAG_ENABLED) || player->getAccess() < tmpChannel->getAccess()
			|| (!player->hasCustomFlag(PlayerCustomFlag_GamemasterPrivileges) && !tmpChannel->checkVocation(
			player->getVocationId())))
		{
			#ifdef __DEBUG_CHAT__
			std::cout << "Chat::getChannel - cannot access normal channel" << std::endl;
			#endif
			return NULL;
		}

		if(channelId == CHANNEL_RVR && !player->hasFlag(PlayerFlag_CanAnswerRuleViolations))
			return NULL;

		#ifdef __DEBUG_CHAT__
		std::cout << "Chat::getChannel - endpoint return" << std::endl;
		#endif
		return tmpChannel;
	}

	PrivateChannelMap::iterator pit = m_privateChannels.find(channelId);
	if(pit != m_privateChannels.end() && pit->second->isInvited(player))
		return pit->second;
		
	TVChannelMap::iterator tit = m_TVChannels.find(channelId);
	if(tit != m_TVChannels.end())
		return tit->second;

	return NULL;
}

ChatChannel* Chat::getChannelById(uint16_t channelId)
{
	NormalChannelMap::iterator it = m_normalChannels.find(channelId);
	if(it != m_normalChannels.end())
		return it->second;

	return NULL;
}

TVChannel* Chat::getTVChannelById(uint16_t channelId)
{
    TVChannelMap::iterator it = m_TVChannels.find(channelId);
    if(it != m_TVChannels.end())
        return it->second;
        
    return NULL;
}

PrivateChatChannel* Chat::getPrivateChannel(Player* player)
{
	if(!player || player->isRemoved())
		return NULL;

	PrivateChatChannel* channel = NULL;
	for(PrivateChannelMap::iterator it = m_privateChannels.begin(); it != m_privateChannels.end(); ++it)
	{
		if((channel = it->second) && channel->getOwner() == player->getGUID())
			return channel;
	}

	return NULL;
}

TVChannel* Chat::getTVChannel(Player* player)
{
	if(!player || player->isRemoved())
		return NULL;

	TVChannel* channel = NULL;
	for(TVChannelMap::iterator it = m_TVChannels.begin(); it != m_TVChannels.end(); ++it)
	{
		if((channel = it->second) && channel->getOwner() == player->getGUID())
			return channel;
	}

	return NULL;
}
