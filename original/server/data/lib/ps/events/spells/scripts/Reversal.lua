local SKILL_NAME = "Reversal"

function onTargetCreature_Reversal(cid, target)
	local cidPos, pos, power, health = getCreaturePosition(cid), getCreaturePosition(target), 20,
        math.ceil(getCreatureHealth(target) / (getCreatureMaxHealth(target) / 100))

    if (health < 4) then
        power = 200
    elseif (health < 10) then
        power = 150
    elseif (health < 20) then
        power = 100
    elseif (health < 35) then
        power = 80
    elseif (health < 70) then
        power = 40
    end

    doSendMagicEffect(cidPos, EFFECT_BLUE_CIRCLE_TWO)
    doTeleportThing(target, cidPos, false)
    doSendMagicEffect(pos, EFFECT_BLUE_CIRCLE_TWO)
    if (isWalkable(cid, pos)) then
        doTeleportThing(cid, pos, false)
    end
	doSkillDamage(cid, target, SKILL_NAME, power)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Reversal")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end
