local SKILL_NAME = "Rock Throw"

function onTargetCreature_RockThrow(cid, target)
	doSkillDamage(cid, target, SKILL_NAME)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_RockThrow")
local function doSpell(cid, target)
    if (isCreature(cid) and isCreature(target)) then
        local pos = getCreaturePosition(target)
        doSendDistanceShoot(getSkyPosition(pos), pos, PROJECTILE_ROCK)
        doCombat(cid, combat, numberToVariant(target))
    end
end

function onCastSpell(cid, var)
	local pos = getCreaturePosition(cid)
    doSendDistanceShoot(pos, getSkyPosition(pos), PROJECTILE_ROCK)
    addEvent(doSpell, 500, cid, variantToNumber(var))
    return true
end
