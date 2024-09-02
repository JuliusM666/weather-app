local http_request = require "http.request"
local JsonDecoder = require "App.jsonDecoder"
local XmlDecoder = require "App.xmlDecoder"
return function(config)
    local self = {

        address = "https://api.openweathermap.org/data/2.5/forecast?units=metric&appid=" ..
            config.getKey() .. -- get data from configuration file
            "&lang=" .. config.getLang() .. "&mode=" .. config.getFormat(),
        decoder = config.getFormat() == "json" and JsonDecoder() or
            XmlDecoder() -- set decoder
    }

    local getData = function(address) -- send request to api
        local headers, stream = assert(
            http_request.new_from_uri(
                address
            ):go())
        local body = assert(stream:get_body_as_string())
        if headers:get ":status" ~= "200" then
            error(self.decoder.decodeError(body)) -- decode error if it accurs
        end
        return self.decoder.decode(body)          -- return parsed data
    end

    local byCity = function(city) -- get data by city name
        return getData(self.address .. "&q=" .. city)
    end
    local byZip = function(zip) -- get data by ZIP code
        return getData(self.address .. "&zip=" .. zip)
    end
    local byCoord = function(lat, lon) -- get data by coordinates
        return getData(self.address .. "&lat=" .. lat .. "&lon=" .. lon)
    end


    return {
        byCity = byCity,
        byZip = byZip,
        byCoord = byCoord,
    }
end
