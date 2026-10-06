local SKILL_NAME = "Flame Wheel"
local SKILL_AREAS = {
	createCombatArea(AREA_SQUARE1X1),
	createCombatArea(AREA_SQUARE1X1),
	createCombatArea(AREA_SQUARE1X1),
	createCombatArea(AREA_SQUARE1X1),
	createCombatArea(AREA_SQUARE1X1),
	createCombatArea(AREA_SQUARE1X1),
	createCombatArea(AREA_SQUARE1X1),
	createCombatArea(AREA_SQUARE1X1),
	createCombatArea(AREA_SQUARE1X1),
	createCombatArea(AREA_SQUARE1X1)
}
local SKILL_DAMAGE = getPokemonSkillDamage(SKILL_NAME) / 10

local combats = {}
for i, skillArea in ipairs(SKILL_AREAS) do
	combats[i] = createCombatObject()
	onTargetCreature_FlameWheel = function(cid, target)
        doSkillDamage(cid, target, SKILL_NAME, SKILL_DAMAGE)
        if (not isCreature(target)) then return end -- Defeated
        if (not doPokemonSpecialAbilityCheck(target, POKEMON_SPECIAL_ABILITY_IDS.SHIELD_DUST, nil) and getRandom(0, 100) <=
                (doPokemonSpecialAbilityCheck(cid, POKEMON_SPECIAL_ABILITY_IDS.SERENA_GRACE, nil) and 2 or 1)) then -- 10% / 10
            doCreatureAddStatus(target, CREATURE_STATUS_BURN, getMonsterLevel(cid), cid)
        end
    end
	setCombatCallback(combats[i], CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_FlameWheel")
	setCombatArea(combats[i], skillArea)
    setCombatParam(combats[i], COMBAT_PARAM_EFFECT, getPokemonSkillAreaEffect(SKILL_NAME))
end

local function doSpell(cid, combat)
	if (isCreature(cid)) then
		doCombat(cid, combat, positionToVariant(getCreaturePosition(cid)))
	end
end

function onCastSpell(cid, var)
	doCreatureRemoveStatus(cid, CREATURE_STATUS_FREEZE)
    doCreatureAddStatus(cid, CREATURE_STATUS_EXTRASPEED, nil, cid)
	local i, combat
	for i, combat in ipairs(combats) do
		addEvent(doSpell, 200 * (i - 1) + 1, cid, combat)
	end
	return true
end
