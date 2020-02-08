local Constants = require("constants")
local Colors = require("utility/colors")

data:extend(
    {
        {
            type = "sprite",
            name = "prime_intergalactic_delivery-close_white",
            filename = Constants.AssetModName .. "/graphics/icons/close_white.png",
            size = 16
        },
        {
            type = "sprite",
            name = "prime_intergalactic_delivery-basket_up_arrow",
            filename = "__core__/graphics/gui.png",
            x = 36,
            y = 0,
            width = 10,
            height = 5
        },
        {
            type = "sprite",
            name = "prime_intergalactic_delivery-basket_up_arrow_hovered",
            filename = "__core__/graphics/gui.png",
            x = 36,
            y = 0,
            width = 10,
            height = 5,
            tint = Colors.yellow
        },
        {
            type = "sprite",
            name = "prime_intergalactic_delivery-basket_down_arrow",
            filename = "__core__/graphics/gui.png",
            x = 36,
            y = 6,
            width = 10,
            height = 5
        },
        {
            type = "sprite",
            name = "prime_intergalactic_delivery-basket_down_arrow_hovered",
            filename = "__core__/graphics/gui.png",
            x = 36,
            y = 6,
            width = 10,
            height = 5,
            tint = Colors.yellow
        }
    }
)
