local PILLAR_DETACHED_ITEMID = 18650
local OLDITEMID_ATTRIBUTE = "olditemid"

function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (not doPlayerSafeAddItem(cid, PILLAR_DETACHED_ITEMID, 1, true, false)) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true

    elseif (not doTransformItem(item.uid, getItemAttribute(item.uid, OLDITEMID_ATTRIBUTE))) then
        log(LOG_TYPES.ERROR, "ballPillar::detach - Can't transform ball.", getCreatureName(cid), fromPosition)
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true
    end

    if (fromPosition.x ~= CONTAINER_POSITION) then
        local name
        local r = db.getResult(string.concat("SELECT `creature_name` FROM `ball_pillars` WHERE `world_id` = ",
            getConfigValue("worldId"), " AND `positionx`=", fromPosition.x," AND `positiony`=", fromPosition.y,
            " AND `positionz`=", fromPosition.z, " LIMIT 1;"))
        if (r:getID() ~= -1) then
            name = r:getDataString('creature_name')
            r:free()
        end

        if (name) then
            local houseId = getHouseFromPos(fromPosition)

            local spec = getSpectators(fromPosition, 20, 20, true)
            if (spec) then
                for k, v in pairs(spec) do
                    if (isNpc(v) and getCreatureNickname(v) == name and getHouseFromPos(getCreaturePosition(v)) == houseId) then
                        doSendDistanceShoot(getCreaturePosition(v), fromPosition, PROJECTILE_POKEBALL)
                        doSendMagicEffect(getCreaturePosition(v), EFFECT_POKEBALL_USE)
                        doRemoveCreature(v)
                        break
                    end
                end
            end
        end

        doMovePlayerItem(cid, item.uid, {y = PLAYER_SLOT_BACKPACK, z = 0})
    end

    db.executeQuery("DELETE FROM `ball_pillars` WHERE positionx='".. fromPosition.x .. "' and positiony='" ..
            fromPosition.y .."' and positionz='".. fromPosition.z .."' and world_id='" ..
            getConfigValue("worldId") .. "';")
    doItemEraseAttribute(item.uid, OLDITEMID_ATTRIBUTE)

    return true
end
