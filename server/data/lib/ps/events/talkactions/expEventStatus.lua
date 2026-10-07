function onSay(cid, words, param, channel)
	doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, ExpEvent.getStatusText(cid))
	return true
end
