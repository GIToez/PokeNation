function onUseChargedBall(cid, ball)
    if (isExhaust(cid)) then
        doPlayerSendCancel(cid, "You're exhausted.")

    elseif (ball.uid ~= getPlayerBall(cid).uid) then
        doPlayerSendCancel(cid, "To use this ball you must put it in the correct slot.")

    elseif (not isEpicBall(ball.itemid) and (getBallPokemonLevel(ball.uid) - getPlayerLevel(cid)) > MAX_LEVEL_DIFF_BETWEEN_PLAYER_POKEMON) then
        doPlayerSendCancel(cid, string.format(__L(cid, "You must be at least level %s to call this Pokemon."), (getBallPokemonLevel(ball.uid) - MAX_LEVEL_DIFF_BETWEEN_PLAYER_POKEMON)))

    else
        if (isBiking(cid)) then
            doPlayerDeRideBike(cid, getPlayerSlotItem(cid, PLAYER_SLOT_KEY_ITEM))
        end

        doPokemonCall(cid, ball)
    end
end
