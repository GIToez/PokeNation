local SKILL_NAME = "Discharge"
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
local AREA_EFFECT = getPokemonSkillAreaEffect(SKILL_NAME)

local combats = {}
for i, skillArea in ipairs(SKILL_AREAS) do
	combats[i] = createCombatObject()
	onTargetCreature_Discharge = function(cid, target)
        local pos = getCreaturePosition(target)
        doSendDistanceShoot(getSkyPosition(pos), pos, PROJECTILE_DOUBLE_THUNDER)
        doSkillDamage(cid, target, SKILL_NAME)
        if (not isCreature(target)) then return end -- Defeated
        if (not doPokemonSpecialAbilityCheck(target, POKEMON_SPECIAL_ABILITY_IDS.SHIELD_DUST, nil) and getRandom(0, 100) <=
                (doPokemonSpecialAbilityCheck(cid, POKEMON_SPECIAL_ABILITY_IDS.SERENA_GRACE, nil) and 12 or 6)) then -- 30% / 6
            doCreatureAddStatus(target, CREATURE_STATUS_PARALYSIS, nil, cid)
        end
    end
    onTargetTile_Discharge = function(cid, position)
        doSendMagicEffect(position, AREA_EFFECT)
    end
	setCombatCallback(combats[i], CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Discharge")
	setCombatCallback(combats[i], CALLBACK_PARAM_TARGETTILE, "onTargetTile_Discharge")
	setCombatArea(combats[i], skillArea)
end

local function doSpell(cid, combat)
	if (isCreature(cid)) then
		doCombat(cid, combat, positionToVariant(getCreaturePosition(cid)))
	end
end

function onCastSpell(cid, var)
	doSendMagicEffect(getCreaturePosition(cid), EFFECT_ELECTRIC_CLOUD)
	for i, combat in ipairs(combats) do
		addEvent(doSpell, 500 * (i - 1) + 1, cid, combat)
	end
	return true
end
