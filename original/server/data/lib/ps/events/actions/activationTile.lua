local ACTIONS = {}

ACTIONS[232] = function(cid, item, fromPosition, itemEx, toPosition)
    local storage = 8713
    if (getCreatureStorage(cid, storage) == QUEST_STATUS.FINISHED) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return false
    end

    doCreatureSetStorage(cid, storage, QUEST_STATUS.FINISHED)
    doPlayerSafeAddItem(cid, 28056, 1, true, true) -- Nagumo's diary
    doSendMagicEffect(toPosition, EFFECT_SPARK)
    doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "The diary was taken!")
    return true
end

ACTIONS[233] = function(cid, item, fromPosition, itemEx, toPosition)
    if (getCreatureStorage(cid, 8690) == QUEST_STATUS.UNSTARTED) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return false
    end

    local storage = 8715
    if (getCreatureStorage(cid, storage) == QUEST_STATUS.FINISHED) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return false
    end

    doCreatureSetStorage(cid, storage, QUEST_STATUS.FINISHED)
    doPlayerSafeAddItem(cid, 28142, 1, true, true) -- sea shell
    doSendMagicEffect(toPosition, EFFECT_SPARK)
    doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "The shell was taken!")
    return true
end

ACTIONS[234] = function(cid, item, fromPosition, itemEx, toPosition)
    if (getCreatureStorage(cid, 8692) == QUEST_STATUS.UNSTARTED) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return false
    end

    local storage = 8716
    if (getCreatureStorage(cid, storage) == QUEST_STATUS.FINISHED) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return false
    end

    doCreatureSetStorage(cid, storage, QUEST_STATUS.FINISHED)
    doPlayerSafeAddItem(cid, 28053, 1, true, true) -- sotashi parchment
    doPlayerSafeAddItem(cid, 28054, 1, true, true) -- suspicious parchment
    doSendMagicEffect(toPosition, EFFECT_SPARK)
    doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "The parchment was taken!")
    return true
end

ACTIONS[230] = function(cid, item, fromPosition, itemEx, toPosition)
    if (getCreatureStorage(cid, 8698) == QUEST_STATUS.UNSTARTED) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true
    end

    local storage = 8702
    if (getCreatureStorage(cid, storage) == QUEST_STATUS.FINISHED) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return false
    end

    doCreatureSetStorage(cid, storage, QUEST_STATUS.FINISHED)
    doPlayerSafeAddItem(cid, 28160, 1, true, true) -- Calico's diary
    doSendMagicEffect(toPosition, EFFECT_SPARK)
    doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "The diary was taken!")
    return true
end

ACTIONS[227] = function(cid, item, fromPosition, itemEx, toPosition)
    if (getCreatureStorage(cid, 8698) == QUEST_STATUS.UNSTARTED) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true
    end

    local storage = 8703
    if (getCreatureStorage(cid, storage) == QUEST_STATUS.FINISHED) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return false
    end

    doCreatureSetStorage(cid, storage, QUEST_STATUS.FINISHED)
    doPlayerSafeAddItem(cid, 28161, 1, true, true) -- Javy Done's diary
    doSendMagicEffect(toPosition, EFFECT_SPARK)
    doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "The diary was taken!")
    return true
end

ACTIONS[228] = function(cid, item, fromPosition, itemEx, toPosition)
    if (getCreatureStorage(cid, 8698) == QUEST_STATUS.UNSTARTED) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true
    end

    local storage = 8704
    if (getCreatureStorage(cid, storage) == QUEST_STATUS.FINISHED) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return false
    end

    doCreatureSetStorage(cid, storage, QUEST_STATUS.FINISHED)
    doPlayerSafeAddItem(cid, 28162, 1, true, true) -- Sotashi's diary
    doSendMagicEffect(toPosition, EFFECT_SPARK)
    doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "The diary was taken!")
    return true
end

