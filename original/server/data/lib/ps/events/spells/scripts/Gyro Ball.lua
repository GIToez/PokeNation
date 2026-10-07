local SKILL_NAME = "Gyro Ball"
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

local OUTFIT_FORRETRESS = createConditionObject(CONDITION_OUTFIT, #SKILL_AREAS * 500)
addOutfitCondition(OUTFIT_FORRETRESS, {lookType = 1125})

local OUTFIT_SHINY_FORRETRESS = createConditionObject(CONDITION_OUTFIT, #SKILL_AREAS * 500)
addOutfitCondition(OUTFIT_SHINY_FORRETRESS, {lookType = 1700})

local OUTFIT_HITMONTOP = createConditionObject(CONDITION_OUTFIT, #SKILL_AREAS * 500)
addOutfitCondition(OUTFIT_HITMONTOP, {lookType = 1126})

local OUTFIT_SHINY_HITMONTOP = createConditionObject(CONDITION_OUTFIT, #SKILL_AREAS * 500)
addOutfitCondition(OUTFIT_SHINY_HITMONTOP, {lookType = 1701})

local outfits = {
	["Forretress"] = OUTFIT_FORRETRESS,
	["Shiny Forretress"] = OUTFIT_SHINY_FORRETRESS,
	["Hitmontop"] = OUTFIT_HITMONTOP,
	["Shiny Hitmontop"] = OUTFIT_SHINY_HITMONTOP
}

local combats = {}
for i, skillArea in ipairs(SKILL_AREAS) do
	combats[i] = createCombatObject()
	onTargetCreature_GyroBall = function(cid, target) doSkillDamage(cid, target, SKILL_NAME) end
	setCombatCallback(combats[i], CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_GyroBall")
	setCombatArea(combats[i], skillArea)
end

local function doSpell(cid, combat)
	if (isCreature(cid)) then
		doCombat(cid, combat, positionToVariant(getCreaturePosition(cid)))
	end
end

function onCastSpell(cid, var)
	local name = getPokemonReferenceName(cid)
	if (outfits[name] and not hasCondition(cid, CONDITION_OUTFIT)) then
		doAddCondition(cid, outfits[name])
	end
	doCreatureAddStatus(cid, CREATURE_STATUS_EXTRASPEED, nil, cid)
	for i, combat in ipairs(combats) do
		addEvent(doSpell, 500 * (i - 1) + 1, cid, combat)
	end
	return true
end
