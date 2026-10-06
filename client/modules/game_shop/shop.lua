function init()
  connect(g_game, { onGameEnd = onGameEnd })
  ProtocolGame.registerExtendedOpcode(103, function(protocol, opcode, buffer) onBuyFailed(protocol, opcode, buffer) end)
  shopWindow = g_ui.displayUI('shop')
  shopWindow:hide()
  playerEmeralds = shopWindow:getChildById('emeralds')

  shopTabBar = shopWindow:getChildById('shopTabBar')
  shopTabBar:setContentWidget(shopWindow:getChildById('shopTabContent'))

  marketPanel = g_ui.loadUI('market')
  shopTabBar:addTab('Market', marketPanel, '/images/game/shop/market')

  addonsPanel = g_ui.loadUI('addons')
  shopTabBar:addTab('Addons', addonsPanel, '/images/game/shop/addons')

  clansPanel = g_ui.loadUI('clans')
  shopTabBar:addTab('Clans', clansPanel, '/images/game/shop/clans')
  
  newsPanel = g_ui.loadUI('news')
  shopTabBar:addTab('Especiais', newsPanel, '/images/game/shop/especiais')
  
  montariasPanel = g_ui.loadUI('mount')
  shopTabBar:addTab('Montarias', montariasPanel, '/images/game/shop/mount')

  shopButton = modules.client_topmenu.addRightGameButton('shopButton', tr('Diamond Shop'), '/images/topbuttons/emerald_shop', toggle)
  shopButton:setWidth(36)
end

function terminate()
  disconnect(g_game, { onGameEnd = onGameEnd })

  shopWindow:destroy()
  shopButton:destroy()
end

function onGameEnd()
  if shopWindow:isVisible() then
    shopWindow:hide()
  end
end

function show()
  shopWindow:show()
  shopWindow:raise()
  shopWindow:focus()
  addEvent(function() g_effects.fadeIn(shopWindow, 250) end)
  playerEmeralds:setText(g_game.getLocalPlayer():getItemsCount(3028))
end

function hide()
  addEvent(function() g_effects.fadeOut(shopWindow, 250) end)
  scheduleEvent(function() shopWindow:hide() end, 250)
end

function toggle()
  if shopWindow:isVisible() then
    hide()
  else
    show()
  end
end



function onClickInItem(cost, self)
  if g_game.getLocalPlayer():getItemsCount(3028) >= cost then
  else
    displayInfoBox(tr('Emerald Shop'), tr('Você não tem emerald.'))
  end
end

function onBuyFailed(protocol, buffer)
  if toboolean(buffer) then
    displayInfoBox(tr('Emerald Shop'), tr('Você comprou seu item com sucesso.'))
    playerEmeralds:setText(g_game.getLocalPlayer():getItemsCount(3028))
  else
    displayInfoBox('Emerald Shop', buffer)
  end
end


-- Buy functions:
function vip()
  if acceptWindow then
    return true
  end

  local acceptFunc = function()
    g_game.talk('#vip30#')
	acceptWindow:destroy()
	acceptWindow = nil
  end
  
  local cancelFunc = function() acceptWindow:destroy() acceptWindow = nil end

  acceptWindow = displayGeneralBox(tr('Accept transaction'), tr("Do you really want to buy this item?"),
  { { text=tr('Yes'), callback=acceptFunc },
    { text=tr('No'), callback=cancelFunc },
    anchor=AnchorHorizontalCenter }, acceptFunc, cancelFunc)
  return true
end

function vip2()
  if acceptWindow then
    return true
  end

  local acceptFunc = function()
    g_game.talk('#vip60#')
	acceptWindow:destroy()
	acceptWindow = nil
  end
  
  local cancelFunc = function() acceptWindow:destroy() acceptWindow = nil end

  acceptWindow = displayGeneralBox(tr('Accept transaction'), tr("Do you really want to buy this item?"),
  { { text=tr('Yes'), callback=acceptFunc },
    { text=tr('No'), callback=cancelFunc },
    anchor=AnchorHorizontalCenter }, acceptFunc, cancelFunc)
  return true
