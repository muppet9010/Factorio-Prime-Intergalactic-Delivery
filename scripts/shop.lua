local Shop = {}
local Events = require("utility/events")
local Interfaces = require("utility/interfaces")
local Logging = require("utility/logging")

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
end

Shop.OnStartup = function()
    Shop.UpdateItems()
end

Shop.OnSettingChanged = function(event)
    local settingName = event.setting
    if settingName == nil or settingName == "prime_intergalactic_delivery-shop_personal_equipment_cost_multiplier" then
        global.shop.personalEquipmentCostMultiplier = tonumber(settings.global["prime_intergalactic_delivery-shop_personal_equipment_cost_multiplier"].value)
    end
    if settingName == nil or settingName == "prime_intergalactic_delivery-shop_infrastructure_cost_multiplier" then
        global.shop.infrastructureCostMultiplier = tonumber(settings.global["prime_intergalactic_delivery-shop_infrastructure_cost_multiplier"].value)
    end
    if settingName == nil or settingName == "prime_intergalactic_delivery-shop_software_start_cost" then
        global.shop.softwareStartCost = tonumber(settings.global["prime_intergalactic_delivery-shop_software_start_cost"].value)
    end
    if settingName == nil or settingName == "prime_intergalactic_delivery-shop_software_cost_level_multiplier" then
        global.shop.softwareLevelCostMultiplier = tonumber(settings.global["prime_intergalactic_delivery-shop_software_cost_level_multiplier"].value)
    end
    if settingName == nil or settingName == "prime_intergalactic_delivery-shop_software_effect_level_bonus_percent" then
        global.shop.softwareLevelEffectBonus = tonumber(settings.global["prime_intergalactic_delivery-shop_software_effect_level_bonus_percent"].value)
    end
    --[[if settingName == nil or settingName == "prime_intergalactic_delivery-xxx" then
        global.shop.xxxxxx = tonumber(settings.global["prime_intergalactic_delivery-xxx"].value)
    end
    if settingName == nil or settingName == "prime_intergalactic_delivery-xxx" then
        global.shop.xxxxxx = tonumber(settings.global["prime_intergalactic_delivery-xxx"].value)
    end]]
    Shop.UpdateItems()
end

Shop.UpdateItems = function()
    global.shop.items = {}

    local items = {
        modularArmor = {type = "personal", localisedName = "item/modular-armor", picture = "item/modular-armor", price = 210, item = "modular-armor"},
        powerArmor = {type = "personal", localisedName = "item/power-armor", picture = "item/power-armor", price = 1400, item = "power-armor"},
        powerArmorMk2 = {type = "personal", localisedName = "item/power-armor-mk2", picture = "item/power-armor-mk2", price = 16000, item = "power-armor-mk2"},
        solarPanelEquipment = {type = "personal", localisedName = "item/solar-panel-equipment", picture = "item/solar-panel-equipment", price = 40, item = "solar-panel-equipment"},
        fusionReactorEquipment = {type = "personal", localisedName = "item/fusion-reactor-equipment", picture = "item/fusion-reactor-equipment", price = 6400, item = "fusion-reactor-equipment"},
        energyShieldEquipment = {type = "personal", localisedName = "item/energy-shield-equipment", picture = "item/energy-shield-equipment", price = 40, item = "energy-shield-equipment"},
        energyShieldEquipmentMk2 = {type = "personal", localisedName = "item/energy-shield-mk2-equipment", picture = "item/energy-shield-mk2-equipment", price = 590, item = "energy-shield-mk2-equipment"},
        batteryEquipment = {type = "personal", localisedName = "item/battery-equipment", picture = "item/battery-equipment", price = 30, item = "battery-equipment"},
        batteryEquipmentMk2 = {type = "personal", localisedName = "item/battery-mk2-equipment", picture = "item/battery-mk2-equipment", price = 830, item = "battery-mk2-equipment"},
        persoanlLaserDefenseEquipment = {type = "personal", localisedName = "item/personal-laser-defense-equipment", picture = "item/personal-laser-defense-equipment", price = 1100, item = "personal-laser-defense-equipment"},
        exoskeletonEquipment = {type = "personal", localisedName = "item/exoskeleton-equipment", picture = "item/exoskeleton-equipment", price = 520, item = "exoskeleton-equipment"},
        personalRoboportEquipment = {type = "personal", localisedName = "item/personal-roboport-equipment", picture = "item/personal-roboport-equipment", price = 250, item = "personal-roboport-equipment"},
        personalRoboportEquipmentMk2 = {type = "personal", localisedName = "item/personal-roboport-mk2-equipment", picture = "item/personal-roboport-mk2-equipment", price = 4400, item = "personal-roboport-mk2-equipment"},
        nightVisionEquipment = {type = "personal", localisedName = "item/night-vision-equipment", picture = "item/night-vision-equipment", price = 40, item = "night-vision-equipment"},
        beltImmunityEquipment = {type = "personal", localisedName = "item/belt-immunity-equipment", picture = "item/belt-immunity-equipment", price = 40, item = "belt-immunity-equipment"},
        constructionRobot = {type = "infrastructure", localisedName = "item/construction-robot", picture = "item/construction-robot", price = 20, item = "construction-robot"},
        logisticChestStorage = {type = "infrastructure", localisedName = "item/logistic-chest-storage", picture = "item/logistic-chest-storage", price = 20, item = "logistic-chest-storage"},
        roboport = {type = "infrastructure", localisedName = "item/roboport", picture = "item/roboport", price = 290, item = "roboport"}
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
end

return Shop
