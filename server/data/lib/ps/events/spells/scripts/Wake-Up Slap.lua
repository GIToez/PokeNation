local SKILL_NAME = "Wake-Up Slap"

function onTargetCreature_WakeUpSlap(cid, target)
    if (getCreatureStatus(target, CREATURE_STATUS_SLEEP)) then
        doSkillDamage(cid, target, SKILL_NAME, getPokemonSkillDamage(SKILL_NAME) * 2)
        doCreatureRemoveStatus(target, CREATURE_STATUS_SLEEP)
    else
        doSkillDamage(cid, target, SKILL_NAME)
    end
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_WakeUpSlap")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end