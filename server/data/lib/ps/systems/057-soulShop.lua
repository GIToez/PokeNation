-- PokeNation Shop (extended opcode 201, POKENATION_SHOP). docs/reference/SOUL_COINS.md
--
-- The client only names a product id, a quantity and an optional target. Everything else
-- (catalog, prices, balance, grants, logging) lives here. Purchases are paid from the
-- account balance `accounts.soulcoins`, the same balance the Soul Trade NPC "withdraw"
-- service reads; carried soul coin items (6500) stay an NPC-only payment method.

SOUL_SHOP_OPCODE = 201
SOUL_SHOP_COIN_USE = 13 -- datalog_coin_uses.use; 1..12 are the Soul Trade NPC services
SOUL_SHOP_HISTORY_LIMIT = 50

-- iconId indexes the 13x13 icon strip of the client's shop category button.
SOUL_SHOP_CATEGORIES = {
    { title = "Items", iconId = 1 },
    { title = "Pokemon Addons", iconId = 3 },
    { title = "Account", iconId = 0 },
}

-- type "item": grants `count` x itemId per unit. type "premium": grants `days` per unit.
-- maxQuantity bounds the units per purchase (default 1). enabled = false hides a product.
SOUL_SHOP_PRODUCTS = {
    { id = "stamina_recover", category = "Items", type = "item", itemId = 13971, count = 1, price = 1, maxQuantity = 10,
      description = "Restores stamina. Same item the Soul Trade NPCs sell." },
    { id = "egg_move_capsule", category = "Items", type = "item", itemId = 28915, count = 1, price = 1, maxQuantity = 10,
      description = "Teaches an Egg Move to a compatible Pokemon." },
    { id = "addon_fossilized_aerodactyl", category = "Pokemon Addons", type = "item", itemId = 29827, count = 1, price = 15,
      description = "Pokemon addon for Aerodactyl." },
    { id = "addon_fossilized_kabutops", category = "Pokemon Addons", type = "item", itemId = 29826, count = 1, price = 15,
      description = "Pokemon addon for Kabutops." },
    { id = "addon_fossilized_armaldo", category = "Pokemon Addons", type = "item", itemId = 29829, count = 1, price = 15,
      description = "Pokemon addon for Armaldo." },
    { id = "addon_fossilized_omastar", category = "Pokemon Addons", type = "item", itemId = 29830, count = 1, price = 15,
      description = "Pokemon addon for Omastar." },
    { id = "addon_greybeard_costume", category = "Pokemon Addons", type = "item", itemId = 29855, count = 1, price = 15,
      description = "Pokemon addon costume." },
    { id = "premium_30_days", category = "Account", type = "premium", days = 30, price = 10, maxQuantity = 1,
      itemId = 6500, description = "30 days of premium account." },
}

local PRODUCTS_BY_ID = {}
for _, product in ipairs(SOUL_SHOP_PRODUCTS) do
    PRODUCTS_BY_ID[product.id] = product
end

local REQUEST_INTERVAL = 1 -- seconds between requests of the same player
local lastRequest = {}

local function send(cid, action, data)
    doSendPlayerExtendedOpcode(cid, SOUL_SHOP_OPCODE, json.encode({ action = action, data = data }))
end

local function sendMessage(cid, msgType, text, close)
    send(cid, "msg", { type = msgType, msg = text, close = close and true or false })
end

local function productName(product)
    if product.name then
        return product.name
    end
    if product.type == "premium" then
        return string.format("Premium Account (%d days)", product.days)
    end
    local name = getItemNameById(product.itemId) or product.id
    return (name:gsub("^%l", string.upper))
end

function getSoulShopAccountBalance(cid)
    local result = db.getResult("SELECT `soulcoins` FROM `accounts` WHERE `id` = " .. getPlayerAccountId(cid) .. ";")
    if result:getID() == -1 then
        return nil
    end
    local balance = result:getDataInt("soulcoins")
    result:free()
    return balance
end

-- Conditional decrement: the WHERE clause makes the check and the debit one statement, so the
-- balance can never go negative even if the website credits or debits concurrently.
local function chargeAccount(cid, amount)
    local accountId = getPlayerAccountId(cid)
    if not db.executeQuery("UPDATE `accounts` SET `soulcoins` = `soulcoins` - " .. amount ..
            " WHERE `id` = " .. accountId .. " AND `soulcoins` >= " .. amount .. ";") then
        return false
    end
    local result = db.getResult("SELECT ROW_COUNT() AS `affected`;")
    if result:getID() == -1 then
        return false
    end
    local affected = result:getDataInt("affected")
    result:free()
    return affected == 1
end

local function refundAccount(cid, amount)
    return db.executeQuery("UPDATE `accounts` SET `soulcoins` = `soulcoins` + " .. amount ..
            " WHERE `id` = " .. getPlayerAccountId(cid) .. ";")
end

