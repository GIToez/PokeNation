local SKILL_NAME = "Magnitude"
local SKILL_AREAS = {
	createCombatArea(AREA_SQUARE1X1),
	createCombatArea(AREA_CIRCLE2X2_EMPTY),
	createCombatArea(AREA_CIRCLE3X3_EMPTY)
}
local POWER_BY_MAGNITUDE = {
    [4] = 10,
    [5] = 30,
    [6] = 50,
    [7] = 70,
    [8] = 90,
    [9] = 110,
    [10] = 150
}

local combats = {}
for i, skillArea in ipairs(SKILL_AREAS) do
	combats[i] = createCombatObject()
	onTargetCreature_Magnitude = function(cid, target)
        doSkillDamage(cid, target, SKILL_NAME, POWER_BY_MAGNITUDE[getRandom(4, 10)])
    end
	setCombatCallback(combats[i], CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Magnitude")
	setCombatParam(combats[i], COMBAT_PARAM_EFFECT, getPokemonSkillAreaEffect(SKILL_NAME))
	setCombatArea(combats[i], skillArea)
end

local function doSpell(cid, combat, var)
	if (isCreature(cid)) then
		doCombat(cid, combat, var)
	end
end

function onCastSpell(cid, var)
	for i, combat in ipairs(combats) do
		addEvent(doSpell, 500 * (i - 1) + 1, cid, combat, var)
	end
	return true
end
