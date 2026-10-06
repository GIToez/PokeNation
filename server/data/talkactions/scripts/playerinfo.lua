function onSay(cid, words, param, channel)
	if(param == '') then
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Command param required.")
		return true
	end

	local pid = getPlayerByNameWildcard(param)
	if(not pid or (isPlayerGhost(pid) and getPlayerGhostAccess(pid) > getPlayerGhostAccess(cid))) then
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Player " .. param .. " not found.")
		return true
	end

	local tmp = {accountId = getPlayerAccountId(pid), ip = getPlayerIp(pid)}
	local pos = getCreaturePosition(pid)
	doPlayerPopupFYI(cid, "Information about player" ..
		"\nName: " .. getCreatureName(pid) ..
		"\nGUID: " .. getPlayerGUID(pid) ..
		"\nGroup: " .. getPlayerGroupName(pid) ..
		"\nAccess: " .. getPlayerAccess(pid) ..
		"\nVocation: " .. getVocationInfo(getPlayerVocation(pid)).name ..
		"\nStatus:" ..
			"\nLevel - " .. getPlayerLevel(pid) .. ", Pokemon Level - " .. getPlayerMagLevel(pid) .. ", Speed - " .. getCreatureSpeed(pid) ..
			"\nHealth - " .. getCreatureHealth(pid) .. " / " .. getCreatureMaxHealth(pid) .. ", Mana - " .. getCreatureMana(pid) .. " / " .. getCreatureMaxMana(pid) ..
			"\nSkills:" ..
			"\nDuel Win - " .. getPlayerSkillLevel(pid, PLAYER_SKILL_DUEL_WIN) .. ", Duel Loss - " .. getPlayerSkillLevel(pid, PLAYER_SKILL_DUEL_LOSS) .. ", Battle Win - " .. getPlayerSkillLevel(pid, PLAYER_SKILL_BATTLE_WIN) .. ", Battle Loss - " .. getPlayerSkillLevel(pid, PLAYER_SKILL_BATTLE_LOSS) ..
			"\nHeadbutting - " .. getPlayerSkillLevel(pid, PLAYER_SKILL_HEADBUTTING) .. ", Catching - " .. getPlayerSkillLevel(pid, PLAYER_SKILL_CATCHING) .. ", Fishing - " .. getPlayerSkillLevel(pid, PLAYER_SKILL_FISHING) ..
		"\nCash:" ..
			"\nGold Bar - " .. getPlayerItemCount(pid, 2160) .. ", Note of Hundred Dollar - " .. getPlayerItemCount(pid, 2152) .. ", Dollar - " .. getPlayerItemCount(pid, 2148) ..
			"\nBalance: " .. getPlayerBalance(pid) ..
			"\nPosition: [X - " .. pos.x .. " | Y - " .. pos.y .. " | Z - " .. pos.z .. "]" ..
		"\nStamina: " .. table.concat(string.timediff(getPlayerStamina(cid) * 60, cid)) ..
		"\nOnline Time: " .. table.concat(string.timediff(os.time() - getPlayerLastLogin(pid), cid)) ..
		"\n\nInformation about account" ..
		"\nName: " .. getPlayerAccount(pid) ..
		"\nID: " .. tmp.accountId ..
		"\nNotations: " .. getNotationsCount(tmp.accountId) ..
		"\nIP: " .. doConvertIntegerToIp(tmp.ip) .. " (" .. tmp.ip .. ")")
	return true
end
