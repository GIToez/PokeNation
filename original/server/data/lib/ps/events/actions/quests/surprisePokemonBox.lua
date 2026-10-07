local RANDOM_POKEMONS = {14035, 14045, 14816}

function onUse(cid, item, fromPosition, itemEx, toPosition)
	if (isPlayerWithBackpackFull(cid)) then
		doPlayerSendCancel(cid, "Your backpack is full.")

	else
		doPlayerAddItem(cid, table.random(RANDOM_POKEMONS), 1)
		doRemoveItem(item.uid)
		doSendMagicEffect(getCreaturePosition(cid), EFFECT_FIREWORK_YELLOW)
	end

	return true
end
