local Shop = {}
local Events = require("utility/events")
local Interfaces = require("utility/interfaces")
local Logging = require("utility/logging")
local ShopRawItemsList = require("scripts/shop-raw-items")
local EventScheduler = require("utility/event-scheduler")
local Utils = require("utility/utils")
local Commands = require("utility/commands")

Shop.CreateGlobals = function()
    global.shop = global.shop or {}
    global.shop.items = global.shop.items or {}
    global.shop.personalEquipmentCostMultiplier = global.shop.personalEquipmentCostMultiplier or 0
    global.shop.infrastructureCostMultiplier = global.shop.infrastructureCostMultiplier or 0
    global.shop.weaponCostMultiplier = global.shop.weaponCostMultiplier or 0
    global.shop.softwareStartCost = global.shop.softwareStartCost or 0
    global.shop.softwareLevelCostMultiplier = global.shop.softwareLevelCostMultiplier or 1
    global.shop.softwareLevelEffectBonus = global.shop.softwareLevelEffectBonus or 1
    global.shop.softwareMaxLevel = global.shop.softwareMaxLevel or 0
    global.shop.softwareLevelsPurchased = global.shop.softwareLevelsPurchased or {}
    global.shop.deliveryDelayMinTicks = global.shop.deliveryDelayMinTicks or 0
    global.shop.deliveryDelayMaxTicks = global.shop.deliveryDelayMaxTicks or 0
    global.shop.softwareLevelsApplied = global.shop.softwareLevelsApplied or {}
    global.shop.softwareItemCapsuleLookup = global.shop.softwareItemCapsuleLookup or {}
    global.shop.ordersMade = global.shop.ordersMade or {}
end

Shop.OnLoad = function()
    Events.RegisterHandler(defines.events.on_runtime_mod_setting_changed, "Shop.OnSettingChanged", Shop.OnSettingChanged)
    Interfaces.RegisterInterface("Shop.BuyItems", Shop.BuyItems)
    Interfaces.RegisterInterface("Shop.CalculateSoftwarePrice", Shop.CalculateSoftwarePrice)
    Interfaces.RegisterInterface("Shop.CalculateSoftwareLevelsPrice", Shop.CalculateSoftwareLevelsPrice)
    EventScheduler.RegisterScheduledEventType("Shop.ItemDeliveryScheduledEvent", Shop.ItemDeliveryScheduledEvent)
    Events.RegisterEvent(defines.events.on_player_used_capsule)
    Events.RegisterHandler(defines.events.on_player_used_capsule, "Shop.OnPlayerUsedCapsule", Shop.OnPlayerUsedCapsule)
    Interfaces.RegisterInterface("Shop.RecordSoftwareStartingLevels", Shop.RecordSoftwareStartingLevels)
    Interfaces.RegisterInterface("Shop.UpdateItems", Shop.UpdateItems)
    Commands.Register("prime_intergalactic_delivery_export_orders", {"api-description.prime_intergalactic_delivery_export_orders"}, Shop.ExportOrders, false)
    Events.RegisterEvent("Shop.UpdatingItems")
end

Shop.OnStartup = function()
    Shop.UpdateItems()
end

