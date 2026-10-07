-- Include the Advanced NPC System
dofile(getDataDir() .. 'npc/lib/npcsystem/npcsystem.lua')

function selfIdle()
    following = false
    attacking = false

    selfAttackCreature(0)
    target = 0
end

function selfSayChannel(cid, message)
    return selfSay(message, cid, false)
end

function selfMoveToCreature(id)
    if (not id or id == 0) then
        return
    end

    local t = getCreaturePosition(id)
    if (not t.x or t.x == nil) then
        return
    end

    selfMoveTo(t.x, t.y, t.z)
    return
end

function getNpcDistanceToCreature(id)
    if (not id or id == 0) then
        selfIdle()
        return nil
    end

    local c = getCreaturePosition(id)
    if (not c.x or c.x == 0) then
        return nil
    end

    local s = getCreaturePosition(getNpcId())
    if (not s.x or s.x == 0 or s.z ~= c.z) then
        return nil
    end

    return math.max(math.abs(s.x - c.x), math.abs(s.y - c.y))
end

local function doKeywordCheck(message, keyword)
    local a, b = message:lower():find(keyword:lower())
    if (a ~= nil and b ~= nil) then
        return true
    end

    return false
end

function doMessageCheck(message, keyword)
    if (type(keyword) == "table") then
        for i, v in pairs(keyword) do
            if (doKeywordCheck(message, v)) then
                return true
            end
        end

        return false
        --return table.isStrIn(message, keyword)
    end

    return doKeywordCheck(message, keyword)
end

function doNpcSellItem(cid, itemid, amount, subType, ignoreCap, inBackpacks, backpack)
    local amount = amount or 1
    local subType = subType or 1
    local ignoreCap = true --ignoreCap and true or false

    local item = 0
    if (isItemStackable(itemid)) then
        item = doCreateItemEx(itemid, amount)
        if (doPlayerAddItemEx(cid, item, ignoreCap) ~= RETURNVALUE_NOERROR) then
            return 0, 0
        end

        return amount, 0
    end

    local a = 0
    if (inBackpacks) then
        local container = doCreateItemEx(backpack, 1)
        local b = 1
        for i = 1, amount do
            item = doAddContainerItem(container, itemid, subType)
            if (itemid == ITEM_PARCEL) then
                doAddContainerItem(item, ITEM_LABEL)
            end

            if (isInArray({ (getContainerCapById(backpack) * b), amount }, i)) then
                if (doPlayerAddItemEx(cid, container, ignoreCap) ~= RETURNVALUE_NOERROR) then
                    b = b - 1
                    break
                end

                a = i
                if (amount > i) then
                    container = doCreateItemEx(backpack, 1)
                    b = b + 1
                end
            end
        end

        return a, b
    end

    for i = 1, amount do
        item = doCreateItemEx(itemid, subType)
        if (itemid == ITEM_PARCEL) then
            doAddContainerItem(item, ITEM_LABEL)
        end

        if (doPlayerAddItemEx(cid, item, ignoreCap) ~= RETURNVALUE_NOERROR) then
            break
        end

        a = i
    end

    return a, 0
end

function doRemoveItemIdFromPos(id, n, position)
    local thing = getThingFromPos({ x = position.x, y = position.y, z = position.z, stackpos = 1 })
    if (thing.itemid == id) then
        doRemoveItem(thing.uid, n)
        return true
    end

    return false
end

function getNpcName()
    return getCreatureName(getNpcId())
end

function getNpcPos()
    return getCreaturePosition(getNpcId())
end

function selfGetPosition()
    local t = getNpcPos()
    return t.x, t.y, t.z
end

msgcontains = doMessageCheck
moveToPosition = selfMoveTo
moveToCreature = selfMoveToCreature
selfMoveToPosition = selfMoveTo
selfGotoIdle = selfIdle
isPlayerPremiumCallback = isPremium
doPosRemoveItem = doRemoveItemIdFromPos
doNpcBuyItem = doPlayerRemoveItem
doNpcSetCreatureFocus = selfFocus
getNpcCid = getNpcId
getDistanceTo = getNpcDistanceTo
getDistanceToCreature = getNpcDistanceToCreature
--
dofile(getDataDir() .. 'npc/lib/frontierisland.lua')
dofile(getDataDir() .. 'npc/lib/wavearena.lua')

function doPokemonRewardFix(cid, allowedPokemon, refundStorage)
    if (getCreatureStorage(cid, refundStorage) == 1) then
        selfSay("I already fixed your Pokemon!", cid)
        return
    end

    local ball = getPlayerBall(cid)
    if (not isItem(ball)) then
        selfSay("Please, first put your poke ball in the correct slot.", cid)
        return
    end

    if (not table.find(allowedPokemon, getBallPokemonName(ball.uid))) then
        selfSay("Sorry, it seems you're not with the previous reward. Please, put the correct poke ball in the slot.", cid)
        return
    end

    if (getBallPokemonLevel(ball.uid) < getBallPokemonExtraPoints(ball.uid)) then
        selfSay("This poke ball is already fixed!", cid)
        return
    end

    setBallPokemonExtraPoints(ball.uid, getBallPokemonExtraPoints(ball.uid) + 10)
    doBallUpdateDescription(ball.uid)
    doCreatureSetStorage(cid, refundStorage, 1)
    selfSay("It's done!", cid)
end

function doTalkSequence(cid, msg, sequence, state)
    local currentState = state[cid]
    if (not currentState) then
        currentState = 0
    end

    currentState = currentState + 1
    if (sequence[currentState]) then
        local currentSequence = sequence[currentState]
        if (msgcontains(msg, currentSequence.keywords)) then
            state[cid] = currentState
            return currentSequence.onSay(cid), state
        else
            currentState = currentState - 1
            if (sequence[currentState]) then
                state[cid] = currentState
                return sequence[currentState].onSay(cid), state
            end
        end
    else
        state[cid] = nil
    end

    return false, state
end
