function onSay(cid, words, param, channel)
	if (not getPlayerRecordingTV(cid)) then
		doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
	elseif (not param or param == '') then
	    doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Command param required.")
	else
		local kicked = getPlayerByName(param)
		if (kicked and isPlayer(kicked)) then
			local tvChannelId = getPlayerTVChannelId(cid)
			if (tvChannelId and tvChannelId > 0) then
				doPlayerLeaveTVChannel(tvChannelId, kicked)
			else
				doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
			end
		else
			doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "No player with this name was found.")
		end
	end
	return true
end
