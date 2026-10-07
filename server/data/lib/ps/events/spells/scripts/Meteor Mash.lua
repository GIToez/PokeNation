local SKILL_NAME = "Meteor Mash"
local SKILL_EFFECT = getPokemonSkillAreaEffect(SKILL_NAME)

function onTargetCreature_MeteorMash(cid, target)
    doSkillDamage(cid, target, SKILL_NAME)
end
local combat = createCombatObject()
setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_MeteorMash")
setCombatArea(combat, createCombatArea(AREA_WAVE7))
setCombatParam(combat, COMBAT_PARAM_DISTANCEEFFECT, getPokemonSkillProjectile(SKILL_NAME))
setCombatParam(combat, COMBAT_PARAM_EFFECT, getPokemonSkillAreaEffect(SKILL_NAME))

function onCastSpell(cid, var)
    if (getRandom(0, 100) <= 20) then
        doCreatureAddStatus(cid, CREATURE_STATUS_EXTRASPATK, CREATURE_STATUS_VAR_LOW, cid)
    end
	return doCombat(cid, combat, var)
end