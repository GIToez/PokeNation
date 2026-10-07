local SKILL_NAME = "Volt Switch"

function onTargetCreature_VoltSwitch(cid, target)
    local cidPos, pos = getCreaturePosition(cid), getPositionAdjacent(cid, getCreaturePosition(target), false)
    if (pos) then
        doSendDistanceShoot(cidPos, pos, PROJECTILE_THUNDER)
        doSendMagicEffect(cidPos, EFFECT_TELEPORT_FRAME)
        doTeleportThing(cid, pos, false)
        doSendMagicEffect(pos, EFFECT_TELEPORT_FRAME)

        doSkillDamage(cid, target, SKILL_NAME)

        doSendDistanceShoot(pos, cidPOs, PROJECTILE_THUNDER)
        doSendMagicEffect(pos, EFFECT_TELEPORT_FRAME)
        doTeleportThing(cid, cidPos, false)
        doSendMagicEffect(cidPos, EFFECT_TELEPORT_FRAME)
    end
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_VoltSwitch")
function onCastSpell(cid, var)
    return doCombat(cid, combat, var)
end
