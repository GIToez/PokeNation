local holes = {[468] = 469, [481] = 482, [483] = 484, [7932] = 7933, [8579] = 8585}
local grasses = {[2782] = 2781, [3985] = 3984}
local debris = 1336

local POKEMON_FAST_MOUNT_CONDITION = createConditionObject(CONDITION_HASTE, 999, -1, CONDITION_SUBID.HASTE.FAST_MOUNT)
setConditionParam(POKEMON_FAST_MOUNT_CONDITION, CONDITION_PARAM_SPEED, 120)

-- Abilities Speed START
RIDE_SPEED = {
    ["Ponyta"] = 120,
	["Rapidash"] = 140,
	["Doduo"] = 120,
	["Dodrio"] = 140,
	["Arcanine"] = 140,
	["Ninetales"] = 140,
	["Onix"] = 130,
	["Tauros"] = 140,
	["Rhyhorn"] = 130,
	["Venusaur"] = 120,
    -- 2nd Gen
    ["Bayleef"] = 120,
    ["Meganium"] = 140,
    ["Mareep"] = 120,
    ["Girafarig"] = 130,
    ["Steelix"] = 140,
    ["Piloswine"] = 130,
    ["Houndoom"] = 140,
    ["Stantler"] = 130,
    -- 3rd Gen
    ["Metagross"] = 130,
    ["Manectric"] = 140,
    ["Absol"] = 130,
    ["Lairon"] = 120,
    ["Aggron"] = 120,
    ["Shelgon"] = 120,
    ["Camerupt"] = 110,
    ["Mightyena"] = 120,
    ["Torkoal"] = 100,
}

local tmp = table.deepcopy(RIDE_SPEED)
for name, speed in pairs(RIDE_SPEED) do
    tmp[string.concat("Shiny ", name)] = speed
end
RIDE_SPEED = tmp

RIDE_SPEED_CONDITIONS = {}
for name, speed in pairs(RIDE_SPEED) do
    RIDE_SPEED_CONDITIONS[name] = {}

    RIDE_SPEED_CONDITIONS[name].default = createConditionObject(CONDITION_HASTE, -1, -1, CONDITION_SUBID.HASTE.ABILITIES)
    setConditionParam(RIDE_SPEED_CONDITIONS[name].default, CONDITION_PARAM_SPEED, (speed * 1.2))

    RIDE_SPEED_CONDITIONS[name].mastery = createConditionObject(CONDITION_HASTE, -1, -1, CONDITION_SUBID.HASTE.ABILITIES)
    setConditionParam(RIDE_SPEED_CONDITIONS[name].mastery, CONDITION_PARAM_SPEED, (speed * 1.2) * 1.5)
end
table.clear(RIDE_SPEED)
RIDE_SPEED = nil

FLY_SPEED = {
    -- 1st Gen
	["Pidgeot"] = 180,
	["Fearow"] = 180,
	["Charizard"] = 190,
	["Dragonite"] = 190,
	["Aerodactyl"] = 190,
	["Zapdos"] = 200,
	["Moltres"] = 200,
	["Articuno"] = 200,
	["Mew"] = 220,
	["Mewtwo"] = 220,
	["Porygon"] = 190,
    ["Farfetchd"] = 180,
    ["Dragonair"] = 190,
    -- 2nd Gen
    ["Noctowl"] = 180,
    ["Crobat"] = 190,
    ["Xatu"] = 180,
    ["Heracross"] = 180,
    ["Skarmory"] = 180,
    ["Porygon2"] = 190,
    -- 3rd Gen
    ["Altaria"] = 180,
    ["Flygon"] = 190,
    ["Latias"] = 200,
    ["Latios"] = 200,
    ["Pelipper"] = 170,
    ["Rayquaza"] = 200,
    ["Salamence"] = 190,
    ["Swablu"] = 180,
    ["Swellow"] = 200,
    ["Tropius"] = 180,
    ["Vibrava"] = 190,
    ["Wingull"] = 180,
}

local tmp = table.deepcopy(FLY_SPEED)
for name, speed in pairs(FLY_SPEED) do
    tmp[string.concat("Shiny ", name)] = speed
end
FLY_SPEED = tmp

FLY_SPEED_CONDITIONS = {}
for name, speed in pairs(FLY_SPEED) do
    FLY_SPEED_CONDITIONS[name] = {}

    FLY_SPEED_CONDITIONS[name].default = createConditionObject(CONDITION_HASTE, -1, -1, CONDITION_SUBID.HASTE.ABILITIES)
    setConditionParam(FLY_SPEED_CONDITIONS[name].default, CONDITION_PARAM_SPEED, (speed * 1.2))

    FLY_SPEED_CONDITIONS[name].mastery = createConditionObject(CONDITION_HASTE, -1, -1, CONDITION_SUBID.HASTE.ABILITIES)
    setConditionParam(FLY_SPEED_CONDITIONS[name].mastery, CONDITION_PARAM_SPEED, (speed * 1.2) * 1.5)
end
table.clear(FLY_SPEED)
FLY_SPEED = nil

LEVITATE_SPEED = {
    -- 1st Gen
	["Gengar"] = 190,
	-- Shiny
	--["Shiny Gengar"] = 190,
}

local tmp = table.deepcopy(LEVITATE_SPEED)
for name, speed in pairs(LEVITATE_SPEED) do
    tmp[string.concat("Shiny ", name)] = speed
end
LEVITATE_SPEED = tmp

LEVITATE_SPEED_CONDITIONS = {}
for name, speed in pairs(LEVITATE_SPEED) do
    LEVITATE_SPEED_CONDITIONS[name] = {}

    LEVITATE_SPEED_CONDITIONS[name].default = createConditionObject(CONDITION_HASTE, -1, -1, CONDITION_SUBID.HASTE.ABILITIES)
    setConditionParam(LEVITATE_SPEED_CONDITIONS[name].default, CONDITION_PARAM_SPEED, (speed * 1.2))

    LEVITATE_SPEED_CONDITIONS[name].mastery = createConditionObject(CONDITION_HASTE, -1, -1, CONDITION_SUBID.HASTE.ABILITIES)
    setConditionParam(LEVITATE_SPEED_CONDITIONS[name].mastery, CONDITION_PARAM_SPEED, (speed * 1.2) * 1.5)
