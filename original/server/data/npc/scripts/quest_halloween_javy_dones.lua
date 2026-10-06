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

local FIRST_QUEST_STORAGE = 8686
local BARBA_ROJA_LAST_QUEST_STORAGE = 8685
local ED_BLACKHOOD_QUESTIONING_QUEST_STORAGE = 8699
local QUESTIONING_STATUS_STORAGE = 8707
local SOTASHI_AMULET_STATUS_STORAGE = 8710
local ED_BLACKHOOD_LAST_QUEST_STORAGE = 8701
local MEDALION_QUESTIONING_STATUS_STORAGE = 8711

local npcBattle = NpcBattle:new(getNpcName(), 9310, 9710, npcHandler)
npcBattle:setPokemons({"Machamp", "Granbull", "Feraligatr", "Heracross", "Ursaring", "Snorlax"})
npcBattle:setOneWin(true)
npcBattle:setDifficulty(NPC_DIFFICULTY_DYNAMIC)
npcBattle:setPokemonDefeatExperienced(true)
npcBattle:setLossSpeech("This taste, it's bitter, it's been a long time since I've tasted defeat, you look like me a few {years} back.")
npcBattle:setWinSpeech("You were brave, but you're still weak, I can give you another beating if you want.")

local TALK_SEQUENCE_STATE = {}

--[[ SEQUENCE DEFAULT ]]
local TALK_SEQUENCE_DEFAULT = {}
TALK_SEQUENCE_DEFAULT[#TALK_SEQUENCE_DEFAULT + 1] = {
  keywords = {'vacation', 'ferias'},
  onSay = function(cid)
    selfSay("Exactly, and you've taken a few minutes of my time, this will cost you 200 dollars. Do you have $ 200?", cid)
    return true
  end
}

TALK_SEQUENCE_DEFAULT[#TALK_SEQUENCE_DEFAULT + 1] = {
  keywords = {'yes', 'sim', 'no', 'nao'},
  onSay = function(cid)
    if (getPlayerMoney(cid) < 200) then
      selfSay("Do you lie to Dones? Now your debt is at $ 400, when you get my $ 400 return, now one of my men is going to get you out of my sight.", cid)
      doTeleportThing(cid, {x = 0, y = 0, z = 0}) -- todo
    else
      selfSay("So I like it, people who are not afraid to get rich, but 200 dollars was for making me lose a few minutes, if you want to talk to me, it's another 200 dollars, you want to talk to me?", cid)
      doPlayerRemoveMoney(cid, 200)
    end
    return true
  end
}

TALK_SEQUENCE_DEFAULT[#TALK_SEQUENCE_DEFAULT + 1] = {
  keywords = {'yes', 'sim'},
  onSay = function(cid)
    if (getPlayerMoney(cid) < 200) then
      selfSay("Do you lie to Dones? Now your debt is at $ 400, when you get my $ 400 return, now one of my men is going to get you out of my sight.", cid)
      doTeleportThing(cid, {x = 0, y = 0, z = 0}) -- todo
    else
      selfSay("Okay, now I can listen to you, what you want to talk to me, I already informed you that we are on {vacation}, but you insist, what is important?", cid)
      doPlayerRemoveMoney(cid, 200)
    end
    return true
  end
}

TALK_SEQUENCE_DEFAULT[#TALK_SEQUENCE_DEFAULT + 1] = {
  keywords = {'vacation', 'ferias'},
  onSay = function(cid)
    selfSay("And we are with a problem that has '{tied}' us a little, you do not have to know about the problems of our 'company'.", cid)
    return true
  end
}

--TALK_SEQUENCE_DEFAULT[#TALK_SEQUENCE_DEFAULT + 1] = {
--  keywords = {'tied', 'amarrado'},
--  onSay = function(cid)
--    selfSay("And we are with a problem that has '{tied}' us a little, you do not have to know about the problems of our 'company'.", cid)
--    return true
--  end
--}

TALK_SEQUENCE_DEFAULT[#TALK_SEQUENCE_DEFAULT + 1] = {
  keywords = {'tied', 'amarrado'},
  onSay = function(cid)
    npcHandler.talkState[cid] = doQuestTalk(cid, name, 'quest', npcHandler.talkState[cid])
    return true
  end
}

TALK_SEQUENCE_DEFAULT[#TALK_SEQUENCE_DEFAULT + 1] = {
  keywords = {'yes', 'sim', 'no', 'nao'},
  onSay = function(cid)
    npcHandler.talkState[cid] = doQuestTalk(cid, name, 'yes', npcHandler.talkState[cid])
    return true
  end
}

--[[ SEQUENCE QUESTIONING - ED BLACKHOOD QUEST ]]
local TALK_SEQUENCE_QUESTIONING = {}
TALK_SEQUENCE_QUESTIONING[#TALK_SEQUENCE_QUESTIONING + 1] = {
  keywords = {'talk', 'falar'},
  onSay = function(cid)
    selfSay("But what boldness of yours, come here on my ship, want to accuse me of something so serious, you know who you're talking to? You seem to have forgotten, what does {Ed} want now?", cid)
    return true
  end
}

TALK_SEQUENCE_QUESTIONING[#TALK_SEQUENCE_QUESTIONING + 1] = {
  keywords = {'ed'},
  onSay = function(cid)
    npcHandler:sayStory(string.createStory(__L(cid, "Look, I do not owe you satisfactions, but if you really want to know, I've been seeing some things about black magic, do you know how many selfish rich people have died and taken their treasures to the tomb? Most of them, I see no harm in bringing them back to life and asking where their treasures are, you would never understand something like this, you are not an entrepreneur ... the truth is, then I remembered that living dead are ghosts , Or alike, and I'm scared to death of ghosts, ironically I'm dead and I'm what? A ghost, I do not know, but the truth is this, it's nothing special, now get off my ship. You committed a serious fault in snooping on my things, even at Ed's request, I'm going to charge him a huge fee because of that, now get out.")), cid)
    doCreatureSetStorage(cid, QUESTIONING_STATUS_STORAGE, QUEST_STATUS.FINISHED)
    return true
  end
}

