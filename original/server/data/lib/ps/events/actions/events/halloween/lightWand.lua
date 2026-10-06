function onUse(cid, item, fromPosition, itemEx, toPosition)
	if (not getPlayerMounted(cid) and
            getCreatureCondition(cid, CONDITION_OUTFIT, CONDITION_SUBID.OUTFITS.HALLOWEEN)) then
		doRemoveCondition(cid, CONDITION_OUTFIT, CONDITION_SUBID.OUTFITS.HALLOWEEN)
		doSendMagicEffect(getCreaturePosition(cid), EFFECT_POISON_GAS_TWO)
		doRemoveItem(item.uid, 1)
	else
		doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
		doSendMagicEffect(getCreaturePosition(cid), EFFECT_POFF)
	end
	return true
end
