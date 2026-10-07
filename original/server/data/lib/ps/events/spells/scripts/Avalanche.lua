local SKILL_NAME = "Avalanche"
local SKILL_AREAS = {
	createCombatArea(AREA_SQUARE1X1)
}

local combats = {}
for i, skillArea in ipairs(SKILL_AREAS) do
	combats[i] = createCombatObject()
	onTargetCreature_Avalanche = function(cid, target)
		doSkillDamage(cid, target, SKILL_NAME)
	end
	setCombatCallback(combats[i], CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Avalanche")
	setCombatParam(combats[i], COMBAT_PARAM_EFFECT, getPokemonSkillEffect(SKILL_NAME))
	setCombatArea(combats[i], skillArea)
end

local function doSpell(cid, combat, var)
	if (isCreature(cid)) then
		doCombat(cid, combat, var)
	end
end

function onTargetCreature_Avalanche(cid, target)
	local var, i, combat = positionToVariant(getCreaturePosition(target))
	for i, combat in ipairs(combats) do
		addEvent(doSpell, 500 * (i - 1) + 1, cid, combat, var)
	end
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Avalanche")
function onCastSpell(cid, var)
	doSendMagicEffect(getCreaturePosition(cid), EFFECT_ICE_CRYSTAL_EMERGE)
	return doCombat(cid, combat, var)
end
