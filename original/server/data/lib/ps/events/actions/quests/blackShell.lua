local QUEST_STORAGE = 8389
local BLACK_PEARL_ITEMID = 18876
local BLACK_SHELL_ITEMID = 18877
local ITEM_STORAGE = 8390
local BLACK_SHELL_SPAWN_INTERVAl = 10 * 60 * 1000

local function doSpawnBlackShell()
    local pos = {
        {x = 3819, y = 578, z = 8},
        {x = 3786, y = 576, z = 9},
        {x = 3719, y = 605, z = 8},
        {x = 3836, y = 629, z = 9},
        {x = 3828, y = 592, z = 9},
    }
    doCreateItem(BLACK_SHELL_ITEMID, 1, table.random(pos))
    pos = table.clear(pos)
end

function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (getCreatureStorage(cid, QUEST_STORAGE) ~= QUEST_STATUS.STARTED or
            getCreatureStorage(cid, ITEM_STORAGE) ~= QUEST_STATUS.UNSTARTED) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true
    end

    doSendDistanceShoot(fromPosition, toPosition, PROJECTILE_GRAVEL)
    doSendMagicEffect(toPosition, EFFECT_POISON_TWO)

    if (doPlayerSafeAddItem(cid, BLACK_PEARL_ITEMID, 1, true, true)) then
        doRemoveItem(item.uid)
        doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "A beautiful black pearl was found.")
        doCreatureSetStorage(cid, ITEM_STORAGE, QUEST_STATUS.FINISHED)
        addEvent(doSpawnBlackShell, BLACK_SHELL_SPAWN_INTERVAl)
    end

    return true
end
