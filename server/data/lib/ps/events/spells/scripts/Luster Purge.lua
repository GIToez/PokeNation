local SKILL_NAME = "Luster Purge"
local HALF_POWER = math.floor(getPokemonSkillDamage(SKILL_NAME) / 2)

function onTargetCreature_LusterPurge(cid, target) doSkillDamage(cid, target, SKILL_NAME) end

local combat = createCombatObject()
setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_LusterPurge")
setCombatArea(combat, createCombatArea({ { 1 } }))

function onTargetCreature_LusterPurgeHalf(cid, target)
    doSkillDamage(cid, target, SKILL_NAME, HALF_POWER)
end

function onTargetTile_LusterPurgeHalf(cid, pos)
    addEvent(doSendDistanceShoot, getRandom(1, 300), getCreaturePosition(cid), pos, PROJECTILE_BUBBLES)
end

local combatEffect = createCombatObject()
setCombatArea(combatEffect, createCombatArea({ { 1, 2, 1 } }))
setCombatCallback(combatEffect, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_LusterPurgeHalf")
setCombatCallback(combatEffect, CALLBACK_PARAM_TARGETTILE, "onTargetTile_LusterPurgeHalf")

local function doSpell(cid, toDirection, lastPosition, ticks)
    if (isCreature(cid)) then
        doSendMagicEffect(lastPosition, getPokemonSkillEffect(SKILL_NAME))
        doCombat(cid, combat, positionToVariant(lastPosition))
        doCombat(cid, combatEffect, positionToVariant(lastPosition))
        if (ticks > 0) then
            doSpell(cid, toDirection, lastPosition, ticks - 1)
        end
    end
end

function onCastSpell(cid, var)
    doSpell(cid, getCreatureLookDirection(cid), getCreaturePosition(cid), 7)
    return true
end
