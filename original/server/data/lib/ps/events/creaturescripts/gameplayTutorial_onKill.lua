local CACHE = {}

function onKill(cid, target, lastHit)
    if (CACHE[getPlayerGUID(cid)]) then
        return true
    end

    doSendPlayerExtendedOpcode(cid, EXTENDED_IDS.GAMEPLAY_TUTORIAL_IMAGE, "006-loot")
    doSendPlayerExtendedOpcode(cid, EXTENDED_IDS.GAMEPLAY_TUTORIAL_TEXT, __L(cid, "Very well, you managed to defeat a wild Pokemon. Now right click on his body to collect the loot. It will automatically go to your backpack."))

    addEvent(function(cid)
        if (isCreature(cid)) then
            doSendPlayerExtendedOpcode(cid, EXTENDED_IDS.GAMEPLAY_TUTORIAL_IMAGE, "007-catch")
            doSendPlayerExtendedOpcode(cid, EXTENDED_IDS.GAMEPLAY_TUTORIAL_TEXT, __L(cid, "After collecting the loot, you can try to capture the wild Pokemon by right-clicking on an empty Pokeball and then with the left button on the Pokemon's body."))
        end
    end, 10000, cid)

    CACHE[getPlayerGUID(cid)] = true

    return true
end
