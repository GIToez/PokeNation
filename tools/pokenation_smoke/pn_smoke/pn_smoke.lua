-- PokeNation client smoke test. Drives the normal login UI (EnterGame -> CharacterList -> game)
-- against a local PSoul server and logs every protocol milestone as "[pn-smoke] ..." lines.
-- "[pn-smoke] SHOT <name>" asks the runner to take a screenshot; "[pn-smoke] RESULT PASS|FAIL"
-- ends the run. Configuration comes from environment variables set by the runner:
--   PN_SMOKE_ACCOUNT, PN_SMOKE_PASSWORD, PN_SMOKE_CHARACTER, PN_SMOKE_LOCALE (en|pt|es),
--   PN_SMOKE_MARKET=1 (market round trip; GM character, seeded depot and balance)
--   PN_SMOKE_SHOP=1 (PokeNation Shop round trip; accounts.soulcoins seeded to 20)
--   PN_SMOKE_POKEMON=1 (Pokemon UI round trip; GM character with a team, Rattata ball_counter seeded)

PNSmoke = {}

local cfg = {
    account = os.getenv('PN_SMOKE_ACCOUNT') or 'admin',
    password = os.getenv('PN_SMOKE_PASSWORD') or 'admin',
    character = os.getenv('PN_SMOKE_CHARACTER') or 'Tester',
    locale = os.getenv('PN_SMOKE_LOCALE'),
    market = os.getenv('PN_SMOKE_MARKET') == '1',
    shop = os.getenv('PN_SMOKE_SHOP') == '1',
    pokemon = os.getenv('PN_SMOKE_POKEMON') == '1'
}

local checks = {}
local counters = { pokemonBarAdd = 0, pokemonMoves = 0, pokedexStatus = 0, creatures = 0, ownSummons = 0 }
local finished = false
local startPos
local hasPoll = false
local pollContinue

local function log(fmt, ...)
    g_logger.info('[pn-smoke] ' .. string.format(fmt, ...))
end

