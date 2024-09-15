local json = require('cjson')
return function()
    local decode = function(data)
        return json.decode(data)
    end
    local decodeError = function(data)
        return json.decode(data)
    end
    local encode = function(data)
        return json.encode(data)
    end
    return {
        decode = decode,
        decodeError = decodeError,
        encode = encode

    }
end
