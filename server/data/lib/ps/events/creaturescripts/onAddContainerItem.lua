local function retryToLink(playerUid, ballId)
	doFastcallLink(playerUid, getPlayerItemByIdWithAttribute(playerUid, true, ballId, 1000, -2).uid)
end

function onAddContainerItem(cid, item)
	if (isItem(item)) then
		if (isBallWithPokemon(item.uid)) then
			doFastcallLink(cid, item.uid)

		elseif (isBallWithPokemonByBallId(item.itemid)) then -- this ball was created now, lets wait the script setup this ball correctly and after try again. We will mark this ball with -2 on attribute 1000.
			doItemSetAttribute(item.uid, 1000, -2)
			addEvent(retryToLink, 100, cid, item.itemid)

		elseif (isContainer(item.uid)) then
            for k, v in pairs(getContainerItems(item.uid, true)) do
                if (isBallWithPokemon(v.uid)) then
					doFastcallLink(cid, v.uid)
				end
            end
		end
	end
end
