--first requests API table, which must be done in mod body and during startup

local HTTPreq = {
    --URL will always just echo request content, ensuring consistent response for testing
    url = "https://echo.free.beeceptor.com",
    timeout = 10,
    method = "GET",
    data = {},
    extra_headers = { "Accept-Language: en-us", "Accept-Charset: utf-8" }
}

function Sleep (a) 
    local sec = tonumber(os.clock() + a); 
    while (os.clock() < sec) do 
    end 
end

--test commands
core.register_chatcommand("lua_request_http_api", {
    description = "Tests result of lua_api > http.http_request_http_api",
    func = function(self)
        if HTTPApiTable then return true, "HTTP Api Table exists "..dump(HTTPApiTable) 
        else return false, "HTTP API table doesn't exist" end
    end
})

core.register_chatcommand("native_request_http_api", 
{
    description = "Tests result of lua_api > http.http_native_request_http_api",
    func = function(self)
        if NativeHTTPApiTable then return true, "Native HTTP API Table exists "..dump(NativeHTTPApiTable)
        else return false, "Native HTTP API table doesn't exist" end
    end
})

core.register_chatcommand("test_request_http_api", 
{
    description = "Tests result of lua_api > http.http_native_request_http_api",
    func = function(self)
        if dump(HTTPApiTable) == dump(NativeHTTPApiTable) then return true, "Native and Lua tables are the same!"
        else return false, "Native HTTP API table doesn't exist" end
    end
})

core.register_chatcommand("lua_http_fetch_async", 
{
    description = "Invokes lua_api > http.http_fetch_async",
    func = function(self)
        local res = HTTPApiTable.fetch_async(HTTPreq)
        Sleep(2)
        if res then return true, "http_fetch_async returned "..dump(HTTPApiTable.fetch_async_get(res))
        else return false, "http_fetch_async didn't return anything"
        end
    end
})

core.register_chatcommand("native_http_fetch_async", {
    description = "Invokes lua_api > http.native_http_fetch_async",
    func = function(self)
        local res = NativeHTTPApiTable.fetch_async(HTTPreq)
        Sleep(2)
        if res then return true, "native_http_fetch_async returned "..dump(HTTPApiTable.fetch_async_get(res))
        else return false, "native_http_fetch_async didn't return anything"
        end
    end
})

core.register_chatcommand("test_http_fetch_async", {
    description = "Compares Lua and native API outputs",
    func = function (self)
        local res = HTTPApiTable.fetch_async(HTTPreq)
        local nativeRes = NativeHTTPApiTable.fetch_async(HTTPreq)
        Sleep(5)
        if dump(HTTPApiTable.fetch_async_get(res)) == dump(NativeHTTPApiTable.fetch_async_get(nativeRes))
        then return true, "Native and Lua API results were identical"
        else return false, "Native and Lua API results were not identical"
        end
    end
})

core.register_chatcommand("lua_http_fetch_sync", 
{
    description = "Invokes lua_api > http.http_fetch_sync",
    func = function(self)
        local res = HTTPApiTable.fetch_sync(HTTPreq)
        if res then return true, "http_fetch_sync returned"..dump(res) end
    end 
})

core.register_chatcommand("native_http_fetch_sync", 
{
    description = "Invokes lua_api > http.native_http_fetch_sync",
    func = function(self)
        local res = NativeHTTPApiTable.fetch_sync(HTTPreq)
        if res then return true, "native_http_fetch_sync returned"..dump(res) end
    end 
})

--make this helper because subsequent sync requests don't use the same IP address
function CompareTables(table1, table2)
    local identical = true
    for i, v in pairs(table1) do
        if table2[i] ~= v and i ~= "data" then identical = false 
            core.chat_send_all(i)
        end
    end
    for i, v in pairs(table2) do
        if table1[i] ~= v and i ~= "data" then identical = false
            core.chat_send_all(i)
         end
    end
    return identical
end

core.register_chatcommand("test_http_fetch_sync", 
{
    description = "Compares Lua and native API outputs",
    func = function(self)
        local res = HTTPApiTable.fetch_sync(HTTPreq)
        local nativeRes = NativeHTTPApiTable.fetch_sync(HTTPreq)
        local tablesSame = CompareTables(res, nativeRes)
        if tablesSame then return true, "Responses are identical"
        else return false, "Responses are not identical:\n"..dump(res).."\n"..dump(nativeRes) end
    end
})