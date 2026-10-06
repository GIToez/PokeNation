local CHEST_ATTR = 1000
local REWARDS_BY_VALUE = {}

local STORAGE = 8370

REWARDS_BY_VALUE[1] = {
    {itemid = 12261, count = 1, unique = false}, -- Zapdos Doll
    {itemid = 18173, count = 1, unique = true}, -- Deepsoul Stone
    --{itemid = 18087, count = 1, unique = false}, -- Thunderstone
    {itemid = 12082, count = 5, unique = true}, -- Zapdos Feather
}

REWARDS_BY_VALUE[2] = {
    {itemid = 12262, count = 1, unique = false}, -- Moltres Doll
    {itemid = 18173, count = 1, unique = true}, -- Deepsoul Stone
    --{itemid = 18083, count = 1, unique = false}, -- Fire Stone
    {itemid = 12081, count = 5, unique = true}, -- Moltres Feather
}

REWARDS_BY_VALUE[3] = {
    {itemid = 12260, count = 1, unique = false}, -- Articuno Doll
    {itemid = 18173, count = 1, unique = true}, -- Deepsoul Stone
    --{itemid = 18088, count = 1, unique = false}, -- Water Stone
    {itemid = 12083, count = 5, unique = true}, -- Articuno Feather
}

function onUse(cid, item, fromPosition, itemEx, toPosition)
    local value = getItemAttribute(item.uid, CHEST_ATTR)
    if (not value or not REWARDS_BY_VALUE[value]) then
        log(LOG_TYPES.ERROR, "legendaryChest - Unknown value.", getCreatureName(cid), value, item, fromPosition,
            toPosition, itemEx)
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true
    end

    if (getCreatureStorage(cid, STORAGE) ~= QUEST_STATUS.FINISHED) then
        for _, item in pairs(REWARDS_BY_VALUE[value]) do
            doPlayerSafeAddItem(cid, item.itemid, item.count, true, item.unique)
        end
        doCreatureSetStorage(cid, STORAGE, QUEST_STATUS.FINISHED)

    else
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_SMALL, "It's empty.")
    end

    doTeleportThing(cid, getTownTemplePosition(getPlayerTown(cid)))
    doRemoveItem(item.uid)

	return true
end
