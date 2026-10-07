local SKILL_NAME = "Rock Tomb"
local SKILL_AREAS = {
	createCombatArea(AREA_CIRCLE4X4_EMPTY),
    createCombatArea(AREA_CIRCLE3X3_EMPTY),
    createCombatArea(AREA_CIRCLE2X2_EMPTY),
    createCombatArea(AREA_SQUARE1X1)
}

local combats = {}
for i, skillArea in ipairs(SKILL_AREAS) do
	combats[i] = createCombatObject()
	setCombatParam(combats[i], COMBAT_PARAM_EFFECT, getPokemonSkillAreaEffect(SKILL_NAME))
	setCombatArea(combats[i], skillArea)
end

local function doEffect(cid, combat, var)
	if (isCreature(cid)) then
		doCombat(cid, combat, var)
	end
end

function onTargetCreature_RockTomb(cid, target)
	doSkillDamage(cid, target, SKILL_NAME)
    if (not isCreature(target)) then return end -- Defeated
    if (not doPokemonSpecialAbilityCheck(target, POKEMON_SPECIAL_ABILITY_IDS.SHIELD_DUST, nil)) then
        doCreatureAddStatus(target, CREATURE_STATUS_EXTRASPEED, CREATURE_STATUS_VAR_BAD, cid)
    end
end
local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_RockTomb")

local function doSpell(cid)
    if (isCreature(cid) and hasTarget(cid)) then
        doCombat(cid, combat, numberToVariant(getCreatureTarget(cid)))
    end
end

function onCastSpell(cid, var)
	for i, combat in ipairs(combats) do
		addEvent(doEffect, 250 * i, cid, combat, var)
    end
    addEvent(doSpell, 250 * #SKILL_AREAS, cid)
	return true
end