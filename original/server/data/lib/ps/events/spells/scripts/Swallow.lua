local SKILL_NAME = "Swallow"

function onTargetCreature_Swallow(cid, target)
    local stocks = 0
    if (getCreatureStatus(cid, CREATURE_STATUS_STOCKPILE_CHARGE3)) then
        stocks = 1
        doCreatureRemoveStatus(cid, CREATURE_STATUS_STOCKPILE_CHARGE3)

    elseif (getCreatureStatus(cid, CREATURE_STATUS_STOCKPILE_CHARGE2)) then
        stocks = 0.5
        doCreatureRemoveStatus(cid, CREATURE_STATUS_STOCKPILE_CHARGE2)

    elseif (getCreatureStatus(cid, CREATURE_STATUS_STOCKPILE_CHARGE1)) then
        stocks = 0.25
        doCreatureRemoveStatus(cid, CREATURE_STATUS_STOCKPILE_CHARGE1)
    end

    if (stocks > 0) then
	    doCreatureAddHealth(cid, getCreatureMaxHealth(cid) * stocks)
    else
        doSendAnimatedText(getCreaturePosition(cid), "FAIL", TEXTCOLOR_WHITE)
    end
end

local combat = createCombatObject()
setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Swallow")
setCombatParam(combat, COMBAT_PARAM_EFFECT, getPokemonSkillEffect(SKILL_NAME))
setCombatParam(combat, COMBAT_PARAM_AGGRESSIVE, false)

function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end
