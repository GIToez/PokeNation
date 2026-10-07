local SKILL_NAME = "Whirlpool"
local SKILL_AREAS = {
	createCombatArea(AREA_SQUARE1X1),
	createCombatArea(AREA_CIRCLE2X2_EMPTY),
	createCombatArea(AREA_CIRCLE3X3_EMPTY)
}

local combats = {}
for i, skillArea in ipairs(SKILL_AREAS) do
	combats[i] = createCombatObject()
	onTargetCreature_Whirlpool = function(cid, target)
		doSkillDamage(cid, target, SKILL_NAME)
	end
	setCombatCallback(combats[i], CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Whirlpool")
	setCombatParam(combats[i], COMBAT_PARAM_EFFECT, getPokemonSkillEffect(SKILL_NAME))
	setCombatArea(combats[i], skillArea)
end

local function doSpell(cid, combat, var)
	if (isCreature(cid)) then
		doCombat(cid, combat, var)
	end
end

function onCastSpell(cid, var)
	for i, combat in ipairs(combats) do
		addEvent(doSpell, 250 * (i - 1) + 1, cid, combat, var)
	end
	return true
end