ACTIONS[229] = function(cid, item, fromPosition, itemEx, toPosition)
    if (getCreatureStorage(cid, 8701) == QUEST_STATUS.UNSTARTED) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true
    end

    local storage = 8710
    if (getCreatureStorage(cid, storage) == QUEST_STATUS.FINISHED) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return false
    end

    doCreatureSetStorage(cid, storage, QUEST_STATUS.FINISHED)
    doPlayerSafeAddItem(cid, 28164, 1, true, true) -- Sothashi's amulet
    doSendMagicEffect(toPosition, EFFECT_SPARK)
    doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "The amulet was taken!")

    local sotashiId = nil
    local nagumoId = nil

    local actions = {
        {
            action = function()
                local npcPos = { x = 5817, y = 159, z = 7 }
                sotashiId = doCreateNpc("Sotashi", npcPos)
                doSendMagicEffect(npcPos, EFFECT_TELEPORT_FRAME)
                doCreatureSetLookDirection(sotashiId, SOUTH)

                doCreatureSetNoMove(cid, true)
                doMutePlayer(cid, 60)
                setPlayerBlockLogout(cid, true)
            end,
            delay = 0
        },
        {
            action = function()
                doCreatureSay(sotashiId, __L(cid, "Whatever you think you're doing, let it go. I told you I'm not coming here any more, get out or I'll tear you to pieces."), TALKTYPE_SAY)
            end,
            delay = 1000
        },
        {
            action = function()
                local npcPos = { x = 5818, y = 159, z = 7 }
                nagumoId = doCreateNpc("Nagumo Harbor", npcPos)
                doSendMagicEffect(npcPos, EFFECT_TELEPORT_FRAME)
                doCreatureSetLookDirection(nagumoId, WEST)
            end,
            delay = 4000
        },
        {
            action = function()
                doCreatureSay(nagumoId, __L(cid, "Sotashi, this medallion is evil, and it's yours, you caused it to us, why? Why did you betray us?"), TALKTYPE_SAY)
            end,
            delay = 8000
        },
        {
            action = function()
                doCreatureSay(sotashiId, __L(cid, "I never betray anyone, whoever is betraying someone here is this stranger, he must be behind all this, or even Blackhood, is doing some kind of theater to cover up something he has done, I was part of The Circle just like you , You know very well who recruited us and what he dealt with, for that reason you left."), TALKTYPE_SAY)
            end,
            delay = 14000
        },
        {
            action = function()
                doCreatureSay(nagumoId, __L(cid, "Do not try to fool me Sotashi, explain me this medallion."), TALKTYPE_SAY)
            end,
            delay = 20000
        },
        {
            action = function()
                doCreatureSay(sotashiId, __L(cid, "This medallion was not mine, it was Javy Dones who gave me, he owed me some coins and when he came to pay me, he gave me this medallion, I do not even know how much it was worth, but I thought Javy was giving me something for the years together, already That he is not giving anything without having something in return ..."), TALKTYPE_SAY)
            end,
            delay = 26000
        },
        {
            action = function()
                doCreatureSay(sotashiId, __L(cid, "Wait a minute... and if you have something in return..."), TALKTYPE_SAY)
            end,
            delay = 34000
        },
        {
            action = function()
                doCreatureSay(nagumoId, __L(cid, "Could it be that Javy Dones planned to give him this medallion to seal some spell?"), TALKTYPE_SAY)
            end,
            delay = 40000
        },
        {
            action = function()
                doCreatureSay(nagumoId, __L(cid, "Take the medallion and take Javy, ask his origin, make him explain himself."), TALKTYPE_SAY)
            end,
            delay = 46000
        },
        {
            action = function()
                doSendMagicEffect(getCreaturePosition(sotashiId), EFFECT_TELEPORT_FRAME)
                doRemoveCreature(sotashiId)

                doSendMagicEffect(getCreaturePosition(nagumoId), EFFECT_TELEPORT_FRAME)
                doRemoveCreature(nagumoId)

                doCreatureSetNoMove(cid, false)
                setPlayerBlockLogout(cid, false)
                --actioning = nil
            end,
            delay = 54000
        },
    }

    for k, v in pairs(actions) do
        addEvent(v.action, v.delay)
    end
    return true
end

-- Armario que leva ao esconderijo Pikachu - Main 7
ACTIONS[220] = function(cid, item, fromPosition, itemEx, toPosition)
    if (getCreatureStorage(cid, 8517) == QUEST_STATUS.UNSTARTED) then
        return false
    end

    -- todo
    local pos = { x = 3750, y = 435, z = 9 }
    doTeleportThing(cid, pos)
    doSendMagicEffect(pos, EFFECT_BLUE_BUFF)
    return true
end

