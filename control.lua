local Facility = require("scripts/facility")
local Events = require("utility/events")
local GuiActionsClick = require("utility/gui-actions-click")
local GuiActionsOpened = require("utility/gui-actions-opened")
local EventScheduler = require("utility/event-scheduler")
local ShopGui = require("scripts/shop-gui")

local function CreateGlobals()
    global.itemDeliveryPodModActive = global.itemDeliveryPodModActive or false
    Facility.CreateGlobals()
end

local function OnLoad()
    --Any Remote Interface registration calls can go in here or in root of control.lua
    Facility.OnLoad()
    ShopGui.OnLoad()
end

local function OnSettingChanged(event)
    --if event == nil or event.setting == "xxxxx" then
    --	local x = tonumber(settings.global["xxxxx"].value)
    --end
end

local function OnStartup()
    CreateGlobals()
    OnLoad()
    OnSettingChanged(nil)

    if game.active_mods["item_delivery_pod"] ~= nil then
        global.itemDeliveryPodModActive = true
    else
        global.itemDeliveryPodModActive = false
    end
    Facility.OnStartup()
end

script.on_init(OnStartup)
script.on_configuration_changed(OnStartup)
script.on_event(defines.events.on_runtime_mod_setting_changed, OnSettingChanged)
script.on_load(OnLoad)

GuiActionsClick.MonitorGuiClickActions()
EventScheduler.RegisterScheduler()
GuiActionsOpened.MonitorGuiOpenedActions()
