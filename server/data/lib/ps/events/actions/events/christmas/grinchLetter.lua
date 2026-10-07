local QUEST_STORAGE = 8642

function onUse(cid, item, fromPosition, itemEx, toPosition)
	for i = 8643, 8648 do
		if (getCreatureStorage(cid, i) ~= QUEST_STATUS.FINISHED) then
			doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
			return true
		end
	end

	doShowTextDialog(cid, item.itemid, __L(cid, "I love you Martha May, I will always love you but hate the people and what they did to me, never see us."))

	if (getCreatureStorage(cid, QUEST_STORAGE) ~= QUEST_STATUS.FINISHED) then
		doCreatureSetStorage(cid, QUEST_STORAGE, QUEST_STATUS.FINISHED)
	end

	local grinchPos = {x = 3930, y = 327, z = 10}
	if (not getAlreadyNpcAround(grinchPos, "Grinch")) then
		local grinch = doCreateNpc("Grinch", grinchPos)
		doSendMagicEffect(grinchPos, EFFECT_TELEPORT_DOWN)
	end

	return true
end
