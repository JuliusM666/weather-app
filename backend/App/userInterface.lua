return function()
    local showMenu = function() -- show menu
        print(string.rep("-", 100))
        print("| 1: Show forecast by city           | 2: Show forecast by zip   | 3: Show forecast by coordinates |")
        print("| 4: Show favourite cities forecasts | 5: Add new favourite city | 6: Delete favourite city        |")
        print("|                                    |                           | 7: Exit                         |")
        print(string.rep("-", 100))
    end

    local showForecast = function(data) -- show forecast
        print(" City: " .. data.city.name)
        print(string.rep("-", 100))
        for key, value in pairs(data.list) do
            print(value.dt_txt .. " " .. value.main.temp .. "°C " .. value.weather[1].description)
        end
        print(string.rep("-", 100))
    end

    local showError = function(error) -- show error
        local message = error:gsub("(.*): ", "")
        print("\27[1;31;40m" .. message .. "\27[0m")
    end
    local showMessage = function(message) -- show message
        print("\27[1;32;40m" .. message .. "\27[0m")
    end
    return {
        showMenu = showMenu,
        showForecast = showForecast,
        showError = showError,
        showMessage = showMessage
    }
end
