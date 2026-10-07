-- PS Lib
PS_LIB_DIR = getDataDir() .. "lib/ps/"
PS_LIB_OTHERS_DIR = PS_LIB_DIR .. "others/"
PS_LIB_CONFIG_DIR = PS_LIB_DIR .. "config/"
PS_LIB_SYSTEMS_DIR = PS_LIB_DIR .. "systems/"
PS_LIB_SKILLS_DIR = PS_LIB_DIR .. "skills/"
PS_LIB_FUNCTIONS_DIR = PS_LIB_DIR .. "functions/"

-- Others
dofile(PS_LIB_OTHERS_DIR .. "constants.lua")
dofile(PS_LIB_OTHERS_DIR .. "logger.lua")
dofile(PS_LIB_OTHERS_DIR .. "outfits.lua")

-- Configs
dofile(PS_LIB_CONFIG_DIR .. "itemsAttributes.lua")
dofile(PS_LIB_CONFIG_DIR .. "playersStorages.lua")
dofile(PS_LIB_CONFIG_DIR .. "accountStorages.lua")
dofile(PS_LIB_CONFIG_DIR .. "balls.lua")
dofile(PS_LIB_CONFIG_DIR .. "pokemonsNumbers.lua")
dofile(PS_LIB_CONFIG_DIR .. "pokemonsNames.lua")
dofile(PS_LIB_CONFIG_DIR .. "pokemon.lua")
dofile(PS_LIB_CONFIG_DIR .. "pokemonsStorages.lua")
dofile(PS_LIB_CONFIG_DIR .. "storages.lua")
dofile(PS_LIB_CONFIG_DIR .. "skill.lua")
dofile(PS_LIB_CONFIG_DIR .. "globalStorages.lua")

-- Functions
	-- Balls
	dofile(PS_LIB_FUNCTIONS_DIR .. "ball/charged.lua")
	dofile(PS_LIB_FUNCTIONS_DIR .. "ball/discharged.lua")
	dofile(PS_LIB_FUNCTIONS_DIR .. "ball/empty.lua")
	dofile(PS_LIB_FUNCTIONS_DIR .. "ball/inUse.lua")
	-- Others
	dofile(PS_LIB_FUNCTIONS_DIR .. "player.lua")
	dofile(PS_LIB_FUNCTIONS_DIR .. "pokemon.lua")
	dofile(PS_LIB_FUNCTIONS_DIR .. "abilities.lua")
	dofile(PS_LIB_FUNCTIONS_DIR .. "others.lua")

-- Systems
dodirectory(PS_LIB_SYSTEMS_DIR)

--[[ END ]]
log(LOG_TYPES.INFO, "Planting random seeds...")
for i = 0, 100000 do
    randomize()
end

doUpdatePokemonEggMovesList() -- We need to do it after all beings loaded, cuz we need some functions that will load after the Pokemon section