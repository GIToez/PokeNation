-- Helpers shared by the PokeNation Pokemon UI modules.

PokeNation = PokeNation or {}

-- Every Pokemon action of the PSoul server is a hidden talkaction ("/cp N", "m1", "/dv N", ...),
-- exactly as the legacy client sends them (legacy game_pokebar, game_pokemoves, game_pokedex).
function PokeNation.say(text)
    if not g_game.isOnline() then
        return false
    end
    g_game.talkChannel(MessageModes.Say, 0, text)
    return true
end

-- Move bar keys: F1-F12 use m1-m12 and Shift+F1-F4 use m13-m16 (game_pokemoves).
function PokeNation.moveKey(index)
    if index <= 12 then
        return 'F' .. index
    elseif index <= PokeNation.MAX_MOVES then
        return 'Shift+F' .. (index - 12)
    end
end

function PokeNation.moveKeysEnabled()
    return g_settings.getBoolean(PokeNation.MOVE_KEYS_SETTING, true)
end

-- game_hotkeys and game_actionbar refuse move bar keys so one key press never runs a move and another
-- hotkey; their unbind-all calls would also drop the move bar's binding. Kept here, not in
-- game_pokemoves, because both load before the move bar.
function PokeNation.isMoveBarKey(keyCombo)
    if not PokeNation.moveKeysEnabled() then
        return false
    end
    for index = 1, PokeNation.MAX_MOVES do
        if PokeNation.moveKey(index) == keyCombo then
            return true
        end
    end
    return false
end

function PokeNation.image(path)
    return PokeNation.IMAGES .. path
end

-- Returns a module setting position if the player moved the widget before, nil otherwise.
function PokeNation.loadWidgetPosition(widget, key)
    local p = g_settings.getPoint(key)
    if p and p.x > 0 and p.y > 0 then
        widget:breakAnchors()
        widget:setPosition(p)
        return true
    end
    return false
end

local accents = {
    ['á'] = 'a', ['à'] = 'a', ['â'] = 'a', ['ã'] = 'a', ['ä'] = 'a', ['ç'] = 'c', ['é'] = 'e', ['è'] = 'e',
    ['ê'] = 'e', ['ë'] = 'e', ['í'] = 'i', ['ì'] = 'i', ['î'] = 'i', ['ï'] = 'i', ['ñ'] = 'n', ['ó'] = 'o',
    ['ò'] = 'o', ['ô'] = 'o', ['õ'] = 'o', ['ö'] = 'o', ['ú'] = 'u', ['ù'] = 'u', ['û'] = 'u', ['ü'] = 'u',
    ['Á'] = 'A', ['À'] = 'A', ['Â'] = 'A', ['Ã'] = 'A', ['Ä'] = 'A', ['Ç'] = 'C', ['É'] = 'E', ['È'] = 'E',
    ['Ê'] = 'E', ['Ë'] = 'E', ['Í'] = 'I', ['Ì'] = 'I', ['Î'] = 'I', ['Ï'] = 'I', ['Ñ'] = 'N', ['Ó'] = 'O',
    ['Ò'] = 'O', ['Ô'] = 'O', ['Õ'] = 'O', ['Ö'] = 'O', ['Ú'] = 'U', ['Ù'] = 'U', ['Û'] = 'U', ['Ü'] = 'U'
}

-- UTF-8 replacement for the legacy corelib string.stripAccents (Redemption has none).
if not string.stripAccents then
    function string.stripAccents(str)
        return (str:gsub('[\195][\128-\191]', function(c) return accents[c] or c end))
    end
end
