local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink()	npcHandler:onThink() end

function creatureSayCallback(cid, type, msg)
  if(not npcHandler:isFocused(cid)) then
    return false
  end

  local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid
  msg = string.lower(msg)

  if (msgcontains(msg, 'shadow') or msgcontains(msg, 'sombra') or msgcontains(msg, 'enter') or msgcontains(msg, 'entrar')) then
    if (getCreatureStorage(cid, 8696) == QUEST_STATUS.UNSTARTED) then
      selfSay("You are not allowed to enter this ship!", cid)
    else
      selfSay("I'll take you to the Shadow, the Captain will decide if you can stay.", cid)
      doTeleportThing(cid, {x = 5851, y = 140, z = 6})
    end
  else
    selfSay("Ok...", cid)
  end

  return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())