local SKILL_NAME = "Hypnosis"
local SKILL_PROJECTILE = getPokemonSkillProjectile(SKILL_NAME)
local SKILL_EFFECT = getPokemonSkillEffect(SKILL_NAME)

function onTargetCreature_Hypnosis(cid, target)
	doSendDistanceShoot(getCreaturePosition(cid), getCreaturePosition(target), SKILL_PROJECTILE)
    doSendMagicEffect(getCreaturePosition(target), SKILL_EFFECT)
	doCreatureAddStatus(target, CREATURE_STATUS_SLEEP, nil, cid)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Hypnosis")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end