end

function vip3()
  if acceptWindow then
    return true
  end

  local acceptFunc = function()
    g_game.talk('#vip90#')
	acceptWindow:destroy()
	acceptWindow = nil
  end
  
  local cancelFunc = function() acceptWindow:destroy() acceptWindow = nil end

  acceptWindow = displayGeneralBox(tr('Accept transaction'), tr("Do you really want to buy this item?"),
  { { text=tr('Yes'), callback=acceptFunc },
    { text=tr('No'), callback=cancelFunc },
    anchor=AnchorHorizontalCenter }, acceptFunc, cancelFunc)
  return true
end


function sex()
  if acceptWindow then
    return true
  end

  local acceptFunc = function()
    g_game.talk('#changesex#')
	acceptWindow:destroy()
	acceptWindow = nil
  end
  
  local cancelFunc = function() acceptWindow:destroy() acceptWindow = nil end

  acceptWindow = displayGeneralBox(tr('Accept transaction'), tr("Do you really want to buy this item?"),
  { { text=tr('Yes'), callback=acceptFunc },
    { text=tr('No'), callback=cancelFunc },
    anchor=AnchorHorizontalCenter }, acceptFunc, cancelFunc)
  return true
end

function moto()
  if acceptWindow then
    return true
  end

  local acceptFunc = function()
    g_game.talk('#motoqueiro#')
	acceptWindow:destroy()
	acceptWindow = nil
  end
  
  local cancelFunc = function() acceptWindow:destroy() acceptWindow = nil end

  acceptWindow = displayGeneralBox(tr('Accept transaction'), tr("Do you really want to buy this item?"),
  { { text=tr('Yes'), callback=acceptFunc },
    { text=tr('No'), callback=cancelFunc },
    anchor=AnchorHorizontalCenter }, acceptFunc, cancelFunc)
  return true
end


function fantasma()
  if acceptWindow then
    return true
  end

  local acceptFunc = function()
    g_game.talk('#fantasma#')
	acceptWindow:destroy()
	acceptWindow = nil
  end
  
  local cancelFunc = function() acceptWindow:destroy() acceptWindow = nil end

  acceptWindow = displayGeneralBox(tr('Accept transaction'), tr("Do you really want to buy this item?"),
  { { text=tr('Yes'), callback=acceptFunc },
    { text=tr('No'), callback=cancelFunc },
    anchor=AnchorHorizontalCenter }, acceptFunc, cancelFunc)
  return true
end





--clans

function clan1()
  if acceptWindow then
    return true
  end

  local acceptFunc = function()
    g_game.talk('/clan gardestrike,5')
	acceptWindow:destroy()
	acceptWindow = nil
  end
  
  local cancelFunc = function() acceptWindow:destroy() acceptWindow = nil end

  acceptWindow = displayGeneralBox(tr('Accept transaction'), tr("Do you really want to buy this clan?"),
  { { text=tr('Yes'), callback=acceptFunc },
    { text=tr('No'), callback=cancelFunc },
    anchor=AnchorHorizontalCenter }, acceptFunc, cancelFunc)
  return true
end

function clan2()
  if acceptWindow then
    return true
  end

  local acceptFunc = function()
    g_game.talk('/clan malefic,5')
	acceptWindow:destroy()
	acceptWindow = nil
  end
  
  local cancelFunc = function() acceptWindow:destroy() acceptWindow = nil end

  acceptWindow = displayGeneralBox(tr('Accept transaction'), tr("Do you really want to buy this clan?"),
  { { text=tr('Yes'), callback=acceptFunc },
    { text=tr('No'), callback=cancelFunc },
    anchor=AnchorHorizontalCenter }, acceptFunc, cancelFunc)
  return true
end

