local SKILL_NAME = "Sky Drop"
local INTERVAL = 2000

function onTargetCreature_SkyDrop(cid, target)
    local cidPos, targetPos = getCreaturePosition(cid), getCreaturePosition(target)
    if (getSameFloor(cidPos, targetPos)) then
        local pos = getPositionAdjacent(cid, targetPos, false)
        if (pos) then
            doTeleportThing(cid, pos, false)
            doSkillDamage(cid, target, SKILL_NAME)
        end
    end
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_SkyDrop")
local condition = createConditionObject(CONDITION_INVISIBLE, INTERVAL)

local function doSpell(cid, target)
    if (isCreature(cid) and isCreature(target)) then
        doCreatureSetTarget(cid, target)
        doCombat(cid, combat, numberToVariant(target))
    end
end

function onCastSpell(cid, var)
    local target = getCreatureTarget(cid)
    doAddCondition(cid, condition)
    doAddCondition(target, condition)
    addEvent(doSpell, INTERVAL + 400, cid, target)
    return true
end
