data:extend(
    {
        {
            name = "prime_intergalactic_delivery-coin_stack_size",
            type = "int-setting",
            default_value = 100,
            minimum_value = 1,
            setting_type = "startup",
            order = "5001"
        },
        {
            name = "prime_intergalactic_delivery-payment_chest_inventory_size",
            type = "int-setting",
            default_value = 480,
            minimum_value = 1,
            setting_type = "startup",
            order = "5002"
        }
    }
)
if mods["item_delivery_pod"] ~= nil then
    data:extend(
        {
            {
                name = "prime_intergalactic_delivery-use_delivery_pod",
                type = "bool-setting",
                default_value = true,
                setting_type = "startup",
                order = "7301"
            },
            {
                name = "prime_intergalactic_delivery-hazard_concrete_delivery_pod_area",
                type = "bool-setting",
                default_value = true,
                setting_type = "startup",
                order = "7302"
            }
        }
    )
end

data:extend(
    {
        {
            name = "prime_intergalactic_delivery-shop_personal_equipment_cost_multiplier",
            type = "double-setting",
            default_value = 1,
            minimum_value = -1,
            setting_type = "runtime-global",
            order = "5501"
        },
        {
            name = "prime_intergalactic_delivery-shop_infrastructure_cost_multiplier",
            type = "double-setting",
            default_value = 1,
            minimum_value = -1,
            setting_type = "runtime-global",
            order = "5502"
        },
        {
            name = "prime_intergalactic_delivery-shop_software_start_cost",
            type = "int-setting",
            default_value = 500,
            minimum_value = -1,
            setting_type = "runtime-global",
            order = "5601"
        },
        {
            name = "prime_intergalactic_delivery-shop_software_cost_level_multiplier",
            type = "double-setting",
            default_value = 2,
            minimum_value = 0,
            setting_type = "runtime-global",
            order = "5602"
        },
        {
            name = "prime_intergalactic_delivery-shop_software_effect_level_bonus_percent",
            type = "double-setting",
            default_value = 5,
            minimum_value = 0,
            setting_type = "runtime-global",
            order = "5603"
        },
        {
            name = "prime_intergalactic_delivery-delivery_min_delay",
            type = "double-setting",
            default_value = 60,
            minimum_value = 0,
            setting_type = "runtime-global",
            order = "5701"
        },
        {
            name = "prime_intergalactic_delivery-delivery_max_delay",
            type = "double-setting",
            default_value = 240,
            minimum_value = 0,
            setting_type = "runtime-global",
            order = "5702"
        }
    }
)
if mods["item_delivery_pod"] ~= nil then
    data:extend(
        {
            {
                name = "prime_intergalactic_delivery-delivery_pod_accuracy",
                type = "int-setting",
                default_value = 20,
                setting_type = "runtime-global",
                order = "7300"
            }
        }
    )
end
