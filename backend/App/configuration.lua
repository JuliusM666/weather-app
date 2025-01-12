return function()
    local self = {
        apikey = "",          -- api key
        lang = "en",          -- api language
        format = "json",      -- api format
    }
    local getKey = function() -- api key getter
        return self.apikey == "" and error("Api key is not provided") or self.apikey
    end
    local getLang = function() -- language getter
        return self.lang == "" and "eng" or self.lang
    end
    local getFormat = function() -- format getter
        return self.format == "" and "json" or self.format
    end
    return {
        getKey = getKey,
        getLang = getLang,
        getFormat = getFormat
    }
end