-- Chave encima da mesa - Main 7
ACTIONS[221] = function(cid, item, fromPosition, itemEx, toPosition)
    local storage = 8518
    if (getCreatureStorage(cid, storage) ~= QUEST_STATUS.STARTED) then
        return false
    end

    doCreatureSetStorage(cid, storage, QUEST_STATUS.FINISHED)

    local pos = getCreaturePosition(cid)
    for _, name in pairs({ "Rocket's Voltorb", "Rocket's Voltorb", "Rocket's Koffing", "Rocket's Ekans" }) do
        local tmpPos = getPositionRandomAdjacent(pos)
        doCreateMonster(name, tmpPos, false)
        doSendMagicEffect(tmpPos, EFFECT_TELEPORT_DOWN)
    end

    -- add chave
    doPlayerSafeAddItem(cid, 25053, 1, true, true)
    doSendMagicEffect(toPosition, EFFECT_SPARK)
    return true
end

-- Ball Pikachu - Main 7
ACTIONS[222] = function(cid, item, fromPosition, itemEx, toPosition)
    if (getCreatureStorage(cid, 8517) ~= QUEST_STATUS.STARTED) then
        return false
    end

    local storage = 8522
    if (getCreatureStorage(cid, storage) == QUEST_STATUS.FINISHED) then
        return true
    end

    local spec = getSpectators(getCreaturePosition(cid), 10, 10, false)
    local npcName = "Ash's Pikachu"
    local pikachu = nil
    if (spec) then
        for k, v in pairs(spec) do
            if (isNpc(v) and getCreatureName(v) == npcName) then
                pikachu = v
                break
            end
        end
    end

    if (pikachu) then
        local creaturePosition = getCreaturePosition(pikachu)

        doSendMagicEffect(creaturePosition, EFFECT_POKEBALL_USE)
        doSendDistanceShoot(getCreaturePosition(cid), creaturePosition, PROJECTILE_POKEBALL)
        addEvent(doSendProjectile, 500, creaturePosition, cid, PROJECTILE_POKEBALL)
        doRemoveCreature(pikachu)
        doPlayerAddItem(cid, 25052, 1, true) -- ash's pikachu poke ball
        addEvent(doCreateNpc, 60 * 1000, npcName, toPosition)
        doCreatureSetStorage(cid, storage, QUEST_STATUS.FINISHED)

        local dest = { x = 3750, y = 438, z = 9 }
        doSendMagicEffect(getCreaturePosition(cid), EFFECT_TELEPORT_UP)
        doTeleportThing(cid, dest)
        doSendMagicEffect(dest, EFFECT_TELEPORT_DOWN)
    end
    return true
end

-- Kanto Main 9 - Telescope
local ACTION223_MISTERY_GUY = nil
ACTIONS[223] = function(cid, item, fromPosition, itemEx, toPosition)
    if (getCreatureStorage(cid, 8527) ~= QUEST_STATUS.STARTED) then
        return false
    end

    if (getCreatureNoMove(cid)) then
        return true -- Probably already using the item
    end

    local doSearch = nil
    doSearch = function(step)
        if (not isCreature(cid)) then
            return
        end

        doCreatureSetLookDirection(cid, getDirectionTo(getCreaturePosition(cid), toPosition, true))

        if (step == 1) then
            doCreatureSetNoMove(cid, true)
            doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Ok! Let's start looking for this guy.")
            doSendMagicEffect(getCreaturePosition(cid), EFFECT_EMOTION_EXCLAMATION)

        elseif (step == 2) then
            doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Hmm... mmm")
            doSendMagicEffect(getCreaturePosition(cid), EFFECT_EMOTION_EXCLAMATION)

        elseif (step == 3) then
            doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Nothing there!")
            doSendMagicEffect(getCreaturePosition(cid), EFFECT_EMOTION_EXCLAMATION)

        elseif (step == 4) then
            doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Here nothing too.")
            doSendMagicEffect(getCreaturePosition(cid), EFFECT_EMOTION_EXCLAMATION)

        elseif (step == 5) then
            doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Grr. Where is he?!")
            doSendMagicEffect(getCreaturePosition(cid), EFFECT_EMOTION_SAD)

        elseif (step == 6) then
            doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "What's that???")
            doSendMagicEffect(getCreaturePosition(cid), EFFECT_EMOTION_EXCLAMATION)

        elseif (step == 7) then
            doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "It's him! Let's go!")
            doSendMagicEffect(getCreaturePosition(cid), EFFECT_EMOTION_EXCLAMATION)

            -- create the npc
            local npcPosition = nil
            if (isCreature(ACTION223_MISTERY_GUY)) then
                npcPosition = getCreaturePosition(ACTION223_MISTERY_GUY)
            else
                npcPosition = table.random({
                    { x = 4010, y = 191, z = 7 },
                    { x = 3962, y = 157, z = 7 },
                    { x = 4007, y = 144, z = 7 }
                })
                ACTION223_MISTERY_GUY = doCreateNpc("Mistery Guy", npcPosition, false) --todo
            end

            -- send the localization to the player
            doPlayerAddMapMark(cid, npcPosition, 0, string.format(__L(cid, "%s last position."), "Mistery Guy"))
            doPlayerSendTextMessage(cid, MESSAGE_STATUS_WARNING, string.format("Mistery Guy %s.", getSearchString(getCreaturePosition(cid), npcPosition, cid, true, true)))

            -- unlock player
            doCreatureSetNoMove(cid, false)
            return
        end

        addEvent(doSearch, 5000, step + 1)
    end

    doSearch(1)
