local SKILL_NAME = "Icy Wind"
local EFFECT = getPokemonSkillEffect(SKILL_NAME)
local CUSTOM_EFFECT = getPokemonSkillAreaEffect(SKILL_NAME)

function onTargetCreature_IcyWind(cid, target)
    doSkillDamage(cid, target, SKILL_NAME)
    if (not isCreature(target)) then return end -- Defeated
    if (not doPokemonSpecialAbilityCheck(target, POKEMON_SPECIAL_ABILITY_IDS.SHIELD_DUST, nil) and getRandom(0, 100) <=
            (doPokemonSpecialAbilityCheck(cid, POKEMON_SPECIAL_ABILITY_IDS.SERENA_GRACE, nil) and 20 or 10)) then
        doCreatureAddStatus(target, CREATURE_STATUS_EXTRASPEED, CREATURE_STATUS_VAR_BAD, cid)
    end
end
local combat = createCombatObject()
setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_IcyWind")

local function doSpell(cid, target, pos)
    if (isCreature(cid) and isCreature(target)) then
        local targetPos = getCreaturePosition(target)
        if (isSightClear(pos, targetPos, false)) then
            if (getDistanceBetween(pos, targetPos) <= 1) then
                doSkillDamage(cid, target, SKILL_NAME)
            else
                targetPos = getPositionByDirection(pos, getDirectionTo(pos, targetPos), 1)
                doSendMagicEffect(pos, CUSTOM_EFFECT)
                addEvent(doSpell, 300, cid, target, targetPos)
            end
        end
    end
end

function onCastSpell(cid, var)
    doSpell(cid, variantToNumber(var), getCreaturePosition(cid))
    return true
end