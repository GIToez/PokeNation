local SKILL_NAME = "Psystrike"
local SKILL_AREAS = {
	createCombatArea(AREA_CIRCLE3X3)
}

local combats = {}
for i, skillArea in ipairs(SKILL_AREAS) do
	combats[i] = createCombatObject()
	onTargetCreature_Psystrike = function(cid, target)
		doSkillDamage(cid, target, SKILL_NAME)
    end
	onTargetTile_Psystrike = function(cid, position)
        addEvent(doSendMagicEffect, getRandom(1, 1000), position, EFFECT_BIG_PURPLE_PULSE)
    end
	setCombatCallback(combats[i], CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Psystrike")
	setCombatCallback(combats[i], CALLBACK_PARAM_TARGETTILE, "onTargetTile_Psystrike")
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