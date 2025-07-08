local Framework = require("@Shared/Framework")

local Client = Framework.New(script.Parent.Controllers)

Client:Run():andThen(function()
	Client:Connect()
end)
