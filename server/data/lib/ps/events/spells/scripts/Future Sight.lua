local SKILL_NAME = "Future Sight"

local function doAttack(cid, target)
    if (isCreature(cid) and isCreature(target)) then
        doSkillDamage(cid, target, SKILL_NAME)
    end
end

function onTargetCreature_FutureSight(cid, target)
	addEvent(doAttack, 4000, cid, target)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_FutureSight")
function onCastSpell(cid, var)
	doSendMagicEffect(getCreaturePosition(cid), EFFECT_BIG_ENIGMA_BALL)
    return doCombat(cid, combat, var)
end
