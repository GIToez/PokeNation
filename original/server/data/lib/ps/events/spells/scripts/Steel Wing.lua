local SKILL_NAME = "Steel Wing"
local LOOK_DIRS = {
	[NORTH] = {x = 0, y = -2, effect = EFFECT_GRAY_WING_ATTACK_UP},
	[EAST] =  {x = 2, y = 0, effect = EFFECT_GRAY_WING_ATTACK_RIGHT},
	[SOUTH] = {x = 0, y = 2, effect = EFFECT_GRAY_WING_ATTACK_DOWN},
	[WEST] =  {x = -2, y = 0, effect = EFFECT_GRAY_WING_ATTACK_LEFT}
}

function onTargetCreature_SteelWing(cid, target)
    doSkillDamage(cid, target, SKILL_NAME)
end

local combat = createCombatObject()
setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_SteelWing")
setCombatArea(combat, createCombatArea(AREA_DOUBLE_FRONT_WALL))

local function doSpell(cid, toDirection, lastPosition, ticks)
	if (isCreature(cid)) then
		lastPosition.x = lastPosition.x + LOOK_DIRS[toDirection].x
		lastPosition.y = lastPosition.y + LOOK_DIRS[toDirection].y
		doCombat(cid, combat, positionToVariant(lastPosition))
        doSendMagicEffect(lastPosition, LOOK_DIRS[toDirection].effect)
        addEvent(doSendMagicEffect, 250, lastPosition, LOOK_DIRS[toDirection].effect)
		if (ticks > 0) then
			doSpell(cid, toDirection, lastPosition, ticks - 1)
		end
	end
end

function onCastSpell(cid, var)
	if (getRandom(0, 100) <= 10) then
        doCreatureAddStatus(cid, CREATURE_STATUS_EXTRASPDEF, CREATURE_STATUS_VAR_LOW, cid)
    end

    local pos, lookDir = getCreaturePosition(cid), getCreatureLookDirection(cid)
    doSpell(cid, lookDir, getPosByDir(pos, REVERSE_DIR[lookDir], 1), 3)
	return true
end