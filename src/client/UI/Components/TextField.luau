local Fusion = require("@Packages/fusion")
local Children = Fusion.Children
local OnEvent = Fusion.OnEvent
local OnChange = Fusion.OnChange

type Scope = Fusion.Scope<{ New: typeof(Fusion.New), Computed: typeof(Fusion.Computed) }>
type UsedAs<T> = Fusion.UsedAs<T>

export type TextFieldProps = {
	Text: UsedAs<string>?,
	PlaceholderText: UsedAs<string>?,
	Size: UsedAs<UDim2>?,
	Position: UsedAs<UDim2>?,
	AnchorPoint: UsedAs<Vector2>?,
	BackgroundColor3: UsedAs<Color3>?,
	BackgroundTransparency: UsedAs<number>?,
	BorderSizePixel: UsedAs<number>?,
	Font: UsedAs<Enum.Font>?,
	TextColor3: UsedAs<Color3>?,
	PlaceholderColor3: UsedAs<Color3>?,
	TextSize: UsedAs<number>?,
	TextXAlignment: UsedAs<Enum.TextXAlignment>?,
	TextYAlignment: UsedAs<Enum.TextYAlignment>?,
	TextWrapped: UsedAs<boolean>?,
	TextScaled: UsedAs<boolean>?,
	ClearTextOnFocus: UsedAs<boolean>?,
	MultiLine: UsedAs<boolean>?,
	Visible: UsedAs<boolean>?,
	ZIndex: UsedAs<number>?,
	CornerRadius: UsedAs<number>?,
	OnTextChanged: ((text: string) -> ())?,
	OnFocused: (() -> ())?,
	OnFocusLost: ((enterPressed: boolean) -> ())?,
	[typeof(Children)]: { any }?,
}

local function TextField(scope: Scope, props: TextFieldProps)
	local textBoxProps = {}

	-- Copy all props except custom ones
	for key, value in pairs(props) do
		if key ~= "CornerRadius" and key ~= "OnTextChanged" and key ~= "OnFocused" and key ~= "OnFocusLost" then
			textBoxProps[key] = value
		end
	end

	-- Handle events
	if props.OnTextChanged then
		textBoxProps[OnChange("Text")] = props.OnTextChanged
	end
	if props.OnFocused then
		textBoxProps[OnEvent("Focused")] = props.OnFocused
	end
	if props.OnFocusLost then
		textBoxProps[OnEvent("FocusLost")] = props.OnFocusLost
	end

	-- Handle CornerRadius by adding UICorner to children
	local children = textBoxProps[Children] or {}
	if props.CornerRadius then
		local corner = scope:New("UICorner")({
			CornerRadius = scope:Computed(function(use, scope)
				local radius = use(props.CornerRadius)
				return UDim.new(0, radius)
			end),
		})
		table.insert(children, corner)
		textBoxProps[Children] = children
	end

	return scope:New("TextBox")(textBoxProps)
end

return TextField
