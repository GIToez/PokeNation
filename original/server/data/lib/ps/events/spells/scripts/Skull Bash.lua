local SKILL_NAME = "Skull Bash"

local function doAttack(cid, target)
    if (isCreature(cid) and isCreature(target)) then
        doSkillDamage(cid, target, SKILL_NAME)
    end
end

function onTargetCreature_SkullBash(cid, target)
	doSendMagicEffect(getCreaturePosition(cid), EFFECT_GRAY_BUFF)
    doCreatureAddStatus(cid, CREATURE_STATUS_EXTRASPDEF, CREATURE_STATUS_VAR_LOW)
    addEvent(doAttack, 2000, cid, target)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_SkullBash")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end
