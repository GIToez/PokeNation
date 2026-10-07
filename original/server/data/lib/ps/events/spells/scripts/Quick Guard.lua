local SKILL_NAME = "Quick Guard"
local SKILL_AREAS = {
    createCombatArea(AREA_CROSS5X5)
}

local combats = {}
for i, skillArea in ipairs(SKILL_AREAS) do
    combats[i] = createCombatObject()
    onTargetTile_QuickGuard = function(cid, position)
        addEvent(doSendMagicEffect, getRandom(1, 300), position, getPokemonSkillEffect(SKILL_NAME))
        local target = getTopCreature(position).uid
        if (isCreature(target) and isFriend(cid, target)) then
            doCreatureAddStatus(target, CREATURE_STATUS_PROTECTION, nil, cid)
        end
    end
    setCombatCallback(combats[i], CALLBACK_PARAM_TARGETTILE, "onTargetTile_QuickGuard")
    setCombatArea(combats[i], skillArea)
    setCombatParam(combats[i], COMBAT_PARAM_AGGRESSIVE, false)
end

local function doSpell(cid, combat, var)
    if (isCreature(cid)) then
        doCombat(cid, combat, var)
    end
end

function onCastSpell(cid, var)
    for i, combat in ipairs(combats) do
        addEvent(doSpell, 500 * (i - 1) + 1, cid, combat, var)
    end
    return true
end
