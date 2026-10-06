local SKILL_NAME = "Charm"
local PROJECTILE = getPokemonSkillProjectile(SKILL_NAME)
local EFFECT = getPokemonSkillEffect(SKILL_NAME)

function onTargetCreature_Charm(cid, target)
    local pos, targetPos = getCreaturePosition(cid), getCreaturePosition(target)
    doSendMagicEffect(pos, EFFECT)
    doSendDistanceShoot(pos, targetPos, PROJECTILE)
    doSendMagicEffect(targetPos, EFFECT)
	doCreatureAddStatus(target, CREATURE_STATUS_EXTRASPATK, CREATURE_STATUS_VAR_BADMEDIUM, cid)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Charm")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end
