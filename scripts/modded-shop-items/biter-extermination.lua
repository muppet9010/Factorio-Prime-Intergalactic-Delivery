local BiterExtermination = {}
local Events = require("utility/events")
local Interfaces = require("utility/interfaces")
--local Logging = require("utility/logging")

BiterExtermination.CreateGlobals = function()
    global.biterExtermination = global.biterExtermination or {}
    global.biterExtermination.capsuleCost = global.biterExtermination.capsuleCost or 0
end

BiterExtermination.OnLoad = function()
    Events.RegisterHandler("Shop.UpdatingItems", "RecruitTeaBiterExterminationmMember.OnUpdatedItems", BiterExtermination.OnUpdatedItems)
    Events.RegisterHandler(defines.events.on_runtime_mod_setting_changed, "BiterExtermination.OnSettingChanged", BiterExtermination.OnSettingChanged)
end

--Some of these settings won't exist due to settings requiring another mod to be present.
BiterExtermination.OnSettingChanged = function(event)
    if game.active_mods["biter_extermination"] == nil then
        return
    end

    local settingName = event.setting
    local updateItems = false

    if settingName == nil or settingName == "prime_intergalactic_delivery-biter_extermination_item_cost" then
        global.biterExtermination.capsuleCost = tonumber(settings.global["prime_intergalactic_delivery-biter_extermination_item_cost"].value)
        updateItems = true
    end

    if updateItems then
        Interfaces.Call("Shop.UpdateItems")
    end
end

BiterExtermination.OnUpdatedItems = function()
    if game.active_mods["biter_extermination"] == nil then
        return
    end

    if global.biterExtermination.capsuleCost > 0 then
        local itemName, itemDetails =
            "exterminateBiters",
            {
                type = "simple",
                shopDisplayName = {"item-name.biter_extermination-exterminate_biters"},
                shopDisplayDescription = {"technology-description.biter_extermination-exterminate_biters"},
                picture = "technology/biter_extermination-exterminate_biters",
                price = global.biterExtermination.capsuleCost,
                item = "biter_extermination-exterminate_biters",
                quantity = 1
            }
        global.shop.items[itemName] = itemDetails
    end
end

return BiterExtermination
