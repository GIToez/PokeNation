local SKILL_NAME = "Smoke Screen"
local SKILL_AREAS = {
	createCombatArea(AREA_CIRCLE2X2)
}
local SKILL_PROJECTILE = getPokemonSkillProjectile(SKILL_NAME)

local combats = {}
for i, skillArea in ipairs(SKILL_AREAS) do
	combats[i] = createCombatObject()
	onTargetCreature_SmokeScreen = function(cid, target) doCreatureAddStatus(target, CREATURE_STATUS_LOWACCURACY, nil, cid) end
	onTargetTile_SmokeScreen = function(cid, position)
		if (math.random(0, 1) == 1) then
		    doSendDistanceShoot(getCreaturePosition(cid), position, SKILL_PROJECTILE)
        end
	end
	setCombatCallback(combats[i], CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_SmokeScreen")
    setCombatCallback(combats[i], CALLBACK_PARAM_TARGETTILE, "onTargetTile_SmokeScreen")
	setCombatParam(combats[i], COMBAT_PARAM_EFFECT, getPokemonSkillAreaEffect(SKILL_NAME))
	setCombatArea(combats[i], skillArea)
end

local function doSpell(cid, combat, var)
	if (isCreature(cid)) then
		doCombat(cid, combat, var)
	end
end

function onTargetCreature_SmokeScreen(cid, target)
	local var, i, combat = positionToVariant(getCreaturePosition(target))
	for i, combat in ipairs(combats) do
		addEvent(doSpell, 500 * (i - 1) + 1, cid, combat, var)
    end
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_SmokeScreen")
setCombatParam(combat, COMBAT_PARAM_DISTANCEEFFECT, SKILL_PROJECTILE)
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end