end

-- Kanto Main 9 - Hidden stairs
ACTIONS[224] = function(cid, item, fromPosition, itemEx, toPosition)
    local storage = 8529
    if (getCreatureStorage(cid, storage) ~= QUEST_STATUS.STARTED) then
        return false
    end

    local hiddenPosition = { x = 3281, y = 1014, z = 7 }
    local stairsItemId = 3138

    if (not isItem(getTileItemById(hiddenPosition, stairsItemId))) then
        doCreateItem(stairsItemId, 1, hiddenPosition)
        doSendMagicEffect(hiddenPosition, EFFECT_SPARK)

        addEvent(function()
            doRemoveItem(getTileItemById(hiddenPosition, stairsItemId))
            doSendMagicEffect(hiddenPosition, EFFECT_SPARK)
        end, 15 * 1000)

        doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "A secret entrance appeared!")
    end
    return true
end

-- Kanto Main 12 - Master Ball
ACTIONS[225] = function(cid, item, fromPosition, itemEx, toPosition)
    local storage = 8557

    if (getCreatureStorage(cid, storage) ~= QUEST_STATUS.FINISHED) then
        doPlayerSafeAddItem(cid, 27426, 1, true, true)
        doCreatureSetStorage(cid, storage, QUEST_STATUS.FINISHED)
    elseif (getPlayerDefeatedNPC(cid, 9703)) then -- Pode ser que o jogador tenha pego a master ball mas ainda não vencido o Giovanni aqui.
        return false
    end

    doSendDistanceShoot(toPosition, fromPosition, PROJECTILE_GRAVEL)
    doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "The master ball was taken!")

    local npcPos = { x = 5505, y = 88, z = 7 }
    local npcName = "Giovanni"

    if (not getAlreadyNpcAround(npcPos, npcName)) then
        doCreateNpc(npcName, npcPos)
        doSendMagicEffect(npcPos, EFFECT_TELEPORT_DOWN)
        doSendMagicEffect(npcPos, EFFECT_EMOTION_SAD)
    end
    return true
end

-- Kanto Main 12 - Wrench
ACTIONS[158] = function(cid, item, fromPosition, itemEx, toPosition)
    local storage = 8559
    if (getCreatureStorage(cid, storage) == QUEST_STATUS.FINISHED) then
        return false
    end

    doCreatureSetStorage(cid, storage, QUEST_STATUS.FINISHED)
    doPlayerSafeAddItem(cid, 25193, 1, true, true) -- wrench
    doSendMagicEffect(toPosition, EFFECT_SPARK)
    doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "The wrench was taken!")
    return true
end

-- Event Christmas Grinch (Santa Chair)
ACTIONS[170] = function(cid, item, fromPosition, itemEx, toPosition)
    local count = getGlobalStorageValue(GLOBAL_STORAGES.EVENT_CHRISTMAS_PRESENT_COUNT)
    local rate = 0

    if (count >= 71) then
        rate = 1
    elseif (count >= 51) then
        rate = 0.7
    elseif (count >= 31) then
        rate = 0.5
    elseif (count >= 21) then
        rate = 0.3
    elseif (count >= 1) then
        rate = 0.2
    end

    if (rate <= 0) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true
    end

    if (not doExtraExpRateStart(cid, 3 * 60 * 60, rate)) then
        doPlayerSendCancel(cid, "You already have got the experience bonus.")
    end

    doPlayerAchievementCheck(cid, ACHIEVEMENT_IDS.GRINCH_XMAS_CHAIR)
    return true
