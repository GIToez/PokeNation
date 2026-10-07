function onPrepareDeath(cid, deathList)
    doSendMagicEffect(getCreaturePosition(cid), EFFECT_GUARDIAN_KABUTOPS_HIDE)
    doRemoveCreature(cid)

    local item = getTileItemById({x = 3578, y = 2758, z = 12}, 14811)
    if (isItem(item)) then
        doRemoveItem(item.uid)
    end
    return false
end
