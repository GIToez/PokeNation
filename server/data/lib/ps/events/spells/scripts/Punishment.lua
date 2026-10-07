local SKILL_NAME = "Punishment"
local BASE_POWER = getPokemonSkillDamage(SKILL_NAME)

function onTargetCreature_Punishment(cid, target)
	local power = BASE_POWER
    if (getCreatureStatus(target, CREATURE_STATUS_EXTRASPDEF)) then
        power = power + 20
    end
    if (getCreatureStatus(target, CREATURE_STATUS_EXTRASPATK)) then
        power = power + 20
    end
    if (getCreatureStatus(target, CREATURE_STATUS_EXTRASPEED)) then
        power = power + 20
    end

    doSkillDamage(cid, target, SKILL_NAME, power)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Punishment")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end
