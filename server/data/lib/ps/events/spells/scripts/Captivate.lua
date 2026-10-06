local SKILL_NAME = "Captivate"
local SKILL_EFFECT = getPokemonSkillEffect(SKILL_NAME)
local SKILL_PROJECTILE = getPokemonSkillProjectile(SKILL_NAME)

function onTargetCreature_Captivate(cid, target)
    local cidPos, targetPos = getCreaturePosition(cid), getCreaturePosition(target)
	doSendMagicEffect(cidPos, SKILL_EFFECT)
    doSendDistanceShoot(cidPos, targetPos, SKILL_PROJECTILE)
	doSendMagicEffect(targetPos, SKILL_EFFECT)
    doCreatureAddStatus(target, CREATURE_STATUS_EXTRASPATK, CREATURE_STATUS_VAR_BADMEDIUM, cid)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Captivate")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end
