function onTextEdit(cid, item, newText)
    if (getDexByItemId(item.itemid)) then -- Checking Pokemon that learn the TM
        local tmItemId = getPlayerLastDexedTmItemId(cid)
        if (not tmItemId or tmItemId == 0) then
            doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
            return false
        end

        local tm = getTmByItemId(tmItemId)
        if (not tmItemId or tmItemId == TM_IDS.NONE) then
            doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
            return false
        end

        newText = string.capitalise(newText)

        if (not isPokemonName(newText)) then
            doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Invalid Pokemon name.")
            return false

        elseif (not hasPlayerDexedPokemon(cid, newText)) then
            doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Your Pokedex doesn't have collected information about this Pokemon yet.")
            return false
        end

        doPlayerPopupFYI(cid, string.format(__L(cid, "%s%s%s learn the %s!"), (getPokemonTmLearnable(newText, tm) and "OK! " or "FAIL! "), newText, (getPokemonTmLearnable(newText, tm) and __L(cid, " can") or __L(cid, " can't")), getItemNameById(tmItemId)))
        return false

    elseif (table.find({13207, 13016, 13017}, item.itemid)) then -- Duel Bet
        local bet = string.extractNumber(newText)
        if (bet < 50 or bet > 30000) then
            doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "You must enter a value between 50 and 30000.")
            return false
        end

        local lastOpponent = getPlayerLastOpponent(cid)
        if (not isPlayer(lastOpponent)) then
            doPlayerSendCancel(cid, "Your opponent seems to be offline.")
            return false
        end

        doPartyDuelCreate(cid, getPlayerLastMaxMembers(cid), getPlayerLastMaxPokemon(cid), bet)
        doPartyDuelInvite(cid, lastOpponent)
        return false
    end

    return true
end