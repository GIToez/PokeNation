// PokeNation / PSoul extended opcodes (packet 0x32: U8 id, string payload).
// Single source of truth for the C++ side; the Lua mirrors are EXTENDED_IDS in
// data/lib/ps/others/constants.lua and ExtendedIds in both clients' gamelib/const.lua.
// Every id, its direction and payload is documented in docs/reference/OPCODES.md §8.

#ifndef __EXTENDEDOPCODES__
#define __EXTENDEDOPCODES__

#include <stdint.h>

enum ExtendedOpcode_t : uint8_t
{
	EXTENDED_OPCODE_ACTIVATE = 0,                // S->C, empty: client may send 0x32 from now on
	EXTENDED_OPCODE_LOCALE = 1,                  // C->S, "0".."LANG_LAST": PokeNation client language (BUG-09)
	EXTENDED_OPCODE_PING = 2,                    // reserved (OTClient ping-back), unused
	EXTENDED_OPCODE_SOUND = 3,                   // reserved (game_environment), unused
	EXTENDED_OPCODE_GAME = 4,                    // reserved, unused
	EXTENDED_OPCODE_PARTICLES = 5,               // reserved, unused
	EXTENDED_OPCODE_MAP_SHADER = 6,              // reserved, unused
	EXTENDED_OPCODE_NEEDS_UPDATE = 7,            // reserved, unused
	EXTENDED_OPCODE_GAMEPLAY_TUTORIAL_TEXT = 8,  // S->C, sent by Lua scripts (game_guide)
	EXTENDED_OPCODE_GAMEPLAY_TUTORIAL_IMAGE = 9, // S->C, sent by Lua scripts (game_guide)
	EXTENDED_OPCODE_DASH_WALKING = 10,           // C->S, "0" or "1"

	// 11..99: reserved for future PokeNation systems; add them here and in OPCODES.md first.
	EXTENDED_OPCODE_LAST_RESERVED = 99,

	// 100..255: handled in Lua by the "ExtendedOpcode" creature event (onExtendedOpcode.lua).
	EXTENDED_OPCODE_POKENATION_SHOP = 201,       // both directions, JSON: PokeNation Shop (057-soulShop.lua)
};

// Largest client->server payload any handler accepts. NetworkMessage already bounds the read;
// this rejects oversized strings before they reach Lua.
static const uint32_t EXTENDED_OPCODE_MAX_PAYLOAD = 4096;

#endif
