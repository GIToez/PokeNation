-- local SKILL_NAME = "Sing"
local SKILL_AREAS = {
	createCombatArea(AREA_CIRCLE3X3)
}

local combats = {}
for i, skillArea in ipairs(SKILL_AREAS) do
	combats[i] = createCombatObject()
	onTargetCreature_Sing = function(cid, target)
        if (not doPokemonSpecialAbilityCheck(target, POKEMON_SPECIAL_ABILITY_IDS.SOUNDPROOF, nil)) then
            doCreatureAddStatus(target, CREATURE_STATUS_SLEEP, nil, cid)
        end
    end
	onTargetTile_Sing = function(cid, position)
        doSendMagicEffect(position, table.random({EFFECT_PURPLE_SOUND, EFFECT_GREEN_SOUND, EFFECT_BLUE_SOUND, EFFECT_RED_SOUND}))
    end
	setCombatCallback(combats[i], CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Sing")
	setCombatCallback(combats[i], CALLBACK_PARAM_TARGETTILE, "onTargetTile_Sing")
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
