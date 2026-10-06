local SKILL_NAME = "Hex"

function onTargetCreature_EvilEye(cid, target)
	doSendMagicEffect(getCreaturePosition(cid), EFFECT_EVIL_EYE)
	doSendMagicEffect(getCreaturePosition(target), EFFECT_EVIL_EYE)
    local skillDamage = getPokemonSkillDamage(SKILL_NAME)
	if (getCreatureStatus(target, CREATURE_STATUS_SLEEP) or getCreatureStatus(target, CREATURE_STATUS_POISON) or getCreatureStatus(target, CREATURE_STATUS_BURN) or
		getCreatureStatus(target, CREATURE_STATUS_CONFUSION) or getCreatureStatus(target, CREATURE_STATUS_FREEZE) or getCreatureStatus(target, CREATURE_STATUS_LOWACCURACY) or
		getCreatureStatus(target, CREATURE_STATUS_PARALYSIS) or getCreatureStatus(target, CREATURE_STATUS_INSOMNIA)) then
		skillDamage = skillDamage * 2
	end
	doSkillDamage(cid, target, SKILL_NAME, skillDamage)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_EvilEye")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end
