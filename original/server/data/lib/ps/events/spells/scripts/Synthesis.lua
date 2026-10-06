local SKILL_NAME = "Synthesis"

function onTargetCreature_Synthesis(cid, target)
	local heal = math.ceil((getCreatureMaxHealth(cid) / 2))
	if ((getWorldLightState() == WORLD_LIGHT_STATE_DAY or getWorldLightState() == WORLD_LIGHT_STATE_SUNRISE) or
            (isPokemonOfPlayer(cid) and getPlayerTournamentReady(getCreatureMaster(cid)))) then
		heal = heal * 2
	end
	doCreatureAddHealth(cid, heal)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Synthesis")
setCombatParam(combat, COMBAT_PARAM_EFFECT, getPokemonSkillEffect(SKILL_NAME))
setCombatParam(combat, COMBAT_PARAM_AGGRESSIVE, false)
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end