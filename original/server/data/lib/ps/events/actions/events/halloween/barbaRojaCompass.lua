local TREASURE_POSITION = {x = 3217, y = 275, z = 6}

function onUse(cid, item, fromPosition, itemEx, toPosition)
    local playerPosition = getCreaturePosition(cid)
    if (getDistanceBetween(playerPosition, TREASURE_POSITION) > 100) then
        doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "The compass is unavailable.")
        return true
    end

    doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "The compass is pointing to: " .. getSearchString(playerPosition, TREASURE_POSITION, cid, true, true) .. ".")
    doSendMagicEffect(playerPosition, EFFECT_EMOTION_EXCLAMATION)

    return true
end
