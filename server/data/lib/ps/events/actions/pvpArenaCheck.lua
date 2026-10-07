function onUse(cid, item, fromPosition, itemEx, toPosition)
	local arenaId = getPvpArenaByActionId(item.actionid)
	if (arenaId) then
		local users = getPvpArenaUsersCount(arenaId)
		if (users) then
			doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, string.format(__L(cid, "Arena #%s status - blue team: %s / red team: %s."), arenaId, users.blue, users.red))
		end
	end
	return true
end
