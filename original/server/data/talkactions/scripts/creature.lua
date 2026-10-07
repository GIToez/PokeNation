function onSay(cid, words, param, channel)
	local func = doCreateMonster
	if(words:sub(2, 2) == "n") then
		func = doCreateNpc
	end

	local pid = cid
	local t = string.explode(param, ",")
	if(t[2]) then
		pid = getPlayerByNameWildcard(t[2])
		if(not pid) then
			doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Player " .. t[2] .. " not found.")
			return true
		end
	end

	local ret = func(t[1], getCreaturePosition(pid), false)
	if(tonumber(ret) == nil) then
		doPlayerSendDefaultCancel(cid, (ret == false and RETURNVALUE_NOTPOSSIBLE or RETURNVALUE_NOTENOUGHROOM))
	end
	return true
end
