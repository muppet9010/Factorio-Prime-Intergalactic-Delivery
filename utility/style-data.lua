--[[
    "margin" and "padded" are 4 pixels. Margin offsets on the top and left of the outside of the element. Padded keeps inside things away from the bottom and right of the elements. Unlimited things with margin should be stackable inside the padded thing. Margin and Padded combines both for elements that are inside others and have their own contents.
]]
local Colors = require("utility/colors")
local defaultStyle = data.raw["gui-style"]["default"]

local frameShadowRisenColor = {0, 0, 0, 0.35}
local frameShadowSunkenColor = {0, 0, 0, 1}
local frameShadowRisen = function()
    return {
        position = {183, 128},
        corner_size = 8,
        tint = frameShadowRisenColor,
        scale = 0.5,
        draw_type = "inner"
    }
end
local frameShadowSunken = function()
    return {
        position = {200, 128},
        corner_size = 8,
        tint = frameShadowSunkenColor,
        scale = 0.5,
        draw_type = "outer"
    }
end

--FLOW
for _, direction in pairs({{"_horizontal", "horizontal"}, {"_vertical", "vertical"}}) do
    for _, margin in pairs({{"", 0, 0, 0, 0}, {"_marginTL", 4, 4, 0, 0}}) do
        for _, padding in pairs({{"", 0, 0, 0, 0}, {"_paddingBR", 0, 0, 4, 4}}) do
            for _, spacing in pairs({{"", 0}, {"_spaced", 4}}) do
                defaultStyle["muppet_flow" .. direction[1] .. margin[1] .. padding[1] .. spacing[1]] = {
                    type = direction[2] .. "_flow_style",
                    left_margin = margin[2],
                    top_margin = margin[3],
                    right_margin = margin[4],
                    bottom_margin = margin[5],
                    left_padding = padding[2],
                    top_padding = padding[3],
                    right_padding = padding[4],
                    bottom_padding = padding[5],
                    [direction[2] .. "_spacing"] = spacing[2]
                }
            end
        end
    end
end

--FRAME - the shadow types include a +2 pixel padding/margin on the correct side for the shadow.
for _, graphic in pairs(
    {
        {"_main", {base = {position = {0, 0}, corner_size = 8}}, 0, 0},
        {"_main_shadowSunken", {base = {position = {0, 0}, corner_size = 8}, shadow = frameShadowSunken()}, 2, 0},
        {"_main_shadowRisen", {base = {position = {0, 0}, corner_size = 8}, shadow = frameShadowRisen()}, 0, 2},
        {"_content", {base = {position = {68, 0}, corner_size = 8}}, 0, 0},
        {"_content_shadowSunken", {base = {position = {68, 0}, corner_size = 8}, shadow = frameShadowSunken()}, 2, 0},
        {"_content_shadowRisen", {base = {position = {68, 0}, corner_size = 8}, shadow = frameShadowRisen()}, 0, 2},
        {"_contentInnerDark", {base = {position = {34, 0}, corner_size = 8}}, 0, 0},
        {"_contentInnerDark_shadowSunken", {base = {position = {34, 0}, corner_size = 8}, shadow = frameShadowSunken()}, 2, 0},
        {"_contentInnerDark_shadowRisen", {base = {position = {34, 0}, corner_size = 8}, shadow = frameShadowRisen()}, 0, 2},
        {"_contentInnerLight", {base = {position = {0, 17}, corner_size = 8}}, 0, 0},
        {"_contentInnerLight_shadowSunken", {base = {position = {0, 17}, corner_size = 8}, shadow = frameShadowSunken()}, 2, 0},
        {"_contentInnerLight_shadowRisen", {base = {position = {0, 17}, corner_size = 8}, shadow = frameShadowRisen()}, 0, 2}
    }
) do
    for _, margin in pairs({{"", 0, 0, 0, 0}, {"_marginTL", 4, 4, 0, 0}}) do
        for _, padding in pairs({{"", 0, 0, 0, 0}, {"_paddingBR", 0, 0, 4, 4}}) do
            defaultStyle["muppet_frame" .. graphic[1] .. margin[1] .. padding[1]] = {
                type = "frame_style",
                left_margin = margin[2] + graphic[3],
                top_margin = margin[3] + graphic[3],
                right_margin = margin[4] + graphic[3],
                bottom_margin = margin[5] + graphic[3],
                left_padding = padding[2] + graphic[4],
                top_padding = padding[3] + graphic[4],
                right_padding = padding[4] + graphic[4],
                bottom_padding = padding[5] + graphic[4],
                graphical_set = graphic[2]
            }
        end
    end
end

--SCROLL
for _, margin in pairs({{"", 0, 0, 0, 0}, {"_marginTL", 4, 4, 0, 0}}) do
    for _, padding in pairs({{"", 0, 0, 0, 0}, {"_paddingBR", 0, 0, 4, 4}}) do
        defaultStyle["muppet_scroll" .. margin[1] .. padding[1]] = {
            type = "scroll_pane_style",
            left_margin = margin[2],
            top_margin = margin[3],
            right_margin = margin[4],
            bottom_margin = margin[5],
            left_padding = padding[2],
            top_padding = padding[3],
            right_padding = padding[4],
            bottom_padding = padding[5]
        }
    end
