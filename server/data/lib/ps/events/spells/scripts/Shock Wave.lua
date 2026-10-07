local SKILL_NAME = "Shock Wave"
local PROJECTILE = getPokemonSkillProjectile(SKILL_NAME)
local EFFECT = getPokemonSkillEffect(SKILL_NAME)

function onTargetCreature_ShockWave(cid, target)
	doSkillDamage(cid, target, SKILL_NAME)
end
local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_ShockWave")

local function doSpell(cid, target)
    if (isCreature(cid) and isCreature(target)) then
        local pos, targetPos = getCreaturePosition(cid), getCreaturePosition(target)
        for i = 0, 7 do
            addEvent(doSendDistanceShoot, i * 100, pos, targetPos, PROJECTILE)
        end
        addEvent(doSendMagicEffect, 7 * 100, targetPos, EFFECT)
        doCombat(cid, combat, numberToVariant(target))
    end
end

function onCastSpell(cid, var)
    local pos = getCreaturePosition(cid)
	for i = 0, 7 do
        addEvent(doSendDistanceShoot, i * 100, {x = pos.x + getRandom(-7, 7), y = pos.y + getRandom(-7, 7), z = pos.z},
            pos, PROJECTILE)
    end
    addEvent(doSendMagicEffect, 7 * 100, pos, EFFECT)
    addEvent(doSpell, 500, cid, variantToNumber(var))
    return true
end
