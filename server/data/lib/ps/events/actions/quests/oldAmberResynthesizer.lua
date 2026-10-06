local STATUS_ATTR = 1200 -- This is used on 002-quest.lua also
local COOLDOWN = 7 * 24 * 60 * 60 -- This is used on 002-quest.lua also
local OLD_AMBER_ITEMID = 12094

function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (not isItem(itemEx) or itemEx.itemid ~= OLD_AMBER_ITEMID) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true
    end

    local status = getItemAttribute(item.uid, STATUS_ATTR)
    if (not status) then
        doItemSetAttribute(item.uid, STATUS_ATTR, getCurrentTimeInSeconds())
        doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "The Resynthesizer has started. Now you must wait until it charges up to 100%.")
        return true
    end

    if (getCurrentTimeInSeconds() < status) then -- Bug fix
        doItemSetAttribute(item.uid, STATUS_ATTR, (getCurrentTimeInSeconds() -  COOLDOWN))
        status = getItemAttribute(item.uid, STATUS_ATTR)
    end

    local charge = math.round(((getCurrentTimeInSeconds() - status) / COOLDOWN) * 100, 2)
    if (charge < 1.0) then
        doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, string.format(__L(cid, "Resynthesizer status: %s%%."), charge))
        return true
    end

    doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "The Resynthesizer is ready! Now you must bring it to Dr. Alan Grant.")
    return true
end
