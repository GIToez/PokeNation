-- local SKILL_NAME = "Mirror Move"
-- local DISABLED_MIMIC_MOVES = {"Metronome", "Sketch", "Struggle"}

function onTargetCreature_MirrorMove(cid, target)
	if (not isMonster(target)) then
        return
    end

    local move = getPokemonLastUsedMove(target)
    if (not move) then -- If the target has no last used move
        move = table.random(getPokemonDefaultSkills(getCreatureName(target)))
    end

    if (getPokemonSkillMimicable(move)) then
        callSkillFunction(cid, move)
    else
        doSendAnimatedText(getCreaturePosition(cid), "FAIL!", TEXTCOLOR_WHITE)
    end
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_MirrorMove")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end
