function onSay(cid, words, param, channel)
	if (not getPlayerRecordingTV(cid)) then
		doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
	elseif (not param or param == '') then
	    doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Command param required.")
	else
		local banned = getPlayerByName(param)
		if (banned and isPlayer(banned)) then
			local tvChannelId = getPlayerTVChannelId(cid)
			if (not tvChannelId or tvChannelId == 0 or not doTVChannelBan(tvChannelId, banned)) then
				doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
			end
		else
			doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "No player with this name was found.")
		end
	end
	return true
end
