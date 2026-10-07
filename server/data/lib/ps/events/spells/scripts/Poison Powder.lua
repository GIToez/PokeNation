local SKILL_NAME = "Poison Powder"
local SKILL_AREAS = {
	createCombatArea(AREA_CIRCLE3X3)
}
local AREA_EFFECT = getPokemonSkillAreaEffect(SKILL_NAME)

local combats = {}
for i, skillArea in ipairs(SKILL_AREAS) do
	combats[i] = createCombatObject()
	onTargetCreature_PoisonPowder = function(cid, target)
		doCreatureAddStatus(target, CREATURE_STATUS_POISON, getMonsterLevel(cid), cid)
	end
	onTargetTile_PoisonPowder = function(cid, position)
		addEvent(doSendMagicEffect, getRandom(1, 300), position, AREA_EFFECT)
	end
	setCombatCallback(combats[i], CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_PoisonPowder")
	setCombatCallback(combats[i], CALLBACK_PARAM_TARGETTILE, "onTargetTile_PoisonPowder")
	--setCombatParam(combats[i], COMBAT_PARAM_EFFECT, getPokemonSkillAreaEffect(SKILL_NAME))
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
