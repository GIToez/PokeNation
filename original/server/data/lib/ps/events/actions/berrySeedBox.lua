local SEEDS = {13176, 13177, 13178, 13179, 13180, 14791, 14792, 14793, 14794, 14795}

function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (doPlayerSafeAddItem(cid, table.random(SEEDS), getRandom(1, 5), true)) then
        doSendMagicEffect(getCreaturePosition(cid), EFFECT_FIREWORK_YELLOW)
        doRemoveItem(item.uid)
    end

	return true
end
