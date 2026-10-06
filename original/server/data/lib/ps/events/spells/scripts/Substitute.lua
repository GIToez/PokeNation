-- local SKILL_NAME = "Substitute"
local INTERVAL = 15000

local function removeSubstitute(cid)
    if (isCreature(cid) and getCreatureStatus(cid, CREATURE_STATUS_SUBSTITUTE)) then
        doCreatureChangeHealth(cid, getPokemonHealthBeforeSubstitute(cid) - getCreatureHealth(cid))
        doCreatureRemoveStatus(cid, CREATURE_STATUS_SUBSTITUTE)
    end
end

function onCastSpell(cid, var)
	setPokemonHealthBeforeSubstitute(cid, getCreatureHealth(cid))
    doCreatureAddStatus(cid, CREATURE_STATUS_SUBSTITUTE, nil, cid)
    addEvent(removeSubstitute, INTERVAL, cid)
    return true
end
