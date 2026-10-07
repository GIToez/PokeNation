local SKILL_NAME = "Grass Knot"
local SKILL_AREAS = {
    createCombatArea(AREA_SQUARE1X1),
    createCombatArea(AREA_SQUARE1X1),
    createCombatArea(AREA_SQUARE1X1),
    createCombatArea(AREA_SQUARE1X1),
    createCombatArea(AREA_SQUARE1X1),
}

local combats = {}
for i, skillArea in ipairs(SKILL_AREAS) do
    combats[i] = createCombatObject()
    onTargetCreature_GrassKnot = function(cid, target)
        doSkillDamage(cid, target, SKILL_NAME, getPokemonSkillDamage(SKILL_NAME) / #SKILL_AREAS)
        doCreatureAddStatus(target, CREATURE_STATUS_PARALYSIS, nil, cid)
    end
    onTargetTile_GrassKnot = function(cid, position)
        addEvent(doSendMagicEffect, getRandom(1, 1000), position, getPokemonSkillEffect(SKILL_NAME))
    end
    setCombatCallback(combats[i], CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_GrassKnot")
    setCombatCallback(combats[i], CALLBACK_PARAM_TARGETTILE, "onTargetTile_GrassKnot")
    setCombatArea(combats[i], skillArea)
end

local function doSpell(cid, combat, var)
    if (isCreature(cid)) then
        doCombat(cid, combat, var)
    end
end

function onTargetCreature_GrassKnot(cid, target)
    --doSkillDamage(cid, target, SKILL_NAME)
    local var, i, combat = positionToVariant(getCreaturePosition(target))
    for i, combat in ipairs(combats) do
        addEvent(doSpell, 500 * (i - 1) + 1, cid, combat, var)
    end
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_GrassKnot")
function onCastSpell(cid, var)
    return doCombat(cid, combat, var)
end
