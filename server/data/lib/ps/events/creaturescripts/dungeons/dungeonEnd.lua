function onPrepareDeath(cid, deathList)
    local killer = getKillerFromList(deathList)
    if (isCreature(killer) and not isPlayer(killer)) then
        killer = getCreatureMaster(killer)
    end
    if (isCreature(killer)) then
        doMasteryDungeonEnd(killer, true)
    end
    doRemoveCreature(cid)
    return false
end
