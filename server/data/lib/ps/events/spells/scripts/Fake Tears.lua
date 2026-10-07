local SKILL_NAME = "Fake Tears"

function onTargetCreature_FakeTears(cid, target)
    doCreatureAddStatus(target, CREATURE_STATUS_EXTRASPATK, CREATURE_STATUS_VAR_BADMEDIUM, cid)
    doSendMagicEffect(getCreaturePosition(cid), getPokemonSkillEffect(SKILL_NAME))
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_FakeTears")
function onCastSpell(cid, var)
    return doCombat(cid, combat, var)
end
