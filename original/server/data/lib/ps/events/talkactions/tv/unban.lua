function onSay(cid, words, param, channel)
	if (not getPlayerRecordingTV(cid)) then
		doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
	elseif (not param or param == '') then
	    doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Command param required.")
	else
		local banned = getPlayerByName(param)
		if (banned and isPlayer(banned)) then
			local tvChannelId = getPlayerTVChannelId(cid)
			if (tvChannelId and tvChannelId > 0) then
				doTVChannelUnban(tvChannelId, banned)
			else
				doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
			end
		else
			doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "No player with this name was found.")
		end
	end
	return true
end
