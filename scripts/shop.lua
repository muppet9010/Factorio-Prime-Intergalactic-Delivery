local Shop = {}
local Events = require("utility/events")
local Interfaces = require("utility/interfaces")
local Logging = require("utility/logging")

--[[
    global.shop.items[itemName] = {
        type = STRING (personal/infrastructure),
        localisedName = STRING (goes in {} at run time),
        localisedDescription = STRING (goes in {} at run time),
        picture = STRING (sprite path),
        price = NUMBER (for software is something special???),
        item = STRING (the item to deliver)
    }
]]
Shop.CreateGlobals = function()
    global.shop = global.shop or {}
    global.shop.items = global.shop.items or {}
    global.shop.personalEquipmentCostMultiplier = global.shop.personalEquipmentCostMultiplier or 1
    global.shop.infrastructureCostMultiplier = global.shop.infrastructureCostMultiplier or 1
    global.shop.softwareStartCost = global.shop.softwareStartCost or 1
    global.shop.softwareLevelCostMultiplier = global.shop.softwareLevelCostMultiplier or 1
    global.shop.softwareLevelEffectBonus = global.shop.softwareLevelEffectBonus or 1
    global.shop.xx = global.shop.xxx or 1
    global.shop.xxx = global.shop.xxx or 1
end

Shop.OnLoad = function()
    Events.RegisterHandler(defines.events.on_runtime_mod_setting_changed, "Shop.OnSettingChanged", Shop.OnSettingChanged)
    Interfaces.RegisterInterface("Shop.BuyBasketItems", Shop.BuyBasketItems)
end

Shop.OnStartup = function()
    Shop.UpdateItems()
end

Shop.OnSettingChanged = function(event)
    local settingName = event.setting
    local updateItems = false
    if settingName == nil or settingName == "prime_intergalactic_delivery-shop_personal_equipment_cost_multiplier" then
        global.shop.personalEquipmentCostMultiplier = tonumber(settings.global["prime_intergalactic_delivery-shop_personal_equipment_cost_multiplier"].value)
        updateItems = true
    end
    if settingName == nil or settingName == "prime_intergalactic_delivery-shop_infrastructure_cost_multiplier" then
        global.shop.infrastructureCostMultiplier = tonumber(settings.global["prime_intergalactic_delivery-shop_infrastructure_cost_multiplier"].value)
        updateItems = true
    end
    if settingName == nil or settingName == "prime_intergalactic_delivery-shop_software_start_cost" then
        global.shop.softwareStartCost = tonumber(settings.global["prime_intergalactic_delivery-shop_software_start_cost"].value)
        updateItems = true
    end
    if settingName == nil or settingName == "prime_intergalactic_delivery-shop_software_cost_level_multiplier" then
        global.shop.softwareLevelCostMultiplier = tonumber(settings.global["prime_intergalactic_delivery-shop_software_cost_level_multiplier"].value)
        updateItems = true
    end
    if settingName == nil or settingName == "prime_intergalactic_delivery-shop_software_effect_level_bonus_percent" then
        global.shop.softwareLevelEffectBonus = tonumber(settings.global["prime_intergalactic_delivery-shop_software_effect_level_bonus_percent"].value)
        updateItems = true
    end
    --[[if settingName == nil or settingName == "prime_intergalactic_delivery-xxx" then
        global.shop.xxxxxx = tonumber(settings.global["prime_intergalactic_delivery-xxx"].value)
        updateItems = true
    end
    if settingName == nil or settingName == "prime_intergalactic_delivery-xxx" then
        global.shop.xxxxxx = tonumber(settings.global["prime_intergalactic_delivery-xxx"].value)
        updateItems = true
    end]]
    if updateItems then
        Shop.UpdateItems()
    end
end

