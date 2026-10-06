local SKILL_NAME = "Clamp"

function onTargetCreature_Clamp(cid, target)
    doSkillDamage(cid, target, SKILL_NAME)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Clamp")

local function doSpell(cid, target, ticks)
    if (not isCreature(target)) then
        if (isCreature(cid)) then
            doCreatureSetNoMove(cid, false)
        end

    elseif (not isCreature(cid)) then
        if (isCreature(target)) then
            doCreatureSetNoMove(target, false)
        end

    else
        doCombat(cid, combat, numberToVariant(target))
        if (ticks > 0) then
            addEvent(doSpell, BATTLE_ROUND_INTERVAL, cid, target, ticks - 1)
        else
            doCreatureSetNoMove(cid, false)
            doCreatureSetNoMove(target, false)
        end
    end
end

function onCastSpell(cid, var)
    local target = getCreatureTarget(cid)

    doCreatureSetNoMove(cid, true)
    doCreatureSetNoMove(target, true)
    doSpell(cid, target, getRandom(4, 5))

    return true
end
