local SKILL_NAME = "Magnet Rise"
local EFFECT = getPokemonSkillEffect(SKILL_NAME)

function onTargetCreature_MagnetRise(cid, target)
    local pos = getCreaturePosition(cid)
    setPokemonCustomType(cid, ELEMENT_FLYING)
    doSendMagicEffect(pos, EFFECT)
    addEvent(executeInArea, 300, pos, AREA_SQUARE1X1, EFFECT)
    addEvent(function(cid)
        if (isCreature(cid)) then
            setPokemonCustomType(cid, nil)
        end
    end, 10 * 1000, cid)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_MagnetRise")
setCombatParam(combat, COMBAT_PARAM_AGGRESSIVE, false)
function onCastSpell(cid, var)
    return doCombat(cid, combat, var)
end
