local SKILL_NAME = "Incinerate"
local SKILL_AREAS = {
	createCombatArea(AREA_SQUARE1X1)
}

local combats = {}
for i, skillArea in ipairs(SKILL_AREAS) do
	combats[i] = createCombatObject()
	onTargetCreature_Incinerate = function(cid, target)
		doSkillDamage(cid, target, SKILL_NAME)
	end
	setCombatCallback(combats[i], CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Incinerate")
	setCombatParam(combats[i], COMBAT_PARAM_EFFECT, getPokemonSkillEffect(SKILL_NAME))
	setCombatParam(combats[i], COMBAT_PARAM_DISTANCEEFFECT, PROJECTILE_FIRE)
	setCombatArea(combats[i], skillArea)
end

local function doSpell(cid, combat, var)
	if (isCreature(cid)) then
		doCombat(cid, combat, var)
	end
end

function onTargetCreature_Incinerate(cid, target)
	local var, i, combat = positionToVariant(getCreaturePosition(target))
	for i, combat in ipairs(combats) do
		addEvent(doSpell, 500 * (i - 1) + 1, cid, combat, var)
	end
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Incinerate")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end