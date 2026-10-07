local SKILL_NAME = "Psyshock"
local INTERVAL = 500
local PROJECTILE = getPokemonSkillProjectile(SKILL_NAME)
local EFFECT = getPokemonSkillEffect(SKILL_NAME)
local ROUNDS = 3

function onTargetCreature_Psyshock(cid, target)
    doSkillDamage(cid, target, SKILL_NAME, getPokemonSkillDamage(SKILL_NAME) / ROUNDS)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Psyshock")

local function doEffect(cid, targetPos)
    if (isCreature(cid)) then
        local pos = getCreaturePosition(cid)
        local tmpPos = { x = targetPos.x + getRandom(-1, 1), y = targetPos.y + getRandom(-1, 1), z = targetPos.z }
        doSendDistanceShoot(pos, tmpPos, PROJECTILE)
        addEvent(doSendMagicEffect, 150, tmpPos, EFFECT)
    end
end

local function doSpell(cid, ticks)
    if (isCreature(cid) and hasTarget(cid)) then
        local target = getCreatureTarget(cid)

        local targetPos = getCreaturePosition(target)
        for i = 0, 7 do
            addEvent(doEffect, i * 250, cid, targetPos)
        end

        doCombat(cid, combat, numberToVariant(target))

        if (ticks > 0) then
            addEvent(doSpell, INTERVAL, cid, ticks - 1)
        end
    end
end

function onCastSpell(cid, var)
    doSpell(cid, ROUNDS)
    return true
end
