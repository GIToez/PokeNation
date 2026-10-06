function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (isPokemonOnline(cid)) then
        doPlayerSendCancel(cid, "You can not do it while you have a Pokemon out of the ball.")
        return true

    elseif (fromPosition.x ~= CONTAINER_POSITION or toPosition.x ~= CONTAINER_POSITION) then -- TODO: This doesnt mean that the player is carring the item or no
        doPlayerSendCancel(cid, "You must pick up this item first.")
        return true

    elseif (not isItem(itemEx)) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true

    elseif (not isBallPokemonFromEgg(itemEx.uid)) then
        doPlayerSendCancel(cid, "This is not a Pokemon from egg!")
        return true

    elseif (not getBallReceivedEggMove(itemEx.uid)) then
        doPlayerSendCancel(cid, "Your Pokemon does not have an Egg Move!")
        return true

    elseif (getBallEggMoveRegenerateEnabled(itemEx.uid)) then
        doPlayerSendCancel(cid, "Your Pokemon already have Egg Move regeneration enabled.")
        return true
    end

    setBallEggMoveRegenerateEnabled(itemEx.uid, true)
    setBallEggMovesRegenerated(itemEx.uid, nil) -- Reseting
    doSendMagicEffect(getCreaturePosition(cid), EFFECT_FIREWORK_BLUE)
    doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "The Egg Move regeneration for this Pokemon has been enabled.")
    doRemoveItem(item.uid, 1)
    return true
end
