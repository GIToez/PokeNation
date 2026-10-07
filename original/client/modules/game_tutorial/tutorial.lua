tutorialButton = nil

CONTENT_TYPES = {
    IMAGE = 1,
    TEXT = 2
}

TUTORIALS = {['pt'] = {}, ['en'] = {}}

for i = 1, 39 do
    dofile("/modules/game_tutorial/content/en/".. string.format("%02d", i) ..".lua")
    dofile("/modules/game_tutorial/content/pt/".. string.format("%02d", i) ..".lua")
end

local function doCreateTutorialIcon(animated)
--    if (animated) then
--        tutorialButton = g_ui.createWidget('TutorialIcon', modules.game_interface.getRootPanel())
--        tutorialButton.onClick = function()
--            doShowTutorialWindow()
--            tutorialButton:destroy()
--            doCreateTutorialIcon(false)
--        end
--        tutorialButton:setTooltip(tr('Game Help'))
--    else
        tutorialButton = modules.client_topmenu.addLeftGameButton('tutorialButton', tr('Game Help'), '/images/topbuttons/tutorial.png', doShowTutorialWindow)
--    end
end

local function checkButton()
    tutorialButton:destroy()

    local settings = g_settings.getNode('game_tutorial')
    if not table.empty(settings) and settings[g_game.getCharacterName()] then
        --tutorialButton = modules.client_topmenu.addLeftGameButton('tutorialButton', tr('Game Help'), '/images/topbuttons/tutorial.png', doShowTutorialWindow)
        doCreateTutorialIcon(false)
    else
        --tutorialButton = modules.client_topmenu.addLeftGameButton('tutorialButton', tr('Game Help'), '/images/topbuttons/tutorial_animated.png', doShowTutorialWindow)
        doCreateTutorialIcon(true)
    end
end

local function saveButton()
    local settings = g_settings.getNode('game_tutorial') or {}
    local char = g_game.getCharacterName()
    if not settings[char] then
        settings[char] = {true}
    end
    g_settings.setNode('game_tutorial', settings)
    g_settings.save()
end

function onInit()
  g_ui.importStyle('tutorial')

  --tutorialButton = modules.client_topmenu.addLeftGameButton('tutorialButton', tr('Game Help'), '/images/topbuttons/tutorial.png', doShowTutorialWindow)
  doCreateTutorialIcon(true)

  connect(g_game, { onGameStart = checkButton, onGameEnd = destroyWindows})
end

function onTerminate()
  disconnect(g_game, { onGameStart = checkButton, onGameEnd = destroyWindows})

  destroyWindows()
  tutorialButton:destroy()
end

function destroyWindows()
  if tutorialWindow then
    tutorialWindow:destroy()
  end
end

function doShowTutorialWindow()
  destroyWindows()

  tutorialWindow = g_ui.createWidget('TutorialWindow', rootWidget)
  local tutorialList = tutorialWindow:getChildById('tutorialList')
  local panel = tutorialWindow:getChildById('content')
  local first = true
  local tutorials = TUTORIALS[modules.client_locales.getCurrentLocale().name]
  if (not tutorials) then
    tutorials = TUTORIALS['en']
  end

  for i,entry in pairs(tutorials) do
    local id, name, completed = 0, entry.name, false

    local questLabel = g_ui.createWidget('QuestLabel', tutorialList)
    questLabel:setOn(completed)
    questLabel:setText(name)
    questLabel.onMouseRelease = function()
      saveButton()
      checkButton()
      panel:destroyChildren()

      local last = g_ui.createWidget('TutorialTitleLabel', panel)
      last:addAnchor(AnchorLeft, 'parent', AnchorLeft)
      last:addAnchor(AnchorRight, 'parent', AnchorRight)
      last:addAnchor(AnchorTop, 'parent', AnchorTop)
      last:setText(name)

      for _, content in pairs(entry.contents) do
        local widget
        if (content.type == CONTENT_TYPES.TEXT) then
            widget = g_ui.createWidget('TutorialText', panel)
            widget:setText(content.value)

            widget:addAnchor(AnchorLeft, 'parent', AnchorLeft)
            widget:addAnchor(AnchorRight, 'parent', AnchorRight)
        else -- IMAGE
            widget = g_ui.createWidget('TutorialImage', panel)
            widget:setImageSource(content.value)

            widget:addAnchor(AnchorHorizontalCenter, 'parent', AnchorHorizontalCenter)
        end

        if (last) then
          widget:addAnchor(AnchorTop, 'prev', AnchorBottom)
        else
          widget:addAnchor(AnchorTop, 'parent', AnchorTop)
        end

        last = widget
      end
    end
    if (first) then
      questLabel:onMouseRelease()
      first = nil
    end
    if (entry.afterSeparator) then
      g_ui.createWidget('HorizontalSeparator', tutorialList)
    end
  end

  tutorialWindow.onDestroy = function()
    tutorialWindow = nil
  end

  tutorialList:focusChild(tutorialList:getFirstChild())
end

