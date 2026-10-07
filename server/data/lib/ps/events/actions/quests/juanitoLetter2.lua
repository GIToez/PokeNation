function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (getCreatureStorage(cid, 8344) ~= QUEST_STATUS.FINISHED) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true
    end

    doShowTextDialog(cid, item.itemid, "I know you will not ever forgive me... but I'll always be your.\nI'm going home.\nRemember that it is close to the large Pokemon shopping.\nBeware Pokemon insects that are on the island.")
    doCreatureSetStorage(cid, 8345, QUEST_STATUS.FINISHED)
	return true
end
