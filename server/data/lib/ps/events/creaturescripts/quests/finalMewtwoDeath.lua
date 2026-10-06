function onPrepareDeath(cid, deathList)
    doSendMagicEffect(getCreaturePosition(cid), EFFECT_DARK_PULSE)
    doCreatureSay(cid, "You win this time... But I will return.", TALKTYPE_SAY)
    doRemoveCreature(cid)

    local killer = getKillerFromList(deathList)
    if (isCreature(killer) and not isPlayer(killer)) then
        killer = getCreatureMaster(killer)
    end
    if (isCreature(killer)) then
        doCreatureSetStorage(killer, 8561, QUEST_STATUS.FINISHED)
    end

    return false
end
