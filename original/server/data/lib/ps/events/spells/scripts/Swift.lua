local SKILL_NAME = "Swift"
local SKILL_DISTANCE = getPokemonSkillMaxDistance(SKILL_NAME)

function onTargetCreature_Swift(cid, target)
	local cidPos, targetPos, i = getCreaturePosition(cid), getCreaturePosition(target), 0
    for i = 0, SKILL_DISTANCE do
        addEvent(doSendDistanceShoot, 100 * i, cidPos, targetPos, PROJECTILE_STARS)
    end
    doSkillDamage(cid, target, SKILL_NAME)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Swift")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end
