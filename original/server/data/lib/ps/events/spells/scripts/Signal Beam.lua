local SKILL_NAME = "Signal Beam"
local LOOK_DIRS = {
	[NORTH] = {x = 0, y = -1},
	[EAST] =  {x = 1, y = 0},
	[SOUTH] = {x = 0, y = 1},
	[WEST] =  {x = -1, y = 0}
}

function onTargetCreature_SignalBeam(cid, target)
    doSkillDamage(cid, target, SKILL_NAME)
    if (not isCreature(target)) then return end -- Defeated
    if (not doPokemonSpecialAbilityCheck(target, POKEMON_SPECIAL_ABILITY_IDS.SHIELD_DUST, nil) and getRandom(0, 100) <=
            (doPokemonSpecialAbilityCheck(cid, POKEMON_SPECIAL_ABILITY_IDS.SERENA_GRACE, nil) and 20 or 10)) then
		doCreatureAddStatus(cid, CREATURE_STATUS_CONFUSION, nil, cid)
	end
end

local combat = createCombatObject()
setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_SignalBeam")
setCombatArea(combat, createCombatArea({{1}}))
setCombatParam(combat, COMBAT_PARAM_EFFECT, getPokemonSkillAreaEffect(SKILL_NAME))

local function doSpell(cid, toDirection, lastPosition, ticks)
	if (isCreature(cid)) then
		lastPosition.x = lastPosition.x + LOOK_DIRS[toDirection].x
		lastPosition.y = lastPosition.y + LOOK_DIRS[toDirection].y
		doCombat(cid, combat, positionToVariant(lastPosition))
		if (ticks > 0) then
			addEvent(doSpell, 300, cid, toDirection, lastPosition, ticks - 1)
		end
	end
end

function onCastSpell(cid, var)
	doSpell(cid, getCreatureLookDirection(cid), getCreaturePosition(cid), 7)
	return true
end
