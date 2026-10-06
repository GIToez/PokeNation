local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler, CONVERSATION_DEFAULT)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

local TM_STORAGE = 8400
local function giveTm(cid)
    doCreatureSetStorage(cid, TM_STORAGE, QUEST_STATUS.FINISHED)
    doPlayerSafeAddItem(cid, 17366, 1, true, true, true) -- TM 30 Reflect
end

local npcBattle = NpcBattle:new(getNpcName(), 9106, 9542, npcHandler)
npcBattle:setPokemons({"Mr. Mime", "Alakazam", "Gengar", "Slowbro", "Hypno", "Exeggutor" })
npcBattle:setRewardBaseExp(185)
npcBattle:setRewardBadge(BADGES.MARSH)
npcBattle:setRewardRespect(2)
npcBattle:setPayRespect(70)
npcBattle:setOneWin(true)
npcBattle:setDifficulty(75)
--[[
npcBattle:setRequiredMessage("You must first defeat the GYM trainers before battle against me.")
npcBattle:setRequired(function(cid)
                        return getPlayerDefeatedNPC(cid, "Jeanie Santangelo") and
                                getPlayerDefeatedNPC(cid, "Maricela Boyter") and
                                getPlayerDefeatedNPC(cid, "Clinton Gautreaux") and
                                getPlayerDefeatedNPC(cid, "Lonnie Pretti") and
                                getPlayerDefeatedNPC(cid, "Lonnie Lasko") and
                                getPlayerDefeatedNPC(cid, "Clinton Dahlke") and
                                getPlayerDefeatedNPC(cid, "Jamie Lesperance")
                        end)
]]
npcBattle:setOnWin(function(cid)
    doPlayerAchievementCheck(cid, ACHIEVEMENT_IDS.MARSH_BADGE)
    giveTm(cid)
end)
npcBattle:setPokemonDefeatExperienced(true)

local function doSummonSabrinaHypno()
    local hypnoPos = {x = 3986, y = 476, z = 10}
    local hypnoName = "Sabrina's Hypno"

    local spec = getSpectators(hypnoPos, 6, 6)
    if (spec) then
        for k, v in pairs(spec) do
            if (isNpc(v) and getCreatureName(v) == hypnoName) then
                return
            end
        end
    end

    doSendDistanceShoot(getNpcPos(), hypnoPos, PROJECTILE_POKEBALL)
    doSendMagicEffect(hypnoPos, EFFECT_POKEBALL_USE)
    return doCreateNpc(hypnoName, hypnoPos, false)
end

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink()	npcHandler:onThink() end

function creatureSayCallback(cid, type, msg)
	if(not npcHandler:isFocused(cid)) then
		return false
	end

	local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid

    if (msgcontains(msg, 'tm')) then
        if (not getPlayerDefeatedNPC(cid, getNpcName())) then
            selfSay("You must defeat me before receive your reward.", cid)

        elseif (getCreatureStorage(cid, TM_STORAGE) == QUEST_STATUS.FINISHED) then
            selfSay("You already got this reward.", cid)

        else
            giveTm(cid)
            selfSay("Oh, here is!", cid)
        end

    elseif ((msgcontains(msg, 'dream') or msgcontains(msg, 'sonho')) and getCreatureStorage(cid, 8474) == QUEST_STATUS.STARTED) then
        local psychicFound = false
        for _, ball in pairs(getPlayerAllBallsWithPokemon(cid)) do
            if (table.find(getPokemonTypes(nil, getBallPokemonName(ball.uid)), ELEMENT_PSYCHIC)) then
                psychicFound = true
                break
            end
        end

        if (not psychicFound) then
            selfSay("You need at least one Psychic-type Pokemon to do this!", cid)
            return true
        end

        local function sendPlayerToDreamWorld(cid, hypno)
            local spec = getSpectators({x = 5093, y = 483, z = 7}, 32, 31)
            if (spec) then
                for k, v in pairs(spec) do
                    if (isPlayer(v)) then
                        selfSay("There are someone doing this right now, please try again later.", cid)
                        return true
                    end
                end
            end

            if (spec) then
                for k, v in pairs(spec) do
                    if (isNpc(v)) then
                        doRemoveCreature(v)
                    end
                end
            end

            local unowns = {
                {pos = {x = 5105, y = 467, z = 7}, name = "Dream World Unown M"},
                {pos = {x = 5082, y = 481, z = 7}, name = "Dream World Unown A"},
                {pos = {x = 5099, y = 483, z = 7}, name = "Dream World Unown R"},
                {pos = {x = 5108, y = 496, z = 7}, name = "Dream World Unown S"},
                {pos = {x = 5077, y = 497, z = 7}, name = "Dream World Unown H"}
            }
            for _, unown in pairs(unowns) do
                doCreateNpc(unown.name, unown.pos, false)
            end

            local dest = {x = 5114, y = 467, z = 7}
            doSendMagicEffect(getCreaturePosition(cid), EFFECT_NIGHT_SHADE)
            doTeleportThing(cid, dest)
            doSendMagicEffect(dest, EFFECT_NIGHT_SHADE)
            setPlayerBlockLogout(cid, true)
            doRemoveCreature(hypno)
        end

        local hypno = doSummonSabrinaHypno()
        doCreatureAddStatus(cid, CREATURE_STATUS_SLEEP)

        addEvent(sendPlayerToDreamWorld, 1000, cid, hypno)

    elseif (getPlayerDefeatedNPC(cid, getNpcName())) then
        npcHandler.talkState[talkUser] = doQuestTalk(cid, getNpcName(), msg, npcHandler.talkState[talkUser])

    elseif (msgcontains(msg, 'battle') or msgcontains(msg, 'fight') or msgcontains(msg, 'duel')) then
        talkState[talkUser] =  npcBattle:doTalkStart(getNpcId(), cid)

    elseif(msgcontains(msg, 'yes') or msgcontains(msg, 'sim')) then
        talkState[talkUser] =  npcBattle:doTalkEnd(getNpcId(), cid, talkState[talkUser])

    else
        selfSay("Ok..", cid)
    end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
