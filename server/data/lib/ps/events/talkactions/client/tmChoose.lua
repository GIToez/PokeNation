function onSay(cid, words, param)
	if (not param) then
		return false
    end

    onTmChoose(cid, tonumber(param))
	return true
end
