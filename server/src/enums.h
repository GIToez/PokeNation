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

#ifndef __ENUMS__
#define __ENUMS__

#include <string>
#include <list>

enum fightMode_t
{
	FIGHTMODE_ATTACK,
	FIGHTMODE_BALANCED,
	FIGHTMODE_DEFENSE
};

enum DatabaseEngine_t
{
	DATABASE_ENGINE_NONE = 0,
	DATABASE_ENGINE_MYSQL,
	DATABASE_ENGINE_SQLITE,
	DATABASE_ENGINE_POSTGRESQL,
	DATABASE_ENGINE_ODBC
};

enum Encryption_t
{
	ENCRYPTION_PLAIN = 0,
	ENCRYPTION_MD5,
	ENCRYPTION_SHA1,
	ENCRYPTION_SHA256
};

enum GuildLevel_t
{
	GUILDLEVEL_NONE = 0,
	GUILDLEVEL_MEMBER,
	GUILDLEVEL_VICE,
	GUILDLEVEL_LEADER
};

enum OperatingSystem_t
{
	CLIENTOS_LINUX = 0x01,
	CLIENTOS_WINDOWS = 0x02,
	CLIENTOS_FLASH = 0x03,
	CLIENTOS_OTCLIENT_WINDOWS = 0x0A,
    CLIENTOS_OTCLIENT_LINUX = 0x0B,
    CLIENTOS_OTCLIENT_MAC = 0x0C,
};

enum Channels_t
{
	CHANNEL_GUILD = 0x00,
	CHANNEL_PARTY = 0x01,
	CHANNEL_RVR = 0x03,
	CHANNEL_HELP = 0x09,
	CHANNEL_TOURNAMENT = 0x0D,
	CHANNEL_TV = 0xFFFD, // PS TV Channel
	CHANNEL_DEFAULT = 0xFFFE, //internal usage only, there is no such channel
	CHANNEL_PRIVATE = 0xFFFF
};

enum ViolationAction_t
{
	ACTION_NOTATION = 0,
	ACTION_NAMEREPORT,
	ACTION_BANISHMENT,
	ACTION_BANREPORT,
	ACTION_BANFINAL,
	ACTION_BANREPORTFINAL,
	ACTION_STATEMENT,
	//internal use
	ACTION_DELETION,
	ACTION_NAMELOCK,
	ACTION_BANLOCK,
	ACTION_BANLOCKFINAL,
	ACTION_PLACEHOLDER
};

enum RaceType_t
{
	RACE_NONE = 0,
	RACE_VENOM,
	RACE_BLOOD,
	RACE_UNDEAD,
	RACE_FIRE,
	RACE_ENERGY
};

enum CombatType_t
{
	COMBAT_FIRST		= 0,
	COMBAT_NONE		= COMBAT_FIRST,
	COMBAT_PHYSICALDAMAGE	= 1 << 0,
	COMBAT_ENERGYDAMAGE	= 1 << 1,
	COMBAT_EARTHDAMAGE	= 1 << 2,
	COMBAT_FIREDAMAGE	= 1 << 3,
	COMBAT_UNDEFINEDDAMAGE	= 1 << 4,
	COMBAT_LIFEDRAIN	= 1 << 5,
	COMBAT_MANADRAIN	= 1 << 6,
	COMBAT_HEALING		= 1 << 7,
	COMBAT_DROWNDAMAGE	= 1 << 8,
	COMBAT_ICEDAMAGE	= 1 << 9,
	COMBAT_HOLYDAMAGE	= 1 << 10,
	COMBAT_DEATHDAMAGE	= 1 << 11,
	COMBAT_NORMAL       = 1 << 12, // PS
	COMBAT_FIGHT        = 1 << 13,
	COMBAT_FLYING       = 1 << 14,
	COMBAT_POISON       = 1 << 15,
	COMBAT_GROUND       = 1 << 16,
	COMBAT_ROCK         = 1 << 17,
	COMBAT_BUG          = 1 << 18,
	COMBAT_GHOST        = 1 << 19,
	COMBAT_STEEL        = 1 << 20,
	COMBAT_FIRE         = 1 << 21,
	COMBAT_WATER        = 1 << 22,
	COMBAT_GRASS        = 1 << 23,
	COMBAT_ELECTRIC     = 1 << 24,
	COMBAT_PSYCHIC      = 1 << 25,
	COMBAT_ICE          = 1 << 26,
	COMBAT_DRAGON       = 1 << 27,
	COMBAT_DARK         = 1 << 28,
	COMBAT_LAST		= COMBAT_DEATHDAMAGE
};

