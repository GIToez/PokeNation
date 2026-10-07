local QUEST_STORAGE = 8379
local ITEM_STORAGE = 8380

function onPrepareDeath(cid, deathList)
    doSendMagicEffect(getCreaturePosition(cid), EFFECT_TELEPORT_UP)
    doRemoveCreature(cid)

    local player = getCreatureMaster(deathList[1])
    if (not isPlayer(player) or getCreatureStorage(player, QUEST_STORAGE) ~= QUEST_STATUS.STARTED or
            getCreatureStorage(player, ITEM_STORAGE) == QUEST_STATUS.FINISHED) then
        return false
    end

    doPlayerSafeAddItem(player, 18756, 1, true, true)
    doCreatureSetStorage(player, ITEM_STORAGE, QUEST_STATUS.FINISHED)
    return false
end
