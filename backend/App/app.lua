local UserInterface = require "App.userInterface"
local UserInput = require "App.userInput"
return function()
    local self = {

        userInterface = UserInterface(),
        userInput = UserInput(),
    }

    local run = function()                                             -- run app
        while true do
            self.userInterface.showMenu()                              -- show menu
            local ok, error = pcall(function()                         -- check if app produces errors
                self.userInput.userCommand(self.userInput.input(": ")) -- get user input
            end)
            if not ok then                                             -- show error if it accurs
                self.userInterface.showError(error)
            end
        end
    end


    return {
        run = run,
    }
end
