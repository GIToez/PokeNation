function onUse(cid, item, fromPosition, itemEx, toPosition)
	if (getPlayerDueling(cid) or getPlayerPvpArena(cid) or getPlayerBattleing(cid)) then
		doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
		return true
	end

	local ballName = ballsNames[itemEx.itemid]
	if (not isItem(itemEx) or ballName == nil or  itemEx.itemid ~= balls[ballName].discharged) then
		doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
	elseif (isDueling(cid)) then
		doPlayerSendCancel(cid, "You can not use this potion while you're dueling.")
	elseif (getPlayerBattleing(cid)) then
		doPlayerSendCancel(cid, "You can not use this potion while you're battleing.")
	else
		doBallHeal(cid, itemEx)
		doSendMagicEffect(getCreaturePosition(cid), EFFECT_GREEN_BUFF)
		doRemoveItem(item.uid, 1)
	end
	return true
end
