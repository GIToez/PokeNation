local SKILL_NAME = "Defog"

function onTargetCreature_Defog(cid, target)
    if (getCreatureStatus(target, CREATURE_STATUS_REFLECT)) then
        doCreatureRemoveStatus(target, CREATURE_STATUS_REFLECT)
    end
end

local combat = createCombatObject()
setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Defog")
setCombatArea(combat, createCombatArea({ { 1 } }))

local function doSpell(cid, toDirection, lastPosition, ticks)
    if (isCreature(cid)) then
        doCombat(cid, combat, positionToVariant(lastPosition))
        doSendMagicEffect(lastPosition, getPokemonSkillEffect(SKILL_NAME))
        if (ticks > 0) then
            doSpell(cid, toDirection, lastPosition, ticks - 1)
        end
    end
end

function onCastSpell(cid, var)
    doSpell(cid, getCreatureLookDirection(cid), getCreaturePosition(cid), 7)
    return true
end
