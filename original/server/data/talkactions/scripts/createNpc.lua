function onSay(cid, words, param, channel)
	doCreateNpc(param, getCreaturePosition(cid))
	return true
end
