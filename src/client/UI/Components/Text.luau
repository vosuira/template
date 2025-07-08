local Fusion = require("@Packages/fusion")
local Children = Fusion.Children

type Scope = Fusion.Scope<{ New: typeof(Fusion.New), Computed: typeof(Fusion.Computed) }>
type UsedAs<T> = Fusion.UsedAs<T>

export type TextProps = {
	Text: UsedAs<string>?,
	Size: UsedAs<UDim2>?,
	Position: UsedAs<UDim2>?,
	AnchorPoint: UsedAs<Vector2>?,
	BackgroundColor3: UsedAs<Color3>?,
	BackgroundTransparency: UsedAs<number>?,
	BorderSizePixel: UsedAs<number>?,
	Font: UsedAs<Enum.Font>?,
	TextColor3: UsedAs<Color3>?,
	TextSize: UsedAs<number>?,
	TextXAlignment: UsedAs<Enum.TextXAlignment>?,
	TextYAlignment: UsedAs<Enum.TextYAlignment>?,
	TextWrapped: UsedAs<boolean>?,
	TextScaled: UsedAs<boolean>?,
	RichText: UsedAs<boolean>?,
	Visible: UsedAs<boolean>?,
	ZIndex: UsedAs<number>?,
	CornerRadius: UsedAs<number>?,
	[typeof(Children)]: { any }?,
}

local function Text(scope: Scope, props: TextProps)
	local textProps = {}

	-- Copy all props except CornerRadius
	for key, value in pairs(props) do
		if key ~= "CornerRadius" then
			textProps[key] = value
		end
	end

	-- Handle CornerRadius by adding UICorner to children
	local children = textProps[Children] or {}
	if props.CornerRadius then
		local corner = scope:New("UICorner")({
			CornerRadius = scope:Computed(function(use, scope)
				local radius = use(props.CornerRadius)
				return UDim.new(0, radius)
			end),
		})
		table.insert(children, corner)
		textProps[Children] = children
	end

	return scope:New("TextLabel")(textProps)
end

return Text
