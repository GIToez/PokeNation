local SKILL_NAME = "Double Slap"

--[[local chances = {100, 3/8*100, 3/8*100, 1/8*100, 1/8*100}
local function doGenerateHits()
	local hits = 0
	for i = 1, #chances do
		if (getRandom(1, 100) <= chances[i]) then
			hits = hits + 1
		end
	end
	return hits
end]]

local chances = {2, 2, 2, 3, 3, 3, 4, 5}
table.shuffle(chances)

local function doGenerateHits()
	return table.random(chances)
end

function onTargetCreature_DoubleSlap(cid, target)
	doSkillMultipleDamages(cid, SKILL_NAME,
        doPokemonSpecialAbilityCheck(cid, POKEMON_SPECIAL_ABILITY_IDS.SKILL_LINK, nil) and 5 or doGenerateHits())
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_DoubleSlap")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end
