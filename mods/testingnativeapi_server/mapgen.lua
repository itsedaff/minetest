--deletes map database on startup so that mapgen is always used on load
local modpath = core.get_modpath("testingnativeapi_server")

InitEnvVars = assert(loadfile(modpath.."/env.lua", "t"))
--env.lua contains path to selected test world (mapgentest)
InitEnvVars()
os.remove(_G["Path"])
CompareTables = _G["CompareTables"]
--collects data from APIs that only work on mapgen threads
MapgenObj = nil
NativeMapgenObj = nil
core.register_on_generated(
function(minp, maxp, blockseed)
    if MapgenObj == nil then MapgenObj = core.get_mapgen_object("voxelmanip") end
    if NativeMapgenObj == nil then NativeMapgenObj = core.native_get_mapgen_object("voxelmanip") end

end)

--functions that can only be called on init go here
local testParams = {mgname="flat", seed="3.343534634643243e+18", chunksize=4, water_level=0, flags="caves, dungeons, biomes"}
local defaultParams = {mgname="v7", seed="3.34353463463e+18", chunksize=5, water_level=1, flags="caves, dungeons, light, decorations, biomes, ores"}

local initialParams
local luaParams
local nativeParams
local nativeChanged_params = false
local luaChanged_params = false
local sameValue_params = false


--test set_mapgen_params
initialParams = core.get_mapgen_params()
core.set_mapgen_params(testParams)
luaParams = core.get_mapgen_params()
if dump(luaParams) ~= dump(initialParams) then luaChanged_params = true end
core.set_mapgen_params(defaultParams)

initialParams = core.get_mapgen_params()
core.native_set_mapgen_params(testParams)
nativeParams = core.get_mapgen_params()
if dump(nativeParams) ~= dump(initialParams) then nativeChanged_params = true end
core.native_set_mapgen_params(defaultParams)

sameValue_params = (dump(nativeParams) == dump(luaParams))

--test set_mapgen_setting by changing mapgen name
local initialSetting
local luaSetting
local nativeSetting
local nativeChanged_setting = false
local luaChanged_setting = false
local sameValue_setting

initialSetting = core.get_mapgen_setting("mgname")
core.set_mapgen_setting("mgname", testParams["mgname"], true)
luaSetting = core.get_mapgen_setting("mgname")
if initialSetting ~= luaSetting then luaChanged_setting = true end
core.set_mapgen_setting("mgname", defaultParams["mgname"], true)

initialSetting = core.get_mapgen_setting("mgname")
core.native_set_mapgen_setting("mgname", testParams["mgname"], true)
nativeSetting = core.get_mapgen_setting("mgname")
if initialSetting ~= nativeSetting then nativeChanged_setting = true end
core.native_set_mapgen_setting("mgname", defaultParams["mgname"], true)

sameValue_setting = (nativeSetting == luaSetting)

--test set_mapgen_setting_noiseparams by changing water_level noiseparams
local defaultNoiseparams = 
{ flags = "defaults",
scale = "0",
spread = {
x = "0",
y = "0",
z = "0",
},
seed=0,
offset = "1",
persistence = "0",
lacunarity = "2",
octaves = 0,
}

local testNoiseparams = 
{ flags = "defaults",
scale = "1",
spread = {
x = "2",
y = "5",
z = "3",
},
seed=3,
offset = "2",
persistence = "1",
lacunarity = "0",
octaves = 1, 
}

local initNoiseparams
local luaNoiseparams
local nativeNoiseparams
local luaChanged_noiseparams
local nativeChanged_noiseparams
local sameValue_noiseparams

initNoiseparams = core.get_mapgen_setting_noiseparams("water_level")
core.set_mapgen_setting_noiseparams("water_level", testNoiseparams, true)
luaNoiseparams = core.get_mapgen_setting_noiseparams("water_level")
if dump(initNoiseparams) ~= dump(luaNoiseparams) then luaChanged_noiseparams = true end
core.set_mapgen_setting_noiseparams("water_level", defaultNoiseparams, true)

