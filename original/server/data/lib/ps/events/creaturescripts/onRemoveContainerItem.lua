function onRemoveContainerItem(cid, item)
	if (isItem(item)) then
		if (isBallWithPokemon(item.uid)) then
			doPlayerSendPokemonWindowRemovePokemonIcon(cid, getFastcallNumber(item.uid))

		elseif (isContainer(item.uid)) then
            for k, v in pairs(getContainerItems(item.uid, true)) do
                if (isBallWithPokemon(v.uid)) then
					doPlayerSendPokemonWindowRemovePokemonIcon(cid, getFastcallNumber(v.uid))
                end
            end
		end
	end
end
