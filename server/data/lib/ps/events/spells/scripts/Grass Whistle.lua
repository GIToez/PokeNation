local SKILL_NAME = "Grass Whistle"
local EFFECTS = {EFFECT_PURPLE_SOUND, EFFECT_GREEN_SOUND, EFFECT_BLUE_SOUND, EFFECT_YELLOW_SOUND }
local PROJECTILE = getPokemonSkillProjectile(SKILL_NAME)

local function doEffect(pos)
    doSendMagicEffect(pos, EFFECT_LEAVES_TWO)
    addEvent(doSendMagicEffect, 300, pos, table.random(EFFECTS))
end

function onTargetCreature_GrassWhistle(cid, target)
    local pos, targetPos = getCreaturePosition(cid), getCreaturePosition(target)
    doEffect(pos)
    doSendDistanceShoot(pos, targetPos, PROJECTILE)
    doEffect(targetPos)
	if (not doPokemonSpecialAbilityCheck(target, POKEMON_SPECIAL_ABILITY_IDS.SOUNDPROOF, nil)) then
        doCreatureAddStatus(target, CREATURE_STATUS_SLEEP, nil, cid)
    end
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_GrassWhistle")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end
