local SKILL_NAME = "Psycho Cut"
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

local combats = {}
for i, skillArea in ipairs(SKILL_AREAS) do
	combats[i] = createCombatObject()
	onTargetCreature_PsychoCut = function(cid, target)
		doSkillDamage(cid, target, SKILL_NAME)
	end
	setCombatCallback(combats[i], CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_PsychoCut")
	setCombatArea(combats[i], skillArea)
end

local function doSpell(cid, combat)
	if (isCreature(cid)) then
		doSendMagicEffect(getCreaturePosition(cid), EFFECT_TELEPORT_FRAME)
		doCombat(cid, combat, positionToVariant(getCreaturePosition(cid)))
	end
end

function onCastSpell(cid, var)
	for i, combat in ipairs(combats) do
		addEvent(doSpell, 500 * (i - 1) + 1, cid, combat)
	end
	return true
end
