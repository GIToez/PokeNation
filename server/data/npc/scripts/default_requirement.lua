setCreatureIcon(getNpcId(), CREATURE_ICONS.TRADE)

local REQUIREMENTS = {}
-- Valencia
REQUIREMENTS["Ralph Patton"] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 2 end
REQUIREMENTS["Wilkie Joshua"] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 2 end

-- Pummelo
REQUIREMENTS["Dusty"] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 2 end
REQUIREMENTS["Angus Ward"] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 2 end
REQUIREMENTS["Mack Edmund"] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 2 end

-- Pinkan

-- Tarroco
REQUIREMENTS["Glen"] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 3 end

-- Hamlin
REQUIREMENTS["Kelsey Linwood"] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 3 end
REQUIREMENTS["Deven Rusty"] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 3 end
REQUIREMENTS["Drake"] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 3 end

-- Kumquat
REQUIREMENTS["Royston"] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 3 end
REQUIREMENTS["Elihu Jesse"] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 3 end
REQUIREMENTS["Trace Nathaniel"] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 3 end
REQUIREMENTS["Darryl Wilson"] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 3 end
REQUIREMENTS["Robin Theobald"] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 3 end
REQUIREMENTS["Red Hughie"] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 3 end
REQUIREMENTS["Shirley Rocky"] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 3 end

-- Butwal
REQUIREMENTS["Cyrus Egbert"] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 4 end
REQUIREMENTS["Tristan"] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 4 end

-- Navel

-- Mandarin North
REQUIREMENTS["Matt"] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 4 end
REQUIREMENTS["Godfrey Stephen"] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 4 end
REQUIREMENTS["Allen Clancy"] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 4 end
REQUIREMENTS["Forrest Jed"] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 4 end
REQUIREMENTS["Yorick Grover"] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 4 end
REQUIREMENTS["Shaw Norm"] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 4 end

-- Ascorbia
REQUIREMENTS["Sidney"] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 5 end
REQUIREMENTS["Percy Page"] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 5 end
REQUIREMENTS["Dale Clay"] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 5 end

-- Seven Grapefruit
REQUIREMENTS["Jamison"] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 5 end
REQUIREMENTS["Walt Eldred"] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 5 end
REQUIREMENTS["Sampson Trueman"] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 5 end

-- Moro
REQUIREMENTS["Arlie"] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 5 end
REQUIREMENTS["Stacy David"] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 5 end

-- Shamouti
REQUIREMENTS["Reg"] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 6 end
REQUIREMENTS["Lacy Rudy"] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 6 end
REQUIREMENTS["Oliver Davin"] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 6 end

-- Murcott
REQUIREMENTS["Leyton"] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 6 end
REQUIREMENTS["Layne Izzy"] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 6 end
REQUIREMENTS["Headley Anderson"] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 6 end
REQUIREMENTS["Ezra Franklin"] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 6 end
REQUIREMENTS["Ross Bobby"] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 6 end

-- Mandarin South
REQUIREMENTS["Sefton"] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 6 end
REQUIREMENTS["Dale"] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 6 end
REQUIREMENTS["Roydon Haywood"] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 6 end

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()				npcHandler:onThink()					end

npcHandler:addModule(FocusModule:new())

npcHandler:setCallback(CALLBACK_GREET, function(cid)
    local name = getNpcName()
    if (not REQUIREMENTS[name]) then
        log(LOG_TYPES.ERROR, "Npc::default_requirement - Unknown NPC!", name)
        selfSay("You do not have enough access to deal here!", cid)
        return false
    end

    if (npcHandler:isInRange(cid)) then
        if (not REQUIREMENTS[name](cid)) then
            selfSay("You do not have enough access to deal here!", cid)
            return false
        end
    end
    return true
end)
