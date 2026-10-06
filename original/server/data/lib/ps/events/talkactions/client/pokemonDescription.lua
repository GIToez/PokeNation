function onSay(cid, words, param)
	if (not param) then
		doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
	else
		local ball = getFastcallBall(cid, param)
		if (not ball) then
			doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
		else
			doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, getItemSpecialDescription(ball))
		end
	end
	return true
end
