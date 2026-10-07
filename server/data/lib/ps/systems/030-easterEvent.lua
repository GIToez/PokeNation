if (EasterEvent) then
    return
end

EasterEvent = {}
--EasterEvent.FindTheEgg = {}
EasterEvent.ThisIsEaster = {}

-- Constants
--[[
EasterEvent.FindTheEgg.REWARDS = {}
EasterEvent.FindTheEgg.REWARDS[#EasterEvent.FindTheEgg.REWARDS + 1] = {
    pokemon = "Shiny Jynx",
    position = {x = 2747, y = 739, z = 7},
    globalStorage = 1005,
}

EasterEvent.FindTheEgg.REWARDS[#EasterEvent.FindTheEgg.REWARDS + 1] = {
    pokemon = "Shiny Magmar",
    position = {x = 3144, y = 292, z = 10},
    globalStorage = 1006,
}

EasterEvent.FindTheEgg.REWARDS[#EasterEvent.FindTheEgg.REWARDS + 1] = {
    pokemon = "Shiny Electabuzz",
    position = {x = 3602, y = 501, z = 7},
    globalStorage = 1007,
}

EasterEvent.FindTheEgg.STORAGE_STATUS = {}
EasterEvent.FindTheEgg.STORAGE_STATUS.AVAILABLE = -1
EasterEvent.FindTheEgg.STORAGE_STATUS.UNAVAILABLE = 1
]]

EasterEvent.ThisIsEaster.DAMAGE_MINIMUM_RATIO = 0.5
EasterEvent.ThisIsEaster.EASTER_EGG_ITEMID = 18794
EasterEvent.ThisIsEaster.EASTER_EGG_DROP_CHANCE = 40000 -- 40%

