function onUse(cid, item, fromPosition, itemEx, toPosition)
	doSendMagicEffect(fromPosition, table.random({EFFECT_YELLOW_SOUND, EFFECT_PURPLE_SOUND, EFFECT_RED_SOUND,
        EFFECT_BLUE_SOUND, EFFECT_YELLOW_SOUND, EFFECT_GREEN_SOUND}))
	return true
end
