local SKILL_NAME = "Flare Blitz"
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
	onTargetCreature_FlareBlitz = function(cid, target) doSkillDamage(cid, target, SKILL_NAME) end
	onTargetTile_FlareBlitz = function(cid, position) doSendMagicEffect(position, AREA_EFFECT) end
	setCombatCallback(combats[i], CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_FlareBlitz")
	setCombatCallback(combats[i], CALLBACK_PARAM_TARGETTILE, "onTargetTile_FlareBlitz")
	setCombatArea(combats[i], skillArea)
end

local function doSpell(cid, combat)
	if (isCreature(cid)) then
		doCombat(cid, combat, positionToVariant(getCreaturePosition(cid)))
	end
end

function onCastSpell(cid, var)
	doCreatureRemoveStatus(cid, CREATURE_STATUS_FREEZE)
	for i, combat in ipairs(combats) do
		addEvent(doSpell, 500 * (i - 1) + 1, cid, combat)
	end
	return true
end
