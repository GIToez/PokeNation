-- local SKILL_NAME = "Metal Burst"
--local DISABLED_MetalBurst_MOVES = {"Metronome", "Sketch", "Struggle"}

function onTargetCreature_MetalBurst(cid, target)
	if (not isMonster(target)) then
		return
	end

	local move = getPokemonLastUsedMove(target)
	if (not move) then -- If the target has no last used move
		move = table.random(getPokemonDefaultSkills(getCreatureName(target)))
	end

	if (getPokemonSkillMimicable(move) and getPokemonSkillDamage(move) > 0) then
		doSkillDamage(cid, target, move, getPokemonSkillDamage(move) * 1.5)
	else
		doSendAnimatedText(getCreaturePosition(cid), "FAIL!", TEXTCOLOR_WHITE)
	end
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_MetalBurst")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end
