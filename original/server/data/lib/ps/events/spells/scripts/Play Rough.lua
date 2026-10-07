local SKILL_NAME = "Play Rough"

function onTargetCreature_PlayRough(cid, target)
    local cidPos, pos = getCreaturePosition(cid), getPositionAdjacent(cid, getCreaturePosition(target), false)
    if (pos) then
        doSendDistanceShoot(cidPos, pos, PROJECTILE_STARS)
        doSendMagicEffect(cidPos, EFFECT_POFF)
        doTeleportThing(cid, pos, false)
        doSendMagicEffect(pos, EFFECT_POFF)
        for i = 1, 10 do
            addEvent(doSendMagicEffect, (i * 50), getPositionRandomAdjacent(pos, 2), EFFECT_CONFUSE_STARS)
            addEvent(doSendMagicEffect, (i * 50), getPositionRandomAdjacent(pos, 2), EFFECT_POFF)
        end
    end
    doSkillDamage(cid, target, SKILL_NAME)
    if (not doPokemonSpecialAbilityCheck(target, POKEMON_SPECIAL_ABILITY_IDS.SHIELD_DUST, nil) and getRandom(0, 100) <=
            (doPokemonSpecialAbilityCheck(cid, POKEMON_SPECIAL_ABILITY_IDS.SERENA_GRACE, nil) and 20 or 10)) then
        doCreatureAddStatus(target, CREATURE_STATUS_EXTRASPATK, CREATURE_STATUS_VAR_BAD, cid)
    end
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_PlayRough")
function onCastSpell(cid, var)
    return doCombat(cid, combat, var)
end
