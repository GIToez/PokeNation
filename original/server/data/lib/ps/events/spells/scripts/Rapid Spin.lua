local SKILL_NAME = "Rapid Spin"
local SKILL_AREAS = {
	createCombatArea(AREA_SQUARE1X1),
	createCombatArea(AREA_SQUARE1X1),
	createCombatArea(AREA_SQUARE1X1),
	createCombatArea(AREA_SQUARE1X1),
	createCombatArea(AREA_SQUARE1X1)
}

local RAPIDSPIN_OUTFIT_BLASTOISE = createConditionObject(CONDITION_OUTFIT, #SKILL_AREAS * 500)
addOutfitCondition(RAPIDSPIN_OUTFIT_BLASTOISE, {lookType = 942})

local RAPIDSPIN_OUTFIT_STARMIE = createConditionObject(CONDITION_OUTFIT, #SKILL_AREAS * 500)
addOutfitCondition(RAPIDSPIN_OUTFIT_STARMIE, {lookType = 1151})

local RAPIDSPIN_OUTFIT_SHINYSTARMIE = createConditionObject(CONDITION_OUTFIT, #SKILL_AREAS * 500)
addOutfitCondition(RAPIDSPIN_OUTFIT_SHINYSTARMIE, {lookType = 1152})

local RAPIDSPIN_OUTFIT_SHINYBLASTOISE = createConditionObject(CONDITION_OUTFIT, #SKILL_AREAS * 500)
addOutfitCondition(RAPIDSPIN_OUTFIT_SHINYBLASTOISE, {lookType = 944})

local RAPIDSPIN_OUTFIT_KABUTOPS = createConditionObject(CONDITION_OUTFIT, #SKILL_AREAS * 500)
addOutfitCondition(RAPIDSPIN_OUTFIT_KABUTOPS, {lookType = 943})

local RAPIDSPIN_OUTFIT_HITMONTOP = createConditionObject(CONDITION_OUTFIT, #SKILL_AREAS * 500)
addOutfitCondition(RAPIDSPIN_OUTFIT_HITMONTOP, {lookType = 1126})

local RAPIDSPIN_OUTFIT_SHINYKABUTOPS = createConditionObject(CONDITION_OUTFIT, #SKILL_AREAS * 500)
addOutfitCondition(RAPIDSPIN_OUTFIT_SHINYKABUTOPS, {lookType = 945})

local RAPIDSPIN_OUTFIT_HITMONLEE = createConditionObject(CONDITION_OUTFIT, #SKILL_AREAS * 500)
addOutfitCondition(RAPIDSPIN_OUTFIT_HITMONLEE, {lookType = 609})

local RAPIDSPIN_OUTFIT_SHINYHITMONLEE = createConditionObject(CONDITION_OUTFIT, #SKILL_AREAS * 500)
addOutfitCondition(RAPIDSPIN_OUTFIT_SHINYHITMONLEE, {lookType = 883})

local RAPIDSPIN_OUTFIT_CLAYDOL = createConditionObject(CONDITION_OUTFIT, #SKILL_AREAS * 500)
addOutfitCondition(RAPIDSPIN_OUTFIT_CLAYDOL, {lookType = 1810})

local outfits = {
	["Blastoise"] = RAPIDSPIN_OUTFIT_BLASTOISE,
	["Starmie"] = RAPIDSPIN_OUTFIT_STARMIE,
	["Shiny Starmie"] = RAPIDSPIN_OUTFIT_SHINYSTARMIE,
	["Shiny Blastoise"] = RAPIDSPIN_OUTFIT_SHINYBLASTOISE,
	["Kabutops"] = RAPIDSPIN_OUTFIT_KABUTOPS,
	["Hitmontop"] = RAPIDSPIN_OUTFIT_HITMONTOP,
	["Shiny Kabutops"] = RAPIDSPIN_OUTFIT_SHINYKABUTOPS,
	["Hitmonlee"] = RAPIDSPIN_OUTFIT_HITMONLEE,
	["Shiny Hitmonlee"] = RAPIDSPIN_OUTFIT_SHINYHITMONLEE,
}

local combats = {}
for i, skillArea in ipairs(SKILL_AREAS) do
	combats[i] = createCombatObject()
	onTargetCreature_RapidSpin = function(cid, target) doSkillDamage(cid, target, SKILL_NAME) end
	setCombatCallback(combats[i], CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_RapidSpin")
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

    doCreatureRemoveStatus(cid, CREATURE_STATUS_LOWACCURACY)
    doCreatureRemoveStatus(cid, CREATURE_STATUS_PARALYSIS)

	for i, combat in ipairs(combats) do
		addEvent(doSpell, 500 * (i - 1) + 1, cid, combat)
	end
	return true
end
