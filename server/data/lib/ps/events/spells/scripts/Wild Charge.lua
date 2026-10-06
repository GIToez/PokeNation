local SKILL_NAME = "Wild Charge"

function onTargetCreature_WildCharge(cid, target)
    local cidPos, pos = getCreaturePosition(cid), getPositionAdjacent(cid, getCreaturePosition(target), false)
    doSendMagicEffect(cidPos, EFFECT_YELLOW_ENERGIZE)
    if (pos) then
        doSendDistanceShoot(cidPos, pos, PROJECTILE_THUNDER)
        doSendMagicEffect(cidPos, EFFECT_TELEPORT_FRAME)
        doTeleportThing(cid, pos, false)
        doSendMagicEffect(pos, EFFECT_TELEPORT_FRAME)
        doSendMagicEffect(getCreaturePos(target), EFFECT_BIG_ELECTRIC_BALL)
    end
    doSkillDamage(cid, target, SKILL_NAME)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_WildCharge")
function onCastSpell(cid, var)
    return doCombat(cid, combat, var)
end
