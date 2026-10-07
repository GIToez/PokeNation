local SKILL_NAME = "Hydro Pump"
local LOOK_DIRS = {
	[NORTH] = {x = 0, y = -1, effectS = EFFECT_WATER_GUN_UP_START, effectM = EFFECT_WATER_GUN_UP_MIDDLE, effectE = EFFECT_WATER_GUN_UP_END},
	[EAST] =  {x = 1, y = 0, effectS = EFFECT_WATER_GUN_RIGHT_START, effectM = EFFECT_WATER_GUN_RIGHT_MIDDLE, effectE = EFFECT_WATER_GUN_RIGHT_END},
	[SOUTH] = {x = 0, y = 1, effectS = EFFECT_WATER_GUN_DOWN_START, effectM = EFFECT_WATER_GUN_DOWN_MIDDLE, effectE = EFFECT_WATER_GUN_DOWN_END},
	[WEST] =  {x = -1, y = 0, effectS = EFFECT_WATER_GUN_LEFT_START, effectM = EFFECT_WATER_GUN_LEFT_MIDDLE, effectE = EFFECT_WATER_GUN_LEFT_END}
}

function onTargetCreature_HydroPump(cid, target)
    doSkillDamage(cid, target, SKILL_NAME)
end

function onTargetTile_HydroPump(cid, position)
    local cidPos = getCreaturePosition(cid)
    if (cidPos.x == position.x or cidPos.y == position.y) then -- Same line
        doSendMagicEffect(position, EFFECT_WATER_TORNADO_TWO)
    else
        local distance = getDistanceBetween(cidPos, position)
        if (distance == 1) then
            doSendMagicEffect(position, LOOK_DIRS[getCreatureLookDir(cid)].effectS)
        elseif (distance == 6) then
            doSendMagicEffect(position, LOOK_DIRS[getCreatureLookDir(cid)].effectE)
        else
            doSendMagicEffect(position, LOOK_DIRS[getCreatureLookDir(cid)].effectM)
        end
    end
end

local combat = createCombatObject()
setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_HydroPump")
setCombatCallback(combat, CALLBACK_PARAM_TARGETTILE, "onTargetTile_HydroPump")
setCombatArea(combat, createCombatArea({{1, 3, 1}}))

local function doSpell(cid, toDirection, lastPosition, ticks)
	if (isCreature(cid)) then
		lastPosition.x = lastPosition.x + LOOK_DIRS[toDirection].x
		lastPosition.y = lastPosition.y + LOOK_DIRS[toDirection].y
		doCombat(cid, combat, positionToVariant(lastPosition))
		if (ticks > 0) then
			doSpell(cid, toDirection, lastPosition, ticks - 1)
		end
	end
end

function onCastSpell(cid, var)
	doSpell(cid, getCreatureLookDirection(cid), getCreaturePosition(cid), 5)
	return true
end