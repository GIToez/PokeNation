local SKILL_NAME = "Worry Seed"

function onTargetCreature_WorrySeed(cid, target) doCreatureAddStatus(target, CREATURE_STATUS_INSOMNIA, nil, cid) end
local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_WorrySeed")
setCombatParam(combat, COMBAT_PARAM_DISTANCEEFFECT, getPokemonSkillProjectile(SKILL_NAME))
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end