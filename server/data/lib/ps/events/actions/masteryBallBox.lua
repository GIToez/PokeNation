local ITEMS = { 19029, 19033, 19037, 19041, 19045, 19049, 19053, 19057, 19061 }

function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (not doPlayerSafeAddItem(cid, table.random(ITEMS), 10, true)) then
        return false
    end

    doRemoveItem(item.uid, 1)
    doSendMagicEffect(toPosition, EFFECT_POFF)
    return true
end
