local Facility = require("scripts/facility")
local Events = require("utility/events")
local GuiActionsClick = require("utility/gui-actions-click")
local GuiActionsOpened = require("utility/gui-actions-opened")
local EventScheduler = require("utility/event-scheduler")
local ShopGui = require("scripts/shop-gui")
local Shop = require("scripts/shop")

local function CreateGlobals()
    global.itemDeliveryPodModActive = global.itemDeliveryPodModActive or false
    Facility.CreateGlobals()
    Shop.CreateGlobals()
    ShopGui.CreateGlobals()
end

local function OnLoad()
    --Any Remote Interface registration calls can go in here or in root of control.lua
    Facility.OnLoad()
    Shop.OnLoad()
    ShopGui.OnLoad()
end

local function OnStartup()
    CreateGlobals()
    OnLoad()
    Events.RaiseEvent({name = defines.events.on_runtime_mod_setting_changed})

    if game.active_mods["item_delivery_pod"] ~= nil then
        global.itemDeliveryPodModActive = true
    else
        global.itemDeliveryPodModActive = false
    end
    Facility.OnStartup()
    Shop.OnStartup()
end

script.on_init(OnStartup)
script.on_configuration_changed(OnStartup)
Events.RegisterEvent(defines.events.on_runtime_mod_setting_changed)
script.on_load(OnLoad)
Events.RegisterEvent(defines.events.on_player_left_game)

GuiActionsClick.MonitorGuiClickActions()
EventScheduler.RegisterScheduler()
GuiActionsOpened.MonitorGuiOpenedActions()
