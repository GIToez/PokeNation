local SKILL_NAME = "Revenge"

local function doSpell(cid, target, ticks)
	if (isCreature(cid) and isCreature(target)) then
		local cidPos, targetPos = getCreaturePosition(cid), getCreaturePosition(target)
		if (getSameFloor(cidPos, targetPos)) then
			doSendMagicEffect(cidPos, EFFECT_PURPLE_ENERGIZE)
			doSendAnimatedText(cidPos, "CHARGE", COLOR_DARKPURPLE)
			if (ticks > 0) then
				addEvent(doSpell, 500, cid, target, ticks - 1)
			else
				targetPos = getPositionAdjacent(cid, targetPos, false)
				if (targetPos) then
					doSendMagicEffect(cidPos, EFFECT_TELEPORT_FRAME)
					doTeleportThing(cid, targetPos, false)
					doSendMagicEffect(targetPos, EFFECT_TELEPORT_FRAME)
				end
				doSkillDamage(cid, target, SKILL_NAME)
			end
		end
	end
end

function onTargetCreature_Revenge(cid, target) doSpell(cid, target, 10) end
local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Revenge")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end
