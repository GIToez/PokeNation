local SKILL_NAME = "Air Cutter"
local LOOK_DIRS = {
	[NORTH] = {x = 0, y = -1, effect = EFFECT_BIG_CROSS_UP},
	[EAST] =  {x = 1, y = 0, effect = EFFECT_BIG_CROSS_RIGHT},
	[SOUTH] = {x = 0, y = 1, effect = EFFECT_BIG_CROSS_DOWN},
	[WEST] =  {x = -1, y = 0, effect = EFFECT_BIG_CROSS_LEFT}
}

function onTargetCreature_AirCutter(cid, target) doSkillDamage(cid, target, SKILL_NAME) end
local combat = createCombatObject()
setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_AirCutter")
setCombatArea(combat, createCombatArea({{1, 3, 1}}))

local function doSpell(cid, toDirection, lastPosition, ticks)
	if (isCreature(cid)) then
		lastPosition.x = lastPosition.x + LOOK_DIRS[toDirection].x
		lastPosition.y = lastPosition.y + LOOK_DIRS[toDirection].y
		doCombat(cid, combat, positionToVariant(lastPosition))
		if (ticks > 0) then
			addEvent(doSpell, 150, cid, toDirection, lastPosition, ticks - 1)
        end
        doSendMagicEffect({x = lastPosition.x, y = lastPosition.y, z = lastPosition.z}, LOOK_DIRS[toDirection].effect) -- Lua bug if use directly lastPosition
	end
end

function onCastSpell(cid, var)
	doSpell(cid, getCreatureLookDirection(cid), getCreaturePosition(cid), 10)
	return true
end