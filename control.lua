local Facility = require("scripts/facility")
local Events = require("utility/events")
local GuiActionsClick = require("utility/gui-actions-click")
local GuiActionsOpened = require("utility/gui-actions-opened")
local EventScheduler = require("utility/event-scheduler")
local ShopGui = require("scripts/shop-gui")
local Shop = require("scripts/shop")
local ItemDeliveryPod = require("scripts/item-delivery-pod")

local function CreateGlobals()
    global.surface = global.surface or game.surfaces[1]
    global.force = global.force or game.forces["player"]
    ItemDeliveryPod.CreateGlobals()
    Facility.CreateGlobals()
    Shop.CreateGlobals()
    ShopGui.CreateGlobals()
end

local function OnLoad()
    --Any Remote Interface registration calls can go in here or in root of control.lua
    ItemDeliveryPod.OnLoad()
    Facility.OnLoad()
    Shop.OnLoad()
    ShopGui.OnLoad()
end

local function OnStartup()
    CreateGlobals()
    OnLoad()
    Events._HandleEvent({name = defines.events.on_runtime_mod_setting_changed})

    ItemDeliveryPod.OnStartup()
    Facility.OnStartup()
    Shop.OnStartup()
end

script.on_init(OnStartup)
script.on_configuration_changed(OnStartup)
Events.RegisterEvent(defines.events.on_runtime_mod_setting_changed)
script.on_load(OnLoad)
Events.RegisterEvent(defines.events.on_player_left_game)
Events.RegisterEvent(defines.events.on_player_died)
Events.RegisterEvent(defines.events.on_player_used_capsule)

GuiActionsClick.MonitorGuiClickActions()
EventScheduler.RegisterScheduler()
GuiActionsOpened.MonitorGuiOpenedActions()
