local http_util = require "http.util"
local Controller = require 'App.Server.controller'
local coxpcall = require "coxpcall"
local http_headers = require "http.headers"
local json = require('cjson')
return function()
    local controller = Controller()
    local self = {

        GET = {

            ['public'] = function(stream, args, req_method, path)
                controller.index(stream, args, req_method, path)
            end,
            ['/backend/favourite-cities'] = function(stream, args, req_method)
                controller.getFavouriteCities(stream, args, req_method)
            end,
            ['/webSocket'] = function(stream, args, req_headers)
                controller.websocket(stream, args, req_headers)
            end,

        },
        POST = {
            ['/backend/search/city'] = function(stream, args, req_method)
                controller.searchByCity(stream, args, req_method)
            end,
            ['/backend/search/zip'] = function(stream, args, req_method)
                controller.searchByZip(stream, args, req_method)
            end,
            ['/backend/search/coord'] = function(stream, args, req_method)
                controller.searchByCoord(stream, args, req_method)
            end,
            ['/backend/city/add'] = function(stream, args, req_method)
                controller.addCity(stream, args, req_method)
            end,
            ['/backend/city/delete'] = function(stream, args, req_method)
                controller.deleteCity(stream, args, req_method)
            end

        }
    }
    local function route(req_headers, stream)
        local req_method = req_headers:get ":method"
        local path = req_headers:get ":path"
        local splitResult = {}
        for i in string.gmatch(path, "([^?]+)") do
            table.insert(splitResult, i)
        end
        local dir = splitResult[1]



        local args = {}
        if #splitResult > 1 then
            local query = splitResult[2]
            for key, val in http_util.query_args(query) do
                args[key] = val
            end
        end



        if string.match(path, "dist") ~= nil then
            self["GET"]["public"](stream, args, req_method, path)
        elseif string.match(path, "assets") ~= nil then
            self["GET"]["public"](stream, args, req_method, "/dist/" .. path)
        else
            local ok, error = coxpcall.pcall(function()
                if string.match(path, "webSocket") ~= nil then
                    self[req_method][dir](stream, args, req_headers)
                else
                    self[req_method][dir](stream, args, req_method)
                end
            end)
            if not ok then
                print(error)
                local res_headers = http_headers.new()
                res_headers:append(":status", error.cod)
                res_headers:append("content-type", "application/json")
                assert(stream:write_headers(res_headers, req_method == "HEAD"))
                assert(stream:write_chunk(json.encode(error.message), true))
            end
        end
    end


    return {
        route = route
    }
end
