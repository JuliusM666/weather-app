local http_headers = require "http.headers"
local jsonParser = require 'App.Server.jsonParser'
local Response = { data = nil, stream = nil, res_headers = nil, jsonParser = jsonParser() }
Response.setStream = function(self, stream)
    self.stream = stream
    return self
end
Response.json = function(self, data)
    local res_headers = http_headers.new()
    res_headers:append(":status", "200")
    res_headers:append("content-type", "application/json")
    self.data = self.jsonParser.encode(data)
    self.res_headers = res_headers
    return self
end
Response.send = function(self, req_method)
    assert(self.stream:write_headers(self.res_headers, req_method == "HEAD"))
    assert(self.stream:write_chunk(self.data, true))
    self.data = nil
    self.stream = nil
    self.res_headers = nil
end
return Response
