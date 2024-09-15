local websocket = require "http.websocket"
local coxpcall = require "coxpcall"
return function(stream, req_headers)
    local self = {
        socket = websocket.new_from_stream(stream, req_headers)
    }
    local function createConnection()
        assert(self.socket:accept())
        local ok = coxpcall.pcall(function()
            while true do
                local data = assert(self.socket:receive(15000))
                assert(self.socket:send("pong"))
            end
        end)
        if not ok then self.socket:close() end
        return true
    end
    local function alertClient(data)
        assert(self.socket:send(data))
    end
    return {
        createConnection = createConnection,
        alertClient = alertClient
    }
end
