local Facility = {}
local Utils = require("utility/utils")
local Logging = require("utility/logging")
local Interfaces = require("utility/interfaces")

Facility.CreateGlobals = function()
    global.facility = global.facility or {}
    global.facility.shop = global.facility.shop or nil
    global.facility.paymentChest = global.facility.paymentChest or nil
    global.facility.deliveryChest = global.facility.deliveryChest or nil
    global.facility.shopVisuals = global.facility.shopVisuals or {}
    global.facility.createdHazardConcreteRadius = global.facility.createdHazardConcreteRadius or 0
end

Facility.OnLoad = function()
    remote.add_interface("prime_intergalactic_delivery", {get_payment_chest = Facility.RemoteReturnPaymentChest})
end

Facility.OnStartup = function()
    if global.facility.shop == nil then
        if not Facility.CreateShopEntity() then
            return
        end
        Facility.CreatePaymentChestEntity()
    end
    if global.itemDeliveryPod.modActive then
        if global.facility.deliveryChest ~= nil then
            local inventory = global.facility.deliveryChest.get_inventory(defines.inventory.chest)
            for itemName, count in pairs(inventory.get_contents()) do
                global.surface.spill_item_stack(global.facility.deliveryChest.position, {name = itemName, count = count})
            end
            global.facility.deliveryChest.destroy()
            global.facility.deliveryChest = nil
        end
        if global.facility.createdHazardConcreteRadius ~= global.itemDeliveryPod.deliveryAccuracy and global.itemDeliveryPod.hazardDropArea then
            global.facility.createdHazardConcreteRadius = global.itemDeliveryPod.deliveryAccuracy
            local tilesInRadius = global.surface.find_tiles_filtered {position = global.facility.shop.position, radius = global.itemDeliveryPod.deliveryAccuracy, collision_mask = "ground-tile", has_hidden_tile = false}
            local tilesToHazard = {}
            for _, tile in pairs(tilesInRadius) do
                table.insert(tilesToHazard, {name = "hazard-concrete-right", position = tile.position})
            end
            global.surface.set_tiles(tilesToHazard)
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
    local pos = global.surface.find_non_colliding_position("prime_intergalactic_delivery-shop_building", nearSpawnRandomSpot, 100, 1, true)
    if pos == nil then
        Logging.Log("ERROR: No valid position for Shop at spawn found - just stuck it down regardless")
        pos = nearSpawnRandomSpot
    end
    local shopBuildingEntity = global.surface.create_entity {name = "prime_intergalactic_delivery-shop_building", position = pos, force = global.force, raise_built = true}
    if shopBuildingEntity == nil then
        Logging.Log("ERROR: Shop at spawn failed to create at valid position")
        return false
    end
    global.facility.shop = shopBuildingEntity
    shopBuildingEntity.destructible = false
    Interfaces.Call("ShopGui.RegisterMarketForOpened", global.facility.shop)

    global.facility.shopVisuals.shopBuildingRadarEntity = global.surface.create_entity {name = "prime_intergalactic_delivery-shop_building_radar", position = shopBuildingEntity.position, force = global.force, raise_built = true}
    global.facility.shopVisuals.shopBuildingRadarEntity.destructible = false

    global.facility.shopVisuals.shopBuildingSpeaker1Entity = global.surface.create_entity {name = "prime_intergalactic_delivery-shop_building_speaker", position = Utils.ApplyOffsetToPosition(shopBuildingEntity.position, {x = 1.2, y = 1.5}), force = global.force, raise_built = true}
    global.facility.shopVisuals.shopBuildingSpeaker1Entity.destructible = false

    global.facility.shopVisuals.shopBuildingSpeaker2Entity = global.surface.create_entity {name = "prime_intergalactic_delivery-shop_building_speaker", position = Utils.ApplyOffsetToPosition(shopBuildingEntity.position, {x = -1.2, y = 1.5}), force = global.force, raise_built = true}
    global.facility.shopVisuals.shopBuildingSpeaker2Entity.destructible = false

    return true
end

Facility.CreatePaymentChestEntity = function()
    local pos = Utils.ApplyOffsetToPosition(global.facility.shop.position, {x = 1, y = 2})
    local entity = global.surface.create_entity {name = "prime_intergalactic_delivery-shop_payment_chest", position = pos, force = global.force, raise_built = true}
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
    local entity = global.surface.create_entity {name = "prime_intergalactic_delivery-shop_delivery_chest", position = pos, force = global.force, raise_built = true}
    if entity == nil then
        Logging.Log("ERROR: Shop Provider Chest at spawn failed to create at valid position")
        return false
    end
    entity.destructible = false
    global.facility.deliveryChest = entity
    return true
end

Facility.RemoteReturnPaymentChest = function()
    return global.facility.paymentChest
end

return Facility
