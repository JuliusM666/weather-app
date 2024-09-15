local xml2lua = require("xml2lua")
local handler = require("xmlhandler.tree")

return function()
    local convertData = function(data) -- convert data because json and xml property names are different
        local convertedData = {
            city = {
                name = data.location.name
            },
            list = {

            }

        }
        for key, value in pairs(data.forecast.time) do -- convert property names
            local tmp = { main = {}, weather = { {} } }
            tmp.dt_txt = value._attr.from:gsub("T", " ")
            tmp.main.temp = value.temperature._attr.value
            tmp.weather[1].description = value.symbol._attr.name
            table.insert(convertedData.list, tmp)
        end
        return convertedData
    end
    local decode = function(data) -- parse XML data
        local dataHandler = handler:new()
        local parser = xml2lua.parser(dataHandler)
        parser:parse(data)
        return convertData(dataHandler.root.weatherdata) -- convert data because json and xml property names are different
    end
    local decodeError = function(data)                   -- parse error
        local dataHandler = handler:new()
        local parser = xml2lua.parser(dataHandler)
        parser:parse(data)
        return dataHandler.root.ClientError.message
    end
    return {
        decode = decode,
        decodeError = decodeError
    }
end
