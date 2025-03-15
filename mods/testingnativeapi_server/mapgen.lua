--deletes map database on startup so that mapgen is always used on load
local modpath = core.get_modpath("testingnativeapi_server")
InitEnvVars = assert(loadfile(modpath.."/env.lua", "t"))
--env.lua contains path to selected test world (mapgentest)
InitEnvVars()
assert(os.remove(_G["Path"]))

--collects data from APIs that only work on mapgen threads
MapgenObj = nil
NativeMapgenObj = nil
core.register_on_generated(
function(minp, maxp, blockseed)
    if MapgenObj == nil then MapgenObj = core.get_mapgen_object("voxelmanip") end
    if NativeMapgenObj == nil then NativeMapgenObj = core.native_get_mapgen_object("voxelmanip") end
end)

--normal test commands
core.register_chatcommand("lua_get_biome_data", 
{
    description = "Invokes lua_api > l_get_biome_data",
    func = function (self)
        local player = core.get_player_by_name("singleplayer")
        local pos = player:get_pos()
        local biomeData = core.get_biome_data(pos)
        if biomeData then return true, "Biome data returned: "..dump(biomeData)
        else return false, "Biome data returned nil" end
    end
})

core.register_chatcommand("lua_native_get_biome_data", 
{
    description = "Invokes lua_api > l_native_get_biome_data",
    func = function (self)
        local player = core.get_player_by_name("singleplayer")
        local pos = player:get_pos()
        local biomeData = core.native_get_biome_data(pos)
        if biomeData then return true, "Biome data returned: "..dump(biomeData)
        else return false, "Biome data returned nil" end
    end
})

core.register_chatcommand("lua_test_get_biome_data", 
{
    description = "Compares output of lua and native get_biome_data",
    func = function (self)
        local player = core.get_player_by_name("singleplayer")
        local pos = player:get_pos()
        local biomeData = core.get_biome_data(pos)
        local nativeData = core.native_get_biome_data(pos)
        if dump(biomeData) == dump(nativeData) then return true, "Biome data and native biome data are the same"
        else return false, "Biome Data not the same"..dump(nativeData)..dump(biomeData) end
    end
})

core.register_chatcommand("lua_get_biome_id", 
{
    description = "Invokes lua_api > l_get_biome_id",
    func = function (self)
        local player = core.get_player_by_name("singleplayer")
        local pos = player:get_pos()
        local biomeData = core.native_get_biome_data(pos)
        local biomeName = core.get_biome_name(biomeData["biome"])
        local biomeId = core.get_biome_id(biomeName)
        if biomeId then return true, "BiomeId: "..tostring(biomeId)
        else return false, "function returned nil" end
    end
})

core.register_chatcommand("lua_get_native_biome_id",
{
    description = "Invokes lua_api > l_native_get_biome_id",
    func = function (self)
        local player = core.get_player_by_name("singleplayer")
        local pos = player:get_pos()
        local biomeData = core.native_get_biome_data(pos)
        local biomeName = core.get_biome_name(biomeData["biome"])
        local biomeId = core.native_get_biome_id(biomeName)
        if biomeId then return true, "BiomeId: "..tostring(biomeId)
        else return false, "function returned nil" end
    end
})

core.register_chatcommand("test_get_biome_id", 
{
    description = "Compares output of lua and native get_biome_id",
    func = function(self)
        local player = core.get_player_by_name("singleplayer")
        local pos = player:get_pos()
        local biomeData = core.native_get_biome_data(pos)
        local biomeName = core.get_biome_name(biomeData["biome"])
        local biomeId = core.get_biome_id(biomeName)
        local nativeId = core.native_get_biome_id(biomeName)
        if tostring(biomeId) == tostring(nativeId) then return true, "Success, function output is the same"
        else return false, "Biome Ids are different - Native Id: "..tostring(nativeId).." Lua Id: "..tostring(BiomeId) end
    end
})

core.register_chatcommand("lua_get_biome_name", {
    description = "Invokes lua_api > get_biome_name",
    func = function(self)
        local player = core.get_player_by_name("singleplayer")
        local pos = player:get_pos()
        local biomeData = core.get_biome_data(pos)
        local biomeName = core.get_biome_name(biomeData["biome"])    
        return true, "Biome name: "..tostring(biomeName)
    end
})

core.register_chatcommand("lua_native_get_biome_name", {
    description = "Invokes lua_api > native_get_biome_name",
    func = function(self)
        local player = core.get_player_by_name("singleplayer")
        local pos = player:get_pos()
        local biomeData = core.get_biome_data(pos)
        local biomeName = core.native_get_biome_name(biomeData["biome"])    
        return true, "Biome name: "..tostring(biomeName)
    end
})

