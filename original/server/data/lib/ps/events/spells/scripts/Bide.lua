local SKILL_NAME = "Bide"
local INTERVAL = 2000

local function doReleaseBide(cid, target)
    if (isCreature(cid) and isCreature(target)) then
        doSkillDamage(cid, target, SKILL_NAME, nil, (getPokemonStoredDamage(cid) * 2))
    end
end

function onTargetCreature_Bide(cid, target)
    setPokemonStoredDamage(cid, 0)
	doCreatureAddStatus(cid, CREATURE_STATUS_STORE_DAMAGE, nil, cid)
    addEvent(doReleaseBide, INTERVAL, cid, target)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Bide")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end
