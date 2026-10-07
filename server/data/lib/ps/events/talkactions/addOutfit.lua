function onSay(cid, words, param, channel)
	if(param == '') then
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Command requires param.")
		return true
	end

	local t = string.explode(param, ",")
	t[1] = tonumber(t[1])
	if(not t[1]) then
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Command requires numeric param.")
		return true
	end

	local pid
	if(t[2]) then
		pid = getPlayerByNameWildcard(t[2])
		if(not pid or (isPlayerGhost(pid) and getPlayerGhostAccess(pid) > getPlayerGhostAccess(cid))) then
			doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(cid, "Player %s not found."), t[2]))
			return true
		end
	end

	if (not pid) then
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Command requires param.")
		return true
	end

	local addon = 0
	if (t[3]) then
		t[3] = tonumber(t[3])
		addon = t[3]
	end

	doPlayerAddOutfitId(pid, t[1], addon)
	doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(cid, "Player '%s' received the outfit successfully."), t[2]))

	return true
end
