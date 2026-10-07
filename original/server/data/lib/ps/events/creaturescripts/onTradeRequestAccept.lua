local function filterItems(tmpItems)
    local balls, items = {}, {}
    for k, v in pairs(tmpItems) do
        if (isBallWithPokemon(v.uid)) then
            balls[#balls + 1] = v
        else
            local insert = true
            for i, j in pairs(items) do
                if (j.itemid == v.itemid) then
                    j.count = j.count + getItemCount(v.uid)
                    insert = false
                    break
                end
            end

            if (insert) then
                items[#items + 1] = v
                items[#items].count = getItemCount(v.uid)
            end
        end
    end
    return balls, items
end

local function doSendTradeInformation(cid, target, targetItem)
    local balls, items = {}, {}
    if (isContainer(targetItem.uid)) then
        balls, items = filterItems(getContainerItems(targetItem.uid, true))
    else
        balls, items = filterItems({targetItem})
    end

    local msg = {}
    msg[1] = string.format(__L(cid, "%s offert:\n"), getCreatureName(target))

    for k, ball in ipairs(balls) do
        msg[#msg + 1] = getBallPokemonName(ball.uid)
        msg[#msg + 1] = " Lv "
        msg[#msg + 1] = getBallPokemonLevel(ball.uid)
        msg[#msg + 1] = " +"
        msg[#msg + 1] = getBallPokemonExtraPoints(ball.uid)
        msg[#msg + 1] = __L(cid, "\nVitamins: ")
        msg[#msg + 1] = Vitamin.getBallDescription(ball.uid)
        msg[#msg + 1] = "\nHeld: "
        msg[#msg + 1] = PokemonHeldItem.getBallDescription(ball.uid)
        msg[#msg + 1] = "\n\n"
    end

    for i, item in pairs(items) do
        if (#msg >= 80) then
            msg[#msg + 1] = "...And another "
            msg[#msg + 1] = #items - i
            msg[#msg + 1] = " items"
            break
        end

        msg[#msg + 1] = item.count
        msg[#msg + 1] = "x "
        msg[#msg + 1] = getItemNameById(item.itemid)
        msg[#msg + 1] = "\n"
    end

    doPlayerPopupFYI(cid, table.concat(msg))
end

function onTradeRequestAccept(cid, target, item, targetItem)
    doSendTradeInformation(cid, target, targetItem)
    doSendTradeInformation(target, cid, item)
    return true
end