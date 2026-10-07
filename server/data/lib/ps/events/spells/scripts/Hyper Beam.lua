local SKILL_NAME = "Hyper Beam"
local LOOK_DIRS = {
	[NORTH] = {x = 0, y = -1, effectS = EFFECT_HYPER_BEAM_UP_START, effectM = EFFECT_HYPER_BEAM_UP_MIDDLE, effectE = EFFECT_HYPER_BEAM_UP_END},
	[EAST] =  {x = 1, y = 0, effectS = EFFECT_HYPER_BEAM_RIGHT_START, effectM = EFFECT_HYPER_BEAM_RIGHT_MIDDLE, effectE = EFFECT_HYPER_BEAM_RIGHT_END},
	[SOUTH] = {x = 0, y = 1, effectS = EFFECT_HYPER_BEAM_DOWN_START, effectM = EFFECT_HYPER_BEAM_DOWN_MIDDLE, effectE = EFFECT_HYPER_BEAM_DOWN_END},
	[WEST] =  {x = -1, y = 0, effectS = EFFECT_HYPER_BEAM_LEFT_START, effectM = EFFECT_HYPER_BEAM_LEFT_MIDDLE, effectE = EFFECT_HYPER_BEAM_LEFT_END}
}

function onTargetCreature_HyperBeam(cid, target) doSkillDamage(cid, target, SKILL_NAME) end
local combat = createCombatObject()
setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_HyperBeam")
setCombatArea(combat, createCombatArea({{1, 3, 1}}))

local function doSpell(cid, toDirection, lastPosition, ticks)
	if (isCreature(cid)) then
		lastPosition.x = lastPosition.x + LOOK_DIRS[toDirection].x
		lastPosition.y = lastPosition.y + LOOK_DIRS[toDirection].y
        doCombat(cid, combat, positionToVariant(lastPosition))
		if (ticks == 7) then
			doSendMagicEffect({x = lastPosition.x, y = lastPosition.y, z = lastPosition.z}, LOOK_DIRS[toDirection].effectS)
		elseif (ticks == 0) then
			doSendMagicEffect({x = lastPosition.x, y = lastPosition.y, z = lastPosition.z}, LOOK_DIRS[toDirection].effectE)
		else
			doSendMagicEffect({x = lastPosition.x, y = lastPosition.y, z = lastPosition.z}, LOOK_DIRS[toDirection].effectM)
		end
		if (ticks > 0) then
			doSpell(cid, toDirection, lastPosition, ticks - 1)
		end
	end
end

function onCastSpell(cid, var)
	doSpell(cid, getCreatureLookDirection(cid), getCreaturePosition(cid), 7)
    doCreatureAddStatus(cid, CREATURE_STATUS_RECHARGE, nil, cid)
	return true
end