local SKILL_NAME = "Hi Jump Kick"

function onTargetCreature_HiJumpKick(cid, target)
	local cidPos, pos = getCreaturePosition(cid), getPositionAdjacent(cid, getCreaturePosition(target), false)
    if (pos) then
        doSendDistanceShoot(cidPos, pos, PROJECTILE_GRAVEL)
        doSendMagicEffect(cidPos, EFFECT_TELEPORT_FRAME)
        doTeleportThing(cid, pos, false)
        doSendMagicEffect(pos, EFFECT_TELEPORT_FRAME)
        doSendMagicEffect(pos, EFFECT_EARTH_EXPLOSION)
    end
	doSkillDamage(cid, target, SKILL_NAME)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_HiJumpKick")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end