local Utils = require("utility/utils")
local Constants = require("constants")
local sounds = require("__base__/prototypes/entity/demo-sounds")

local shopPaymentChest = Utils.DeepCopy(data.raw["logistic-container"]["logistic-chest-requester"])
shopPaymentChest.name = "prime_intergalactic_delivery-shop_payment_chest"
shopPaymentChest.flags = {"placeable-off-grid", "not-blueprintable", "not-deconstructable"}
shopPaymentChest.minable = nil
shopPaymentChest.inventory_size = settings.startup["prime_intergalactic_delivery-payment_chest_inventory_size"].value
table.insert(
    shopPaymentChest.animation.layers,
    {
        filename = Constants.AssetModName .. "/graphics/entity/coin_animation.png",
        priority = "extra-high",
        size = 64,
        frame_count = 7,
        scale = 0.13,
        shift = {0, 0.1}
    }
)
shopPaymentChest.render_not_in_network_icon = false
shopPaymentChest.order = "9999"

local shopDeliveryChest = Utils.DeepCopy(data.raw["logistic-container"]["logistic-chest-passive-provider"])
shopDeliveryChest.name = "prime_intergalactic_delivery-shop_delivery_chest"
shopDeliveryChest.flags = {"placeable-off-grid", "not-blueprintable", "not-deconstructable"}
shopDeliveryChest.minable = nil
shopDeliveryChest.render_not_in_network_icon = false
shopDeliveryChest.order = "9999"

data:extend(
    {
        {
            type = "market",
            name = "prime_intergalactic_delivery-shop_building",
            flags = {"placeable-off-grid"},
            collision_box = {{-1.4, -1.4}, {1.4, 2.4}},
            selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
            map_color = data.raw["utility-constants"].default.chart.default_friendly_color,
            vehicle_impact_sound = sounds.generic_impact,
            picture = {
                layers = {
                    {
                        filename = Constants.AssetModName .. "/graphics/entity/shop_building.png",
                        width = 156,
                        height = 127,
                        shift = {0.95, 0.2}
                    },
                    {
                        filename = Constants.AssetModName .. "/graphics/entity/shop_building_shadow.png",
                        flags = {"shadow"},
                        draw_as_shadow = true,
                        width = 156,
                        height = 127,
                        shift = {0.95, 0.2}
                    }
                }
            }
        },
        {
            type = "simple-entity",
            name = "prime_intergalactic_delivery-shop_building_radar",
            flags = {"placeable-off-grid", "not-selectable-in-game"},
            render_layer = "higher-object-under",
            animations = {
                layers = {
                    {
                        filename = Constants.AssetModName .. "/graphics/entity/shop_building_radar.png",
                        width = 98,
                        height = 128,
                        line_length = 8,
                        frame_count = 64,
                        animation_speed = 0.2,
                        shift = util.by_pixel(-2, -48),
                        scale = 0.75
                    },
                    {
                        filename = Constants.AssetModName .. "/graphics/entity/shop_building_radar_shadow.png",
                        flags = {"shadow"},
                        draw_as_shadow = true,
                        width = 172,
                        height = 94,
                        line_length = 8,
                        frame_count = 64,
                        animation_speed = 0.2,
                        shift = util.by_pixel(64, 25),
                        scale = 0.75
                    }
                }
            },
            water_reflection = {
                pictures = {
                    filename = "__base__/graphics/entity/radar/radar-reflection.png",
                    priority = "extra-high",
                    width = 28,
                    height = 32,
                    shift = util.by_pixel(3, 90),
                    variation_count = 1,
                    scale = 4
                },
                rotate = false,
                orientation_to_variation = false
            }
        },
        {
            type = "simple-entity",
            name = "prime_intergalactic_delivery-shop_building_speaker",
            flags = {"placeable-off-grid"},
            picture = data.raw["programmable-speaker"]["programmable-speaker"].sprite,
            water_reflection = data.raw["programmable-speaker"]["programmable-speaker"].water_reflection
        },
        shopPaymentChest,
        shopDeliveryChest
    }
)
