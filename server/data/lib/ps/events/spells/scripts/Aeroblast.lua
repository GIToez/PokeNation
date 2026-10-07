local SKILL_NAME = "Aeroblast"
local LOOK_DIRS = {
    [NORTH] = { x = 0, y = -1, effect = EFFECT_BLUE_DUST_UP },
    [EAST] = { x = 1, y = 0, effect = EFFECT_BLUE_DUST_RIGHT },
    [SOUTH] = { x = 0, y = 1, effect = EFFECT_BLUE_DUST_DOWN },
    [WEST] = { x = -1, y = 0, effect = EFFECT_BLUE_DUST_LEFT }
}

function onTargetCreature_Aeroblast(cid, target)
    doSkillDamage(cid, target, SKILL_NAME)
end

local combat = createCombatObject()
setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Aeroblast")
setCombatArea(combat, createCombatArea({ { 1, 3, 1 } }))

local function doSpell(cid, toDirection, lastPosition, ticks)
    if (isCreature(cid)) then
        lastPosition.x = lastPosition.x + LOOK_DIRS[toDirection].x
        lastPosition.y = lastPosition.y + LOOK_DIRS[toDirection].y
        doSendMagicEffect(lastPosition, LOOK_DIRS[toDirection].effect)
        doCombat(cid, combat, positionToVariant(lastPosition))
        if (ticks > 0) then
            addEvent(doSpell, 300, cid, toDirection, lastPosition, ticks - 1)
        end
    end
end

function onCastSpell(cid, var)
    doSpell(cid, getCreatureLookDirection(cid), getCreaturePosition(cid), 7)
    return true
end
