--Gets name of current player and lets you change it by sending a chat message - needed for tests
local playerName = "singleplayer"
core.register_on_chat_message(function(name, message)
    playerName = name
    core.chat_send_player(name, "Test player name changed to: ".. name)
end)

--Can't catch cancelled shutdown notification messages, so visually observed cancellation for all three functions
core.register_chatcommand("lua_request_shutdown", {
    description="Invokes lua_api > request_shutdown",
    func  = function(self)
        core.request_shutdown("lua shutdown requested", true, 1)
        core.request_shutdown("lua canceling shutdown", true, -1)
        return true
    end    
})

core.register_chatcommand("native_request_shutdown", {
    description="Invokes native_api > request_shutdown",
    func  = function(self)
        core.native_request_shutdown("lua shutdown requested", true, 100)
        core.native_request_shutdown("lua canceling shutdown", true, -1)
        return true
    end 
})

core.register_chatcommand("test_request_shutdown", {
    description="Tests both lua and native shutdowns",
    func = function (self)
        core.request_shutdown("lua shutdown requested", true, 100)
        core.request_shutdown("lua canceling shutdown", true, -1)
        core.native_request_shutdown("lua shutdown requested", true, 100)
        core.native_request_shutdown("lua canceling shutdown", true, -1)
        return true
    end
})

--may require visual confirmation because server status may change between function calls
core.register_chatcommand("lua_get_server_status", {
    description="Invokes lua_api > get_server_status",
    func = function (self)
        local status = core.get_server_status()
        if status ~= nil then return true, "Sever status: "..status
        else return false, "Server status not gotten" end
    end
})

core.register_chatcommand("native_get_server_status", {
    description="Invokes native_api > get_server_status",
    func = function (self)
        local status = core.native_get_server_status()
        if status ~= nil then return true, "Sever status: "..status
        else return false, "Server status not gotten" end
    end
})

core.register_chatcommand("test_get_server_status", {
    description="Invokes both lua and native server statuses",
    func = function (self)
        local luaStatus = core.get_server_status()
        local nativeStatus = core.native_get_server_status()
        if luaStatus == nativeStatus then return true, "Statuses are the same"
        else return false, "Lua status: "..luaStatus.."\nnative status: "..nativeStatus end
    end
})

--may require visual confirmation because server status may change between function calls
core.register_chatcommand("lua_get_server_uptime", {
    description="Invokes lua_api > get_server_uptime",
    func = function (self)
        local uptime = core.get_server_uptime()
        if uptime ~= nil then return true, "Sever uptime: "..uptime
        else return false, "Server uptime not gotten" end
    end
})

core.register_chatcommand("native_get_server_uptime", {
    description="Invokes native_api > get_server_uptime",
    func = function (self)
        local uptime = core.native_get_server_uptime()
        if uptime ~= nil then return true, "Sever uptime: "..uptime
        else return false, "Server uptime not gotten" end
    end
})

core.register_chatcommand("test_get_server_uptime", {
    description="Compares lua and native functions for get_server_uptime",
    func = function (self)
        local luaUp = core.get_server_uptime()
        local nativeUp = core.native_get_server_uptime()
        if luaUp == nativeUp then return true, "Server uptimes were the same"
        else return false, "Lua uptime: "..luaUp.." Native uptime: "..nativeUp end
    end
})

--visually observed results in debug console
core.register_chatcommand("lua_print", {
    description="Invokes lua_api > print",
    func = function ()
        print("lua print invoked")
        return true
    end
})
--native print only works when called from core
core.register_chatcommand("native_print", {
    description="Invokes native_api > print",
    func = function ()
        core.native_print("native print invoked")
        return true
    end
})

core.register_chatcommand("test_print", {
    description="Invokes native_api > print and lua_api > print",
    func = function ()
        print("lua print invoked")
        core.native_print("native print invoked")
        return true
    end
})

--visually observed results in debug console 
core.register_chatcommand("lua_chat_send_all", {
    description="Invokes lua_api > chat_send_all",
    func = function (self)
        core.chat_send_all("lua chat message sent")
    end
})

