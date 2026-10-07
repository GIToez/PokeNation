local BOX_ITEMS = {
	12157, 10, -- Empty Poke Ball
	12161, 10, -- Empty Great Ball
	12165, 10, -- Empty Ultra Ball
	12173, 5, -- Empty Blue Ball
	12177, 5, -- Empty Red Ball
	12181, 5, -- Empty Yellow Ball
	12185, 5, -- Empty Dark Ball
}

local REWARD_MIN = 1
local REWARD_MAX = #BOX_ITEMS / 2
local CAN_DROP_ON_MAP = true

function onUse(cid, item, fromPosition, itemEx, toPosition)
	local numberOfRewards = math.random(REWARD_MIN, REWARD_MAX)
	local outputMessage = ""

	for i = 1, numberOfRewards, 2 do
		local rewardCount = math.random(REWARD_MIN, BOX_ITEMS[i + 1])

		doPlayerAddDepotItem(cid, 0, doCreateItemEx(BOX_ITEMS[i], rewardCount))
		outputMessage = outputMessage .. "\n" .. getItemNameById(BOX_ITEMS[i]) .. " x" .. rewardCount
	end

	if (outputMessage ~= "") then
		doPlayerSendTextMessage(cid, MESSAGE_EVENT_ORANGE, string.format(__L(cid, "This black surprise box contains:%s. The items were teleported to the Pokemon center."), outputMessage))
		doSendMagicEffect(getCreaturePosition(cid), EFFECT_FIREWORK_YELLOW)

	else
		doPlayerSendTextMessage(cid, MESSAGE_EVENT_ORANGE, "This black surprise box is empty.")
		doSendMagicEffect(getCreaturePosition(cid), EFFECT_POFF)
	end

	doRemoveItem(item.uid)

	return true
end
