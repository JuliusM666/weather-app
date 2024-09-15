local http_server = require "http.server"
local Router = require 'App.Server.router'
return function()
    local self = {
        port = 3000,
        router = Router()
    }
    local function reply(server, stream)
        local req_headers = assert(stream:get_headers())
        assert(io.stdout:write(string.format('[%s] "%s %s HTTP/%g"  "%s" "%s"\n',
            os.date("%d/%b/%Y:%H:%M:%S %z"),
            req_headers:get ":method" or "",
            req_headers:get(":path") or "",
            stream.connection.version,
            req_headers:get("referer") or "-",
            req_headers:get("user-agent") or "-"
        )))
        self.router.route(req_headers, stream)
    end

    local function setup()
        self.server = assert(http_server.listen {
            host = "localhost",
            port = self.port,
            onstream = reply,
            onerror = function(myserver, context, op, err, errno)
                local msg = op .. " on " .. tostring(context) .. " failed"
                if err then
                    msg = msg .. ": " .. tostring(err)
                end
                assert(io.stderr:write(msg, "\n"))
            end,
        })
    end
    local function run()
        setup()
        assert(self.server:listen())
        do
            local bound_port = select(3, self.server:localname())
            assert(io.stderr:write(string.format("Now listening on port %d\n", bound_port)))
        end
        assert(self.server:loop())
    end

    return {
        run = run
    }
end
