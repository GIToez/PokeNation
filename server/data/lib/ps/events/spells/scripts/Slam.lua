local SKILL_NAME = "Slam"

function onTargetCreature_Slam(cid, target)
    local cidPos, pos = getCreaturePosition(cid), getCreaturePosition(target)
    doSendMagicEffect(cidPos, EFFECT_TELEPORT_FRAME)
	doTeleportThing(target, cidPos, false)
    doSendMagicEffect(pos, EFFECT_TELEPORT_FRAME)
	doTeleportThing(cid, pos, false)
    doSendMagicEffect(cidPos, EFFECT_GROUND_SMASH)
    doSkillDamage(cid, target, SKILL_NAME)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Slam")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end
