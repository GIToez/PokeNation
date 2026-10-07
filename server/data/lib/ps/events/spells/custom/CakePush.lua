local SKILL_DISTANCE = 6

function onTargetCreature_Cake(cid, target)
	local cidPos, targetPos, i = getCreaturePosition(cid), getCreaturePosition(target), 0
	for i = 0, SKILL_DISTANCE do
		addEvent(doSendDistanceShoot, 100 * (i - 1), cidPos, targetPos, PROJECTILE_CAKE)
	end

	local dir = getDirectionTo(cidPos, targetPos)
	local newPos = getPositionByDirection(targetPos, dir, 1)
	if (isWalkable(target, newPos)) then
		doTeleportThing(target, newPos, true)
	end
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Cake")
setCombatParam(combat, COMBAT_PARAM_DISTANCEEFFECT, PROJECTILE_CAKE)
setCombatParam(combat, COMBAT_PARAM_HITEFFECT, EFFECT_CAKE)
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end