enum CombatParam_t
{
	COMBATPARAM_NONE = 0,
	COMBATPARAM_COMBATTYPE,
	COMBATPARAM_EFFECT,
	COMBATPARAM_DISTANCEEFFECT,
	COMBATPARAM_BLOCKEDBYSHIELD,
	COMBATPARAM_BLOCKEDBYARMOR,
	COMBATPARAM_TARGETCASTERORTOPMOST,
	COMBATPARAM_CREATEITEM,
	COMBATPARAM_AGGRESSIVE,
	COMBATPARAM_DISPEL,
	COMBATPARAM_USECHARGES,
	COMBATPARAM_TARGETPLAYERSORSUMMONS,
	COMBATPARAM_DIFFERENTAREADAMAGE,
	COMBATPARAM_HITEFFECT,
	COMBATPARAM_HITCOLOR
};

enum CallBackParam_t
{
	CALLBACKPARAM_NONE = 0,
	CALLBACKPARAM_LEVELMAGICVALUE,
	CALLBACKPARAM_SKILLVALUE,
	CALLBACKPARAM_TARGETTILECALLBACK,
	CALLBACKPARAM_TARGETCREATURECALLBACK
};

enum ConditionParam_t
{
	CONDITIONPARAM_OWNER = 1,
	CONDITIONPARAM_TICKS = 2,
	CONDITIONPARAM_OUTFIT = 3,
	CONDITIONPARAM_HEALTHGAIN = 4,
	CONDITIONPARAM_HEALTHTICKS = 5,
	CONDITIONPARAM_MANAGAIN = 6,
	CONDITIONPARAM_MANATICKS = 7,
	CONDITIONPARAM_DELAYED = 8,
	CONDITIONPARAM_SPEED = 9,
	CONDITIONPARAM_LIGHT_LEVEL = 10,
	CONDITIONPARAM_LIGHT_COLOR = 11,
	CONDITIONPARAM_SOULGAIN = 12,
	CONDITIONPARAM_SOULTICKS = 13,
	CONDITIONPARAM_MINVALUE = 14,
	CONDITIONPARAM_MAXVALUE = 15,
	CONDITIONPARAM_STARTVALUE = 16,
	CONDITIONPARAM_TICKINTERVAL = 17,
	CONDITIONPARAM_FORCEUPDATE = 18,
	CONDITIONPARAM_SKILL_MELEE = 19,
	CONDITIONPARAM_SKILL_FIST = 20,
	CONDITIONPARAM_SKILL_CLUB = 21,
	CONDITIONPARAM_SKILL_SWORD = 22,
	CONDITIONPARAM_SKILL_AXE = 23,
	CONDITIONPARAM_SKILL_DISTANCE = 24,
	CONDITIONPARAM_SKILL_SHIELD = 25,
	CONDITIONPARAM_SKILL_FISHING = 26,
	CONDITIONPARAM_STAT_MAXHEALTH = 27,
	CONDITIONPARAM_STAT_MAXMANA = 28,
	CONDITIONPARAM_STAT_SOUL = 29,
	CONDITIONPARAM_STAT_MAGICLEVEL = 30,
	CONDITIONPARAM_STAT_MAXHEALTHPERCENT = 31,
	CONDITIONPARAM_STAT_MAXMANAPERCENT = 32,
	CONDITIONPARAM_STAT_SOULPERCENT = 33,
	CONDITIONPARAM_STAT_MAGICLEVELPERCENT = 34,
	CONDITIONPARAM_SKILL_MELEEPERCENT = 35,
	CONDITIONPARAM_SKILL_FISTPERCENT = 36,
	CONDITIONPARAM_SKILL_CLUBPERCENT = 37,
	CONDITIONPARAM_SKILL_SWORDPERCENT = 38,
	CONDITIONPARAM_SKILL_AXEPERCENT = 39,
	CONDITIONPARAM_SKILL_DISTANCEPERCENT = 40,
	CONDITIONPARAM_SKILL_SHIELDPERCENT = 41,
	CONDITIONPARAM_SKILL_FISHINGPERCENT = 42,
	CONDITIONPARAM_PERIODICDAMAGE = 43,
	CONDITIONPARAM_BUFF = 44,
	CONDITIONPARAM_SUBID = 45,
	CONDITIONPARAM_EFFECTTICKS = 46, // PS
};

