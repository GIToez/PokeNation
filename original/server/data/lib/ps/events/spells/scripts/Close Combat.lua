local SKILL_NAME = "Close Combat"

function onTargetCreature_CloseCombat(cid, target)
    local targetPos, i = getCreaturePosition(target)
    for i = 0, 6 do
        local tmpPos = {x = targetPos.x + getRandom(-1, 1), y = targetPos.y + getRandom(-1, 1), z = targetPos.z}
        doSendDistanceShoot(getSkyPosition(tmpPos), tmpPos, PROJECTILE_GRAVEL)
        addEvent(doSendMagicEffect, 100, tmpPos, EFFECT_PUNCH_TWO)
    end

    local pos = getPositionAdjacent(cid, targetPos, false)
    if (pos) then
        doSendMagicEffect(getCreaturePosition(cid), EFFECT_TELEPORT_FRAME)
        doTeleportThing(cid, pos, false)
        doSendMagicEffect(pos, EFFECT_TELEPORT_FRAME)
    end
	doSkillDamage(cid, target, SKILL_NAME)
    if (not isCreature(target)) then return end -- Defeated
    doCreatureAddStatus(cid, CREATURE_STATUS_EXTRASPDEF, CREATURE_STATUS_VAR_BAD, cid)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_CloseCombat")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end
