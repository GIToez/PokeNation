function onUse(cid, item, fromPosition, itemEx, toPosition)
    local foundNpc = false
    local spec = getSpectators(toPosition, 3, 3)
    if (spec) then
        for k, v in pairs(spec) do
            if (isNpc(v) and getCreatureName(v) == "Emmet Cash") then
                foundNpc = true
                break
            end
        end
    end

    if (foundNpc) then
        doRemoveItem(item.uid)
        doPlayerSafeAddItem(cid, 28049, 1, true, true)
        doSendAnimatedText(fromPosition, "$$$", TEXTCOLOR_YELLOW)
    else
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
    end

    return true
end
