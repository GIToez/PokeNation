local FISHING_FLOAT_ID = 13181
local SHINY_CHANCE = getConfigValue("shinyAppearChance")

local POKEMON_BY_SKILL_KANTO = {
	{skill = 0, pokemons = {"Magikarp"}},
	{skill = 10, pokemons = {"Magikarp", "Krabby"}},
	{skill = 20, pokemons = {"Magikarp", "Krabby", "Poliwag"}},
	{skill = 40, pokemons = {"Magikarp", "Krabby", "Poliwag", "Horsea"}},
	{skill = 50, pokemons = {"Magikarp", "Krabby", "Poliwag", "Horsea", "Goldeen"}},
	{skill = 60, pokemons = {"Magikarp", "Krabby", "Poliwag", "Horsea", "Goldeen", "Tentacool"}},
	{skill = 70, pokemons = {"Magikarp", "Krabby", "Poliwag", "Horsea", "Goldeen", "Tentacool", "Shellder"}},
	{skill = 100, pokemons = {"Magikarp", "Krabby", "Poliwag", "Horsea", "Goldeen", "Tentacool", "Shellder", "Kingler"}},
	{skill = 130, pokemons = {"Magikarp", "Krabby", "Poliwag", "Horsea", "Goldeen", "Tentacool", "Shellder", "Kingler", "Poliwhirl"}},
	{skill = 160, pokemons = {"Magikarp", "Krabby", "Poliwag", "Horsea", "Goldeen", "Tentacool", "Shellder", "Kingler", "Poliwhirl", "Seaking"}},
	{skill = 180, pokemons = {"Magikarp", "Krabby", "Poliwag", "Horsea", "Goldeen", "Tentacool", "Shellder", "Kingler", "Poliwhirl", "Seaking", "Seadra"}},
	{skill = 200, pokemons = {"Magikarp", "Krabby", "Poliwag", "Horsea", "Goldeen", "Tentacool", "Shellder", "Kingler", "Poliwhirl", "Seaking", "Seadra", "Cloyster"}},
}

local POKEMON_BY_SKILL_ORANGE_ARCHIPELAGO = {
    {skill = 0, pokemons = {"Magikarp"}},
	{skill = 10, pokemons = {"Magikarp", "Krabby"}},
	{skill = 20, pokemons = {"Magikarp", "Krabby", "Poliwag", "Marill"}},
	{skill = 40, pokemons = {"Magikarp", "Krabby", "Poliwag", "Horsea", "Marill", "Wooper",}},
	{skill = 50, pokemons = {"Magikarp", "Krabby", "Poliwag", "Horsea", "Goldeen", "Marill", "Wooper", "Remoraid"}},
	{skill = 60, pokemons = {"Magikarp", "Krabby", "Poliwag", "Horsea", "Goldeen", "Tentacool", "Marill", "Wooper", "Remoraid"}},
	{skill = 70, pokemons = {"Magikarp", "Krabby", "Poliwag", "Horsea", "Goldeen", "Tentacool", "Shellder", "Marill", "Wooper", "Remoraid", "Qwilfish"}},
	{skill = 100, pokemons = {"Magikarp", "Krabby", "Poliwag", "Horsea", "Goldeen", "Tentacool", "Shellder", "Kingler", "Marill", "Wooper", "Remoraid", "Qwilfish", "Corsola"}},
	{skill = 130, pokemons = {"Magikarp", "Krabby", "Poliwag", "Horsea", "Goldeen", "Tentacool", "Shellder", "Kingler", "Poliwhirl", "Marill", "Wooper", "Remoraid", "Qwilfish", "Corsola"}},
	{skill = 160, pokemons = {"Magikarp", "Krabby", "Poliwag", "Horsea", "Goldeen", "Tentacool", "Shellder", "Kingler", "Poliwhirl", "Seaking", "Marill", "Wooper", "Remoraid", "Qwilfish", "Corsola"}},
	{skill = 180, pokemons = {"Magikarp", "Krabby", "Poliwag", "Horsea", "Goldeen", "Tentacool", "Shellder", "Kingler", "Poliwhirl", "Seaking", "Marill", "Wooper", "Remoraid", "Qwilfish", "Corsola", "Octillery"}},
	{skill = 200, pokemons = {"Magikarp", "Krabby", "Poliwag", "Horsea", "Goldeen", "Tentacool", "Shellder", "Kingler", "Poliwhirl", "Seaking", "Marill", "Wooper", "Remoraid", "Qwilfish", "Corsola", "Octillery", "Azumarill"}},
}

local RODS = {
	[12292] = {delay = 4, requiredSkill = 0, maxSkill = 70},
	[12293] = {delay = 5, requiredSkill = 40, maxSkill = 130},
	[12294] = {delay = 5, requiredSkill = 80, maxSkill = 200}
}

local function getPlayerFishingFormula(cid, rodId)
	return getPlayerSkill(cid, SKILL_FISHING) / 200 + 0.85 * math.random()
end

local function getPlayerFishablePokemons(cid, rodId)
	local playerFishingSkill = getPlayerSkill(cid, SKILL_FISHING)
	local pokemon_by_skill = getPlayerInsideOrangeArchipelago(cid) and POKEMON_BY_SKILL_ORANGE_ARCHIPELAGO
            or POKEMON_BY_SKILL_KANTO
    for i = #pokemon_by_skill, 1, -1 do
		if (RODS[rodId].maxSkill >= pokemon_by_skill[i].skill and
                pokemon_by_skill[i].skill <= playerFishingSkill) then
			return pokemon_by_skill[i].pokemons
		end
	end
