local REQUIREMENTS = {}
-- Valencia

-- Pummelo
REQUIREMENTS["Dee Edgar"] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 2 end

-- Pinkan

-- Tarroco

-- Hamlin
REQUIREMENTS["Branson Kip"] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 3 end

-- Kumquat
REQUIREMENTS["Caelan Thorley"] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 3 end

-- Butwal

-- Navel

-- Mandarin North

-- Ascorbia
REQUIREMENTS["Den Quincey"] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 5 end

-- Seven Grapefruit

-- Moro
REQUIREMENTS["Garret Redd"] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 5 end

-- Shamouti
REQUIREMENTS["Todd Clancy"] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 6 end

-- Murcott

-- Mandarin South
REQUIREMENTS["Whitaker Upton"] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 6 end

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}
local lastCount = {}
local lastTransferName = {}

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink()	npcHandler:onThink() end

local STATES = {
  NONE = 0,
  DEPOSIT = 1,
  WITHDRAW = 2,
  TRANSFER_ONE = 3,
  TRANSFER_TWO = 4,
  DEPOSIT_ALL = 5,
  WITHDRAW_ALL = 6,
  TRANSFER_THREE = 7,
  TRANSFER_FOUR = 8
}

local BANK_ACTIONS = {}
BANK_ACTIONS.DEPOSIT = 0
BANK_ACTIONS.WITHDRAW = 1
BANK_ACTIONS.TRANSFER = 2

local BANK_ACTIONS_NAMES = {}
BANK_ACTIONS_NAMES[BANK_ACTIONS.DEPOSIT] = "Deposit"
BANK_ACTIONS_NAMES[BANK_ACTIONS.WITHDRAW] = "Withdraw"
BANK_ACTIONS_NAMES[BANK_ACTIONS.TRANSFER] = "Transfer"

local function getCountFromMessage(msg)
  local ret = -1
  local b, e = string.find(msg, "%d+")
  if b ~= nil and e ~= nil then
    ret = tonumber(string.sub(msg, b, e))
  end
  return ret
end

