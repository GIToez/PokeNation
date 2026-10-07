-- PokeNation Shop (Soul Coins). Wire format: docs/reference/OPCODES.md "POKENATION_SHOP".
-- The server owns the catalog, prices and balance; this module only displays them and sends
-- {action = "purchase", data = {id = productId, count = quantity}}.

local SHOP_OPCODE = ExtendedIds.PokeNationShop
local CURRENCY = "Soul Coins"
local SEARCH_CATEGORY = "Search Results"
local HISTORY_PER_PAGE = 25

local shopWindow = nil
local msgWindow = nil
local messageBox = nil
local selected = nil
local selectedOffer = nil

local catalogLoaded = false
local fetchPending = false
local balance = 0
local categories = {}
local offers = {}
local history = {}
local currentPage = 1
local totalPages = 1
local lastMessage = nil

local function sendRequest(action, data)
    local protocolGame = g_game.getProtocolGame()
    if not protocolGame or not protocolGame:isExtendedOpcodeEnabled() then
        return false
    end
    protocolGame:sendExtendedOpcode(SHOP_OPCODE, json.encode({ action = action, data = data or {} }))
    return true
end

local function requestCatalog()
    fetchPending = not sendRequest("fetch")
end

local function onExtendedOpcodeEnabled()
    if fetchPending and shopWindow and shopWindow:isVisible() then
        requestCatalog()
    end
end

function init()
    connect(g_game, { onGameStart = create, onGameEnd = destroy, onExtendedOpcodeEnabled = onExtendedOpcodeEnabled })
    ProtocolGame.registerExtendedOpcode(SHOP_OPCODE, onExtendedOpcode)
    if g_game.isOnline() then
        create()
    end
end

function terminate()
    disconnect(g_game, { onGameStart = create, onGameEnd = destroy, onExtendedOpcodeEnabled = onExtendedOpcodeEnabled })
    ProtocolGame.unregisterExtendedOpcode(SHOP_OPCODE, onExtendedOpcode)
    destroy()
end

function onExtendedOpcode(protocol, code, buffer)
    local ok, message = pcall(json.decode, buffer)
    if not ok or type(message) ~= "table" or type(message.action) ~= "string" then
        g_logger.warning("PokeNation Shop: malformed payload ignored")
        return
    end

    local data = message.data
    if message.action == "catalog" and type(data) == "table" then
        onCatalog(data)
    elseif message.action == "balance" and type(data) == "table" then
        onBalance(data)
    elseif message.action == "history" and type(data) == "table" then
        onHistory(data)
    elseif message.action == "msg" and type(data) == "table" then
        onMessage(data)
    else
        g_logger.warning("PokeNation Shop: unknown action '" .. message.action .. "' ignored")
    end
end

function create()
    if shopWindow then
        return
    end
    shopWindow = g_ui.displayUI("game_shop")
    shopWindow:hide()
end

function destroy()
    if shopWindow then
        shopWindow:destroy()
        shopWindow = nil
    end
    if msgWindow then
        msgWindow:destroy()
        msgWindow = nil
    end
    closeMessage()
    selected = nil
    selectedOffer = nil
    catalogLoaded = false
    fetchPending = false
    balance = 0
    categories = {}
    offers = {}
    history = {}
    lastMessage = nil
end

function show()
    if not shopWindow then
        return
    end
    if not catalogLoaded then
        requestCatalog()
    end
    hideHistory()
    shopWindow:show()
    shopWindow:raise()
    shopWindow:focus()
end

function hide()
    if shopWindow then
        shopWindow:hide()
    end
end

function toggle()
    if not shopWindow then
        return
    end
    if shopWindow:isVisible() then
        return hide()
    end
    show()
end

function comma_value(n)
    local left, num, right = string.match(tostring(n), "^([^%d]*%d)(%d*)(.-)$")
    if not left then
        return tostring(n)
    end
    return left .. (num:reverse():gsub("(%d%d%d)", "%1,"):reverse()) .. right
end

function onCatalog(data)
    local categoriesList = shopWindow:getChildById("categoriesList")
    categoriesList:destroyChildren()
    selected = nil
    selectedOffer = nil
    categories = {}
    offers = {}

    for _, category in ipairs(data.categories or {}) do
        if type(category.title) == "string" then
            addCategory(category)
            offers[category.title] = {}
        end
    end

    for _, offer in ipairs(data.offers or {}) do
        if type(offer.id) == "string" and offers[offer.category] then
            table.insert(offers[offer.category], offer)
        end
    end

    catalogLoaded = true
    local first = categoriesList:getChildren()[1]
    if first then
        select(first:getChildById("button"))
    end
end

function onBalance(data)
    balance = tonumber(data.coins) or 0
    shopWindow:getChildById("balance"):getChildById("value"):setText(comma_value(balance))
    if selectedOffer then
        updateDescription(selectedOffer)
    end
end