EasterEvent.ThisIsEaster.REWARDS = {
    {itemid = 25405, count = 1, chance = 500, unique = nil}, -- choco curtain
    {itemid = 25406, count = 1, chance = 500, unique = nil}, -- dream curtain
    {itemid = 25407, count = 1, chance = 500, unique = nil}, -- enigma curtain
  
    {itemid = 25408, count = 1, chance = 500, unique = nil}, -- blue easter backpack
    {itemid = 25409, count = 1, chance = 500, unique = nil}, -- green easter backpack
    {itemid = 25410, count = 1, chance = 500, unique = nil}, -- red easter backpack
    {itemid = 25411, count = 1, chance = 500, unique = nil}, -- yellow easter backpack
  
    {itemid = 25418, count = 1, chance = 500, unique = nil}, -- bluesky block
    {itemid = 25419, count = 1, chance = 500, unique = nil}, -- chocolate block
    {itemid = 25421, count = 1, chance = 500, unique = nil}, -- mint block
    {itemid = 25423, count = 1, chance = 500, unique = nil}, -- vanilla block
    
    {itemid = 25412, count = 1, chance = 50, unique = nil}, -- blue easter doll
    {itemid = 25413, count = 1, chance = 10, unique = nil}, -- easter doll
    {itemid = 25414, count = 1, chance = 50, unique = nil}, -- green easter doll
    {itemid = 25415, count = 1, chance = 50, unique = nil}, -- red easter doll
    {itemid = 25416, count = 1, chance = 50, unique = nil}, -- yellow easter doll
    
    {itemid = 25394, count = 1, chance = 100, unique = nil}, -- blue chocoegg paint ticket
    {itemid = 25395, count = 1, chance = 100, unique = nil}, -- brown chocoegg paint ticket
    {itemid = 25396, count = 1, chance = 100, unique = nil}, -- golden easter paint ticket
    {itemid = 25397, count = 1, chance = 100, unique = nil}, -- king chocoegg paint ticket
    {itemid = 25398, count = 1, chance = 100, unique = nil}, -- mint chocoegg paint ticket
    {itemid = 25399, count = 1, chance = 100, unique = nil}, -- ocean chocoegg paint ticket
    {itemid = 25400, count = 1, chance = 100, unique = nil}, -- orange chocoegg paint ticket
    {itemid = 25401, count = 1, chance = 100, unique = nil}, -- pink chocoegg paint ticket
    {itemid = 25402, count = 1, chance = 100, unique = nil}, -- purple chocoegg paint ticket
    {itemid = 25403, count = 1, chance = 100, unique = nil}, -- red chocoegg paint ticket
    {itemid = 25404, count = 1, chance = 100, unique = nil}, -- yellow chocoegg paint ticket
    {itemid = 25433, count = 1, chance = 100, unique = nil}, -- green chocoegg paint ticket
  
    {itemid = 24549, count = 1, chance = 25000, unique = nil, onReceive = function(cid) doPlayerAchievementCheck(cid, ACHIEVEMENT_IDS.GOLDEN_EGG) end}, -- golden easter egg
    {itemid = 6541, count = 1, chance = 20000, unique = nil}, -- coloured egg
    {itemid = 6542, count = 1, chance = 20000, unique = nil}, -- coloured egg
    {itemid = 6543, count = 1, chance = 20000, unique = nil}, -- coloured egg
    {itemid = 6544, count = 1, chance = 20000, unique = nil}, -- coloured egg
    {itemid = 6545, count = 1, chance = 20000, unique = nil}, -- coloured egg
    {itemid = 6574, mincount = 1, maxcount = 3, chance = 40000, unique = nil}, -- bar of chocolate
    {itemid = 18837,count = 1, chance = 10, unique = nil}, -- furniture package
    {itemid = 18838,count = 1, chance = 10, unique = nil}, -- furniture package
    {itemid = 18839,count = 1, chance = 10, unique = nil}, -- furniture package
    {itemid = 18840,count = 1, chance = 10, unique = nil}, -- furniture package
    {itemid = 18841,count = 1, chance = 10, unique = nil}, -- furniture package
    {itemid = 18842,count = 1, chance = 10, unique = nil}, -- furniture package
    {itemid = 18843,count = 1, chance = 10, unique = nil}, -- furniture package
    {itemid = 18844,count = 1, chance = 10, unique = nil}, -- furniture package
    {itemid = 18845,count = 1, chance = 10, unique = nil}, -- furniture package
    {itemid = 18846,count = 1, chance = 10, unique = nil}, -- furniture package
    {itemid = 18847,count = 1, chance = 10, unique = nil}, -- furniture package
    {itemid = 18848,count = 1, chance = 10, unique = nil}, -- furniture package
    {itemid = 18849,count = 1, chance = 10, unique = nil}, -- furniture package
    {itemid = 18850,count = 1, chance = 10, unique = nil}, -- furniture package
    {itemid = 18851,count = 1, chance = 100, unique = nil}, -- easter #1 clothes kit
    {itemid = 18867,count = 1, chance = 100, unique = nil}, -- blue egg paint ticket
    {itemid = 18868,count = 1, chance = 100, unique = nil}, -- carrot paint ticket
    {itemid = 18869,count = 1, chance = 100, unique = nil}, -- chocolate paint ticket
    {itemid = 18870,count = 1, chance = 100, unique = nil}, -- green egg paint ticket
    {itemid = 18871,count = 1, chance = 100, unique = nil}, -- white egg paint ticket
}

-- Methods
--[[
EasterEvent.FindTheEgg.onPlayerDig = function(cid, position)
    for _, reward in pairs(EasterEvent.FindTheEgg.REWARDS) do
        if (doComparePositions(position, reward.position)) then
            if (getStorage(reward.globalStorage) == EasterEvent.FindTheEgg.STORAGE_STATUS.AVAILABLE) then
                doSetStorage(reward.globalStorage, EasterEvent.FindTheEgg.STORAGE_STATUS.UNAVAILABLE)
                doCreatePokemonBall(cid, "poke", reward.pokemon, 1, nil, nil, 10, nil, false, 999999)
                doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Congratulations! You have found a Find the Egg event spot!")
                doBroadcastMessage(string.concat(getCreatureName(cid), " found a Find the Egg event spot!"))

            else
                doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Ergh! This spot is empty.")
            end

            doPlayerAchievementCheck(cid, ACHIEVEMENT_IDS.EASTER_FIND_THE_EGG)
        end
    end
end
]]

