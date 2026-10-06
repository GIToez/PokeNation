local SKILL_NAME = "Synchronoise"
local SKILL_AREAS = {
    createCombatArea(AREA_CIRCLE3X3)
}

local combats = {}
for i, skillArea in ipairs(SKILL_AREAS) do
    combats[i] = createCombatObject()
    onTargetCreature_Synchronoise = function(cid, target)
		if (isMonster(target) and table.findAsTable(getPokemonTypes(cid), getPokemonTypes(target))) then
            doSkillDamage(cid, target, SKILL_NAME)
        end
    end
    onTargetTile_Synchronoise = function(cid, position)
        addEvent(doSendMagicEffect, getRandom(1, 1000), position, EFFECT_PSYCHIC_TRIANGLE)
    end
    setCombatCallback(combats[i], CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Synchronoise")
    setCombatCallback(combats[i], CALLBACK_PARAM_TARGETTILE, "onTargetTile_Synchronoise")
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