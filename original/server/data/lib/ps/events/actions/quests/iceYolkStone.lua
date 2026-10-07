local QUEST_STORAGE = 8393
local ITEM_STORAGE = 8395
local PICKUPABLE_ICE_YOLK_STONE_ITEMID = 18880
local SPAWN_INTERVAl = 30 * 60 * 1000

local function doSpawnIceYolkStone()
    local pos = {
        {x = 3731, y = 1097, z = 8},
        {x = 3748, y = 1076, z = 8},
        {x = 3758, y = 1064, z = 9},
        {x = 3759, y = 1064, z = 9},
        {x = 3684, y = 1065, z = 9},
    }
    doCreateItem(PICKUPABLE_ICE_YOLK_STONE_ITEMID, 1, table.random(pos))
    pos = table.clear(pos)
end

function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (getCreatureStorage(cid, QUEST_STORAGE) ~= QUEST_STATUS.STARTED or
            getCreatureStorage(cid, ITEM_STORAGE) ~= QUEST_STATUS.UNSTARTED) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true
    end

    doSendDistanceShoot(fromPosition, toPosition, PROJECTILE_GRAVEL)
    doSendMagicEffect(toPosition, EFFECT_ICE_EXPLOSION)
    doRemoveItem(item.uid)

    if (doPlayerSafeAddItem(cid, PICKUPABLE_ICE_YOLK_STONE_ITEMID, 1, true, true)) then
        doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "A precious stone was taken.")
        doCreatureSetStorage(cid, ITEM_STORAGE, QUEST_STATUS.FINISHED)
        addEvent(doSpawnIceYolkStone, SPAWN_INTERVAl)
    end

    return true
end
