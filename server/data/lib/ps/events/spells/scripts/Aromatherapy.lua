-- local SKILL_NAME = "Aromatherapy"
local SKILL_AREAS = {
	createCombatArea(AREA_CROSS5X5)
}
local EFFECTS = {EFFECT_RED_BUFF, EFFECT_BLUE_BUFF, EFFECT_GREEN_BUFF}

local combats = {}
for i, skillArea in ipairs(SKILL_AREAS) do
	combats[i] = createCombatObject()
    onTargetTile_Aromatherapy = function(cid, position)
        doSendMagicEffect(position, table.random(EFFECTS))
        local target = getTopCreature(position).uid
        if (isCreature(target) and isFriend(cid, target)) then
            doCreatureRemoveStatus(target, CREATURE_STATUS_BURN)
			doCreatureRemoveStatus(target, CREATURE_STATUS_FREEZE)
			doCreatureRemoveStatus(target, CREATURE_STATUS_PARALYSIS)
			doCreatureRemoveStatus(target, CREATURE_STATUS_POISON)
			doCreatureRemoveStatus(target, CREATURE_STATUS_BADPOISON)
			doCreatureRemoveStatus(target, CREATURE_STATUS_SLEEP)
        end
	end
	setCombatCallback(combats[i], CALLBACK_PARAM_TARGETTILE, "onTargetTile_Aromatherapy")
	setCombatArea(combats[i], skillArea)
	setCombatParam(combats[i], COMBAT_PARAM_AGGRESSIVE, false)
end

local function doSpell(cid, combat, var)
	if (isCreature(cid)) then
		doCombat(cid, combat, var)
	end
end

function onCastSpell(cid, var)
	for i, combat in ipairs(combats) do
		addEvent(doSpell, 500 * (i - 1) + 1, cid, combat, var)
	end
	return true
end
