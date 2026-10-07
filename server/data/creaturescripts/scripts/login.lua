local energyRegenCondition = createConditionObject(CONDITION_REGENERATION, -1, nil, 1000)
setConditionParam(energyRegenCondition, CONDITION_PARAM_MANAGAIN, 5)
setConditionParam(energyRegenCondition, CONDITION_PARAM_MANATICKS, 2000)

local voltagicEnergyRegenCondition = createConditionObject(CONDITION_REGENERATION, -1, nil, 1000)
setConditionParam(voltagicEnergyRegenCondition, CONDITION_PARAM_MANAGAIN, 10)
setConditionParam(voltagicEnergyRegenCondition, CONDITION_PARAM_MANATICKS, 2000)

local lowLevelEnergyRegenCondition = createConditionObject(CONDITION_REGENERATION, -1, nil, 1000)
setConditionParam(lowLevelEnergyRegenCondition, CONDITION_PARAM_MANAGAIN, 25)
setConditionParam(lowLevelEnergyRegenCondition, CONDITION_PARAM_MANATICKS, 2000)

local invulnerableCondition = createConditionObject(CONDITION_INVULNERABLE, 4 * 1000)

local checkFirstAchievment = true
local loginMessage = getConfigValue('loginMessage')

local events = {"onDeath", "onKill", "onGainExperience", "onAddContainerItem", "onRemoveContainerItem",
"onPrepareDeath", "onTarget", "onJoinChannel", "onReportBug", "onTradeRequestAccept", "onStatisticChange",
"onQuestInfo", "Mail", "GuildMotd", "Idle", "onAdvance", "onTextEdit", "onTalkChannel", "onLeaveChannel", "onTournamentStart", "onStaminaChange", "onCustomOutfit"}

