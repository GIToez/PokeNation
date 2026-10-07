local SKILL_NAME = "Charge Beam"
local LOOK_DIRS = {
	[NORTH] = {x = 0, y = -1, effectS = EFFECT_YELLOW_BEAM_UP_START, effectM = EFFECT_YELLOW_BEAM_UP_MIDDLE, effectE = EFFECT_YELLOW_BEAM_UP_END},
	[EAST] =  {x = 1, y = 0, effectS = EFFECT_YELLOW_BEAM_RIGHT_START, effectM = EFFECT_YELLOW_BEAM_RIGHT_MIDDLE, effectE = EFFECT_YELLOW_BEAM_RIGHT_END},
	[SOUTH] = {x = 0, y = 1, effectS = EFFECT_YELLOW_BEAM_DOWN_START, effectM = EFFECT_YELLOW_BEAM_DOWN_MIDDLE, effectE = EFFECT_YELLOW_BEAM_DOWN_END},
	[WEST] =  {x = -1, y = 0, effectS = EFFECT_YELLOW_BEAM_LEFT_START, effectM = EFFECT_YELLOW_BEAM_LEFT_MIDDLE, effectE = EFFECT_YELLOW_BEAM_LEFT_END}
}

function onTargetCreature_ChargeBeam(cid, target)
	doSkillDamage(cid, target, SKILL_NAME)
end

local combat = createCombatObject()
setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_ChargeBeam")
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
	doSendMagicEffect(getCreaturePosition(cid), EFFECT_BIG_ELECTRIC_BALL)
    doSpell(cid, getCreatureLookDirection(cid), getCreaturePosition(cid), 7)
    if (getRandom(0, 100) <= 70) then
		doCreatureAddStatus(cid, CREATURE_STATUS_EXTRASPATK, CREATURE_STATUS_VAR_LOW, cid)
	end
	return true
end
