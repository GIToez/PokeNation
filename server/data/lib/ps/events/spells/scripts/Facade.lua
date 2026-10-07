local SKILL_NAME = "Facade"

function onTargetCreature_Facade(cid, target)
    local cidPos, pos = getCreaturePosition(cid), getPositionAdjacent(cid, getCreaturePosition(target), false)
    if (pos) then
        doSendDistanceShoot(cidPos, pos, PROJECTILE_GRAVEL)
        doSendMagicEffect(cidPos, EFFECT_BIG_YELLOW_BALL)
        doTeleportThing(cid, pos, false)
        doSendMagicEffect(pos, EFFECT_BIG_YELLOW_BALL)
    end

    local power = getPokemonSkillDamage(SKILL_NAME)
    if (getCreatureStatus(target, CREATURE_STATUS_POISON) or
            getCreatureStatus(target, CREATURE_STATUS_BURN) or
            getCreatureStatus(target, CREATURE_STATUS_PARALYSIS)) then
        power = power * 2
    end

    doSkillDamage(cid, target, SKILL_NAME, power)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Facade")
function onCastSpell(cid, var)
    return doCombat(cid, combat, var)
end