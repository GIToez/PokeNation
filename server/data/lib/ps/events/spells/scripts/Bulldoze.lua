local SKILL_NAME = "Bulldoze"
local SKILL_AREAS = {
    createCombatArea(AREA_CIRCLE3X3)
}

local combats = {}
for i, skillArea in ipairs(SKILL_AREAS) do
    combats[i] = createCombatObject()
    onTargetCreature_Bulldoze = function(cid, target)
        doSkillDamage(cid, target, SKILL_NAME)
        doCreatureAddStatus(target, CREATURE_STATUS_EXTRASPEED, CREATURE_STATUS_VAR_BAD, cid)
    end
    onTargetTile_Bulldoze = function(cid, position)
        addEvent(doSendMagicEffect, getRandom(1, 1000), position, EFFECT_BROWN_STORM)
    end
    setCombatCallback(combats[i], CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Bulldoze")
    setCombatCallback(combats[i], CALLBACK_PARAM_TARGETTILE, "onTargetTile_Bulldoze")
    setCombatArea(combats[i], skillArea)
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