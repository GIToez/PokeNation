local function doEffect(pos)
    for i = 0, 20 do
        addEvent(doSendMagicEffect, i * 50, {x = pos.x - getRandom(-1,1), y = pos.y, z = pos.z},
            table.random({EFFECT_EXPLOSION, EFFECT_POISON_GAS, EFFECT_POISON, EFFECT_BLUE_BUFF, EFFECT_RED_BUFF,
                EFFECT_GREEN_BUFF, EFFECT_FIREWORK_YELLOW, EFFECT_FIREWORK_BLUE, EFFECT_FIREWORK_RED}))
    end
end

function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (not isItem(itemEx) or not HalloweenEvent.isCauldronItemRequired(itemEx.itemid)) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true
    end

    doSendDistanceShoot(toPosition, fromPosition, PROJECTILE_GRAVEL)
    doEffect(fromPosition)
    doRemoveItem(itemEx.uid, HalloweenEvent.onDropIngredient(itemEx.itemid, getItemCount(itemEx.uid)))

    local msg = string.createStory(string.format(__L(cid, "Remaing items to build the potion: %s"), HalloweenEvent.getRemaingIngredientsMessage()))
    for i, message in pairs(msg) do
        if (i == 1) then
            doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_RED, message)
        else
            local tmpInterval = (i - 1) * 5000
            addEvent(function(cid, text)
                if (isPlayer(cid)) then
                    doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_RED, text)
                end
            end, tmpInterval, cid, message)
        end
    end

    return true
end