Shop.UpdateItems = function()
    global.shop.items = {}

    local items = {
        modularArmor = {type = "personal", localisedName = "item-name.modular-armor", localisedDescription = "technology-description.modular-armor", picture = "item/modular-armor", price = 210, item = "modular-armor"},
        powerArmor = {type = "personal", localisedName = "item-name.power-armor", localisedDescription = "technology-description.power-armor", picture = "item/power-armor", price = 1400, item = "power-armor"},
        powerArmorMk2 = {type = "personal", localisedName = "item-name.power-armor-mk2", localisedDescription = "technology-description.power-armor-mk2", picture = "item/power-armor-mk2", price = 16000, item = "power-armor-mk2"},
        solarPanelEquipment = {type = "personal", localisedName = "equipment-name.solar-panel-equipment", localisedDescription = "technology-description.solar-panel-equipment", picture = "item/solar-panel-equipment", price = 40, item = "solar-panel-equipment"},
        fusionReactorEquipment = {type = "personal", localisedName = "equipment-name.fusion-reactor-equipment", localisedDescription = "technology-description.fusion-reactor-equipment", picture = "item/fusion-reactor-equipment", price = 6400, item = "fusion-reactor-equipment"},
        energyShieldEquipment = {type = "personal", localisedName = "equipment-name.energy-shield-equipment", localisedDescription = "technology-description.energy-shield-equipment", picture = "item/energy-shield-equipment", price = 40, item = "energy-shield-equipment"},
        energyShieldEquipmentMk2 = {type = "personal", localisedName = "equipment-name.energy-shield-mk2-equipment", localisedDescription = "technology-description.energy-shield-mk2-equipment", picture = "item/energy-shield-mk2-equipment", price = 590, item = "energy-shield-mk2-equipment"},
        batteryEquipment = {type = "personal", localisedName = "equipment-name.battery-equipment", localisedDescription = "technology-description.battery-equipment", picture = "item/battery-equipment", price = 30, item = "battery-equipment"},
        batteryEquipmentMk2 = {type = "personal", localisedName = "equipment-name.battery-mk2-equipment", localisedDescription = "technology-description.battery-mk2-equipment", picture = "item/battery-mk2-equipment", price = 830, item = "battery-mk2-equipment"},
        personalLaserDefenseEquipment = {type = "personal", localisedName = "equipment-name.personal-laser-defense-equipment", localisedDescription = "technology-description.personal-laser-defense-equipment", picture = "item/personal-laser-defense-equipment", price = 1100, item = "personal-laser-defense-equipment"},
        exoskeletonEquipment = {type = "personal", localisedName = "equipment-name.exoskeleton-equipment", localisedDescription = "technology-description.exoskeleton-equipment", picture = "item/exoskeleton-equipment", price = 520, item = "exoskeleton-equipment"},
        personalRoboportEquipment = {type = "personal", localisedName = "equipment-name.personal-roboport-equipment", localisedDescription = "technology-description.personal-roboport-equipment", picture = "item/personal-roboport-equipment", price = 250, item = "personal-roboport-equipment"},
        personalRoboportEquipmentMk2 = {type = "personal", localisedName = "equipment-name.personal-roboport-mk2-equipment", localisedDescription = "technology-description.personal-roboport-mk2-equipment", picture = "item/personal-roboport-mk2-equipment", price = 4400, item = "personal-roboport-mk2-equipment"},
        nightVisionEquipment = {type = "personal", localisedName = "equipment-name.night-vision-equipment", localisedDescription = "technology-description.night-vision-equipment", picture = "item/night-vision-equipment", price = 40, item = "night-vision-equipment"},
        beltImmunityEquipment = {type = "personal", localisedName = "equipment-name.belt-immunity-equipment", localisedDescription = "technology-description.belt-immunity-equipment", picture = "item/belt-immunity-equipment", price = 40, item = "belt-immunity-equipment"},
        constructionRobot = {type = "infrastructure", localisedName = "entity-name.construction-robot", localisedDescription = "technology-description.construction-robotics", picture = "item/construction-robot", price = 20, item = "construction-robot"},
        logisticChestStorage = {type = "infrastructure", localisedName = "entity-name.logistic-chest-storage", localisedDescription = "entity-description.logistic-chest-storage", picture = "item/logistic-chest-storage", price = 20, item = "logistic-chest-storage"},
        roboport = {type = "infrastructure", localisedName = "entity-name.roboport", localisedDescription = "entity-description.roboport", picture = "item/roboport", price = 290, item = "roboport"}
    }

    for name, itemDetails in pairs(items) do
        if itemDetails.type == "personal" and global.shop.personalEquipmentCostMultiplier > 0 then
            itemDetails.price = itemDetails.price * global.shop.personalEquipmentCostMultiplier
            global.shop.items[name] = itemDetails
        elseif itemDetails.type == "infrastructure" and global.shop.infrastructureCostMultiplier > 0 then
            itemDetails.price = itemDetails.price * global.shop.infrastructureCostMultiplier
            global.shop.items[name] = itemDetails
        elseif itemDetails.type == "software" and global.shop.softwareStartCost > 0 then
            --TODO: handle software
            global.shop.softwareStartCost = global.shop.softwareStartCost or 1
            global.shop.softwareLevelCostMultiplier = global.shop.softwareLevelCostMultiplier or 1
            global.shop.softwareLevelEffectBonus = global.shop.softwareLevelEffectBonus or 1
        end
    end

    Interfaces.Call("ShopGui.RecreateGui")
end

Shop.BuyBasketItems = function()
    if global.itemDeliveryPodModActive then
        game.print("TODO: deliver items via the Item Delivery Pod mod")
    else
        --TODO: this cost is temporary until software is added, make sure taht money is still present to let things be brought in future.
        local cost = 0
        for itemName, quantity in pairs(global.shopGui.shoppingBasket) do
            local itemDetails = global.shop.items[itemName]
            local inserted = global.facility.deliveryChest.insert({name = itemDetails.item, count = quantity})
            cost = cost + (quantity * itemDetails.price)
            if inserted < quantity then
                global.facility.surface.spill_item_stack(global.facility.deliveryChest.position, {name = itemDetails.item, count = quantity - inserted})
            end
        end
        global.facility.paymentChest.remove_item({name = "coin", count = cost})
    end
end

return Shop
