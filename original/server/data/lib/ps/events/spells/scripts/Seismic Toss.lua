local SKILL_NAME = "Seismic Toss"

function onTargetCreature_SeismicToss(cid, target)
	local targetPos = getCreaturePosition(target)
    local pos = getPositionAdjacent(cid, targetPos, false)
    if (pos) then
        doSendMagicEffect(getCreaturePosition(cid), EFFECT_TELEPORT_FRAME)
        doTeleportThing(cid, pos, false)
        doSendMagicEffect(pos, EFFECT_TELEPORT_FRAME)
    end
	doSkillDamage(cid, target, SKILL_NAME)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_SeismicToss")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end