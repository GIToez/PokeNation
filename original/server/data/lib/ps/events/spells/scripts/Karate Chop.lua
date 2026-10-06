local SKILL_NAME = "Karate Chop"
local SKILL_EFFECT = getPokemonSkillAreaEffect(SKILL_NAME)

function onTargetCreature_KarateChop(cid, target) doSkillDamage(cid, target, SKILL_NAME) end
local combat = createCombatObject()
setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_KarateChop")
setCombatArea(combat, createCombatArea(AREA_WAVE3X3))
setCombatParam(combat, COMBAT_PARAM_DISTANCEEFFECT, getPokemonSkillProjectile(SKILL_NAME))

function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end