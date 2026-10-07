local PICK_USE_MESSAGES = {"Poff", "Tak", "Plok", "Puff", "Tek"}
local ALLOWED_ITEMEX_IDS = {3671, 3673, 3672}
local COUNT = 0

function onUse(cid, item, fromPosition, itemEx, toPosition)
	if (not isItem(itemEx) or not isInArray(ALLOWED_ITEMEX_IDS, itemEx.itemid)) then
		doPlayerSendCancel(cid, "You can not dig here.")
	else
		doSendMagicEffect(toPosition, EFFECT_GRAY_SMOKE)
		doSendAnimatedText(toPosition, table.random(PICK_USE_MESSAGES), COLOR_GREY)

		if (getRandom(0, 100) == 1 or COUNT == 100) then
			doPlayerAddItem(cid, 14363) -- Fossil Rock
			doRemoveItem(item.uid)
			doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "You have found a Fossil Rock.")
			doSendMagicEffect(getCreaturePosition(cid), EFFECT_FIREWORK_RED)
			COUNT = 0
		else
			doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "You have found nothing.")
			COUNT = COUNT + 1
		end
	end

	return true
end
