local DELIVERIES = {
	-- Pallet
	[{x = 3282, y = 815, z = 7}] = 8578,
	[{x = 3290, y = 823, z = 7}] = 8579,
	[{x = 3300, y = 825, z = 7}] = 8580,
	[{x = 3317, y = 831, z = 7}] = 8581,
	[{x = 3304, y = 813, z = 7}] = 8582,
	-- Viridian
	[{x = 3290, y = 575, z = 7}] = 8583,
	[{x = 3301, y = 581, z = 7}] = 8584,
	[{x = 3273, y = 559, z = 7}] = 8585,
	[{x = 3292, y = 548, z = 7}] = 8586,
	[{x = 3317, y = 588, z = 7}] = 8587,
	-- Pewter
	[{x = 3296, y = 277, z = 7}] = 8588,
	[{x = 3321, y = 286, z = 7}] = 8589,
	[{x = 3326, y = 302, z = 7}] = 8590,
	[{x = 3310, y = 315, z = 7}] = 8591,
	[{x = 3290, y = 296, z = 7}] = 8592,
	-- Cerulean
	[{x = 3899, y = 275, z = 7}] = 8593,
	[{x = 3930, y = 291, z = 7}] = 8594,
	[{x = 3913, y = 332, z = 7}] = 8595,
	[{x = 3858, y = 325, z = 7}] = 8596,
	[{x = 3845, y = 295, z = 7}] = 8597,
	-- Saffron
	[{x = 3927, y = 460, z = 7}] = 8598,
	[{x = 3950, y = 461, z = 7}] = 8599,
	[{x = 3970, y = 491, z = 7}] = 8601,
	[{x = 3928, y = 508, z = 7}] = 8602,
	[{x = 3914, y = 472, z = 7}] = 8603,
	-- Celadon
	[{x = 3653, y = 415, z = 7}] = 8604,
	[{x = 3704, y = 425, z = 7}] = 8605,
	[{x = 3697, y = 459, z = 7}] = 8606,
	[{x = 3653, y = 451, z = 7}] = 8607,
	[{x = 3670, y = 440, z = 7}] = 8608,
	-- Lavender
	[{x = 4199, y = 536, z = 7}] = 8609,
	[{x = 4209, y = 563, z = 7}] = 8610,
	[{x = 4200, y = 592, z = 7}] = 8611,
	[{x = 4168, y = 587, z = 7}] = 8612,
	[{x = 4171, y = 565, z = 7}] = 8613,
	-- Vermilion
	[{x = 3946, y = 612, z = 7}] = 8614,
	[{x = 3967, y = 610, z = 7}] = 8615,
	[{x = 3993, y = 639, z = 7}] = 8616,
	[{x = 3914, y = 653, z = 7}] = 8617,
	[{x = 3910, y = 607, z = 7}] = 8618,
	-- Fuchsia
	[{x = 3875, y = 814, z = 7}] = 8619,
	[{x = 3898, y = 829, z = 7}] = 8620,
	[{x = 3887, y = 858, z = 7}] = 8621,
	[{x = 3864, y = 859, z = 7}] = 8622,
	[{x = 3839, y = 828, z = 7}] = 8623,
	-- Cinnabar
	[{x = 3352, y = 1019, z = 7}] = 8624,
	[{x = 3385, y = 1017, z = 7}] = 8625,
	[{x = 3390, y = 1038, z = 7}] = 8626,
	[{x = 3360, y = 1057, z = 7}] = 8627,
	[{x = 3337, y = 1036, z = 7}] = 8628,
}

function onUse(cid, item, fromPosition, itemEx, toPosition)
	local delivery = nil
	for k, v in pairs(DELIVERIES) do
		if (doComparePositions(toPosition, k)) then
			delivery = v
			break
		end
	end

	if (not delivery) then
		doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
		return true
	end

	if (getCreatureStorage(cid, delivery) == QUEST_STATUS.FINISHED) then
		doPlayerSendCancel(cid, "You've already delivered there.")
		return true
	end

	doCreatureSetStorage(cid, delivery, QUEST_STATUS.FINISHED)
	doRemoveItem(item.uid, 1)
	doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "X-MAS!")
	doSendMagicEffect(toPosition, EFFECT_FIREWORK_RED)
	doSendDistanceShoot(getCreaturePosition(cid), toPosition, PROJECTILE_GRAVEL)
	doCreatureIncreaseStorage(cid, 8640)
	doPlayerAchievementCheck(cid, ACHIEVEMENT_IDS.GRINCH_XMAS_PRESENT_DELIVERY)
	return true
end
