local SKILL_NAME = "Ancient Power"
local SKILL_AREAS = {
	createCombatArea(AREA_SQUARE1X1)
}

local combats = {}
for i, skillArea in ipairs(SKILL_AREAS) do
	combats[i] = createCombatObject()
	onTargetCreature_AncientPower = function(cid, target)
		doSkillDamage(cid, target, SKILL_NAME)
	end
	setCombatCallback(combats[i], CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_AncientPower")
	setCombatParam(combats[i], COMBAT_PARAM_EFFECT, getPokemonSkillEffect(SKILL_NAME))
	setCombatArea(combats[i], skillArea)
end

local function doSpell(cid, combat, var)
	if (isCreature(cid)) then
		doCombat(cid, combat, var)
	end
end

function onTargetCreature_AncientPower(cid, target)
	--doSkillDamage(cid, target, SKILL_NAME)
	local var, i, combat = positionToVariant(getCreaturePosition(target))
	for i, combat in ipairs(combats) do
		addEvent(doSpell, 500 * (i - 1) + 1, cid, combat, var)
	end
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_AncientPower")
function onCastSpell(cid, var)
	if (getRandom(0, 100) <= 10) then
        doCreatureAddStatus(cid, CREATURE_STATUS_EXTRASPDEF, CREATURE_STATUS_VAR_LOW, cid)
        doCreatureAddStatus(cid, CREATURE_STATUS_EXTRASPATK, CREATURE_STATUS_VAR_LOW, cid)
        doCreatureAddStatus(cid, CREATURE_STATUS_EXTRASPEED, nil, cid)
    end
    doSendMagicEffect(getCreaturePosition(cid), EFFECT_BIG_ENIGMA_BALL)
    return doCombat(cid, combat, var)
end