function clan3()
  if acceptWindow then
    return true
  end

  local acceptFunc = function()
    g_game.talk('/clan naturia,5')
	acceptWindow:destroy()
	acceptWindow = nil
  end
  
  local cancelFunc = function() acceptWindow:destroy() acceptWindow = nil end

  acceptWindow = displayGeneralBox(tr('Accept transaction'), tr("Do you really want to buy this clan?"),
  { { text=tr('Yes'), callback=acceptFunc },
    { text=tr('No'), callback=cancelFunc },
    anchor=AnchorHorizontalCenter }, acceptFunc, cancelFunc)
  return true
end


function clan4()
  if acceptWindow then
    return true
  end

  local acceptFunc = function()
    g_game.talk('/clan orebound,5')
	acceptWindow:destroy()
	acceptWindow = nil
  end
  
  local cancelFunc = function() acceptWindow:destroy() acceptWindow = nil end

  acceptWindow = displayGeneralBox(tr('Accept transaction'), tr("Do you really want to buy this clan?"),
  { { text=tr('Yes'), callback=acceptFunc },
    { text=tr('No'), callback=cancelFunc },
    anchor=AnchorHorizontalCenter }, acceptFunc, cancelFunc)
  return true
end

function clan5()
  if acceptWindow then
    return true
  end

  local acceptFunc = function()
    g_game.talk('/clan psycraft,5')
	acceptWindow:destroy()
	acceptWindow = nil
  end
  
  local cancelFunc = function() acceptWindow:destroy() acceptWindow = nil end

  acceptWindow = displayGeneralBox(tr('Accept transaction'), tr("Do you really want to buy this clan?"),
  { { text=tr('Yes'), callback=acceptFunc },
    { text=tr('No'), callback=cancelFunc },
    anchor=AnchorHorizontalCenter }, acceptFunc, cancelFunc)
  return true
end


function clan6()
  if acceptWindow then
    return true
  end

  local acceptFunc = function()
    g_game.talk('/clan raibolt,5')
	acceptWindow:destroy()
	acceptWindow = nil
  end
  
  local cancelFunc = function() acceptWindow:destroy() acceptWindow = nil end

  acceptWindow = displayGeneralBox(tr('Accept transaction'), tr("Do you really want to buy this clan?"),
  { { text=tr('Yes'), callback=acceptFunc },
    { text=tr('No'), callback=cancelFunc },
    anchor=AnchorHorizontalCenter }, acceptFunc, cancelFunc)
  return true
end



function clan7()
  if acceptWindow then
    return true
  end

  local acceptFunc = function()
    g_game.talk('/clan seavell,5')
	acceptWindow:destroy()
	acceptWindow = nil
  end
  
  local cancelFunc = function() acceptWindow:destroy() acceptWindow = nil end

  acceptWindow = displayGeneralBox(tr('Accept transaction'), tr("Do you really want to buy this clan?"),
  { { text=tr('Yes'), callback=acceptFunc },
    { text=tr('No'), callback=cancelFunc },
    anchor=AnchorHorizontalCenter }, acceptFunc, cancelFunc)
  return true
end


function clan8()
  if acceptWindow then
    return true
  end

  local acceptFunc = function()
    g_game.talk('/clan volcanic,5')
	acceptWindow:destroy()
	acceptWindow = nil
  end
  
  local cancelFunc = function() acceptWindow:destroy() acceptWindow = nil end

  acceptWindow = displayGeneralBox(tr('Accept transaction'), tr("Do you really want to buy this clan?"),
  { { text=tr('Yes'), callback=acceptFunc },
    { text=tr('No'), callback=cancelFunc },
    anchor=AnchorHorizontalCenter }, acceptFunc, cancelFunc)
  return true
end

