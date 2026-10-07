function getCurrentTimeInSeconds()
	local currentTime = os.date("*t")
	return ((currentTime.yday * 24) * 60 * 60) + (currentTime.hour * 60 * 60) + (currentTime.min * 60) + currentTime.sec
end

-- get
function getBallSkillCooldown(ballUid, skillName)
	local r = (getItemAttribute(ballUid, getPokemonSkillCooldownStorage(skillName)) or 0) - getCurrentTimeInSeconds()
	return r < 2592000 and r or 0 -- Bug check (2592000 = 1 month in seconds)
end

-- set
function setBallSkillCooldown(cid, ballUid, skillName, cooldownTime)
	cooldownTime = cooldownTime ~= nil and cooldownTime or getPokemonSkillCooldownTime(skillName)
	doItemSetAttribute(ballUid, getPokemonSkillCooldownStorage(skillName), cooldownTime + getCurrentTimeInSeconds())
	doPlayerSendPokemonSkillCooldown(cid, getPokemonSkillClientIconId(skillName), cooldownTime)
end

-- do
function doBallResetAllCooldowns(cid, ballUid, pokemonName)
    if (not pokemonName) then
        pokemonName = getBallPokemonName(ballUid)
    end

    local moves = getPokemonSkills(pokemonName, ballUid)

    if (getPokemonAbilityAvailable(nil, POKEMON_ABILITIES.TRANSFORM, pokemonName)) then
        for key = 1, POKEMON_TRANSFORM_MEMORY_MAX do
            local memory = getBallTransformMemory(ballUid, key)
            if (memory) then
                moves = table_concat(moves, getPokemonDefaultSkills(memory))
            end
        end
    end

    for _, move in pairs(moves) do
        setBallSkillCooldown(cid, ballUid, move, 0)
        doPlayerSendPokemonSkillCooldown(cid, getPokemonSkillClientIconId(move), 0)
    end
end
