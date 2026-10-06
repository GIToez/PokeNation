local SKILL_NAME = "Faint Attack"
local CUSTOM_EFFECT = EFFECT_ORDER_HAND

local function doSpell(cid, target)
    if (isCreature(cid) and isCreature(target)) then
        local cidPos, pos = getCreaturePosition(cid), getPositionAdjacent(cid, getCreaturePosition(target), false)
        if (pos) then
            doSendDistanceShoot(cidPos, pos, PROJECTILE_GRAVEL)
            doSendMagicEffect(cidPos, EFFECT_TELEPORT_FRAME)
            doTeleportThing(cid, pos, false)
            doSendMagicEffect(pos, EFFECT_TELEPORT_FRAME)
        end
        doSkillDamage(cid, target, SKILL_NAME)
    end
end

function onTargetCreature_FaintAttack(cid, target)
	doSendMagicEffect(getCreaturePosition(cid), CUSTOM_EFFECT)
    addEvent(doSpell, 300, cid, target)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_FaintAttack")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end
