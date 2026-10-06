function onSay(cid, words, param)
    local last = getCreatureStorage(cid, BOSS_REWARD_STORAGE)
    if (last == -1 or ((os.time() - last) >= BOSS_REWARD_INTERVAL)) then
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "You are able to receive another World Boss reward.")
    else
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(cid, "You must wait %s to be able to receive another World Boss reward."), table.concat(string.timediff(BOSS_REWARD_INTERVAL - (os.time() - last), cid))))
    end

	return true
end
