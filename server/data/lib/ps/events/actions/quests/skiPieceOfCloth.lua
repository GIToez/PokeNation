local QUEST_STORAGE = 8392
local ITEM_STORAGE = 8394
local IMMOBLE_PIECE_OF_CLOTH_ITEMID = 18882
local PICKUPABLE_PIECE_OF_CLOTH_ITEMID = 18883
local SPAWN_INTERVAl = 15 * 1000
local BREAK_CHANCE = 95

local function doSpawnPieceOfCloth()
    local pos = {
        {x = 3661, y = 1124, z = 8},
        {x = 3664, y = 1122, z = 8},
        {x = 3665, y = 1119, z = 8},
        {x = 3668, y = 1124, z = 8},
        {x = 3667, y = 1129, z = 8},
    }
    local tmpPos = table.random(pos)
    doSendMagicEffect(tmpPos, EFFECT_SPARK)
    doCreateItem(IMMOBLE_PIECE_OF_CLOTH_ITEMID, 1, tmpPos)
    pos = table.clear(pos)
end

function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (getCreatureStorage(cid, QUEST_STORAGE) ~= QUEST_STATUS.STARTED or
            getCreatureStorage(cid, ITEM_STORAGE) ~= QUEST_STATUS.UNSTARTED) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true
    end

    doSendDistanceShoot(fromPosition, toPosition, PROJECTILE_GRAVEL)
    doSendMagicEffect(toPosition, EFFECT_SPARK)
    doRemoveItem(item.uid)
    addEvent(doSpawnPieceOfCloth, SPAWN_INTERVAl)

    if (getRandom(1, 100) <= BREAK_CHANCE) then
        doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "The cloth was torn.")

    else
        if (doPlayerSafeAddItem(cid, PICKUPABLE_PIECE_OF_CLOTH_ITEMID, 1, true, true)) then
            doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "The piece did not tear this time.")
            doCreatureSetStorage(cid, ITEM_STORAGE, QUEST_STATUS.FINISHED)
        end
    end

    return true
end
