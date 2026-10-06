local ITEMS = {
    [29127] = { -- rare paint ticket box
        18908, 18909, 18910, 14449, 14450, 18942, 18943, 18944, 27778, 27782, 27794, 27802
    },
    [29128] = { -- mastery paint ticket box
        19064, 19065, 19066, 19067, 19068, 19069, 19070, 19071, 19072
    },
    [29133] = { -- legendary paint ticket box
        18895, 18896, 18897, 24604, 24605, 24606
    }
}

function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (not doPlayerSafeAddItem(cid, table.random(ITEMS[item.itemid]), 1, true, false, true)) then
        return false
    end

    doRemoveItem(item.uid, 1)
    doSendMagicEffect(toPosition, EFFECT_POFF)
    return true
end
