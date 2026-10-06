local HORN = 2079
local BIRD_CAGE = 2095
local WOODEN_WHISTLE = 5786
local DIDGERIDOO = 3952
local CORNUCOPIA = 2369
local PARTY_TRUMPET = 6572
local USED_PARTY_TRUMPET = 6573
local GREEN_NOTES = {2070, 2071, 2073, 2075, 2076, 2078, 2367, 2374}

function onUse(cid, item, fromPosition, itemEx, toPosition)
	local random = math.random(1, 5)
	if(item.itemid == BIRD_CAGE) then
		doSendMagicEffect(fromPosition, EFFECT_YELLOW_SOUND)
	elseif(item.itemid == DIDGERIDOO) then
		if(random == 1) then
			doSendMagicEffect(fromPosition, EFFECT_BLUE_SOUND)
			return true
		end
	elseif(item.itemid == PARTY_TRUMPET) then
		doTransformItem(item.uid, USED_PARTY_TRUMPET)
		doCreatureSay(cid, "TOOOOOOT!", TALKTYPE_ORANGE_1)

		doSendMagicEffect(fromPosition, EFFECT_BLUE_SOUND)
		doDecayItem(item.uid)
	elseif(item.itemid == CORNUCOPIA) then
		for i = 1, 11 do
			doPlayerAddItem(cid, 2681)
		end

		doRemoveItem(item.uid, 1)
		doSendMagicEffect(fromPosition, EFFECT_YELLOW_SOUND)
	elseif(item.itemid == WOODEN_WHISTLE) then
		if(random == 2) then
			doSendMagicEffect(fromPosition, EFFECT_RED_SOUND)
			doRemoveItem(item.uid, 1)
			return true
		end

		local position = getPlayerPosition(cid)
		position.x = position.x + 1

		doSendMagicEffect(fromPosition, EFFECT_PURPLE_SOUND)
		--doSummonCreature("Wolf", pos)
	else
		local effect = EFFECT_BLUE_SOUND
		if(item.itemid == HORN) then
			effect = EFFECT_PURPLE_SOUND
		elseif(isInArray(GREEN_NOTES, item.itemid)) then
			effect = EFFECT_GREEN_SOUND
		end

		doSendMagicEffect(fromPosition, effect)
	end

	return true
end