EasterEvent.ThisIsEaster.onPlayerKill = function(cid, target, lastHit)
    if (not isPokemonName(getCreatureName(target)) or
            getCreatureDamageRatioByMaster(target, cid) < EasterEvent.ThisIsEaster.DAMAGE_MINIMUM_RATIO) then
        return
    end

    if (getRandom(RANDOM_CHANCE_MIN, RANDOM_CHANCE_MAX) <= EasterEvent.ThisIsEaster.EASTER_EGG_DROP_CHANCE * (getMonsterLevel(target) / 100)) then
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "You have found an easter egg's.")
        doPlayerSafeAddItem(cid, EasterEvent.ThisIsEaster.EASTER_EGG_ITEMID, 1, true, true)
        doPlayerAchievementCheck(cid, ACHIEVEMENT_IDS.EASTER_THIS_IS_EASTER)
    end
end

EasterEvent.ThisIsEaster.onPlayerUseEaster = function(cid, item)
    doRemoveItem(item.uid, 1)
    doSendMagicEffect(getCreaturePosition(cid), EFFECT_FIREWORK_YELLOW)
    doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Easter egg's contains: ")

    local nothing = true
    for _, item in pairs(EasterEvent.ThisIsEaster.REWARDS) do
        if (not item.chance or getRandom(RANDOM_CHANCE_MIN, RANDOM_CHANCE_MAX) <= item.chance) then
            local count = ((item.mincount and item.maxcount) and getRandom(item.mincount, item.maxcount) or
                    item.count)
            nothing = false
            doPlayerSafeAddItem(cid, item.itemid, count, true, item.unique)
            doDatalogEasterDrops(getPlayerGUID(cid), item.itemid, count, os.time())
            if (item.onReceive) then
                item.onReceive(cid)
            end
        end
    end

    if (nothing) then
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Nothing.")
    end
end

local EASTER_POKEMON = {
    ["Pikachu"] = "Easter Pikachu",
    ["Squirtle"] = "Easter Squirtle",
    ["Charmander"] = "Easter Charmander",
    ["Bulbasaur"] = "Easter Bulbasaur"
}
local EASTER_POKEMON_CHANCE = 10

EasterEvent.OnSpawn = function(cid)
    local name = getCreatureName(cid)
    if (EASTER_POKEMON[name] and getRandom(1, EASTER_POKEMON_CHANCE) <= 1) then
        local r = doCreateMonster(EASTER_POKEMON[name], getCreaturePosition(cid), false)
        if (not isBoolean(r)) then
            addEvent(doRemoveCreature, 1000, cid)
            setMonsterSpecialAbility(r, getPokemonRandomSpecialAbility(getCreatureName(r)))
            doSendMagicEffect(getCreaturePosition(r), EFFECT_TELEPORT_DOWN)
            return true
        end
    end

    return false
end

local DELICIOUS_MACHINES = {}
DELICIOUS_MACHINES[25425] = {jujubeItemId = 25417, lastUseAttribute = 1000, lastUsePlayerStorage = playersStorages.blueDeliciousMachineLastUse, textColor = TEXTCOLOR_BLUE} -- blue
DELICIOUS_MACHINES[25426] = {jujubeItemId = 25420, lastUseAttribute = 1000, lastUsePlayerStorage = playersStorages.greenDeliciousMachineLastUse, textColor = TEXTCOLOR_GREEN} -- green
DELICIOUS_MACHINES[25427] = {jujubeItemId = 25422, lastUseAttribute = 1000, lastUsePlayerStorage = playersStorages.redDeliciousMachineLastUse, textColor = TEXTCOLOR_RED} -- red
DELICIOUS_MACHINES[25428] = {jujubeItemId = 25424, lastUseAttribute = 1000, lastUsePlayerStorage = playersStorages.yellowDeliciousMachineLastUse, textColor = TEXTCOLOR_YELLOW} -- yellow

local DELICIOUS_MACHINE_USE_INTERNVAL = 60 * 60
local DELICIOUS_MACHINE_JUJUBE_MAX_COUNT = 3

