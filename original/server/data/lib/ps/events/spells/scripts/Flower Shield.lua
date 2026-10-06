local SKILL_NAME = "Flower Shield"
local SKILL_AREAS = {
    createCombatArea(AREA_CIRCLE3X3)
}
local SKILL_EFFECT = getPokemonSkillEffect(SKILL_NAME)

local combats = {}
for i, skillArea in ipairs(SKILL_AREAS) do
    combats[i] = createCombatObject()
    onTargetCreature_FlowerShield = function(cid, target)
        if (isFriend(cid, target) and isMonster(cid) and isInArray(getPokemonTypes(cid), ELEMENT_FIRE)) then
            doSendMagicEffect(getCreaturePosition(target), SKILL_EFFECT)
            doCreatureAddStatus(cid, CREATURE_STATUS_EXTRASPDEF, CREATURE_STATUS_VAR_HIGH, cid)
        end
    end
    onTargetTile_FlowerShield = function(cid, position)
        addEvent(doSendMagicEffect, getRandom(1, 1000), position, SKILL_EFFECT)
    end
    setCombatCallback(combats[i], CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_FlowerShield")
    setCombatCallback(combats[i], CALLBACK_PARAM_TARGETTILE, "onTargetTile_FlowerShield")
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
