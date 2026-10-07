local SKILL_NAME = "Tickle"
local PROJECTILE = getPokemonSkillProjectile(SKILL_NAME)
local EFFECT = getPokemonSkillEffect(SKILL_NAME)

function onTargetCreature_Tickle(cid, target)
    local pos, targetPos = getCreaturePosition(cid), getCreaturePosition(target)
    doSendMagicEffect(pos, EFFECT)
    doSendDistanceShoot(pos, targetPos, PROJECTILE)
    doSendMagicEffect(targetPos, EFFECT)
	doCreatureAddStatus(target, CREATURE_STATUS_EXTRASPATK, CREATURE_STATUS_VAR_BAD, cid)
	doCreatureAddStatus(target, CREATURE_STATUS_EXTRASPDEF, CREATURE_STATUS_VAR_BAD, cid)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Tickle")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end
