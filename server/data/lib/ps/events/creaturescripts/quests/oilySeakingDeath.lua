function onPrepareDeath(cid, deathList)
    local pos = getCreaturePosition(cid)

    doCreateItem(18884, 1, pos) -- puddle of oil
    doSendMagicEffect(pos, EFFECT_TELEPORT_UP)
    doRemoveCreature(cid)
    return false
end
