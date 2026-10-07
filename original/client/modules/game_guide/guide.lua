local window, image, lastImageSource

-- Hooks
function onOnline() end

function onOffline()
    window:setVisible(false)
    image:setVisible(false)
    lastImageSource = nil
end

function onGameplayTutorialText(protocol, opcode, buffer)
    window:getChildById('text'):setText(buffer);

    if (buffer == '') then
        window:setVisible(false)
    else
        window:setVisible(true)
    end
end

function onGameplayTutorialImage(protocol, opcode, buffer)
    if (buffer == '') then
        image:setVisible(false)
    else
        local imageSource = '/images/guide/' .. buffer;
        if (lastImageSource ~= imageSource) then
            image:setImageSource('/images/guide/' .. buffer);
            image:restartImageAnimation()
            image:setVisible(true)
        end

        lastImageSource = imageSource
    end
end

function onInit()
    connect(g_game, {
        onGameStart = onOnline,
        onGameEnd = onOffline
    })

    ProtocolGame.registerExtendedOpcode(ExtendedIds.GameplayTutorialText, onGameplayTutorialText)
    ProtocolGame.registerExtendedOpcode(ExtendedIds.GameplayTutorialImage, onGameplayTutorialImage)

    window = g_ui.loadUI('guide', modules.game_interface.getMapPanel())
    image = g_ui.createWidget('TutorialImage', modules.game_interface.getMapPanel())

    if (g_game.isOnline()) then
        onOnline()
    end
end

function onTerminate()
    disconnect(g_game, {
        onGameStart = onOnline,
        onGameEnd = onOffline
    })

    ProtocolGame.unregisterExtendedOpcode(ExtendedIds.GameplayTutorialText)
    ProtocolGame.unregisterExtendedOpcode(ExtendedIds.GameplayTutorialImage)
end