end
table.clear(LEVITATE_SPEED)
LEVITATE_SPEED = nil

SURF_SPEED = {
    -- 1st Gen
	["Squirtle"] = 180,
	["Wartortle"] = 190,
	["Blastoise"] = 200,
	["Poliwag"] = 160,
	["Poliwhirl"] = 190,
	["Poliwrath"] = 200,
	["Goldeen"] = 180,
	["Seaking"] = 190,
	["Tentacool"] = 180,
	["Tentacruel"] = 200,
	["Staryu"] = 180,
	["Starmie"] = 190,
	["Dewgong"] = 190,
	["Lapras"] = 190,
	["Gyarados"] = 200,
	["Omastar"] = 190,
	["Kabutops"] = 200,
	["Vaporeon"] = 190,
	["Seadra"] = 190,
	["Golduck"] = 190,
	["Snorlax"] = 180,
    -- 2nd Gen
    ["Totodile"] = 180,
    ["Croconaw"] = 190,
    ["Feraligatr"] = 200,
    ["Marill"] = 160,
    ["Azumarill"] = 190,
    ["Politoed"] = 200,
    ["Wooper"] = 160,
    ["Quagsire"] = 190,
    ["Octillery"] = 190,
    ["Mantine"] = 190,
    ["Kingdra"] = 200,
    -- 3rd Gen
    ["Aggron"] = 160,
    ["Azurill"] = 160,
    ["Barboach"] = 170,
    ["Carvanha"] = 170,
    ["Clamperl"] = 170,
    ["Corphish"] = 170,
    ["Crawdaunt"] = 190,
    ["Feebas"] = 170,
    ["Gorebyss"] = 190,
    ["Hariyama"] = 160,
    ["Huntail"] = 190,
    ["Kyogre"] = 200,
    ["Latias"] = 200,
    ["Latios"] = 200,
    ["Linoone"] = 160,
    ["Lombre"] = 170,
    ["Lotad"] = 160,
    ["Ludicolo"] = 180,
    ["Luvdisc"] = 170,
    ["Makuhita"] = 160,
    ["Marshtomp"] = 180,
    ["Milotic"] = 190,
    ["Mudkip"] = 170,
    ["Pelipper"] = 180,
    ["Rayquaza"] = 200,
    ["Relicanth"] = 170,
    ["Sealeo"] = 170,
    ["Sharpedo"] = 190,
    ["Spheal"] = 160,
    ["Swampert"] = 170,
    ["Wailmer"] = 160,
    ["Wailord"] = 170,
    ["Walrein"] = 170,
    ["Zigzagoon"] = 160,
    ["Whiscash"] = 180,
}

local tmp = table.deepcopy(SURF_SPEED)
for name, speed in pairs(SURF_SPEED) do
    tmp[string.concat("Shiny ", name)] = speed
end
SURF_SPEED = tmp

SURF_SPEED_CONDITIONS = {}
for name, speed in pairs(SURF_SPEED) do
    SURF_SPEED_CONDITIONS[name] = {}

    SURF_SPEED_CONDITIONS[name].default = createConditionObject(CONDITION_HASTE, -1, -1, CONDITION_SUBID.HASTE.ABILITIES)
    setConditionParam(SURF_SPEED_CONDITIONS[name].default, CONDITION_PARAM_SPEED, (speed * 1.2))

    SURF_SPEED_CONDITIONS[name].mastery = createConditionObject(CONDITION_HASTE, -1, -1, CONDITION_SUBID.HASTE.ABILITIES)
    setConditionParam(SURF_SPEED_CONDITIONS[name].mastery, CONDITION_PARAM_SPEED, (speed * 1.2) * 1.5)
end
table.clear(SURF_SPEED)
SURF_SPEED = nil

DIVE_SPEED = {
	-- 1st Gen
    ["Squirtle"] = 160,
	["Wartortle"] = 170,
	["Blastoise"] = 180,
	["Poliwag"] = 160,
	["Poliwhirl"] = 170,
	["Poliwrath"] = 180,
	["Goldeen"] = 160,
	["Seaking"] = 170,
	["Tentacool"] = 160,
	["Tentacruel"] = 180,
	["Staryu"] = 160,
	["Starmie"] = 170,
	["Dewgong"] = 170,
	["Lapras"] = 170,
	["Gyarados"] = 180,
	["Omastar"] = 170,
	["Kabutops"] = 180,
	["Vaporeon"] = 170,
	["Seadra"] = 170,
	["Golduck"] = 170,
    -- 2nd Gen
    ["Totodile"] = 160,
    ["Croconaw"] = 170,
    ["Feraligatr"] = 180,
    ["Marill"] = 140,
    ["Azumarill"] = 170,
    ["Politoed"] = 180,
    ["Wooper"] = 140,
    ["Quagsire"] = 170,
    ["Octillery"] = 170,
    ["Mantine"] = 170,
    ["Kingdra"] = 180,
    -- 3rd Gen
    ["Carvanha"] = 170,
    ["Clamperl"] = 170,
    ["Crawdaunt"] = 190,
    ["Feebas"] = 170,
    ["Gorebyss"] = 190,
    ["Huntail"] = 190,
    ["Kyogre"] = 200,
    ["Lombre"] = 170,
    ["Ludicolo"] = 180,
    ["Luvdisc"] = 170,
    ["Marshtomp"] = 180,
    ["Milotic"] = 190,
    ["Rayquaza"] = 200,
    ["Relicanth"] = 170,
    ["Sealeo"] = 170,
    ["Sharpedo"] = 190,
    ["Spheal"] = 160,
    ["Swampert"] = 170,
    ["Wailmer"] = 160,
    ["Wailord"] = 170,
    ["Walrein"] = 170,
    ["Whiscash"] = 180,
}

local tmp = table.deepcopy(DIVE_SPEED)
for name, speed in pairs(DIVE_SPEED) do
    tmp[string.concat("Shiny ", name)] = speed
end
DIVE_SPEED = tmp

