local SKILL_NAME = "Rage Powder"
local SKILL_AREAS = {
	createCombatArea(AREA_CROSS5X5)
}

local combats = {}
for i, skillArea in ipairs(SKILL_AREAS) do
	combats[i] = createCombatObject()
	onTargetCreature_AngerPowder = function(cid, target) doMonsterSetTarget(target, cid) end
	setCombatCallback(combats[i], CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_AngerPowder")
	setCombatParam(combats[i], COMBAT_PARAM_EFFECT, getPokemonSkillAreaEffect(SKILL_NAME))
	setCombatArea(combats[i], skillArea)
end

local function doSpell(cid, combat, var)
	if (isCreature(cid)) then
		doCombat(cid, combat, var)
	end
end

function onCastSpell(cid, var)
	doSendMagicEffect(getCreaturePosition(cid), EFFECT_ORDER_HAND)
    local i, combat
	for i, combat in ipairs(combats) do
		addEvent(doSpell, 500 * (i - 1) + 1, cid, combat, var)
    end
	return true
end