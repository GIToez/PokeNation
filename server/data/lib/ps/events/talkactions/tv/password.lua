function onSay(cid, words, param, channel)
	if (not getPlayerRecordingTV(cid)) then
		doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
	elseif (not param or param == '') then
        setTVChannelPassword(cid, "")
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Your TV Channel password has been unlocked.")
	elseif (string.len(param) < 4 or string.len(param) > 20) then
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "The new TV Channel password need be between 4 and 20 characters.")
	elseif (setTVChannelPassword(cid, param)) then
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(cid, "Your TV Channel password has successfully changed to '%s'."), param))
	else
		doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
	end
	return true
end
