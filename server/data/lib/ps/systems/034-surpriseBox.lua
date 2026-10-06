if (SurpriseBox) then
    return
end

SurpriseBox = {}

-- Constants
local MAP_MAX_WIDTH = 2048
local MAP_MAX_HEIGHT = 3207
local SURPRISE_BOX_ITEMID = 18898
local POSITION_Z_MAX = 15
local SKIP_GROUND_IDS = WATER_IDS
local MAP_BOXES = 10
local SPAWN_INTERVAL = 2 * 60 * 60 * 1000
local GENERATE_UNIQUE = false
local SEND_TO_DEPOT = true
local SHOW_MESSAGE = true

local SKIP_AREAS = {
    {fromPosition = {x = 4313, y = 167, z = 7}, toPosition = {x = 5554, y = 1225, z = 7}}, -- Limbo
}

local ITEMS = {
    {maxLevel = 30, items = {
        {itemId = 18908, minCount = 1, maxCount = 1, chance = 1000}, -- Fire Paint Ticket 1%
        {itemId = 18909, minCount = 1, maxCount = 1, chance = 1000}, -- Thunder Paint Ticket 1%
        {itemId = 18910, minCount = 1, maxCount = 1, chance = 1000}, -- Water Paint Ticket 1%
        {itemId = 27730, minCount = 1, maxCount = 1, chance = 1000}, -- Bug Paint Ticket 1%
        {itemId = 27731, minCount = 1, maxCount = 1, chance = 1000}, -- Insect Paint Ticket 1%
        {itemId = 27732, minCount = 1, maxCount = 1, chance = 1000}, -- Dark Paint Ticket 1%
        {itemId = 27733, minCount = 1, maxCount = 1, chance = 1000}, -- Dread Paint Ticket 1%
        {itemId = 27734, minCount = 1, maxCount = 1, chance = 1000}, -- Draco Paint Ticket 1%
        {itemId = 27735, minCount = 1, maxCount = 1, chance = 1000}, -- Dragon Paint Ticket 1%
        {itemId = 27736, minCount = 1, maxCount = 1, chance = 1000}, -- Electric Paint Ticket 1%
        {itemId = 27737, minCount = 1, maxCount = 1, chance = 1000}, -- Pixie Paint Ticket 1%
        {itemId = 27738, minCount = 1, maxCount = 1, chance = 1000}, -- Fighting Paint Ticket 1%
        {itemId = 27739, minCount = 1, maxCount = 1, chance = 1000}, -- Fist Paint Ticket 1%
        {itemId = 27740, minCount = 1, maxCount = 1, chance = 1000}, -- Fire Paint Ticket 1%
        {itemId = 27741, minCount = 1, maxCount = 1, chance = 1000}, -- Flying Paint Ticket 1%
        {itemId = 27742, minCount = 1, maxCount = 1, chance = 1000}, -- Sky Paint Ticket 1%
        {itemId = 27743, minCount = 1, maxCount = 1, chance = 1000}, -- Ghost Paint Ticket 1%
        {itemId = 27744, minCount = 1, maxCount = 1, chance = 1000}, -- Spooky Paint Ticket 1%
        {itemId = 27745, minCount = 1, maxCount = 1, chance = 1000}, -- Grass Paint Ticket 1%
        {itemId = 27746, minCount = 1, maxCount = 1, chance = 1000}, -- Meadow Paint Ticket 1%
        {itemId = 27747, minCount = 1, maxCount = 1, chance = 1000}, -- Earth Paint Ticket 1%
        {itemId = 27748, minCount = 1, maxCount = 1, chance = 1000}, -- Ground Paint Ticket 1%
        {itemId = 27749, minCount = 1, maxCount = 1, chance = 1000}, -- Ice Paint Ticket 1%
        {itemId = 27750, minCount = 1, maxCount = 1, chance = 1000}, -- Icicle Paint Ticket 1%
        {itemId = 27751, minCount = 1, maxCount = 1, chance = 1000}, -- Normal Paint Ticket 1%
        {itemId = 27752, minCount = 1, maxCount = 1, chance = 1000}, -- Plate Paint Ticket 1%
        {itemId = 27753, minCount = 1, maxCount = 1, chance = 1000}, -- Poison Paint Ticket 1%
        {itemId = 27754, minCount = 1, maxCount = 1, chance = 1000}, -- Toxic Paint Ticket 1%
        {itemId = 27755, minCount = 1, maxCount = 1, chance = 1000}, -- Mind Paint Ticket 1%
        {itemId = 27756, minCount = 1, maxCount = 1, chance = 1000}, -- Psychic Paint Ticket 1%
        {itemId = 27757, minCount = 1, maxCount = 1, chance = 1000}, -- Rock Paint Ticket 1%
        {itemId = 27758, minCount = 1, maxCount = 1, chance = 1000}, -- Stone Paint Ticket 1%
        {itemId = 27759, minCount = 1, maxCount = 1, chance = 1000}, -- Iron Paint Ticket 1%
        {itemId = 27760, minCount = 1, maxCount = 1, chance = 1000}, -- Steel Paint Ticket 1%
        {itemId = 27761, minCount = 1, maxCount = 1, chance = 1000}, -- Water Paint Ticket 1%
        {itemId = 27762, minCount = 1, maxCount = 1, chance = 1000}, -- Fairy Paint Ticket 1%
        
        {itemId = 18911, minCount = 1, maxCount = 1, chance = 1000}, -- Researcher Clothes Kit 1%
        {itemId = 12248, minCount = 1, maxCount = 5, chance = 5000}, -- Pokemon Revive 1-5 5%
        {itemId = 12244, minCount = 10, maxCount = 30, chance = 10000}, -- Pokemon Health Potion 10-30 10%
        {itemId = 13653, minCount = 1, maxCount = 10, chance = 10000}, -- Pokemon Energy Potion 1-10 10%
        {itemId = 12161, minCount = 1, maxCount = 15, chance = 10000}, -- Empty Great Ball 1-30 10%
        {itemId = 12157, minCount = 10, maxCount = 50, chance = RANDOM_CHANCE_MAX} -- Empty Poke Ball 10-100 100%
    }},
    {maxLevel = 50, items = {
       {itemId = 18908, minCount = 1, maxCount = 1, chance = 1000}, -- Fire Paint Ticket 1%
        {itemId = 18909, minCount = 1, maxCount = 1, chance = 1000}, -- Thunder Paint Ticket 1%
        {itemId = 18910, minCount = 1, maxCount = 1, chance = 1000}, -- Water Paint Ticket 1%
        {itemId = 27730, minCount = 1, maxCount = 1, chance = 1000}, -- Bug Paint Ticket 1%
        {itemId = 27731, minCount = 1, maxCount = 1, chance = 1000}, -- Insect Paint Ticket 1%
        {itemId = 27732, minCount = 1, maxCount = 1, chance = 1000}, -- Dark Paint Ticket 1%
        {itemId = 27733, minCount = 1, maxCount = 1, chance = 1000}, -- Dread Paint Ticket 1%
        {itemId = 27734, minCount = 1, maxCount = 1, chance = 1000}, -- Draco Paint Ticket 1%
        {itemId = 27735, minCount = 1, maxCount = 1, chance = 1000}, -- Dragon Paint Ticket 1%
        {itemId = 27736, minCount = 1, maxCount = 1, chance = 1000}, -- Electric Paint Ticket 1%
        {itemId = 27737, minCount = 1, maxCount = 1, chance = 1000}, -- Pixie Paint Ticket 1%
        {itemId = 27738, minCount = 1, maxCount = 1, chance = 1000}, -- Fighting Paint Ticket 1%
        {itemId = 27739, minCount = 1, maxCount = 1, chance = 1000}, -- Fist Paint Ticket 1%
        {itemId = 27740, minCount = 1, maxCount = 1, chance = 1000}, -- Fire Paint Ticket 1%
        {itemId = 27741, minCount = 1, maxCount = 1, chance = 1000}, -- Flying Paint Ticket 1%
        {itemId = 27742, minCount = 1, maxCount = 1, chance = 1000}, -- Sky Paint Ticket 1%
        {itemId = 27743, minCount = 1, maxCount = 1, chance = 1000}, -- Ghost Paint Ticket 1%
        {itemId = 27744, minCount = 1, maxCount = 1, chance = 1000}, -- Spooky Paint Ticket 1%
        {itemId = 27745, minCount = 1, maxCount = 1, chance = 1000}, -- Grass Paint Ticket 1%
        {itemId = 27746, minCount = 1, maxCount = 1, chance = 1000}, -- Meadow Paint Ticket 1%
        {itemId = 27747, minCount = 1, maxCount = 1, chance = 1000}, -- Earth Paint Ticket 1%
        {itemId = 27748, minCount = 1, maxCount = 1, chance = 1000}, -- Ground Paint Ticket 1%
        {itemId = 27749, minCount = 1, maxCount = 1, chance = 1000}, -- Ice Paint Ticket 1%
        {itemId = 27750, minCount = 1, maxCount = 1, chance = 1000}, -- Icicle Paint Ticket 1%
        {itemId = 27751, minCount = 1, maxCount = 1, chance = 1000}, -- Normal Paint Ticket 1%
        {itemId = 27752, minCount = 1, maxCount = 1, chance = 1000}, -- Plate Paint Ticket 1%
        {itemId = 27753, minCount = 1, maxCount = 1, chance = 1000}, -- Poison Paint Ticket 1%
        {itemId = 27754, minCount = 1, maxCount = 1, chance = 1000}, -- Toxic Paint Ticket 1%
        {itemId = 27755, minCount = 1, maxCount = 1, chance = 1000}, -- Mind Paint Ticket 1%
        {itemId = 27756, minCount = 1, maxCount = 1, chance = 1000}, -- Psychic Paint Ticket 1%
        {itemId = 27757, minCount = 1, maxCount = 1, chance = 1000}, -- Rock Paint Ticket 1%
        {itemId = 27758, minCount = 1, maxCount = 1, chance = 1000}, -- Stone Paint Ticket 1%
        {itemId = 27759, minCount = 1, maxCount = 1, chance = 1000}, -- Iron Paint Ticket 1%
        {itemId = 27760, minCount = 1, maxCount = 1, chance = 1000}, -- Steel Paint Ticket 1%
        {itemId = 27761, minCount = 1, maxCount = 1, chance = 1000}, -- Water Paint Ticket 1%
        {itemId = 27762, minCount = 1, maxCount = 1, chance = 1000}, -- Fairy Paint Ticket 1%
        
        {itemId = 18911, minCount = 1, maxCount = 1, chance = 1000}, -- Researcher Clothes Kit 1%
        {itemId = 12248, minCount = 10, maxCount = 20, chance = 5000}, -- Pokemon Revive 10-20 5%
        {itemId = 12246, minCount = 5, maxCount = 20, chance = 10000}, -- Pokemon Ultra Health Potion 5-20 10%
        {itemId = 12245, minCount = 10, maxCount = 30, chance = 10000}, -- Pokemon Great Health Potion 10-30 10%
        {itemId = 13819, minCount = 10, maxCount = 30, chance = 10000}, -- Pokemon Great Energy Potion 10-30 10%
        {itemId = 13653, minCount = 20, maxCount = 50, chance = 10000}, -- Pokemon Energy Potion 20-50 10%
        {itemId = 12165, minCount = 30, maxCount = 30, chance = 10000}, -- Empty Ultra Ball 30-60 10%
        {itemId = 12161, minCount = 10, maxCount = 50, chance = RANDOM_CHANCE_MAX} -- Empty Great Ball 10-100 100%
    }},
    {maxLevel = 80, items = {
        {itemId = 18908, minCount = 1, maxCount = 1, chance = 1000}, -- Fire Paint Ticket 1%
        {itemId = 18909, minCount = 1, maxCount = 1, chance = 1000}, -- Thunder Paint Ticket 1%
        {itemId = 18910, minCount = 1, maxCount = 1, chance = 1000}, -- Water Paint Ticket 1%
        {itemId = 27730, minCount = 1, maxCount = 1, chance = 1000}, -- Bug Paint Ticket 1%
        {itemId = 27731, minCount = 1, maxCount = 1, chance = 1000}, -- Insect Paint Ticket 1%
        {itemId = 27732, minCount = 1, maxCount = 1, chance = 1000}, -- Dark Paint Ticket 1%
        {itemId = 27733, minCount = 1, maxCount = 1, chance = 1000}, -- Dread Paint Ticket 1%
        {itemId = 27734, minCount = 1, maxCount = 1, chance = 1000}, -- Draco Paint Ticket 1%
        {itemId = 27735, minCount = 1, maxCount = 1, chance = 1000}, -- Dragon Paint Ticket 1%
        {itemId = 27736, minCount = 1, maxCount = 1, chance = 1000}, -- Electric Paint Ticket 1%
        {itemId = 27737, minCount = 1, maxCount = 1, chance = 1000}, -- Pixie Paint Ticket 1%
        {itemId = 27738, minCount = 1, maxCount = 1, chance = 1000}, -- Fighting Paint Ticket 1%
        {itemId = 27739, minCount = 1, maxCount = 1, chance = 1000}, -- Fist Paint Ticket 1%
        {itemId = 27740, minCount = 1, maxCount = 1, chance = 1000}, -- Fire Paint Ticket 1%
        {itemId = 27741, minCount = 1, maxCount = 1, chance = 1000}, -- Flying Paint Ticket 1%
        {itemId = 27742, minCount = 1, maxCount = 1, chance = 1000}, -- Sky Paint Ticket 1%
        {itemId = 27743, minCount = 1, maxCount = 1, chance = 1000}, -- Ghost Paint Ticket 1%
        {itemId = 27744, minCount = 1, maxCount = 1, chance = 1000}, -- Spooky Paint Ticket 1%
        {itemId = 27745, minCount = 1, maxCount = 1, chance = 1000}, -- Grass Paint Ticket 1%
        {itemId = 27746, minCount = 1, maxCount = 1, chance = 1000}, -- Meadow Paint Ticket 1%
        {itemId = 27747, minCount = 1, maxCount = 1, chance = 1000}, -- Earth Paint Ticket 1%
        {itemId = 27748, minCount = 1, maxCount = 1, chance = 1000}, -- Ground Paint Ticket 1%
        {itemId = 27749, minCount = 1, maxCount = 1, chance = 1000}, -- Ice Paint Ticket 1%
        {itemId = 27750, minCount = 1, maxCount = 1, chance = 1000}, -- Icicle Paint Ticket 1%
        {itemId = 27751, minCount = 1, maxCount = 1, chance = 1000}, -- Normal Paint Ticket 1%
        {itemId = 27752, minCount = 1, maxCount = 1, chance = 1000}, -- Plate Paint Ticket 1%
        {itemId = 27753, minCount = 1, maxCount = 1, chance = 1000}, -- Poison Paint Ticket 1%
        {itemId = 27754, minCount = 1, maxCount = 1, chance = 1000}, -- Toxic Paint Ticket 1%
        {itemId = 27755, minCount = 1, maxCount = 1, chance = 1000}, -- Mind Paint Ticket 1%
        {itemId = 27756, minCount = 1, maxCount = 1, chance = 1000}, -- Psychic Paint Ticket 1%
        {itemId = 27757, minCount = 1, maxCount = 1, chance = 1000}, -- Rock Paint Ticket 1%
        {itemId = 27758, minCount = 1, maxCount = 1, chance = 1000}, -- Stone Paint Ticket 1%
        {itemId = 27759, minCount = 1, maxCount = 1, chance = 1000}, -- Iron Paint Ticket 1%
        {itemId = 27760, minCount = 1, maxCount = 1, chance = 1000}, -- Steel Paint Ticket 1%
        {itemId = 27761, minCount = 1, maxCount = 1, chance = 1000}, -- Water Paint Ticket 1%
        {itemId = 27762, minCount = 1, maxCount = 1, chance = 1000}, -- Fairy Paint Ticket 1%
        
        {itemId = 18911, minCount = 1, maxCount = 1, chance = 1000}, -- Researcher Clothes Kit 1%
        {itemId = 12248, minCount = 20, maxCount = 30, chance = 5000}, -- Pokemon Revive 20-30 5%
        {itemId = 12247, minCount = 10, maxCount = 30, chance = 10000}, -- Pokemon Super Health Potion 10-30 10%
        {itemId = 12245, minCount = 20, maxCount = 30, chance = 10000}, -- Pokemon Ultra Health Potion 20-30 10%
        {itemId = 13819, minCount = 20, maxCount = 50, chance = 10000}, -- Pokemon Great Energy Potion 20-50 10%
        {itemId = 13653, minCount = 30, maxCount = 30, chance = 10000}, -- Pokemon Energy Potion 30-60 10%
        {itemId = 12165, minCount = 10, maxCount = 50, chance = RANDOM_CHANCE_MAX} -- Empty Ultra Ball 10-100 100%
    }},
    {items = {
        {itemId = 18908, minCount = 1, maxCount = 1, chance = 1000}, -- Fire Paint Ticket 1%
        {itemId = 18909, minCount = 1, maxCount = 1, chance = 1000}, -- Thunder Paint Ticket 1%
        {itemId = 18910, minCount = 1, maxCount = 1, chance = 1000}, -- Water Paint Ticket 1%
        {itemId = 27730, minCount = 1, maxCount = 1, chance = 1000}, -- Bug Paint Ticket 1%
        {itemId = 27731, minCount = 1, maxCount = 1, chance = 1000}, -- Insect Paint Ticket 1%
        {itemId = 27732, minCount = 1, maxCount = 1, chance = 1000}, -- Dark Paint Ticket 1%
        {itemId = 27733, minCount = 1, maxCount = 1, chance = 1000}, -- Dread Paint Ticket 1%
        {itemId = 27734, minCount = 1, maxCount = 1, chance = 1000}, -- Draco Paint Ticket 1%
        {itemId = 27735, minCount = 1, maxCount = 1, chance = 1000}, -- Dragon Paint Ticket 1%
        {itemId = 27736, minCount = 1, maxCount = 1, chance = 1000}, -- Electric Paint Ticket 1%
        {itemId = 27737, minCount = 1, maxCount = 1, chance = 1000}, -- Pixie Paint Ticket 1%
        {itemId = 27738, minCount = 1, maxCount = 1, chance = 1000}, -- Fighting Paint Ticket 1%
        {itemId = 27739, minCount = 1, maxCount = 1, chance = 1000}, -- Fist Paint Ticket 1%
        {itemId = 27740, minCount = 1, maxCount = 1, chance = 1000}, -- Fire Paint Ticket 1%
        {itemId = 27741, minCount = 1, maxCount = 1, chance = 1000}, -- Flying Paint Ticket 1%
        {itemId = 27742, minCount = 1, maxCount = 1, chance = 1000}, -- Sky Paint Ticket 1%
        {itemId = 27743, minCount = 1, maxCount = 1, chance = 1000}, -- Ghost Paint Ticket 1%
        {itemId = 27744, minCount = 1, maxCount = 1, chance = 1000}, -- Spooky Paint Ticket 1%
        {itemId = 27745, minCount = 1, maxCount = 1, chance = 1000}, -- Grass Paint Ticket 1%
        {itemId = 27746, minCount = 1, maxCount = 1, chance = 1000}, -- Meadow Paint Ticket 1%
        {itemId = 27747, minCount = 1, maxCount = 1, chance = 1000}, -- Earth Paint Ticket 1%
        {itemId = 27748, minCount = 1, maxCount = 1, chance = 1000}, -- Ground Paint Ticket 1%
        {itemId = 27749, minCount = 1, maxCount = 1, chance = 1000}, -- Ice Paint Ticket 1%
        {itemId = 27750, minCount = 1, maxCount = 1, chance = 1000}, -- Icicle Paint Ticket 1%
        {itemId = 27751, minCount = 1, maxCount = 1, chance = 1000}, -- Normal Paint Ticket 1%
        {itemId = 27752, minCount = 1, maxCount = 1, chance = 1000}, -- Plate Paint Ticket 1%
        {itemId = 27753, minCount = 1, maxCount = 1, chance = 1000}, -- Poison Paint Ticket 1%
        {itemId = 27754, minCount = 1, maxCount = 1, chance = 1000}, -- Toxic Paint Ticket 1%
        {itemId = 27755, minCount = 1, maxCount = 1, chance = 1000}, -- Mind Paint Ticket 1%
        {itemId = 27756, minCount = 1, maxCount = 1, chance = 1000}, -- Psychic Paint Ticket 1%
        {itemId = 27757, minCount = 1, maxCount = 1, chance = 1000}, -- Rock Paint Ticket 1%
        {itemId = 27758, minCount = 1, maxCount = 1, chance = 1000}, -- Stone Paint Ticket 1%
        {itemId = 27759, minCount = 1, maxCount = 1, chance = 1000}, -- Iron Paint Ticket 1%
        {itemId = 27760, minCount = 1, maxCount = 1, chance = 1000}, -- Steel Paint Ticket 1%
        {itemId = 27761, minCount = 1, maxCount = 1, chance = 1000}, -- Water Paint Ticket 1%
        {itemId = 27762, minCount = 1, maxCount = 1, chance = 1000}, -- Fairy Paint Ticket 1%
        
        {itemId = 18911, minCount = 1, maxCount = 1, chance = 1000}, -- Researcher Clothes Kit 1%
        {itemId = 12248, minCount = 30, maxCount = 40, chance = 5000}, -- Pokemon Revive 30-40 5%
        {itemId = 12247, minCount = 10, maxCount = 30, chance = 10000}, -- Pokemon Super Health Potion 10-30 10%
        {itemId = 13819, minCount = 20, maxCount = 50, chance = 10000}, -- Pokemon Great Energy Potion 20-50 10%
        {itemId = 12165, minCount = 50, maxCount = 50, chance = RANDOM_CHANCE_MAX} -- Empty Ultra Ball 10-100 100%
    }},
}

