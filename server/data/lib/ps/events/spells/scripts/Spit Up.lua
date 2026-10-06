local SKILL_NAME = "Spit Up"
local BULLETS = 4

function onTargetCreature_SpitUp(cid, target)
    local power = 0
    if (getCreatureStatus(cid, CREATURE_STATUS_STOCKPILE_CHARGE3)) then
        power = 300 / BULLETS
        doCreatureRemoveStatus(cid, CREATURE_STATUS_STOCKPILE_CHARGE3)

    elseif (getCreatureStatus(cid, CREATURE_STATUS_STOCKPILE_CHARGE2)) then
        power = 200 / BULLETS
        doCreatureRemoveStatus(cid, CREATURE_STATUS_STOCKPILE_CHARGE2)

    elseif (getCreatureStatus(cid, CREATURE_STATUS_STOCKPILE_CHARGE1)) then
        power = 100 / BULLETS
        doCreatureRemoveStatus(cid, CREATURE_STATUS_STOCKPILE_CHARGE1)
    end

    if (power > 0) then
        doSkillMultipleDamages(cid, SKILL_NAME, BULLETS, power)
    else
        doSendAnimatedText(getCreaturePosition(cid), "FAIL", TEXTCOLOR_WHITE)
    end
end

local combat = createCombatObject()
setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_SpitUp")

function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end
