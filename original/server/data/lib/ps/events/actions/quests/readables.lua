local READS = {
    [23559] = {text = "Day 16:\n\nWe have progressed with the the use of Mew DNA. It is becoming more developed every day, it is responding to our tests. He needs some field experiments... I bet that his strength is what we need to dominate the world. Mewtwo is our greatest weapon."},
    [23562] = {text = "Day 29:\n\nWe discovered in some Pokemon a virus, some call Pokerus. We need to study more sink their consequences. We know so far that it spreads easily. How many Pokemon are infected around?"},
    [23566] = {text = "Chewba\nLuken\nLia"},
    [23579] = {text = "15 Fine Woods - Use Headbutt\n50 Tangela Hairs - Look for Tangelas\n10 Sea Shells - Cerulean underwater stones at north"},
    [0--[[todo]]] = {text = "Greetings pokemon trainer, I bring an invitation:\n\nYou have been chosen to join a select group of Pokemon trainers for a special meeting, it will be led by my teacher, the world's Pokemon coach in his palace on New Island.\n\nA boat will leave the Vermilion city that will take them to the island, please come by boat.\n\nOnly the coaches that are experiencing this invitation will be admitted.\n\nMy master awaits them."},
    [25059] = {onRead = function(cid)
        doCreatureSetStorage(cid, 8528, QUEST_STATUS.FINISHED)
        doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, string.format(__L(cid, "Laboratory information taken. [%s/%s]"),
            doCreatureIncreaseStorage(cid, 8539), 10))
    end,
        text = "Book 01 - Note 01\n\nA new pokemon in South America was found, it is pink and floats gracefully. Its muzzle is short and wide, and it has triangular ears and big blue eyes. It has short arms legs with three fingers, large hind legs and feet soles with oval spots, and a long, thin tail which terminates in an ovoid tip."},
    [25060] = {onRead = function(cid)
        if (getCreatureStorage(cid, 8666) ~= QUEST_STATUS.FINISHED) then
            doCreatureSetStorage(cid, 8666, QUEST_STATUS.FINISHED)
            doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, string.format(__L(cid, "Laboratory information taken. [%s/%s]"),
                doCreatureIncreaseStorage(cid, 8539), 10))
        end
    end, text = "Book 01 - Note 02\n\nApparently it has the ability to appear and disappear at will."},
    [25061] = {onRead = function(cid)
        if (getCreatureStorage(cid, 8530) ~= QUEST_STATUS.FINISHED) then
            doCreatureSetStorage(cid, 8530, QUEST_STATUS.FINISHED)
            doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, string.format(__L(cid, "Laboratory information taken. [%s/%s]"),
                doCreatureIncreaseStorage(cid, 8539), 10))
        end
    end, text = "Book 01 - Note 03\n\nI have the feeling he's following us since the day we sighted."},
    [25062] = {onRead = function(cid)
        if (getCreatureStorage(cid, 8531) ~= QUEST_STATUS.FINISHED) then
            doCreatureSetStorage(cid, 8531, QUEST_STATUS.FINISHED)
            doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, string.format(__L(cid, "Laboratory information taken. [%s/%s]"),
                doCreatureIncreaseStorage(cid, 8539), 10))
        end
    end, text = "Book 01 - Note 04\n\nHe shows signs of intelligence, curiosity, and is playful."},
    [25063] = {onRead = function(cid)
        if (getCreatureStorage(cid, 8532) ~= QUEST_STATUS.FINISHED) then
            doCreatureSetStorage(cid, 8532, QUEST_STATUS.FINISHED)
            doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, string.format(__L(cid, "Laboratory information taken. [%s/%s]"),
                doCreatureIncreaseStorage(cid, 8539), 10))
        end
    end, text = "Book 01 - Note 05\n\nHe is incredibly adaptable, able to travel freely in the air or underwater."},
    [25064] = {onRead = function(cid)
        if (getCreatureStorage(cid, 8533) ~= QUEST_STATUS.FINISHED) then
            doCreatureSetStorage(cid, 8533, QUEST_STATUS.FINISHED)
            doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, string.format(__L(cid, "Laboratory information taken. [%s/%s]"),
                doCreatureIncreaseStorage(cid, 8539), 10))
        end
    end, text = "Book 01 - Note 06\n\nIncredibly, he has an incredible range of motion."},
    [25065] = {onRead = function(cid)
        if (getCreatureStorage(cid, 8534) ~= QUEST_STATUS.FINISHED) then
            doCreatureSetStorage(cid, 8534, QUEST_STATUS.FINISHED)
            doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, string.format(__L(cid, "Laboratory information taken. [%s/%s]"),
                doCreatureIncreaseStorage(cid, 8539), 10))
        end
    end, text = "Book 01 - Note 07\n\nWe got a DNA sample from Mew, it's the type Psychic pokemon."},
    [25066] = {onRead = function(cid)
        if (getCreatureStorage(cid, 8535) ~= QUEST_STATUS.FINISHED) then
            doCreatureSetStorage(cid, 8535, QUEST_STATUS.FINISHED)
            doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, string.format(__L(cid, "Laboratory information taken. [%s/%s]"),
                doCreatureIncreaseStorage(cid, 8539), 10))
        end
    end, text = "Book 02 - Note 01\n\nI could draw the attention of the leader of the team rocket, I will fund my research and so I can have it again ..."},
    [25067] = {onRead = function(cid)
        if (getCreatureStorage(cid, 8536) ~= QUEST_STATUS.FINISHED) then
            doCreatureSetStorage(cid, 8536, QUEST_STATUS.FINISHED)
            doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, string.format(__L(cid, "Laboratory information taken. [%s/%s]"),
                doCreatureIncreaseStorage(cid, 8539), 10))
        end
    end, text = "Book 02 - Note 02\n\nAmazing what he could for research, the team rocket has a lot of power."},
    [25068] = {onRead = function(cid)
        if (getCreatureStorage(cid, 8537) ~= QUEST_STATUS.FINISHED) then
            doCreatureSetStorage(cid, 8537, QUEST_STATUS.FINISHED)
            doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, string.format(__L(cid, "Laboratory information taken. [%s/%s]"),
                doCreatureIncreaseStorage(cid, 8539), 10))
        end
    end, text = "Book 02 - Note 03\n\nIn one month the research center is completed, I'm so looking forward ..."},
    [25069] = {onRead = function(cid)
        if (getCreatureStorage(cid, 8538) ~= QUEST_STATUS.FINISHED) then
            doCreatureSetStorage(cid, 8538, QUEST_STATUS.FINISHED)
            doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, string.format(__L(cid, "Laboratory information taken. [%s/%s]"),
                doCreatureIncreaseStorage(cid, 8539), 10))
        end
    end, text = "Book 02 - Note 04\n\nTomorrow we will be going to the new research center that (name blotted out) built for me, he thinks that isolated island the project will be safer."},
    [25192] = {text = "Greetings pokemon trainer, I bring an invitation:\n\nYou have been chosen to join a select group of Pokemon trainers for a special meeting, it will be led by my teacher, the world's Pokemon trainer in his palace on New Island.\n\nA boat will leave Vermilion city to take the selected group to the island, please come by boat.\n\nOnly trainers who present this invitation will be accepted.\n\nMy master awaits you."},
}

function onUse(cid, item, fromPosition, itemEx, toPosition)
    doShowTextDialog(cid, item.itemid, __L(cid, READS[item.itemid].text))
    if (READS[item.itemid].onRead) then
        READS[item.itemid].onRead(cid)
    end
    return true
end