end

-- Event Christmas - Grinch's cloak
ACTIONS[171] = function(cid, item, fromPosition, itemEx, toPosition)
    local storage = 8564
    if (getCreatureStorage(cid, storage) == QUEST_STATUS.FINISHED) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return false
    end

    doCreatureSetStorage(cid, storage, QUEST_STATUS.FINISHED)
    doPlayerSafeAddItem(cid, 25244, 1, true, true) -- grinch's cloak
    doSendMagicEffect(toPosition, EFFECT_SPARK)
    doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "The cloak was taken!")
    return true
end

-- Event Christmas - Saw
ACTIONS[163] = function(cid, item, fromPosition, itemEx, toPosition)
    local storage = 8565
    if (getCreatureStorage(cid, storage) == QUEST_STATUS.FINISHED) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return false
    end

    doCreatureSetStorage(cid, storage, QUEST_STATUS.FINISHED)
    doPlayerSafeAddItem(cid, 25245, 1, true, true) -- saw
    doSendMagicEffect(toPosition, EFFECT_SPARK)
    doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "The saw was taken!")
    return true
end

-- Event Christmas - House Itens [1]
ACTIONS[164] = function(cid, item, fromPosition, itemEx, toPosition)
    local storage = 8643
    if (getCreatureStorage(cid, storage) == QUEST_STATUS.FINISHED) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return false
    end

    doCreatureSetStorage(cid, storage, QUEST_STATUS.FINISHED)
    doSendMagicEffect(toPosition, EFFECT_SPARK)
    doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Hmm! Nothing here.")
    return true
end

-- Event Christmas - House Itens [2]
ACTIONS[165] = function(cid, item, fromPosition, itemEx, toPosition)
    local storage = 8644
    if (getCreatureStorage(cid, storage) == QUEST_STATUS.FINISHED) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return false
    end

    doCreatureSetStorage(cid, storage, QUEST_STATUS.FINISHED)
    doSendMagicEffect(toPosition, EFFECT_SPARK)
    doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Hmm! Nothing here.")
    return true
end

-- Event Christmas - House Itens [3]
ACTIONS[166] = function(cid, item, fromPosition, itemEx, toPosition)
    local storage = 8645
    if (getCreatureStorage(cid, storage) == QUEST_STATUS.FINISHED) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return false
    end

    doCreatureSetStorage(cid, storage, QUEST_STATUS.FINISHED)
    doSendMagicEffect(toPosition, EFFECT_SPARK)
    doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Hmm! Nothing here.")
    return true
end

-- Event Christmas - House Itens [4]
ACTIONS[167] = function(cid, item, fromPosition, itemEx, toPosition)
    local storage = 8646
    if (getCreatureStorage(cid, storage) == QUEST_STATUS.FINISHED) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return false
    end

    doCreatureSetStorage(cid, storage, QUEST_STATUS.FINISHED)
    doSendMagicEffect(toPosition, EFFECT_SPARK)
    doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Hmm! Nothing here.")
    return true
end

-- Event Christmas - House Itens [5]
ACTIONS[168] = function(cid, item, fromPosition, itemEx, toPosition)
    local storage = 8647
    if (getCreatureStorage(cid, storage) == QUEST_STATUS.FINISHED) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return false
    end

    doCreatureSetStorage(cid, storage, QUEST_STATUS.FINISHED)
    doSendMagicEffect(toPosition, EFFECT_SPARK)
    doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Hmm! Nothing here.")
    return true
end

-- Event Christmas - House Itens [6]
ACTIONS[169] = function(cid, item, fromPosition, itemEx, toPosition)
    local storage = 8648
    if (getCreatureStorage(cid, storage) == QUEST_STATUS.FINISHED) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return false
    end

    doCreatureSetStorage(cid, storage, QUEST_STATUS.FINISHED)
    doSendMagicEffect(toPosition, EFFECT_SPARK)
    doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Hmm! Nothing here.")
    return true
end

function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (ACTIONS[item.actionid]) then
        return ACTIONS[item.actionid](cid, item, fromPosition, itemEx, toPosition)
    end
    return true
end