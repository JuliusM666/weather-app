local UserInterface = require "App.userInterface"
local Config = require "App.configuration"
local Api = require "App.api"
local Database = require "App.database"
return function()
    local self = {
        api = Api(Config()),
        userInterface = UserInterface(),
        database = Database(),
    }
    local input = function(label) -- get user input
        io.write(label)
        return io.read()
    end
    local commands =
    {
        ["1"] = function() -- Show forecast by city
            self.userInterface.showForecast(self.api.byCity(input("Enter city name: ")))
        end,
        ["2"] = function() -- Show forecast by ZIP code
            self.userInterface.showForecast(self.api.byZip(input("Enter zip code: ")))
        end,
        ["3"] = function() -- Show forecast by coordinates
            self.userInterface.showForecast(self.api.byCoord(input("Enter latitude: "), input("Enter longitude: ")))
        end,
        ["4"] = function() -- Show favourite cities forecasts
            for city in self.database.findAll() do
                self.userInterface.showForecast(self.api.byCity(city))
            end
        end,
        ["5"] = function()                                           --  Add new favourite city
            local city = string.upper(input("Enter city name: "))    -- get user input
            if self.database.find(city) == true then                 -- check if city already exists in database
                error("this city is already in favourite city list") -- throw error if city already exists
            end
            self.api.byCity(city)                                    -- check if city exists in api
            self.database.store(city)                                -- store city in database
            self.userInterface.showMessage("City added successfully")
        end,
        ["6"] = function()                                        -- Delete favourite city
            local city = string.upper(input("Enter city name: ")) -- get user input
            if self.database.find(city) == false then             -- check if city  exists in database
                error("No such city in faourite cities")          -- throw error if city doesn't exist
            end
            self.database.destroy(city)                           -- delete city from database
            self.userInterface.showMessage("City deleted successfully")
        end,
        ["7"] = function() -- Exit
            os.exit()
        end,
    }
    local userCommand = function(data) -- check if command exists
        if commands[data] then
            commands[data]()
        else
            error("Invalid command") -- throw error if command does not exist
        end
    end


    return {
        input = input,
        userCommand = userCommand
    }
end
