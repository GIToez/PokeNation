local SKILL_NAME = "Spite"

function onTargetCreature_Spite(cid, target)
	local master, energy = getCreatureMaster(target), math.random(100, 200)
	if (master ~= target) then
		energy = math.ceil(getCreatureMana(master) / 10)
	end
	doSkillDamage(cid, target, SKILL_NAME)
	doCreatureAddMana(master, -energy, false)
	doCreatureAddMana(getCreatureMaster(cid), energy, false)
	doSendAnimatedText(getCreaturePosition(target), "-" .. energy, COLOR_RED)
	doSendAnimatedText(getCreaturePosition(cid), "+" .. energy, COLOR_PURPLE)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Spite")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end
