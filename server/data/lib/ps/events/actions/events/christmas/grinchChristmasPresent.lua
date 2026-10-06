local PRESENT_CONVERSION = {
    [25264] = 25271,
    [25265] = 25272,
    [25266] = 25273,
    [25267] = 25274,
    [25268] = 25275,
}

function onUse(cid, item, fromPosition, itemEx, toPosition)
    for k, v in pairs(PRESENT_CONVERSION) do
        if (getPlayerItemCount(cid, v) > 0) then
            doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "You can not carry more than one present at a time.")
            return true
        end
    end

    if (doPlayerSafeAddItem(cid, PRESENT_CONVERSION[item.itemid], 1, true, true)) then
        doSendMagicEffect(toPosition, EFFECT_RED_BUFF)
        doRemoveItem(item.uid)
        doCreatureSetStorage(cid, 8562, QUEST_STATUS.FINISHED) -- Just to flag the player within the event
        doPlayerAchievementCheck(cid, ACHIEVEMENT_IDS.GRINCH_XMAS_PRESENT)
    end
    return true
end
