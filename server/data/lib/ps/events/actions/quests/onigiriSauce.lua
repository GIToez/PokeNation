local QUEST_STORAGE = 8458
local ONIGIRI_ITEMID = 14464
local COUNT = 40

function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (--[[getCreatureStorage(cid, QUEST_STORAGE) ~= QUEST_STATUS.STARTED or ]]not isItem(itemEx) or
            itemEx.itemid ~= ONIGIRI_ITEMID) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true

    elseif (fromPosition.x ~= CONTAINER_POSITION or toPosition.x ~= CONTAINER_POSITION) then -- TODO: This doesnt mean that the player is carring the item or no
        doPlayerSendCancel(cid, "You must pick up this item first.")
        return true

    elseif (itemEx.type ~= COUNT) then
        doPlayerSendCancel(cid, string.format(__L(cid, "You must use it on %s onigiris."), COUNT))
        return true
    end

    doSendMagicEffect(toPosition, EFFECT_EMOTION_EXCLAMATION)
    doRemoveItem(itemEx.uid)
    doPlayerSafeAddItem(cid, 23590, COUNT, true, true) -- seasoned onigiri
    doRemoveItem(item.uid)
    doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "The onigiris are seasoned.")

    return true
end
