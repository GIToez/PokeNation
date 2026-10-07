local function getMoveCooldown(cid, move)
    local v = tonumber(getCreatureStorage(cid, getPokemonSkillCooldownStorage(move)))
    return (v and v ~= -1) and v - getCurrentTimeInSeconds() or 0
end

local function setMoveCooldown(cid, move)
    doCreatureSetStorage(cid, getPokemonSkillCooldownStorage(move),
        getPokemonSkillCooldownTime(move) + getCurrentTimeInSeconds())
end

local function canUseMove(cid, move)
    if (isExhaust(cid) or getPokemonSkillWildBlock(move) or getMoveCooldown(cid, move) > 0 or
            (getMonsterLevel(cid) < (getPokemonSkillWildLevel(move) and getPokemonSkillWildLevel(move) or getPokemonSkillRequiredLevel(getCreatureName(cid), move))) or
            (isPokemonSkillTypeTarget(move) and not hasTarget(cid)) or
            (getPokemonSkillMakeHeal(move) and getCreatureHealth(cid) / getCreatureMaxHealth(cid) > 0.5)) then
        return false
    end
    return true
end

local function getMove(cid)
    local moves = getPokemonDefaultSkills(getPokemonReferenceName(cid))
    -- First try a random move, if cant use it, try from the strongest to down
    local move
    for i = 0, 6 do
        move = table.random(moves)
        if (canUseMove(cid, move)) then
            break
        else
            move = nil
        end
    end

    if (not move) then
        for i = #moves, #moves, -1 do
            if (canUseMove(cid, moves[i])) then
                move = moves[i]
                break
            end
        end
    end

    return move
end

local function doUseMove(cid, move)
    if (doPokemonUseSkill(cid, move)) then
        setMoveCooldown(cid, move)
        doAddExhaust(cid)
    end
end

function onCastSpell(cid)
	if (isPokemonWild(cid)) then
		local move = getMove(cid)
        if (move) then
            doUseMove(cid, move)
        end
    end
	return true
end