EasterEvent.onPlayerUseDeliciousMachine = function(cid, item, fromPosition, itemEx, toPosition)
  local machine = DELICIOUS_MACHINES[item.itemid]
  if (not machine) then
    log(LOG_TYPES.ERROR, "EasterEvent::onPlayerUseDeliciousMachine - Unknown machine", getCreatureName(cid), item, fromPosition, itemEx, toPosition)
    doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
    return true
  end
  
  if (not getHouseFromPos(fromPosition)) then
    doPlayerSendCancel(cid, "You must use it inside a house.")
    return true
  end
  
  local currentDate = getCurrentTimeInSeconds()
	local machineInterval = getItemAttribute(item.uid, machine.lastUseAttribute) or currentDate
	local remaingTime = machineInterval - currentDate

	if (remaingTime > 0) then
    if (remaingTime > DELICIOUS_MACHINE_USE_INTERNVAL) then -- bug-ugly-fix
      remaingTime = DELICIOUS_MACHINE_USE_INTERNVAL
      doItemSetAttribute(item.uid, machine.lastUseAttribute, getCurrentTimeInSeconds())
    end
    
    doPlayerSendCancel(cid, string.format(__L(cid, "You must wait %s to generate another jujube on this machine."), table.concat(string.timediff(remaingTime, cid))))
    return true
	end
  
  currentDate = os.time()
  local playerInterval = getCreatureStorage(cid, machine. lastUsePlayerStorage) or currentDate
  remaingTime = playerInterval - currentDate
  
  if (remaingTime > 0) then    
    doPlayerSendCancel(cid, string.format(__L(cid, "You must wait %s to generate another jujube on this machine."), table.concat(string.timediff(remaingTime, cid))))
    return true
	end
  
  doItemSetAttribute(item.uid, machine.lastUseAttribute, getCurrentTimeInSeconds() + DELICIOUS_MACHINE_USE_INTERNVAL)
  doCreatureSetStorage(cid, machine.lastUsePlayerStorage, os.time() + DELICIOUS_MACHINE_USE_INTERNVAL)
  
  local count = getRandom(1, DELICIOUS_MACHINE_JUJUBE_MAX_COUNT)
  doPlayerSafeAddItem(cid, machine.jujubeItemId, count, true)
  
  doSendMagicEffect(fromPosition, EFFECT_FIREWORK_YELLOW)
  doSendAnimatedText(fromPosition, "Brump!", machine.textColor)
  
  return true
end

local EASTER_OUTFITS = {}

EASTER_OUTFITS[25429] = createConditionObject(CONDITION_OUTFIT, -1, nil, CONDITION_SUBID.OUTFITS.EASTER)-- black
addOutfitCondition(EASTER_OUTFITS[25429], {lookType = 1430})

EASTER_OUTFITS[25432] = createConditionObject(CONDITION_OUTFIT, -1, nil, CONDITION_SUBID.OUTFITS.EASTER)-- white
addOutfitCondition(EASTER_OUTFITS[25432], {lookType = 1429})

local FREE_SHOES = {}
FREE_SHOES[25429] = 25434 -- black free
FREE_SHOES[25432] = 25435 -- white free

local LOCKED_SHOES = {}
LOCKED_SHOES[25434] = 25429 -- black locked
LOCKED_SHOES[25435] = 25432 -- white locked

EasterEvent.onUseShoes = function(cid, item)
    local shoes, locked
    if (FREE_SHOES[item.itemid]) then
        shoes = FREE_SHOES[item.itemid]
        locked = true
    elseif (LOCKED_SHOES[item.itemid]) then
        shoes = LOCKED_SHOES[item.itemid]
        locked = false
    else
        log(LOG_TYPES.ERROR, "EasterEvent::Shoes - Unknown shoes", getCreatureName(cid), item)
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true
    end

    if (getPlayerMounted(cid) or isBiking(cid)) then
        return false
    end

    doSendMagicEffect(getCreaturePosition(cid), EFFECT_PURPLE_ENERGIZE)
    if (locked) then
        doAddCondition(cid, EASTER_OUTFITS[item.itemid])
    else
        doRemoveCondition(cid, CONDITION_OUTFIT, CONDITION_SUBID.OUTFITS.EASTER)
    end
    doTransformItem(item.uid, shoes)

    return true
end