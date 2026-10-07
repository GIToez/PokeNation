-- PSoul protocol 312 profile for the PokeNation server.
--
-- The PSoul engine speaks the 8.54 game protocol with PSoul extensions and expects the
-- protocol number 312 in both login packets. Redemption only accepts versions >= 740, so the
-- client runs as 8.54 internally (things, message modes, features) and writes 312 on the wire.
-- The profile is selected explicitly (PokeNationConfig.protocolProfile in init.lua), never by
-- version detection. Enabled and disabled features: docs/REDEMPTION_CHANGES.md section 2.

PokeNationProtocol = {
    PROFILE = 'psoul312',
    CLIENT_VERSION = 854,
    WIRE_PROTOCOL_VERSION = 312,

    -- Server-side ids, server/src/enums.h OperatingSystem_t.
    Os = {
        Windows = 0x14,
        Linux = 0x15,
        Mac = 0x16,
        Android = 0x17
    },

    -- Server-side LocalizationLang_t (server/src/localization.h); others fall back to English.
    ServerLanguageIds = {
        en = 0,
        pt = 1,
        es = 2
    },

    -- Features the 8.54 defaults in game_features do not set but the PSoul server relies on.
    -- Each one is read the same way by the legacy client (client/), see REDEMPTION_CHANGES.md.
    enabledFeatures = {
        'GamePSoulProtocol',
        'GameMagicEffectU16',
        'GameCreatureIcons',
        'GameSpritesU32',
        'GameSpritesAlphaChannel',
        'GamePlayerMarket',
        'GameChargeableItems',
        'GameBlueNpcNameColor',
        'GameDiagonalAnimatedText'
    },

    -- 8.54 defaults the legacy client does not use.
    disabledFeatures = {
        'GameFormatCreatureName'
    }
}

function PokeNationProtocol.isSelected()
    return PokeNationConfig ~= nil and PokeNationConfig.protocolProfile == PokeNationProtocol.PROFILE
end

function PokeNationProtocol.isActive()
    return g_game.getFeature(GamePSoulProtocol)
end

function PokeNationProtocol.osId()
    local os = PokeNationProtocol.Os
    if g_platform.isMobile() then
        return os.Android
    end
    local name = g_app.getOs()
    if name == 'windows' then
        return os.Windows
    elseif name == 'mac' then
        return os.Mac
    end
    return os.Linux
end

function PokeNationProtocol.serverLanguageId(localeName)
    return PokeNationProtocol.ServerLanguageIds[localeName] or PokeNationProtocol.ServerLanguageIds.en
end

-- Client -> server packets of the PSoul protocol that stock Redemption does not have.
-- Shapes: server/src/protocolgame.cpp parseRequestPollWindow / parsePollVote.
PokeNationProtocol.ClientOpcodes = {
    RequestPollWindow = 0xFA,
    PollVote = 0xFB
}

local function sendPSoulPacket(opcode, write)
    if not PokeNationProtocol.isActive() then
        return false
    end
    local protocolGame = g_game.getProtocolGame()
    if not protocolGame then
        return false
    end
    local msg = OutputMessage.create()
    msg:addU8(opcode)
    if write then
        write(msg)
    end
    protocolGame:send(msg)
    return true
end

-- Same names as the legacy client's C++ bindings (client/src-cpp/src/client/luafunctions.cpp),
-- so the legacy game_poll module runs unchanged.
function g_game.requestPollWindow()
    return sendPSoulPacket(PokeNationProtocol.ClientOpcodes.RequestPollWindow)
end

function g_game.doPollVote(optionId)
    optionId = tonumber(optionId)
    if not optionId or optionId < 0 or optionId > 255 then
        g_logger.warning('[PokeNation] doPollVote: option id out of range: ' .. tostring(optionId))
        return false
    end
    return sendPSoulPacket(PokeNationProtocol.ClientOpcodes.PollVote, function(msg)
        msg:addU8(optionId)
    end)
end

function g_game.doPollVoteText(text)
    if type(text) ~= 'string' then
        return false
    end
    return sendPSoulPacket(PokeNationProtocol.ClientOpcodes.PollVote, function(msg)
        msg:addString(text)
    end)
end

-- Called by game_features at the end of onClientVersionChange.
function PokeNationProtocol.apply(version)
    if not PokeNationProtocol.isSelected() then
        g_game.setWireProtocolVersion(0)
        return false
    end

    if version ~= PokeNationProtocol.CLIENT_VERSION then
        g_logger.warning(string.format('[PokeNation] protocol profile %s needs client version %d, got %d; profile not applied',
            PokeNationProtocol.PROFILE, PokeNationProtocol.CLIENT_VERSION, version))
        g_game.setWireProtocolVersion(0)
        return false
    end

    for _, name in ipairs(PokeNationProtocol.enabledFeatures) do
        g_game.enableFeature(_G[name])
    end
    for _, name in ipairs(PokeNationProtocol.disabledFeatures) do
        g_game.disableFeature(_G[name])
    end

    g_game.setWireProtocolVersion(PokeNationProtocol.WIRE_PROTOCOL_VERSION)
    g_game.setCustomOs(PokeNationProtocol.osId())
    g_game.setRsa(OTSERV_RSA)
    return true
end
