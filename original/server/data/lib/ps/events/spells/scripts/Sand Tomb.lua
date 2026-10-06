local SKILL_NAME = "Sand Tomb"
local SKILL_AREAS = {
	createCombatArea(AREA_SQUARE1X1)
}

local combats = {}
for i, skillArea in ipairs(SKILL_AREAS) do
	combats[i] = createCombatObject()
	onTargetCreature_SandTomb = function(cid, target)
        doSkillMultipleDamages(cid, SKILL_NAME, 5)
        if (not isCreature(target)) then return end -- Defeated
        if (not doPokemonSpecialAbilityCheck(target, POKEMON_SPECIAL_ABILITY_IDS.SHIELD_DUST, nil)) then
            doCreatureAddStatus(target, CREATURE_STATUS_EXTRASPEED, CREATURE_STATUS_VAR_BADMEDIUM, cid)
        end
	end
	setCombatCallback(combats[i], CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_SandTomb")
	setCombatParam(combats[i], COMBAT_PARAM_EFFECT, getPokemonSkillAreaEffect(SKILL_NAME))
	setCombatArea(combats[i], skillArea)
end

local function doSpell(cid, combat, var)
	if (isCreature(cid)) then
		doCombat(cid, combat, var)
	end
end

function onTargetCreature_SandTomb(cid, target)
	doSkillDamage(cid, target, SKILL_NAME)
	local var = positionToVariant(getCreaturePosition(target))
	for i, combat in ipairs(combats) do
		addEvent(doSpell, 500 * (i - 1) + 1, cid, combat, var)
	end
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_SandTomb")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end