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
        },
        {
            name = "prime_intergalactic_delivery-shop_personal_equipment_block_crafting",
            type = "bool-setting",
            default_value = false,
            setting_type = "startup",
            order = "5101"
        },
        {
            name = "prime_intergalactic_delivery-shop_infrastructure_block_crafting",
            type = "bool-setting",
            default_value = false,
            setting_type = "startup",
            order = "5102"
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
            minimum_value = 0,
            setting_type = "runtime-global",
            order = "5501"
        },
        {
            name = "prime_intergalactic_delivery-shop_infrastructure_cost_multiplier",
            type = "double-setting",
            default_value = 1,
            minimum_value = 0,
            setting_type = "runtime-global",
            order = "5502"
        },
        {
            name = "prime_intergalactic_delivery-shop_weapon_cost_multiplier",
            type = "double-setting",
            default_value = 1,
            minimum_value = 0,
            setting_type = "runtime-global",
            order = "5503"
        },
        {
            name = "prime_intergalactic_delivery-shop_software_start_cost",
            type = "int-setting",
            default_value = 500,
            minimum_value = 0,
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
            name = "prime_intergalactic_delivery-shop_software_max_level",
            type = "int-setting",
            default_value = 20,
            minimum_value = 0,
            setting_type = "runtime-global",
            order = "5604"
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
        },
        {
            name = "prime_intergalactic_delivery-shop_player_whitelist",
            type = "string-setting",
            default_value = "",
            allow_blank = true,
            setting_type = "runtime-global",
            order = "5801"
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
if mods["biter_extermination"] ~= nil then
    data:extend(
        {
            {
                name = "prime_intergalactic_delivery-biter_extermination_item_cost",
                type = "int-setting",
                default_value = 100000,
                minimum_value = 0,
                setting_type = "runtime-global",
                order = "7310"
            }
        }
    )
end
if mods["muppet_streamer"] ~= nil then
    data:extend(
        {
            {
                name = "prime_intergalactic_delivery-muppet_streamer_recruit_team_member_software_start_cost",
                type = "int-setting",
                default_value = 5000,
                minimum_value = 0,
                setting_type = "runtime-global",
                order = "7320"
            },
            {
                name = "prime_intergalactic_delivery-muppet_streamer_recruit_team_member_software_cost_level_multiplier",
                type = "double-setting",
                default_value = 2,
                minimum_value = 0,
                setting_type = "runtime-global",
                order = "7321"
            }
        }
    )
end
