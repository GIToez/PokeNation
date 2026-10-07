local SKILL_NAME = "Sludge Bomb"
local SKILL_AREAS = {
	createCombatArea(AREA_SQUARE1X1)
}

local combats = {}
for i, skillArea in ipairs(SKILL_AREAS) do
	combats[i] = createCombatObject()
	onTargetCreature_SludgeBomb = function(cid, target)
		doSkillDamage(cid, target, SKILL_NAME)
        if (not isCreature(target)) then return end -- Defeated
        if (not doPokemonSpecialAbilityCheck(target, POKEMON_SPECIAL_ABILITY_IDS.SHIELD_DUST, nil) and getRandom(0, 100) <=
                (doPokemonSpecialAbilityCheck(cid, POKEMON_SPECIAL_ABILITY_IDS.SERENA_GRACE, nil) and 60 or 30)) then
            doCreatureAddStatus(target, CREATURE_STATUS_POISON, getMonsterLevel(cid), cid)
        end
	end
	setCombatCallback(combats[i], CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_SludgeBomb")
	setCombatParam(combats[i], COMBAT_PARAM_EFFECT, getPokemonSkillEffect(SKILL_NAME))
	setCombatArea(combats[i], skillArea)
end

local function doSpell(cid, combat, var)
	if (isCreature(cid)) then
		doCombat(cid, combat, var)
	end
end

function onTargetCreature_SludgeBomb(cid, target)
	local var = positionToVariant(getCreaturePosition(target))
	for i, combat in ipairs(combats) do
		addEvent(doSpell, 500 * (i - 1) + 1, cid, combat, var)
	end
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_SludgeBomb")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end
