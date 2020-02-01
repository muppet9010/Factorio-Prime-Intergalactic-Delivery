local Facility = {}
local Utils = require("utility/utils")
local Logging = require("utility/logging")

Facility.CreateGlobals = function()
    global.facility = global.facility or {}
    global.facility.shop = global.facility.shop or nil
    global.facility.paymentChest = global.facility.paymentChest or nil
    global.facility.deliveryChest = global.facility.deliveryChest or nil
    global.facility.surface = global.facility.surface or nil
end

Facility.OnLoad = function()
end

Facility.OnStartup = function()
    global.facility.surface = game.surfaces[1]
    if global.facility.shop == nil then
        if not Facility.CreateShopEntity() then
            return
        end
        Facility.CreatePaymentChestEntity()
    end
    if global.itemDeliveryPodModActive then
        if global.facility.deliveryChest ~= nil then
            global.facility.deliveryChest.destory()
            global.facility.deliveryChest = nil
        end
    else
        if global.facility.deliveryChest == nil then
            Facility.CreateDeliveryChestEntity()
        end
    end
end

Facility.CreateShopEntity = function()
    local nearSpawnRandomSpot = {
        x = math.random(-20, 20),
        y = math.random(-20, 20)
    }
    local pos = Utils.GetValidPositionForEntityNearPosition("prime_intergalactic_delivery-shop_building", global.facility.surface, nearSpawnRandomSpot, 20, 5)
    if pos == nil then
        Logging.Log("ERROR: No valid position for Shop at spawn found")
        return false
    end
    local shopBuildingEntity = global.facility.surface.create_entity {name = "prime_intergalactic_delivery-shop_building", position = pos, force = "player", raise_built = true}
    if shopBuildingEntity == nil then
        Logging.Log("ERROR: Shop at spawn failed to create at valid position")
        return false
    end
    local shopBuildingRadarEntity = global.facility.surface.create_entity {name = "prime_intergalactic_delivery-shop_building_radar", position = {pos.x - 0.1, pos.y - 1}, force = "player", raise_built = true}
    shopBuildingEntity.destructible = false
    shopBuildingRadarEntity.destructible = false
    global.facility.shop = shopBuildingEntity
    return true
end

Facility.CreatePaymentChestEntity = function()
    local pos = Utils.ApplyOffsetToPosition(global.facility.shop.position, {x = 1, y = 2})
    local entity = global.facility.surface.create_entity {name = "prime_intergalactic_delivery-shop_payment_chest", position = pos, force = "player", raise_built = true}
    if entity == nil then
        Logging.Log("ERROR: Shop Requester Chest at spawn failed to create at valid position")
        return false
    end
    entity.destructible = false
    global.facility.paymentChest = entity
    return true
end

Facility.CreateDeliveryChestEntity = function()
    local pos = Utils.ApplyOffsetToPosition(global.facility.shop.position, {x = -1, y = 2})
    local entity = global.facility.surface.create_entity {name = "prime_intergalactic_delivery-shop_delivery_chest", position = pos, force = "player", raise_built = true}
    if entity == nil then
        Logging.Log("ERROR: Shop Provider Chest at spawn failed to create at valid position")
        return false
    end
    entity.destructible = false
    global.facility.deliveryChest = entity
    return true
end

return Facility
