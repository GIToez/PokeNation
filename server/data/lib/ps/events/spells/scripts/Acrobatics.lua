local SKILL_NAME = "Acrobatics"
local PROJECTILE = getPokemonSkillProjectile(SKILL_NAME)
local EFFECT = getPokemonSkillEffect(SKILL_NAME)

local function doEffect(pos)
    doSendDistanceShoot(getSkyPosition(pos), pos, PROJECTILE)
    addEvent(doSendMagicEffect, 250, pos, EFFECT)
end

function onTargetCreature_Acrobatics(cid, target)
	local pos, targetPos = getCreaturePosition(cid), getPositionAdjacent(cid, getCreaturePosition(target), false)
    if (targetPos) then
        doSendMagicEffect(pos, EFFECT_TELEPORT_FRAME)
        doTeleportThing(cid, targetPos, false)
        doSendMagicEffect(targetPos, EFFECT_TELEPORT_FRAME)
        for i = 0, 7 do
            doEffect({x = targetPos.x + getRandom(-2, 2), y = targetPos.y + getRandom(-2, 2), z = targetPos.z})
        end
    end
	doSkillDamage(cid, target, SKILL_NAME)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Acrobatics")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end