local function doPlayerShowBankHistory(cid)
  local i = 0
  local message = {}
  local r = db.getResult("SELECT `action_id`, `sender`, `receiver`, `amount`, `date` FROM `datalog_bank_transactions` WHERE `sender` = '".. getPlayerGUID(cid) .."' OR `receiver` = '".. getPlayerGUID(cid) .."' ORDER BY `date` DESC LIMIT 10;")
  if (r:getID() ~= -1) then
    repeat
      i = i + 1

      message[#message + 1] = "#" .. i .. " - " 
      message[#message + 1] = BANK_ACTIONS_NAMES[r:getDataInt("action_id")]
      message[#message + 1] = " "
      
      message[#message + 1] = r:getDataInt("amount")
      message[#message + 1] = " dollars. "

      local sender = r:getDataInt("sender")
      local receiver = r:getDataInt("receiver")

      message[#message + 1] = "("
      message[#message + 1] = sender > 0 and getPlayerNameByGUID(sender) or "Bank"
      message[#message + 1] = " => "
      message[#message + 1] = receiver > 0 and getPlayerNameByGUID(receiver) or "Bank"
      message[#message + 1] = ") "

      message[#message + 1] = os.date("%a %b %d %X %Y", r:getDataInt("date"))
      message[#message + 1] = "\n"
    until not r:next()
    r:free()
  end

  doPlayerPopupFYI(cid, #message > 0 and table.concat(message) or "There is no transactions.")
end

function creatureSayCallback(cid, type, msg)
  if(not npcHandler:isFocused(cid)) then
    return false
  end

  local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid
  msg = string.lower(msg)

  if (msgcontains(msg, 'history') or msgcontains(msg, 'historico')) then
    doPlayerShowBankHistory(cid)

  elseif (msgcontains(msg, 'balance') or msgcontains(msg, 'saldo')) then
    talkState[talkUser] = STATES.NONE

    selfSay(string.format(__L(cid, "Your account balance is %s dollar(s)."), getPlayerBalance(cid)), cid)

  elseif (msgcontains(msg, 'deposit all') or msgcontains(msg, 'depositar tudo')) then
    talkState[talkUser] = STATES.DEPOSIT_ALL

    selfSay("Are you sure do you want to deposit all your money?", cid)

  elseif (msgcontains(msg, 'withdraw all') or msgcontains(msg, 'sacar tudo')) then
    talkState[talkUser] = STATES.WITHDRAW_ALL

    selfSay("Are you sure do you want to withdraw all your money?", cid)

  elseif (msgcontains(msg, 'deposit') or msgcontains(msg, 'depositar')) then
    talkState[talkUser] = STATES.DEPOSIT

    selfSay("How much dollars do you like to deposit?", cid)

  elseif (msgcontains(msg, 'withdraw') or msgcontains(msg, 'sacar')) then
    talkState[talkUser] = STATES.WITHDRAW

    selfSay("How much dollars do you like to withdraw?", cid)

  elseif (msgcontains(msg, 'transfer') or msgcontains(msg, 'transferir')) then
    talkState[talkUser] = STATES.TRANSFER_ONE

    selfSay("How much dollars do you like to transfer?", cid)

  elseif (talkState[talkUser] == STATES.DEPOSIT and getCountFromMessage(msg) > 0) then
    local count = getCountFromMessage(msg)
    talkState[talkUser] = STATES.NONE

    if (getPlayerMoney(cid) >= count) then
      if (doPlayerDepositMoney(cid, count)) then
        selfSay("Alright, it's done. Is there something else I can do for you?", cid)
        doDatalogBankTransaction(BANK_ACTIONS.DEPOSIT, getPlayerGUID(cid), 0, count, os.time())
      else
        selfSay("Sorry, the transaction could not be completed.")
      end

    else
      selfSay(string.format(__L(cid, "Sorry, you don't have %s dollar(s)"),count), cid)
    end

  elseif (talkState[talkUser] == STATES.WITHDRAW and getCountFromMessage(msg) > 0) then
    local count = getCountFromMessage(msg)
    talkState[talkUser] = STATES.NONE

    if (getPlayerBalance(cid) >= count) then
      if (doPlayerWithdrawMoney(cid, count)) then
        selfSay("Alright, it's done. Is there something else I can do for you?", cid)
        doDatalogBankTransaction(BANK_ACTIONS.WITHDRAW, 0, getPlayerGUID(cid), count, os.time())
      else
        selfSay("Sorry, the transaction could not be completed.")
      end

    else
      selfSay(string.format(__L(cid, "Sorry, you don't have %s dollar(s) in your account."), count), cid)
    end

  elseif (talkState[talkUser] == STATES.TRANSFER_ONE and getCountFromMessage(msg) > 0) then
    local count = getCountFromMessage(msg)

    if (getPlayerBalance(cid) >= count) then
      talkState[talkUser] = STATES.TRANSFER_TWO
      lastCount[talkUser] = count

      selfSay(string.format(__L(cid, "So you want to transfer %s dollar(s) to?"), count), cid)

    else
      talkState[talkUser] = STATES.NONE

      selfSay(string.format(__L(cid, "Sorry, you don't have %s dollar(s) in your account."), count), cid)
    end

  elseif (talkState[talkUser] == STATES.TRANSFER_TWO) then
    if (getPlayerGUIDByName(msg) and getCreatureName(cid) ~= msg) then
      lastTransferName[talkUser] = msg      
      selfSay("Please retype the name of the player who will receive the amount.", cid)
      talkState[talkUser] = STATES.TRANSFER_THREE

    else
      talkState[talkUser] = STATES.NONE

      selfSay("Sorry, any account has founded with this name.", cid)
    end

  elseif (talkState[talkUser] == STATES.TRANSFER_THREE) then
    if (msg == lastTransferName[talkUser]) then
      selfSay(string.format(__L(cid, "Do you really want to transfer %s dollars to %s?"), lastCount[talkUser], lastTransferName[talkUser]), cid)
      talkState[talkUser] = STATES.TRANSFER_FOUR

    else
      talkState[talkUser] = STATES.NONE

      selfSay("Sorry, any account has founded with this name.", cid)
    end

  elseif (talkState[talkUser] == STATES.TRANSFER_FOUR) then
    if (msgcontains(msg, 'yes') or msgcontains(msg, 'sim')) then
      if (doPlayerTransferMoneyTo(cid, lastTransferName[talkUser], lastCount[talkUser])) then
        selfSay("Alright, it's done. Is there something else I can do for you?", cid)
        doDatalogBankTransaction(BANK_ACTIONS.TRANSFER, getPlayerGUID(cid), getPlayerGUIDByName(lastTransferName[talkUser]), lastCount[talkUser], os.time())
      else
        selfSay("Sorry, the transaction could not be completed.")
      end

    else
      talkState[talkUser] = STATES.NONE

      selfSay("Sorry, any account has founded with this name.", cid)
    end

    lastCount[talkUser] = 0
    lastTransferName[talkUser] = nil

  elseif (talkState[talkUser] == STATES.DEPOSIT_ALL and (msgcontains(msg, 'yes') or msgcontains(msg, 'sim'))) then
    talkState[talkUser] = STATES.NONE

    local count = getPlayerMoney(cid)
    if (doPlayerDepositAllMoney(cid)) then
      selfSay("Alright, it's done. Is there something else I can do for you?", cid)
      doDatalogBankTransaction(BANK_ACTIONS.DEPOSIT, getPlayerGUID(cid), 0, count, os.time())
    else
      selfSay("Sorry, the transaction could not be completed.")
    end

  elseif (talkState[talkUser] == STATES.WITHDRAW_ALL and (msgcontains(msg, 'yes') or msgcontains(msg, 'sim'))) then
    talkState[talkUser] = STATES.NONE

    local count = getPlayerBalance(cid)
    if (doPlayerWithdrawAllMoney(cid)) then
      selfSay("Alright, it's done. Is there something else I can do for you?", cid)
      doDatalogBankTransaction(BANK_ACTIONS.WITHDRAW, 0, getPlayerGUID(cid), count, os.time())
    else
      selfSay("Sorry, the transaction could not be completed.")
    end

  else
    talkState[talkUser] = STATES.NONE

    selfSay("Ok...", cid)
  end

  return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())

npcHandler:setCallback(CALLBACK_GREET, function(cid)
    if (npcHandler:isInRange(cid)) then
      if (REQUIREMENTS[getNpcName()] and not REQUIREMENTS[getNpcName()](cid)) then
        selfSay("You do not have enough access to deal here!", cid)
        return false
      end
    end
    return true
  end)
