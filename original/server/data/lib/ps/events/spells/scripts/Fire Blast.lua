local SKILL_NAME = "Fire Blast"
local LOOK_DIRS = {
	[NORTH] = {x = 0, y = -1, effect = EFFECT_BURNING_MAN_UP},
	[EAST] =  {x = 1, y = 0, effect = EFFECT_BURNING_MAN_RIGHT},
	[SOUTH] = {x = 0, y = 1, effect = EFFECT_BURNING_MAN_DOWN},
	[WEST] =  {x = -1, y = 0, effect = EFFECT_BURNING_MAN_LEFT}
}

function onTargetCreature_FireBlast(cid, target)
    doSkillDamage(cid, target, SKILL_NAME)
    if (not isCreature(target)) then return end -- Defeated
    if (not doPokemonSpecialAbilityCheck(target, POKEMON_SPECIAL_ABILITY_IDS.SHIELD_DUST, nil) and getRandom(0, 100) <=
            (doPokemonSpecialAbilityCheck(cid, POKEMON_SPECIAL_ABILITY_IDS.SERENA_GRACE, nil) and 20 or 10)) then
        doCreatureAddStatus(target, CREATURE_STATUS_BURN, getMonsterLevel(cid), cid)
    end
end

local combat = createCombatObject()
setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_FireBlast")
setCombatArea(combat, createCombatArea({{1, 3, 1}}))

local combatEffect = createCombatObject()
setCombatArea(combatEffect, createCombatArea({{1, 3, 1}}))
setCombatParam(combatEffect, COMBAT_PARAM_EFFECT, EFFECT_FIRE)

local function doSpell(cid, toDirection, lastPosition, ticks)
	if (isCreature(cid)) then
		lastPosition.x = lastPosition.x + LOOK_DIRS[toDirection].x
		lastPosition.y = lastPosition.y + LOOK_DIRS[toDirection].y
		doSendMagicEffect(lastPosition, LOOK_DIRS[toDirection].effect)
		doCombat(cid, combat, positionToVariant(lastPosition))
        doCombat(cid, combatEffect, positionToVariant(lastPosition))
		if (ticks > 0) then
			addEvent(doSpell, 300, cid, toDirection, lastPosition, ticks - 1)
		end
	end
end

function onCastSpell(cid, var)
	doSpell(cid, getCreatureLookDirection(cid), getCreaturePosition(cid), 7)
	return true
end