core.register_chatcommand("native_chat_send_all", {
    description="Invokes native_api > chat_send_all",
    func = function (self)
        core.native_chat_send_all("native chat message sent")
    end
})

core.register_chatcommand("test_chat_send_all", {
    description="Invokes native_api > chat_send_all",
    func = function (self)
        core.chat_send_all("lua chat message sent")
        core.native_chat_send_all("native chat message sent")
    end
})

--visually observed results in debug console 
core.register_chatcommand("lua_chat_send_player", {
    description="Invokes lua_api > chat_send_player",
    func = function (self)
        core.chat_send_player(playerName, "lua chat message to "..playerName.." sent")
    end
})

core.register_chatcommand("native_chat_send_player", {
    description="Invokes native_api > chat_send_player",
    func = function (self)
        core.native_chat_send_player(playerName, "Native chat message to "..playerName.." sent")
    end
})

core.register_chatcommand("test_chat_send_player", {
    description="Invokes both lua_api and native_api chat_send_player",
    func = function (self)
        core.chat_send_player(playerName, "lua chat message to "..playerName.." sent")
        core.native_chat_send_player(playerName, "Native chat message to "..playerName.." sent")
    end
})

core.register_chatcommand("lua_get_player_privs", {
    description="Invokes lua_api > get_player_privs",
    func = function (self)
        local privs = core.get_player_privs(playerName)
        if privs ~= nil then return true, "Got player privs"
        else return false, "Did not get player privs" end
    end
})

core.register_chatcommand("native_get_player_privs", {
    description="Invokes native_api > get_player_privs",
    func = function (self)
        local privs = core.native_get_player_privs(playerName)
        if privs ~= nil then return true, "Got player privs"
        else return false, "Did not get player privs" end
    end
})

core.register_chatcommand("test_get_player_privs", {
    description="Compares get_player_privs output for lua and native APIs",
    func = function (self)
        local luaPrivs = core.get_player_privs(playerName)
        local nativePrivs = core.native_get_player_privs(playerName)
        if dump(luaPrivs) == dump(nativePrivs) then return true, "Lua and native privs identical"
        else return false, "Lua privs: "..dump(luaPrivs).."\nnative privs: "..dump(nativePrivs) end
    end
})

core.register_chatcommand("lua_get_player_ip", {
    description="Invokes lua_api > get_player_ip",
    func = function (self)
        local ip = core.get_player_ip(playerName)
        if ip ~= nil then return true, "Player ip returned"
        else return false, "Player ip not returned" end
    end
})

core.register_chatcommand("native_get_player_ip", {
    description="Invokes native_api > get_player_ip",
    func = function (self)
        local ip = core.native_get_player_ip(playerName)
        if ip ~= nil then return true, "Player ip returned"
        else return false, "Player ip not returned" end
    end
})

core.register_chatcommand("test_get_player_ip", {
    description="Compares get_player_ip output for lua and native APIs",
    func = function (self)
        local luaip = core.get_player_ip(playerName)
        local nativeip = core.native_get_player_ip(playerName)
        if luaip == nativeip then return true, "Lua and native ips identical"
        else return false, "Lua ip: "..luaip.."\nnative ip: "..nativeip end
    end
})

core.register_chatcommand("lua_get_player_information", {
    description="Invokes lua_api > get_player_information",
    func = function (self)
        local info = core.get_player_ip(playerName)
        if info ~= nil then return true, "Player information returned"
        else return false, "Player information not returned" end
    end
})

core.register_chatcommand("native_get_player_information", {
    description="Invokes native_api > get_player_information",
    func = function (self)
        local info = core.native_get_player_ip(playerName)
        if info ~= nil then return true, "Player information returned"
        else return false, "Player information not returned" end
    end
})

