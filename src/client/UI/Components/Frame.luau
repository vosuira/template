local Fusion = require("@Packages/fusion")
local Children = Fusion.Children

type Scope = Fusion.Scope<{ New: typeof(Fusion.New), Computed: typeof(Fusion.Computed) }>
type UsedAs<T> = Fusion.UsedAs<T>

export type FrameProps = {
	Name: UsedAs<string>?,
	Size: UsedAs<UDim2>?,
	Position: UsedAs<UDim2>?,
	AnchorPoint: UsedAs<Vector2>?,
	BackgroundColor3: UsedAs<Color3>?,
	BackgroundTransparency: UsedAs<number>?,
	BorderSizePixel: UsedAs<number>?,
	ClipsDescendants: UsedAs<boolean>?,
	Visible: UsedAs<boolean>?,
	ZIndex: UsedAs<number>?,
	CornerRadius: UsedAs<number>?,
	[typeof(Children)]: { any }?,
}

local function Frame(scope: Scope, props: FrameProps)
	local frameProps = {}

	for key, value in pairs(props) do
		if key ~= "CornerRadius" then
			frameProps[key] = value
		end
	end

	local children = frameProps[Children] or {}
	if props.CornerRadius then
		local corner = scope:New("UICorner")({
			CornerRadius = scope:Computed(function(use, scope)
				local radius = use(props.CornerRadius)
				return UDim.new(0, radius)
			end),
		})
		table.insert(children, corner)
		frameProps[Children] = children
	end

	return scope:New("Frame")(frameProps)
end

return Frame
