local cityCollector = {}
cityCollector.cityWeather = function(self, data)
    local recolectedData = {}
    recolectedData.list = {}
    for _, value in pairs(data.list) do
        table.insert(recolectedData.list, {
            city = data.city.name,
            date = os.date("%A", value.dt) .. " " .. os.date("%H", value.dt) .. "h",
            temp = value.main.temp .. "°C ",
            description = value.weather[1].description,
            icon = "http://openweathermap.org/img/wn/" .. value.weather[1].icon .. "@2x.png"
        })
    end

    return recolectedData
end

return cityCollector
