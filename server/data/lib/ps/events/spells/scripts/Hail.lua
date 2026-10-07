local SKILL_NAME = "Hail"
local SKILL_AREAS = {
    createCombatArea(AREA_CIRCLE3X3),
    createCombatArea(AREA_CIRCLE3X3),
    createCombatArea(AREA_CIRCLE3X3),
    createCombatArea(AREA_CIRCLE3X3),
    createCombatArea(AREA_CIRCLE3X3)
}
local SKILL_PROJECTILE = PROJECTILE_ICE

local combats = {}
for i, skillArea in ipairs(SKILL_AREAS) do
    combats[i] = createCombatObject()
    onTargetCreature_Hail = function(cid, target)
        if (not isMonster(target) or not table.find(getPokemonTypes(target), ELEMENT_ICE)) then
            doSkillDamage(cid, target, SKILL_NAME)
        end
    end
    onTargetTile_Hail = function(cid, position)
        if (math.random(0, 1) == 1) then
            doSendDistanceShoot(getSkyPosition(position), position, SKILL_PROJECTILE)
            addEvent(doSendMagicEffect, 150, position, EFFECT_ICEBERG_TWO)
        end
    end
    setCombatCallback(combats[i], CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Hail")
    setCombatCallback(combats[i], CALLBACK_PARAM_TARGETTILE, "onTargetTile_Hail")
    setCombatParam(combats[i], COMBAT_PARAM_EFFECT, getPokemonSkillEffect(SKILL_NAME))
    setCombatArea(combats[i], skillArea)
end

local function doSpell(cid, combat, var)
    if (isCreature(cid)) then
        doCombat(cid, combat, var)
    end
end

local function doSpells(cid, var)
    for i, combat in ipairs(combats) do
        addEvent(doSpell, 500 * (i - 1) + 1, cid, combat, var)
    end
end

function onCastSpell(cid, var)
    local pos, i = getCreaturePosition(cid)
    for i = 1, 5 do
        if (i < 5) then
            addEvent(doSendDistanceShoot, 150 * (i - 1) + 1, pos, getSkyPosition(pos), SKILL_PROJECTILE)
        else
            addEvent(doSpells, 150 * (i - 1) + 1, cid, var)
        end
    end

    if (doPokemonSpecialAbilityCheck(cid, POKEMON_SPECIAL_ABILITY_IDS.FORECAST, nil)) then
        local tmp = getCreatureOutfit(cid)
        tmp.lookType = 1612

        doCreatureChangeOutfit(cid, tmp)
        setPokemonCustomType(cid, ELEMENT_ICE)
        doSendMagicEffect(getCreaturePosition(cid), EFFECT_ICEBERG_TWO)
    end

    return true
end