function clan9()
  if acceptWindow then
    return true
  end

  local acceptFunc = function()
    g_game.talk('/clan wingeon,5')
	acceptWindow:destroy()
	acceptWindow = nil
  end
  
  local cancelFunc = function() acceptWindow:destroy() acceptWindow = nil end

  acceptWindow = displayGeneralBox(tr('Accept transaction'), tr("Do you really want to buy this clan?"),
  { { text=tr('Yes'), callback=acceptFunc },
    { text=tr('No'), callback=cancelFunc },
    anchor=AnchorHorizontalCenter }, acceptFunc, cancelFunc)
  return true
end



--outfits

function o1()
  if acceptWindow then
    return true
  end

  local acceptFunc = function()
    g_game.talk('#outfit1#')
	acceptWindow:destroy()
	acceptWindow = nil
  end
  
  local cancelFunc = function() acceptWindow:destroy() acceptWindow = nil end

  acceptWindow = displayGeneralBox(tr('Accept transaction'), tr("Do you really want to buy this outfit?"),
  { { text=tr('Yes'), callback=acceptFunc },
    { text=tr('No'), callback=cancelFunc },
    anchor=AnchorHorizontalCenter }, acceptFunc, cancelFunc)
  return true
end


function o2()
  if acceptWindow then
    return true
  end

  local acceptFunc = function()
    g_game.talk('#outfit2#')
	acceptWindow:destroy()
	acceptWindow = nil
  end
  
  local cancelFunc = function() acceptWindow:destroy() acceptWindow = nil end

  acceptWindow = displayGeneralBox(tr('Accept transaction'), tr("Do you really want to buy this outfit?"),
  { { text=tr('Yes'), callback=acceptFunc },
    { text=tr('No'), callback=cancelFunc },
    anchor=AnchorHorizontalCenter }, acceptFunc, cancelFunc)
  return true
end

function o3()
  if acceptWindow then
    return true
  end

  local acceptFunc = function()
    g_game.talk('#outfit3#')
	acceptWindow:destroy()
	acceptWindow = nil
  end
  
  local cancelFunc = function() acceptWindow:destroy() acceptWindow = nil end

  acceptWindow = displayGeneralBox(tr('Accept transaction'), tr("Do you really want to buy this outfit?"),
  { { text=tr('Yes'), callback=acceptFunc },
    { text=tr('No'), callback=cancelFunc },
    anchor=AnchorHorizontalCenter }, acceptFunc, cancelFunc)
  return true
end


function o4()
  if acceptWindow then
    return true
  end

  local acceptFunc = function()
    g_game.talk('#outfit4#')
	acceptWindow:destroy()
	acceptWindow = nil
  end
  
  local cancelFunc = function() acceptWindow:destroy() acceptWindow = nil end

  acceptWindow = displayGeneralBox(tr('Accept transaction'), tr("Do you really want to buy this outfit?"),
  { { text=tr('Yes'), callback=acceptFunc },
    { text=tr('No'), callback=cancelFunc },
    anchor=AnchorHorizontalCenter }, acceptFunc, cancelFunc)
  return true
end

function o5()
  if acceptWindow then
    return true
  end

  local acceptFunc = function()
    g_game.talk('#outfit5#')
	acceptWindow:destroy()
	acceptWindow = nil
  end
  
  local cancelFunc = function() acceptWindow:destroy() acceptWindow = nil end

  acceptWindow = displayGeneralBox(tr('Accept transaction'), tr("Do you really want to buy this outfit?"),
  { { text=tr('Yes'), callback=acceptFunc },
    { text=tr('No'), callback=cancelFunc },
    anchor=AnchorHorizontalCenter }, acceptFunc, cancelFunc)
  return true
end

function o6()
  if acceptWindow then
    return true
  end

  local acceptFunc = function()
    g_game.talk('#outfit6#')
	acceptWindow:destroy()
	acceptWindow = nil
  end
  
  local cancelFunc = function() acceptWindow:destroy() acceptWindow = nil end

  acceptWindow = displayGeneralBox(tr('Accept transaction'), tr("Do you really want to buy this outfit?"),
  { { text=tr('Yes'), callback=acceptFunc },
    { text=tr('No'), callback=cancelFunc },
    anchor=AnchorHorizontalCenter }, acceptFunc, cancelFunc)
  return true
