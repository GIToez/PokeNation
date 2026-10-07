function onDeEquip(cid, item)
	setPlayerIcons(cid, item, false)
	return true
end

function onEquip(cid, item)
	if (isItem(item)) then
		setPlayerIcons(cid, item, true)
		return true
	end
	return false
end

