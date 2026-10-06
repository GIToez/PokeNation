local SKILL_NAME = "Curse"

local function doSpell(cid, target, ticks)
	if (isCreature(cid) and isCreature(target)) then
		doSkillDamage(cid, target, SKILL_NAME)
		if (ticks > 0) then
			addEvent(doSpell, 1000, cid, target, ticks - 1)
		end
	end
end

function onTargetCreature_Curse(cid, target)
    if (not isInArray(getPokemonTypes(cid), ELEMENT_GHOST)) then
        doCreatureAddStatus(cid, CREATURE_STATUS_EXTRASPDEF, CREATURE_STATUS_VAR_LOW, cid)
        doCreatureAddStatus(cid, CREATURE_STATUS_EXTRASPATK, CREATURE_STATUS_VAR_LOW, cid)
        doCreatureAddStatus(cid, CREATURE_STATUS_EXTRASPEED, CREATURE_STATUS_VAR_BAD, cid)
    else
        local healAmount = -(math.ceil(getCreatureHealth(cid) / 2))
        doTargetCombatHealth(nil, cid, COMBAT_DEATHDAMAGE, healAmount, healAmount, EFFECT_CURSE)
        doSpell(cid, target, 5)
        doSendCreatureEffect(target, CREATURE_EFFECTS.PURPLE, 5 * 1000)
    end
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Curse")
function onCastSpell(cid, var)
  return doCombat(cid, combat, var)
end
