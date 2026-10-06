setCreatureIcon(getNpcId(), CREATURE_ICONS.QUEST)

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end

function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end

function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end

function onThink() npcHandler:onThink() end

function sayStory(...) return npcHandler:sayStory(...) end

local name = getNpcName()

local WILL_KID_LAST_BATTLE_STORAGE = 9712

local TALK_SEQUENCE_STATE = {}
local TALK_SEQUENCE = {}
TALK_SEQUENCE[#TALK_SEQUENCE + 1] = {
    keywords = { 'sea', 'mar', 'yes', 'sim' },
    onSay = function(cid)
        selfSay("I'm looking for adventurers who can help me with a {problem}! Has interest?", cid)
        return true
    end
}

TALK_SEQUENCE[#TALK_SEQUENCE + 1] = {
    keywords = { 'problem', 'problema' },
    onSay = function(cid)
        selfSay("A few days ago, one of my most reliable sailors told me that he saw a {ghost ship}, I did not believe it, I thought he was drunk or with the madness of the sea, but when I went to the place, I saw it with my own eyes.", cid)
        return true
    end
}

TALK_SEQUENCE[#TALK_SEQUENCE + 1] = {
    keywords = { 'ghost', 'ship', 'embarcacao', 'fantasma' },
    onSay = function(cid)
        selfSay("It was Exile, a Japanese ship belonging to the {Alliance of the 4 Seas}, a group of pirates formed by four factions, who united dominated the seas of the earth for decades, but were defeated 200 years ago.", cid)
        return true
    end
}

TALK_SEQUENCE[#TALK_SEQUENCE + 1] = {
    keywords = { 'alliance of the 4 seas', 'aliança dos 4 mares', 'alliance', 'alianca' },
    onSay = function(cid)
        selfSay("As I said, it was an alias of four great pirate captains, Nagumo, Javy Dones, Jack Spearow and Ed Blackhood, the four commanded pirate groups, Sea Dragons, Guns And Roses, Lunatticus and Cold Waters, were feared By all 4 corners of the planet, but were defeated in the battle of {Black Water}.", cid)
        return true
    end
}

TALK_SEQUENCE[#TALK_SEQUENCE + 1] = {
    keywords = { 'black', 'water' },
    onSay = function(cid)
        selfSay("This battle was between the Alliance of the 4 Seas and an alliance of Lords who thought of putting an end to all the pirates that existed, some say that the victory of the lords would be impossible if it were not an act of treason on the part of someone on the side Two pirates. But these are legends of the seas, the problem here is that this occurred 200 years ago and these {factions} no longer exist, well at least until a few days ago.", cid)
        return true
    end
}

TALK_SEQUENCE[#TALK_SEQUENCE + 1] = {
    keywords = { 'factions', 'faccoes' },
    onSay = function(cid)
        selfSay("I know the {location} of each one of them, you could go check all and prove that I'm not crazy with the sea, but be careful, each faction has its peculiarities.", cid)
        return true
    end
}

TALK_SEQUENCE[#TALK_SEQUENCE + 1] = {
    keywords = { 'location', 'localizacao' },
    onSay = function(cid)
        selfSay("Before I tell you where they need to tell you about each of them, do you want to know which faction first? {Sea Dragons}, {Guns and Roses}, {Lunatticus} or {Cold Waters}?", cid)
        return true
    end
}

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, function(cid, type, msg)
    if (not npcHandler:isFocused(cid)) then
        return false
    end

    if (msgcontains(msg, 'dragon') or msgcontains(msg, 'dragoes')) then
        selfSay("This faction is commanded by Captain Nagumo Harbor, she is aided by the first Sailor Sotashi, she is considered the greatest strategist of the seas, they are pirates but they are disciplined and honored, if you prove their honor to them, perhaps they win the respect of them.", cid)
        selfSay("It is located northeast of Viridian, on a beach near the mountain.", cid)
        selfSay("What other faction do you want to know? {Guns and Roses}, {Lunatticus} or {Cold Waters}?", cid)
        doCreatureSetStorage(cid, 8694, QUEST_STATUS.STARTED) -- Mark as faction started
        return true
    end

    if (msgcontains(msg, 'guns')) then
        selfSay("Led by Javy Dones, this faction is the most aggressive of all, despite their aggressiveness they may hear adventurers, but beware, Javy Dones loves to do business, but if he does not make a profit he'll ask for Redbeard to make some profit from some way.", cid)
        selfSay("It is located south of Fuchsia, on the beach.", cid)
        selfSay("What other faction do you want to know? {Sea Dragons}, {Lunatticus} or {Cold Waters}?", cid)
        doCreatureSetStorage(cid, 8695, QUEST_STATUS.STARTED) -- Mark as faction started
        return true
    end

    if (msgcontains(msg, 'lunatticus')) then
        selfSay("This faction is in this branch for adventure, but they are still pirates, they usually risk in the improbable and are famous for being successful, its leader Captain Jack Spearow, likes to have fun, but will close the face in case you do not call him Captain, Brother Calico only runs the business and is usually more sensible.", cid)
        selfSay("It is located north of Cerulean, next to the Bill's Laboratory.", cid)
        selfSay("What other faction do you want to know? {Sea Dragons}, {Guns And Roses} or {Cold Waters}?", cid)
        doCreatureSetStorage(cid, 8696, QUEST_STATUS.STARTED) -- Mark as faction started
        return true
    end

    if (msgcontains(msg, 'cold')) then
        selfSay("I would not say it's a faction, as they are only 2, Ed Blackhood and Will Kid, it seems they seek revenge for Rickon, Ed's eldest son, Will's brother, I can only say that they have no interest in anything that You want to offer them.", cid)
        selfSay("It is located to the east of Cerulean, near Power Plant, on the coast.", cid)
        selfSay("What other faction do you want to know? {Sea Dragons}, {Guns And Roses} or {Lunatticus}?", cid)
        doCreatureSetStorage(cid, 8697, QUEST_STATUS.STARTED) -- Mark as faction started
        return true
    end

    local sequenceReturn, TALK_SEQUENCE_STATE = doTalkSequence(cid, msg, TALK_SEQUENCE, TALK_SEQUENCE_STATE)
    if (not sequenceReturn) then
        selfSay("Hello adventurer, you look like someone who likes the {sea}, am I correct?", cid)
    end

    return true
end)

npcHandler:setCallback(CALLBACK_GREET, function(cid)
    if (getPlayerDefeatedNPC(cid, WILL_KID_LAST_BATTLE_STORAGE)) then
        npcHandler:sayStory(string.createStory(__L(cid, "You're a damn!! I saw everything, you were fantastic, fought those aberrations and survived, well I healed you, but you stayed alive until I arrived ... I was looking for you, you forgot to tell me if it was true that they had returned .. Then I saw with my eyes Will Kid shooting at you ... lucky that I got there in time, the sleeping dose was high and you almost went the other way ... When I took you home, I boarded a boat near the ship of Nagumo to see more closely, when Nagumo told me to stop ... she wanted to know what I had done to you, I got caught, and they took care of you ... I explained Everything I saw ... so I thought I'd better get you to the city ... I think you'd better go and thank Nagumo, she defended you, that's an honor for the few.")), cid)
        return false
    end

    return true
end)

npcHandler:addModule(FocusModule:new())
