local PILLAR_ATTACHED_ITEMID = 18649
local OLDITEMID_ATTRIBUTE = "olditemid"
--local POKE_PER_TILE = 10

function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (not isItem(itemEx) or not isBallWithPokemon(itemEx.uid) or
            (not ballsNames[itemEx.itemid] or itemEx.itemid ~= balls[ballsNames[itemEx.itemid]].charged)) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true

    elseif (toPosition.x ~= CONTAINER_POSITION) then -- TODO: This doesnt mean that the player is carring the item or no
        doPlayerSendCancel(cid, "You must pick up this item first.")
        return true
    end

    local unique = getItemUniqueOwner(itemEx.uid)
    if (unique ~= ITEM_UNIQUE_OWNER_NONE and unique ~= getPlayerGUID(cid)) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true
    end

    local pos = getPositionAdjacent(cid, fromPosition)
    if (not pos or not getHouseFromPos(pos)) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTENOUGHROOM)
        return true
    end

    if (not doMoveItem(itemEx.uid, fromPosition)) then -- Move Ball to ground, to be transformed into a pillar
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTENOUGHROOM)
        return true
    end

    local npc = doCreateNpc(table.random({"Pillar Model", "Pillar Model Slow", "Pillar Model Fast"}), pos)
    if (not npc) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true
    end

    local name
    if (getBallPokemonNickname(itemEx.uid)) then
        name = string.concat(getBallPokemonNickname(itemEx.uid), " [", getBallPokemonLevel(itemEx.uid), "]")
    else
        name = string.concat(getBallPokemonName(itemEx.uid), " [", getBallPokemonLevel(itemEx.uid), "]")
    end

    local query = string.concat(
        "INSERT INTO ball_pillars (world_id, positionx, positiony, positionz, attributes, ball_id, creature_name, creature_sex) VALUES (",
         getConfigValue("worldId"), ",",
         fromPosition.x, ",",
         fromPosition.y, ",",
         fromPosition.z, ",",
         getItemAttributesBlob(itemEx.uid), ",",
         itemEx.itemid, ",",
         "'", name , "',",
         getBallPokemonSex(itemEx.uid), ");"
    )

	if (not db.executeQuery(query)) then
		log(LOG_TYPES.ERROR, "ballPillars::attach - Can't query.", getCreatureName(cid), query)
        doRemoveCreature(npc)
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true
	end

    setNpcHouser(npc, true) -- Allow walk inside houses
    doSendDistanceShoot(fromPosition, pos, PROJECTILE_POKEBALL)
    doSendMagicEffect(pos, EFFECT_POKEBALL_USE)
    doCreatureChangeOutfit(npc, getMonsterInfo(getBallPokemonName(itemEx.uid)).outfit)
    setCreatureNickname(npc, name)

    local sex = getBallPokemonSex(itemEx.uid)
    if (sex == POKEMON_SEX_MALE) then
        doCreatureSetSkullType(npc, SKULL_BLACK)
    elseif (sex == POKEMON_SEX_FEMALE) then
        doCreatureSetSkullType(npc, SKULL_RED)
    else
        doCreatureSetSkullType(npc, SKULL_YELLOW)
    end

    doRemoveItem(item.uid)
    doItemSetAttribute(itemEx.uid, OLDITEMID_ATTRIBUTE, itemEx.itemid)
    doTransformItem(itemEx.uid, PILLAR_ATTACHED_ITEMID)
    doPlayerSave(cid) -- let's save to prevent clone balls

    return true
end
