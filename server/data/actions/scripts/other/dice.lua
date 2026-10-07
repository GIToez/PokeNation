function onUse(cid, item, fromPosition, itemEx, toPosition)
	if(fromPosition.x ~= CONTAINER_POSITION) then
		doSendMagicEffect(fromPosition, EFFECT_DICE)
	end

	local value = math.random(5792, 5797)
	doTransformItem(item.uid, value)
	doCreatureSay(cid, string.format(__L(cid, '%s rolled a %s.'), getCreatureName(cid), value - 5791), TALKTYPE_ORANGE_1)
	return true
end
