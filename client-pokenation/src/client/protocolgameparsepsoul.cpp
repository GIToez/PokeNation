/*
* Copyright (c) 2010-2026 OTClient <https://github.com/edubart/otclient>
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

// PSoul server opcode 0xFF family. Every payload mirrors the PSoul server writer
// (server/src/protocolgame.cpp) and fires the same g_game Lua events as the legacy
// client (client/src-cpp/src/client/protocolgameparse.cpp), so the ported Pokemon
// modules keep their callbacks. See docs/reference/OPCODES.md section 6.

#include "creature.h"
#include "game.h"
#include "map.h"
#include "protocolcodes.h"
#include "protocolgame.h"
#include "framework/luaengine/luainterface.h"
#include "framework/net/inputmessage.h"

namespace
{
    std::vector<uint16_t> readU16List(const InputMessagePtr& msg, const uint32_t count)
    {
        std::vector<uint16_t> list;
        list.reserve(count);
        for (uint32_t i = 0; i < count; ++i)
            list.push_back(msg->getU16());
        return list;
    }

    std::vector<uint8_t> readU8List(const InputMessagePtr& msg, const uint32_t count)
    {
        std::vector<uint8_t> list;
        list.reserve(count);
        for (uint32_t i = 0; i < count; ++i)
            list.push_back(msg->getU8());
        return list;
    }
}

void ProtocolGame::parsePSoulMessage(const InputMessagePtr& msg)
{
    const uint8_t subOpcode = msg->getU8();
    switch (subOpcode) {
        case Proto::GameServerPSoulMoveBarUpdate: {
            const uint16_t iconItemId = msg->getU16();
            const auto moves = readU16List(msg, msg->getU8());
            g_lua.callGlobalField("g_game", "onPokemonMoves", iconItemId, moves);
            break;
        }
        case Proto::GameServerPSoulMoveBarClose:
            g_lua.callGlobalField("g_game", "onMoveBarClose");
            break;
        case Proto::GameServerPSoulMoveBarOpen:
            g_lua.callGlobalField("g_game", "onMoveBarOpen");
            g_lua.callGlobalField("g_game", "onPokemonBarOpen");
            break;
        case Proto::GameServerPSoulPokemonBarAdd: {
            const uint16_t itemId = msg->getU16();
            const uint16_t fastcallNumber = msg->getU16();
            const uint8_t textColor = msg->getU8();
            const auto& text = msg->getString();
            g_lua.callGlobalField("g_game", "onPokemonBarAdd", itemId, fastcallNumber, textColor, text);
            break;
        }
        case Proto::GameServerPSoulPokemonBarRemove:
            g_lua.callGlobalField("g_game", "onPokemonBarRemove", msg->getU16());
            break;
        case Proto::GameServerPSoulPokemonBarUpdate: {
            const uint16_t fastcallNumber = msg->getU16();
            const uint8_t textColor = msg->getU8();
            const auto& text = msg->getString();
            g_lua.callGlobalField("g_game", "onPokemonBarUpdate", fastcallNumber, textColor, text);
            break;
        }
        case Proto::GameServerPSoulPokemonBarOpen:
            g_lua.callGlobalField("g_game", "onPokemonBarOpen");
            break;
        case Proto::GameServerPSoulPokemonBarClose:
            g_lua.callGlobalField("g_game", "onPokemonBarClose");
            break;
        case Proto::GameServerPSoulMoveCooldown: {
            const uint16_t itemId = msg->getU16();
            const uint8_t cooldown = msg->getU8();
            g_lua.callGlobalField("g_game", "onPokemonMoveCooldown", itemId, cooldown);
            break;
        }
        case Proto::GameServerPSoulPokedexStatus:
            g_lua.callGlobalField("g_game", "onPokedexStatus", readU8List(msg, msg->getU16()));
            break;
        case Proto::GameServerPSoulPokedexOpen:
            g_lua.callGlobalField("g_game", "onPokedexOpen");
            break;
        case Proto::GameServerPSoulPokedexUpdate: {
            const uint16_t pokemonNumber = msg->getU16();
            const uint8_t status = msg->getU8();
            g_lua.callGlobalField("g_game", "onPokedexUpdate", pokemonNumber, status);
            break;
        }
        case Proto::GameServerPSoulTmChoose: {
            const uint16_t tmMoveItemId = msg->getU16();
            const auto moves = readU16List(msg, msg->getU8());
            g_lua.callGlobalField("g_game", "onTmChoose", tmMoveItemId, moves);
            break;
        }
        case Proto::GameServerPSoulStatusBarAdd: {
            const uint16_t itemId = msg->getU16();
            const uint8_t cooldown = msg->getU8();
            g_lua.callGlobalField("g_game", "onStatusBarAdd", itemId, cooldown);
            break;
        }
        case Proto::GameServerPSoulStatusBarRemove:
            g_lua.callGlobalField("g_game", "onStatusBarRemove", msg->getU16());
            break;
        case Proto::GameServerPSoulStatusBarClear:
            g_lua.callGlobalField("g_game", "onStatusBarClear");
            break;
        case Proto::GameServerPSoulPokedexInfo: {
            const uint16_t pokemonId = msg->getU16();
            const auto& details = msg->getString();
            const auto& moves = msg->getString();
            const auto& effectiveness = msg->getString();
            const auto& families = msg->getString();
            g_lua.callGlobalField("g_game", "onPokedexInfo", pokemonId, details, moves, effectiveness, families);
            break;
        }
        case Proto::GameServerPSoulCreatureJump: {
            if (const auto& creature = g_map.getCreatureById(msg->getU32()))
                creature->jump(20, 450);
            break;
        }
        case Proto::GameServerPSoulCreatureEffect: {
            const uint32_t creatureId = msg->getU32();
            const uint8_t effectId = msg->getU8();
            const uint32_t var = msg->getU32();
            if (const auto& creature = g_map.getCreatureById(creatureId))
                creature->callLuaField("onEffect", effectId, var);
            break;
        }
        // The legacy client stores the U16 counts of 0x14 and 0x19 in a uint8_t; reading the
        // full U16 consumes the same bytes and stays in sync past 255 entries.
        case Proto::GameServerPSoulDollCaseStatus:
            g_lua.callGlobalField("g_game", "onDollCaseStatus", readU8List(msg, msg->getU16()));
            break;
        case Proto::GameServerPSoulDollCaseUpdate: {
            const uint16_t pokemonNumber = msg->getU16();
            const uint8_t status = msg->getU8();
            g_lua.callGlobalField("g_game", "onDollCaseUpdate", pokemonNumber, status);
            break;
        }
        case Proto::GameServerPSoulSlotMachine: {
            const uint8_t result1 = msg->getU8();
            const uint8_t result2 = msg->getU8();
            const uint8_t result3 = msg->getU8();
            g_lua.callGlobalField("g_game", "onSlotMachine", result1, result2, result3);
            break;
        }
        case Proto::GameServerPSoulTip:
            g_lua.callGlobalField("g_game", "onTip", msg->getU8());
            break;
        case Proto::GameServerPSoulPollWindow: {
            const auto& question = msg->getString();
            if (msg->getU8() != 0) {
                g_lua.callGlobalField("g_game", "onPollWindow", question, true);
                break;
            }
            std::map<uint32_t, std::string> options;
            const uint8_t optionCount = msg->getU8();
            for (uint8_t i = 0; i < optionCount; ++i) {
                const uint8_t optionId = msg->getU8();
                options[optionId] = msg->getString();
            }
            g_lua.callGlobalField("g_game", "onPollWindow", question, options);
            break;
        }
        case Proto::GameServerPSoulPokemonLevelUp: {
            const uint16_t pokemonNumber = msg->getU16();
            const uint8_t newLevel = msg->getU8();
            const auto newMoves = readU16List(msg, msg->getU16());
            g_lua.callGlobalField("g_game", "onPokemonLevelUp", pokemonNumber, newLevel, newMoves);
            break;
        }
        case Proto::GameServerPSoulLootList: {
            std::map<uint16_t, uint8_t> lootList;
            const uint8_t count = msg->getU8();
            for (uint8_t i = 0; i < count; ++i) {
                const uint16_t itemId = msg->getU16();
                lootList[itemId] = msg->getU8();
            }
            g_lua.callGlobalField("g_game", "onLootList", lootList);
            break;
        }
        default:
            // The sub-opcode decides the payload length; skipping it would desync the stream.
            throw stdext::exception("[ProtocolGame::parsePSoulMessage] unknown PSoul sub-opcode {}", subOpcode);
    }
}
