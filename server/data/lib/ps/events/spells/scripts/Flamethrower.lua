local SKILL_NAME = "Flamethrower"
local LOOK_DIRS = {
	[NORTH] = {x = 1, y = -1, effect = EFFECT_FLAMETHROWER_UP},
	[EAST] =  {x = 3, y = 1, effect = EFFECT_FLAMETHROWER_RIGHT},
	[SOUTH] = {x = 1, y = 3, effect = EFFECT_FLAMETHROWER_DOWN},
	[WEST] =  {x = -1, y = 1, effect = EFFECT_FLAMETHROWER_LEFT}
}

function onTargetCreature_Flamethrower(cid, target)
    doSkillDamage(cid, target, SKILL_NAME)
    if (not isCreature(target)) then return end -- Defeated
    if (not doPokemonSpecialAbilityCheck(target, POKEMON_SPECIAL_ABILITY_IDS.SHIELD_DUST, nil) and getRandom(0, 100) <=
            (doPokemonSpecialAbilityCheck(cid, POKEMON_SPECIAL_ABILITY_IDS.SERENA_GRACE, nil) and 20 or 10)) then
        doCreatureAddStatus(target, CREATURE_STATUS_BURN, getMonsterLevel(cid), cid)
    end
end

local combat = createCombatObject()
setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Flamethrower")
setCombatArea(combat, createCombatArea(AREA_WAVE3X3))

local function doSpell(cid, var)
	local dir, pos = getCreatureLookDirection(cid), getCreaturePosition(cid)
	doSendMagicEffect({x = pos.x + LOOK_DIRS[dir].x, y = pos.y + LOOK_DIRS[dir].y, z = pos.z}, LOOK_DIRS[dir].effect)
	doCombat(cid, combat, var)
end

function onCastSpell(cid, var)
	doSpell(cid, var)
	return true
end
