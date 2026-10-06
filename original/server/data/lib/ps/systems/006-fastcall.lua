local MIN_FASTCALL_NUMBER = 0
local MAX_FASTCALL_NUMBER = 1000

local function generateFastcallNumber(playerUid)
	local newFastcallNumber = getCreatureStorage(playerUid, PLAYER_STORAGES.LAST_FASTCALL_NUMBER) + 1
	if (newFastcallNumber < MIN_FASTCALL_NUMBER or newFastcallNumber > MAX_FASTCALL_NUMBER) then
		newFastcallNumber = MIN_FASTCALL_NUMBER
	end
	doCreatureSetStorage(playerUid, PLAYER_STORAGES.LAST_FASTCALL_NUMBER, newFastcallNumber)
	return newFastcallNumber
end

function doFastcallLink(playerUid, ballUid)
	local newFastcallNumber = generateFastcallNumber(playerUid)
	local pokemonName = getBallPokemonName(ballUid)
	--local pokemonTotalHealth = getMonsterInfo(pokemonName).health + (70 * getBallPokemonLevel(ballUid))
	local pokemonCurrentHpPercent, textColor = getBallPokemonLastHpPercent(ballUid)

	if (pokemonCurrentHpPercent >= 80) then
		textColor = 0
	elseif (pokemonCurrentHpPercent >= 40) then
		textColor = 1
	else
		textColor = 2
    end

    if (pokemonCurrentHpPercent > 0) then
        pokemonCurrentHpPercent = tostring(pokemonCurrentHpPercent .. "%")
    else
        pokemonCurrentHpPercent = "FNT"
    end

	doItemSetAttribute(ballUid, 1000, newFastcallNumber)
	doPlayerSendPokemonWindowAddPokemonIcon(playerUid, getPokemonFastcallPortraitId(pokemonName), newFastcallNumber,
        textColor, pokemonCurrentHpPercent)
end

function getFastcallNumber(itemUid)
	return getItemAttribute(itemUid, 1000)
end

function getFastcallBall(playerUid, fastcallNumber)
    fastcallNumber = tonumber(fastcallNumber)
	for _, ball in pairs(getPlayerAllBallsWithPokemon(playerUid)) do
		if (tonumber(getFastcallNumber(ball.uid)) == fastcallNumber) then
			return ball.uid
		end
	end
	return false
end

function getFastcallPortrait(playerUid, ballUid)
	local fastcallContainer = getPlayerSlotItem(playerUid, CONST_SLOT_ARMOR).uid
	local fastcallContainerSize = getContainerSize(fastcallContainer) - 1
	local fastcallContainerPortraits = {}
	local fastcallNumber = getFastcallNumber(ballUid)

	for i = 0, fastcallContainerSize do
		local currentFastcallPortrait = getContainerItem(fastcallContainer, i)
		if (isItem(currentFastcallPortrait)) then
			table.insert(fastcallContainerPortraits, currentFastcallPortrait)
		end
	end

	for i = 1, #fastcallContainerPortraits do
		local currentPortraitFastcallNumber = getFastcallNumber(fastcallContainerPortraits[i].uid)
		if (fastcallNumber == currentPortraitFastcallNumber) then
			return fastcallContainerPortraits[i].uid
		end
	end

	return false
end
