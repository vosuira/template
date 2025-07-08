local Fusion = require("@Packages/fusion")
local Children = Fusion.Children

local Frame = require("@Components/Frame")

local function App(scope)
	return Frame(scope, {
		Name = "App",
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,

		[Children] = {
			-- components mount
		},
	})
end

return App