local function grant(cid, product, quantity)
    if product.type == "item" then
        return doPlayerSafeAddItem(cid, product.itemId, product.count * quantity, true)
    elseif product.type == "premium" then
        doPlayerAddPremiumDays(cid, product.days * quantity)
        return true
    end
    return false
end

local function logPurchase(cid, product, quantity, price, balanceAfter)
    doDatalogCoinUse(os.time(), getPlayerGUID(cid), SOUL_SHOP_COIN_USE, price)
    db.executeQuery(string.format("INSERT INTO `datalog_shop_purchases` (`date`, `account_id`, `player_id`, `product_id`, " ..
            "`product_name`, `quantity`, `price`, `balance_after`) VALUES (%d, %d, %d, %s, %s, %d, %d, %d);",
        os.time(), getPlayerAccountId(cid), getPlayerGUID(cid), db.escapeString(product.id),
        db.escapeString(productName(product)), quantity, price, balanceAfter or -1))
end

local function sendBalance(cid)
    send(cid, "balance", { coins = getSoulShopAccountBalance(cid) or 0 })
end

local function sendCatalog(cid)
    local offers = {}
    for _, product in ipairs(SOUL_SHOP_PRODUCTS) do
        if product.enabled ~= false then
            offers[#offers + 1] = {
                id = product.id,
                category = product.category,
                name = productName(product),
                description = product.description or "",
                price = product.price,
                count = product.type == "item" and product.count or 1,
                maxQuantity = product.maxQuantity or 1,
                clientItemId = product.itemId and getItemClientId(product.itemId) or 0,
            }
        end
    end
    send(cid, "catalog", { currency = "Soul Coins", categories = SOUL_SHOP_CATEGORIES, offers = offers })
end

local function sendHistory(cid)
    local entries = {}
    local result = db.getResult("SELECT `date`, `product_name`, `quantity`, `price` FROM `datalog_shop_purchases` " ..
            "WHERE `account_id` = " .. getPlayerAccountId(cid) .. " ORDER BY `id` DESC LIMIT " .. SOUL_SHOP_HISTORY_LIMIT .. ";")
    if result:getID() ~= -1 then
        repeat
            entries[#entries + 1] = {
                date = os.date("%Y-%m-%d %H:%M", result:getDataInt("date")),
                name = result:getDataInt("quantity") .. "x " .. result:getDataString("product_name"),
                price = -result:getDataInt("price"),
            }
        until not result:next()
        result:free()
    end
    send(cid, "history", entries)
end

local function purchase(cid, data)
    if type(data) ~= "table" then
        return sendMessage(cid, "error", "Invalid request.")
    end

    local product = PRODUCTS_BY_ID[data.id]
    if not product or product.enabled == false then
        return sendMessage(cid, "error", "This product is not available.")
    end

    local quantity = tonumber(data.count) or 1
    if quantity ~= math.floor(quantity) or quantity < 1 or quantity > (product.maxQuantity or 1) then
        return sendMessage(cid, "error", "Invalid quantity.")
    end

    if data.target ~= nil and data.target ~= "" and data.target ~= getCreatureName(cid) then
        return sendMessage(cid, "error", "Gifting is not available yet.")
    end

    local price = product.price * quantity
    if not chargeAccount(cid, price) then
        sendBalance(cid)
        return sendMessage(cid, "error", string.format("You need %d Soul Coins on your account to buy this.", price))
    end

    if not grant(cid, product, quantity) then
        refundAccount(cid, price)
        log(LOG_TYPES.ERROR, "soulShop - grant failed, refunded.", getCreatureName(cid), product.id, quantity, price)
        sendBalance(cid)
        return sendMessage(cid, "error", "The purchase could not be delivered. Your Soul Coins were refunded.")
    end

    local balance = getSoulShopAccountBalance(cid)
    logPurchase(cid, product, quantity, price, balance)
    send(cid, "balance", { coins = balance or 0 })
    sendMessage(cid, "info", string.format("You bought %dx %s for %d Soul Coins.", quantity, productName(product), price))
end

function onSoulShopExtendedOpcode(cid, buffer)
    local request = json.decode(buffer)
    if type(request) ~= "table" or type(request.action) ~= "string" then
        return true
    end

    local now = os.time()
    if not lastRequest[cid] then
        for oldCid in pairs(lastRequest) do
            if not isPlayer(oldCid) then
                lastRequest[oldCid] = nil
            end
        end
    end
    local last = lastRequest[cid] or {}
    lastRequest[cid] = last
    if last[request.action] and now - last[request.action] < REQUEST_INTERVAL then
        if request.action == "purchase" then
            sendMessage(cid, "error", "Please wait a moment before buying again.")
        end
        return true
    end
    last[request.action] = now

    if request.action == "fetch" then
        sendCatalog(cid)
        sendBalance(cid)
    elseif request.action == "history" then
        sendHistory(cid)
    elseif request.action == "purchase" then
        purchase(cid, request.data)
    end
    return true
end