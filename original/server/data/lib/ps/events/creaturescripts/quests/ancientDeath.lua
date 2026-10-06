local STORAGE = 8371
local REWARDS = {}

REWARDS["Ancient Blastoise"] = {
    {itemid = 18176, count = 1, unique = true}, -- magical ice orb
}

REWARDS["Ancient Charizard"] = {
    {itemid = 18175, count = 1, unique = true}, -- magical fire orb
}

REWARDS["Ancient Venusaur"] = {
    {itemid = 18174, count = 1, unique = true}, -- magical electric orb
}

function onPrepareDeath(cid, deathList)
    if (not REWARDS[getCreatureName(cid)]) then
        log(LOG_TYPES.ERROR, "ancientDeath - Unknown reward.", getCreatureName(cid))
        return true
    end

    local player = getKillerFromList(deathList)
    if (isCreature(player) and not isPlayer(player)) then
        player = getCreatureMaster(player)
    end
    if (not isPlayer(player)) then
        log(LOG_TYPES.ERROR, "ancientDeath - Unknown killer.", getCreatureName(cid), deathList)
        return true
    end

    if (getCreatureStorage(player, STORAGE) ~= QUEST_STATUS.FINISHED) then
        for _, item in pairs(REWARDS[getCreatureName(cid)]) do
            doPlayerSafeAddItem(player, item.itemid, item.count, true, item.unique)
        end
        doCreatureSetStorage(player, STORAGE, QUEST_STATUS.FINISHED)
    end

    doTeleportThing(player, {x = 3508, y = 1945, z = 11}) -- Ancient Times
    doRemoveCreature(cid)
    setPlayerBlockLogout(player, false)

    return false
end
