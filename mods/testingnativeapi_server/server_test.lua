--runs every server class; output sent to worlds/world/server_dump.txt
minetest.register_chatcommand("test_server_classes", {
	description = "test all server classes",
	func = function()

		--fill this with all the class names to be tested
		local server_classes = {
			"areastore",
			"auth",
			"inventory",
			"particles",
			"noise",
			"nodetimer",
			"modchannels",
			"settings",
			"itemstackmeta",
			"metadata",
			"vmanip",
			"rollback",
			"nodemeta",
			"util",
			"base"
		}

		native_tests.clear_file();

		--test each class
		local total = 0
		local hits = 0
		for k,v in pairs(server_classes) do
			local res = minetest.registered_chatcommands["test_"..v].func()
			if res then
				hits = hits + 1
			end
			total = total + 1
		end

		--write total result to file
		native_tests.open_file()
		native_tests.write("***SERVER TESTS COMPLETED: "..hits.." PASSED, "..total-hits.." FAILED***\n\n")
		native_tests.close_file()

		return true, "Server tests completed. See server_dump.txt for details."
	end
})

--clear server_dump.txt (output of testing individual classes always appends to file; useful to clear previous tests)
minetest.register_chatcommand("clear_dump", {
	description = "clears server_dump.txt",
	func = function()
		return native_tests.clear_file(), "server_dump.txt cleared"
	end
})