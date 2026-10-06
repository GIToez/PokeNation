local function doSendProjectile(fromPosition, toCid, projectile)
    if (not isCreature(toCid)) then return end
    doSendDistanceShoot(fromPosition, getCreaturePosition(toCid), projectile)
end

function onPrepareDeath(cid)
    if (getCreatureStatus(cid, CREATURE_STATUS_SUBSTITUTE)) then
        doCreatureChangeHealth(cid, getPokemonHealthBeforeSubstitute(cid))
        doCreatureRemoveStatus(cid, CREATURE_STATUS_SUBSTITUTE)
        return false
    elseif (getCreatureStatus(cid, CREATURE_STATUS_ENDURE)) then
        doCreatureChangeHealth(cid, 1)
        doCreatureRemoveStatus(cid, CREATURE_STATUS_ENDURE)
        return false
    end

    local pokemonMaster = getCreatureMaster(cid)
    local ball = getPlayerBall(pokemonMaster)
    local ballName = ballsNames[ball.itemid]
    local pokemonPosition = getCreaturePosition(cid)

    if (getPlayerDueling(pokemonMaster) or getPlayerBattleing(pokemonMaster)) then
        local duelPokemonRemaing = getPlayerDuelPokemonRemaing(pokemonMaster)
        if (duelPokemonRemaing) then
            setPlayerDuelPokemonRemaing(pokemonMaster, duelPokemonRemaing - 1)
        end
    end

    doTransformItem(ball.uid, balls[ballName].discharged)
    doSendMagicEffect(getCreaturePosition(cid), balls[ballName].effects.use)
    setPlayerVulnerable(pokemonMaster, true)
    setCreatureMaxMana(pokemonMaster, 0)
    doCreatureAddMana(pokemonMaster, -getCreatureMana(pokemonMaster), false)
    doSendDistanceShoot(getCreaturePosition(pokemonMaster), pokemonPosition, balls[ballName].projectile)
    addEvent(doSendProjectile, 500, pokemonPosition, pokemonMaster, balls[ballName].projectile)
    doCreatureSay(pokemonMaster, string.format(__L(pokemonMaster, "%s, back!"), getCreatureNickname(cid)))
    doPlayerSendPokemonWindowUpdatePokemonIcon(pokemonMaster, getFastcallNumber(ball.uid), 2, "FNT")
    setBallPokemonLastHpPercent(ball.uid, 0)
    doRemoveCreature(cid)
    doCreatureSetStorage(pokemonMaster, playersStorages.isPokemonOnline, 0)
    doPlayerSendPokemonStatusClear(pokemonMaster)
    return false
end
