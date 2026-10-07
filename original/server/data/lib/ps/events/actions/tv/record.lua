function onUse(cid, item, fromPosition, itemEx, toPosition)
	if (getPlayerRecordingTV(cid)) then
		doPlayerSendCancel(cid, "You're already recording.")
	elseif (not isPremium(cid)) then
		doPlayerSendDefaultCancel(cid, RETURNVALUE_YOUNEEDPREMIUMACCOUNT)
	elseif (doPlayerCreateTVChannel(cid)) then
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Welcome to your TV channel! Command list:\n- /tvname new_name - Change your TV channel name\n- /tvkick player_name - Kick a viewer\n- /tvlist - List all viewers\n- /tvban player_name - Ban a viewer\n- /tvunban player_name - Unban a viewer\n- /tvpassword new_password - Create a required password to watch the channel")
	else
		doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
	end
	return true
end
