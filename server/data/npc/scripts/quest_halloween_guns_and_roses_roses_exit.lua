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

  if (msgcontains(msg, 'shore') or msgcontains(msg, 'praia') or msgcontains(msg, 'leave') or msgcontains(msg, 'sair') or msgcontains(msg, 'yes') or msgcontains(msg, 'sim')) then
    selfSay("Here you go.", cid)
    doTeleportThing(cid, {x = 3856, y = 930, z = 7})
  elseif (msgcontains(msg, 'guns')) then
    selfSay("Here you go.", cid)
    doTeleportThing(cid, {x = 5749, y = 123, z = 6})
  else
    selfSay("Ok...", cid)
  end

  return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())