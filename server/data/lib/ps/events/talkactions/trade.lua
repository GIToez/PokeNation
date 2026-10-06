local function doPlayerAutoTrade(cid, message)
	if (isPlayer(cid) and getPlayerAutoTrade(cid)) then
		doPlayerTalkOnChannel(cid, message, TALKTYPE_CHANNEL_Y, 5)
		addEvent(doPlayerAutoTrade, 2 * 60 * 1000 + 1000, cid, message) -- 2 minutes + 1 second, to prevent problems
	end
end

function onSay(cid, words, param)
	if (not param or string.len(param) < 1 or param == 'off') then
		if (getPlayerAutoTrade(cid)) then
			setPlayerAutoTrade(cid, false)
			doPlayerSendTextMessage(cid, MESSAGE_EVENT_ORANGE, "Auto Trade OFF!")
		else
			doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "You are not using Auto Trade.")
		end

	elseif (string.len(param) < 8) then
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Your offer must contain at least 8 characters, please try again.")

	elseif (getPlayerAutoTrade(cid)) then
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "You are already using Auto Trade! To change the message first say '/autoTrade off'.")

	elseif (getCreatureCondition(cid, CONDITION_MUTED, 2)) then -- Prevent alot of events running same time, cuz if a player stop and start the event again during the delay more then one event will run (this can crash the server, think about alot of events)
		doPlayerSendTextMessage(cid, MESSAGE_EVENT_ORANGE, "You may only place one offer in two minutes!")

	else
		setPlayerAutoTrade(cid, true)
		doPlayerAutoTrade(cid, param)
		doPlayerSendTextMessage(cid, MESSAGE_EVENT_ORANGE, "Auto Trade ON!")
	end

	return true
end
