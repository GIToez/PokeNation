-- local SKILL_NAME = "Feather Dance"

function onTargetCreature_FeatherDance(cid, target)
    for i = 0, 3 do
        addEvent(function(target)
            if (not isCreature(target)) then return end
            local targetPos = getCreaturePosition(target)
            for j = 0, 7 do
                doSendDistanceShoot({x = targetPos.x + getRandom(-7, 7), y = targetPos.y + getRandom(-5, 5),
                    z = targetPos.z}, targetPos, PROJECTILE_RED_FEATHERS)
            end
        end, 100 * i, target)
    end
    doCreatureAddStatus(target, CREATURE_STATUS_EXTRASPATK, CREATURE_STATUS_VAR_BADMEDIUM, cid)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_FeatherDance")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end
