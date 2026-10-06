local SKILL_NAME = "Camouflage"

function onTargetCreature_Camouflage(cid, target)
    local types = {
        { type = ELEMENT_NORMAL, color = 1 },
        { type = ELEMENT_GROUND, color = 60 },
        { type = ELEMENT_ROCK, color = 38 },
        { type = ELEMENT_GRASS, color = 82 },
        { type = ELEMENT_WATER, color = 86 },
        { type = ELEMENT_ICE, color = 9 },
    }

    local random = table.random(types)
    setPokemonCustomType(cid, random.type)

    local tmp = getCreatureOutfit(cid)
    tmp.lookHead = random.color
    tmp.lookBody = random.color
    doCreatureChangeOutfit(cid, tmp)

    doSendMagicEffect(getCreaturePosition(cid), getPokemonSkillEffect(SKILL_NAME))
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Camouflage")
setCombatParam(combat, COMBAT_PARAM_EFFECT, getPokemonSkillEffect(SKILL_NAME))
setCombatParam(combat, COMBAT_PARAM_AGGRESSIVE, false)
function onCastSpell(cid, var)
    return doCombat(cid, combat, var)
end