DIVE_SPEED_CONDITIONS = {}
for name, speed in pairs(DIVE_SPEED) do
    DIVE_SPEED_CONDITIONS[name] = {}

    DIVE_SPEED_CONDITIONS[name].default = createConditionObject(CONDITION_HASTE, -1, -1, CONDITION_SUBID.HASTE.ABILITIES)
    setConditionParam(DIVE_SPEED_CONDITIONS[name].default, CONDITION_PARAM_SPEED, (speed * 1.2))

    DIVE_SPEED_CONDITIONS[name].mastery = createConditionObject(CONDITION_HASTE, -1, -1, CONDITION_SUBID.HASTE.ABILITIES)
    setConditionParam(DIVE_SPEED_CONDITIONS[name].mastery, CONDITION_PARAM_SPEED, (speed * 1.2) * 1.5)
end
table.clear(DIVE_SPEED)
DIVE_SPEED = nil

function getAbilitySpeedCondition(cid)
    if (isFlying(cid)) then
        local name = getPlayerPokemonName(cid, true)
        return doMasteryAdvantageCheck(cid, MASTERY_ADVANTAGES.FLY_SPEED) and
                (FLY_SPEED_CONDITIONS[name] and FLY_SPEED_CONDITIONS[name].mastery or nil) or
                (FLY_SPEED_CONDITIONS[name] and FLY_SPEED_CONDITIONS[name].default or nil)

    elseif (isLevitating(cid)) then
        local name = getPlayerPokemonName(cid, true)
        return doMasteryAdvantageCheck(cid, MASTERY_ADVANTAGES.LEVITATE_SPEED) and
                (LEVITATE_SPEED_CONDITIONS[name] and LEVITATE_SPEED_CONDITIONS[name].mastery or nil) or
                (LEVITATE_SPEED_CONDITIONS[name] and LEVITATE_SPEED_CONDITIONS[name].default or nil)

    elseif (isRiding(cid)) then
        local name = getPlayerPokemonName(cid, true)
        return doMasteryAdvantageCheck(cid, MASTERY_ADVANTAGES.RIDE_SPEED) and
                (RIDE_SPEED_CONDITIONS[name] and RIDE_SPEED_CONDITIONS[name].mastery or nil) or
                (RIDE_SPEED_CONDITIONS[name] and RIDE_SPEED_CONDITIONS[name].default or nil)

    elseif (isSurfing(cid)) then
        local name = getPlayerPokemonName(cid, true)
        return doMasteryAdvantageCheck(cid, MASTERY_ADVANTAGES.SURF_SPEED) and
                (SURF_SPEED_CONDITIONS[name] and SURF_SPEED_CONDITIONS[name].mastery or nil) or
                (SURF_SPEED_CONDITIONS[name] and SURF_SPEED_CONDITIONS[name].default or nil)

    elseif (isDiving(cid)) then
        local name = getPlayerPokemonName(cid, true)
        return doMasteryAdvantageCheck(cid, MASTERY_ADVANTAGES.DIVE_SPEED) and
                (DIVE_SPEED_CONDITIONS[name] and DIVE_SPEED_CONDITIONS[name].mastery or nil) or
                (DIVE_SPEED_CONDITIONS[name] and DIVE_SPEED_CONDITIONS[name].default or nil)
    end

    return nil
end

-- Abilities Speed END

local function checkRide(cid, pokemon, playerPosition, ticks)
    if (isCreature(cid) and isCreature(pokemon)) then
        local toPosition = getCreaturePosition(cid)
        if (getSamePosition(toPosition, playerPosition)) then -- If the player moves, we cannot secure that this is a mountable position
            if (getDistanceBetween(getCreaturePosition(pokemon), toPosition) < 2) then
                doBallSaveStats(pokemon, getPlayerBall(cid).uid)
                doRemoveCreature(pokemon)
                setRidingStatus(cid, true)
                setPlayerVulnerable(cid, true)
                doPlayerUpdateOutfit(cid)
                setCreatureMaxMana(cid, 0)
                doPlayerAddMana(cid, -getCreatureMana(cid), false)

            elseif (ticks > 1) then
                doAddCondition(pokemon, POKEMON_FAST_MOUNT_CONDITION) -- Speed up Pokemon reaching player
                addEvent(checkRide, 500, cid, pokemon, playerPosition, ticks - 1)
            end
        end
    end
end

function ride(cid)
    local toPosition = getCreaturePosition(cid)
    local pokemon = getPlayerPokemon(cid)
    local targetPos = getPositionAdjacent(pokemon, toPosition, true)
    local pos = getCreaturePosition(pokemon)

    if ((not targetPos and getDistanceBetween(pos, toPosition) <= 1) or
            (targetPos and isSightClear(pos, targetPos, true) and getDistanceBetween(targetPos, toPosition) <= 1 and
                    getPathToEx(pokemon, targetPos))) then
        doCreatureSay(cid, string.format(__L(cid, "%s , let's ride!"), getCreatureNickname(pokemon)), TALKTYPE_MONSTER)
        if (targetPos) then
            doCreatureWalkToPosition(pokemon, targetPos)
        end
        checkRide(cid, pokemon, toPosition, 20)
    else
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
    end
end

function deRide(cid)
	if (doPokemonCall(cid, getPlayerBall(cid))) then
        doPlayerRemoveAbilitySpeedCondition(cid)
	end
end

local function checkFly(cid, pokemon, playerPosition, ticks)
    if (isCreature(cid) and isCreature(pokemon)) then
        local toPosition = getCreaturePosition(cid)
        if (getSamePosition(toPosition, playerPosition)) then -- If the player moves, we cannot secure that this is a mountable position
            if (getDistanceBetween(getCreaturePosition(pokemon), toPosition) < 2) then
                local name = getPokemonReferenceName(pokemon)

                doBallSaveStats(pokemon, getPlayerBall(cid).uid)
                doRemoveCreature(pokemon)
                setFlyingStatus(cid, true)
                setPlayerVulnerable(cid, true)
                doPlayerUpdateOutfit(cid)
                setCreatureMaxMana(cid, 0)
                doPlayerAddMana(cid, -getCreatureMana(cid), false)

                if (name == "Porygon") then
                    doSendMagicEffect(getCreaturePosition(cid), EFFECT_BIG_PORYGON)
                end

            elseif (ticks > 1) then
                doAddCondition(pokemon, POKEMON_FAST_MOUNT_CONDITION) -- Speed up Pokemon reaching player
                addEvent(checkFly, 500, cid, pokemon, playerPosition, ticks - 1)
            end
        end
    end
