local Facility = require("scripts/facility")
local Events = require("utility/events")
local GuiActionsClick = require("utility/gui-actions-click")
local GuiActionsOpened = require("utility/gui-actions-opened")
local GuiActionsClosed = require("utility/gui-actions-closed")
local EventScheduler = require("utility/event-scheduler")
local ShopGui = require("scripts/shop-gui")
local Shop = require("scripts/shop")
local ItemDeliveryPod = require("scripts/item-delivery-pod")
local RecruitTeamMember = require("scripts/modded-shop-items/recruit-team-member")
local BiterExtermination = require("scripts/modded-shop-items/biter-extermination")

local function CreateGlobals()
    global.surface = global.surface or game.surfaces[1]
    global.force = global.force or game.forces["player"]
    ItemDeliveryPod.CreateGlobals()
    Facility.CreateGlobals()
    Shop.CreateGlobals()
    ShopGui.CreateGlobals()
    RecruitTeamMember.CreateGlobals()
    BiterExtermination.CreateGlobals()
end

local function OnLoad()
    --Any Remote Interface registration calls can go in here or in root of control.lua
    remote.remove_interface("prime_intergalactic_delivery")

    ItemDeliveryPod.OnLoad()
    Facility.OnLoad()
    Shop.OnLoad()
    ShopGui.OnLoad()
    RecruitTeamMember.OnLoad()
    BiterExtermination.OnLoad()
end

local function OnStartup()
    CreateGlobals()
    OnLoad()
    Events.RaiseInternalEvent({name = defines.events.on_runtime_mod_setting_changed})

    ItemDeliveryPod.OnStartup()
    Facility.OnStartup()
    Shop.OnStartup()
    ShopGui.OnStartup()
end

script.on_init(OnStartup)
script.on_configuration_changed(OnStartup)
Events.RegisterEvent(defines.events.on_runtime_mod_setting_changed)
script.on_load(OnLoad)
Events.RegisterEvent(defines.events.on_player_left_game)
Events.RegisterEvent(defines.events.on_player_died)
Events.RegisterEvent(defines.events.on_player_used_capsule)
Events.RegisterEvent(defines.events.on_player_respawned)
Events.RegisterEvent(defines.events.on_player_created)
Events.RegisterEvent("Shop.UpdatingItems")

GuiActionsClick.MonitorGuiClickActions()
EventScheduler.RegisterScheduler()
GuiActionsOpened.MonitorGuiOpenedActions()
GuiActionsClosed.MonitorGuiClosedActions()