initNoiseparams = core.get_mapgen_setting_noiseparams("water_level")
core.native_set_mapgen_setting_noiseparams("water_level", testNoiseparams, true) 
nativeNoiseparams = core.get_mapgen_setting_noiseparams("water_level")
if dump(nativeNoiseparams) ~= dump(initNoiseparams) then nativeChanged_noiseparams = true end
core.native_set_mapgen_setting_noiseparams("water_level", defaultNoiseparams, true)

sameValue_noiseparams = (dump(luaNoiseparams) == dump(nativeNoiseparams))

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

core.register_chatcommand("native_get_biome_data", 
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

core.register_chatcommand("native_get_biome_name", {
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

core.register_chatcommand("native_get_humidity", {
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

core.register_chatcommand("native_get_mapgen_object", 
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
        --teleport to known appropriate spawn location
        player:set_pos({x=0, y=10.5, z=-192.0})
        local pos = player:get_pos()
        local spawnLvl = core.get_spawn_level(pos["y"], pos["z"])
        if spawnLvl then return true, "spawn result: "..dump(spawnLvl)
        else return false, "spawn level is nil at"..dump(pos) end 
    end
})

core.register_chatcommand("native_get_spawn_level", 
{
    description = "Invokes lua_api > native_get_spawn_level",
    func = function ()
        local player = core.get_player_by_name("singleplayer")
        player:set_pos({x=0, y=10.5, z=-192.0})
        local pos = player:get_pos()
        local spawnLvl = core.native_get_spawn_level(pos["y"], pos["z"])
        if spawnLvl then return true, "spawn level: "..dump(spawnLvl) end
    end
})

core.register_chatcommand("test_native_get_spawn_level", 
{
    description = "Compares output of lua and native get_spawn_level",
    func = function ()
        local player = core.get_player_by_name("singleplayer")
        player:set_pos({x=0, y=10.5, z=-192.0})
        local pos = player:get_pos()
        local nativeSpawnLvl = core.native_get_spawn_level(pos["y"], pos["z"])
        local spawnLvl = core.get_spawn_level(pos["y"], pos["z"])
        if spawnLvl == nativeSpawnLvl then return true, "spawn levels are the same" 
        else return false, "spawn levels are different" end
    end
})

core.register_chatcommand("lua_get_mapgen_params",
{
    description="Invokes lua_api > get_mapgen_params",
    func=function()
        local mapgenParams = core.get_mapgen_params()
        if mapgenParams then return true, "Mapgen params: "..dump(mapgenParams)
        else return false, "Function returned nil" end
    end
})

core.register_chatcommand("native_get_mapgen_params",
{
    description="Invokes lua_api > get_native_mapgen_params",
    func=function()
        local nativeParams = core.native_get_mapgen_params()
        if nativeParams then return true, "Native mapgen params: "..dump(nativeParams)
        else return false, "Function returned nil" end
    end
})

core.register_chatcommand("test_get_native_mapgen_params",
{
    description="Compares lua and native get_mapgen_params",
    func=function()
        local nativeParams = core.native_get_mapgen_params()
        local mapgenParams = core.get_mapgen_params()
        if dump(mapgenParams) == dump(nativeParams) then return true, "Native and Lua function outputs identical"
        else return false, "Native and Lua function outputs different" end
    end
})

core.register_chatcommand("lua_set_mapgen_params", {
    description="Invokes lua_api > set_mapgen_params",
    func=function ()
    if luaChanged_params then return true, "Mapgen params set with lua_api"
    else return false, "Mapgen params not set with lua_api" end
    end
})

core.register_chatcommand("native_set_mapgen_params", {
    description="Invokes lua_api > set_mapgen_params",
    func=function ()
        if nativeChanged_params then return true, "Mapgen params set with native_api"
        else return false, "Mapgen params not set with native_api" end
    end
})

core.register_chatcommand("test_set_mapgen_params", {
    description="Checks that both set_mapgen_params are the same",
    func = function()
    if sameValue_params then return true, "Lua and native functions set mapgen params to same value"
    else return false, "Lua and native functions did not set mapgen params to same value" end
    end
})
--must pass in name of field of current mapgen that you want
core.register_chatcommand("lua_get_mapgen_setting", {
    description="Invokes lua_api > get_mapgen_setting",
    func = function(self)
        local failedRetrieval = false
        local setting
        setting = core.get_mapgen_setting("mg_name")
        failedRetrieval = (setting == nil)  
        setting = core.get_mapgen_setting("seed")
        failedRetrieval = (setting == nil)
        setting = core.get_mapgen_setting("chunksize")
        failedRetrieval = (setting == nil)
        setting = core.get_mapgen_setting("water_level")
        failedRetrieval = (setting == nil)
        setting = core.get_mapgen_setting("mg_flags")
        failedRetrieval = (setting == nil)
        
        if failedRetrieval == false then return true, "All calls returned values"
        else return false, "Function returned nil at least once" end
    end
})

core.register_chatcommand("native_get_mapgen_setting", {
    description="Invokes lua_api > native_get_mapgen_setting",
    func = function(self)
        local failedRetrieval = false
        local setting
        setting = core.native_get_mapgen_setting("mg_name")
        failedRetrieval = (setting == nil)  
        setting = core.native_get_mapgen_setting("seed")
        failedRetrieval = (setting == nil)
        setting = core.native_get_mapgen_setting("chunksize")
        failedRetrieval = (setting == nil)
        setting = core.native_get_mapgen_setting("water_level")
        failedRetrieval = (setting == nil)
        setting = core.native_get_mapgen_setting("mg_flags")
        failedRetrieval = (setting == nil)
        
        if failedRetrieval == false then return true, "All calls returned values"
        else return false, "Function returned nil at least once" end
    end
})

core.register_chatcommand("test_get_mapgen_setting", {
    description="Compares output of lua and native get_mapgen_setting",
    func = function(self)
        local setting = {
            ["mg_name"] = core.get_mapgen_setting("mg_name"),
            ["seed"] = core.get_mapgen_setting("seed"),
            ["chunksize"] = core.get_mapgen_setting("chunksize"),
            ["water_level"] = core.get_mapgen_setting("water_level"),
            ["mg_flags"] = core.get_mapgen_setting("mg_flags")
        }
        local nativeSetting = {
            ["mg_name"] = core.native_get_mapgen_setting("mg_name"),
            ["seed"] = core.native_get_mapgen_setting("seed"),
            ["chunksize"] = core.native_get_mapgen_setting("chunksize"),
            ["water_level"] = core.native_get_mapgen_setting("water_level"),
            ["mg_flags"] = core.native_get_mapgen_setting("mg_flags")            
        }

        if dump(setting) == dump(nativeSetting) then return true, "Mapgen settings identical"
        else return false, "Setting: "..dump(setting).."Native setting: "..dump(nativeSetting) end
    end
})

core.register_chatcommand("lua_get_mapgen_setting_noiseparams", {
    description="Invokes lua_api > lua_get_mapgen_setting_noiseparams",
    func = function(self)
        local setting
        setting = core.get_mapgen_setting_noiseparams("water_level")
        if setting then return true, "Setting noiseparams: "..dump(setting)
        else return false, "Function call returned nil" end
    end
})

core.register_chatcommand("native_get_mapgen_setting_noiseparams", {
    description="Invokes lua_api > lua_get_mapgen_setting_noiseparams",
    func = function(self)
        setting = core.native_get_mapgen_setting_noiseparams("water_level")
        if setting then return true, "Setting noiseparams:"..dump(setting)
        else return false, "Function call returned nil" end
    end
})

core.register_chatcommand("test_get_mapgen_setting_noiseparams", {
    description="Compares lua and native get_mapgen_setting_noiseparams",
    func = function(self)
        setting = core.get_mapgen_setting_noiseparams("water_level")
        nativeSetting = core.native_get_mapgen_setting_noiseparams("water_level")
        if dump(setting) == dump(nativeSetting) then return true, "Function outputs identical"
        else return false, "Functions returned different values\n setting: "..dump(setting).."\n native setting: "..dump(setting) end
    end
})

core.register_chatcommand("lua_set_mapgen_setting", {
    description="Invokes lua_api > set_mapgen_setting",
    func=function ()
    if luaChanged_setting then return true, "Mapgen params set with lua_api"
    else return false, "Mapgen params not set with lua_api" end
    end
})

core.register_chatcommand("native_set_mapgen_setting", {
    description="Invokes lua_api > set_mapgen_setting",
    func=function ()
        if nativeChanged_setting then return true, "Mapgen params set with native_api"
        else return false, "Mapgen params not set with native_api" end
    end
})

core.register_chatcommand("test_set_mapgen_setting", {
    description="Checks that both set_mapgen_settings are the same",
    func = function()
    if sameValue_setting then return true, "Lua and native functions set mapgen params to same value"
    else return false, "Lua and native functions did not set mapgen params to same value" end
    end
})

core.register_chatcommand("lua_set_mapgen_setting_noiseparams", {
    description="Invokes lua_api > set_mapgen_setting_noiseparams",
    func=function ()
    if luaChanged_noiseparams then return true, "Mapgen noiseparams set with lua_api"
    else return false, "Setting noiseparams not set with lua_api" end
    end
})

core.register_chatcommand("native_set_mapgen_setting_noiseparams", {
    description="Invokes lua_api > set_mapgen_setting",
    func=function ()
        if nativeChanged_noiseparams then return true, "Mapgen noiseparams set with native_api"
        else return false, "Mapgen noiseparams not set with native_api" end
    end
})

core.register_chatcommand("test_set_mapgen_setting_noiseparams", {
    description="Checks that both set_mapgen_settings are the same",
    func = function()
    if sameValue_noiseparams then return true, "Lua and native functions set noiseparams to same value"
    else return false, "Lua and native functions did not set noiseparams to same value" end
    end
})

core.register_chatcommand("lua_set_noiseparams", {
    description = "Invokes lua_api > set_noiseparams",
    func = function ()
        core.set_noiseparams("water_level", testNoiseparams, false)
        local currNoiseparams = core.get_noiseparams("water_level")
        core.set_noiseparams("water_level", defaultNoiseparams, false)
        if dump(currNoiseparams) ~= dump(core.get_noiseparams("water_level")) then return true, "Noiseparams set with lua_api"
        else return false, "Noiseparams not set with lua_api" end
    end
})

core.register_chatcommand("native_set_noiseparams", {
    description = "Invokes native_api > set_noiseparams",
    func = function ()
        core.native_set_noiseparams("water_level", testNoiseparams, false)
        local currNoiseparams = core.native_get_noiseparams("water_level")
        core.native_set_noiseparams("water_level", defaultNoiseparams, false)
        if dump(currNoiseparams) ~= dump(core.native_get_noiseparams("water_level")) then return true, "Noiseparams set with native_api"
        else return false, "Noiseparams not set with native_api" end
    end
})

core.register_chatcommand("test_set_noiseparams", {
    description = "Compares lua and native set_noiseparams",
    func = function ()
        core.set_noiseparams("water_level", testNoiseparams, false)
        local luaNoiseparams = core.get_noiseparams("water_level")
        core.set_noiseparams("water_level", defaultNoiseparams, false)

        core.native_set_noiseparams("water_level", testNoiseparams, false)
        local nativeNoiseparams = core.native_get_noiseparams("water_level")
        core.native_set_noiseparams("water_level", defaultNoiseparams, false)

        if dump(luaNoiseparams) == dump(nativeNoiseparams) then return true, "Noiseparams set to same value"
        else return false, "Noiseparams not set to same value" end
    end
})

core.register_chatcommand("lua_get_noiseparams", {
    description = "Invokes lua_api > get_noiseparams",
    func = function (self)
        local noiseparams = core.get_noiseparams("water_level")
        if noiseparams then return true, "Noiseparams not nil: "..dump(noiseparams)
        else return false, "Function returned nil" end
    end
})

core.register_chatcommand("native_get_noiseparams", {
    description = "Invokes native_api > get_noiseparams",
    func = function (self)
        local noiseparams = core.native_get_noiseparams("water_level")
        if noiseparams then return true, "Noiseparams not nil: "..dump(noiseparams)
        else return false, "Function returned nil" end
    end
})

core.register_chatcommand("test_get_noiseparams", {
    description = "Compares native and lua get_noiseparams",
    func = function (self)
        local noiseParams = core.get_noiseparams("water_level")
        local nativeNoiseparams = core.native_get_noiseparams("water_level")
        if (dump(noiseParams) == dump(nativeNoiseparams)) then return true, "Functions returned same value"
        else return false, "Functions did not return same value" end
    end
})

core.register_chatcommand("get_decorations",
{
    description="Helper command - prints all registered decorations",
    func = function(self)
        local f = io.open("decorations.txt", "w")
        f:write(dump(core.registered_decorations))
        return true
    end
})

--finish after testing get_decoration_id
core.register_chatcommand("lua_set_gen_notify", {
    description="Invokes lua_api > set_gen_notify",
    func = function (self)
        local initGenNotify = core.get_gen_notify()
        core.set_gen_notify("dungeon, temple, decoration", {22})
        local genNotify = core.get_gen_notify()
        core.set_gen_notify("dungeon, temple, cave_begin, cave_end, large_cave_begin, large_cave_end, decoration", {})
        if dump(initGenNotify) ~= dump(genNotify) then return true, "Set gen notify table"
        else return false, "Did not set gen notify table"..dump(initGenNotify)..dump(genNotify) end
    end
})

core.register_chatcommand("lua_get_gen_notify", 
{
    description="Invokes lua_api > get_gen_notify",
    func = function(self)
        local genNotify = core.get_gen_notify()
        if genNotify then return true, "gen_notify table: "..dump(genNotify)
        else return false, "Function returned nil" end
    end
})

core.register_chatcommand("native_get_gen_notify", 
{
    description="Invokes native_api > get_gen_notify",
    func = function(self)
        local genNotify = core.native_get_gen_notify()
        if genNotify then return true, "gen_notify table: "..dump(genNotify)
        else return false, "Function returned nil" end
    end
})

core.register_chatcommand("test_get_gen_notify", 
{
    description="Compares core and native get_gen_notify",
    func = function(self)
        local genNotify = core.get_gen_notify()
        local nativeGenNotify = core.native_get_gen_notify()
        if (dump(genNotify) == dump(nativeGenNotify)) then return true, "Lua and native function output identical"
        else return false, "Lua and native function outputs different"..dump(genNotify)..dump(nativeGenNotify) end
    end
})

core.register_chatcommand("lua_get_decoration_id", 
{
    description="Invokes lua_api > get_decoration_id",
    func = function ()
        local id = core.get_decoration_id("default:grass_5")
        if id then return true, "Decoration id: "..id 
        else return false, "Function returned nil" end
    end
})

core.register_chatcommand("native_get_decoration_id", 
{
    description="Invokes native_api > get_decoration_id",
    func = function ()
        local id = core.native_get_decoration_id("default:grass_5")
        if id then return true, "Decoration id: "..id 
        else return false, "Function returned nil" end
    end
})

core.register_chatcommand("test_get_decoration_id", 
{
    description="Compares Lua and native get_decoration_id",
    func = function ()
        local id = core.native_get_decoration_id("default:grass_5")
        local nativeId = core.native_get_decoration_id("default:grass_5")
        if id == nativeId then return true, "Function outputs were identical. Id: "..id
        else return false, "Function outputs were different \n id: "..id.."\n native id: "..nativeId end
    end
})