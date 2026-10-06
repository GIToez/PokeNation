local SKILL_NAME = "Powder Snow"
local LOOK_DIRS = {
	[NORTH] = {x = 0, y = -2},
	[EAST] =  {x = 2, y = 0},
	[SOUTH] = {x = 0, y = 2},
	[WEST] =  {x = -2, y = 0}
}

function onTargetCreature_PowderSnow(cid, target)
    doSkillDamage(cid, target, SKILL_NAME)
    if (not isCreature(target)) then return end -- Defeated
    if (not doPokemonSpecialAbilityCheck(target, POKEMON_SPECIAL_ABILITY_IDS.SHIELD_DUST, nil) and getRandom(0, 100) <=
            (doPokemonSpecialAbilityCheck(cid, POKEMON_SPECIAL_ABILITY_IDS.SERENA_GRACE, nil) and 20 or 10)) then
        doCreatureAddStatus(target, CREATURE_STATUS_FREEZE, nil, cid)
    end
end

local combat = createCombatObject()
setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_PowderSnow")
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
	local pos, lookDir = getCreaturePosition(cid), getCreatureLookDirection(cid)
    doSpell(cid, lookDir, getPosByDir(pos, REVERSE_DIR[lookDir], 1), 3)
	return true
end