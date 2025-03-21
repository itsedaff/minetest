--Confirm base.lua works by visually observing warningstream in console
minetest.register_chatcommand("lua_base_deprecated_function", {
    description="Test base class method deprecated_function in lua",
    func = function()
        local player = minetest.get_player_by_name("singleplayer")
        player:set_velocity({x=1.0, y=1.0, z=1.0})
        --call deprecated function
        local res_dep = player:get_player_velocity()
        --call regular function
        local res  = player:get_velocity()
        player:set_velocity({x=0.0, y=0.0, z=0.0})
        return true, "Check console log for 1 warning"
    end
})
--result: warningstream visually observed for deprecated_function - PASS

minetest.register_chatcommand("native_base_deprecated_function", {
    description="Test native deprecated function in lua",
    func = function()
        local player = minetest.get_player_by_name("singleplayer")
        player:set_velocity({x=1.0, y=1.0, z=1.0})
        --call native alias of deprecated function
        local res_dep = player:native_get_player_velocity()
        --call regular function
        local res  = player:get_velocity()
        player:set_velocity({x=0.0, y=0.0, z=0.0})

        return true, "Check console log for 1 warning"
    end

})
--note: warningstream visually observed for native alias - PASS

minetest.register_chatcommand("test_base_deprecated_function", {
    func = function()
        local player = minetest.get_player_by_name("singleplayer")
        player:set_velocity({x=1.0, y=1.0, z=1.0})
        --call native alias of deprecated function
        local res_dep_native = player:native_get_player_velocity()
        --call regular deprecated function
        local res_dep  = player:get_player_velocity()
        player:set_velocity({x=0.0, y=0.0, z=0.0})

        return true, "Check console log for 2 warnings"
    end       
})
--note: warningstream visually observed for both native alias and original deprecated function - PASS