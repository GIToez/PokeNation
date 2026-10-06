local COUNT = 0 -- Prevent take long time

function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (getCreatureStorage(cid, 8329) ~= QUEST_STATUS.STARTED) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true
    end

    local spec = getSpectators(fromPosition, 8, 8)
    if (spec) then
        local monsters = 0
        for k, v in pairs(spec) do
            if (isMonster(v) and not isSummon(v)) then
                monsters = monsters + 1
            end
        end

        if (monsters >= 4) then
            doPlayerSendCancel(cid, "Too many Pokemon around.")
            return true
        end
    end

    doSendMagicEffect(toPosition, EFFECT_GRAY_SMOKE)
    doTransformItem(itemEx.uid, 18314)
    doDecayItem(itemEx.uid)

    if (getRandom(0, 100) > 10 and COUNT < 50) then
        local pos = getCreaturePosition(cid)
        for i = 1, 10 do
            addEvent(function(pos)
                doSendMagicEffect(pos, EFFECT_GRAY_SMOKE)
                doCreateMonster("Noisy Rattata", pos)
            end, i * 200, pos)
        end
        doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Wrong trunk! Keep looking.")

    else -- Boss
        doCreateMonster("Gluttonous Raticate", getCreaturePosition(cid))
        doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "It seems that something was found!")
    end

	return true
end