function addCategory(data)
    categories[data.title] = data
    local categoriesList = shopWindow:getChildById("categoriesList")
    local category
    if data.parent and categoriesList:getChildById(data.parent) then
        local parentPanel = categoriesList:getChildById(data.parent)
        category = g_ui.createWidget("ShopSubCategory", parentPanel:getChildById("subCategories"))
        parentPanel:getChildById("expandArrow"):show()
    else
        category = g_ui.createWidget("ShopCategory", categoriesList)
    end

    category:setId(data.title)
    category:getChildById("button"):setIconClip((tonumber(data.iconId) or 0) * 13 .. " 0 13 13")
    category:getChildById("name"):setText(data.title)
end

function deselect()
    if not selected then
        return
    end
    selected:getChildById("button"):setChecked(false)
    local arrow = selected:getChildById("selectArrow")
    if arrow then
        arrow:hide()
    end
    if not selected:getChildById("subCategories") then
        selected = selected:getParent():getParent()
        selected:getChildById("expandArrow"):show()
    end
    selected:setHeight(22)
    selected:getChildById("subCategories"):hide()
end

function select(self, ignoreSearch)
    hideHistory()
    if not ignoreSearch then
        eraseSearchResults()
    end

    local selfParent = self:getParent()
    local panel = selfParent:getChildById("subCategories")
    if panel then
        deselect()
        selected = selfParent
        if panel:getChildCount() > 0 then
            panel:show()
            selfParent:setHeight((panel:getChildCount() + 1) * 22)
            selfParent:getChildById("expandArrow"):hide()
            select(panel:getChildren()[1]:getChildById("button"))
            return
        end
        self:setChecked(true)
    else
        if selected then
            selected:getChildById("button"):setChecked(false)
            local arrow = selected:getChildById("selectArrow")
            if arrow then
                arrow:hide()
            end
        end
        selected = selfParent
        self:setChecked(true)
        selfParent:getChildById("selectArrow"):show()
    end

    showOffers(selfParent:getId())
end

local function setOfferImage(imagePanel, offer)
    local item = imagePanel:getChildById("item")
    local clientItemId = tonumber(offer.clientItemId) or 0
    item:setVisible(clientItemId > 0)
    if clientItemId > 0 then
        item:setItemId(clientItemId)
    end
end

function showOffers(categoryTitle)
    local offersPanel = shopWindow:getChildById("offers")
    local offersList = offersPanel:getChildById("offersList")
    offersList:destroyChildren()
    offersPanel:getChildById("offerDetails"):hide()
    selectedOffer = nil

    local list = offers[categoryTitle] or {}
    for i, offer in ipairs(list) do
        local widget = g_ui.createWidget("OfferWidget", offersList)
        widget:setId(offer.id)
        widget.data = offer
        widget:getChildById("name"):setText(offer.name)
        widget:getChildById("price"):getChildById("value"):setText(comma_value(offer.price))
        local count = widget:getChildById("count")
        count:setText((offer.count or 1) .. "x")
        count:setVisible((offer.count or 1) > 1)
        setOfferImage(widget:getChildById("imagePanel"), offer)
        if i == 1 then
            selectOffer(widget)
        end
    end
    offersPanel:show()
end

function selectOffer(self)
    if selectedOffer then
        selectedOffer:setChecked(false)
    end
    self:setChecked(true)
    selectedOffer = self
    updateDescription(self)
end

local function configureBuyButton(button, priceWidget, offer, quantity)
    local price = offer.price * quantity
    button.quantity = quantity
    button:setText(quantity > 1 and tr("Buy %d", quantity) or tr("Buy"))
    button:setEnabled(price <= balance)
    priceWidget:setText(comma_value(price))
    priceWidget:setEnabled(price <= balance)
end

function updateDescription(self)
    local offer = self.data
    local offerDetails = shopWindow:getChildById("offers"):getChildById("offerDetails")
    offerDetails:show()
    offerDetails:getChildById("name"):setText(offer.name)

    local descriptionPanel = offerDetails:getChildById("description")
    local label = descriptionPanel:getChildren()[1] or g_ui.createWidget("OfferDescriptionLabel", descriptionPanel)
    label:setText(offer.description or "")

    configureBuyButton(offerDetails:getChildById("buyButton"), offerDetails:getChildById("price"), offer, 1)

    local maxQuantity = math.max(1, tonumber(offer.maxQuantity) or 1)
    local additionalBuyButton = offerDetails:getChildById("additionalBuyButton")
    local additionalPrice = offerDetails:getChildById("additionalPrice")
    additionalBuyButton:setVisible(maxQuantity > 1)
    additionalPrice:setVisible(maxQuantity > 1)
    if maxQuantity > 1 then
        configureBuyButton(additionalBuyButton, additionalPrice, offer, maxQuantity)
    end

    setOfferImage(offerDetails:getChildById("imagePanel"), offer)
end

function onOfferBuy(button)
    if not selectedOffer then
        return
    end
    local offer = selectedOffer.data
    local quantity = button.quantity or 1
    local text = tr("Do you want to buy %dx %s for %s %s?", quantity, offer.name, comma_value(offer.price * quantity), CURRENCY)

    hide()
    local productId = offer.id
    local confirm = function()
        msgWindow:destroy()
        msgWindow = nil
        sendRequest("purchase", { id = productId, count = quantity })
    end
    local cancel = function()
        msgWindow:destroy()
        msgWindow = nil
        show()
    end
    msgWindow = displayGeneralBox(tr("Purchase Confirmation"), text, {
        { text = tr("Yes"), callback = confirm },
        { text = tr("No"), callback = cancel },
        anchor = AnchorHorizontalCenter
    }, confirm, cancel)
