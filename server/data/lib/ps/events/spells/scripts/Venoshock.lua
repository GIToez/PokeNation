local SKILL_NAME = "Venoshock"

function onTargetCreature_Venoshock(cid, target)
    local power = getPokemonSkillDamage(SKILL_NAME)
    if (getCreatureStatus(target, CREATURE_STATUS_POISON) or getCreatureStatus(target, CREATURE_STATUS_BADPOISON)) then
        power = power * 2
    end
    doSkillDamage(cid, target, SKILL_NAME, power)
end

local combat = createCombatObject()
setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Venoshock")
setCombatArea(combat, createCombatArea(AREA_WAVE4))
setCombatParam(combat, COMBAT_PARAM_EFFECT, getPokemonSkillAreaEffect(SKILL_NAME))

function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end