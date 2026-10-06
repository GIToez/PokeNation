local SKILL_NAME = "Icicle Spear"

local chances = { 2, 2, 2, 3, 3, 3, 4, 5 }
table.shuffle(chances)

local function doGenerateHits()
    return table.random(chances)
end

function onTargetCreature_IcicleSpear(cid, target)
    doSkillMultipleDamages(cid, SKILL_NAME,
        doPokemonSpecialAbilityCheck(cid, POKEMON_SPECIAL_ABILITY_IDS.SKILL_LINK, nil) and 5 or doGenerateHits())
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_IcicleSpear")
function onCastSpell(cid, var)
    return doCombat(cid, combat, var)
end
