local SKILL_NAME = "Vital Throw"

function onTargetCreature_VitalThrow(cid, target)
    doSendMagicEffect(getCreaturePosition(cid), EFFECT_MULTIPLE_BLOW)
	doSkillDamage(cid, target, SKILL_NAME)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_VitalThrow")
setCombatParam(combat, COMBAT_PARAM_DISTANCEEFFECT, getPokemonSkillProjectile(SKILL_NAME))
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end