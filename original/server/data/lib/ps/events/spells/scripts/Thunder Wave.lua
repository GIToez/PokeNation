local SKILL_NAME = "Thunder Wave"
local AREA_EFFECT = getPokemonSkillAreaEffect(SKILL_NAME)

function onTargetCreature_ThunderWave(cid, target)
    doCreatureAddStatus(target, CREATURE_STATUS_PARALYSIS, nil, cid)
end
function onTargetTile_ThunderWave(cid, position)
    doSendMagicEffect(position, AREA_EFFECT)
end
local combat = createCombatObject()
setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_ThunderWave")
setCombatCallback(combat, CALLBACK_PARAM_TARGETTILE, "onTargetTile_ThunderWave")
setCombatArea(combat, createCombatArea(AREA_WAVE4))

function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end