-- Vars
local CURRENT_POSITIONS = {}

-- Local
local function checkPos(pos)
    for i = 1, #SKIP_AREAS do
        if (isInRange(pos, SKIP_AREAS[i].fromPosition, SKIP_AREAS[i].toPosition)) then
            return false
        end
    end

    return not getTileInfo(pos).protection and not getHouseFromPos(pos) and
            isWalkable(getCreatureByName(GET_MONSTER_INFO_TEST), pos)
end

local doSpawnSurpriseBoxes
doSpawnSurpriseBoxes = function()
    if (#CURRENT_POSITIONS > 0) then
        for i = 1, #CURRENT_POSITIONS do
            local item = getTileItemById(CURRENT_POSITIONS[i], SURPRISE_BOX_ITEMID)
            if (isItem(item)) then
                doRemoveItem(item.uid)
            end
        end

        table.clear(CURRENT_POSITIONS)
        CURRENT_POSITIONS = {}
    end

    for i = 1, MAP_BOXES do
        while (true) do
            local pos = {x = getRandom(1, MAP_MAX_WIDTH), y = getRandom(1, MAP_MAX_HEIGHT),
                z = getRandom(1, POSITION_Z_MAX), stackpos = STACKPOS_GROUND}
            local item = getThingFromPos(pos)

            if (isItem(item) and not table.find(SKIP_GROUND_IDS, item.itemid) and checkPos(pos)) then
                doCreateItem(SURPRISE_BOX_ITEMID, 1, pos)
                doSendMagicEffect(pos, EFFECT_BLUE_BUFF)
                CURRENT_POSITIONS[#CURRENT_POSITIONS + 1] = pos
                break
            end
        end
    end

    addEvent(doSpawnSurpriseBoxes, SPAWN_INTERVAL)
end

-- Global
SurpriseBox.onGameStart = function()
    doSpawnSurpriseBoxes()
end

SurpriseBox.onOpen = function(cid, item, fromPosition, itemEx, toPosition)
    local level = getPlayerLevel(cid)
    local found = false
    for i = 1, #ITEMS do
        local item = ITEMS[i]
        if (not item.maxLevel or level <= item.maxLevel) then
            for i = 1, #item.items do
                local tmpItem = item.items[i]
                if (getRandom(RANDOM_CHANCE_MIN, RANDOM_CHANCE_MAX) <= tmpItem.chance) then
                    local count = getRandom(tmpItem.minCount, tmpItem.maxCount)
                    if (doPlayerSafeAddItem(cid, tmpItem.itemId, count, SHOW_MESSAGE,
                        GENERATE_UNIQUE, SEND_TO_DEPOT)) then
                        doDatalogSurpriseBox(getPlayerGUID(cid), tmpItem.itemId, count, os.time())
                        found = true
                        break
                    end
                end
            end

            break
        end
    end

    if (not found) then
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "This surprise box was empty.")
        log(LOG_TYPES.ERROR, "SurpriseBox.onOpen - Empty box.", getCreatureName(cid), level, item, fromPosition,
            itemEx, toPosition)
    end

    doRemoveItem(item.uid)
    doSendMagicEffect(toPosition, EFFECT_POFF)
    return true
end