local SKILL_NAME = "Silver Wind"
local LOOK_DIRS = {
	[NORTH] = {x = 0, y = -2},
	[EAST] =  {x = 2, y = 0},
	[SOUTH] = {x = 0, y = 2},
	[WEST] =  {x = -2, y = 0}
}

function onTargetCreature_SilverWind(cid, target)
    doSkillDamage(cid, target, SKILL_NAME)
end
local combat = createCombatObject()
setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_SilverWind")
setCombatArea(combat, createCombatArea(AREA_DOUBLE_FRONT_WALL))
setCombatParam(combat, COMBAT_PARAM_EFFECT, getPokemonSkillAreaEffect(SKILL_NAME))

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
    if (getRandom(0, 100) <= 10) then
        doCreatureAddStatus(cid, CREATURE_STATUS_EXTRASPDEF, CREATURE_STATUS_VAR_LOW, cid)
        doCreatureAddStatus(cid, CREATURE_STATUS_EXTRASPATK, CREATURE_STATUS_VAR_LOW, cid)
        doCreatureAddStatus(cid, CREATURE_STATUS_EXTRASPEED, nil, cid)
    end
    local pos, lookDir = getCreaturePosition(cid), getCreatureLookDirection(cid)
    doSpell(cid, lookDir, getPosByDir(pos, REVERSE_DIR[lookDir], 1), 3)
	return true
end