function onPrepareDeath(cid, deathList)
    local pos = getCreaturePosition(cid)

    doCreateItem(18322, 1, pos)
    doSendMagicEffect(pos, EFFECT_TELEPORT_UP)
    doRemoveCreature(cid)
    return false
end
