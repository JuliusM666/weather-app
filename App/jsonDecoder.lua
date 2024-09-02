local json = require('cjson')
return function()
    local decode = function(data) -- parse json data
        return json.decode(data)
    end
    local decodeError = function(data) -- parse json error from api
        return json.decode(data).message
    end
    return {
        decode = decode,
        decodeError = decodeError
    }
end
