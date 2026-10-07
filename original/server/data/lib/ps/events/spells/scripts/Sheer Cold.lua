local SKILL_NAME = "Sheer Cold"

function onTargetCreature_SheerCold(cid, target)
    if (not isMonster(target) or (getMonsterLevel(cid) >= getMonsterLevel(target) and not table.find(getPokemonTypes(cid), ELEMENT_ICE))) then
        doSkillDamage(cid, target, SKILL_NAME, getPokemonSkillDamage(SKILL_NAME), getCreatureMaxHealth(target) * 0.3)
    end
end

local combat = createCombatObject()
setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_SheerCold")
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
