function onSay(cid, words, param, channel)
  doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, string.format(__L(cid, "The time now is %s (%s)."), getGameTimeString(), __L(cid, WORLD_LIGHT_STATE_NAMES[getWorldLightState()])))
	return true
end
