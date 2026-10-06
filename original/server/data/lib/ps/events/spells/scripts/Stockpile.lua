local SKILL_NAME = "Stockpile"

function onTargetCreature_Stockpile(cid, target)
    doCreatureAddStatus(cid, CREATURE_STATUS_EXTRASPDEF, CREATURE_STATUS_VAR_LOW, cid)

    local newCondition, oldCondition

    if (getCreatureStatus(cid, CREATURE_STATUS_STOCKPILE_CHARGE2)) then
        newCondition = CREATURE_STATUS_STOCKPILE_CHARGE3
        oldCondition = CREATURE_STATUS_STOCKPILE_CHARGE2
    elseif (getCreatureStatus(cid, CREATURE_STATUS_STOCKPILE_CHARGE1)) then
        newCondition = CREATURE_STATUS_STOCKPILE_CHARGE2
        oldCondition = CREATURE_STATUS_STOCKPILE_CHARGE1
    elseif (not getCreatureStatus(cid, CREATURE_STATUS_STOCKPILE_CHARGE3)) then
        newCondition = CREATURE_STATUS_STOCKPILE_CHARGE1
    end

    if (newCondition) then
        if (oldCondition) then
            doCreatureRemoveStatus(cid, oldCondition)
        end
        doCreatureAddStatus(cid, newCondition, nil, cid)
    else
        doSendAnimatedText(getCreaturePosition(cid), "FAIL", TEXTCOLOR_WHITE)
    end
end

local combat = createCombatObject()
setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Stockpile")
setCombatParam(combat, COMBAT_PARAM_EFFECT, getPokemonSkillEffect(SKILL_NAME))
setCombatParam(combat, COMBAT_PARAM_AGGRESSIVE, false)

function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end