end

function fly(cid)
    local toPosition = getCreaturePosition(cid)
	local pokemon = getPlayerPokemon(cid)
    local targetPos = getPositionAdjacent(pokemon, toPosition, true)
    local pos = getCreaturePosition(pokemon)

    if ((not targetPos and getDistanceBetween(pos, toPosition) <= 1) or
            (targetPos and isSightClear(pos, targetPos, true) and getDistanceBetween(targetPos, toPosition) <= 1 and
                    getPathToEx(pokemon, targetPos))) then
        doCreatureSay(cid, string.format(__L(cid, "%s, let's fly!"), getCreatureNickname(pokemon)), TALKTYPE_MONSTER)
        if (targetPos) then
            doCreatureWalkToPosition(pokemon, targetPos)
        end
        checkFly(cid, pokemon, toPosition, 20)
    else
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
    end
end

function deFly(cid)
	if (doPokemonCall(cid, getPlayerBall(cid))) then
        doPlayerRemoveAbilitySpeedCondition(cid)
    end
end

local function checkSurf(cid, pokemon, newPosition, playerPosition, ticks)
    if (isCreature(cid) and isCreature(pokemon)) then
        local toPosition = getCreaturePosition(cid)
        if (getSamePosition(toPosition, playerPosition)) then -- If the player moves, we cannot secure that this is a mountable position
            if (getDistanceBetween(getCreaturePosition(pokemon), toPosition) < 2) then
                doTeleportThing(cid, newPosition, false)
                doCreatureSay(cid, string.format(__L(cid, "%s, let's surf!"), getCreatureNickname(pokemon)), TALKTYPE_MONSTER)
                doBallSaveStats(pokemon, getPlayerBall(cid).uid)
                doRemoveCreature(pokemon)
                setSurfingStatus(cid, true)
                setPlayerVulnerable(cid, true)
                doPlayerUpdateOutfit(cid)
                setCreatureMaxMana(cid, 0)
                doPlayerAddMana(cid, -getCreatureMana(cid), false)

            elseif (ticks > 1) then
                doAddCondition(pokemon, POKEMON_FAST_MOUNT_CONDITION) -- Speed up Pokemon reaching player
                addEvent(checkSurf, 500, cid, pokemon, newPosition, playerPosition, ticks - 1)
            end
        end
    end
end

function surf(cid, newPosition, toPosition)
    if (not toPosition) then -- When called by Oxygen Mask
        toPosition = getCreaturePosition(cid)
    end

    local pokemon = getPlayerPokemon(cid)
    local targetPos = getPositionAdjacent(pokemon, toPosition, true)
    local pos = getCreaturePosition(pokemon)

    if ((not targetPos and getDistanceBetween(pos, toPosition) <= 1) or
            (targetPos and isSightClear(pos, targetPos, true) and getDistanceBetween(targetPos, toPosition) <= 1 and
                    getPathToEx(pokemon, targetPos))) then
        doCreatureSay(cid, string.format(__L(cid, "%s, let's surf!"), getCreatureNickname(pokemon)), TALKTYPE_MONSTER)
        if (targetPos) then
            doCreatureWalkToPosition(pokemon, targetPos)
        end
        checkSurf(cid, pokemon, newPosition, getPlayerPosition(cid), 20)
    else
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
    end
end

function deSurf(cid, newPosition)
	local oldPos = getCreaturePosition(cid)
    doTeleportThing(cid, newPosition, false)
    if (doPokemonCall(cid, getPlayerBall(cid))) then
        doPlayerRemoveAbilitySpeedCondition(cid)
    else
        doTeleportThing(cid, oldPos, false)
    end
end

local function checkDive(cid, pokemon, playerPosition, ticks)
    if (isCreature(cid) and isCreature(pokemon)) then
        local toPosition = getCreaturePosition(cid)
        if (getSamePosition(toPosition, playerPosition)) then -- If the player moves, we cannot secure that this is a mountable position
            if (getDistanceBetween(getCreaturePosition(pokemon), toPosition) < 2) then
                doBallSaveStats(pokemon, getPlayerBall(cid).uid)
                doRemoveCreature(pokemon)
                setDivingStatus(cid, true)
                setSurfingStatus(cid, false)
                setPlayerVulnerable(cid, true)
                doPlayerUpdateOutfit(cid)
                setCreatureMaxMana(cid, 0)
                doPlayerAddMana(cid, -getCreatureMana(cid), false)

            elseif (ticks > 1) then
                doAddCondition(pokemon, POKEMON_FAST_MOUNT_CONDITION) -- Speed up Pokemon reaching player
                addEvent(checkDive, 500, cid, pokemon, playerPosition, ticks - 1)
            end
        end
    end
end

function dive(cid)
	if (isPokemonOnline(cid)) then
        local toPosition = getCreaturePosition(cid)
        local pokemon = getPlayerPokemon(cid)
        local targetPos = getPositionAdjacent(pokemon, toPosition, true)
        local pos = getCreaturePosition(pokemon)

        if ((not targetPos and getDistanceBetween(pos, toPosition) <= 1) or
                (targetPos and isSightClear(pos, targetPos, true) and getDistanceBetween(targetPos, toPosition) <= 1 and
                        getPathToEx(pokemon, targetPos))) then
            doCreatureSay(cid, string.format(__L(cid, "%s, let's dive!"), getCreatureNickname(pokemon)), TALKTYPE_MONSTER)
            if (targetPos) then
                doCreatureWalkToPosition(pokemon, targetPos)
            end
            checkDive(cid, pokemon, toPosition, 20)
        else
            doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        end

    else
        setDivingStatus(cid, true)
        setSurfingStatus(cid, false)
        setPlayerVulnerable(cid, true)
        doPlayerUpdateOutfit(cid)
        setCreatureMaxMana(cid, 0)
        doPlayerAddMana(cid, -getCreatureMana(cid), false)
	end