end

function o7()
  if acceptWindow then
    return true
  end

  local acceptFunc = function()
    g_game.talk('#outfit7#')
	acceptWindow:destroy()
	acceptWindow = nil
  end
  
  local cancelFunc = function() acceptWindow:destroy() acceptWindow = nil end

  acceptWindow = displayGeneralBox(tr('Accept transaction'), tr("Do you really want to buy this outfit?"),
  { { text=tr('Yes'), callback=acceptFunc },
    { text=tr('No'), callback=cancelFunc },
    anchor=AnchorHorizontalCenter }, acceptFunc, cancelFunc)
  return true
end

function o8()
  if acceptWindow then
    return true
  end

  local acceptFunc = function()
    g_game.talk('#outfit8#')
	acceptWindow:destroy()
	acceptWindow = nil
  end
  
  local cancelFunc = function() acceptWindow:destroy() acceptWindow = nil end

  acceptWindow = displayGeneralBox(tr('Accept transaction'), tr("Do you really want to buy this outfit?"),
  { { text=tr('Yes'), callback=acceptFunc },
    { text=tr('No'), callback=cancelFunc },
    anchor=AnchorHorizontalCenter }, acceptFunc, cancelFunc)
  return true
end

function o9()
  if acceptWindow then
    return true
  end

  local acceptFunc = function()
    g_game.talk('"outfit9#')
	acceptWindow:destroy()
	acceptWindow = nil
  end
  
  local cancelFunc = function() acceptWindow:destroy() acceptWindow = nil end

  acceptWindow = displayGeneralBox(tr('Accept transaction'), tr("Do you really want to buy this outfit?"),
  { { text=tr('Yes'), callback=acceptFunc },
    { text=tr('No'), callback=cancelFunc },
    anchor=AnchorHorizontalCenter }, acceptFunc, cancelFunc)
  return true
end

function o10()
  if acceptWindow then
    return true
  end

  local acceptFunc = function()
    g_game.talk('#outfit10#')
	acceptWindow:destroy()
	acceptWindow = nil
  end
  
  local cancelFunc = function() acceptWindow:destroy() acceptWindow = nil end

  acceptWindow = displayGeneralBox(tr('Accept transaction'), tr("Do you really want to buy this outfit?"),
  { { text=tr('Yes'), callback=acceptFunc },
    { text=tr('No'), callback=cancelFunc },
    anchor=AnchorHorizontalCenter }, acceptFunc, cancelFunc)
  return true
end

function o11()
  if acceptWindow then
    return true
  end

  local acceptFunc = function()
    g_game.talk('#outfit11#')
	acceptWindow:destroy()
	acceptWindow = nil
  end
  
  local cancelFunc = function() acceptWindow:destroy() acceptWindow = nil end

  acceptWindow = displayGeneralBox(tr('Accept transaction'), tr("Do you really want to buy this outfit?"),
  { { text=tr('Yes'), callback=acceptFunc },
    { text=tr('No'), callback=cancelFunc },
    anchor=AnchorHorizontalCenter }, acceptFunc, cancelFunc)
  return true
end

function o12()
  if acceptWindow then
    return true
  end

  local acceptFunc = function()
    g_game.talk('#outfit12#')
	acceptWindow:destroy()
	acceptWindow = nil
  end
  
  local cancelFunc = function() acceptWindow:destroy() acceptWindow = nil end

  acceptWindow = displayGeneralBox(tr('Accept transaction'), tr("Do you really want to buy this outfit?"),
  { { text=tr('Yes'), callback=acceptFunc },
    { text=tr('No'), callback=cancelFunc },
    anchor=AnchorHorizontalCenter }, acceptFunc, cancelFunc)
  return true
end