enum BlockType_t
{
	BLOCK_NONE = 0,
	BLOCK_DEFENSE,
	BLOCK_ARMOR,
	BLOCK_IMMUNITY
};

enum Reflect_t
{
	REFLECT_FIRST = 0,
	REFLECT_PERCENT = REFLECT_FIRST,
	REFLECT_CHANCE,
	REFLECT_LAST = REFLECT_CHANCE
};

enum Increment_t
{
	INCREMENT_FIRST = 0,
	HEALING_VALUE = INCREMENT_FIRST,
	HEALING_PERCENT,
	MAGIC_VALUE,
	MAGIC_PERCENT,
	INCREMENT_LAST = MAGIC_PERCENT
};

enum skills_t
{
	SKILL_FIRST = 0,
	SKILL_FIST = SKILL_FIRST,
	SKILL_CLUB,
	SKILL_SWORD,
	SKILL_AXE,
	SKILL_DIST,
	SKILL_SHIELD,
	SKILL_FISH,
	SKILL__MAGLEVEL,
	SKILL__LEVEL,
	SKILL_LAST = SKILL_FISH,
	SKILL__LAST = SKILL__LEVEL
};

enum stats_t
{
	STAT_FIRST = 0,
	STAT_MAXHEALTH = STAT_FIRST,
	STAT_MAXMANA,
	STAT_SOUL,
	STAT_LEVEL,
	STAT_MAGICLEVEL,
	STAT_LAST = STAT_MAGICLEVEL
};

enum lossTypes_t
{
	LOSS_FIRST = 0,
	LOSS_EXPERIENCE = LOSS_FIRST,
	LOSS_MANA,
	LOSS_SKILLS,
	LOSS_CONTAINERS,
	LOSS_ITEMS,
	LOSS_LAST = LOSS_ITEMS
};

enum formulaType_t
{
	FORMULA_UNDEFINED = 0,
	FORMULA_LEVELMAGIC,
	FORMULA_SKILL,
	FORMULA_VALUE
};

enum ConditionId_t
{
	CONDITIONID_DEFAULT = -1,
	CONDITIONID_COMBAT = 0,
	CONDITIONID_HEAD,
	CONDITIONID_NECKLACE,
	CONDITIONID_BACKPACK,
	CONDITIONID_ARMOR,
	CONDITIONID_RIGHT,
	CONDITIONID_LEFT,
	CONDITIONID_LEGS,
	CONDITIONID_FEET,
	CONDITIONID_RING,
	CONDITIONID_AMMO,
	CONDITIONID_OUTFIT
};

enum PlayerSex_t
{
	PLAYERSEX_FEMALE = 0,
	PLAYERSEX_MALE
	// DO NOT ADD HERE! Every higher sex is only for your
	// own use- each female should be even and male odd.
};

struct Outfit_t
{
	Outfit_t() {lookHead = lookBody = lookLegs = lookFeet = lookType = lookTypeEx = lookAddons = 0;}
	uint16_t lookType, lookTypeEx;
	uint8_t lookHead, lookBody, lookLegs, lookFeet, lookAddons;

