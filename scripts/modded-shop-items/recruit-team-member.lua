local RecruitTeamMember = {}
local Events = require("utility/events")
local Interfaces = require("utility/interfaces")
--local Logging = require("utility/logging")

RecruitTeamMember.CreateGlobals = function()
    global.recruitTeamMember = global.recruitTeamMember or {}
    global.recruitTeamMember.shopStartCost = global.recruitTeamMember.shopStartCost or 0
    global.recruitTeamMember.shopLevelCostMultiplier = global.recruitTeamMember.shopLevelCostMultiplier or 1
end

RecruitTeamMember.OnLoad = function()
    Events.RegisterHandler("Shop.UpdatingItems", "RecruitTeamMember.OnUpdatedItems", RecruitTeamMember.OnUpdatedItems)
    Events.RegisterHandler(defines.events.on_runtime_mod_setting_changed, "RecruitTeamMember.OnSettingChanged", RecruitTeamMember.OnSettingChanged)
    Interfaces.RegisterInterface("RecruitTeamMember.CalculateSoftwarePrice", RecruitTeamMember.CalculateSoftwarePrice)
end

--Some of these settings won't exist due to settings requiring another mod to be present.
RecruitTeamMember.OnSettingChanged = function(event)
    if game.active_mods["muppet_streamer"] == nil then
        return
    end

    local settingName = event.setting
    local updateItems = false

    if settingName == nil or settingName == "prime_intergalactic_delivery-muppet_streamer_recruit_team_member_software_start_cost" then
        global.recruitTeamMember.shopStartCost = tonumber(settings.global["prime_intergalactic_delivery-muppet_streamer_recruit_team_member_software_start_cost"].value)
        updateItems = true
    end

    if settingName == nil or settingName == "prime_intergalactic_delivery-muppet_streamer_recruit_team_member_software_cost_level_multiplier" then
        global.recruitTeamMember.shopLevelCostMultiplier = tonumber(settings.global["prime_intergalactic_delivery-muppet_streamer_recruit_team_member_software_cost_level_multiplier"].value)
        updateItems = true
    end

    if updateItems then
        Interfaces.Call("Shop.UpdateItems")
    end
end

RecruitTeamMember.OnUpdatedItems = function()
    if game.active_mods["muppet_streamer"] == nil then
        return
    end

    if global.recruitTeamMember.shopStartCost > 0 then
        local recruitTeamMemberItem = game.item_prototypes["prime_intergalactic_delivery-recruit_team_member"]
        local itemName, itemDetails =
            "recruitTeamMember",
            {
                type = "software",
                shopDisplayName = recruitTeamMemberItem.localised_name,
                shopDisplayDescription = recruitTeamMemberItem.localised_description,
                picture = "technology/muppet_streamer-recruit_team_member-1",
                item = "prime_intergalactic_delivery-recruit_team_member",
                printName = recruitTeamMemberItem.localised_name,
                quantity = 1,
                priceCalculationInterfaceName = "RecruitTeamMember.CalculateSoftwarePrice",
                bonusEffectType = "mod",
                bonusEffect = function(removing)
                    local change = global.shop.softwareLevelsApplied["recruitTeamMember"]
                    if removing then
                        change = 0 - change
                    end
                    remote.call("muppet_streamer", "increase_team_member_level", change)
                end
            }
        global.shop.items[itemName] = itemDetails
        Interfaces.Call("Shop.RecordSoftwareStartingLevels", itemName, itemDetails)
    end
end

RecruitTeamMember.CalculateSoftwarePrice = function(level)
    local currentMultiplier = global.recruitTeamMember.shopLevelCostMultiplier ^ (level - 1)
    local price = math.floor(global.recruitTeamMember.shopStartCost * currentMultiplier)
    return price
end

return RecruitTeamMember