core.register_chatcommand("test_get_player_information", {
    description="Compares get_player_information output for lua and native APIs",
    func = function ()
        local luaInfo = core.get_player_information(playerName)
        local nativeInfo = core.get_player_information(playerName)
        if dump(luaInfo) == dump(nativeInfo) then return true, "Lua and native player info identical"
        else return false, "Lua info: "..dump(luaInfo).."native info: "..dump(nativeInfo) end
    end
})

local mockPlayer = {
    is_player = function ()
        return true
    end,
    get_player_name = function ()
        return "mockPlayer"
    end
}

core.register_chatcommand("lua_get_ban_list", {
    description="Invokes lua_api > get_ban_list",
    func = function (self)
        core.ban_player(playerName)
        local banlist = core.get_ban_list()
        core.unban_player_or_ip(playerName)
        if banlist ~= "" then return true, banlist
        else return false, "No ban list returned" end
    end
})

core.register_chatcommand("native_get_ban_list", {
    description="Invokes native_api > get_ban_list",
    func = function (self)
        core.ban_player(playerName)
        local banlist = core.native_get_ban_list()
        core.unban_player_or_ip(playerName)
        if banlist ~= "" then return true, banlist
        else return false, "No ban list returned" end
    end
})

core.register_chatcommand("test_get_ban_list", {
    description="Compares output of lua and native get_ban_list",
    func= function (self)
        core.ban_player(playerName)
        local luaBanlist = core.get_ban_list()
        core.unban_player_or_ip(playerName)

        core.ban_player(playerName)
        local nativeBanlist = core.native_get_ban_list()
        core.unban_player_or_ip(playerName)

        if luaBanlist ~= "" and luaBanlist == nativeBanlist then return true, "Banlists were the same"
        else return false, "Lua banlist: "..luaBanlist.." Native banlist: "..nativeBanlist end
    end
})

core.register_chatcommand("lua_get_ban_description", {
    description="Invokes lua_api > get_ban_description",
    func = function (self)
        core.ban_player(playerName)
        local banDesc = core.get_ban_description(playerName)
        core.unban_player_or_ip(playerName)
        if banDesc ~= "" then return true, banDesc
        else return false, "No ban list returned" end
    end
})

core.register_chatcommand("native_get_ban_description", {
    description="Invokes native_api > get_ban_description",
    func = function (self)
        core.ban_player(playerName)
        local banDesc = core.native_get_ban_description(playerName)
        core.unban_player_or_ip(playerName)
        if banDesc ~= "" then return true, banDesc
        else return false, "No ban list returned" end
    end
})

core.register_chatcommand("test_get_ban_description", {
    description="Compares output of lua and native get_ban_description",
    func= function (self)
        core.ban_player(playerName)
        local luaDesc = core.get_ban_description(playerName)
        core.unban_player_or_ip(playerName)

        core.ban_player(playerName)
        local nativeDesc = core.native_get_ban_description(playerName)
        core.unban_player_or_ip(playerName)

        if luaDesc ~= "" and luaDesc == nativeDesc then return true, "Ban descriptions were the same"
        else return false, "Lua ban desc: "..luaDesc.." Native ban desc: "..nativeDesc end
    end
})

--can momentarily ban yourself to test function
core.register_chatcommand("lua_ban_player", {
    description="Invokes lua_api > ban_player",
    func = function (self)
        local banned = core.ban_player(playerName)
        core.unban_player_or_ip(playerName)
        return banned, "Player banned: "..tostring(banned)
    end
})

core.register_chatcommand("native_ban_player", {
    description="Invokes native_api > ban_player",
    func = function (self)
        local banned = core.native_ban_player(playerName)
        core.unban_player_or_ip(playerName)
        return banned, "Player banned: "..tostring(banned)
    end
})

core.register_chatcommand("test_ban_player", {
    description="Compares ban result for lua and native ban_player",
    func= function (self)
        local luaBanned = core.ban_player(playerName)
        core.unban_player_or_ip(playerName)
        local nativeBanned = core.native_ban_player(playerName)
        core.unban_player_or_ip(playerName)
        if luaBanned and nativeBanned then return true, "Lua and native ban_player worked"
        else return false, "Lua ban"..tostring(luaBanned).." Native ban: "..tostring(nativeBanned) end
    end
})

