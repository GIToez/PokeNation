local DESTINATION = {x = 5758, y = 190, z = 7}

function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (getDistanceBetween(getCreaturePosition(cid), {x = 5800, y = 169, z = 7}) > 100) then -- Player outside island
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true
    end

    if (isPokemonOnline(cid) or getPlayerMounted(cid) or isUnderwater(cid) or isPlayerOnPvpArena(cid) or
            hasCondition(cid, CONDITION_INFIGHT) or getPlayerWatchingTV(cid) or getPlayerDueling(cid) or
            getPlayerMasteryDungeon(cid) > 0 or getPlayerFrontierIsland(cid) or getPlayerTournamentReady(cid)) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true
    end

    local currentDate = os.time()
    local machineInterval = getCreatureStorage(cid, playersStorages.lastEdBlackhoodTeleporterUse) or currentDate
    local remaingTime = machineInterval - currentDate

    if (remaingTime > 0) then
        doPlayerSendCancel(cid, string.format(__L(cid, "You must wait %s to use the teleporter again."), table.concat(string.timediff(remaingTime, cid))))
        return true
    end

    doTeleportThing(cid, DESTINATION)
    doSendMagicEffect(DESTINATION, EFFECT_ELECTRIC_CLOUD)
    doCreatureSetStorage(cid, playersStorages.lastEdBlackhoodTeleporterUse, os.time() + (10 * 60))

    return true
end
