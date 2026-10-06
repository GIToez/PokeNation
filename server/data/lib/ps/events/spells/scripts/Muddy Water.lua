local SKILL_NAME = "Muddy Water"
local SKILL_AREAS = {
	createCombatArea(AREA_CIRCLE3X3),
	createCombatArea(AREA_CIRCLE3X3),
	createCombatArea(AREA_CIRCLE3X3),
	createCombatArea(AREA_CIRCLE3X3),
	createCombatArea(AREA_CIRCLE3X3),
	createCombatArea(AREA_CIRCLE3X3),
	createCombatArea(AREA_CIRCLE3X3),
	createCombatArea(AREA_CIRCLE3X3),
	createCombatArea(AREA_CIRCLE3X3),
	createCombatArea(AREA_CIRCLE3X3)
}
local SKILL_PROJECTILE = getPokemonSkillProjectile(SKILL_NAME)

local combats = {}
for i, skillArea in ipairs(SKILL_AREAS) do
	combats[i] = createCombatObject()
	onTargetCreature_MuddyWater = function(cid, target)
		doSkillDamage(cid, target, SKILL_NAME)
        if (not isCreature(target)) then return end -- Defeated
        if (not doPokemonSpecialAbilityCheck(target, POKEMON_SPECIAL_ABILITY_IDS.SHIELD_DUST, nil) and getRandom(0, 100) <=
                (doPokemonSpecialAbilityCheck(cid, POKEMON_SPECIAL_ABILITY_IDS.SERENA_GRACE, nil) and 12 or 6)) then -- 30% / 5
            doCreatureAddStatus(target, CREATURE_STATUS_EXTRASPATK, CREATURE_STATUS_VAR_BAD, cid)
        end
    end
    onTargetTile_MuddyWater = function(cid, position)
        if (getRandom(0, 1) == 0) then
            doSendMagicEffect(position, EFFECT_SURF)
        end
    end
	setCombatCallback(combats[i], CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_MuddyWater")
	setCombatCallback(combats[i], CALLBACK_PARAM_TARGETTILE, "onTargetTile_MuddyWater")
	setCombatArea(combats[i], skillArea)
end

local function doSpell(cid, combat)
	if (isCreature(cid)) then
		local pos = getCreaturePosition(cid)
		for i = 1, 30 do
			doSendDistanceShoot(pos, {x = pos.x + math.random(-7, 7), y = pos.y + math.random(-5, 5), z = pos.z}, SKILL_PROJECTILE)
		end
		doCombat(cid, combat, positionToVariant(pos))
	end
end

function onCastSpell(cid, var)
	for i, combat in ipairs(combats) do
		addEvent(doSpell, 500 * (i - 1) + 1, cid, combat)
	end
	return true
end
