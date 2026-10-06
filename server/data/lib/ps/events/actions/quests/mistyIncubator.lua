local eggStorage = 8219
local questStorage = 8205
local battleNpcStorages = {9653, 9654, 9655, 9656}

function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (getCreatureStorage(cid, questStorage) ~= QUEST_STATUS.STARTED or
        getCreatureStorage(cid, eggStorage) == QUEST_STATUS.FINISHED) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)

	else
        for _, storage in pairs(battleNpcStorages) do
            if (not getPlayerDefeatedNPC(cid, storage)) then
                doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
                return true
            end
        end

        if (doPlayerAddUniqueItem(cid, 18158, 1, false)) then
            doCreatureSetStorage(cid, eggStorage, QUEST_STATUS.FINISHED)
            doSendMagicEffect(getCreaturePosition(cid), EFFECT_BLUE_BUFF)
            doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "You received a pokemon egg! Go see Misty now.")
            doRemoveItem(item.uid)
            doDecayItem(doCreateItem(18288, 1, toPosition))
        end
    end

	return true
end
