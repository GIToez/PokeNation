local SKILL_NAME = "Leech Seed"

local function doSpell(cid, target, ticks)
	if(isCreature(cid) and isCreature(target)) then
		if (isPokemon(target) and isInArray(getPokemonTypes(target), ELEMENT_GRASS)) then -- Grass Immunity
            doSkillHealthDrain(cid, target, SKILL_NAME, nil, 1)
        else
            doSkillHealthDrain(cid, target, SKILL_NAME)
        end
		if (ticks > 0) then
			addEvent(doSpell, 1000, cid, target, ticks - 1)
		end
	end
end

function onTargetCreature_LeechSeed(cid, target) doSpell(cid, target, 3) end
local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_LeechSeed")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end