if (getBooleanFromString(getConfigValue('advancedSave'))) then
    events[#events + 1] = "AdvancedSave"
end

ONLINE_TUTORS = {}

function onLogin(cid)
	local accountManager = getPlayerAccountManager(cid)
	if(accountManager == MANAGER_NONE) then
		for _, v in pairs(events) do
            registerCreatureEvent(cid, v)
        end

        local lastLogin, str = getPlayerLastLoginSaved(cid), loginMessage
		if (lastLogin > 0) then
			doPlayerSendTextMessage(cid, MESSAGE_STATUS_DEFAULT, str)
			str = string.format(__L(cid, "Your last visit was %s ago, on %s."), table.concat(string.timediff(os.time() - lastLogin, cid)), os.date("%a %b %d %X %Y", lastLogin))
		else
			--if (not getPlayerUsingOtClient(cid)) then
			--	doPlayerPopupFYI(cid, "Bem vindo ao mundo de PSoul! Voc est prestes a iniciar sua\njornada em um divertido e misterioso mundo habitado por Pokemons!\n\nOs primeiros locais indicados para iniciar o treinamento do seus\nPokemons  atravs dos bueiros das cidades ou pescando prximo a\nrios com a vara de pesca que est em sua mochila.\n\nPara curar seus Pokemons, aproxime-se da Nurse Joy e diga 'hi'.\nEnquanto em batalhas voc pode utilizar poes de vida!\n\nVoc pode visitar o endereo http://www.psoul.net/blogCategories/1-tutorials para buscar guias!\n\nSinta-se  vontade para buscar ajuda tambm no canal 'Help' ou\n'Game-Chat', atravs do atalho Ctrl + O.\n\nBoa sorte em sua jornada!\n")
			--end
			--doPlayerPopupFYI(cid, "Welcome to the world of PSoul! You are about to start your journey\nin a fun and mysterious world inhabited by Pokemon!\n\nThe first sites listed to start training your Pokemon is through\nthe sewers of cities or near rivers fishing with a fishing rod\nthat is in your backpack.\n\nFor heal your Pokemon, approach the Nurse Joy and say 'hi'.\nWhile in battle you can use health potions!\n\nYou can visit http://www.psoul.net/blogCategories/1-tutorials to find guides!\nFeel free to also get help in the 'Help' or 'Game-Chat' channels\nusing the shortcut Ctrl + O.\n\nGood luck on your journey!\n")
			
			--str = str .. " Please choose your outfit."
			--doPlayerSendOutfitWindow(cid)
			-- Give start items
			if (getPlayerTown(cid) ~= 10 and getPlayerLevel(cid) == 1) then -- Isnt starting at beginner island
				local lockedBackpack = getPlayerItemById(cid, true, 13499)
				if (isItem(lockedBackpack)) then
					doTransformItem(lockedBackpack.uid, 12282)
				end
				doPlayerRemoveItem(cid, 13492, getPlayerItemCount(cid, 13492)) -- Empty Soul Ball
				doPlayerRemoveItem(cid, 13497, getPlayerItemCount(cid, 13497)) -- Special Small Stone

				--doPlayerAddMainItems(cid)
				--doCreatePokemonBall(cid, "soul", getPlayerFirstPokemon(cid), 5, nil, nil, 0, cid, false, 999999, nil, nil, nil, nil, nil, nil, nil,
				--	nil, nil, function(ball) setBallOriginalTrainer(ball, cid) end)
				doPlayerAddLevel(cid, 4)
				--setPlayerGotStarterPokemon(cid, true)
			else
				doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_ORANGE, "This is your first login on Pokenordic! Welcome! Remember that if you need help you can use the Help Channel (CTRL + O) and also our tutorials section")
				doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "You're in the Beginner Island, a place made for inexperienced players, please watch this tutorial before start playing.")
				doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_RED, "You are not required to stay on this island. Anytime you want to leave, go to Professor Tommy and talk about 'skip beginner island', even though you are no pokemon he will give you one.")
			end
			
			--doPlayerAddTownMarks(cid, getTownName(getPlayerTown(cid)))
			--doPlayerSendTip(cid, TIP_IDS.WELCOME)
			doSendPlayerExtendedOpcode(cid, EXTENDED_IDS.GAMEPLAY_TUTORIAL_TEXT, string.format(__L(cid, "Hello %s! Welcome to PSoul, a MMORPG loyal in the Pokemon series. You are boarding a world filled with many adventures and discoveries."), getCreatureName(cid)))
			doSendPlayerExtendedOpcode(cid, EXTENDED_IDS.GAMEPLAY_TUTORIAL_IMAGE, "keyboard")
			--addEvent(function(cid)
				--if (isCreature(cid)) then
					--doPlayerPopupFYI(cid, "Use the arrow keys on your keyboard to move your character. Say \"Hi\" at the Default channel to the character ahead to start a dialogue.")
				--end
			--end, 10000, cid)
			--if (getPlayerTown(cid) == 34) then -- Tutorial Island
				--addEvent(function(cid)
					--if (isCreature(cid)) then
						--doPlayerSendTip(cid, TIP_IDS.WALK_TALK)
					--end
				--end, 15000, cid)
			--end
        end
		
		if (getPlayerTown(cid) == 34) then
			registerCreatureEvent(cid, "gameplayTutorial_onKill")
		end
		
		if (getPlayerLevel(cid) < 30) then
			addEvent(function(cid)
				if (isCreature(cid)) then
					doPlayerOpenChannel(cid, CHANNEL_WIKI_CHAT)
					doPlayerOpenChannel(cid, CHANNEL_HELP)
				end
			end, 500, cid)
		end

		doPlayerSendTextMessage(cid, MESSAGE_STATUS_DEFAULT, "If you need some help use the Help and the Wiki Chat channels.")
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_DEFAULT, str)

        doPlayerRemoveFrontierBalls(cid)
		doPlayerRemoveEpicBalls(cid)
    setPlayerColosseumArenaPaid(cid, false)
        doPlayerReset(cid)

        if (not isPremium(cid)) then
            if (isSurfing(cid)) then
                setSurfingStatus(cid, false)
                doTeleportThing(cid, getTownTemplePosition(getPlayerTown(cid)))

            elseif (isFlying(cid)) then
                setFlyingStatus(cid, false)
                doTeleportThing(cid, getTownTemplePosition(getPlayerTown(cid)))
				
			elseif (isLevitating(cid)) then
                setLevitatingStatus(cid, false)
                doTeleportThing(cid, getTownTemplePosition(getPlayerTown(cid)))

            elseif (isDiving(cid)) then
                setDivingStatus(cid, false)
                doTeleportThing(cid, getTownTemplePosition(getPlayerTown(cid)))
            end

            if (isUnderwater(cid)) then
                OxygenMask.doPlayerUnlock(cid)
                setUnderwaterStatus(cid, false)
                doTeleportThing(cid, getTownTemplePosition(getPlayerTown(cid)))
            end
        end
		
		if (isRiding(cid) or isSurfing(cid) or isDiving(cid)) then
            doPlayerUpdateOutfit(cid)

		elseif (isFlying(cid) or isLevitating(cid)) then
			for i, unsetTilePosition in ipairs(getUnsetTilesArroundPosition(getCreaturePosition(cid))) do
				doCreateTileInPosition(VOID_TILE_ID, unsetTilePosition)
			end
			doPlayerUpdateOutfit(cid)
		end

        if (getPlayerMasteryDungeon(cid) > 0) then
            doTeleportThing(cid, getTownTemplePosition(getPlayerTown(cid)))
            setPlayerMasteryDungeon(cid, 0)
        end

        doExtraExpRateCheck(cid)
        doExtraLootRateCheck(cid)
        doExtraCatchRateCheck(cid)
        doExtraEggRateCheck(cid)
        ExpEvent.onLogin(cid)
        doAddCondition(cid, (doMasteryAdvantageCheck(cid, MASTERY_ADVANTAGES.PASSIVE_ENERGY_REGENERATION) and
                voltagicEnergyRegenCondition or (getPlayerLevel(cid) > 30 and energyRegenCondition or
                lowLevelEnergyRegenCondition)))

        local loss = getConfigValue('deathLostPercent')
        if(loss ~= nil) then
            doPlayerSetLossPercent(cid, PLAYERLOSS_EXPERIENCE, loss * 10)
        end

        doPlayerCheckTms(cid) -- TODO: Remove it after TS or no

        if (checkFirstAchievment) then
            addEvent(function(cid)
                if (isCreature(cid)) then
                    doPlayerAchievementCheck(cid, ACHIEVEMENT_IDS.SERVER_FIRST)
                end
                checkFirstAchievment = nil
            end, 500, cid)
        end

        doPlayerAchievementCheck(cid, ACHIEVEMENT_IDS.HOUSE)
        doPlayerAchievementCheck(cid, ACHIEVEMENT_IDS.PREMIUM_ACCOUNT)
        doPlayerAchievementCheck(cid, ACHIEVEMENT_IDS.JOIN_GUILD)
		if (not getTilePzInfo(getCreaturePosition(cid)) and not isGamemaster(cid)) then
			doAddCondition(cid, invulnerableCondition)
		end
		addEvent(function(cid) if (isCreature(cid)) then doPlayerSendWindowsData(cid) end end, 500, cid)
		
		if (getPlayerBlockLogout(cid)) then
			doTeleportThing(cid, TRADE_ROOM_POSITION, false)
            setPlayerBlockLogout(cid, false)
        end
		
		if (getPlayerAutoLootSave(cid)) then
			setPlayerAutoLoot(cid, true)
		end

	elseif(accountManager == MANAGER_NAMELOCK) then
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_ORANGE, "Hello, it appears that your character has been namelocked, what would you like as your new name?")

	elseif(accountManager == MANAGER_ACCOUNT) then
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_ORANGE, "Hello, type 'account' to manage your account and if you want to start over then type 'cancel'.")

	else
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_ORANGE, "Hello, type 'account' to create an account or type 'recover' to recover an account.")
	end

	if (not isPlayerGhost(cid, true)) then
		doSendMagicEffect(getCreaturePosition(cid), CONST_ME_TELEPORT)
	end
	
	if (isTutor(cid)) then
		ONLINE_TUTORS[getPlayerGUID(cid)] = true
	
	elseif (isGamemaster(cid)) then
		addEvent(function(cid)
			if (isCreature(cid)) then
				doPlayerOpenChannel(cid, CHANNEL_HELP)
				doPlayerOpenChannel(cid, CHANNEL_GAMECHAT_PTBR)
				doPlayerOpenChannel(cid, CHANNEL_GAMECHAT_ENUS)
				doPlayerOpenChannel(cid, CHANNEL_RULE_VIOLATIONS)
			end
		end, 500, cid)
	end

	return true
end
