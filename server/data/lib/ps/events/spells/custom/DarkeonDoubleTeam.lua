-- local SKILL_NAME = "Double Team"

local function getProjectile(cid)
    return getPokemonReferenceName(cid) == "Scyther" and PROJECTILE_SCYTHER or PROJECTILE_GRAVEL
end

function onTargetCreature_DoubleTeam(cid, target)
    local pos, summons, i, summon, projectile = getCreaturePosition(target), getCreatureSummons(cid), 0, 0, getProjectile(cid)
    summons = table_concat({cid}, summons)
    for i, summon in ipairs(summons) do
        local cidPos = getCreaturePosition(summon)
        local newPos = {x = pos.x + getRandom(-1, 1), y = pos.y + getRandom(-1, 1), z = pos.z}
        doSendDistanceShoot({x = cidPos.x + getRandom(-4, 4), y = cidPos.y + getRandom(-3, 3), z = cidPos.z}, pos, projectile)
        doSendMagicEffect(cidPos, EFFECT_TELEPORT_FRAME)
        if (isWalkable(summon, newPos)) then
            doTeleportThing(summon, newPos, false)
        end
        doSendMagicEffect(pos, EFFECT_TELEPORT_FRAME)
    end
end
local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_DoubleTeam")

local function doSpell(cid, ticks)
    if (isCreature(cid)) then
        local target = getCreatureTarget(cid)
        if (isCreature(target)) then
            doCombat(cid, combat, numberToVariant(target))
        end

        if (ticks > 0) then
            addEvent(doSpell, 300, cid, ticks - 1)
        end
    end
end

local combatSelf = createCombatObject()
setCombatParam(combatSelf, COMBAT_PARAM_AGGRESSIVE, false)
setCombatCondition(combatSelf, createConditionObject(CONDITION_INVISIBLE, 1000))

function onCastSpell(cid, var)
    doCombat(cid, combatSelf, numberToVariant(cid))

    addEvent(function(cid)
        if (isCreature(cid)) then
            local name = getPokemonReferenceName(cid)
            local summonHealth = 1
            for i = 1, 8 do
                doSummonMonster(cid, name, true)
            end

            for _, summon in pairs(getCreatureSummons(cid)) do
                if (getRandom(0, 3) == 0) then
                    doRemoveCondition(cid, CONDITION_INVISIBLE)
                end

                registerCreatureEvent(summon, "onDeath_Remove")
                setMonsterSex(summon, getMonsterSex(cid))
                setMonsterExtraPoints(summon, getMonsterExtraPoints(cid))
                setMonsterLevel(summon, getMonsterLevel(cid))
                doCreatureChangeHealth(summon, summonHealth)
                setCreatureNickname(summon, getCreatureNickname(cid))
                setPokemonSummon(summon, true)
            end

            addEvent(function(cid)
                if(isCreature(cid)) then
                    for k, v in pairs(getCreatureSummons(cid)) do
                        doRemoveCreature(v)
                    end
                end
            end, 10 * 1001, cid)

            local enemy = getCreatureTarget(cid)
            if (isCreature(enemy)) then
                doCreatureSetTarget(cid, enemy)
            end

            doSpell(cid, 33) --[[ 10 seconds ]]
        end
    end, 500, cid)

    --doSpell(cid, 33) --[[ 10 seconds ]]
    return true
end