end

function deDive(cid)
    doPlayerRemoveAbilitySpeedCondition(cid)
	doPokemonCall(cid, getPlayerBall(cid))
end

function light(cid)
	local pokemon = getPlayerPokemon(cid)

	doCreatureSay(cid, string.format(__L(cid, "%s, turn on the lights!"), getCreatureNickname(pokemon)), TALKTYPE_MONSTER)
	doAddCondition(pokemon, lightCondition)
	doSendMagicEffect(getCreaturePosition(pokemon), EFFECT_GREEN_BUFF)
end

function deLight(cid)
	local pokemon = getPlayerPokemon(cid)

	doCreatureSay(cid, string.format(__L(cid, "%s, turn off the lights!"), getCreatureNickname(pokemon)), TALKTYPE_MONSTER)
	doRemoveCondition(pokemon, CONDITION_LIGHT)
	doSendMagicEffect(getCreaturePosition(pokemon), EFFECT_GREEN_BUFF)
end

local function checkDig(cid, itemEx, toPosition, ticks)
	if (isCreature(cid)) then
		if (getDistanceBetween(getCreaturePosition(cid), toPosition) < 2) then
			local cidPos = getCreaturePosition(cid)

            doCreatureSetLookDirection(cid, getDirectionTo(cidPos, toPosition))
            itemEx.uid = getTileItemById(toPosition, itemEx.itemid).uid
            doTransformItem(itemEx.uid, holes[itemEx.itemid])
            doDecayItem(itemEx.uid)
			doSendDistanceShoot(cidPos, toPosition, PROJECTILE_GRAVEL)
            doSendMagicEffect(toPosition, EFFECT_SCRATCH)
            doCreatureWalkToPosition(cid, getCreaturePosition(cid)) -- Stop Walk

		elseif (ticks > 1) then
			addEvent(checkDig, 500, cid, itemEx, toPosition, ticks - 1)
		end
	end
end

function dig(cid, itemEx, toPosition)
	local pokemon = getPlayerPokemon(cid)
    local pos = getCreaturePosition(pokemon)
    local targetPos = (getDistanceBetween(pos, toPosition) <= 1 and toPosition or
            getPositionAdjacent(pokemon, toPosition, true))

    if (targetPos and isSightClear(pos, targetPos, true) and getDistanceBetween(targetPos, toPosition) <= 1 and
            getPathToEx(pokemon, targetPos)) then
        doCreatureSay(cid, string.format(__L(cid, "%s, dig it!"), getCreatureNickname(pokemon)), TALKTYPE_MONSTER)
        doCreatureWalkToPosition(pokemon, targetPos)
	    checkDig(pokemon, itemEx, toPosition, 20)
    else
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
    end
end

local function checkCut(cid, itemEx, toPosition, ticks)
	if (isCreature(cid)) then
		if (getDistanceBetween(getCreaturePosition(cid), toPosition) < 2) then
			doCreatureSetLookDirection(cid, getDirectionTo(getCreaturePosition(cid), toPosition))
            itemEx.uid = getTileItemById(toPosition, itemEx.itemid).uid
			doTransformItem(itemEx.uid, grasses[itemEx.itemid])
			doDecayItem(itemEx.uid)
			doSendMagicEffect(toPosition, EFFECT_SCRATCH)
            PokemonAbility.afterCut(getCreatureMaster(cid), cid, toPosition)

		elseif (ticks > 1) then
			addEvent(checkCut, 500, cid, itemEx, toPosition, ticks - 1)
		end
	end
end

function cut(cid, itemEx, toPosition)
    local pokemon = getPlayerPokemon(cid)
    local pos = getCreaturePosition(pokemon)
    local targetPos = (getDistanceBetween(pos, toPosition) <= 1 and toPosition or
            getPositionAdjacent(pokemon, toPosition, true))

    if (targetPos and isSightClear(pos, targetPos, true) and getDistanceBetween(targetPos, toPosition) <= 1 and
            getPathToEx(pokemon, targetPos)) then
        doCreatureSay(cid, string.format(__L(cid, "%s, cut it!"), getCreatureNickname(pokemon)), TALKTYPE_MONSTER)
        doCreatureWalkToPosition(pokemon, targetPos)
	    checkCut(pokemon, itemEx, toPosition, 20)
    else
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
    end
end

local function checkRockSmash(cid, itemEx, toPosition, ticks)
	if (isCreature(cid)) then
		if (getDistanceBetween(getCreaturePosition(cid), toPosition) < 2) then
			local a = getTileItemById(toPosition, itemEx.itemid).uid
            local createDebris = true

			while (a ~= nil and a > 0) do
                if (itemEx.itemid == 18742) then -- Ice Pillar
                    doCreateItem(18741, 1, toPosition) -- Ice Block
                    createDebris = false

                    addEvent(function(pos) doCreateItem(18742, 1, pos) end, 60000, toPosition) -- Re-create Ice Pillar

                elseif (itemEx.itemid == 23563) then -- Closed door Kanto Main 10
                    local positions = {
                        {x = 5026, y = 489, z = 7},
                        {x = 5026, y = 490, z = 7}
                    }

                    for k, v in pairs(positions) do
                        if (getSamePosition(toPosition, v)) then
                            doRemoveItem(getTileItemById({x = 5026, y = 491, z = 7}, 20230).uid)
                            doCreateItem(20133, 1, {x = 5026, y = 491, z = 7}) -- Open Door
                            createDebris = false
                            addEvent(function()
                                doRemoveItem(getTileItemById({x = 5026, y = 491, z = 7}, 20133).uid)
                                doCreateItem(20230, 1, {x = 5026, y = 491, z = 7}) -- Open Door
                            end, 60 * 1000)
                        end
                    end
                    
                    break
                end

				doRemoveItem(a)
				a = getTileItemById(toPosition, itemEx.itemid).uid
			end

            local cidPos = getCreaturePosition(cid)

			doCreatureSetLookDirection(cid, getDirectionTo(cidPos, toPosition))
            doSendDistanceShoot(cidPos, toPosition, PROJECTILE_GRAVEL)
			doSendMagicEffect(toPosition, EFFECT_EARTH_EXPLOSION)

            if (createDebris) then
                doDecayItem(doCreateItem(debris, 1, toPosition))
            end

            PokemonAbility.afterRockSmash(getCreatureMaster(cid), cid, toPosition)

		elseif (ticks > 1) then
			addEvent(checkRockSmash, 500, cid, itemEx, toPosition, ticks - 1)
		end
	end
