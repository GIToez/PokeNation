local SKILL_NAME = "Nightmare"

local function doSpell(cid, target, ticks)
	if(isCreature(cid) and isCreature(target)) then
		doSkillDamage(cid, target, SKILL_NAME)
		if (ticks > 0) then
			addEvent(doSpell, 1000, cid, target, ticks - 1)
		end
	end
end

function onTargetCreature_Nightmare(cid, target) doSpell(cid, target, 5) end
local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Nightmare")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end