--[[ SEQUENCE SOTASHI MEDALLION ]]
local TALK_SEQUENCE_SOTASHI_MEDALLION = {}
TALK_SEQUENCE_SOTASHI_MEDALLION[#TALK_SEQUENCE_SOTASHI_MEDALLION + 1] = {
  keywords = {'accused', 'acusado'},
  onSay = function(cid)
    npcHandler:sayStory(string.createStory(__L(cid, "You are persistent is not it ... come here to accuse me again ... I do not know anything about that medallion there. I only know that I received it from a debt and then realized that it was not valuable, so I gave Sotashi why I go with the face of that slim Japanese. Yes I can be cool sometimes, what's more about it ... and that was not even worth anything. That reminds me that {someone} passed me behind.")), cid)
    return true
  end
}

TALK_SEQUENCE_SOTASHI_MEDALLION[#TALK_SEQUENCE_SOTASHI_MEDALLION + 1] = {
  keywords = {'someone', 'alguem'},
  onSay = function(cid)
    npcHandler:sayStory(string.createStory(__L(cid, "Yes, I got a new rifle for Ed Blackhood, it was actually his son, the dumb one ... so I took it to him, but he was busy making one more machine that he spends his time creating, and asked me to give him the Rifle to the son. I did not like it very much, I'm not a deliveryman, but since I was already there, and I was also curious to see from the top of their observation, I went ... handed the damn rifle to Will, and asked for the payment ... he pulled Some coins, it was not the whole amount, so I asked for the rest, that kid did not talk, he came down, went into his room and came back with this medallion, he looked beautiful and glowed in the dark, but then he lost his sparkle, . But that kid broke my leg ... I tried to give the medallion to Calico, but he said that the medallion symbol was not a good omen, at the time he was coming into The Circle and I did not quite understand that, but he did not want to. I then stored the medallion for a while, until I decided to give it to Sotashi and that was it. If anyone knows anything about the medallion is Will and Ed, go and ask them and stop fucking me, by the way, tell Ed that the debt he already had for accusing me, he just doubled ... Now get out.")), cid)
    doCreatureSetStorage(cid, MEDALION_QUESTIONING_STATUS_STORAGE, QUEST_STATUS.FINISHED)
    return true
  end
}

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, function(cid, type, msg)
    if(not npcHandler:isFocused(cid)) then
      return false
    end
    
    if (getCreatureStorage(cid, ED_BLACKHOOD_LAST_QUEST_STORAGE) == QUEST_STATUS.STARTED and
      getCreatureStorage(cid, SOTASHI_AMULET_STATUS_STORAGE) == QUEST_STATUS.FINISHED) then
      local sequenceReturn, TALK_SEQUENCE_STATE = doTalkSequence(cid, msg, TALK_SEQUENCE_SOTASHI_MEDALLION, TALK_SEQUENCE_STATE)
      return true
    end

    if (getCreatureStorage(cid, ED_BLACKHOOD_QUESTIONING_QUEST_STORAGE) == QUEST_STATUS.STARTED) then
      local sequenceReturn, TALK_SEQUENCE_STATE = doTalkSequence(cid, msg, TALK_SEQUENCE_QUESTIONING, TALK_SEQUENCE_STATE)
      return true
    end

    if (getCreatureStorage(cid, FIRST_QUEST_STORAGE) == QUEST_STATUS.UNSTARTED) then
      local sequenceReturn, TALK_SEQUENCE_STATE = doTalkSequence(cid, msg, TALK_SEQUENCE_DEFAULT, TALK_SEQUENCE_STATE)
      if (sequenceReturn) then
        return true
      end
    end

    local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid
    npcHandler.talkState[talkUser] = doQuestTalk(cid, name, msg, npcHandler.talkState[talkUser])

    return true
  end)


npcHandler:setCallback(CALLBACK_GREET, function(cid)
    if (getCreatureStorage(cid, ED_BLACKHOOD_LAST_QUEST_STORAGE) == QUEST_STATUS.STARTED and
      getCreatureStorage(cid, SOTASHI_AMULET_STATUS_STORAGE) == QUEST_STATUS.FINISHED) then
      selfSay("You again, came to pay me what Ed owes me? But I do not even remember having already added the debt for having {accused} me...", cid)
      npcHandler:addFocus(cid)
      return false
    end

    if (getCreatureStorage(cid, ED_BLACKHOOD_QUESTIONING_QUEST_STORAGE) == QUEST_STATUS.STARTED) then
      selfSay("Look, I like you, but if it's not important, you'll have to pay me, you know that, do not you? Need to {talk} to me?", cid)
      npcHandler:addFocus(cid)
      return false
    end

    if (getCreatureStorage(cid, FIRST_QUEST_STORAGE) == QUEST_STATUS.FINISHED and getCreatureStorage(cid, BARBA_ROJA_LAST_QUEST_STORAGE) ~= QUEST_STATUS.FINISHED) then
      selfSay("At the moment there is nothing you can do for me, maybe Barba Roja can give you some service, or a beating, it depends on his mood, go to him and find out.", cid)
      return false
    end

    return true
  end)

npcHandler:addModule(FocusModule:new())
