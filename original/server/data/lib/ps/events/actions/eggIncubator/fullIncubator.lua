local INCUBATOR_STORAGE_BORN_DATE = 1000
local INCUBATOR_STORAGE_POKEMON_NAME = 1001
local SHINY_CHANCE = getConfigValue("shinyAppearChance")

function onUse(cid, item, fromPosition, itemEx, toPosition)
	local currentDate = getCurrentTimeInSeconds()
	local bornDate = getItemAttribute(item.uid, INCUBATOR_STORAGE_BORN_DATE) or currentDate
	local remaingTime = bornDate - currentDate
	local pokemonName = getItemAttribute(item.uid, INCUBATOR_STORAGE_POKEMON_NAME)
	local pokemonDescription = getMonsterInfo(pokemonName).description or pokemonName

	if (remaingTime > 0) then
		local remaingDays = math.ceil(remaingTime / 60 / 60 / 24)
		if (remaingDays > 5) then -- Bug fix
			local diff = remaingDays - 365
			if (diff < 1) then
				diff = 1
			end
			remaingTime = getCurrentTimeInSeconds() + (60 * 60 * 24 * diff)
			doItemSetAttribute(item.uid, INCUBATOR_STORAGE_BORN_DATE, remaingTime)
		end

		local eggMove = getItemAttribute(item.uid, ITEM_ATTRIBUTES.EGG_MOVE)
		local eggMoveTypeText = "None"
		if (eggMove) then
			eggMoveTypeText = ELEMENT_NAMES[getPokemonSkillDamageType(eggMove)]
		end


		local msg = math.ceil(remaingTime / 60) .. " minutes (" .. math.ceil(remaingTime / 60 / 60 / 24) .. " days)"
		doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, string.format("Remaing %s for this egg to hatch.", msg))
		doItemSetSpecialDescription(item.uid, "This incubator is hatching " .. pokemonDescription .. " egg.\nLast check: " ..
				msg .. " on " .. os.date("%a %b %d %X %Y", os.time()) .. ". Egg Move type: " .. eggMoveTypeText .. ".")

    else
        PokemonEgg.onEggHatch(cid, item, pokemonName)
		--[[
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Congratulations! Your " .. pokemonName ..
                " egg hatches!")
		if (getRandom(0, SHINY_CHANCE) == 0) then
			pokemonName = getMonsterInfo(pokemonName).shiny
		end
		doCreatePokemonBall(cid, "poke", pokemonName, 1, nil, nil, 10, nil, true, 9999999, nil)
		doRemoveItem(item.uid)
		doSendMagicEffect(getCreaturePosition(cid), EFFECT_FIREWORK_YELLOW)
		]]
	end

	return true
end
