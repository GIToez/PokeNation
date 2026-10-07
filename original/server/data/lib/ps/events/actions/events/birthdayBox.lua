local BIRTHDAY_BOXES = {
	[14433] = { -- Blue Level 1
		{id = 6569, chance = 1500, count = 5}, -- Candies
		{id = 6577, chance = 1500, count = 1}, -- Green Balloon
		{id = 6578, chance = 1500, count = 1}, -- Party Hat
		{id = 6572, chance = 1500, count = 1}, -- Party Trumpet
		{id = 7966, chance = 1500, count = 1}, -- Birthday Cake
		{id = 12244, chance = 1000, count = 5}, -- Pokemon Health Potion
		{id = 14438, chance = 20, count = 1}, -- Letter L
		{id = 14439, chance = 20, count = 1}, -- Letter O
		{id = 14440, chance = 20, count = 1}, -- Letter P
		{id = 14441, chance = 20, count = 1}, -- Letter S
		{id = 14442, chance = 20, count = 1}, -- Letter U
	},
	[14434] = { -- Green Level 2
		{id = 6569, chance = 1500, count = 8}, -- Candies
		{id = 6577, chance = 1500, count = 1}, -- Green Balloon
		{id = 6575, chance = 1500, count = 1}, -- Red Balloon
		{id = 6578, chance = 1500, count = 1}, -- Party Hat
		{id = 6572, chance = 1500, count = 1}, -- Party Trumpet
		{id = 6574, chance = 1500, count = 1}, -- Bar of Chocolate
		{id = 7966, chance = 1500, count = 1}, -- Birthday Cake
		{id = 12244, chance = 1500, count = 5}, -- Pokemon Health Potion
		{id = 14438, chance = 30, count = 1}, -- Letter L
		{id = 14439, chance = 30, count = 1}, -- Letter O
		{id = 14440, chance = 30, count = 1}, -- Letter P
		{id = 14441, chance = 30, count = 1}, -- Letter S
		{id = 14442, chance = 30, count = 1}, -- Letter U
	},
	[14435] = { -- Pink Level 3
		{id = 6569, chance = 1500, count = 10}, -- Candies
		{id = 6577, chance = 1500, count = 1}, -- Green Balloon
		{id = 6575, chance = 1500, count = 1}, -- Red Balloon
		{id = 6578, chance = 1500, count = 1}, -- Party Hat
		{id = 6572, chance = 1500, count = 1}, -- Party Trumpet
		{id = 6576, chance = 1500, count = 1}, -- Fireworks Rocket
		{id = 6574, chance = 1500, count = 1}, -- Bar of Chocolate
		{id = 7966, chance = 1500, count = 1}, -- Birthday Cake
		{id = 12245, chance = 1500, count = 5}, -- Pokemon Great Health Potion
		{id = 2114, chance = 100, count = 1}, -- Piggy Bank
		{id = 14438, chance = 40, count = 1}, -- Letter L
		{id = 14439, chance = 40, count = 1}, -- Letter O
		{id = 14440, chance = 40, count = 1}, -- Letter P
		{id = 14441, chance = 40, count = 1}, -- Letter S
		{id = 14442, chance = 40, count = 1}, -- Letter U
	},
	[14436] = { -- Red Level 4
		{id = 6569, chance = 1500, count = 13}, -- Candies
		{id = 6577, chance = 1500, count = 1}, -- Green Balloon
		{id = 6575, chance = 1500, count = 1}, -- Red Balloon
		{id = 6578, chance = 1500, count = 1}, -- Party Hat
		{id = 6572, chance = 1500, count = 1}, -- Party Trumpet
		{id = 6576, chance = 1500, count = 1}, -- Fireworks Rocket
		{id = 6574, chance = 1500, count = 1}, -- Bar of Chocolate
		{id = 7966, chance = 1500, count = 1}, -- Birthday Cake
		{id = 12246, chance = 1500, count = 5}, -- Pokemon Ultra Health Potion
		{id = 2114, chance = 150, count = 1}, -- Piggy Bank
		{id = 14438, chance = 50, count = 1}, -- Letter L
		{id = 14439, chance = 50, count = 1}, -- Letter O
		{id = 14440, chance = 50, count = 1}, -- Letter P
		{id = 14441, chance = 50, count = 1}, -- Letter S
		{id = 14442, chance = 50, count = 1}, -- Letter U
	},
	[14437] = { -- Yellow Level 5
		{id = 6569, chance = 1500, count = 15}, -- Candies
		{id = 6577, chance = 1500, count = 1}, -- Green Balloon
		{id = 6575, chance = 1500, count = 1}, -- Red Balloon
		{id = 6578, chance = 1500, count = 1}, -- Party Hat
		{id = 6572, chance = 1500, count = 1}, -- Party Trumpet
		{id = 6576, chance = 1500, count = 1}, -- Fireworks Rocket
		{id = 6574, chance = 1500, count = 1}, -- Bar of Chocolate
		{id = 7966, chance = 1500, count = 1}, -- Birthday Cake
		{id = 12247, chance = 1500, count = 5}, -- Pokemon Super Health Potion
		{id = 2114, chance = 150, count = 1}, -- Piggy Bank
		{id = 14438, chance = 60, count = 1}, -- Letter L
		{id = 14439, chance = 60, count = 1}, -- Letter O
		{id = 14440, chance = 60, count = 1}, -- Letter P
		{id = 14441, chance = 60, count = 1}, -- Letter S
		{id = 14442, chance = 60, count = 1}, -- Letter U
	}
}
local CHANCE_MAX = 100000

function onUse(cid, item, fromPosition, itemEx, toPosition)
	local out = ""
	for i, reward in ipairs(BIRTHDAY_BOXES[item.itemid]) do
		if (getRandom(0, CHANCE_MAX) <= (reward.chance * 20)) then -- 20 is the number of monsters that need be killed to drop a box, chance x 20 = monster loot like formula
			local count = getRandom(1, reward.count)
			doPlayerAddItem(cid, reward.id, count, true)
			out = out .. "\n" .. getItemNameById(reward.id) .. " [" .. count .. "x]"
		end
	end
	if (out ~= "") then
		doPlayerSendTextMessage(cid, MESSAGE_EVENT_ORANGE, string.format(__L(cid, "This %s contains:%s."), getItemNameById(item.itemid), out))
		doSendMagicEffect(getCreaturePosition(cid), EFFECT_FIREWORK_YELLOW)
	else
		doPlayerSendTextMessage(cid, MESSAGE_EVENT_ORANGE, string.format(__L(cid, "This %s is empty."), getItemNameById(item.itemid)))
		doSendMagicEffect(getCreaturePosition(cid), EFFECT_POFF)
	end
	doRemoveItem(item.uid)
	return true
end
