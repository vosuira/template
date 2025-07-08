local Fusion = require("@Packages/fusion")
local Children = Fusion.Children
local OnEvent = Fusion.OnEvent

type Scope = Fusion.Scope<{ New: typeof(Fusion.New), Computed: typeof(Fusion.Computed) }>
type UsedAs<T> = Fusion.UsedAs<T>

export type ButtonProps = {
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
	Visible: UsedAs<boolean>?,
	ZIndex: UsedAs<number>?,
	CornerRadius: UsedAs<number>?,
	OnActivated: (() -> ())?,
	OnMouseEnter: (() -> ())?,
	OnMouseLeave: (() -> ())?,
	[typeof(Children)]: { any }?,
}

local function Button(scope: Scope, props: ButtonProps)
	local buttonProps = {}

	for key, value in pairs(props) do
		if key ~= "CornerRadius" and key ~= "OnActivated" and key ~= "OnMouseEnter" and key ~= "OnMouseLeave" then
			buttonProps[key] = value
		end
	end

	if props.OnActivated then
		buttonProps[OnEvent("Activated")] = props.OnActivated
	end
	if props.OnMouseEnter then
		buttonProps[OnEvent("MouseEnter")] = props.OnMouseEnter
	end
	if props.OnMouseLeave then
		buttonProps[OnEvent("MouseLeave")] = props.OnMouseLeave
	end

	local children = buttonProps[Children] or {}
	if props.CornerRadius then
		local corner = scope:New("UICorner")({
			CornerRadius = scope:Computed(function(use, scope)
				local radius = use(props.CornerRadius)
				return UDim.new(0, radius)
			end),
		})
		table.insert(children, corner)
		buttonProps[Children] = children
	end

	return scope:New("TextButton")(buttonProps)
end

return Button
