local SKILL_NAME = "Boomburst"
local LOOK_DIRS = {
    [NORTH] = { x = 0, y = -1, effect = EFFECT_WING_ATTACK_UP, effectX = 1, effectY = 1 },
    [EAST] = { x = 1, y = 0, effect = EFFECT_WING_ATTACK_RIGHT, effectX = 1, effectY = 1 },
    [SOUTH] = { x = 0, y = 1, effect = EFFECT_WING_ATTACK_DOWN, effectX = 1, effectY = 1 },
    [WEST] = { x = -1, y = 0, effect = EFFECT_WING_ATTACK_LEFT, effectX = 0, effectY = 1 }
}

function onTargetCreature_Boomburst(cid, target)
    if (not doPokemonSpecialAbilityCheck(target, POKEMON_SPECIAL_ABILITY_IDS.SOUNDPROOF, nil)) then
        doSkillDamage(cid, target, SKILL_NAME)
    end
end

local combat = createCombatObject()
setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Boomburst")
setCombatArea(combat, createCombatArea({ { 1, 3, 1 } }))
setCombatParam(combat, COMBAT_PARAM_EFFECT, getPokemonSkillAreaEffect(SKILL_NAME))

local function doSpell(cid, toDirection, lastPosition, ticks)
    if (isCreature(cid)) then
        lastPosition.x = lastPosition.x + LOOK_DIRS[toDirection].x
        lastPosition.y = lastPosition.y + LOOK_DIRS[toDirection].y
        doSendMagicEffect(lastPosition, LOOK_DIRS[toDirection].effect)
        doCombat(cid, combat, positionToVariant(lastPosition))
        if (ticks > 0) then
            addEvent(doSpell, 150, cid, toDirection, lastPosition, ticks - 1)
        end
    end
end

function onCastSpell(cid, var)
    doSpell(cid, getCreatureLookDirection(cid), getCreaturePosition(cid), 7)
    return true
end
