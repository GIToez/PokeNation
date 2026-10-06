function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (doExtraExpRateStart(cid, 60 * 60, 0.15)) then
        doSendMagicEffect(toPosition, table.random({ EFFECT_POISON_EXPLODE, EFFECT_ENERGY_EXPLODE, EFFECT_BLUE_BUFF, EFFECT_RED_BUFF, EFFECT_GREEN_BUFF }))
        doRemoveItem(item.uid, 1)
    else
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
    end
    return true
end
