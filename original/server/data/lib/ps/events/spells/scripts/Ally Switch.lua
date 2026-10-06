local SKILL_NAME = "Ally Switch"
local SKILL_EFFECT = getPokemonSkillEffect(SKILL_NAME)

function onTargetCreature_AllySwitch(cid, target)
    if (isMonster(target)) then
        local cidPos = getCreaturePosition(cid)
        local targetPos = getCreaturePosition(target)
        doTeleportThing(cid, targetPos)
        doSendMagicEffect(targetPos, SKILL_EFFECT)
        doTeleportThing(target, cidPos)
        doSendMagicEffect(cidPos, SKILL_EFFECT)
    end
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_AllySwitch")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end
