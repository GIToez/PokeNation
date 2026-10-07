local config = {
	idleWarning = getConfigValue('idleWarningTime'),
	idleKick = getConfigValue('idleKickTime')
}

function onThink(cid, interval)
	if(getTileInfo(getCreaturePosition(cid)).nologout or getCreatureNoMove(cid) or
		getPlayerCustomFlagValue(cid, PLAYERCUSTOMFLAG_ALLOWIDLE) or getPlayerWatchingTV(cid)) then
		return true
	end

	local idleTime = getPlayerIdleTime(cid) + interval
	doPlayerSetIdleTime(cid, idleTime)
	if(config.idleKick > 0 and idleTime > config.idleKick) then
		doRemoveCreature(cid)
	elseif(config.idleWarning > 0 and idleTime == config.idleWarning) then
		local message = string.format(__L(cid, "You have been idle for %s minutes"), math.ceil(config.idleWarning / 60000))
		if(config.idleKick > 0) then
			message = message .. __L(cid, ", you will be disconnected in ")
			local diff = math.ceil((config.idleWarning - config.idleKick) / 60000)
			if(diff > 1) then
				message = message .. diff .. __L(cid, " minutes")
			else
				message = message .. __L(cid, "one minute")
			end

			message = message .. __L(cid, " if you are still idle")
		end

        message = message .. "."
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_WARNING, message)
        doPlayerPopupFYI(cid, message)
	end

	return true
end
