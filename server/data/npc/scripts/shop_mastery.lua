setCreatureIcon(getNpcId(), CREATURE_ICONS.TRADE)

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end

function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end

function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end

function onThink() npcHandler:onThink() end

local NPCS = {
    ["Lake Dan"] = {
        -- Hurricane
        REQUIRED_VOCATION = VOCATIONID_HURRICANEACE,
        REQUIRED_MASTERY = MASTERYID_HURRICANE,
        TOKEN_ID = 14741,
        OPTIONS = {
            { name = "flying container", id = 19016, tokens = 7, count = 1 },
            { name = "dragon container", id = 19011, tokens = 7, count = 1 },
            { name = "curtain", id = 18070, tokens = 1, count = 1 },
            { name = "hurricane paint ticket", id = 19068, tokens = 6, count = 1 },
            { name = "empty hurricane ball", id = 19045, tokens = 1, count = 100, requiredItems = { 14502, 28, 12114, 124, 14472, 87 } },
            {
                name = "hurricane backpack",
                id = 23503,
                tokens = 6,
                count = 1,
                onBuy = function(cid)
                    if (getRandom(1, 100) <= 5) then -- 5%
                        doPlayerSafeAddItem(cid, 19765, 1, true, false) -- doll
                    end
                end
            },
            { id = 29599, tokens = 3, count = 1 },
            { id = 29754, tokens = 7, count = 1 },
            { id = 29755, tokens = 7, count = 1 },
            { id = 29822, tokens = 15, count = 1 },
            { id = 29846, tokens = 15, count = 1 },
        }
    },
    ["Aylmer Len"] = {
        -- Blaze
        REQUIRED_VOCATION = VOCATIONID_BLAZEFLARE,
        REQUIRED_MASTERY = MASTERYID_BLAZE,
        TOKEN_ID = 14740,
        OPTIONS = {
            { name = "fire container", id = 19015, tokens = 7, count = 1 },
            { name = "curtain", id = 18072, tokens = 1, count = 1 },
            { name = "blaze paint ticket", id = 19065, tokens = 6, count = 1 },
            { name = "empty blaze ball", id = 19033, tokens = 1, count = 100, requiredItems = { 12087, 120, 13303, 57, 14482, 22, 14471, 11, 14513, 217, 13307, 54 } },
            {
                name = "blaze backpack",
                id = 23509,
                tokens = 6,
                count = 1,
                onBuy = function(cid)
                    if (getRandom(1, 100) <= 5) then -- 5%
                        doPlayerSafeAddItem(cid, 19763, 1, true, false) -- doll
                    end
                end
            },
            { id = 29569, tokens = 3, count = 1 },
            { id = 29572, tokens = 7, count = 1 },
            { id = 29652, tokens = 7, count = 1 },
            { id = 29787, tokens = 15, count = 1 },
            { id = 29799, tokens = 15, count = 1 },
        }
    },
    ["Grayson Eliot"] = {
        -- Voltagic
        REQUIRED_VOCATION = VOCATIONID_VOLTAGICSTRIKE,
        REQUIRED_MASTERY = MASTERYID_VOLTAGIC,
        TOKEN_ID = 14742,
        OPTIONS = {
            { name = "electric container", id = 19012, tokens = 7, count = 1 },
            { name = "steel container", id = 19025, tokens = 7, count = 1 },
            { name = "curtain", id = 18064, tokens = 1, count = 1 },
            { name = "voltagic paint ticket", id = 19071, tokens = 6, count = 1 },
            { name = "empty voltagic ball", id = 19057, tokens = 1, count = 100, requiredItems = { 12118, 181, 14498, 108, 12140, 217, 13308, 125 } },
            {
                name = "voltagic backpack",
                id = 23508,
                tokens = 6,
                count = 1,
                onBuy = function(cid)
                    if (getRandom(1, 100) <= 5) then -- 5%
                        doPlayerSafeAddItem(cid, 19764, 1, true, false) -- doll
                    end
                end
            },
            { id = 29721, tokens = 3, count = 1 },
            { id = 29617, tokens = 7, count = 1 },
            { id = 29720, tokens = 7, count = 1 },
            { id = 29785, tokens = 15, count = 1 },
            { id = 29797, tokens = 15, count = 1 },
        }
    },
    ["Triston Tibby"] = {
        -- Spectrum
        REQUIRED_VOCATION = VOCATIONID_SPECTRUMASSASSIN,
        REQUIRED_MASTERY = MASTERYID_SPECTRUM,
        TOKEN_ID = 14743,
        OPTIONS = {
            { name = "ghost container", id = 19017, tokens = 7, count = 1 },
            { name = "poison container", id = 19022, tokens = 7, count = 1 },
            { name = "curtain", id = 18065, tokens = 1, count = 1 },
            { name = "spectrum paint ticket", id = 19069, tokens = 6, count = 1 },
            { name = "empty spectrum ball", id = 19049, tokens = 1, count = 100, requiredItems = { 14512, 108, 14499, 46, 12144, 217, 17808, 217 } },
            {
                name = "spectrum backpack",
                id = 23511,
                tokens = 6,
                count = 1,
                onBuy = function(cid)
                    if (getRandom(1, 100) <= 5) then -- 5%
                        doPlayerSafeAddItem(cid, 19766, 1, true, false) -- doll
                    end
                end
            },
            { id = 29626, tokens = 3, count = 1 },
            { id = 29698, tokens = 7, count = 1 },
            { id = 29568, tokens = 7, count = 1 },
            { id = 29625, tokens = 15, count = 1 },
            { id = 29823, tokens = 15, count = 1 },
        }
    },
    ["Rhetta Verna"] = {
        -- Vital
        REQUIRED_VOCATION = VOCATIONID_VITALCOMBAT,
        REQUIRED_MASTERY = MASTERYID_VITAL,
        TOKEN_ID = 14744,
        OPTIONS = {
            { name = "fighting container", id = 19014, tokens = 7, count = 1 },
            { name = "normal container", id = 19021, tokens = 7, count = 1 },
            { name = "curtain", id = 18067, tokens = 1, count = 1 },
            { name = "vital paint ticket", id = 19070, tokens = 6, count = 1 },
            { name = "empty vital ball", id = 19053, tokens = 1, count = 100, requiredItems = { 12133, 32, 14517, 54, 12121, 148, 12099, 148 } },
            {
                name = "vital backpack",
                id = 23505,
                tokens = 6,
                count = 1,
                onBuy = function(cid)
                    if (getRandom(1, 100) <= 5) then -- 5%
                        doPlayerSafeAddItem(cid, 19762, 1, true, false) -- doll
                    end
                end
            },
            { id = 29631, tokens = 3, count = 1 },
            { id = 29632, tokens = 7, count = 1 },
            { id = 29703, tokens = 7, count = 1 },
            { id = 29747, tokens = 15, count = 1 },
            { id = 29782, tokens = 15, count = 1 },
        }
    },
    ["Florence Blanch"] = {
        -- Gaia
        REQUIRED_VOCATION = VOCATIONID_GAIACATCHER,
        REQUIRED_MASTERY = MASTERYID_GAIA,
        TOKEN_ID = 14745,
        OPTIONS = {
            { name = "bug container", id = 19009, tokens = 7, count = 1 },
            { name = "grass container", id = 19018, tokens = 7, count = 1 },
            { name = "curtain", id = 18069, tokens = 1, count = 1 },
            { name = "gaia paint ticket", id = 19066, tokens = 6, count = 1 },
            { name = "empty gaia ball", id = 19037, tokens = 1, count = 100, requiredItems = { 13302, 162, 14510, 325, 17802, 162, 13309, 120 } },
            {
                name = "gaia backpack",
                id = 23506,
                tokens = 6,
                count = 1,
                onBuy = function(cid)
                    if (getRandom(1, 100) <= 5) then -- 5%
                        doPlayerSafeAddItem(cid, 19761, 1, true, false) -- doll
                    end
                end
            },
            { id = 29692, tokens = 3, count = 1 },
            { id = 29713, tokens = 7, count = 1 },
            { id = 29712, tokens = 7, count = 1 },
            { id = 29791, tokens = 15, count = 1 },
            { id = 29808, tokens = 15, count = 1 },
        }
    },
    ["Chris Chrissie"] = {
        -- Avalanche
        REQUIRED_VOCATION = VOCATIONID_AVALANCHEOCEANBORN,
        REQUIRED_MASTERY = MASTERYID_AVALANCHE,
        TOKEN_ID = 14746,
        OPTIONS = {
            { name = "ice container", id = 19020, tokens = 7, count = 1 },
            { name = "water container", id = 19026, tokens = 7, count = 1 },
            { name = "curtain", id = 18068, tokens = 1, count = 1 },
            { name = "avalanche paint ticket", id = 19064, tokens = 6, count = 1 },
            { name = "empty avalanche ball", id = 19029, tokens = 1, count = 100, requiredItems = { 14515, 130, 12112, 203, 14496, 130, 14489, 65 } },
            {
                name = "avalanche backpack",
                id = 23510,
                tokens = 6,
                count = 1,
                onBuy = function(cid)
                    if (getRandom(1, 100) <= 5) then -- 5%
                        doPlayerSafeAddItem(cid, 19760, 1, true, false) -- doll
                    end
                end
            },
            { id = 29737, tokens = 3, count = 1 },
            { id = 29653, tokens = 7, count = 1 },
            { id = 29668, tokens = 7, count = 1 },
            { id = 29716, tokens = 15, count = 1 },
            { id = 29733, tokens = 15, count = 1 },
        }
    },
    ["Adelyn Star"] = {
        -- Heremit
        REQUIRED_VOCATION = VOCATIONID_HEREMITTOMB,
        REQUIRED_MASTERY = MASTERYID_HEREMIT,
        TOKEN_ID = 14747,
        OPTIONS = {
            { name = "rock container", id = 19024, tokens = 7, count = 1 },
            { name = "ground container", id = 19019, tokens = 7, count = 1 },
            { name = "curtain", id = 18066, tokens = 1, count = 1 },
            { name = "heremit paint ticket", id = 19067, tokens = 6, count = 1 },
            { name = "empty heremit ball", id = 19041, tokens = 1, count = 100, requiredItems = { 14505, 116, 14492, 65, 12138, 139, 14519, 46 } },
            {
                name = "heremit backpack",
                id = 23507,
                tokens = 6,
                count = 1,
                onBuy = function(cid)
                    if (getRandom(1, 100) <= 5) then -- 5%
                        doPlayerSafeAddItem(cid, 19768, 1, true, false) -- doll
                    end
                end
            },
            { id = 29623, tokens = 3, count = 1 },
            { id = 29638, tokens = 7, count = 1 },
            { id = 29672, tokens = 7, count = 1 },
            { id = 29701, tokens = 15, count = 1 },
            { id = 29742, tokens = 15, count = 1 },
        }
    },
    ["Coby Fallon"] = {
        -- Zen
        REQUIRED_VOCATION = VOCATIONID_ZENKINESIS,
        REQUIRED_MASTERY = MASTERYID_ZEN,
        TOKEN_ID = 14748,
        OPTIONS = {
            { name = "psychic container", id = 19023, tokens = 7, count = 1 },
            { name = "dark container", id = 19010, tokens = 7, count = 1 },
            { name = "curtain", id = 18071, tokens = 1, count = 1 },
            { name = "zen paint ticket", id = 19072, tokens = 6, count = 1 },
            { name = "empty zen ball", id = 19061, tokens = 1, count = 100, requiredItems = { 12135, 162, 14512, 108, 12148, 81, 12130, 139 } },
            {
                name = "zen backpack",
                id = 23504,
                tokens = 6,
                count = 1,
                onBuy = function(cid)
                    if (getRandom(1, 100) <= 5) then -- 5%
                        doPlayerSafeAddItem(cid, 19767, 1, true, false) -- doll
                    end
                end
            },
            { id = 29659, tokens = 3, count = 1 },
            { id = 29710, tokens = 7, count = 1 },
            { id = 29717, tokens = 7, count = 1 },
            { id = 29801, tokens = 15, count = 1 },
            { id = 29842, tokens = 15, count = 1 },
        }
    },
}

