local SKILL_NAME = "Dragon Pulse"
local PROJECTILE = getPokemonSkillProjectile(SKILL_NAME)
local EFFECT = getPokemonSkillEffect(SKILL_NAME)
local SKILL_AREAS = {
	createCombatArea(AREA_SQUARE1X1),
	createCombatArea(AREA_CIRCLE2X2_EMPTY_NOCENTER),
	createCombatArea(AREA_CIRCLE3X3_EMPTY_NOCENTER)
}

local combats = {}
for i, skillArea in ipairs(SKILL_AREAS) do
	combats[i] = createCombatObject()
	onTargetCreature_DragonPulse = function(cid, target)
		doSkillDamage(cid, target, SKILL_NAME)
	end
	setCombatCallback(combats[i], CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_DragonPulse")
    setCombatParam(combats[i], COMBAT_PARAM_EFFECT, EFFECT)
	setCombatArea(combats[i], skillArea)
end

local function doSpell(cid, combat, var)
    if (isCreature(cid)) then
		doCombat(cid, combat, var)
	end
end

function onTargetCreature_DragonPulse(cid, target)
	local targetPos = getCreaturePosition(target)
    doSendDistanceShoot(getCreaturePosition(cid), targetPos, PROJECTILE)

    local var = positionToVariant(targetPos)
	for i, combat in ipairs(combats) do
		addEvent(doSpell, 300 * (i - 1) + 1, cid, combat, var)
	end
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_DragonPulse")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end
