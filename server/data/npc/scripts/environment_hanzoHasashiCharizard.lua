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
    for k, v in pairs(PLAYERS) do
        local toPos = getCreaturePosition(v)
        if (toPos) then
            doSendDistanceShoot(getCreaturePosition(getNpcId()), toPos, PROJECTILE_FIRE)
            doCreatureTrueDamage(v, getRandom(-250, -150), EFFECT_FIRE, TEXTCOLOR_ORANGE, toPos)
        end
    end
end
