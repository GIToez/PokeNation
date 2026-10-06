local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

local GUIDES = {}
GUIDES["Guide Cary"] = "Tangelo"
GUIDES["Guide Ross"] = "Mandarin North"
GUIDES["Guide Jay"] = "Kumquat"
GUIDES["Guide Everitt"] = "Mikan"
GUIDES["Guide Jocelyn"] = "Pummelo"
GUIDES["Guide David"] = "Ascorbia"
GUIDES["Guide Emmerson"] = "Trovitopolis"
GUIDES["Guide Thurstan"] = "Moro"
GUIDES["Guide Brendan"] = "Sunburst"
GUIDES["Guide Chesley"] = "Viridian"
GUIDES["Guide Emil"] = "Pewter"
GUIDES["Guide Maddox"] = "Cerulean"
GUIDES["Guide Andie"] = "Saffron"
GUIDES["Guide Augustine"] = "Celadon"
GUIDES["Guide Ron"] = "Vermilion"
GUIDES["Guide Weldon"] = "Fuchsia"
GUIDES["Guide Fran"] = "Cinnabar"
GUIDES["Guide Darby"] = "Lavender"

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, function(cid, type, msg)
	if(not npcHandler:isFocused(cid)) then
		return false
    end

    if (msgcontains(msg, 'mark') or msgcontains(msg, 'marcar')) then
        doPlayerAddTownMarks(cid, GUIDES[getNpcName()])
        selfSay("Here you go.", cid)
    end

	return true
end)
npcHandler:addModule(FocusModule:new())