local function check(name, ok, detail)
    checks[#checks + 1] = { name = name, ok = ok }
    log('CHECK %s %s%s', ok and 'PASS' or 'FAIL', name, detail and (' (' .. detail .. ')') or '')
end

local function finish()
    if finished then
        return
    end
    finished = true
    local failed = 0
    for _, c in ipairs(checks) do
        if not c.ok then
            failed = failed + 1
        end
    end
    log('RESULT %s %d/%d checks passed', failed == 0 and #checks > 0 and 'PASS' or 'FAIL', #checks - failed, #checks)
    scheduleEvent(function() g_app.exit() end, 500)
end

local function fail(reason)
    check('run', false, reason)
    finish()
end

-- Reads the GL framebuffer of the next frame into the user write dir; the runner collects it.
local LOGIN_BOX_TITLES = { ['Message of the day'] = true, ['For Your Information'] = true }

-- The MOTD / login advice boxes are created by displayInfoBox with generated ids and would cover every later screenshot.
local function closeLoginBoxes()
    for _, child in ipairs(g_ui.getRootWidget():getChildren()) do
        if child:getStyleName() == 'MessageBoxWindow' and child.title and LOGIN_BOX_TITLES[child.title:getText()] then
            log('closing message box "%s"', child.title:getText())
            child:destroy()
        end
    end
end

local function shot(name)
    if name ~= '03-world' then
        closeLoginBoxes()
    end
    g_app.doScreenshot('/pn-smoke-' .. name .. '.png')
    log('SHOT %s', name)
end

local function onCharacterListCreated(characters, account)
    log('charlist: %d characters, premDays=%s, hasPoll=%s', #characters, tostring(account.premDays), tostring(account.hasPoll))
    local found
    for _, c in ipairs(characters) do
        log('  %s world=%s %s:%d level=%s vocation=%s looktype=%s team=%d', c.name, c.worldName, c.worldIp, c.worldPort,
            tostring(c.level), tostring(c.vocation), tostring(c.outfit and c.outfit.type), c.pokemonTeam and #c.pokemonTeam or -1)
        if c.name == cfg.character then
            found = c
        end
    end
    check('charlist parsed with PSoul extras', found ~= nil and found.level ~= nil and found.outfit ~= nil and found.pokemonTeam ~= nil)
    check('charlist poll flag read', account.hasPoll ~= nil)
    hasPoll = account.hasPoll == true
    if not found then
        return fail('character ' .. cfg.character .. ' not in list')
    end
    scheduleEvent(function() shot('02-charlist') end, 1000)
    scheduleEvent(function()
        CharacterList.doLogin()
    end, 2500)
end

-- Only when the character list announced a poll: 0xFA request -> 0xFF 0x18 window -> 0xFB vote.
local function pollStep(nextStep)
    if not hasPoll then
        return nextStep()
    end
    pollContinue = nextStep
    g_game.requestPollWindow()
    scheduleEvent(function()
        if pollContinue then
            check('0xFA poll request answered by 0xFF 0x18', false, 'no poll window within 4 s')
            pollContinue = nil
            nextStep()
        end
    end, 4000)
end

local function onPollWindow(question, options)
    if not pollContinue then
        return
    end
    local nextStep = pollContinue
    pollContinue = nil
    check('0xFA poll request answered by 0xFF 0x18', type(question) == 'string' and question ~= '', question)
    if type(options) == 'table' then
        local firstId
        for id, text in pairs(options) do
            log('poll option %d: %s', id, text)
            if not firstId or id < firstId then
                firstId = id
            end
        end
        log('POLL VOTE option %s', tostring(firstId))
        check('0xFB poll vote sent', firstId ~= nil and g_game.doPollVote(firstId))
    else
        log('POLL VOTE text')
        check('0xFB poll text vote sent', g_game.doPollVoteText('pn-smoke text vote'))
    end
    scheduleEvent(nextStep, 1500)
end

-- Market round trip. Expects the seed from PHASE_3_TEST_MATRIX.md C-14: balance 12345 and
-- 5 red apples (client id 3585, has a ware id) in depot 0.
local MARKET_ITEM = 3585
local MARKET_PRICE = 150
local MARKET_FEE = 20 -- server minimum fee (Game::playerCreateMarketOffer)
local MARKET_BALANCE = 12345
local OWN_OFFERS = 0xFFFE
local market = {}

local function marketFinish()
    local nextStep = market.next
    market = {}
    g_game.leaveMarket()
    scheduleEvent(nextStep, 1500)
end

local function marketStep(nextStep)
    if not cfg.market then
        return nextStep()
    end
    market = { stage = 'enter', next = nextStep }
    local npcPresent = false
    for _, creature in ipairs(g_map.getSpectators(g_game.getLocalPlayer():getPosition(), false)) do
        if creature:getName() == 'Jaron Jewell' then
            npcPresent = true
        end
    end
    if not npcPresent then
        g_game.talk('/n Jaron Jewell')
    end
    scheduleEvent(function() g_game.talk('hi') end, 1500)
    -- After the greeting the conversation continues in the NPC channel.
    scheduleEvent(function() g_game.talkChannel(MessageModes.NpcTo, 0, 'market') end, 3500)
    scheduleEvent(function()
        if market.stage then
            check('market round trip', false, 'stuck at stage ' .. market.stage)
            marketFinish()
        end
    end, 20000)
end

local function onMarketEnter(items, offerCount, balance, vocation)
    if not market.stage then
        return
    end
    local apples = 0
    for _, item in ipairs(items) do
        if item[1] == MARKET_ITEM then
            apples = item[2]
        end
    end
    log('market enter: balance=%s offers=%d depotItems=%d apples=%d vocation=%s', tostring(balance), offerCount, #items, apples, tostring(vocation))
    if market.stage == 'enter' then
        check('0xF6 market enter (U64 balance, depot items)', balance == MARKET_BALANCE and apples == 5,
            string.format('balance %s, %d apples', tostring(balance), apples))
        shot('05-market')
        market.stage = 'create'
        g_game.createMarketOffer(0, MARKET_ITEM, 0, 1, MARKET_PRICE, 0)
    elseif market.stage == 'create' then
        market.createBalance = balance
    elseif market.stage == 'cancel' then
        check('0xF7 cancel offer: price refunded', balance == MARKET_BALANCE - MARKET_FEE, 'balance ' .. tostring(balance))
        marketFinish()
    end
end

-- intOffers rows: { action, amount, counter, itemId, price, state, timestamp, var, itemTier }
local function onMarketBrowse(intOffers, names)
    if not market.stage then
        return
    end
    log('market browse: %d offers', #intOffers)
    for i, o in ipairs(intOffers) do
        log('  offer action=%d amount=%d itemId=%d price=%d var=%d player=%s', o[1], o[2], o[4], o[5], o[8], tostring(names[i]))
    end
    local function find(var)
        for _, o in ipairs(intOffers) do
            if o[1] == 0 and o[4] == MARKET_ITEM and o[5] == MARKET_PRICE and o[2] == 1 and (var == nil or o[8] == var) then
                return o
            end
        end
    end
    if market.stage == 'create' then
        check('0xF6 create offer (U32 price) answered by 0xF6 + 0xF9', find(MARKET_ITEM) ~= nil and
            market.createBalance == MARKET_BALANCE - MARKET_PRICE - MARKET_FEE, 'balance ' .. tostring(market.createBalance))
        market.stage = 'own'
        g_game.browseMarket(0, OWN_OFFERS, 0)
    elseif market.stage == 'own' then
        local offer = find(OWN_OFFERS)
        check('0xF5 browse own offers answered by 0xF9', offer ~= nil)
        if not offer then
            return marketFinish()
        end
        market.stage = 'cancel'
        g_game.cancelMarketOffer(offer[7], offer[3])
    end
end

-- PokeNation Shop round trip (extended opcode 201). Expects accounts.soulcoins = SHOP_BALANCE
-- for the smoke account (the runner seeds it with PN_SMOKE_SHOP=1).
local SHOP_BALANCE = 20
local function shopStep(nextStep)
    if not cfg.shop then
        return nextStep()
    end
    local shop = modules.game_shop
    if not shop then
        check('PokeNation Shop module loaded', false)
        return nextStep()
    end
    shop.show()
    local steps = {
        function()
            local s = shop.getState()
            log('shop: catalog=%s offers=%d balance=%d', tostring(s.catalogLoaded), s.offerCount, s.balance)
            check('opcode 201 fetch answered by catalog + balance', s.catalogLoaded and s.offerCount >= 8 and s.balance == SHOP_BALANCE,
                string.format('%d offers, balance %d', s.offerCount, s.balance))
            shop.selectOfferById('stamina_recover')
            shot('06-shop')
        end,
        function()
            shop.purchase('stamina_recover', 1)
        end,
        function()
            local s = shop.getState()
            check('opcode 201 purchase charged by server', s.balance == SHOP_BALANCE - 1 and s.lastMessage and s.lastMessage.type == 'info',
                string.format('balance %d, %s', s.balance, s.lastMessage and s.lastMessage.text or 'no message'))
            shot('07-shop-purchase')
            shop.purchase('stamina_recover', 999)
        end,
        function()
            local s = shop.getState()
            check('opcode 201 invalid quantity rejected', s.balance == SHOP_BALANCE - 1 and s.lastMessage and s.lastMessage.type == 'error',
                s.lastMessage and s.lastMessage.text or 'no message')
            shop.purchase('tibia_coins', 1)
        end,
        function()
            local s = shop.getState()
            check('opcode 201 unknown product rejected', s.balance == SHOP_BALANCE - 1 and s.lastMessage and s.lastMessage.type == 'error',
                s.lastMessage and s.lastMessage.text or 'no message')
            shop.requestHistory()
        end,
        function()
            local s = shop.getState()
            check('opcode 201 history lists the purchase', s.historyCount >= 1, s.historyCount .. ' entries')
            shot('08-shop-history')
            shop.closeMessage()
            shop.hide()
        end
    }
    local function run(i)
        if i > #steps then
            return scheduleEvent(nextStep, 1000)
        end
        steps[i]()
        scheduleEvent(function() run(i + 1) end, 2500)
    end
    scheduleEvent(function() run(1) end, 2500)
end

-- Pokemon UI round trip on a character with a team (GM Admin): team bar, summon, move bar,
-- move details, combat against a GM-spawned wild Pokemon, catch, Pokemon details, Pokedex, return.
-- Catching needs ball_counter tries for Rattata (#19); the runner seeds them with PN_SMOKE_POKEMON=1.
local EMPTY_POKEBALL_CLIENT_ID = 11118 -- server item 12157 (empty poke ball)
local WILD_POKEMON = 'Rattata'
local LEVEL_UP_TARGET = 'Magikarp' -- harmless; one kill levels the level-1 Rattata created by /mypokemon
local POTION_CLIENT_ID = 11205 -- server item 12244 (Pokemon Health Potion)
local TM_SERVER_ID, TM_CLIENT_ID = 29170, 27925 -- TM Facade: every Pokemon from level 40 can learn it
local recentTexts = {}

local function sequence(steps, done)
    local function run(i)
        if i > #steps then
            return done()
        end
        local delay = steps[i]() or 2500
        scheduleEvent(function() run(i + 1) end, delay)
    end
    run(1)
end

local function findWild(name)
    name = name or WILD_POKEMON
    for _, creature in ipairs(g_map.getSpectators(g_game.getLocalPlayer():getPosition(), false)) do
        if creature:getName():find('^' .. name) and not creature:isLocalPlayerSummon() and not creature:isPlayer() then
            return creature
        end
    end
end

local function textSeen(pattern)
    for _, text in ipairs(recentTexts) do
        if text:find(pattern) then
            return true
        end
    end
    return false
end

local function pokemonStep(nextStep)
    if not cfg.pokemon then
        return nextStep()
    end
    local bar, movesModule = modules.game_pokebar, modules.game_pokemoves
    if not bar or not movesModule then
        check('Pokemon UI modules loaded', false)
        return nextStep()
    end
    local summoned, wild, wildPos, teamBefore, switchedTo, levelSlot
    local caught = false
    local sawCooldown = false
    local catchTries = 0

    local function slotByName(name)
        for _, slot in ipairs(bar.getSlots()) do
            if slot.name == name and not slot.fainted then
                return slot
            end
        end
    end

    -- Containers (corpses) near the last position of the wild Pokemon, closest first.
    local function findCorpse()
        if not wildPos then
            return nil
        end
        for radius = 0, 2 do
            for dx = -radius, radius do
                for dy = -radius, radius do
                    if math.max(math.abs(dx), math.abs(dy)) == radius then
                        local tile = g_map.getTile({ x = wildPos.x + dx, y = wildPos.y + dy, z = wildPos.z })
                        local thing = tile and tile:getTopUseThing()
                        if thing and thing:isItem() and thing:isContainer() then
                            return thing
                        end
                    end
                end
            end
        end
    end

    local function fight(done, name, timeoutMs)
        local deadline = g_clock.millis() + (timeoutMs or 25000)
        local index = 0
        local function hit()
            local creature = findWild(name)
            if not creature or creature:isDead() or creature:getHealthPercent() <= 0 then
                return scheduleEvent(done, 1500)
            end
            wildPos = creature:getPosition()
            if g_clock.millis() > deadline then
                return done()
            end
            if g_game.getAttackingCreature() ~= creature then
                g_game.attack(creature)
            end
            local moves = movesModule.getMoves()
            index = index % math.max(1, #moves) + 1
            movesModule.useMove(index)
            scheduleEvent(function()
                local move = movesModule.getMoves()[index]
                if move and move.cooldown > 0 then
                    sawCooldown = true
                end
            end, 600)
            scheduleEvent(hit, 1200)
        end
        hit()
    end

    local function catchLoop(done)
        -- Each ball is a 1-in-2 roll for the seeded Rattata, so 10 tries make a false failure ~0.1% likely.
        if caught or catchTries >= 10 then
            return done()
        end
        catchTries = catchTries + 1
        recentTexts = {}
        PokeNation.say('/m ' .. WILD_POKEMON)
        scheduleEvent(function()
            wild = findWild()
            if not wild then
                local names = {}
                for _, creature in ipairs(g_map.getSpectators(g_game.getLocalPlayer():getPosition(), false)) do
                    names[#names + 1] = creature:getName()
                end
                log('catch try %d: no wild %s among %s', catchTries, WILD_POKEMON, table.concat(names, ', '))
                return catchLoop(done)
            end
            wildPos = wild:getPosition()
            fight(function()
                local corpse = findCorpse()
                log('catch try %d: corpse=%s at %d,%d,%d', catchTries, corpse and tostring(corpse:getId()) or 'none',
                    wildPos.x, wildPos.y, wildPos.z)
                if catchTries == 1 then
                    shot('12-combat')
                end
                if corpse then
                    g_game.useInventoryItemWith(EMPTY_POKEBALL_CLIENT_ID, corpse)
                end
                scheduleEvent(function()
                    caught = textSeen('Gotcha!')
                    if catchTries == 1 or caught then
                        shot(caught and '13-catch' or '13-catch-miss')
                    end
                    catchLoop(done)
                end, 7000)
            end)
        end, 2000)
    end

    sequence({
        function()
            if not slotByName('Venusaur') then
                PokeNation.say('/mypokemon Venusaur,100')
            end
            scheduleEvent(function() PokeNation.say('/mypokemon Rattata,1') end, 1500)
            return 4000
        end,
        function()
            local console = modules.game_console
            if console and console.channelsWindow then
                console.channelsWindow:destroy()
                console.channelsWindow = nil
            end
            local slots = bar.getSlots()
            teamBefore = #slots
            for _, slot in ipairs(slots) do
                log('team slot fastcall=%d %s text=%s fainted=%s', slot.fastcall, slot.name, tostring(slot.text), tostring(slot.fainted))
            end
            check('team bar shows the team (0xFF 0x04)', #slots > 0 and bar.getWidget():isVisible(), #slots .. ' slots')
            local values = modules.game_pokenation_hud and modules.game_pokenation_hud.getValues()
            if values then
                log('hud: health=%s energy=%s levels=%s respect=%s balls=%s', values.health, values.energy, values.levels, values.respect, values.balls)
            end
            shot('10-teambar')
            summoned = slotByName('Venusaur')
            levelSlot = slotByName('Rattata')
            if not summoned then
                check('summon', false, 'no healthy Pokemon')
                return 500
            end
            bar.summon(summoned.fastcall)
            return 3500
        end,
        function()
            local moves = movesModule.getMoves()
            local own = 0
            for _, creature in ipairs(g_map.getSpectators(g_game.getLocalPlayer():getPosition(), false)) do
                if creature:isLocalPlayerSummon() then
                    own = own + 1
                end
            end
            check('/cp summon marks the slot in use (0xFF 0x06)', summoned and bar.getInUse() == summoned.fastcall and own == 1,
                string.format('inUse=%s ownSummons=%d', tostring(bar.getInUse()), own))
            check('move bar filled (0xFF 0x01)', #moves > 0 and movesModule.getWidget():isVisible(), #moves .. ' moves')
            for i, move in ipairs(moves) do
                log('move %d icon=%d %s key=%s', i, move.iconId, move.name, tostring(move.key))
            end
            movesModule.requestDetails(1)
            shot('11-summoned')
        end,
        function()
            local move = movesModule.getMoves()[1]
            check('/sd move details parsed into the tooltip', move ~= nil and move.info ~= nil,
                move and move.info and move.info.summary:gsub('\n', '; ') or 'no answer')
            bar.requestDetails(summoned.fastcall)
        end,
        function()
            local details = modules.game_pokemondetails and modules.game_pokemondetails.getLast()
            check('/pd Pokemon details window', details ~= nil and details.species ~= nil,
                details and string.format('%s lv %s', tostring(details.species), tostring(details.level)) or 'no answer')
            shot('14-details')
            local window = modules.game_pokemondetails and modules.game_pokemondetails.getWindow()
            if window then
                window:hide()
            end
            return 1000
        end,
        function()
            catchLoop(function()
                local slots = bar.getSlots()
                check('combat: used move shows its cooldown (0xFF 0x09)', sawCooldown)
                check('catch: wild Pokemon caught and added to the team bar', caught and #slots == teamBefore + 1,
                    string.format('%d tries, team %d -> %d', catchTries, teamBefore, #slots))
                sequence({
                    function()
                        local entry = g_ui.getRootWidget():recursiveGetChildById('dex19')
                        modules.game_pokedex.show()
                        if entry and entry.onClick then
                            entry.onClick(entry)
                        else
                            PokeNation.say('/dv 19')
                        end
                        return 3000
                    end,
                    function()
                        local s = modules.game_pokedex.getState()
                        check('/dv Pokedex entry shown (0xFF 0x11)', s.visible and s.selected == 19 and s.name == WILD_POKEMON,
                            string.format('%s, %d entries, %d seen, %d caught, %d moves', s.name, s.entries, s.seen, s.caught, s.moves))
                        shot('15-pokedex')
                        modules.game_pokedex.hide()
                        bar.toggle(summoned.fastcall)
                        return 3000
                    end,
                    function()
                        check('ball-slot use returns the Pokemon and dims the move bar', bar.getInUse() == nil and not movesModule.isActive(),
                            'inUse=' .. tostring(bar.getInUse()))
                        shot('16-returned')
                        PokeNation.say('/i ' .. TM_SERVER_ID)
                        return 2000
                    end,
                    function()
                        local ball = g_game.getLocalPlayer():getInventoryItem(InventorySlotFeet)
                        if ball then
                            g_game.useInventoryItemWith(TM_CLIENT_ID, ball)
                        end
                        return 3000
                    end,
                    function()
                        local tm = modules.game_tmchoose
                        local state = tm.getState()
                        check('TM chooser opened (0xFF 0x0D)', state.visible and state.moves > 0 and state.tm ~= nil,
                            string.format('%d moves, tm icon %s', state.moves, tostring(state.tm)))
                        local first = tm.getWindow():getChildById('moves'):getChildren()[1]
                        if first and first.onClick then
                            first.onClick(first)
                        end
                        shot('17-tm-confirm')
                        tm.cancel()
                        tm.cancel()
                        check('TM chooser cancel closes without /tc', not tm.getState().visible)
                        switchedTo = levelSlot and levelSlot.fastcall
                        if switchedTo then
                            bar.toggle(switchedTo)
                        end
                        return 4000
                    end,
                    function()
                        check('/cp summon the level 1 Pokemon', switchedTo ~= nil and bar.getInUse() == switchedTo and #movesModule.getMoves() > 0,
                            string.format('inUse=%s, %d moves', tostring(bar.getInUse()), #movesModule.getMoves()))
                        shot('18-caught-summoned')
                        for _, creature in ipairs(g_map.getSpectators(g_game.getLocalPlayer():getPosition(), false)) do
                            if creature:isLocalPlayerSummon() then
                                g_game.useInventoryItemWith(POTION_CLIENT_ID, creature)
                            end
                        end
                        return 2500
                    end,
                    function()
                        local statuses = modules.game_statusbar.getStatuses()
                        check('potion status icon with countdown (0xFF 0x0E)', #statuses > 0,
                            #statuses > 0 and string.format('%s, %ds', tostring(statuses[1].name), statuses[1].remaining) or 'none')
                        local statusPanel = modules.game_statusbar.getWidget()
                        local rect = statusPanel:getRect()
                        check('status icon drawn', statusPanel:isVisible() and rect.width > 0 and rect.height > 0,
                            string.format('%dx%d at %d,%d', rect.width, rect.height, rect.x, rect.y))
                        shot('19-statusbar')
                        recentTexts = {}
                        PokeNation.say('/autoloot')
                        return 2000
                    end,
                    function()
                        if textSeen('Auto Loot OFF') then
                            PokeNation.say('/autoloot')
                        end
                        recentTexts = {}
                        PokeNation.say('/m ' .. LEVEL_UP_TARGET)
                        return 2000
                    end,
                    function()
                        fight(function()
                            local corpse = findCorpse()
                            if corpse then
                                g_game.use(corpse)
                            end
                            scheduleEvent(function()
                                local loot = modules.game_lootlist.getState()
                                check('autoloot list strip (0xFF 0x1A)', loot.received > 0, loot.received .. ' entries')
                                local levelUp = modules.game_advanceeffect.getLastPokemonLevelUp()
                                check('Pokemon level-up popup (0xFF 0x19)', levelUp ~= nil,
                                    levelUp and string.format('#%s level %s, %s new moves', tostring(levelUp.number), tostring(levelUp.level), tostring(levelUp.moves)) or 'no level-up')
                                shot('21-loot')
                                PokeNation.say('/autoloot')
                                bar.toggle(bar.getInUse())
                                scheduleEvent(function()
                                    check('caught Pokemon returned', bar.getInUse() == nil)
                                    shot('22-returned')
                                    nextStep()
                                end, 3000)
                            end, 1200)
                        end, LEVEL_UP_TARGET, 60000)
                        return 1
                    end
                }, function() end)
            end)
            return 1
        end
    }, function() end)
end

local function afterWorld()
    local player = g_game.getLocalPlayer()
    startPos = player:getPosition()
    log('in world as %s at %d,%d,%d health=%d/%d level=%d', player:getName(), startPos.x, startPos.y, startPos.z,
        player:getHealth(), player:getMaxHealth(), player:getLevel())
    check('local player placed', startPos.x > 0)

    local spectators = g_map.getSpectators(startPos, false)
    for _, creature in ipairs(spectators) do
        counters.creatures = counters.creatures + 1
        if creature:isLocalPlayerSummon() then
            counters.ownSummons = counters.ownSummons + 1
        end
    end
    log('spectators=%d ownSummons=%d', counters.creatures, counters.ownSummons)
    check('creature descriptions parsed', counters.creatures >= 1)
    shot('03-world')
    closeLoginBoxes()

    g_game.requestChannels()
    g_game.requestQuestLog()

    -- Try each direction until the server moves the player (the tile next to the spawn may be blocked).
    local directions = { South, East, North, West }
    local function tryWalk(i)
        if i > #directions then
            check('walk accepted by server', false, 'no direction moved the player')
            return scheduleEvent(PNSmoke.logout, 500)
        end
        local before = g_game.getLocalPlayer():getPosition()
        g_game.walk(directions[i])
        scheduleEvent(function()
            local pos = g_game.getLocalPlayer():getPosition()
            log('walk %d: %d,%d,%d -> %d,%d,%d', directions[i], before.x, before.y, before.z, pos.x, pos.y, pos.z)
            if pos.x ~= before.x or pos.y ~= before.y then
                check('walk accepted by server', true, 'direction ' .. directions[i])
                shot('04-after-walk')
                scheduleEvent(function() pollStep(function() marketStep(function() shopStep(function() pokemonStep(PNSmoke.logout) end) end) end) end, 2500)
            else
                tryWalk(i + 1)
            end
        end, 1200)
    end
    scheduleEvent(function() tryWalk(1) end, 2500)
end

function PNSmoke.logout()
    log('pokemonBarAdd=%d pokemonMoves=%d pokedexStatus=%d', counters.pokemonBarAdd, counters.pokemonMoves, counters.pokedexStatus)
    g_game.safeLogout()
end

local handlers = {
    onGameStart = function()
        log('onGameStart: feature GamePSoulProtocol=%s wire=%d protocol=%d client=%d os=%d', tostring(g_game.getFeature(GamePSoulProtocol)),
            g_game.getWireProtocolVersion(), g_game.getProtocolVersion(), g_game.getClientVersion(), g_game.getOs())
        check('PSoul profile active', g_game.getFeature(GamePSoulProtocol) and g_game.getWireProtocolVersion() == 312)
        scheduleEvent(afterWorld, 3000)
    end,
    onGameEnd = function()
        log('onGameEnd')
        check('logout', true)
        finish()
    end,
    onExtendedOpcodeEnabled = function()
        check('ACTIVATE (extended opcode 0) received', true)
    end,
    onLightHour = function(minutes)
        check('login light hour read', minutes >= 0 and minutes < 24 * 60, tostring(minutes))
    end,
    onChannelList = function(channels)
        check('0xAB channel list (U16 count)', #channels > 0, #channels .. ' channels')
    end,
    onPokemonBarAdd = function() counters.pokemonBarAdd = counters.pokemonBarAdd + 1 end,
    onPokemonMoves = function() counters.pokemonMoves = counters.pokemonMoves + 1 end,
    onPokedexStatus = function(status)
        counters.pokedexStatus = counters.pokedexStatus + 1
        log('pokedex status entries=%d', #status)
    end,
    onQuestLog = function(quests)
        check('0xF0 quest log', true, #quests .. ' quests')
        if #quests > 0 then
            g_game.requestQuestLine(quests[1][1])
        end
    end,
    onQuestLine = function(questId, missions)
        check('0xF1 quest line', true, string.format('quest %d, %d missions', questId, #missions))
    end,
    onPollWindow = onPollWindow,
    onPokemonLevelUp = function(number, level, moves)
        log('pokemon level-up #%d level %d, %d moves', number, level, #moves)
        scheduleEvent(function()
            local popup = modules.game_advanceeffect.getPopup('pokemon')
            local rect = popup and popup:getRect()
            check('Pokemon level-up popup drawn', popup ~= nil and popup:isVisible() and rect.height > 0 and rect.width > 0,
                rect and string.format('%dx%d at %d,%d, opacity %.2f', rect.width, rect.height, rect.x, rect.y, popup:getOpacity()) or 'no popup')
            shot('20-levelup')
        end, 1200)
    end,
    onMarketEnter = onMarketEnter,
    onTalk = function(name, level, mode, text)
        if market.stage then
            log('talk %s: %s', tostring(name), tostring(text))
        end
    end,
    onTextMessage = function(mode, text)
        if cfg.pokemon then
            recentTexts[#recentTexts + 1] = text
            log('text message %d: %s', mode, tostring(text):gsub('\n', ' | '))
        elseif market.stage then
            log('text message %d: %s', mode, tostring(text))
        end
    end,
    onMarketBrowse = onMarketBrowse,
    onLoginError = function(msg)
        fail('login error: ' .. tostring(msg))
    end
}

local originalCreate

function PNSmoke.init()
    log('starting: account=%s character=%s', cfg.account, cfg.character)
    connect(g_game, handlers)

    originalCreate = CharacterList.create
    CharacterList.create = function(characters, account, otui)
        originalCreate(characters, account, otui)
        onCharacterListCreated(characters, account)
    end

    g_settings.set('last-used-character', cfg.character)
    g_settings.set('last-used-world', 'Cristal')

    scheduleEvent(function()
        local locales = modules.client_locales
        if locales then
            -- First run shows a language picker; close it without the module reload it triggers.
            if locales.localesWindow then
                locales.localesWindow:destroy()
                locales.localesWindow = nil
            end
            locales.setLocale(cfg.locale or 'en')
        end
        if not (modules.client_entergame and EnterGame) then
            return fail('client_entergame not loaded')
        end
        local root = g_ui.getRootWidget()
        root:recursiveGetChildById('accountNameTextEdit'):setText(cfg.account)
        root:recursiveGetChildById('accountPasswordTextEdit'):setText(cfg.password)
        shot('01-login')
        scheduleEvent(function() EnterGame.doLogin() end, 2500)
    end, 3000)

    scheduleEvent(function()
        if not finished then
            fail('timeout')
        end
    end, cfg.pokemon and 300000 or 180000)
end

function PNSmoke.terminate()
    disconnect(g_game, handlers)
    if originalCreate then
        CharacterList.create = originalCreate
    end
end
