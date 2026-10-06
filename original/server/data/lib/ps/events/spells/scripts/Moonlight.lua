local SKILL_NAME = "Moonlight"

function onTargetCreature_Moonlight(cid, target)
	local heal = math.ceil((getCreatureMaxHealth(cid) / 2))
	if ((getWorldLightState() == WORLD_LIGHT_STATE_NIGHT or getWorldLightState() == WORLD_LIGHT_STATE_SUNSET)
            or (isPokemonOfPlayer(cid) and getPlayerTournamentReady(getCreatureMaster(cid)))) then
		heal = heal * 2
	end
	doCreatureAddHealth(cid, heal)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Moonlight")
setCombatParam(combat, COMBAT_PARAM_EFFECT, getPokemonSkillEffect(SKILL_NAME))
setCombatParam(combat, COMBAT_PARAM_AGGRESSIVE, false)
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end
