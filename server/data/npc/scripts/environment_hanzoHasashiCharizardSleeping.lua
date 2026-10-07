local PLAYERS = {}

function onCreatureMove(cid, oldPos, newPos)
    if (isPlayer(cid)) then
        local f = table.find(PLAYERS, cid)
        local dist = getDistanceBetween(getCreaturePosition(getNpcId()), newPos) > 7
        if (f and dist) then
            table.remove(PLAYERS, f)
        elseif (not dist and not f) then
            PLAYERS[#PLAYERS + 1] = cid
        end

        if (not getCreatureStatus(getNpcId(), CREATURE_STATUS_SLEEP)) then
            doCreatureAddStatus(getNpcId(), CREATURE_STATUS_SLEEP)
        end
    end
end

function onCreatureDisappear(cid)
    if (isPlayer(cid)) then
        local f = table.find(PLAYERS, cid)
        if (f) then
            table.remove(PLAYERS, f)
        end
    end
end

function onThink()
    local npc = getNpcId()

    for k, v in pairs(PLAYERS) do
        local toPos = getCreaturePosition(v)
        if (toPos and getRandom(1, 5) == 1) then
            doSendDistanceShoot(getSkyPosition(toPos), toPos, PROJECTILE_GRAVEL)
            doCreatureTrueDamage(v, getRandom(-50, -100), EFFECT_FAILING_ROCKS, TEXTCOLOR_GREY, toPos)
        end
    end
end