end

function rockSmash(cid, itemEx, toPosition)
	local pokemon = getPlayerPokemon(cid)
    local pos = getCreaturePosition(pokemon)
    local targetPos = (getDistanceBetween(pos, toPosition) <= 1 and toPosition or
            getPositionAdjacent(pokemon, toPosition, true))

    if (targetPos and isSightClear(pos, targetPos, true) and getDistanceBetween(targetPos, toPosition) <= 1 and
            getPathToEx(pokemon, targetPos)) then
        doCreatureSay(cid, string.format(__L(cid, "%s, smash it!"), getCreatureNickname(pokemon)), TALKTYPE_MONSTER)
        doCreatureWalkToPosition(pokemon, targetPos)
	    checkRockSmash(pokemon, itemEx, toPosition, 20)
    else
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
    end
end
--[[
local HEADBUTT_KANTO = {
	{skill = 0, pokemons = {"Caterpie", "Weedle"}},
	{skill = 15, pokemons = {"Caterpie", "Weedle", "Pidgey", "Spearow"}},
	{skill = 30, pokemons = {"Caterpie", "Weedle", "Pidgey", "Spearow", "Kakuna", "Metapod"}},
	{skill = 45, pokemons = {"Caterpie", "Weedle", "Pidgey", "Spearow", "Kakuna", "Metapod", "Ekans", "Venonat"}},
	{skill = 60, pokemons = {"Caterpie", "Weedle", "Pidgey", "Spearow", "Kakuna", "Metapod", "Ekans", "Venonat", "Mankey"}},
	{skill = 80, pokemons = {"Caterpie", "Weedle", "Pidgey", "Spearow", "Kakuna", "Metapod", "Ekans", "Venonat", "Mankey", "Exeggcute"}},
	{skill = 100, pokemons = {"Caterpie", "Weedle", "Pidgey", "Spearow", "Kakuna", "Metapod", "Ekans", "Venonat", "Mankey", "Exeggcute", "Pidgeotto"}},
	{skill = 130, pokemons = {"Caterpie", "Weedle", "Pidgey", "Spearow", "Kakuna", "Metapod", "Ekans", "Venonat", "Mankey", "Exeggcute", "Pidgeotto", "Beedrill", "Butterfree"}},
	{skill = 160, pokemons = {"Caterpie", "Weedle", "Pidgey", "Spearow", "Kakuna", "Metapod", "Ekans", "Venonat", "Mankey", "Exeggcute", "Pidgeotto", "Beedrill", "Butterfree", "Arbok", "Golbat"}},
	{skill = 200, pokemons = {"Caterpie", "Weedle", "Pidgey", "Spearow", "Kakuna", "Metapod", "Ekans", "Venonat", "Mankey", "Exeggcute", "Pidgeotto", "Beedrill", "Butterfree", "Arbok", "Golbat", "Venomoth"}},
	{skill = 230, pokemons = {"Caterpie", "Weedle", "Pidgey", "Spearow", "Kakuna", "Metapod", "Ekans", "Venonat", "Mankey", "Exeggcute", "Pidgeotto", "Beedrill", "Butterfree", "Arbok", "Golbat", "Venomoth", "Pinsir"}},
	{skill = 260, pokemons = {"Caterpie", "Weedle", "Pidgey", "Spearow", "Kakuna", "Metapod", "Ekans", "Venonat", "Mankey", "Exeggcute", "Pidgeotto", "Beedrill", "Butterfree", "Arbok", "Golbat", "Venomoth", "Pinsir", "Farfetchd"}},
	{skill = 300, pokemons = {"Caterpie", "Weedle", "Pidgey", "Spearow", "Kakuna", "Metapod", "Ekans", "Venonat", "Mankey", "Exeggcute", "Pidgeotto", "Beedrill", "Butterfree", "Arbok", "Golbat", "Venomoth", "Pinsir", "Farfetchd", "Scyther"}},
}

local HEADBUTT_ORANGE_ARCHIPELAGO = {
	{skill = 0, pokemons = {"Caterpie", "Weedle"}},
	{skill = 15, pokemons = {"Caterpie", "Weedle", "Sentret", "Hoothoot"}},
	{skill = 30, pokemons = {"Caterpie", "Weedle", "Sentret", "Hoothoot", "Ledyba", "Spinarak"}},
	{skill = 45, pokemons = {"Caterpie", "Weedle", "Sentret", "Hoothoot", "Ledyba", "Spinarak", "Furret", "Venonat"}},
	{skill = 60, pokemons = {"Caterpie", "Weedle", "Sentret", "Hoothoot", "Ledyba", "Spinarak", "Furret", "Venonat", "Aipom"}},
	{skill = 80, pokemons = {"Caterpie", "Weedle", "Sentret", "Hoothoot", "Ledyba", "Spinarak", "Furret", "Venonat", "Aipom", "Yanma"}},
	{skill = 100, pokemons = {"Caterpie", "Weedle", "Sentret", "Hoothoot", "Ledyba", "Spinarak", "Furret", "Venonat", "Aipom", "Yanma", "Pidgeotto"}},
	{skill = 130, pokemons = {"Caterpie", "Weedle", "Sentret", "Hoothoot", "Ledyba", "Spinarak", "Furret", "Venonat", "Aipom", "Yanma", "Pidgeotto", "Beedrill", "Butterfree"}},
	{skill = 160, pokemons = {"Caterpie", "Weedle", "Sentret", "Hoothoot", "Ledyba", "Spinarak", "Furret", "Venonat", "Aipom", "Yanma", "Pidgeotto", "Beedrill", "Butterfree", "Noctowl", "Ledian"}},
	{skill = 200, pokemons = {"Caterpie", "Weedle", "Sentret", "Hoothoot", "Ledyba", "Spinarak", "Furret", "Venonat", "Aipom", "Yanma", "Pidgeotto", "Beedrill", "Butterfree", "Noctowl", "Ledian", "Ariados"}},
	{skill = 230, pokemons = {"Caterpie", "Weedle", "Sentret", "Hoothoot", "Ledyba", "Spinarak", "Furret", "Venonat", "Aipom", "Yanma", "Pidgeotto", "Beedrill", "Butterfree", "Noctowl", "Ledian", "Ariados", "Pineco"}},
	{skill = 260, pokemons = {"Caterpie", "Weedle", "Sentret", "Hoothoot", "Ledyba", "Spinarak", "Furret", "Venonat", "Aipom", "Yanma", "Pidgeotto", "Beedrill", "Butterfree", "Noctowl", "Ledian", "Ariados", "Pineco", "Heracross"}},
	{skill = 300, pokemons = {"Caterpie", "Weedle", "Sentret", "Hoothoot", "Ledyba", "Spinarak", "Furret", "Venonat", "Aipom", "Yanma", "Pidgeotto", "Beedrill", "Butterfree", "Noctowl", "Ledian", "Ariados", "Pineco", "Heracross", "Forretress"}},
}

local SHINY_CHANCE = getConfigValue("shinyAppearChance")
local HEADBUTT_EXHAUST_CONDITION = createConditionObject(CONDITION_EXHAUST, 12 * 1000, false, CONDITION_SUBID.EXHAUST.ABILITYHEADBUTT)

local function getPlayerHeadbuttablePokemons(cid)
	local playerSkill = getPlayerSkill(cid, PLAYER_SKILL_HEADBUTTING)
    local pokemon_by_skill = getPlayerInsideOrangeArchipelago(cid) and HEADBUTT_ORANGE_ARCHIPELAGO
            or HEADBUTT_KANTO
	for i = #pokemon_by_skill, 1, -1 do
		if (pokemon_by_skill[i].skill <= playerSkill) then
			return pokemon_by_skill[i].pokemons
		end
	end
end

local function checkHeadbutt(cid, itemEx, toPosition, ticks)
	if (isCreature(cid)) then
		if (getDistanceBetween(getCreaturePosition(cid), toPosition) == 1) then
			local master = getCreatureMaster(cid)
			local headbuttSkill = getPlayerSkillLevel(master, PLAYER_SKILL_HEADBUTTING)
            local cidPos = getCreaturePosition(cid)

			itemEx.uid = getTileItemById(toPosition, itemEx.itemid).uid
			doTransformItem(itemEx.uid, itemEx.itemid + 1)
			doDecayItem(itemEx.uid)
            doCreatureSetLookDirection(cid, getDirectionTo(getCreaturePosition(cid), toPosition))

			doSendMagicEffect(cidPos, EFFECT_CONFUSE_STARS)
			doSendMagicEffect(toPosition, EFFECT_TREE_FALLING_LEAVES)
            doSendDistanceShoot(cidPos, toPosition, PROJECTILE_GRAVEL)

			doPlayerSendTextMessage(master, MESSAGE_STATUS_CONSOLE_BLUE, "You find something!")
			doSendMagicEffect(cidPos, EFFECT_EMOTION_EXCLAMATION)

			local headbuttablePokemons = getPlayerHeadbuttablePokemons(master)
			local randomHeadbuttablePokemon = headbuttablePokemons[math.random(1, #headbuttablePokemons)]

			local amount, i = math.ceil((headbuttSkill + 1) / 75)
			if (randomHeadbuttablePokemon == "Scyther" or randomHeadbuttablePokemon == "Pinsir" or randomHeadbuttablePokemon == "Farfetchd") then
				amount = 1
			end
			local amount = getRandom(1, amount)
			if (amount > 4) then
				amount = 4
			end

			if (HEADBUTT_KANTO[#HEADBUTT_KANTO].skill > getPlayerSkill(master, PLAYER_SKILL_HEADBUTTING)) then
				doPlayerAddSkillTry(master, PLAYER_SKILL_HEADBUTTING, math.ceil(30 / (headbuttSkill + 1)))
			end

			for i = 1, amount do
				local pokemonName = randomHeadbuttablePokemon
				if (getRandom(0, SHINY_CHANCE) == 0) then
					pokemonName = getMonsterInfo(pokemonName).shiny
				end
				local pokemon = doSummonCreature(pokemonName, getCreaturePosition(cid))

				addEvent(doRemoveCreature, 3 * 60 * 1000, pokemon, true, false) -- remove creature after 2 min, force remove and dont show error
				setMonsterUniqueTarget(pokemon, master)
			end
		elseif (ticks > 1) then
			addEvent(checkHeadbutt, 1000, cid, itemEx, toPosition, ticks - 1)
		end
	end
end

function headbutt(cid, itemEx, toPosition)
	local pokemon = getPlayerPokemon(cid)
    if (getCreatureCondition(pokemon, CONDITION_EXHAUST, 5)) then
		doPlayerSendCancel(cid, "Your Pokemon is exhaust.")
        return
    end

    local pos = getCreaturePosition(pokemon)
    local targetPos = (getDistanceBetween(pos, toPosition) <= 1 and toPosition or
            getPositionAdjacent(pokemon, toPosition, true))

    if (targetPos and isSightClear(pos, targetPos, true) and getDistanceBetween(targetPos, toPosition) <= 1 and
            getPathToEx(pokemon, targetPos)) then
        doCreatureSay(cid, getCreatureNickname(pokemon) .. ", headbutt it!", TALKTYPE_MONSTER)
        doCreatureWalkToPosition(pokemon, targetPos)
	    checkHeadbutt(pokemon, itemEx, toPosition, 20)
        doAddCondition(pokemon, HEADBUTT_EXHAUST_CONDITION)
    else
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
    end
end
]]
function blink(cid, toPosition)
	local pokemon = getPlayerPokemon(cid)
	local pokemonPosition = getCreaturePosition(pokemon)

	doCreatureSay(cid, string.format(__L(cid, "%s, blink!"), getCreatureNickname(pokemon)), TALKTYPE_MONSTER)
	doTeleportThing(pokemon, toPosition, false)
	doSendMagicEffect(pokemonPosition, EFFECT_TELEPORT_TWO)
	doSendMagicEffect(toPosition, EFFECT_TELEPORT_TWO)
	doCreatureSetStorage(cid, playersStorages.blink, os.time())
    doPlayerSendPokemonStatusAdd(cid, 17393, (doMasteryAdvantageCheck(cid, MASTERY_ADVANTAGES.BLINK_COOLDOWN) and 7 or 10))
end
-- TRANSFORM
local TRANSFORM_EXHAUST_CONDITION = createConditionObject(CONDITION_EXHAUST, 20 * 60 * 1000 + 1, false, CONDITION_SUBID.EXHAUST.ABILITYTRANSFORM)
--[[local function deTransform(cid, outfit, baseSpeed)
	if(isCreature(cid)) then
        local master = getCreatureMaster(cid)

		doCreatureChangeOutfit(cid, outfit)
        setCreatureBaseSpeed(cid, baseSpeed)
		doSendMagicEffect(getCreaturePosition(cid), EFFECT_DITTO_TRANSFORM)
		doCreatureSetStorage(cid, pokemonsStorages.transform, EMPTY_STORAGE)
		doPlayerUpdatePokemonIcons(master, getCreatureName(cid))
        setBallCurrentTransform(getPlayerBall(master).uid, nil)
	end
end]]

function doAbilitieTransform(cid, pokemon, target, targetName, afterDismount)
	if (getCreatureCondition(pokemon, CONDITION_EXHAUST, 6)) then
		doPlayerSendCancel(cid, "Your Pokemon is exhaust.")

    elseif (target and getMonsterSpecialAbility(target) == POKEMON_SPECIAL_ABILITY_IDS.SUMMI) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)

	else
		if (not targetName) then
            targetName = getCreatureName(target)
        end

        if (not afterDismount) then
            if (getPokemonBlockTransform(targetName)) then
                doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
                return
            end

            if (target and getMonsterLevel(pokemon) < getMonsterLevel(target)) then
                doPlayerSendCancel(cid, "Your Pokemon cannot transform into a higher level Pokemon.")
                return
            end

            if (getPokemonEvolveLevel(targetName) > getMonsterLevel(pokemon)) then
                doPlayerSendCancel(cid, string.format(__L(cid, "Your Pokemon need at least level %s to transform into that Pokemon."), getPokemonEvolveLevel(targetName)))
                return
            end

            local reqEnergy
            if (isShinyName(targetName)) then
                reqEnergy = math.ceil(getPokemonMaxEnergy(pokemon) * 0.4)
            else
                reqEnergy = math.ceil(getPokemonMaxEnergy(pokemon) * 0.3)
            end

            if (getPokemonEnergy(pokemon) < reqEnergy) then
                doPlayerSendCancel(cid, string.format(__L(cid, "Your Pokemon need at least %s energy to transform into this Pokemon."), reqEnergy))
                return
            end

            doPokemonAddEnergy(pokemon, -reqEnergy)
        end

        local ball = getPlayerBall(cid)

        doPlayerUpdatePokemonIcons(cid, targetName, true)
		doCreatureSetStorage(pokemon, pokemonsStorages.transform, targetName)
        doCreatureChangeOutfit(pokemon, getMonsterInfo(targetName).outfit)
        setCreatureBaseSpeed(pokemon, getMonsterInfo(targetName).baseSpeed)

        if (not afterDismount) then
            doSendMagicEffect(getCreaturePosition(pokemon), EFFECT_DITTO_TRANSFORM)
            doCreatureSay(cid, string.format(__L(cid, "%s, transform!"), getCreatureNickname(pokemon)), TALKTYPE_MONSTER)
            doAddCondition(pokemon, TRANSFORM_EXHAUST_CONDITION)
            doBallSaveTransformMemory(ball.uid, targetName)
            setBallCurrentTransform(ball.uid, targetName)
        end
	end
end

local function checkLevitate(cid, pokemon, playerPosition, ticks)
    if (isCreature(cid) and isCreature(pokemon)) then
        local toPosition = getCreaturePosition(cid)
        if (getSamePosition(toPosition, playerPosition)) then -- If the player moves, we cannot secure that this is a mountable position
            if (getDistanceBetween(getCreaturePosition(pokemon), toPosition) < 2) then
                doBallSaveStats(pokemon, getPlayerBall(cid).uid)
                doRemoveCreature(pokemon)
                setLevitatingStatus(cid, true)
                setPlayerVulnerable(cid, true)
                doPlayerUpdateOutfit(cid)
                setCreatureMaxMana(cid, 0)
                doPlayerAddMana(cid, -getCreatureMana(cid), false)

            elseif (ticks > 1) then
                doAddCondition(pokemon, POKEMON_FAST_MOUNT_CONDITION) -- Speed up Pokemon reaching player
                addEvent(checkLevitate, 500, cid, pokemon, playerPosition, ticks - 1)
            end
        end
    end
end

function levitate(cid)
    local toPosition = getCreaturePosition(cid)
    local pokemon = getPlayerPokemon(cid)
    local targetPos = getPositionAdjacent(pokemon, toPosition, true)
    local pos = getCreaturePosition(pokemon)

    if ((not targetPos and getDistanceBetween(pos, toPosition) <= 1) or
            (targetPos and isSightClear(pos, targetPos, true) and getDistanceBetween(targetPos, toPosition) <= 1 and
                    getPathToEx(pokemon, targetPos))) then
        doCreatureSay(cid, string.format(__L(cid, "%s, let's levitate!"), getCreatureNickname(pokemon)), TALKTYPE_MONSTER)
        if (targetPos) then
            doCreatureWalkToPosition(pokemon, targetPos)
        end
        checkLevitate(cid, pokemon, toPosition, 20)
    else
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
    end
end

function deLevitate(cid)
	if (doPokemonCall(cid, getPlayerBall(cid))) then
        doPlayerRemoveAbilitySpeedCondition(cid)
    end
end