core.register_chatcommand("test_native_get_biome_name", {
    description = "Compares output of lua and native get_biome_name",
    func = function(self)
        local player = core.get_player_by_name("singleplayer")
        local pos = player:get_pos()
        local biomeData = core.get_biome_data(pos)
        local biomeName = core.get_biome_name(biomeData["biome"])
        local nativeName = core.native_get_biome_name(biomeData["biome"])
        if biomeName == nativeName then return true, "Lua and native biome names are the same"
        else return false, "Biome and native names are not the same" end
    end
})

core.register_chatcommand("lua_get_heat", {
    description = "Invokes lua_api > get_heat",
    func = function(self)
        local player = core.get_player_by_name("singleplayer")
        local pos = player:get_pos()
        local heat = core.get_heat(pos)
        if heat then return true, "Heat: "..tostring(heat)
        else return false, "function returned nil" end
    end
})

core.register_chatcommand("native_get_heat", {
    description = "Invokes lua_api > native_get_heat",
    func = function(self)
        local player = core.get_player_by_name("singleplayer")
        local pos = player:get_pos()
        local heat = core.native_get_heat(pos)
        if heat then return true, "Heat: "..tostring(heat)
        else return false, "function returned nil" end
    end
})

core.register_chatcommand("test_get_heat", {
    description = "Compares output of lua and native get_heat",
    func = function(self)
        local player = core.get_player_by_name("singleplayer")
        local pos = player:get_pos()
        local heat = core.get_heat(pos)
        local nativeHeat = core.native_get_heat(pos)
        if heat == nativeHeat then return true, "Lua and native heats are the same"
        else return false, "Lua and native heats are not the same" end
    end
})

core.register_chatcommand("lua_get_humidity", {
    description = "Invokes lua_api > get_humidity",
    func = function(self)
        local player = core.get_player_by_name("singleplayer")
        local pos = player:get_pos()
        local hum = core.get_humidity(pos)
        if hum then return true, "Humidity: "..hum
        else return false, "function returned nil" end
    end
})

core.register_chatcommand("lua_native_get_humidity", {
    description = "Invokes lua_api > native_get_humidity",
    func = function(self)
        local player = core.get_player_by_name("singleplayer")
        local pos = player:get_pos()
        local hum = core.native_get_humidity(pos)
        if hum then return true, "Humidity: "..hum
        else return false, "function returned nil" end
    end
})

core.register_chatcommand("test_get_humidity", {
    description = "Compares lua and native get_humidity",
    func = function(self)
        local player = core.get_player_by_name("singleplayer")
        local pos = player:get_pos()
        local nativeHum = core.native_get_humidity(pos)
        local hum = core.get_humidity(pos)
        if hum == nativeHum then return true, "Lua and native humidities are the same"
        else return false, "Lua and native humidities are not the same" end
    end
})

core.register_chatcommand("lua_get_mapgen_object", 
{
    description = "Invokes lua_api > get_mapgen_object",
    func = function (self)
        if MapgenObj then return true, "Mapgen Object: "..dump(MapgenObj)
        else return false, "Function returned nil" end
    end
})

core.register_chatcommand("lua_native_get_mapgen_object", 
{
    description = "Invokes lua_api > native_get_mapgen_object",
    func = function (self)
        if NativeMapgenObj then return true, "Mapgen Object: "..dump(NativeMapgenObj)
        else return false, "Function returned nil" end
    end
})

core.register_chatcommand("test_get_mapgen_object", 
{
    description = "Compares output of lua and native get_mapgen_object",
    func = function (self)
        if dump(MapgenObj) == dump(NativeMapgenObj) then return true, "Mapgen objects are identical"
        else return false, "Mapgen objects are different"..dump(MapgenObj)..dump(NativeMapgenObj) end
    end
})

core.register_chatcommand("lua_get_spawn_level", 
{
    description = "Invokes lua_api > get_spawn_level",
    func = function ()
        local player = core.get_player_by_name("singleplayer")
        local pos = player:get_pos()
        local spawnLvl = core.get_spawn_level(pos["y"], pos["z"])
        if spawnLvl then return true, "spawn result: "..dump(spawnLvl)
        else return false, "spawn level is nil at"..dump(pos) end 
    end
})

core.register_chatcommand("lua_native_get_spawn_level", 
{
    description = "Invokes lua_api > native_get_spawn_level",
    func = function ()
        local player = core.get_player_by_name("singleplayer")
        --teleport to known appropriate spawn location
        player:set_pos({-286.6, 16.5, -197.0})
        local pos = player:get_pos()
        local spawnLvl = core.native_get_spawn_level(pos["y"], pos["z"])
        if spawnLvl then return true, "spawn level: "..dump(spawnLvl) end
    end
})