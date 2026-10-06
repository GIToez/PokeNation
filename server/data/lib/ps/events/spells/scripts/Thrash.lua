local SKILL_NAME = "Thrash"

local function doEffect(target)
    if (isCreature(target)) then
        local pos = getCreaturePosition(target)
        doSendMagicEffect(pos, EFFECT_KICK)
        doSendMagicEffect(pos, EFFECT_PUNCH)
    end
end

function onTargetCreature_Thrash(cid, target)
	local random = getRandom(2, 3)
    for i = 0, random do
        addEvent(doEffect, i * 500, target)
    end
    doSkillMultipleDamages(cid, SKILL_NAME, random)
    addEvent(doCreatureAddStatus, random * 500, cid, CREATURE_STATUS_CONFUSION, nil, cid)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Thrash")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end