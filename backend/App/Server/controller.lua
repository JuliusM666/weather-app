local Api = require 'App.api'
local JsonParser = require 'App.Server.jsonParser'
local Config = require "App.configuration"
local http_headers = require "http.headers"
local Response = require 'App.Server.response'
local Database = require 'App.database'
local cityCollector = require 'App.Server.cityCollector'
local webSocket = require 'App.Server.webSocket'
return function()
    local self = {
        jsonParser = JsonParser(),
        api = Api(Config(), JsonParser()),
        database = Database(),
        sockets = {}
    }
    local function alertWebSockets()
        for _, socket in pairs(self.sockets) do
            socket.alertClient("databaseChanged")
        end
    end
    local function searchByCity(stream, query, req_method)
        local data = cityCollector:cityWeather(self.api.byCity(query.city))
        Response:setStream(stream):json(data):send(req_method)
    end
    local function searchByZip(stream, query, req_method)
        local data = cityCollector:cityWeather(self.api.byZip(query.zip))
        Response:setStream(stream):json(data):send(req_method)
    end
    local function searchByCoord(stream, query, req_method)
        local data = cityCollector:cityWeather(self.api.byCoord(query.lat, query.lon))
        Response:setStream(stream):json(data):send(req_method)
    end
    local function addCity(stream, query, req_method)
        local city = self.api.byCity(query.city).city.name
        if self.database.find(city) == true then
            error({
                cod = "403",
                message =
                "this city is already in favourite city list"
            })
        end

        self.database.store(city)
        Response:setStream(stream):json("City added successfully"):send(req_method)
        alertWebSockets()
    end
    local function getFavouriteCities(stream, query, req_method)
        local data = {}
        for city in self.database.findAll() do
            table.insert(data, cityCollector:cityWeather(self.api.byCityOne(city)))
        end
        Response:setStream(stream):json(data):send(req_method)
    end
    local function deleteCity(stream, query, req_method)
        local city = self.api.byCity(query.city).city.name
        if self.database.find(city) == false then
            error({ cod = "404", message = "No such city in faourite cities" })
        end
        self.database.destroy(city)
        Response:setStream(stream):json("City deleted successfully"):send(req_method)
        alertWebSockets()
    end
    local function websocket(stream, args, req_headers)
        local webSock = webSocket(stream, req_headers)
        local pos = #self.sockets + 1
        table.insert(self.sockets, pos, webSock)
        assert(webSock.createConnection())
        table.remove(self.sockets, pos)
    end
    local mimeCase = {
        [".html"] = function()
            return "text/html"
        end,
        [".css"] = function()
            return "text/css"
        end,
        [".js"] = function()
            return "text/javascript"
        end,

        default = function()
            return "text/html"
        end
    }
    local function index(stream, query, req_method, path)
        path = path:sub(2)
        local res_headers = http_headers.new()
        res_headers:append(":status", "200")

        local mimeType = string.match(path, '[.][A-z]+')
        if mimeCase[mimeType] then
            res_headers:append("content-type", mimeCase[mimeType]())
        else
            res_headers:append("content-type", mimeCase["default"]())
        end

        local file = io.open(path, 'r')
        assert(stream:write_headers(res_headers, req_method == "HEAD"))
        assert(stream:write_body_from_file({
            file = file
        }))
        io.close(file)
    end
    return {
        searchByCity = searchByCity,
        searchByCoord = searchByCoord,
        searchByZip = searchByZip,
        addCity = addCity,
        getFavouriteCities = getFavouriteCities,
        deleteCity = deleteCity,
        websocket = websocket,
        index = index
    }
end
