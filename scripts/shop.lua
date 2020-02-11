local Shop = {}
local Events = require("utility/events")
local Interfaces = require("utility/interfaces")
--local Logging = require("utility/logging")
local ShopRawItemsList = require("scripts/shop-raw-items")
local EventScheduler = require("utility/event-scheduler")
local Utils = require("utility/utils")

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
    global.shop.softwareMaxLevel = global.shop.softwareMaxLevel or 0
    global.shop.softwareLevelsPurchased = global.shop.softwareLevelsPurchased or {}
    global.shop.deliveryDelayMinTicks = global.shop.deliveryDelayMinTicks or 0
    global.shop.deliveryDelayMaxTicks = global.shop.deliveryDelayMaxTicks or 0
end

Shop.OnLoad = function()
    Events.RegisterHandler(defines.events.on_runtime_mod_setting_changed, "Shop.OnSettingChanged", Shop.OnSettingChanged)
    Interfaces.RegisterInterface("Shop.BuyBasketItems", Shop.BuyBasketItems)
    Interfaces.RegisterInterface("Shop.CalculateSoftwarePrice", Shop.CalculateSoftwarePrice)
    Interfaces.RegisterInterface("Shop.CalculateSoftwareLevelsPrice", Shop.CalculateSoftwareLevelsPrice)
    EventScheduler.RegisterScheduledEventType("Shop.ItemDeliveryScheduledEvent", Shop.ItemDeliveryScheduledEvent)
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
    if settingName == nil or settingName == "prime_intergalactic_delivery-shop_software_max_level" then
        global.shop.softwareMaxLevel = tonumber(settings.global["prime_intergalactic_delivery-shop_software_max_level"].value)
        updateItems = true
    end
    if settingName == nil or settingName == "prime_intergalactic_delivery-delivery_min_delay" then
        global.shop.deliveryDelayMinTicks = tonumber(settings.global["prime_intergalactic_delivery-delivery_min_delay"].value) * 60
    end
    if settingName == nil or settingName == "prime_intergalactic_delivery-delivery_max_delay" then
        global.shop.deliveryDelayMaxTicks = tonumber(settings.global["prime_intergalactic_delivery-delivery_max_delay"].value) * 60
    end
    if updateItems then
        Shop.UpdateItems()
    end
end

Shop.UpdateItems = function()
    global.shop.items = {}

    for itemName, itemDetails in pairs(ShopRawItemsList) do
        if itemDetails.type == "personal" and global.shop.personalEquipmentCostMultiplier > 0 then
            itemDetails.price = itemDetails.price * global.shop.personalEquipmentCostMultiplier
            global.shop.items[itemName] = itemDetails
        elseif itemDetails.type == "infrastructure" and global.shop.infrastructureCostMultiplier > 0 then
            itemDetails.price = itemDetails.price * global.shop.infrastructureCostMultiplier
            global.shop.items[itemName] = itemDetails
        elseif itemDetails.type == "software" and global.shop.softwareStartCost > 0 then
            global.shop.items[itemName] = itemDetails
            if global.shop.softwareLevelsPurchased[itemName] == nil then
                global.shop.softwareLevelsPurchased[itemName] = 0
            end
        end
    end

    Interfaces.Call("ShopGui.RecreateGui")
end

Shop.CalculateSoftwarePrice = function(level)
    local currentMultiplier = global.shop.softwareLevelCostMultiplier ^ (level - 1)
    local price = global.shop.softwareStartCost * currentMultiplier
    return price
end

Shop.CalculateSoftwareLevelsPrice = function(softwareName, count)
    local quantityCost = 0
    for level = global.shop.softwareLevelsPurchased[softwareName] + 1, global.shop.softwareLevelsPurchased[softwareName] + count do
        local value = Interfaces.Call("Shop.CalculateSoftwarePrice", level)
        quantityCost = quantityCost + value
    end
    return quantityCost
end

Shop.BuyBasketItems = function()
    local totalCost = 0
    for itemName, quantity in pairs(global.shopGui.shoppingBasket) do
        local itemDetails = global.shop.items[itemName]
        local thisCost
        if itemDetails.type ~= "software" then
            thisCost = (quantity * itemDetails.price)
        else
            thisCost = Shop.CalculateSoftwareLevelsPrice(itemName, quantity)
        end
        totalCost = totalCost + thisCost
    end
    if global.facility.paymentChest.get_item_count("coin") >= totalCost then
        global.facility.paymentChest.remove_item({name = "coin", count = totalCost})
    else
        return false
    end

    for itemName, quantity in pairs(global.shopGui.shoppingBasket) do
        local itemDetails = global.shop.items[itemName]
        if itemDetails.type == "software" then
            global.shop.softwareLevelsPurchased[itemName] = global.shop.softwareLevelsPurchased[itemName] + quantity
        end
    end

    local itemsPurchased = Utils.DeepCopy(global.shopGui.shoppingBasket)
    local deliverTick = game.tick + math.random(global.shop.deliveryDelayMinTicks, global.shop.deliveryDelayMaxTicks)
    EventScheduler.ScheduleEvent(deliverTick, "Shop.ItemDeliveryScheduledEvent", global.shopGui.currentPurchaseId, itemsPurchased)

    return true
end

Shop.ItemDeliveryScheduledEvent = function(eventData)
    game.print({"messages.prime_intergalactic_delivery-order_delivered", eventData.instanceId})
    local entityItemsPurchased = {}
    for itemName, quantity in pairs(eventData.data) do
        local itemDetails = global.shop.items[itemName]
        if itemDetails ~= nil then
            entityItemsPurchased[itemDetails.item] = quantity
        end
    end

    if global.itemDeliveryPod.modActive then
        Interfaces.Call("ItemDeliveryPod.SendItems", entityItemsPurchased)
    else
        for entityItemName, quantity in pairs(entityItemsPurchased) do
            local inserted = global.facility.deliveryChest.insert({name = entityItemName, count = quantity})
            local couldntBeInserted = quantity - inserted
            if couldntBeInserted > 0 then
                global.facility.surface.spill_item_stack(global.facility.deliveryChest.position, {name = entityItemName, count = couldntBeInserted})
            end
        end
    end
end

return Shop