for _, npc in pairs(NPCS) do
    for __, option in pairs(npc.OPTIONS) do
        if (not option.name) then
            option.name = getItemNameById(option.id)
        end

        if (option.requiredItems) then
            option.requiredItemsMessage = {}
            for i = 1, #option.requiredItems, 2 do
                option.requiredItemsMessage[#option.requiredItemsMessage + 1] = option.requiredItems[i + 1]
                option.requiredItemsMessage[#option.requiredItemsMessage + 1] = " "
                option.requiredItemsMessage[#option.requiredItemsMessage + 1] = getItemNameById(option.requiredItems[i])
                if ((i + 1) ~= #option.requiredItems) then
                    option.requiredItemsMessage[#option.requiredItemsMessage + 1] = ", "
                else
                    option.requiredItemsMessage[#option.requiredItemsMessage - 3] = " and "
                end
            end
            option.requiredItemsMessage = table.concat(option.requiredItemsMessage)
        end
    end
end

local OPTIONS = NPCS[getNpcName()].OPTIONS

local OPTION_BY_NAME = {}
for k, v in pairs(OPTIONS) do
    OPTION_BY_NAME[string.lower(v.name)] = v
end

local TOKEN_ID = NPCS[getNpcName()].TOKEN_ID
local REQUIRED_VOCATION = NPCS[getNpcName()].REQUIRED_VOCATION
local REQUIRED_MASTERY = NPCS[getNpcName()].REQUIRED_MASTERY

local lastOption = {}

local TALKSTATE_NONE = 0
local TALKSTATE_EXCHANGING = 10

local function getOptionsMessage()
    local message = {}
    for i, option in ipairs(OPTIONS) do
        message[#message + 1] = i
        message[#message + 1] = "# "
        message[#message + 1] = option.name
        if (option.description) then
            message[#message + 1] = " ("
            message[#message + 1] = option.description
            message[#message + 1] = ")"
        end
        message[#message + 1] = " ["
        message[#message + 1] = option.count
        message[#message + 1] = "x]["
        message[#message + 1] = option.tokens
        message[#message + 1] = "x MT]\n"
    end
    message[#message + 1] = "\nMT = Mastery Tokens"
    return table.concat(message)
end

local optionsMessage = getOptionsMessage()
getOptionsMessage = nil

--
function creatureSayCallback(cid, type, msg)
    if (not npcHandler:isFocused(cid)) then
        return false
    end

    local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid

    if (getPlayerMastery(cid) ~= REQUIRED_MASTERY or getPlayerVocation(cid) < REQUIRED_VOCATION) then
        selfSay("Sorry, you are not able to deal with me! Only 3rd or greater rank members of our mastery can do this.", cid)
        return true
    end

    if (OPTION_BY_NAME[msg]) then
        lastOption[talkUser] = msg
        talkState[talkUser] = TALKSTATE_EXCHANGING
        selfSay(string.format(__L(cid, "You want to exchange %s mastery token%s%s for %sx %s?"), OPTION_BY_NAME[msg].tokens, (OPTION_BY_NAME[msg].tokens > 1 and "s" or ""), (OPTION_BY_NAME[msg].requiredItemsMessage and
                (" more " .. OPTION_BY_NAME[msg].requiredItemsMessage) or ""), OPTION_BY_NAME[msg].count, msg), cid)

    elseif (OPTIONS[tonumber(msg)]) then
        msg = string.lower(OPTIONS[tonumber(msg)].name)
        lastOption[talkUser] = msg
        talkState[talkUser] = TALKSTATE_EXCHANGING
        selfSay(string.format(__L(cid, "You want to exchange %s mastery token%s%s for %sx %s?"), OPTION_BY_NAME[msg].tokens, (OPTION_BY_NAME[msg].tokens > 1 and "s" or ""), (OPTION_BY_NAME[msg].requiredItemsMessage and
                (" more " .. OPTION_BY_NAME[msg].requiredItemsMessage) or ""), OPTION_BY_NAME[msg].count, msg), cid)

    elseif (msgcontains(msg, 'option') or msgcontains(msg, 'opcoes')) then
        doPlayerPopupFYI(cid, optionsMessage)

    elseif ((msgcontains(msg, 'yes') or msgcontains(msg, 'sim')) and talkState[talkUser] == TALKSTATE_EXCHANGING and
            lastOption[talkUser]) then
        local opt = OPTION_BY_NAME[lastOption[talkUser]]

        if (opt.canBuy and not opt.canBuy(cid)) then
            selfSay(opt.onBuyError, cid)

        else
            if (getPlayerItemCount(cid, TOKEN_ID) < opt.tokens) then
                selfSay("You do not have enough mastery tokens for it.", cid)
                return true
            end

            if (opt.requiredItems) then
                local gotItems = true
                for i = 1, #opt.requiredItems, 2 do
                    if (getPlayerItemCount(cid, opt.requiredItems[i]) < opt.requiredItems[i + 1]) then
                        gotItems = false
                        break
                    end
                end

                if (not gotItems) then
                    selfSay(string.format(__L(cid, "You do not have all needed items for manufacturing! (%s)"), opt.requiredItemsMessage), cid)
                    return true
                end

                for i = 1, #opt.requiredItems, 2 do
                    doPlayerRemoveItem(cid, opt.requiredItems[i], opt.requiredItems[i + 1])
                end
            end

            doPlayerRemoveItem(cid, TOKEN_ID, opt.tokens)
            doPlayerSafeAddItem(cid, opt.id, opt.count, true, opt.unique)
            selfSay("Here is, thanks!", cid)
            doDatalogMasteryTokenBought(os.time(), getPlayerGUID(cid), opt.id, opt.count, opt.tokens)

            if (opt.onBuy) then
                opt.onBuy(cid)
            end
        end

        talkState[talkUser] = TALKSTATE_NONE

    elseif (msgcontains(msg, 'no') or msgcontains(msg, 'nao')) then
        selfSay("Sure.", cid)
        talkState[talkUser] = TALKSTATE_NONE

    else
        selfSay("I'm here to exhcange your {mastery tokens} into {rewards}! Just type {options} to see.", cid)
    end

    return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
