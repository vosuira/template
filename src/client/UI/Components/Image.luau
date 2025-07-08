local Fusion = require("@Packages/fusion")
local Children = Fusion.Children

type Scope = Fusion.Scope<{ New: typeof(Fusion.New), Computed: typeof(Fusion.Computed) }>
type UsedAs<T> = Fusion.UsedAs<T>

export type ImageProps = {
	Image: UsedAs<string>?,
	ImageColor3: UsedAs<Color3>?,
	ImageTransparency: UsedAs<number>?,
	ImageRectOffset: UsedAs<Vector2>?,
	ImageRectSize: UsedAs<Vector2>?,
	ScaleType: UsedAs<Enum.ScaleType>?,
	SliceCenter: UsedAs<Rect>?,
	SliceScale: UsedAs<number>?,
	TileSize: UsedAs<UDim2>?,
	Size: UsedAs<UDim2>?,
	Position: UsedAs<UDim2>?,
	AnchorPoint: UsedAs<Vector2>?,
	BackgroundColor3: UsedAs<Color3>?,
	BackgroundTransparency: UsedAs<number>?,
	BorderSizePixel: UsedAs<number>?,
	Visible: UsedAs<boolean>?,
	ZIndex: UsedAs<number>?,
	CornerRadius: UsedAs<number>?,
	[typeof(Children)]: { any }?,
}

local function Image(scope: Scope, props: ImageProps)
	local imageProps = {}

	for key, value in pairs(props) do
		if key ~= "CornerRadius" then
			imageProps[key] = value
		end
	end

	local children = imageProps[Children] or {}
	if props.CornerRadius then
		local corner = scope:New("UICorner")({
			CornerRadius = scope:Computed(function(use, scope)
				local radius = use(props.CornerRadius)
				return UDim.new(0, radius)
			end),
		})
		table.insert(children, corner)
		imageProps[Children] = children
	end

	return scope:New("ImageLabel")(imageProps)
end

return Image
