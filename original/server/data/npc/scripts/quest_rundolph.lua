local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler, CONVERSATION_DEFAULT)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink()	npcHandler:onThink() end

local TOWNS = {
    ["viridian"] = {
        destination = {x = 3307, y = 565, z = 7},
        marks = {
            {x = 3290, y = 575, z = 7},
            {x = 3301, y = 581, z = 7},
            {x = 3273, y = 559, z = 7},
            {x = 3292, y = 548, z = 7},
            {x = 3317, y = 588, z = 7}
        }
    },
    ["pewter"] = {
        destination = {x = 3316, y = 301, z = 7},
        marks = {
            {x = 3296, y = 277, z = 7},
            {x = 3321, y = 286, z = 7},
            {x = 3326, y = 302, z = 7},
            {x = 3310, y = 315, z = 7},
            {x = 3290, y = 296, z = 7},
        }
    },
    ["cerulean"] = {
        destination = {x = 3893, y = 319, z = 7},
        marks = {
            {x = 3899, y = 275, z = 7},
            {x = 3930, y = 291, z = 7},
            {x = 3913, y = 332, z = 7},
            {x = 3858, y = 325, z = 7},
            {x = 3845, y = 295, z = 7}
        }
    },
    ["saffron"] = {
        destination = {x = 3917, y = 483, z = 7},
        marks = {
            {x = 3927, y = 460, z = 7},
            {x = 3950, y = 461, z = 7},
            {x = 3970, y = 491, z = 7},
            {x = 3928, y = 508, z = 7},
            {x = 3914, y = 472, z = 7},
        }
    },
    ["celadon"] = {
        destination = {x = 3689, y = 439, z = 7},
        marks = {
            {x = 3653, y = 415, z = 7},
            {x = 3704, y = 425, z = 7},
            {x = 3697, y = 459, z = 7},
            {x = 3653, y = 451, z = 7},
            {x = 3670, y = 440, z = 7},
        }
    },
    ["vermilion"] = {
        destination = {x = 3956, y = 645, z = 7},
        marks = {
            {x = 3946, y = 612, z = 7},
            {x = 3967, y = 610, z = 7},
            {x = 3993, y = 639, z = 7},
            {x = 3914, y = 653, z = 7},
            {x = 3910, y = 607, z = 7},
        }
    },
    ["fuchsia"] = {
        destination = {x = 3868, y = 848, z = 7},
        marks = {
            {x = 3875, y = 814, z = 7},
            {x = 3898, y = 829, z = 7},
            {x = 3887, y = 858, z = 7},
            {x = 3864, y = 859, z = 7},
            {x = 3839, y = 828, z = 7},
        }
    },
    ["pallet"] = {
        destination = {x = 3291, y = 796, z = 7},
        marks = {
            {x = 3282, y = 815, z = 7},
            {x = 3290, y = 823, z = 7},
            {x = 3300, y = 825, z = 7},
            {x = 3317, y = 831, z = 7},
            {x = 3304, y = 813, z = 7},
        }
    },
    ["lavender"] = {
        destination = {x = 4197, y = 561, z = 7},
        marks = {
            {x = 4199, y = 536, z = 7},
            {x = 4209, y = 563, z = 7},
            {x = 4200, y = 592, z = 7},
            {x = 4168, y = 587, z = 7},
            {x = 4171, y = 565, z = 7},
        }
    },
    ["cinnabar"] = {
        destination = {x = 3357, y = 1043, z = 7},
        marks = {
            {x = 3352, y = 1019, z = 7},
            {x = 3385, y = 1017, z = 7},
            {x = 3390, y = 1038, z = 7},
            {x = 3360, y = 1057, z = 7},
            {x = 3337, y = 1036, z = 7},
        }
    }
}

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, function(cid, type, msg)
    if(not npcHandler:isFocused(cid)) then
        return false
    end

    local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid

    msg = string.lower(msg)

    if (getCreatureStorage(cid, 8639) == QUEST_STATUS.UNSTARTED) then
        selfSay("Sorry, you cannot use my services!", cid)
        return true
    end

    if (TOWNS[msg]) then
        doTeleportThing(cid, TOWNS[msg].destination)
        doSendMagicEffect(TOWNS[msg].destination, EFFECT_TELEPORT_FRAME_TWO)

--        for k, v in pairs(TOWNS[msg].marks) do
--            doPlayerAddMapMark(cid, v, MAPMARK_EXCLAMATION, "Christmas Delivery Position.")
--        end

    else
        selfSay("Your options are: {Viridian}, {Pewter}, {Cerulean}, {Saffron}, {Celadon}, {Vermilion}, {Fuchsia}, {Pallet}, {Lavender} and {Cinnabar}.", cid)
    end
    return true
end)

npcHandler:setCallback(CALLBACK_GREET, function(cid)
    if (not npcHandler:isInRange(cid)) then
        return false
    end

    if (getCreatureStorage(cid, 8639) ~= QUEST_STATUS.UNSTARTED) then
        selfSay("Hi, you must be Grinch who warned me, we will be brief, what city you want to start? Your options are: {Viridian}, {Pewter}, {Cerulean}, {Saffron}, {Celadon}, {Vermilion}, {Fuchsia}, {Pallet}, {Lavender} and {Cinnabar}.", cid)
        npcHandler:addFocus(cid)
        return false
    end

    return true
end)

npcHandler:addModule(FocusModule:new())