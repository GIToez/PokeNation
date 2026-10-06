local SKILL_NAME = "Snore"
local SKILL_AREAS = {
	createCombatArea(AREA_CIRCLE1X1),
	createCombatArea(AREA_CIRCLE2X2_EMPTY),
	createCombatArea(AREA_CIRCLE3X3_EMPTY),
	createCombatArea(AREA_CIRCLE4X4_EMPTY)
}

local combats = {}
for i, skillArea in ipairs(SKILL_AREAS) do
	combats[i] = createCombatObject()
	onTargetCreature_Snore = function(cid, target)
        if (not doPokemonSpecialAbilityCheck(target, POKEMON_SPECIAL_ABILITY_IDS.SOUNDPROOF, nil)) then
            doSkillDamage(cid, target, SKILL_NAME)
        end
    end
	setCombatCallback(combats[i], CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Snore")
	setCombatParam(combats[i], COMBAT_PARAM_EFFECT, getPokemonSkillAreaEffect(SKILL_NAME))
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