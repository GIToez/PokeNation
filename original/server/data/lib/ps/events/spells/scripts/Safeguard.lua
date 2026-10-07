local SKILL_NAME = "Safeguard"
local SKILL_AREAS = {
	createCombatArea(AREA_CROSS5X5)
}

local combats = {}
for i, skillArea in ipairs(SKILL_AREAS) do
	combats[i] = createCombatObject()
    onTargetTile_Safeguard = function(cid, position)
        local target = getTopCreature(position).uid
        if (isCreature(target) and isFriend(cid, target)) then
            doCreatureAddStatus(cid, CREATURE_STATUS_PREVENTSTATUS, nil, cid)
        end
	end
	setCombatCallback(combats[i], CALLBACK_PARAM_TARGETTILE, "onTargetTile_Safeguard")
	setCombatParam(combats[i], COMBAT_PARAM_EFFECT, getPokemonSkillAreaEffect(SKILL_NAME))
	setCombatArea(combats[i], skillArea)
	setCombatParam(combats[i], COMBAT_PARAM_AGGRESSIVE, false)
end

local function doSpell(cid, combat, var)
	if (isCreature(cid)) then
		doCombat(cid, combat, var)
	end
end

function onCastSpell(cid, var)
	local i, combat
	for i, combat in ipairs(combats) do
		addEvent(doSpell, 500 * (i - 1) + 1, cid, combat, var)
	end
	return true
end
