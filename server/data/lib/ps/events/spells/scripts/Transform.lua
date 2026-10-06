-- local SKILL_NAME = "Transform"

local function deTransform(cid, outfit, _isPokemonOfPlayer)
	if(isCreature(cid)) then
		doCreatureChangeOutfit(cid, outfit)
		doSendMagicEffect(getCreaturePosition(cid), EFFECT_DITTO_TRANSFORM)
		doCreatureSetStorage(cid, pokemonsStorages.transform, -1)
		if (_isPokemonOfPlayer) then
			doPlayerUpdatePokemonIcons(getCreatureMaster(cid), "Ditto")
		end
	end
end

function onTargetCreature_Transform(cid, target)
	if (isPokemonOfPlayer(cid)) then
        doPlayerUpdatePokemonIcons(getCreatureMaster(cid), getCreatureName(target))
        addEvent(deTransform, 20 * 60 * 1000, cid, getCreatureOutfit(cid), true)
    else
        addEvent(deTransform, 20 * 60 * 1000, cid, getCreatureOutfit(cid))
    end
    doSendMagicEffect(getCreaturePosition(cid), EFFECT_DITTO_TRANSFORM)
    doCreatureSetStorage(cid, pokemonsStorages.transform, getCreatureName(target))
	doCreatureChangeOutfit(cid, getCreatureOutfit(target))
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Transform")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end