local SKILL_NAME = "Brutal Swing"

local innerCombat = createCombatObject()
onTargetCreature_BrutalSwingDamage = function(cid, target) doSkillDamage(cid, target, SKILL_NAME) end
setCombatCallback(innerCombat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_BrutalSwingDamage")
setCombatParam(innerCombat, COMBAT_PARAM_EFFECT, getPokemonSkillEffect(SKILL_NAME))
setCombatArea(innerCombat, createCombatArea(AREA_SQUARE1X1))

function onTargetCreature_BrutalSwing(cid, target) doCombat(cid, innerCombat, positionToVariant(getCreaturePosition(target))) end
local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_BrutalSwing")

function onCastSpell(cid, var)
    return doCombat(cid, combat, var)
end
