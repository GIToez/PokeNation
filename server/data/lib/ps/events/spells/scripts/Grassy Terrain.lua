local SKILL_NAME = "Grassy Terrain"
local SKILL_AREAS = {
    createCombatArea(AREA_CIRCLE3X3),
    createCombatArea(AREA_CIRCLE3X3),
    createCombatArea(AREA_CIRCLE3X3),
    createCombatArea(AREA_CIRCLE3X3),
    createCombatArea(AREA_CIRCLE3X3),
}
local AREA_EFFECT = getPokemonSkillEffect(SKILL_NAME)

local combats = {}
for i, skillArea in ipairs(SKILL_AREAS) do
    combats[i] = createCombatObject()
    onTargetCreature_GrassyTerrain = function(cid, target)
        if (isFriend(cid, target)) then
            doCreatureAddHealth(target, math.floor((getCreatureMaxHealth(target) / 30) / #SKILL_AREAS))
        end
    end
    onTargetTile_GrassyTerrain = function(cid, position)
        addEvent(doSendMagicEffect, getRandom(1, 300), position, AREA_EFFECT)
    end
    setCombatCallback(combats[i], CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_GrassyTerrain")
    setCombatCallback(combats[i], CALLBACK_PARAM_TARGETTILE, "onTargetTile_GrassyTerrain")
    setCombatParam(combats[i], COMBAT_PARAM_AGGRESSIVE, false)
    setCombatArea(combats[i], skillArea)
end

local function doSpell(cid, combat)
    if (isCreature(cid)) then
        doCombat(cid, combat, positionToVariant(getCreaturePosition(cid)))
    end
end

function onCastSpell(cid, var)
    doSendMagicEffect(getCreaturePosition(cid), EFFECT_ELECTRIC_CLOUD)
    for i, combat in ipairs(combats) do
        addEvent(doSpell, 500 * (i - 1) + 1, cid, combat)
    end
    return true
end
