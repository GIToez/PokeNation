local SKILL_NAME = "Thunder"
local SKILL_PROJECTILE = getPokemonSkillProjectile(SKILL_NAME)

function onTargetCreature_Thunder(cid, target)
    local position = getCreaturePosition(target)
    doSendDistanceShoot(getSkyPosition(position), position, SKILL_PROJECTILE)
    addEvent(doSendMagicEffect, 150, position, EFFECT_ELECTRIC_SPARK)
    doSkillDamage(cid, target, SKILL_NAME)
    if (not isCreature(target)) then return end -- Defeated
    if (not doPokemonSpecialAbilityCheck(target, POKEMON_SPECIAL_ABILITY_IDS.SHIELD_DUST, nil) and getRandom(0, 100) <=
            (doPokemonSpecialAbilityCheck(cid, POKEMON_SPECIAL_ABILITY_IDS.SERENA_GRACE, nil) and 60 or 30)) then
        doCreatureAddStatus(target, CREATURE_STATUS_PARALYSIS, nil, cid)
    end
end
onTargetTile_Thunder = function(cid, position)
        if (math.random(0, 1) == 1) then
            doSendDistanceShoot(getSkyPosition(position), position, SKILL_PROJECTILE)
            addEvent(doSendMagicEffect, 150, position, EFFECT_ELECTRIC_SPARK)
        end
    end
local combat = createCombatObject()
setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Thunder")
setCombatCallback(combat, CALLBACK_PARAM_TARGETTILE, "onTargetTile_Thunder")
setCombatArea(combat, createCombatArea(AREA_CIRCLE3X3))

local function doSpell(cid, var)
	if (isCreature(cid)) then
		doSendMagicEffect(getCreaturePosition(cid), EFFECT_BIG_ELECTRIC_BALL)
        doCombat(cid, combat, var)
	end
end

function onCastSpell(cid, var)
	local pos = getCreaturePosition(cid)
    local skyPos, i = getSkyPosition(pos)
    for i = 1, 5 do
        addEvent(doSendDistanceShoot, 100 * (i - 1) + 1, skyPos, pos, SKILL_PROJECTILE)
    end
    addEvent(doSpell, 500, cid, var)
	return true
end