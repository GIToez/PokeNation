local SKILL_NAME = "Double-Edge"

function onTargetCreature_DoubleEdge(cid, target)
	local pos = getPositionAdjacent(cid, getCreaturePosition(target), false)
    if (pos) then
        doSendMagicEffect(getCreaturePosition(cid), EFFECT_TELEPORT_FRAME)
        doTeleportThing(cid, pos, false)
        doSendMagicEffect(pos, EFFECT_TELEPORT_FRAME)
    end
	doSkillDamage(cid, target, SKILL_NAME)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_DoubleEdge")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end
