local SKILL_NAME = "Rock Slide"
local SKILL_AREAS = {
	createCombatArea(AREA_CIRCLE3X3),
	createCombatArea(AREA_CIRCLE3X3)
}
local rand = 30 / #SKILL_AREAS

local combats = {}
for i, skillArea in ipairs(SKILL_AREAS) do
	combats[i] = createCombatObject()
	onTargetCreature_RockSlide = function(cid, target)
        doSkillDamage(cid, target, SKILL_NAME)
        if (not isCreature(target)) then return end -- Defeated
        if (not doPokemonSpecialAbilityCheck(target, POKEMON_SPECIAL_ABILITY_IDS.SHIELD_DUST, nil) and getRandom(0, 100) <=
                (doPokemonSpecialAbilityCheck(cid, POKEMON_SPECIAL_ABILITY_IDS.SERENA_GRACE, nil) and (rand * 2) or rand)) then
            doCreatureAddStatus(target, CREATURE_STATUS_FLINCH, nil, cid)
        end
    end
	onTargetTile_RockSlide = function(cid, position)
		position.x = position.x + math.random(0, 2)
		position.y = position.y + math.random(0, 2)
		doSendDistanceShoot(getSkyPosition(position), position, PROJECTILE_ROCK)
		addEvent(doSendMagicEffect, 150, position, EFFECT_FAILING_ROCKS)
	end
	setCombatCallback(combats[i], CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_RockSlide")
	setCombatCallback(combats[i], CALLBACK_PARAM_TARGETTILE, "onTargetTile_RockSlide")
	setCombatArea(combats[i], skillArea)
end

local function doSpell(cid, combat, var)
	if (isCreature(cid)) then
		doCombat(cid, combat, var)
	end
end

function onCastSpell(cid, var)
	for i, combat in ipairs(combats) do
		addEvent(doSpell, 500 * (i - 1) + 1, cid, combat, var)
	end
	return true
end
