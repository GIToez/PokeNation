function onPrepareDeath(cid, deathList)
    local killer = getKillerFromList(deathList)
    if (isCreature(killer) and not isPlayer(killer)) then
        killer = getCreatureMaster(killer)
    end
    if (isPlayer(killer)) then
        RangerClub.onPlayerDefeatBoss(killer, getCreatureNickname(cid))
    end

    doRemoveCreature(cid)
    return false
end
