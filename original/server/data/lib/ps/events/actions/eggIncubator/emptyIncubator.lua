local INCUBATOR_STORAGE_BORN_DATE = 1000
local INCUBATOR_STORAGE_POKEMON_NAME = 1001

function onUse(cid, item, fromPosition, itemEx, toPosition)
	if (not isItem(itemEx)) then
		doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)

	else
		local pokemonName = getPokemonNameByEggId(itemEx.itemid)

		if (not pokemonName) then
			doPlayerSendCancel(cid, "You can only use the incubator in an Pokemon egg.")

		else
			local eggMove = getItemAttribute(itemEx.uid, ITEM_ATTRIBUTES.EGG_MOVE)
            doRemoveItem(itemEx.uid) -- Remove egg
			doTransformItem(item.uid, 14049) -- Transforming to a full pokemon incubator
			doItemSetAttribute(item.uid, INCUBATOR_STORAGE_BORN_DATE, getCurrentTimeInSeconds() + 60 * 60)-- * 24 * 5) -- current time in seconds + 5 days in seconds
			doItemSetAttribute(item.uid, INCUBATOR_STORAGE_POKEMON_NAME, pokemonName)
            if (eggMove) then
			    doItemSetAttribute(item.uid, ITEM_ATTRIBUTES.EGG_MOVE, eggMove)
            end
			doItemSetSpecialDescription(item.uid, string.format(__L(cid, "This incubator is hatching %s %s."), getItemArticleById(itemEx.itemid), getItemNameById(itemEx.itemid)))

			doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(cid, "Your %s egg is hatching now! Use this incubator again after 60 minutes."), pokemonName))
			doSendMagicEffect(getCreaturePosition(cid), EFFECT_FIREWORK_BLUE)
		end
	end

	return true
end
