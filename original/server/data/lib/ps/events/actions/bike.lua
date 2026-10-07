function onUse(cid, item)
    if (getPlayerSlotItem(cid, PLAYER_SLOT_KEY_ITEM).uid ~= item.uid) then
        doPlayerSendCancel(cid, "To use this bike, put in the correct slot.")
    elseif (not isBiking(cid)) then
        if (isPokemonOnline(cid)) then
            inUseBall(cid, getPlayerSlotItem(cid, PLAYER_SLOT_BALL))
        end

        if (isPokemonOnline(cid) or getPlayerMounted(cid) or isFishing(cid) or isPlayerOnPvpArena(cid)) then
            doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        else
            doPlayerRideBike(cid, item)
        end
    else
        doPlayerDeRideBike(cid, item)
    end
    return true
end
