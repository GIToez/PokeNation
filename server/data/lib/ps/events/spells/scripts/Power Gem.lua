local SKILL_NAME = "Power Gem"
local LOOK_DIRS = {
	[NORTH] = {x = 0, y = -1, effectS = EFFECT_YELLOW_BEAM_UP_START, effectM = EFFECT_YELLOW_BEAM_UP_MIDDLE, effectE = EFFECT_YELLOW_BEAM_UP_END},
	[EAST] =  {x = 1, y = 0, effectS = EFFECT_YELLOW_BEAM_RIGHT_START, effectM = EFFECT_YELLOW_BEAM_RIGHT_MIDDLE, effectE = EFFECT_YELLOW_BEAM_RIGHT_END},
	[SOUTH] = {x = 0, y = 1, effectS = EFFECT_YELLOW_BEAM_DOWN_START, effectM = EFFECT_YELLOW_BEAM_DOWN_MIDDLE, effectE = EFFECT_YELLOW_BEAM_DOWN_END},
	[WEST] =  {x = -1, y = 0, effectS = EFFECT_YELLOW_BEAM_LEFT_START, effectM = EFFECT_YELLOW_BEAM_LEFT_MIDDLE, effectE = EFFECT_YELLOW_BEAM_LEFT_END},
}

function onTargetCreature_PowerGem(cid, target)
	doSkillDamage(cid, target, SKILL_NAME)
end

function onTargetTile_PowerGem(cid, position)
    local cidPos = getCreaturePosition(cid)
    if (cidPos.x == position.x or cidPos.y == position.y) then
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
setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_PowerGem")
setCombatCallback(combat, CALLBACK_PARAM_TARGETTILE, "onTargetTile_PowerGem")
setCombatArea(combat, createCombatArea({{1, 3, 1}}))
setCombatParam(combat, COMBAT_PARAM_EFFECT, EFFECT_CONFUSE_STARS)

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
	doSendMagicEffect(getCreaturePosition(cid), EFFECT_POWER_UP)
    doSpell(cid, getCreatureLookDirection(cid), getCreaturePosition(cid), 7)
	return true
end
