function onSay(cid, words, param, channel)
	if (not getPlayerRecordingTV(cid)) then
		doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
	else
		local viewersList = getTVChannelViewers(cid)
		if (viewersList and #viewersList > 0) then
			local list = ""
			for i, viewer in ipairs(viewersList) do
				if (i ~= #viewersList) then
					list = list .. getCreatureName(viewer) .. ", "
				else
					list = list .. getCreatureName(viewer) .. "."
				end
			end
			doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(cid, "Viewers: %s"), list))
		else
			doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Nobody is watching your TV Channel right now.")
		end
	end
	return true
end