Shop.OnSettingChanged = function(eventData)
    local settingName = eventData.setting
    local updateItems, recreateGui = false, false
    if settingName == nil or settingName == "prime_intergalactic_delivery-shop_personal_equipment_cost_multiplier" then
        global.shop.personalEquipmentCostMultiplier = tonumber(settings.global["prime_intergalactic_delivery-shop_personal_equipment_cost_multiplier"].value)
        updateItems = true
    end
    if settingName == nil or settingName == "prime_intergalactic_delivery-shop_infrastructure_cost_multiplier" then
        global.shop.infrastructureCostMultiplier = tonumber(settings.global["prime_intergalactic_delivery-shop_infrastructure_cost_multiplier"].value)
        updateItems = true
    end
    if settingName == nil or settingName == "prime_intergalactic_delivery-shop_weapon_cost_multiplier" then
        global.shop.weaponCostMultiplier = tonumber(settings.global["prime_intergalactic_delivery-shop_weapon_cost_multiplier"].value)
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
        Shop.UpdateItems() -- have to call it to force shop bonus functions to update prior to applying.
        Shop.ApplyCoreBonusEffects(true)
        global.shop.softwareLevelEffectBonus = tonumber(settings.global["prime_intergalactic_delivery-shop_software_effect_level_bonus_percent"].value)
        Shop.ApplyCoreBonusEffects(false)
        updateItems = true
    end
    if settingName == nil or settingName == "prime_intergalactic_delivery-shop_software_max_level" then
        global.shop.softwareMaxLevel = tonumber(settings.global["prime_intergalactic_delivery-shop_software_max_level"].value)
        updateItems = true
    end
    if settingName == nil or settingName == "prime_intergalactic_delivery-delivery_min_delay" then
        global.shop.deliveryDelayMinTicks = tonumber(settings.global["prime_intergalactic_delivery-delivery_min_delay"].value) * 60
        recreateGui = true
    end
    if settingName == nil or settingName == "prime_intergalactic_delivery-delivery_max_delay" then
        global.shop.deliveryDelayMaxTicks = tonumber(settings.global["prime_intergalactic_delivery-delivery_max_delay"].value) * 60
        recreateGui = true
    end

    if updateItems then
        Shop.UpdateItems()
    elseif recreateGui then
        Interfaces.Call("ShopGui.RecreateGui")
    end
end

Shop.UpdateItems = function()
    global.shop.items = {}

    for itemName, itemDetails in pairs(Utils.DeepCopy(ShopRawItemsList)) do
        if itemDetails.type == "personal" and global.shop.personalEquipmentCostMultiplier > 0 then
            itemDetails.price = math.floor(itemDetails.price * global.shop.personalEquipmentCostMultiplier)
            global.shop.items[itemName] = itemDetails
        elseif itemDetails.type == "infrastructure" and global.shop.infrastructureCostMultiplier > 0 then
            itemDetails.price = math.floor(itemDetails.price * global.shop.infrastructureCostMultiplier)
            global.shop.items[itemName] = itemDetails
        elseif itemDetails.type == "weapon" and global.shop.weaponCostMultiplier > 0 then
            itemDetails.price = math.floor(itemDetails.price * global.shop.weaponCostMultiplier)
            global.shop.items[itemName] = itemDetails
        elseif itemDetails.type == "software" and global.shop.softwareStartCost > 0 then
            global.shop.items[itemName] = itemDetails
            Shop.RecordSoftwareStartingLevels(itemName, itemDetails)
        elseif itemDetails.type == "simple" then
            global.shop.items[itemName] = itemDetails
        else
            Logging.LogPrint("unhandled shop item - type: '" .. itemDetails.type .. "' - name: '" .. itemName .. "'")
        end
    end
    Events.RaiseInternalEvent({name = "Shop.UpdatingItems"})

    Interfaces.Call("ShopGui.RecreateGui")
end

Shop.RecordSoftwareStartingLevels = function(itemName, itemDetails)
    global.shop.softwareLevelsPurchased[itemName] = global.shop.softwareLevelsPurchased[itemName] or 0
    global.shop.softwareLevelsApplied[itemName] = global.shop.softwareLevelsApplied[itemName] or 0
    global.shop.softwareItemCapsuleLookup[itemDetails.item] = itemName
end

Shop.CalculateSoftwarePrice = function(level)
    local currentMultiplier = global.shop.softwareLevelCostMultiplier ^ (level - 1)
    local price = math.floor(global.shop.softwareStartCost * currentMultiplier)
    return price
end

Shop.CalculateSoftwareLevelsPrice = function(softwareName, count)
    local quantityCost = 0
    local softwareDetails = global.shop.items[softwareName]
    for level = global.shop.softwareLevelsPurchased[softwareName] + 1, global.shop.softwareLevelsPurchased[softwareName] + count do
        local value = Interfaces.Call(softwareDetails.priceCalculationInterfaceName, level)
        quantityCost = quantityCost + value
    end
    return quantityCost
