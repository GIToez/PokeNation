local SKILL_NAME = "Rollout"
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

local ROLLING_OUTFIT_SANDSHREW = createConditionObject(CONDITION_OUTFIT, #SKILL_AREAS * 500)
local ROLLING_OUTFIT_SANDSLASH = createConditionObject(CONDITION_OUTFIT, #SKILL_AREAS * 500)
local ROLLING_OUTFIT_VOLTORB = createConditionObject(CONDITION_OUTFIT, #SKILL_AREAS * 500)
local ROLLING_OUTFIT_ELECTRODE = createConditionObject(CONDITION_OUTFIT, #SKILL_AREAS * 500)
local ROLLING_OUTFIT_GOLEM = createConditionObject(CONDITION_OUTFIT, #SKILL_AREAS * 500)
local ROLLING_OUTFIT_OMASTAR = createConditionObject(CONDITION_OUTFIT, #SKILL_AREAS * 500)
local ROLLING_OUTFIT_LICKITUNG = createConditionObject(CONDITION_OUTFIT, #SKILL_AREAS * 500)
local ROLLING_OUTFIT_SHUCKLE = createConditionObject(CONDITION_OUTFIT, #SKILL_AREAS * 500)
local ROLLING_OUTFIT_PHANPY = createConditionObject(CONDITION_OUTFIT, #SKILL_AREAS * 500)
local ROLLING_OUTFIT_DONPHAN = createConditionObject(CONDITION_OUTFIT, #SKILL_AREAS * 500)
local ROLLING_OUTFIT_MILTANK = createConditionObject(CONDITION_OUTFIT, #SKILL_AREAS * 500)
local ROLLING_OUTFIT_SHINYSANDSHREW = createConditionObject(CONDITION_OUTFIT, #SKILL_AREAS * 500)
local ROLLING_OUTFIT_SHINYSANDSLASH = createConditionObject(CONDITION_OUTFIT, #SKILL_AREAS * 500)
local ROLLING_OUTFIT_SHINYVOLTORB = createConditionObject(CONDITION_OUTFIT, #SKILL_AREAS * 500)
local ROLLING_OUTFIT_SHINYELECTRODE = createConditionObject(CONDITION_OUTFIT, #SKILL_AREAS * 500)
local ROLLING_OUTFIT_SHINYGOLEM = createConditionObject(CONDITION_OUTFIT, #SKILL_AREAS * 500)
local ROLLING_OUTFIT_SHINYOMASTAR = createConditionObject(CONDITION_OUTFIT, #SKILL_AREAS * 500)
local ROLLING_OUTFIT_SHINYLICKITUNG = createConditionObject(CONDITION_OUTFIT, #SKILL_AREAS * 500)
local ROLLING_OUTFIT_SHINYSHUCKLE = createConditionObject(CONDITION_OUTFIT, #SKILL_AREAS * 500)
local ROLLING_OUTFIT_SHINYPHANPY = createConditionObject(CONDITION_OUTFIT, #SKILL_AREAS * 500)
local ROLLING_OUTFIT_SHINYDONPHAN = createConditionObject(CONDITION_OUTFIT, #SKILL_AREAS * 500)
local ROLLING_OUTFIT_SHINYMILTANK = createConditionObject(CONDITION_OUTFIT, #SKILL_AREAS * 500)

addOutfitCondition(ROLLING_OUTFIT_SANDSHREW, {lookType = 661})
addOutfitCondition(ROLLING_OUTFIT_SANDSLASH, {lookType = 662})
addOutfitCondition(ROLLING_OUTFIT_VOLTORB, {lookType = 663})
addOutfitCondition(ROLLING_OUTFIT_ELECTRODE, {lookType = 664})
addOutfitCondition(ROLLING_OUTFIT_GOLEM, {lookType = 665})
addOutfitCondition(ROLLING_OUTFIT_OMASTAR, {lookType = 946})
addOutfitCondition(ROLLING_OUTFIT_LICKITUNG, {lookType = 948})
addOutfitCondition(ROLLING_OUTFIT_SHUCKLE, {lookType = 1127})
addOutfitCondition(ROLLING_OUTFIT_PHANPY, {lookType = 1103})
addOutfitCondition(ROLLING_OUTFIT_DONPHAN, {lookType = 1104})
addOutfitCondition(ROLLING_OUTFIT_MILTANK, {lookType = 1105})
addOutfitCondition(ROLLING_OUTFIT_SHINYSANDSHREW, {lookType = 727})
addOutfitCondition(ROLLING_OUTFIT_SHINYSANDSLASH, {lookType = 728})
addOutfitCondition(ROLLING_OUTFIT_SHINYVOLTORB, {lookType = 799})
addOutfitCondition(ROLLING_OUTFIT_SHINYELECTRODE, {lookType = 881})
addOutfitCondition(ROLLING_OUTFIT_SHINYGOLEM, {lookType = 882})
addOutfitCondition(ROLLING_OUTFIT_SHINYOMASTAR, {lookType = 947})
addOutfitCondition(ROLLING_OUTFIT_SHINYLICKITUNG, {lookType = 949})
addOutfitCondition(ROLLING_OUTFIT_SHINYSHUCKLE, {lookType = 1702})
addOutfitCondition(ROLLING_OUTFIT_SHINYPHANPY, {lookType = 1691})
addOutfitCondition(ROLLING_OUTFIT_SHINYDONPHAN, {lookType = 1692})
addOutfitCondition(ROLLING_OUTFIT_SHINYMILTANK, {lookType = 1693})

local rolloutOutfits = {
	["Sandshrew"] = ROLLING_OUTFIT_SANDSHREW,
	["Sandslash"] = ROLLING_OUTFIT_SANDSLASH,
	["Voltorb"] = ROLLING_OUTFIT_VOLTORB,
	["Electrode"] = ROLLING_OUTFIT_ELECTRODE,
	["Golem"] = ROLLING_OUTFIT_GOLEM,
	["Omastar"] = ROLLING_OUTFIT_OMASTAR,
	["Lickitung"] = ROLLING_OUTFIT_LICKITUNG,
	["Shuckle"] = ROLLING_OUTFIT_SHUCKLE,
	["Phanpy"] = ROLLING_OUTFIT_PHANPY,
	["Donphan"] = ROLLING_OUTFIT_DONPHAN,
	["Miltank"] = ROLLING_OUTFIT_MILTANK,
	["Shiny Sandshrew"] = ROLLING_OUTFIT_SHINYSANDSHREW,
	["Shiny Sandslash"] = ROLLING_OUTFIT_SHINYSANDSLASH,
	["Shiny Voltorb"] = ROLLING_OUTFIT_SHINYVOLTORB,
	["Shiny Electrode"] = ROLLING_OUTFIT_SHINYELECTRODE,
	["Shiny Golem"] = ROLLING_OUTFIT_SHINYGOLEM,
	["Shiny Omastar"] = ROLLING_OUTFIT_SHINYOMASTAR,
	["Shiny Lickitung"] = ROLLING_OUTFIT_SHINYLICKITUNG,
  ["Shiny Shuckle"] = ROLLING_OUTFIT_SHINYSHUCKLE,
	["Shiny Phanpy"] = ROLLING_OUTFIT_SHINYPHANPY,
	["Shiny Donphan"] = ROLLING_OUTFIT_SHINYDONPHAN,
	["Shiny Miltank"] = ROLLING_OUTFIT_SHINYMILTANK,
}

local combats = {}
for i, skillArea in ipairs(SKILL_AREAS) do
	combats[i] = createCombatObject()
	onTargetCreature_Rollout = function(cid, target) doSkillDamage(cid, target, SKILL_NAME) end
	setCombatCallback(combats[i], CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Rollout")
	setCombatArea(combats[i], skillArea)
end

local function doSpell(cid, combat)
	if (isCreature(cid)) then
		doCombat(cid, combat, positionToVariant(getCreaturePosition(cid)))
	end
end

function onCastSpell(cid, var)
	local name = getPokemonReferenceName(cid)
	if (rolloutOutfits[name] and not hasCondition(cid, CONDITION_OUTFIT)) then
		doAddCondition(cid, rolloutOutfits[name])
	end
	doCreatureAddStatus(cid, CREATURE_STATUS_EXTRASPEED, nil, cid)
	for i, combat in ipairs(combats) do
		addEvent(doSpell, 500 * (i - 1) + 1, cid, combat)
	end
	return true
end
