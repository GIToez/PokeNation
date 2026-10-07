local SKILL_NAME = "Fairy Wind"
local LOOK_DIRS = {
    [NORTH] = { x = 0, y = -1 },
    [EAST] = { x = 1, y = 0 },
    [SOUTH] = { x = 0, y = 1 },
    [WEST] = { x = -1, y = 0 }
}

function onTargetCreature_FairyWind(cid, target) doSkillDamage(cid, target, SKILL_NAME) end

local combat = createCombatObject()
setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_FairyWind")
setCombatArea(combat, createCombatArea({ { 1, 3, 1 } }))
setCombatParam(combat, COMBAT_PARAM_EFFECT, EFFECT_GREEN_WIND)

local function doSpell(cid, toDirection, lastPosition, ticks)
    if (isCreature(cid)) then
        lastPosition.x = lastPosition.x + LOOK_DIRS[toDirection].x
        lastPosition.y = lastPosition.y + LOOK_DIRS[toDirection].y
        doCombat(cid, combat, positionToVariant(lastPosition))
        if (ticks > 0) then
            addEvent(doSpell, 150, cid, toDirection, lastPosition, ticks - 1)
        end
--        doSendMagicEffect({ x = lastPosition.x, y = lastPosition.y, z = lastPosition.z }, EFFECT_GREEN_WIND) -- Lua bug if use directly lastPosition
    end
end

function onCastSpell(cid, var)
    doSpell(cid, getCreatureLookDirection(cid), getCreaturePosition(cid), 10)
    return true
end