end

Shop.BuyItems = function(playerIndex, orderId, items)
    local totalCost = 0
    for itemName, quantity in pairs(items) do
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

    for itemName, quantity in pairs(items) do
        local itemDetails = global.shop.items[itemName]
        if itemDetails.type == "software" then
            global.shop.softwareLevelsPurchased[itemName] = global.shop.softwareLevelsPurchased[itemName] + quantity
        end
    end

    local itemsPurchased = Utils.DeepCopy(items)
    local deliverTick = game.tick + math.random(global.shop.deliveryDelayMinTicks, global.shop.deliveryDelayMaxTicks)
    EventScheduler.ScheduleEvent(deliverTick, "Shop.ItemDeliveryScheduledEvent", orderId, itemsPurchased)

    local player = game.get_player(playerIndex)
    table.insert(global.shop.ordersMade, {orderId = orderId, tick = game.tick, playerName = player.name, items = Utils.DeepCopy(items)})

    return true
end

Shop.ItemDeliveryScheduledEvent = function(eventData)
    game.print({"message.prime_intergalactic_delivery-order_delivered", eventData.instanceId})
    local entityItemsPurchased = {}
    for itemName, quantity in pairs(eventData.data) do
        local itemDetails = global.shop.items[itemName]
        if itemDetails ~= nil then
            entityItemsPurchased[itemDetails.item] = quantity * itemDetails.quantity
        end
    end

    if global.itemDeliveryPod.modActive then
        Interfaces.Call("ItemDeliveryPod.SendItems", entityItemsPurchased)
    else
        for entityItemName, quantity in pairs(entityItemsPurchased) do
            local inserted = global.facility.deliveryChest.insert({name = entityItemName, count = quantity})
            local couldntBeInserted = quantity - inserted
            if couldntBeInserted > 0 then
                global.surface.spill_item_stack(global.facility.deliveryChest.position, {name = entityItemName, count = couldntBeInserted})
            end
        end
    end
end

Shop.OnPlayerUsedCapsule = function(event)
    local capsuleName = event.item.name
    local softwareName = global.shop.softwareItemCapsuleLookup[capsuleName]
    if softwareName == nil then
        return
    end

    local itemDetails = global.shop.items[softwareName]
    Interfaces.Call(itemDetails.bonusEffectName, true)
    global.shop.softwareLevelsApplied[softwareName] = global.shop.softwareLevelsApplied[softwareName] + 1
    Interfaces.Call(itemDetails.bonusEffectName, false)

    local printName = global.shop.items[softwareName].printName
    game.print({"message.prime_intergalactic_delivery-software_applied", printName, global.shop.softwareLevelsApplied[softwareName]})
    for _, player in pairs(game.connected_players) do
        Shop.CreateSparksAroundPosition(Utils.ApplyOffsetToPosition(player.position, {x = 0.2, y = -1}))
    end
end

Shop.ApplyCoreBonusEffects = function(removing)
    for _, itemDetails in pairs(global.shop.items) do
        if itemDetails.type == "software" and itemDetails.bonusEffectType == "core" then
            Interfaces.Call(itemDetails.bonusEffectName, removing)
        end
    end
end

Shop.CreateSparksAroundPosition = function(basePosition)
    for i = 1, 50 do
        local sparkNum = math.random(1, 6)
        local position = Utils.RandomLocationInRadius(basePosition, 1)
        global.surface.create_trivial_smoke {name = "prime_intergalactic_delivery-software_applied_sparks_" .. sparkNum, position = position}
    end
end

Shop.ExportOrders = function(commandData)
    game.write_file("Prime_Intergalactic_Delivery_Orders.txt", Utils.TableContentsToJSON(global.shop.ordersMade), false, commandData.player_index)
end

return Shop
