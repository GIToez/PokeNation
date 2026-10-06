setCreatureIcon(getNpcId(), CREATURE_ICONS.TRADE)

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

npcHandler:addModule(FocusModule:new())

local talkState = {}
local lastCount = {}

local function getCountFromMessage(msg)
  local ret = -1
  local b, e = string.find(msg, "%d+")
  if b ~= nil and e ~= nil then
    ret = tonumber(string.sub(msg, b, e))
  end
  return ret
end

local NODES = {
  -- BALANCE
  {
    keywords = {'balance', 'saldo'},
    callback = function(cid, message, keywords, parameters, node)
      local npcHandler = parameters.npcHandler
      if (npcHandler == nil) then
        error('bank.balance called without any npcHandler instance.')
      end

      if (not npcHandler:isFocused(cid)) then
        return false
      end

      selfSay(string.format(__L(cid, "Your account balance is %s dollar(s)."), getPlayerBalance(cid)), cid)
      npcHandler:resetNpc(cid)
      return true
    end,
    parameters = {
      npcHandler = npcHandler
    },
  },
  -- WITHDRAW
  {
    keywords = {'withdraw', 'sacar'},
    callback = StdModule.say,
    parameters = {
      npcHandler = npcHandler,
      text = 'How much dollars do you like to withdraw?'
    },
    childs = {
      {
        keywords = {'.*'},
        callback = function(cid, message, keywords, parameters, node)
          local npcHandler = parameters.npcHandler
          if (npcHandler == nil) then
            error('bank.withdraw called without any npcHandler instance.')
          end

          if (not npcHandler:isFocused(cid)) then
            return false
          end

          local count = getCountFromMessage(message)
          if (count <= 0) then
            npcHandler:say("Maybe later.", cid)
            npcHandler:resetNpc(cid)
            return true
          end

          local playerSoulCoins = getPlayerAccountSoulCoins(cid)
          if (count > playerSoulCoins) then
            npcHandler:say("Sorry, your account does not have that number of Soul Coins.", cid)
            return true
          end

          setPlayerAccountSoulCoins(cid, playerSoulCoins - count)
          doPlayerAddItem(cid, SOUL_COIN_ID, count)
          doDatalogCoinUse(os.time(), getPlayerGUID(cid), COIN_USE_IDS.WITHDRAW, count)
          npcHandler:say("Alright, it's here.", cid)

          npcHandler:resetNpc(cid)
          return true
        end,
        parameters = {
          npcHandler = npcHandler
        }
      }
    }
  },
}

for k, v in pairs(NODES) do
  local node = keywordHandler:addKeyword(v.keywords, v.callback, v.parameters)
  if (v.childs) then
    for _k, _v in pairs(v.childs) do
      local subNode = node:addChildKeyword(_v.keywords, _v.callback, _v.parameters)
      if (_v.childs) then
        for __k, __v in pairs(_v.childs) do
          subNode:addChildKeyword(__v.keywords, __v.callback, __v.parameters)
        end
      end
    end
  end
end

NODES = nil