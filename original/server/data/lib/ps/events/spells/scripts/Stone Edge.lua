local SKILL_NAME = "Stone Edge"
local PROJECTILE = getPokemonSkillProjectile(SKILL_NAME)
local EFFECT = getPokemonSkillEffect(SKILL_NAME)

function onTargetCreature_StoneEdge(cid, target)
    local pos, targetPos = getCreaturePosition(cid), getCreaturePosition(target)
    for i = 0, 7 do
        local tmpPos = {x = targetPos.x + getRandom(-2, 2), y = targetPos.y + getRandom(-2, 2), z = targetPos.z}
        doSendDistanceShoot(pos, tmpPos, PROJECTILE)
        addEvent(doSendMagicEffect, 250, tmpPos, EFFECT)
    end
	doSkillDamage(cid, target, SKILL_NAME)
end
local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_StoneEdge")

local function doSpell(cid)
    if (isCreature(cid) and hasTarget(cid)) then
        doCombat(cid, combat, numberToVariant(getCreatureTarget(cid)))
    end
end

function onCastSpell(cid, var)
	executeInArea(getCreaturePosition(cid), AREA_SQUARE1X1, doSendMagicEffect, EFFECT_BIG_ROCK_EMERGE)
    addEvent(doSpell, 500, cid)
    return true
end
