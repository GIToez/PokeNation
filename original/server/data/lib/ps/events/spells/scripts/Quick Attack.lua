local SKILL_NAME = "Quick Attack"

function onTargetCreature_QuickAttack(cid, target)
	local cidPos, pos = getCreaturePosition(cid), getPositionAdjacent(cid, getCreaturePosition(target), false)
    if (pos) then
        doSendDistanceShoot(cidPos, pos, PROJECTILE_GRAVEL)
        doSendMagicEffect(cidPos, EFFECT_TELEPORT_FRAME)
        doTeleportThing(cid, pos, false)
        doSendMagicEffect(pos, EFFECT_TELEPORT_FRAME)
    end
	doSkillDamage(cid, target, SKILL_NAME)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_QuickAttack")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end
