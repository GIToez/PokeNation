function onSay(cid, words, param)
	local langCode = string.stripAccents(param)
	if (not LANG_CODES[langCode]) then
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Incorrect language! Please type 'english' or 'portugues'.")
		return true
	end

	setPlayerLanguage(cid, LANG_CODES[langCode])
	doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(cid, "Your language has been update to %s!"), langCode))
	return true
end
