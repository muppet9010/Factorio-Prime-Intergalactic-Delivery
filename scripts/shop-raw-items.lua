local ShopRawItemsList = {}

ShopRawItemsList.Get = function()
    return {
        modularArmor = {
            type = "personal",
            shopDisplayName = {"item-name.modular-armor"},
            shopDisplayDescription = {"technology-description.modular-armor"},
            picture = "item/modular-armor",
            price = 210,
            item = "modular-armor"
        },
        powerArmor = {
            type = "personal",
            shopDisplayName = {"item-name.power-armor"},
            shopDisplayDescription = {"technology-description.power-armor"},
            picture = "item/power-armor",
            price = 1400,
            item = "power-armor"
        },
        powerArmorMk2 = {
            type = "personal",
            shopDisplayName = {"item-name.power-armor-mk2"},
            shopDisplayDescription = {"technology-description.power-armor-mk2"},
            picture = "item/power-armor-mk2",
            price = 16000,
            item = "power-armor-mk2"
        },
        solarPanelEquipment = {
            type = "personal",
            shopDisplayName = {"equipment-name.solar-panel-equipment"},
            shopDisplayDescription = {"technology-description.solar-panel-equipment"},
            picture = "item/solar-panel-equipment",
            price = 40,
            item = "solar-panel-equipment"
        },
        fusionReactorEquipment = {
            type = "personal",
            shopDisplayName = {"equipment-name.fusion-reactor-equipment"},
            shopDisplayDescription = {"technology-description.fusion-reactor-equipment"},
            picture = "item/fusion-reactor-equipment",
            price = 6400,
            item = "fusion-reactor-equipment"
        },
        energyShieldEquipment = {
            type = "personal",
            shopDisplayName = {"equipment-name.energy-shield-equipment"},
            shopDisplayDescription = {"technology-description.energy-shield-equipment"},
            picture = "item/energy-shield-equipment",
            price = 40,
            item = "energy-shield-equipment"
        },
        energyShieldEquipmentMk2 = {
            type = "personal",
            shopDisplayName = {"equipment-name.energy-shield-mk2-equipment"},
            shopDisplayDescription = {"technology-description.energy-shield-mk2-equipment"},
            picture = "item/energy-shield-mk2-equipment",
            price = 590,
            item = "energy-shield-mk2-equipment"
        },
        batteryEquipment = {
            type = "personal",
            shopDisplayName = {"equipment-name.battery-equipment"},
            shopDisplayDescription = {"technology-description.battery-equipment"},
            picture = "item/battery-equipment",
            price = 30,
            item = "battery-equipment"
        },
        batteryEquipmentMk2 = {
            type = "personal",
            shopDisplayName = {"equipment-name.battery-mk2-equipment"},
            shopDisplayDescription = {"technology-description.battery-mk2-equipment"},
            picture = "item/battery-mk2-equipment",
            price = 830,
            item = "battery-mk2-equipment"
        },
        personalLaserDefenseEquipment = {
            type = "personal",
            shopDisplayName = {"equipment-name.personal-laser-defense-equipment"},
            shopDisplayDescription = {"technology-description.personal-laser-defense-equipment"},
            picture = "item/personal-laser-defense-equipment",
            price = 1100,
            item = "personal-laser-defense-equipment"
        },
        exoskeletonEquipment = {
            type = "personal",
            shopDisplayName = {"equipment-name.exoskeleton-equipment"},
            shopDisplayDescription = {"technology-description.exoskeleton-equipment"},
            picture = "item/exoskeleton-equipment",
            price = 520,
            item = "exoskeleton-equipment"
        },
        personalRoboportEquipment = {
            type = "personal",
            shopDisplayName = {"equipment-name.personal-roboport-equipment"},
            shopDisplayDescription = {"technology-description.personal-roboport-equipment"},
            picture = "item/personal-roboport-equipment",
            price = 250,
            item = "personal-roboport-equipment"
        },
        personalRoboportEquipmentMk2 = {
            type = "personal",
            shopDisplayName = {"equipment-name.personal-roboport-mk2-equipment"},
            shopDisplayDescription = {"technology-description.personal-roboport-mk2-equipment"},
            picture = "item/personal-roboport-mk2-equipment",
            price = 4400,
            item = "personal-roboport-mk2-equipment"
        },
        nightVisionEquipment = {
            type = "personal",
            shopDisplayName = {"equipment-name.night-vision-equipment"},
            shopDisplayDescription = {"technology-description.night-vision-equipment"},
            picture = "item/night-vision-equipment",
            price = 40,
            item = "night-vision-equipment"
        },
        beltImmunityEquipment = {
            type = "personal",
            shopDisplayName = {"equipment-name.belt-immunity-equipment"},
            shopDisplayDescription = {"technology-description.belt-immunity-equipment"},
            picture = "item/belt-immunity-equipment",
            price = 40,
            item = "belt-immunity-equipment"
        },
        constructionRobot = {
            type = "infrastructure",
            shopDisplayName = {"entity-name.construction-robot"},
            shopDisplayDescription = {"technology-description.construction-robotics"},
            picture = "item/construction-robot",
            price = 20,
            item = "construction-robot"
        },
        logisticChestStorage = {
            type = "infrastructure",
            shopDisplayName = {"entity-name.logistic-chest-storage"},
            shopDisplayDescription = {"entity-description.logistic-chest-storage"},
            picture = "item/logistic-chest-storage",
            price = 20,
            item = "logistic-chest-storage"
        },
        roboport = {
            type = "infrastructure",
            shopDisplayName = {"entity-name.roboport"},
            shopDisplayDescription = {"entity-description.roboport"},
            picture = "item/roboport",
            price = 290,
            item = "roboport"
        },
        softwareMovementSpeed = {
            type = "software",
            shopDisplayName = {"item-name.prime_intergalactic_delivery-software_movement_speed"},
            shopDisplayDescription = {"item-shop-description.prime_intergalactic_delivery-software_movement_speed"},
            picture = "item/prime_intergalactic_delivery-software_movement_speed",
            item = "prime_intergalactic_delivery-software_movement_speed",
            printName = {"item-effect-name.prime_intergalactic_delivery-software_movement_speed"},
            priceCalculationInterfaceName = "Shop.CalculateSoftwarePrice",
            bonusEffectType = "core",
            bonusEffect = function(removing)
                local modifier = global.shop.softwareLevelsApplied["softwareMovementSpeed"] * (global.shop.softwareLevelEffectBonus / 100)
                if removing then
                    modifier = 0 - modifier
                end
                global.force.character_running_speed_modifier = global.force.character_running_speed_modifier + modifier
            end
        },
        softwareMiningSpeed = {
            type = "software",
            shopDisplayName = {"item-name.prime_intergalactic_delivery-software_mining_speed"},
            shopDisplayDescription = {"item-shop-description.prime_intergalactic_delivery-software_mining_speed"},
            picture = "item/prime_intergalactic_delivery-software_mining_speed",
            item = "prime_intergalactic_delivery-software_mining_speed",
            printName = {"item-effect-name.prime_intergalactic_delivery-software_mining_speed"},
            priceCalculationInterfaceName = "Shop.CalculateSoftwarePrice",
            bonusEffectType = "core",
            bonusEffect = function(removing)
                local modifier = global.shop.softwareLevelsApplied["softwareMiningSpeed"] * (global.shop.softwareLevelEffectBonus / 100)
                if removing then
                    modifier = 0 - modifier
                end
                global.force.manual_mining_speed_modifier = global.force.manual_mining_speed_modifier + modifier
            end
        },
        softwareCraftingSpeed = {
            type = "software",
            shopDisplayName = {"item-name.prime_intergalactic_delivery-software_crafting_speed"},
            shopDisplayDescription = {"item-shop-description.prime_intergalactic_delivery-software_crafting_speed"},
            picture = "item/prime_intergalactic_delivery-software_crafting_speed",
            item = "prime_intergalactic_delivery-software_crafting_speed",
            printName = {"item-effect-name.prime_intergalactic_delivery-software_crafting_speed"},
            priceCalculationInterfaceName = "Shop.CalculateSoftwarePrice",
            bonusEffectType = "core",
            bonusEffect = function(removing)
                local modifier = global.shop.softwareLevelsApplied["softwareCraftingSpeed"] * (global.shop.softwareLevelEffectBonus / 100)
                if removing then
                    modifier = 0 - modifier
                end
                global.force.manual_crafting_speed_modifier = global.force.manual_crafting_speed_modifier + modifier
            end
        },
        softwareInventorySize = {
            type = "software",
            shopDisplayName = {"item-name.prime_intergalactic_delivery-software_inventory_size"},
            shopDisplayDescription = {"item-shop-description.prime_intergalactic_delivery-software_inventory_size"},
            picture = "item/prime_intergalactic_delivery-software_inventory_size",
            item = "prime_intergalactic_delivery-software_inventory_size",
            printName = {"item-effect-name.prime_intergalactic_delivery-software_inventory_size"},
            priceCalculationInterfaceName = "Shop.CalculateSoftwarePrice",
            bonusEffectType = "core",
            bonusEffect = function(removing)
                local modifier = global.shop.softwareLevelsApplied["softwareInventorySize"] * global.shop.softwareLevelEffectBonus
                if removing then
                    modifier = 0 - modifier
                end
                global.force.character_inventory_slots_bonus = global.force.character_inventory_slots_bonus + modifier
            end
        }
    }
end

return ShopRawItemsList
