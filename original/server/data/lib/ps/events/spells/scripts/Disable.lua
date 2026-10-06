local SKILL_NAME = "Disable"
local SET_COOLDOWN = 100

function onTargetCreature_Disable(cid, target)
    if (not isMonster(target)) then
        return
    end

	local move, master = getPokemonLastUsedMove(target), getCreatureMaster(target)

    if (master ~= target) then
        if (isPlayer(master)) then
            local ballUid = getPlayerBall(master).uid
            if (not move) then -- If the target has no last used move
                move = table.random(getPokemonSkills(getCreatureName(target), ballUid))
            end

            if (getBallSkillCooldown(ballUid, move) < SET_COOLDOWN) then
                setBallSkillCooldown(master, ballUid, move, SET_COOLDOWN)
            end
        end

    else
        doCreatureSetStorage(target, getPokemonSkillCooldownStorage(move),
            getPokemonSkillCooldownTime(move) + getCurrentTimeInSeconds())
    end
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Disable")
setCombatParam(combat, COMBAT_PARAM_EFFECT, getPokemonSkillAreaEffect(SKILL_NAME))
setCombatParam(combat, COMBAT_PARAM_DISTANCEEFFECT, getPokemonSkillProjectile(SKILL_NAME))
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end
