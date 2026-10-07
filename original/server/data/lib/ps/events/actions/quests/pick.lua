local PICK_USE_MESSAGES = {"Poff", "Tak", "Plok", "Puff", "Tek"}
local ALLOWED_ITEMEX_IDS = {5747, 5750, 5751, 5752, 5753, 5754 }
local QUEST_STORAGE = 8026

function onUse(cid, item, fromPosition, itemEx, toPosition)
	if (not isItem(itemEx) or not isInArray(ALLOWED_ITEMEX_IDS, itemEx.itemid)) then
		doPlayerSendCancel(cid, "You can not mine here.")

    elseif (getCreatureStorage(cid, QUEST_STORAGE) == QUEST_STATUS.FINISHED) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)

	else
		doSendMagicEffect(toPosition, EFFECT_GRAY_SMOKE)
		doSendAnimatedText(toPosition, table.random(PICK_USE_MESSAGES), COLOR_GREY)

		if (math.random(0, 10) == 1) then
			doPlayerAddItem(cid, 5880, 1, true) -- Iron Ore
			doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "You have found an Iron Ore.")
		else
			doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "You have found nothing.")
		end
	end

	return true
end