end

function onMessage(data)
    local isError = data.type == "error"
    lastMessage = { type = data.type, text = tostring(data.msg or "") }
    if data.close then
        hide()
    end
    closeMessage()
    local done = function()
        closeMessage()
        show()
    end
    messageBox = UIMessageBox.display(isError and tr("Shop Error") or tr("PokeNation Shop"), lastMessage.text,
        { { text = tr("Ok"), callback = done } }, done, done)
end

function closeMessage()
    if messageBox then
        messageBox:destroy()
        messageBox = nil
    end
end

function requestHistory()
    deselect()
    shopWindow:getChildById("offers"):hide()
    shopWindow:getChildById("history"):show()
    sendRequest("history")
end

function showHistory()
    requestHistory()
end

function hideHistory()
    shopWindow:getChildById("history"):hide()
end

function updateHistory()
    local historyPanel = shopWindow:getChildById("history")
    local historyList = historyPanel:getChildById("list")
    historyList:destroyChildren()

    local first = ((currentPage - 1) * HISTORY_PER_PAGE) + 1
    for i = first, math.min(#history, first + HISTORY_PER_PAGE - 1) do
        local entry = history[i]
        local price = tonumber(entry.price) or 0
        local widget = g_ui.createWidget("HistoryWidget", historyList)
        widget:getChildById("date"):setText(tostring(entry.date or ""))
        widget:getChildById("price"):setText((price > 0 and "+" or "") .. comma_value(price))
        widget:getChildById("price"):setOn(price > 0)
        widget:getChildById("description"):setText(tostring(entry.name or ""))
    end

    historyPanel:getChildById("pageLabel"):setText(tr("Page %d/%d", currentPage, totalPages))
    historyPanel:getChildById("nextPageButton"):setVisible(currentPage < totalPages)
    historyPanel:getChildById("prevPageButton"):setVisible(currentPage > 1)
end

function onHistory(entries)
    history = entries
    currentPage = 1
    totalPages = math.max(1, math.ceil(#history / HISTORY_PER_PAGE))
    updateHistory()
end

function prevPage()
    if currentPage > 1 then
        currentPage = currentPage - 1
        updateHistory()
    end
end

function nextPage()
    if currentPage < totalPages then
        currentPage = currentPage + 1
        updateHistory()
    end
end

function onTypeSearch(self)
    shopWindow:getChildById("searchButton"):setEnabled(#self:getText() > 2)
end

function eraseSearchResults()
    local widget = shopWindow:getChildById("categoriesList"):getChildById(SEARCH_CATEGORY)
    if widget then
        if selected == widget then
            selected = nil
        end
        widget:destroy()
    end
    offers[SEARCH_CATEGORY] = nil
end

function onSearch()
    local searchTextEdit = shopWindow:getChildById("searchTextEdit")
    local text = searchTextEdit:getText()
    if #text < 3 then
        return
    end

    eraseSearchResults()
    local results = {}
    local term = text:lower()
    for categoryTitle, list in pairs(offers) do
        for _, offer in ipairs(list) do
            if offer.name:lower():find(term, 1, true) then
                table.insert(results, offer)
            end
        end
    end
    addCategory({ title = SEARCH_CATEGORY, iconId = 7 })
    offers[SEARCH_CATEGORY] = results

    local children = shopWindow:getChildById("categoriesList"):getChildren()
    select(children[#children]:getChildById("button"), true)
    searchTextEdit:clearText()
end

-- Test/inspection helpers (used by the GUI smoke test).
function getState()
    local offerCount = 0
    for title, list in pairs(offers) do
        if title ~= SEARCH_CATEGORY then
            offerCount = offerCount + #list
        end
    end
    return {
        visible = shopWindow and shopWindow:isVisible() or false,
        catalogLoaded = catalogLoaded,
        balance = balance,
        offerCount = offerCount,
        selectedOffer = selectedOffer and selectedOffer.data.id or nil,
        historyCount = #history,
        lastMessage = lastMessage
    }
end

function getWindow()
    return shopWindow
end

function selectOfferById(productId)
    if not shopWindow then
        return false
    end
    for title, list in pairs(offers) do
        for _, offer in ipairs(list) do
            if offer.id == productId and title ~= SEARCH_CATEGORY then
                local category = shopWindow:getChildById("categoriesList"):recursiveGetChildById(title)
                if category then
                    select(category:getChildById("button"))
                    local widget = shopWindow:getChildById("offers"):getChildById("offersList"):getChildById(productId)
                    if widget then
                        selectOffer(widget)
                        return true
                    end
                end
            end
        end
    end
    return false
end

function purchase(productId, quantity)
    return sendRequest("purchase", { id = productId, count = quantity or 1 })
end
