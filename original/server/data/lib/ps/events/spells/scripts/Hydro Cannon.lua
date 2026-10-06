local SKILL_NAME = "Hydro Cannon"
local LOOK_DIRS = {
	[NORTH] = {x = 0, y = -1, effect = EFFECT_WATERING_MAN_UP},
	[EAST] =  {x = 1, y = 0, effect = EFFECT_WATERING_MAN_RIGHT},
	[SOUTH] = {x = 0, y = 1, effect = EFFECT_WATERING_MAN_DOWN},
	[WEST] =  {x = -1, y = 0, effect = EFFECT_WATERING_MAN_LEFT}
}

function onTargetCreature_HydroCannon(cid, target) doSkillDamage(cid, target, SKILL_NAME) end
local combat = createCombatObject()
setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_HydroCannon")
setCombatArea(combat, createCombatArea({{1, 3, 1}}))

local combatEffect = createCombatObject()
setCombatArea(combatEffect, createCombatArea({{1, 3, 1}}))
setCombatParam(combatEffect, COMBAT_PARAM_EFFECT, EFFECT_WATER_TORNADO_TWO)

local function doSpell(cid, toDirection, lastPosition, ticks)
	if (isCreature(cid)) then
		lastPosition.x = lastPosition.x + LOOK_DIRS[toDirection].x
		lastPosition.y = lastPosition.y + LOOK_DIRS[toDirection].y
		doSendMagicEffect(lastPosition, LOOK_DIRS[toDirection].effect)
		doCombat(cid, combat, positionToVariant(lastPosition))
        doCombat(cid, combatEffect, positionToVariant(lastPosition))
		if (ticks > 0) then
			addEvent(doSpell, 300, cid, toDirection, lastPosition, ticks - 1)
		end
	end
end

function onCastSpell(cid, var)
	doSpell(cid, getCreatureLookDirection(cid), getCreaturePosition(cid), 7)
    doCreatureAddStatus(cid, CREATURE_STATUS_RECHARGE, nil, cid)
	return true
end
