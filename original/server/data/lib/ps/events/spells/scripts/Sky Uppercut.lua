local SKILL_NAME = "Sky Uppercut"

local LOOK_DIRS = {
	[NORTH] = EFFECT_BLUE_CUT_UP,
	[SOUTH] = EFFECT_BLUE_CUT_DOWN,
	[WEST] = EFFECT_BLUE_CUT_LEFT,
	[EAST] = EFFECT_BLUE_CUT_RIGHT
}

function onTargetCreature_SkyUppercut(cid, target)
	doSendMagicEffect(getCreaturePosition(target), LOOK_DIRS[getCreatureLookDir(cid)])
	doSkillDamage(cid, target, SKILL_NAME)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_SkyUppercut")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end
