function onLogout(cid, forceLogout)
    if (not forceLogout) then
        if (isFishing(cid)) then
            doPlayerSendCancel(cid, "You can't logout while you're fishing.")
            return false

        elseif (getSafariZone(cid)) then
            doPlayerSendCancel(cid, "You can't logout while you're on the safari zone.")
            return false

        elseif (getPlayerMasteryDungeon(cid) > 0) then
            doPlayerSendCancel(cid, "You can't logout while you're on the mastery dungeon.")
            return false

        elseif (getPlayerBattleing(cid)) then
            doPlayerSendCancel(cid, "You can't logout while you're battleing.")
            return false

        elseif (getPlayerDueling(cid)) then
            doPlayerSendCancel(cid, "You can't logout while you're dueling.")
            return false

        elseif (getPlayerFrontierIsland(cid)) then
            doPlayerSendCancel(cid, "You can't logout right now.")
            return false

        elseif (getCreatureCondition(cid, CONDITION_INVULNERABLE)) then
            doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
            return false

        elseif (getPlayerBlockLogout(cid)) then
            doPlayerSendDefaultCancel(cid, RETURNVALUE_YOUCANNOTLOGOUTHERE)
            return false
        end

    else
        if (EliteFour.getChallengingPlayer() == getPlayerGUID(cid)) then
            EliteFour.doRemovePlayer(cid)
        end

        if (isNumber(getPlayerMasteryDungeon(cid)) and getPlayerMasteryDungeon(cid) > 0) then
            doMasteryDungeonEnd(cid, false)
        end

        if (not isPlayer(cid)) then
            return true
        end

        if (getPlayerPvpArena(cid)) then
            doTeleportThing(cid, TRADE_ROOM_POSITION, false)

        elseif (getSafariZone(cid)) then
            if (isDiving(cid) or isUnderwater(cid)) then
                OxygenMask.doPlayerUnlock(cid)
                setUnderwaterStatus(cid, false)
                setDivingStatus(cid, false)
                doRemoveCondition(cid, CONDITION_OUTFIT)
            end
            doTeleportThing(cid, SAFARI_ENTRANCE_POSITION, false)

        elseif (getPlayerFrontierIsland(cid)) then
            doTeleportThing(cid, FRONTIER_ISLAND_SAFE_POSITION, false)
        end

        if (getPlayerBlockLogout(cid) and doTeleportThing(cid, TRADE_ROOM_POSITION, false)) then
            setPlayerBlockLogout(cid, false)
        end
    end

    if (isPokemonOnline(cid)) then
        local pokemon = getPlayerPokemon(cid)
        if (isCreature(pokemon)) then
            local ball = getPlayerBall(cid)
            if (isItem(ball)) then
                setBallPokemonLastHp(ball.uid, getCreatureHealth(pokemon))
                doTransformItem(ball.uid, balls[ballsNames[ball.itemid]].charged)
                setBallPokemonEnergy(ball.uid, getPlayerMana(cid))
            end
            doRemoveCreature(pokemon)
        end
        doCreatureSetStorage(cid, playersStorages.isPokemonOnline, 0)
    end
    doPlayerRemoveFrontierBalls(cid)

    local guid = getPlayerGUID(cid)
    if (isTutor(cid) and ONLINE_TUTORS[getPlayerGUID(cid)]) then
        ONLINE_TUTORS[guid] = nil
    end

    for i, ball in ipairs(getPlayerAllBallsWithPokemon(cid)) do
        if (i > PLAYER_BALL_MAX) then
            break
        end

        db.executeQuery(string.concat("INSERT INTO `player_pokemon` (`player_id`, `slot`, `pokemon_number`, `description`) VALUES('",
            guid, "', '", i, "', '", getPokemonNumberByName(getBallPokemonName(ball.uid)), "', '", getItemSpecialDescription(ball.uid), "') ON DUPLICATE KEY UPDATE `pokemon_number`='",
            getPokemonNumberByName(getBallPokemonName(ball.uid)), "', `description`='", getItemSpecialDescription(ball.uid), "' ;"))
    end

    return true
end
