local Constants = require("constants")
local Shared = require("prototypes/_shared")

data:extend(
    {
        {
            type = "capsule",
            name = "prime_intergalactic_delivery-software_movement_speed",
            icon = Constants.AssetModName .. "/graphics/icons/software_movement_speed.png",
            icon_size = 128,
            icon_mipmaps = 1,
            flags = {"hidden"},
            subgroup = "other",
            order = "z",
            stack_size = 1,
            capsule_action = Shared.capsuleAction
        },
        {
            type = "capsule",
            name = "prime_intergalactic_delivery-software_mining_speed",
            icon = Constants.AssetModName .. "/graphics/icons/software_mining_speed.png",
            icon_size = 128,
            icon_mipmaps = 1,
            flags = {"hidden"},
            subgroup = "other",
            order = "z",
            stack_size = 1,
            capsule_action = Shared.capsuleAction
        },
        {
            type = "capsule",
            name = "prime_intergalactic_delivery-software_crafting_speed",
            icon = Constants.AssetModName .. "/graphics/icons/software_crafting_speed.png",
            icon_size = 128,
            icon_mipmaps = 1,
            flags = {"hidden"},
            subgroup = "other",
            order = "z",
            stack_size = 1,
            capsule_action = Shared.capsuleAction
        },
        {
            type = "capsule",
            name = "prime_intergalactic_delivery-software_inventory_size",
            icon = Constants.AssetModName .. "/graphics/icons/software_inventory.png",
            icon_size = 128,
            icon_mipmaps = 1,
            flags = {"hidden"},
            subgroup = "other",
            order = "z",
            stack_size = 1,
            capsule_action = Shared.capsuleAction
        },
        {
            type = "optimized-particle",
            name = "prime_intergalactic_delivery-software_applied_sparks",
            life_time = 24,
            render_layer = "air-object",
            pictures = {
                sheet = {
                    filename = "__base__/graphics/particle/spark-particle/sparks.png",
                    line_length = 12,
                    width = 4,
                    height = 4,
                    frame_count = 12,
                    variation_count = 3,
                    shift = util.by_pixel(0, 0),
                    tint = {r = 0.1, g = 0.1, b = 1, a = 1},
                    hr_version = {
                        filename = "__base__/graphics/particle/spark-particle/hr-sparks.png",
                        line_length = 12,
                        width = 6,
                        height = 6,
                        frame_count = 12,
                        variation_count = 3,
                        scale = 0.5,
                        shift = util.by_pixel(0, 0),
                        tint = {r = 0.1, g = 0.1, b = 1, a = 1}
                    }
                }
            }
        }
    }
)

local CreateSparksTrivialSmoke = function(pngNumber, width, height, shift)
    data:extend(
        {
            {
                type = "trivial-smoke",
                name = "prime_intergalactic_delivery-software_applied_sparks_" .. pngNumber,
                animation = {
                    filename = "__base__/graphics/entity/sparks/sparks-0" .. pngNumber .. ".png",
                    width = width,
                    height = height,
                    frame_count = 19,
                    line_length = 19,
                    shift = shift,
                    tint = {r = 0.1, g = 0.1, b = 1, a = 1},
                    animation_speed = 0.3
                },
                duration = 60,
                affected_by_wind = false,
                show_when_smoke_off = true,
                movement_slow_down_factor = 1,
                render_layer = "higher-object-under"
            }
        }
    )
end
CreateSparksTrivialSmoke("1", 39, 34, {-0.109375, 0.3125})
CreateSparksTrivialSmoke("2", 36, 32, {0.03125, 0.125})
CreateSparksTrivialSmoke("3", 42, 29, {-0.0625, 0.203125})
CreateSparksTrivialSmoke("4", 40, 35, {-0.0625, 0.234375})
CreateSparksTrivialSmoke("5", 39, 29, {-0.109375, 0.171875})
CreateSparksTrivialSmoke("6", 44, 36, {0.03125, 0.3125})
