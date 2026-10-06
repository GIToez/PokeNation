local QUEST_STORAGE = 8422
local POSTERS = {
    {pos = {x = 3336, y = 282, z = 7}, storage = 8423},
    {pos = {x = 3288, y = 259, z = 7}, storage = 8424},
    {pos = {x = 3297, y = 353, z = 7}, storage = 8425},
    {pos = {x = 3311, y = 302, z = 7}, storage = 8426},
    {pos = {x = 3892, y = 275, z = 7}, storage = 8427},
    {pos = {x = 3859, y = 291, z = 7}, storage = 8428},
    {pos = {x = 3879, y = 320, z = 7}, storage = 8429},
    {pos = {x = 3927, y = 291, z = 7}, storage = 8430},
}

function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (getCreatureStorage(cid, QUEST_STORAGE) ~= QUEST_STATUS.STARTED) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true
    end

    for k, v in pairs(POSTERS) do
        if (getSamePosition(toPosition, v.pos)) then
            if (getCreatureStorage(cid, v.storage) ~= QUEST_STATUS.FINISHED) then
                doCreatureSetStorage(cid, v.storage, QUEST_STATUS.FINISHED)
                doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "The poster was placed.")
                doSendDistanceShoot(fromPosition, toPosition, PROJECTILE_GRAVEL)
                doSendMagicEffect(toPosition, EFFECT_EMOTION_EXCLAMATION)
                doRemoveItem(item.uid, 1)
                doDecayItem(doCreateItem(23541, 1, toPosition)) -- police poster
            else
                doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
            end

            return true
        end
    end

    doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
    return true
end
