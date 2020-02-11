local ItemDeliveryPod = {}
local Events = require("utility/events")
--local Logging = require("utility/logging")
local Interfaces = require("utility/interfaces")

ItemDeliveryPod.CreateGlobals = function()
    global.itemDeliveryPod = global.itemDeliveryPod or {}
    global.itemDeliveryPod.modActive = global.itemDeliveryPod.modActive or false
    global.itemDeliveryPod.deliveryAccuracy = global.itemDeliveryPod.deliveryAccuracy or 0
    global.itemDeliveryPod.hazardDropArea = global.itemDeliveryPod.hazardDropArea or false
end

ItemDeliveryPod.OnLoad = function()
    Events.RegisterHandler(defines.events.on_runtime_mod_setting_changed, "ItemDeliveryPod.OnSettingChanged", ItemDeliveryPod.OnSettingChanged)
    Interfaces.RegisterInterface("ItemDeliveryPod.SendItems", ItemDeliveryPod.SendItems)
end

ItemDeliveryPod.OnStartup = function()
    if game.active_mods["item_delivery_pod"] ~= nil and settings.startup["prime_intergalactic_delivery-use_delivery_pod"].value then
        global.itemDeliveryPod.modActive = true
    else
        global.itemDeliveryPod.modActive = false
    end
    if game.active_mods["item_delivery_pod"] ~= nil and settings.startup["prime_intergalactic_delivery-hazard_concrete_delivery_pod_area"].value then
        global.itemDeliveryPod.hazardDropArea = true
    else
        global.itemDeliveryPod.hazardDropArea = false
    end
end

--Some of these settings won't exist
ItemDeliveryPod.OnSettingChanged = function(event)
    local settingName = event.setting
    if (settingName == nil or settingName == "prime_intergalactic_delivery-delivery_pod_accuracy") and settings.global["prime_intergalactic_delivery-delivery_pod_accuracy"] ~= nil then
        global.itemDeliveryPod.deliveryAccuracy = tonumber(settings.global["prime_intergalactic_delivery-delivery_pod_accuracy"].value)
    end
end

ItemDeliveryPod.SendItems = function(items)
    for i = 1, 10 do
        remote.call("item_delivery_pod", "call_crash_ship", global.facility.shop.position, {3, global.itemDeliveryPod.deliveryAccuracy}, "tiny", items)
    end
end

return ItemDeliveryPod
