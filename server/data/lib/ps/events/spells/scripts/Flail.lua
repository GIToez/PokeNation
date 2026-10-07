local SKILL_NAME = "Flail"

function onTargetCreature_Flail(cid, target)
    local cidPos, pos, power, health = getCreaturePosition(cid), getCreaturePosition(target), 20, math.ceil(getCreatureHealth(cid) / (getCreatureMaxHealth(cid) / 100))

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

    doSkillDamage(cid, target, SKILL_NAME, power)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Flail")
function onCastSpell(cid, var)
    return doCombat(cid, combat, var)
end
