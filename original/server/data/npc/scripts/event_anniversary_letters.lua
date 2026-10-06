setCreatureIcon(getNpcId(), CREATURE_ICONS.QUEST)

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}
local lastCount = {}

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink()	npcHandler:onThink() end

--[[ ]]
local OPTIONS = {
  {name = "letter A", id = 27819, tokens = 1},
  {name = "letter B", id = 27820, tokens = 1},
  {name = "letter C", id = 27821, tokens = 1},
  {name = "letter D", id = 27822, tokens = 1},
  {name = "letter E", id = 27823, tokens = 1},
  {name = "letter F", id = 27825, tokens = 1},
  {name = "letter G", id = 27826, tokens = 1},
  {name = "letter H", id = 27827, tokens = 1},
  {name = "letter I", id = 27828, tokens = 1},
  {name = "letter J", id = 27830, tokens = 1},
  {name = "letter K", id = 27831, tokens = 1},
  {name = "letter L", id = 14438, tokens = 1},
  {name = "letter M", id = 27832, tokens = 1},
  {name = "letter N", id = 27833, tokens = 1},
  {name = "letter O", id = 14439, tokens = 1},
  {name = "letter P", id = 14440, tokens = 1},
  {name = "letter Q", id = 27834, tokens = 1},
  {name = "letter R", id = 27835, tokens = 1},
  {name = "letter S", id = 14441, tokens = 1},
  {name = "letter T", id = 27836, tokens = 1},
  {name = "letter U", id = 14442, tokens = 1},
  {name = "letter V", id = 27837, tokens = 1},
  {name = "letter W", id = 27838, tokens = 1},
  {name = "letter X", id = 27839, tokens = 1},
  {name = "letter Y", id = 27840, tokens = 1},
  {name = "letter Z", id = 27841, tokens = 1},
  {name = "letter ?", id = 27829, tokens = 2},
  {name = "letter !", id = 27824, tokens = 2},
  {name = "PSoul letter P", id = 27844, tokens = 3},
  {name = "PSoul letter S", id = 27845, tokens = 3},
  {name = "PSoul letter O", id = 27843, tokens = 3},
  {name = "PSoul letter U", id = 27846, tokens = 3},
  {name = "PSoul letter L", id = 27842, tokens = 3},
}

local OPTION_BY_NAME = {}
for k, v in pairs(OPTIONS) do
  OPTION_BY_NAME[string.lower(v.name)] = v
end

local lastOption = {}
local lastCount = {}

local TALKSTATE_NONE = 0
local TALKSTATE_EXCHANGING = 100
local TALKSTATE_COUNT = 150

local function getOptionsMessage()
  local message = {}
  for i, option in ipairs(OPTIONS) do
    message[#message + 1] = option.name
    if (option.description) then
      message[#message + 1] = " ("
      message[#message + 1] = option.description
      message[#message + 1] = ")"
    end
    message[#message + 1] = " [1x]["
    message[#message + 1] = option.tokens
    if (option.tokenId) then
      message[#message + 1] = "x "
      message[#message + 1] = getItemNameById(option.tokenId)
      message[#message + 1] = "]\n"
    else
      message[#message + 1] = "x AT]\n"
    end
  end
  message[#message + 1] = "\nAT = Anniversary Token"
  return table.concat(message)
end

local optionsMessage = getOptionsMessage()
getOptionsMessage = nil
--[[ ]]

function creatureSayCallback(cid, type, msg)
  if(not npcHandler:isFocused(cid)) then
    return false
  end

  local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid
  msg = string.lower(msg)

  if (OPTION_BY_NAME[msg]) then
    lastOption[talkUser] = msg
    talkState[talkUser] = TALKSTATE_COUNT
    selfSay("And how much letters do you want do exchange?", cid)
    
  elseif (msgcontains(msg, 'gift') or msgcontains(msg, 'presente') or msgcontains(msg, 'letter') or msgcontains(msg, 'letra')) then
    selfSay("Here you can exchange the letters into anniversary tokens, you can see the {options}.", cid)
    
  elseif (talkState[talkUser] == TALKSTATE_COUNT) then
    local count = string.extractNumber(msg)
    if (count <= 0) then
      selfSay("And how much letters do you want do exchange?", cid)
      return true
    end
    
    local opt = OPTION_BY_NAME[lastOption[talkUser]]
    lastCount[talkUser] = count
    talkState[talkUser] = TALKSTATE_EXCHANGING
    selfSay(string.format(__L(cid, "You want to exchange %s %s for %s anniversary token(s)?"), count, opt.name, count * opt.tokens), cid)

  elseif (msgcontains(msg, 'option') or msgcontains(msg, 'opcoes')) then
    doPlayerPopupFYI(cid, optionsMessage)

  elseif ((msgcontains(msg, 'yes') or msgcontains(msg, 'sim')) and talkState[talkUser] == TALKSTATE_EXCHANGING and
    lastOption[talkUser]) then
    local opt = OPTION_BY_NAME[lastOption[talkUser]]

    if (getPlayerItemCount(cid, opt.id) >= lastCount[talkUser] and
      doPlayerRemoveItem(cid, opt.id, lastCount[talkUser])) then
      doPlayerSafeAddItem(cid, 27935, lastCount[talkUser] * opt.tokens, true, true)
      selfSay("Oh, thanks!", cid)

      if (opt.onBuy) then
        opt.onBuy(cid)
      end

    else
      selfSay("You do not have enough items for it.", cid)
    end

    talkState[talkUser] = TALKSTATE_NONE
    lastCount[talkUser] = nil

  elseif (msgcontains(msg, 'no') or msgcontains(msg, 'nao')) then
    selfSay("Ok.", cid)
    talkState[talkUser] = TALKSTATE_NONE
    lastCount[talkUser] = nil

  else
    talkState[talkUser] = TALKSTATE_NONE
    lastCount[talkUser] = nil

    selfSay("Ok...", cid)
  end

  return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
