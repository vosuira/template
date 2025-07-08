-- [ SERVICES ] --

local Players = game:GetService("Players")
local App = require("@Shared/App")

-- [ PACKAGES ] --

local Fusion = require("@Packages/fusion")
local New = Fusion.New
local scoped = Fusion.scoped
local Children = Fusion.Children

local InterfaceController = {}

local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local scope = scoped(Fusion)

function InterfaceController:Init()
	local Interface = New(scope, "ScreenGui")({
		Name = "Interface",
		Parent = PlayerGui,

		[Children] = {
			App(scope),
		},
	})

	self.Interface = Interface
end

return InterfaceController
