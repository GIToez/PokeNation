local INTERVAL = 700
local INVISIBLE = createConditionObject(CONDITION_INVISIBLE, INTERVAL)

function onCastSpell(cid, var)
    local direction, effect, distance
    if (getCreatureLookDir(cid) == EAST) then
        direction = EAST
        effect = EFFECT_STANTLER_JUMP_RIGHT
        distance = 4

    elseif (getCreatureLookDir(cid) == WEST) then
        direction = WEST
        effect = EFFECT_STANTLER_JUMP_LEFT
        distance = 4

    else
        return true
    end

    local pos = getCreaturePosition(cid)
    local targetPos = getPositionByDirection(pos, direction, distance)

    if (isSightClear(pos, targetPos, false) and isWalkable(cid, targetPos)) then
        doSendMagicEffect(pos, effect)
        doAddCondition(cid, INVISIBLE)
        addEvent(function(cid, targetPos)
            if (isCreature(cid)) then
                doTeleportThing(cid, targetPos, false)
            end
        end, INTERVAL, cid, targetPos)

    end

	return true
end
