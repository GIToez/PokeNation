-- local SKILL_NAME = "Rain Dance"

local function doSpell(cid, ticks)
    if (isCreature(cid)) then
        local pos = getCreaturePosition(cid)
        for i = 1, 7 do
            doSendMagicEffect({ x = pos.x + math.random(-2, 2), y = pos.y + math.random(-2, 2), z = pos.z }, EFFECT_THUNDER_CLOUD)
            doSendMagicEffect({ x = pos.x + math.random(-2, 2), y = pos.y + math.random(-2, 2), z = pos.z }, EFFECT_SPLASH)
        end
        if (ticks > 0) then
            addEvent(doSpell, 500, cid, ticks - 1)
        end
    end
end

function onTargetCreature_RainDance(cid, target)
    doCreatureAddStatus(cid, CREATURE_STATUS_EXTRASPATK, CREATURE_STATUS_VAR_LOW, cid)
    doCreatureAddStatus(cid, CREATURE_STATUS_EXTRASPDEF, CREATURE_STATUS_VAR_LOW, cid)
    doSpell(cid, 3)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_RainDance")
setCombatParam(combat, COMBAT_PARAM_AGGRESSIVE, false)
function onCastSpell(cid, var)
    doCombat(cid, combat, var)

    if (doPokemonSpecialAbilityCheck(cid, POKEMON_SPECIAL_ABILITY_IDS.FORECAST, nil)) then
        local tmp = getCreatureOutfit(cid)
        tmp.lookType = 1613

        doCreatureChangeOutfit(cid, tmp)
        setPokemonCustomType(cid, ELEMENT_WATER)
        doSendMagicEffect(getCreaturePosition(cid), EFFECT_SPLASH)
    end

    return true
end
