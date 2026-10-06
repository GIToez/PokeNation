local tradeBanCondition = createConditionObject(CONDITION_MUTED, 60 * 60 * 1000, false, 2, true)
local helpBanCondition = createConditionObject(CONDITION_MUTED, 60 * 60 * 1000, false, 3, true)
local chatBanCondition = createConditionObject(CONDITION_MUTED, 60 * 60 * 1000, false, 4, true)

function onSay(cid, words, param)
	local pid = 0
	if (param == '') then
		pid = getCreatureTarget(cid)
		if (pid == 0) then
			doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Command param required.")
			return true
		end
	else
		pid = getPlayerByNameWildcard(param)
	end

	if (not pid) then
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(cid, "Player %s is not currently online."), param))
		return true
	end

	if (isPlayer(pid) and getPlayerAccess(pid) >= getPlayerAccess(cid) or (isTutor(pid) and isTutor(cid))) then
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "You cannot chat ban this player.")
		return true
	end

	doAddCondition(pid, tradeBanCondition)
	doAddCondition(pid, helpBanCondition)
	doAddCondition(pid, chatBanCondition)
	doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(cid, "%s has been baned from all game-chats for 60 minutes."), getCreatureName(pid)))
	doPlayerSendTextMessage(pid, MESSAGE_STATUS_CONSOLE_BLUE, "You have been banned from all game-chats for 60 minutes.")
	return true
end