--must visually confirm because API has no unkick (maybe future dev can add automation?)
core.register_chatcommand("lua_kick_player", {
    description="Invokes lua_api > kick_player",
    func = function (self)
        core.kick_player(playerName)
    end
})

core.register_chatcommand("native_kick_player", {
    description="Invokes native_api > kick_player",
    func = function (self)
        core.native_kick_player(playerName)
    end
})

--must open 2 other Minetest instances and join with usernames mockclient1 and mockclient2 to use
core.register_chatcommand("test_kick_player", {
    description="Tests kicking players in native and lua APIs",
    func = function (self)
        core.kick_player("mockclient1")
        core.native_kick_player("mockclient2")
        local players = core.get_connected_players()
        local playerCt = 0
        for _ in ipairs(players) do
            playerCt = playerCt+1
        end
        if playerCt == 1 then return true, "Players succesfully kicked"
        else return false, "Players were not succesfully kicked"..dump(players) end
    end
})

--[[
Must run on three cases for comprehensive testing:
1. mockplayer doesn't exist
2. mockplayer exists but is offline
3. mockplayer is online
]]

core.register_chatcommand("lua_remove_player", {
    description="Invokes lua_api > remove_player",
    func = function (self)
        local code = core.remove_player("mockplayer")
        if code == 0 then return true, "playerRemoval successful"
        elseif code == 1 then return true, "player did not exist"
        elseif code == 2 then return true, "player currently online"
        else return false, "Unknown status code" end
    end
})

core.register_chatcommand("native_remove_player", {
    description="Invokes native_api > remove_player",
    func = function (self)
        local code = core.native_remove_player("mockplayer")
        if code == 0 then return true, "playerRemoval successful"
        elseif code == 1 then return true, "player did not exist"
        elseif code == 2 then return true, "player currently online"
        else return false, "Unknown status code" end
    end
})

--make sure that mockplayer 1 and mockplayer 2 have the same status
core.register_chatcommand("test_remove_player", {
    description="Tests output of remove_player from Lua and native APIs",
    func = function (self)
        local luaCode = core.remove_player("mockplayer1")
        local nativeCode = core.remove_player("mockplayer2")
        if luaCode == nativeCode then return true, "Lua and native functions return same value"
        else return false, "Lua code: "..luaCode.. " Native code: "..nativeCode end
    end
})

core.register_chatcommand("lua_unban_player_or_ip", {
    description="Invokes lua_api > unban_player_or_ip",
    func = function ()
        core.ban_player(playerName)
        core.unban_player_or_ip(playerName)
        core.ban_player(playerName)
        core.unban_player_or_ip(core.get_player_ip(playerName))
        --no false condition because you will just be banned if test fails
        return true, "Player was unbanned by Lua function"
    end
})

core.register_chatcommand("native_unban_player_or_ip", {
    description="Invokes native_api > unban_player_or_ip",
    func = function ()
        core.ban_player(playerName)
        core.native_unban_player_or_ip(playerName)
        core.ban_player(playerName)
        core.unban_player_or_ip(core.get_player_ip(playerName))
        return true, "Player was unbanned by native function"
    end
})

core.register_chatcommand("test_unban_player_or_ip", {
    description="Tests unban_player_or_ip for both Lua and native APIs",
    func = function ()
        core.ban_player(playerName)
        core.unban_player_or_ip(playerName)
        core.ban_player(playerName)
        core.unban_player_or_ip(core.get_player_ip(playerName))
        return true, "Both Lua and native functions unban player"
    end
})

local testFormspec = {
    "formspec_version[4]",
    "button[1.5,2.3;3,0.8;cringe;Cringe]"
}

core.register_chatcommand("lua_show_formspec", {
    description="Invokes lua_api > show_formspec",
    function (self)
        core.show_formspec(playerName, "lua:formspec", table.concat(testFormspec, ""))
        return true, "Lua formspec shown"
    end
})
