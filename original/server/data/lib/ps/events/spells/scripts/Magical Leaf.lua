local SKILL_NAME = "Magical Leaf"

function onTargetCreature_MagicalLeaf(cid, target)
	local targetPos, i = getCreaturePosition(target)
    for i = 0, 7 do
        local tmpPos = {x = targetPos.x + getRandom(-3, 3), y = targetPos.y + getRandom(-3, 3), z = targetPos.z}
        doSendDistanceShoot(targetPos, tmpPos, PROJECTILE_COLORED_LEAVES)
        addEvent(doSendDistanceShoot, 100, tmpPos, targetPos, PROJECTILE_COLORED_LEAVES)
    end
    doSkillDamage(cid, target, SKILL_NAME)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_MagicalLeaf")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end