	bool operator==(const Outfit_t o) const
	{
		return (o.lookAddons == lookAddons
			&& o.lookType == lookType && o.lookTypeEx == lookTypeEx
			&& o.lookHead == lookHead && o.lookBody == lookBody
			&& o.lookLegs == lookLegs && o.lookFeet == lookFeet);
	}

	bool operator!=(const Outfit_t o) const
	{
		return !(*this == o);
	}
};

struct LightInfo
{
	uint32_t level, color;

	LightInfo() {level = color = 0;}
	LightInfo(uint32_t _level, uint32_t _color):
		level(_level), color(_color) {}
};

struct ShopInfo
{
	uint32_t itemId;
	int32_t subType, buyPrice, sellPrice;
	std::string itemName;

	ShopInfo()
	{
		itemId = 0;
		subType = 1;
		buyPrice = sellPrice = -1;
		itemName = "";
	}
	ShopInfo(uint32_t _itemId, int32_t _subType = 1, int32_t _buyPrice = -1, int32_t _sellPrice = -1,
		const std::string& _itemName = ""): itemId(_itemId), subType(_subType), buyPrice(_buyPrice),
		sellPrice(_sellPrice), itemName(_itemName) {}
};

typedef std::list<ShopInfo> ShopInfoList;

enum pokeStats_t
{
	POKESTAT_FIRST = 0,
	POKESTAT_MAXHEALTH = POKESTAT_FIRST,
	POKESTAT_ATTACK,
	POKESTAT_DEFENSE,
	POKESTAT_SPECIALATTACK,
	POKESTAT_SPECIALDEFENSE,
	POKESTAT_SPEED,
	POKESTAT_MAXENERGY,
	POKESTAT_LAST = POKESTAT_MAXENERGY
};

enum MarketAction_t {
	MARKETACTION_BUY = 0,
	MARKETACTION_SELL = 1
};

enum MarketRequest_t {
	MARKETREQUEST_OWN_OFFERS = 0xFFFE,
	MARKETREQUEST_OWN_HISTORY = 0xFFFF
};

enum MarketOfferState_t {
	OFFERSTATE_ACTIVE = 0,
	OFFERSTATE_CANCELLED = 1,
	OFFERSTATE_EXPIRED = 2,
	OFFERSTATE_ACCEPTED = 3,

	OFFERSTATE_ACCEPTEDEX = 255
};

struct MarketOffer {
	uint32_t price;
	uint32_t timestamp;
	uint16_t amount;
	uint16_t counter;
	uint16_t itemId;
	std::string playerName;
};

struct MarketOfferEx {
	MarketOfferEx() {}
	MarketOfferEx(uint32_t _id, uint32_t _playerId, uint32_t _timestamp, uint32_t _price,
                  uint16_t _amount, uint16_t _counter, uint16_t _itemId, MarketAction_t _type,
                  std::string _playerName) :
		id(_id), playerId(_playerId), timestamp(_timestamp), price(_price),
		amount(_amount), counter(_counter), itemId(_itemId), type(_type),
		playerName(_playerName) {}

	uint32_t id;
	uint32_t playerId;
	uint32_t timestamp;
	uint32_t price;
	uint16_t amount;
	uint16_t counter;
	uint16_t itemId;
	MarketAction_t type;
	std::string playerName;
};

struct ExpiredMarketOffer {
	uint32_t id;
	uint32_t price;
	uint16_t amount;
	uint16_t itemId;
	uint32_t playerId;
};

struct HistoryMarketOffer {
	uint32_t timestamp;
	uint32_t price;
	uint16_t itemId;
	uint16_t amount;
	MarketOfferState_t state;
};

struct MarketStatistics {
	MarketStatistics() {
		numTransactions = 0;
		highestPrice = 0;
		totalPrice = 0;
		lowestPrice = 0;
	}

	uint32_t numTransactions;
	uint32_t highestPrice;
	uint64_t totalPrice;
	uint32_t lowestPrice;
};

typedef std::list<MarketOffer> MarketOfferList;
typedef std::list<ExpiredMarketOffer> ExpiredMarketOfferList;
typedef std::list<HistoryMarketOffer> HistoryMarketOfferList;
#endif