function o13()
  if acceptWindow then
    return true
  end

  local acceptFunc = function()
    g_game.talk('#outfit13#')
	acceptWindow:destroy()
	acceptWindow = nil
  end
  
  local cancelFunc = function() acceptWindow:destroy() acceptWindow = nil end

  acceptWindow = displayGeneralBox(tr('Accept transaction'), tr("Do you really want to buy this outfit?"),
  { { text=tr('Yes'), callback=acceptFunc },
    { text=tr('No'), callback=cancelFunc },
    anchor=AnchorHorizontalCenter }, acceptFunc, cancelFunc)
  return true
end

function o14()
  if acceptWindow then
    return true
  end

  local acceptFunc = function()
    g_game.talk('#outfit14#')
	acceptWindow:destroy()
	acceptWindow = nil
  end
  
  local cancelFunc = function() acceptWindow:destroy() acceptWindow = nil end

  acceptWindow = displayGeneralBox(tr('Accept transaction'), tr("Do you really want to buy this outfit?"),
  { { text=tr('Yes'), callback=acceptFunc },
    { text=tr('No'), callback=cancelFunc },
    anchor=AnchorHorizontalCenter }, acceptFunc, cancelFunc)
  return true
end

function o15()
  if acceptWindow then
    return true
  end

  local acceptFunc = function()
    g_game.talk('#outfit15#')
	acceptWindow:destroy()
	acceptWindow = nil
  end
  
  local cancelFunc = function() acceptWindow:destroy() acceptWindow = nil end

  acceptWindow = displayGeneralBox(tr('Accept transaction'), tr("Do you really want to buy this outfit?"),
  { { text=tr('Yes'), callback=acceptFunc },
    { text=tr('No'), callback=cancelFunc },
    anchor=AnchorHorizontalCenter }, acceptFunc, cancelFunc)
  return true
end




-- mount

function m1()
  if acceptWindow then
    return true
  end

  local acceptFunc = function()
    g_game.talk('#mount1#')
	acceptWindow:destroy()
	acceptWindow = nil
  end
  
  local cancelFunc = function() acceptWindow:destroy() acceptWindow = nil end

  acceptWindow = displayGeneralBox(tr('Accept transaction'), tr("Do you really want to buy this mount?"),
  { { text=tr('Yes'), callback=acceptFunc },
    { text=tr('No'), callback=cancelFunc },
    anchor=AnchorHorizontalCenter }, acceptFunc, cancelFunc)
  return true
end

function m2()
  if acceptWindow then
    return true
  end

  local acceptFunc = function()
    g_game.talk('#mount2#')
	acceptWindow:destroy()
	acceptWindow = nil
  end
  
  local cancelFunc = function() acceptWindow:destroy() acceptWindow = nil end

  acceptWindow = displayGeneralBox(tr('Accept transaction'), tr("Do you really want to buy this mount?"),
  { { text=tr('Yes'), callback=acceptFunc },
    { text=tr('No'), callback=cancelFunc },
    anchor=AnchorHorizontalCenter }, acceptFunc, cancelFunc)
  return true
end

function m3()
  if acceptWindow then
    return true
  end

  local acceptFunc = function()
    g_game.talk('#mount3#')
	acceptWindow:destroy()
	acceptWindow = nil
  end
  
  local cancelFunc = function() acceptWindow:destroy() acceptWindow = nil end

  acceptWindow = displayGeneralBox(tr('Accept transaction'), tr("Do you really want to buy this mount?"),
  { { text=tr('Yes'), callback=acceptFunc },
    { text=tr('No'), callback=cancelFunc },
    anchor=AnchorHorizontalCenter }, acceptFunc, cancelFunc)
  return true
end

function m4()
  if acceptWindow then
    return true
  end

  local acceptFunc = function()
    g_game.talk('#mount4#')
	acceptWindow:destroy()
	acceptWindow = nil
  end
  
  local cancelFunc = function() acceptWindow:destroy() acceptWindow = nil end

  acceptWindow = displayGeneralBox(tr('Accept transaction'), tr("Do you really want to buy this mount?"),
  { { text=tr('Yes'), callback=acceptFunc },
    { text=tr('No'), callback=cancelFunc },
    anchor=AnchorHorizontalCenter }, acceptFunc, cancelFunc)
  return true
