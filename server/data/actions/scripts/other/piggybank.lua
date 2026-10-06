function onUse(cid, item, fromPosition, itemEx, toPosition)
	if(math.random(1, 6) == 1) then
		doSendMagicEffect(fromPosition, EFFECT_POFF)
		doPlayerAddItem(cid, 2148, 1)
		doTransformItem(item.uid, 2115)
	else
		doSendMagicEffect(fromPosition, EFFECT_YELLOW_SOUND)
		doPlayerAddItem(cid, 2148, 50)
	end
	return true
end
