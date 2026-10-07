local SKILL_NAME = "Sweet Kiss"
local PROJECTILE = getPokemonSkillProjectile(SKILL_NAME)
local EFFECT = getPokemonSkillEffect(SKILL_NAME)

function onTargetCreature_SweetKiss(cid, target)
    local pos, targetPos = getCreaturePosition(cid), getCreaturePosition(target)
    doSendMagicEffect(pos, EFFECT)
    doSendDistanceShoot(pos, targetPos, PROJECTILE)
    doSendMagicEffect(targetPos, EFFECT)
	doCreatureAddStatus(target, CREATURE_STATUS_CONFUSION, nil, cid)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_SweetKiss")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end
