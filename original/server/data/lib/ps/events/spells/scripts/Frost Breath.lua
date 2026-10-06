local SKILL_NAME = "Frost Breath"
local LOOK_DIRS = {
    [NORTH] = { x = 1, y = -1, effect = EFFECT_BIG_ICE_BEAM_UP },
    [EAST] = { x = 5, y = 1, effect = EFFECT_BIG_ICE_BEAM_RIGHT },
    [SOUTH] = { x = 1, y = 5, effect = EFFECT_BIG_ICE_BEAM_DOWN },
    [WEST] = { x = -1, y = 1, effect = EFFECT_BIG_ICE_BEAM_LEFT }
}

function onTargetCreature_FrostBreath(cid, target)
    doSkillDamage(cid, target, SKILL_NAME)
end

local combat = createCombatObject()
setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_FrostBreath")
setCombatArea(combat, createCombatArea(AREA_BEAM5_TRIPLE))

local function doSpell(cid, toDirection, lastPosition, var)
    if (isCreature(cid)) then
        lastPosition.x = lastPosition.x + LOOK_DIRS[toDirection].x
        lastPosition.y = lastPosition.y + LOOK_DIRS[toDirection].y
        doSendMagicEffect(lastPosition, LOOK_DIRS[toDirection].effect)
        doCombat(cid, combat, var)
    end
end

function onCastSpell(cid, var)
    doSpell(cid, getCreatureLookDirection(cid), getCreaturePosition(cid), var)
    return true
end