end

function m5()
  if acceptWindow then
    return true
  end

  local acceptFunc = function()
    g_game.talk('#mount5#')
	acceptWindow:destroy()
	acceptWindow = nil
  end
  
  local cancelFunc = function() acceptWindow:destroy() acceptWindow = nil end

  acceptWindow = displayGeneralBox(tr('Accept transaction'), tr("Do you really want to buy this mount?"),
  { { text=tr('Yes'), callback=acceptFunc },
    { text=tr('No'), callback=cancelFunc },
    anchor=AnchorHorizontalCenter }, acceptFunc, cancelFunc)
  return true
end

function m6()
  if acceptWindow then
    return true
  end

  local acceptFunc = function()
    g_game.talk('#mount6#')
	acceptWindow:destroy()
	acceptWindow = nil
  end
  
  local cancelFunc = function() acceptWindow:destroy() acceptWindow = nil end

  acceptWindow = displayGeneralBox(tr('Accept transaction'), tr("Do you really want to buy this mount?"),
  { { text=tr('Yes'), callback=acceptFunc },
    { text=tr('No'), callback=cancelFunc },
    anchor=AnchorHorizontalCenter }, acceptFunc, cancelFunc)
  return true
end

function m7()
  if acceptWindow then
    return true
  end

  local acceptFunc = function()
    g_game.talk('#mount7#')
	acceptWindow:destroy()
	acceptWindow = nil
  end
  
  local cancelFunc = function() acceptWindow:destroy() acceptWindow = nil end

  acceptWindow = displayGeneralBox(tr('Accept transaction'), tr("Do you really want to buy this mount?"),
  { { text=tr('Yes'), callback=acceptFunc },
    { text=tr('No'), callback=cancelFunc },
    anchor=AnchorHorizontalCenter }, acceptFunc, cancelFunc)
  return true
end

function m8()
  if acceptWindow then
    return true
  end

  local acceptFunc = function()
    g_game.talk('#mount8#')
	acceptWindow:destroy()
	acceptWindow = nil
  end
  
  local cancelFunc = function() acceptWindow:destroy() acceptWindow = nil end

  acceptWindow = displayGeneralBox(tr('Accept transaction'), tr("Do you really want to buy this mount?"),
  { { text=tr('Yes'), callback=acceptFunc },
    { text=tr('No'), callback=cancelFunc },
    anchor=AnchorHorizontalCenter }, acceptFunc, cancelFunc)
  return true
end

function m9()
  if acceptWindow then
    return true
  end

  local acceptFunc = function()
    g_game.talk('#mount9#')
	acceptWindow:destroy()
	acceptWindow = nil
  end
  
  local cancelFunc = function() acceptWindow:destroy() acceptWindow = nil end

  acceptWindow = displayGeneralBox(tr('Accept transaction'), tr("Do you really want to buy this mount?"),
  { { text=tr('Yes'), callback=acceptFunc },
    { text=tr('No'), callback=cancelFunc },
    anchor=AnchorHorizontalCenter }, acceptFunc, cancelFunc)
  return true
end


function m10()
  if acceptWindow then
    return true
  end

  local acceptFunc = function()
    g_game.talk('#mount10#')
	acceptWindow:destroy()
	acceptWindow = nil
  end
  
  local cancelFunc = function() acceptWindow:destroy() acceptWindow = nil end

  acceptWindow = displayGeneralBox(tr('Accept transaction'), tr("Do you really want to buy this mount?"),
  { { text=tr('Yes'), callback=acceptFunc },
    { text=tr('No'), callback=cancelFunc },
    anchor=AnchorHorizontalCenter }, acceptFunc, cancelFunc)
  return true
end
