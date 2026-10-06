local SKILL_NAME = "Giga Impact"
local SKILL_AREAS = {
	createCombatArea(AREA_SQUARE1X1),
	createCombatArea(AREA_SQUARE2X2_EMPTY)
}

local combats = {}
for i, skillArea in ipairs(SKILL_AREAS) do
	combats[i] = createCombatObject()
	onTargetCreature_GigaImpact = function(cid, target) doSkillDamage(cid, target, SKILL_NAME) end
	setCombatCallback(combats[i], CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_GigaImpact")
	setCombatParam(combats[i], COMBAT_PARAM_EFFECT, getPokemonSkillAreaEffect(SKILL_NAME))
	setCombatArea(combats[i], skillArea)
end

local function doSpell(cid, combat, var)
	if (isCreature(cid)) then
		doCombat(cid, combat, var)
	end
end

function onCastSpell(cid, var)
    doSendMagicEffect(getCreaturePosition(cid), EFFECT_EARTH_EXPLOSION_REVERSAL)
	for i, combat in ipairs(combats) do
		addEvent(doSpell, 500 * (i - 1) + 1, cid, combat, var)
    end
    doCreatureAddStatus(cid, CREATURE_STATUS_RECHARGE, nil, cid)
	return true
end
