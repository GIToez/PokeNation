local SKILL_AREAS = {
	createCombatArea(AREA_CIRCLE3X3)
}
local SKILL_PROJECTILE = PROJECTILE_CAKE

local combats = {}
for i, skillArea in ipairs(SKILL_AREAS) do
	combats[i] = createCombatObject()
	onTargetCreature_Cake = function(cid, target)
		local master = getCreatureMaster(target)
		if (isPlayer(master)) then
			doPlayerUseBallOnSlot(master)
		end
	end
	onTargetTile_Cake = function(cid, position)
		if (math.random(0, 1) == 1) then
			doSendDistanceShoot(getCreaturePosition(cid), position, SKILL_PROJECTILE)
			addEvent(doSendMagicEffect, 150, position, EFFECT_CAKE)
		end
	end
	setCombatCallback(combats[i], CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Cake")
	setCombatCallback(combats[i], CALLBACK_PARAM_TARGETTILE, "onTargetTile_Cake")
	setCombatParam(combats[i], COMBAT_PARAM_EFFECT, EFFECT_CAKE)
	setCombatArea(combats[i], skillArea)
end

local function doSpell(cid, combat, var)
	if (isCreature(cid)) then
		doCombat(cid, combat, var)
	end
end

local function doSpells(cid, var)
	for i, combat in ipairs(combats) do
		addEvent(doSpell, 500 * (i - 1) + 1, cid, combat, var)
	end
end

function onCastSpell(cid, var)
	local pos, i = getCreaturePosition(cid)
	for i = 1, 5 do
		if (i < 5) then
			addEvent(doSendDistanceShoot, 150 * (i - 1) + 1, pos, getSkyPosition(pos), SKILL_PROJECTILE)
		else
			addEvent(doSpells, 150 * (i - 1) + 1, cid, var)
		end
	end
	return true
end