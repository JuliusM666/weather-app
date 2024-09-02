local App = require "App.app"
local UserInterface = require "App.userInterface"

-- Main file to start app
local ok, error = pcall(App) -- check if app produces errors
if not ok then
    local userInterface = UserInterface()
    userInterface.showError(error) -- display error
else
    local app = App()
    app.run() -- start app
end
