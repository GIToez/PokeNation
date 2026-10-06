local SKILL_NAME = "Extrasensory"
local LOOK_DIRS = {
	[NORTH] = {x = 1, y = -1, effect = EFFECT_PSYBEAM_UP},
	[EAST] =  {x = 4, y = 1, effect = EFFECT_PSYBEAM_RIGHT},
	[SOUTH] = {x = 1, y = 4, effect = EFFECT_PSYBEAM_DOWN},
	[WEST] =  {x = -1, y = 1, effect = EFFECT_PSYBEAM_LEFT}
}

LOOK_DIRS[NORTH].reverseX = 1
LOOK_DIRS[NORTH].reverseY = 0

LOOK_DIRS[EAST].reverseX = 4
LOOK_DIRS[EAST].reverseY = 1

LOOK_DIRS[SOUTH].reverseX = 1
LOOK_DIRS[SOUTH].reverseY = 4

LOOK_DIRS[WEST].reverseX = 0
LOOK_DIRS[WEST].reverseY = 1

function onTargetCreature_Extrasensory(cid, target)
    doSkillDamage(cid, target, SKILL_NAME)
    if (not isCreature(target)) then return end -- Defeated
    if (not doPokemonSpecialAbilityCheck(target, POKEMON_SPECIAL_ABILITY_IDS.SHIELD_DUST, nil) and getRandom(0, 100) <=
            (doPokemonSpecialAbilityCheck(cid, POKEMON_SPECIAL_ABILITY_IDS.SERENA_GRACE, nil) and 20 or 10)) then
		doCreatureAddStatus(target, CREATURE_STATUS_FLINCH, nil, cid)
    end
end

local combat = createCombatObject()
setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Extrasensory")
setCombatArea(combat, createCombatArea(AREA_SQUAREWAVE5_CROSS))

local function doSpell(cid, toDirection, pos, var)
	if (isCreature(cid)) then
		doSendMagicEffect({x = pos.x + LOOK_DIRS[toDirection].x, y = pos.y + LOOK_DIRS[toDirection].y, z = pos.z},
            LOOK_DIRS[toDirection].effect)
        doSendMagicEffect({x = pos.x + LOOK_DIRS[toDirection].reverseX, y = pos.y + LOOK_DIRS[toDirection].reverseY,
            z = pos.z}, LOOK_DIRS[REVERSE_DIR[toDirection]].effect)
        doCombat(cid, combat, var)
	end
end

function onCastSpell(cid, var)
	doSpell(cid, getCreatureLookDirection(cid), getCreaturePosition(cid), var)
	return true
end
