function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (getCreatureStorage(cid, 8310) ~= QUEST_STATUS.STARTED) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true
    end

    for _, itemid in pairs({18622, 18297}) do
        doPlayerRemoveItem(cid, itemid, getPlayerItemCount(cid, itemid))
    end

    doSendMagicEffect(getCreaturePosition(cid), EFFECT_RED_BUFF)
    if (getCreatureStorage(cid, 8337) >= 10) then
        doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "You successfully tested the new poke balls, go see Jarrod now.")
    else
        doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "The experiment is not complete. You must catch more Pokemon!")
    end

	return true
end
