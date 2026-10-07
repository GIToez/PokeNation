function onUse(cid, item, fromPosition, itemEx, toPosition)
	doPlayerSendChannelsDialog(cid, {CHANNEL_HIGHSCORES, CHANNEL_CAUGHTS})
	return true
end
