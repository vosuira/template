local Framework = require("@Shared/Framework")
local Players = game:GetService("Players")

local Server = Framework.New(script.Parent.Modules)
	:Bind("PlayerAdded", Players.PlayerAdded, "OnPlayerAdded")
	:Bind("PlayerRemoving", Players.PlayerRemoving, "OnPlayerRemoving")

Server:Run():andThen(function()
	Server:Connect()
end)
