setCreatureIcon(getNpcId(), CREATURE_ICONS.QUEST)

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end
function sayStory(...) return npcHandler:sayStory(...) end

local npcBattle = NpcBattle:new(getNpcName(), 9297, 9697, npcHandler)
npcBattle:setPokemons({"Venusaur", "Pidgeot", "Raichu", "Poliwrath", "Muk", "Lickitung"})
npcBattle:setOneWin(true)
npcBattle:setDifficulty(60)
npcBattle:setLossSpeech("Wow, you are very good, I see a great future master pokemon. Now I'm going back to my {journey}, see you later.")

local name = getNpcName()

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, function(cid, type, msg)
    if(not npcHandler:isFocused(cid)) then
      return false
    end

    local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid

    if (getCreatureStorage(cid, 8527) == QUEST_STATUS.STARTED) then -- Self quest
      if (not getPlayerDefeatedNPC(cid, name)) then
        if (msgcontains(msg, 'know') or msgcontains(msg, 'saber')) then
          selfSay("Mm... I'm just a pokemon trainer, my dream is to be the greatest Pokemon trainer of all time! I already know! Let's {duel}!", cid)

        elseif (msgcontains(msg, 'duel') or msgcontains(msg, 'duelar')) then
          npcHandler.talkState[talkUser] =  npcBattle:doTalkStart(getNpcId(), cid)

        elseif (msgcontains(msg, 'yes') or msgcontains(msg, 'sim')) then
          npcHandler.talkState[talkUser] =  npcBattle:doTalkEnd(getNpcId(), cid, npcHandler.talkState[talkUser])

        else
          selfSay("So you found me! Haha! So you want to {know} who am I?", cid)
        end

        return true

      elseif (msgcontains(msg, 'journey') or msgcontains(msg, 'jornada')) then
        selfSay("You are insistent on, but since you and your friends have helped me in a way I will tell... From a long time ago the team rocket controls the illegal pokemon trade and my mission is to stop them, they are very wicked and do more {terrible} things.", cid)
        return true

      elseif (not table.find({'terrible', 'terrivel', 'sim', 'yes', 'terriveis', 'terríveis'}, msg)) then
        selfSay("Wow, you are very good, I see a great future master pokemon. Now I'm going back to my {journey}, see you later.", cid)
        return true
      end

    elseif (getCreatureStorage(cid, 8527) == QUEST_STATUS.FINISHED and (msgcontains(msg, 'father') or msgcontains(msg, 'pai'))) then -- Self quest
      selfSay("...I spoke too much... So... You know my father, he is the owner of Celadon Hotel, a long time the team rocket kidnapped me to force my father to help them, but there met a man who taught me everything I know, but unfortunately he died for the greater good, today I fight for the cause of it being free the world from the clutches of the rocket team. Do not tell my father about me, please! Returning to the subject, go talk to Professor Bill about what you discovered, but not remember who I tell anyone!", cid)

      return true
    end

    npcHandler.talkState[talkUser] = doQuestTalk(cid, name, msg, npcHandler.talkState[talkUser])

    return true
  end)

npcHandler:setCallback(CALLBACK_GREET, function(cid)
    if (not npcHandler:isInRange(cid)) then
      return false
    end

    if (getSamePosition(getNpcPos(), {x = 5029, y = 485, z = 8}) or getSamePosition(getNpcPos(), {x = 5030, y = 575, z = 9})) then -- Kanto Main 10 (Stuck Version)
      return false
    end
    return true
  end)


npcHandler:addModule(FocusModule:new())