end

--TABLE
for _, tableMargin in pairs({{"", 0, 0, 0, 0}, {"_marginTL", 4, 4, 0, 0}}) do
    for _, tablePadding in pairs({{"", 0, 0, 0, 0}, {"_paddingBR", 0, 0, 4, 4}}) do
        for _, cellMargin in pairs({{"", 0, 0, 0, 0}, {"_cellMarginTL", 4, 4, 0, 0}}) do
            for _, cellPadding in pairs({{"", 0, 0, 0, 0}, {"_cellMaddingBR", 0, 0, 4, 4}}) do
                defaultStyle["muppet_table" .. tableMargin[1] .. tablePadding[1] .. cellMargin[1] .. cellPadding[1]] = {
                    type = "table_style",
                    left_margin = tableMargin[2],
                    top_margin = tableMargin[3],
                    right_margin = tableMargin[4],
                    bottom_margin = tableMargin[5],
                    left_padding = tablePadding[2],
                    top_padding = tablePadding[3],
                    right_padding = tablePadding[4],
                    bottom_padding = tablePadding[5],
                    left_cell_margin = cellMargin[2],
                    top_cell_margin = cellMargin[3],
                    right_cell_margin = cellMargin[4],
                    bottom_cell_margin = cellMargin[5],
                    left_cell_padding = cellPadding[2],
                    top_cell_padding = cellPadding[3],
                    right_cell_padding = cellPadding[4],
                    bottom_cell_padding = cellPadding[5]
                }
            end
        end
    end
end

--SPRITE
for _, size in pairs({{"_32", 32}, {"_48", 48}, {"_64", 64}}) do
    defaultStyle["muppet_sprite" .. size[1]] = {
        type = "image_style",
        width = size[2],
        height = size[2],
        margin = 0,
        padding = 0,
        scalable = true,
        stretch_image_to_widget_size = true
    }
end

--SPRITE BUTTON - the attributes are to handle oddness in some base game settings.
for _, attributes in pairs(
    {
        {"", {}},
        {"_frame", {top_margin = 4, default_graphical_set = {base = {position = {0, 0}, corner_size = 8}, shadow = {position = {440, 24}, corner_size = 8, draw_type = "outer"}}}} --top_margin is to fix the unusually high position of this setup,
    }
) do
    for _, size in pairs({{"_mod", 36}, {"_smallText", 28}, {"_clickable", 16}, {"_32", 32}, {"_48", 48}, {"_64", 64}}) do
        local name = "muppet_sprite_button" .. attributes[1] .. size[1]
        defaultStyle[name] = {
            type = "button_style",
            width = size[2],
            height = size[2],
            margin = 0,
            padding = 0,
            scalable = true
        }
        for k, v in pairs(attributes[2]) do
            defaultStyle[name][k] = v
        end
    end
end

defaultStyle.muppet_small_button = {
    type = "button_style",
    padding = 2,
    font = "default"
}
defaultStyle.muppet_large_button = {
    type = "button_style",
    parent = "muppet_small_button",
    font = "default-large-bold"
}

--LABEL
for _, textSize in pairs({{"_small", "default"}, {"_medium", "default-medium"}, {"_large", "default-large"}}) do
    for _, boldness in pairs({{"", ""}, {"_semibold", "-semibold"}, {"_bold", "-bold"}}) do
        for _, purpose in pairs({{"_text", {255, 255, 255}}, {"_heading", Colors.guiheadingcolor}}) do
            for _, margin in pairs({{"", 0, 0, 0, 0}, {"_marginTL", 4, 4, 0, 0}}) do
                for _, padding in pairs({{"", 0, 0, 0, 0}, {"_paddingBR", 0, 0, 4, 4}, {"_paddingSides", 4, 0, 4, 0}}) do
                    defaultStyle["muppet_label" .. purpose[1] .. textSize[1] .. boldness[1] .. margin[1] .. padding[1]] = {
                        type = "label_style",
                        font = textSize[2] .. boldness[2],
                        font_color = purpose[2],
                        single_line = false,
                        left_margin = margin[2],
                        top_margin = margin[3],
                        right_margin = margin[4],
                        bottom_margin = margin[5],
                        left_padding = padding[2],
                        top_padding = padding[3],
                        right_padding = padding[4],
                        bottom_padding = padding[5]
                    }
                end
            end
        end
    end
end

data:extend(
    {
        {
            type = "font",
            name = "default-medium",
            from = "default",
            size = 16
        },
        {
            type = "font",
            name = "default-medium-semibold",
            from = "default-semibold",
            size = 16
        },
        {
            type = "font",
            name = "default-medium-bold",
            from = "default-bold",
            size = 16
        }
    }
)