end

local function doFishing(cid, fromPosition, toPosition, rod, tries, ticksToStart)
	local removed = false
    if (isPlayer(cid)) then
		local currentPosition = getCreaturePosition(cid)
		if (getDistanceBetween(currentPosition, fromPosition) > 1) then
			doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "You left your fishing spot and stopped to fish.")
			removed = true

		elseif (ticksToStart <= 0 and (getPlayerFishingFormula(cid, rod) > 1.0 or tries >= 3)) then
            local fishablePokemons = getPlayerFishablePokemons(cid, rod)
            local randomFishablePokemon = table.random(fishablePokemons)

            if (getRandom(0, SHINY_CHANCE) == 0) then
                local tmp = getMonsterInfo(randomFishablePokemon).shiny
                if (tmp and isString(tmp) and tmp ~= "") then
                    randomFishablePokemon = tmp
                end
            end

            local pokemonFished = doSummonCreature(randomFishablePokemon, fromPosition)
            local pos = getClosestFreeTile(pokemonFished, fromPosition)
            if (pos) then
                doTeleportThing(pokemonFished, pos)
                doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(cid, "You hooked %s!"), getMonsterInfo(randomFishablePokemon).description))
                doSendMagicEffect(currentPosition, EFFECT_EMOTION_EXCLAMATION)
                addEvent(doRemoveCreature, 3 * 60 * 1000, pokemonFished, true, false) -- remove creature after 3 min, force remove and don't show error
                setMonsterUniqueTarget(pokemonFished, cid)
                doPlayerAddStatistic(cid, PLAYER_STATISTIC_IDS.HOOKED_FISH, 1)

                if (RODS[rod].maxSkill > getPlayerSkill(cid, SKILL_FISHING)) then
                    doPlayerAddSkillTry(cid, SKILL_FISHING, (25 / (getPlayerSkill(cid, SKILL_FISHING) + 1)) +
                            (tries / 3))
                end

            else
                doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE,
                    "There is no free space next to you, please move to a different spot!")
                doRemoveCreature(pokemonFished)
            end

            removed = true

        else
            doSendMagicEffect(currentPosition, EFFECT_EMOTION_THREE_POINTS)
            doCreatureSetLookDirection(cid, getDirectionTo(fromPosition, toPosition, true))
            addEvent(doFishing, 2000, cid, fromPosition, toPosition, rod, tries + 1, ticksToStart - 2)
        end

	else
		removed = true
    end

    if (removed) then
        local item = getTileItemById(toPosition, FISHING_FLOAT_ID)
        if (isItem(item)) then
            doRemoveItem(item.uid)
            doSendMagicEffect(toPosition, EFFECT_WATER_PULSE)
        end
        if (isCreature(cid)) then
            setFishingStatus(cid, false)
            doRemoveCondition(cid, CONDITION_OUTFIT, CONDITION_SUBID.OUTFITS.FISHING)
        end
    end
end

function onUse(cid, item, fromPosition, itemEx, toPosition)
	--[[
    if (not isInArray(WATER_IDS, itemEx.itemid) or getSafariZone(cid) or getPlayerMounted(cid) or
            isBiking(cid) or getPlayerFrontierIsland(cid) or getPlayerPvpArena(cid) or
            getTileInfo(toPosition).things > 1) then
		doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)

	elseif (isFishing(cid)) then
		doPlayerSendCancel(cid, "You're already fishing.")

    elseif (getTilePzInfo(getCreaturePosition(cid))) then
        doPlayerSendCancel(cid, "You can't fish while you're in a protection zone.")

	elseif (getPlayerSkill(cid, SKILL_FISHING) < RODS[item.itemid].requiredSkill) then
		doPlayerSendCancel(cid, string.concat("You need at least skill ", RODS[item.itemid].requiredSkill,
            " to use this fishing rod."))

    elseif (getCreatureCondition(cid, CONDITION_EXHAUST, CONDITION_SUBID.EXHAUST.FISHING)) then
        doPlayerSendCancel(cid, "Your fishing is blocked, please try again in a few seconds.")

	else
		local pokemon = getPlayerPokemon(cid)
        if (isCreature(pokemon) and getTilePzInfo(getCreaturePosition(pokemon))) then
            doPlayerSendCancel(cid, "You can't fish while your pokemon is inside a protection zone.")
            return true
        end

        local playerPosition = getCreaturePosition(cid)
		if (getDistanceBetween(playerPosition, toPosition) > 4) then
			doPlayerSendDefaultCancel(cid, RETURNVALUE_TOOFARAWAY)

		else
			doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "You are fishing now.")
			setFishingStatus(cid, true)
			doCreateItem(FISHING_FLOAT_ID, 1, toPosition)
			doSendDistanceShoot(playerPosition, toPosition, PROJECTILE_GRAVEL)
			doSendMagicEffect(toPosition, EFFECT_WATER_PULSE)
			addEvent(doFishing, 1000, cid, playerPosition, toPosition, item.itemid, 0,
                RODS[item.itemid].delay - 1)

            local outfit = getCreatureOutfit(cid)
            outfit.lookType = getPlayerSex(cid) == PLAYERSEX_FEMALE and 1227 or 1228
            doSetCreatureOutfit(cid, outfit, -1, CONDITION_SUBID.OUTFITS.FISHING)
            doCreatureSetLookDirection(cid, getDirectionTo(playerPosition, toPosition, true))
		end
	end]]
    Fishing.onFishing(cid, item, fromPosition, itemEx, toPosition)
	return true
end
