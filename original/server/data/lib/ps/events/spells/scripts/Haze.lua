local SKILL_NAME = "Haze"
local SKILL_AREAS = {
	createCombatArea(AREA_SQUARE1X1),
	createCombatArea(AREA_CIRCLE2X2_EMPTY),
	createCombatArea(AREA_CIRCLE3X3_EMPTY),
    createCombatArea(AREA_CIRCLE4X4_EMPTY)
}

local combats = {}
for i, skillArea in ipairs(SKILL_AREAS) do
	combats[i] = createCombatObject()
	setCombatParam(combats[i], COMBAT_PARAM_EFFECT, getPokemonSkillAreaEffect(SKILL_NAME))
	setCombatArea(combats[i], skillArea)
end

local function doEffect(cid, combat)
	if (isCreature(cid)) then
		doCombat(cid, combat, positionToVariant(getCreaturePosition(cid)))
	end
end

function onTargetCreature_Haze(cid, target)
	doCreatureRemoveStatus(cid, CREATURE_STATUS_LOWACCURACY)
	doCreatureRemoveStatus(cid, CREATURE_STATUS_EXTRASPEED)
	doCreatureRemoveStatus(cid, CREATURE_STATUS_EXTRASPATK)
	doCreatureRemoveStatus(cid, CREATURE_STATUS_EXTRASPDEF)

    doCreatureRemoveStatus(target, CREATURE_STATUS_LOWACCURACY)
	doCreatureRemoveStatus(target, CREATURE_STATUS_EXTRASPEED)
	doCreatureRemoveStatus(target, CREATURE_STATUS_EXTRASPATK)
	doCreatureRemoveStatus(target, CREATURE_STATUS_EXTRASPDEF)
end
local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Haze")

function onCastSpell(cid, var)
    for i, combat in ipairs(combats) do
		addEvent(doEffect, 250 * (i - 1) + 1, cid, combat)
	end
    return doCombat(cid, combat, var)
end
