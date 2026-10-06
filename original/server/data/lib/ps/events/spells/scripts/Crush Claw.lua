local SKILL_NAME = "Crush Claw"
local SKILL_AREAS = {
    createCombatArea(AREA_SQUARE1X1)
}

local combats = {}
for i, skillArea in ipairs(SKILL_AREAS) do
    combats[i] = createCombatObject()
    onTargetCreature_CrushClaw = function(cid, target)
        doSkillDamage(cid, target, SKILL_NAME)
        if (not isCreature(target)) then return end -- Defeated
        if (not doPokemonSpecialAbilityCheck(target, POKEMON_SPECIAL_ABILITY_IDS.SHIELD_DUST, nil) and getRandom(0, 100) <=
                (doPokemonSpecialAbilityCheck(cid, POKEMON_SPECIAL_ABILITY_IDS.SERENA_GRACE, nil) and 100 or 50)) then
            doCreatureAddStatus(target, CREATURE_STATUS_EXTRASPDEF, CREATURE_STATUS_VAR_BAD, cid)
        end
    end
    setCombatCallback(combats[i], CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_CrushClaw")
    setCombatArea(combats[i], skillArea)
end

local function doSpell(cid, combat)
    if (isCreature(cid)) then
        local pos = getCreaturePosition(getCreatureTarget(cid))
        if (pos) then
            doSendMagicEffect(pos, EFFECT_BIG_CROSS_DOWN)
            doCombat(cid, combat, positionToVariant(pos))
        end
    end
end

function onCastSpell(cid, var)
    for i, combat in ipairs(combats) do
        addEvent(doSpell, 500 * (i - 1) + 1, cid, combat, var)
    end
    return true
end