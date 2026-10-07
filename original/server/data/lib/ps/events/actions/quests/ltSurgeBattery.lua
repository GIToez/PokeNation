local STATUS_ATTR = 1200 -- This is used on 002-quest.lua also

function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (not isItem(itemEx) or not isCorpse(itemEx.uid)) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true

    elseif (getItemAttribute(itemEx.uid, "corpseowner") and
            getItemAttribute(itemEx.uid, "corpseowner") ~= getPlayerGUID(cid)) then
        doPlayerSendCancel(cid, "You didn't defeated this Pokemon.")
        return true
    end

    local pokemonName = getItemAttribute(itemEx.uid, "pokemon")
    if (not pokemonName or not isPokemonName(pokemonName)) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true
    end

    if (not table.find(getPokemonTypes(nil, pokemonName), ELEMENT_ELECTRIC)) then
        doPlayerSendCancel(cid, "You can use it only on Electric-Type Pokemon.")
        return true
    end

    local status = getItemAttribute(item.uid, STATUS_ATTR)
    if (not status) then
        status = 0

    elseif (status >= 100) then
        doPlayerSendCancel(cid, "The battery is already full charged.")
        return true
    end

    status = status + (getItemAttribute(itemEx.uid, "level") / 10)
    if (status >= 100) then
        doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "The battery is full charged now.")
    else
        doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, string.format(__L(cid, "The battery is charging (%s%%)."), math.round(status)))
    end

    doItemSetAttribute(item.uid, STATUS_ATTR, status)
    doSendDistanceShoot(toPosition, fromPosition, PROJECTILE_ELECTRIC_BALL)
    doSendMagicEffect(fromPosition, EFFECT_ELECTRIC_DISCHARGE)
    doRemoveItem(itemEx.uid)
    return true
end
