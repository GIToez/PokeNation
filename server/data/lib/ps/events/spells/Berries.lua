local berries = {13182, 13183, 13184, 13185, 14766, 13186, 14767, 14768, 14769, 14770}

function onCastSpell(cid)
	if (isPokemonWild(cid)) then
        local pos = getCreaturePosition(cid)
        onCreatureUseBerry(cid, table.random(berries), pos, cid, pos, true)
	end
	return true
end
