-- Lua-side extended opcodes (ids >= 100). Ids 0..99 are handled in C++ (game.cpp) and never reach here.
-- Every id must be listed in src/extendedopcodes.h and docs/reference/OPCODES.md.
function onExtendedOpcode(cid, opcode, buffer)
    if opcode == SOUL_SHOP_OPCODE then
        return onSoulShopExtendedOpcode(cid, buffer)
    end
    return true
end
