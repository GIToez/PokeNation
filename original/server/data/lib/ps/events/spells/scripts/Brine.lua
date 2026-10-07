local SKILL_NAME = "Brine"
local LOOK_DIRS = {
	[NORTH] = {x = 0, y = -1, effectS = EFFECT_WATER_GUN_UP_START, effectM = EFFECT_WATER_GUN_UP_MIDDLE, effectE = EFFECT_WATER_GUN_UP_END},
	[EAST] =  {x = 1, y = 0, effectS = EFFECT_WATER_GUN_RIGHT_START, effectM = EFFECT_WATER_GUN_RIGHT_MIDDLE, effectE = EFFECT_WATER_GUN_RIGHT_END},
	[SOUTH] = {x = 0, y = 1, effectS = EFFECT_WATER_GUN_DOWN_START, effectM = EFFECT_WATER_GUN_DOWN_MIDDLE, effectE = EFFECT_WATER_GUN_DOWN_END},
	[WEST] =  {x = -1, y = 0, effectS = EFFECT_WATER_GUN_LEFT_START, effectM = EFFECT_WATER_GUN_LEFT_MIDDLE, effectE = EFFECT_WATER_GUN_LEFT_END}
}

function onTargetCreature_Brine(cid, target)
	local power = getPokemonSkillDamage(SKILL_NAME)
    if (getCreatureHealth(target) <= getCreatureMaxHealth(target) / 2) then
		power = power * 2
	end
    doSkillDamage(cid, target, SKILL_NAME, power)
end
local combat = createCombatObject()
setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Brine")
setCombatArea(combat, createCombatArea({{1}}))

local function doSpell(cid, toDirection, lastPosition, ticks)
	if (isCreature(cid)) then
		lastPosition.x = lastPosition.x + LOOK_DIRS[toDirection].x
		lastPosition.y = lastPosition.y + LOOK_DIRS[toDirection].y
		if (ticks == 7) then
			doSendMagicEffect(lastPosition, LOOK_DIRS[toDirection].effectS)
		elseif (ticks == 0) then
			doSendMagicEffect(lastPosition, LOOK_DIRS[toDirection].effectE)
		else
			doSendMagicEffect(lastPosition, LOOK_DIRS[toDirection].effectM)
		end
		doCombat(cid, combat, positionToVariant(lastPosition))
		if (ticks > 0) then
			doSpell(cid, toDirection, lastPosition, ticks - 1)
		end
	end
end

function onCastSpell(cid, var)
	doSpell(cid, getCreatureLookDirection(cid), getCreaturePosition(cid), 7)
	return true
end
