setCreatureIcon(getNpcId(), CREATURE_ICONS.QUEST)

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

local OPTIONS = {
  {reagent = "water stone", reagentId = 18088, requiredPokeballs = 7, enchantedBallsGenerate = 7},
  {reagent = "fire stone", reagentId = 18083, requiredPokeballs = 7, enchantedBallsGenerate = 7},
  {reagent = "thunderstone", reagentId = 18087, requiredPokeballs = 7, enchantedBallsGenerate = 7},
  {reagent = "leaf stone", reagentId = 18086, requiredPokeballs = 7, enchantedBallsGenerate = 7},

  {reagent = "held magnet", reagentId = 23518, requiredPokeballs = 5, enchantedBallsGenerate = 5},
  {reagent = "held metal coat", reagentId = 23519, requiredPokeballs = 5, enchantedBallsGenerate = 5},

  {reagent = "held never melt ice", reagentId = 23522, requiredPokeballs = 8, enchantedBallsGenerate = 8},
  {reagent = "held soft sand", reagentId = 23529, requiredPokeballs = 8, enchantedBallsGenerate = 8},

  {reagent = "held mystic water", reagentId = 23521, requiredPokeballs = 12, enchantedBallsGenerate = 12},
  {reagent = "held charcoal", reagentId = 23515, requiredPokeballs = 12, enchantedBallsGenerate = 12},
  {reagent = "held miracle seed", reagentId = 23520, requiredPokeballs = 12, enchantedBallsGenerate = 12},

  {reagent = "held spell tag", reagentId = 23530, requiredPokeballs = 20, enchantedBallsGenerate = 20},
  {reagent = "held twisted spoon", reagentId = 23531, requiredPokeballs = 20, enchantedBallsGenerate = 20},

  {reagent = "splash plate", reagentId = 12230, requiredPokeballs = 2, enchantedBallsGenerate = 2},
  {reagent = "flame plate", reagentId = 12229, requiredPokeballs = 2, enchantedBallsGenerate = 2},
  {reagent = "meadow plate", reagentId = 12231, requiredPokeballs = 2, enchantedBallsGenerate = 2},
  {reagent = "zap plate", reagentId = 12237, requiredPokeballs = 2, enchantedBallsGenerate = 2},
  {reagent = "iron plate", reagentId = 17814, requiredPokeballs = 2, enchantedBallsGenerate = 2},
  {reagent = "earth plate", reagentId = 13807, requiredPokeballs = 2, enchantedBallsGenerate = 2},

  {reagent = "spooky plate", reagentId = 18082, requiredPokeballs = 4, enchantedBallsGenerate = 4},
  {reagent = "mind plate", reagentId = 12233, requiredPokeballs = 4, enchantedBallsGenerate = 4},
}

local OPTION_BY_REAGENT = {}
for k, v in pairs(OPTIONS) do
  OPTION_BY_REAGENT[string.lower(v.reagent)] = v
end

local EMPTY_ENCHANTED_BALL_ITEM_ID = 28070
local EMPTY_POKE_BALL_ITEM_ID = 12157

local lastOption = {}

local TALKSTATE_NONE = 0
local TALKSTATE_EXCHANGING = 1

local function getOptionsMessage()
  local message = {}
  for i, option in ipairs(OPTIONS) do
    message[#message + 1] = option.reagent
    if (option.description) then
      message[#message + 1] = " ("
      message[#message + 1] = option.description
      message[#message + 1] = ")"
    end
    message[#message + 1] = " + "
    message[#message + 1] = option.requiredPokeballs
    message[#message + 1] = " empty poke balls for "
    message[#message + 1] = option.enchantedBallsGenerate
    message[#message + 1] = " empty enchanted balls\n"
  end
  return table.concat(message)
end

local optionsMessage = getOptionsMessage()
getOptionsMessage = nil

function creatureSayCallback(cid, type, msg)
  if(not npcHandler:isFocused(cid)) then
    return false
  end

  local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid

  if (OPTION_BY_REAGENT[msg]) then
    lastOption[talkUser] = msg
    talkState[talkUser] = TALKSTATE_EXCHANGING
    selfSay(string.format(__L(cid, "You want to exchange %s more %s empty poke balls for %s empty enchanted balls?"), OPTION_BY_REAGENT[msg].reagent, OPTION_BY_REAGENT[msg].requiredPokeballs, OPTION_BY_REAGENT[msg].enchantedBallsGenerate), cid)

  elseif (msgcontains(msg, 'halloween') or msgcontains(msg, 'gift') or msgcontains(msg, 'dia das bruxas') or msgcontains(msg, 'presente')) then
    selfSay("I can help you build magic {balls} to catch Halloween Pokemons!", cid)

  elseif (msgcontains(msg, 'option') or msgcontains(msg, 'opcoes') or msgcontains(msg, 'ball') or msgcontains(msg, 'bola')) then
    doPlayerPopupFYI(cid, optionsMessage)

  elseif ((msgcontains(msg, 'yes') or msgcontains(msg, 'sim')) and talkState[talkUser] == TALKSTATE_EXCHANGING and
    lastOption[talkUser]) then
    local opt = OPTION_BY_REAGENT[lastOption[talkUser]]

    if (opt.canBuy and not opt.canBuy(cid)) then
      selfSay(opt.onBuyError, cid)

    elseif (getPlayerItemCount(cid, opt.reagentId) >= 1 and getPlayerItemCount(cid, EMPTY_POKE_BALL_ITEM_ID) >= opt.requiredPokeballs and
      doPlayerRemoveItem(cid, opt.reagentId, 1) and doPlayerRemoveItem(cid, EMPTY_POKE_BALL_ITEM_ID, opt.requiredPokeballs)) then
      doPlayerSafeAddItem(cid, EMPTY_ENCHANTED_BALL_ITEM_ID, opt.enchantedBallsGenerate)
      selfSay("Here is, thanks!", cid)

      if (opt.onBuy) then
        opt.onBuy(cid)
      end

    else
      selfSay("You do not have reagents for it.", cid)
    end

    talkState[talkUser] = TALKSTATE_NONE

  elseif (msgcontains(msg, 'no') or msgcontains(msg, 'nao')) then
    selfSay("Hmmm...", cid)
    talkState[talkUser] = TALKSTATE_NONE

  else
    selfSay("What?", cid)
    talkState[talkUser] = TALKSTATE_NONE
  end
  return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
