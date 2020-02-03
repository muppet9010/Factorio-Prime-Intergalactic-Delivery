local Gui = {}
local GuiUtil = require("utility/gui-util")
local GuiActionsClick = require("utility/gui-actions-click")
local GuiActionsOpened = require("utility/gui-actions-opened")
local Interfaces = require("utility/interfaces")

Gui.OnLoad = function()
    Interfaces.RegisterInterface("Gui.RegisterMarketForOpened", Gui.RegisterMarketForOpened)
    GuiActionsOpened.LinkGuiOpenedActionNameToFunction("Gui.MarketOpened", Gui.MarketOpened)
end

Gui.RegisterMarketForOpened = function(marketEntity)
    GuiActionsOpened.RegisterEntityForGuiOpenedAction(marketEntity, "Gui.MarketOpened")
end

Gui.MarketOpened = function(actionData)
    local player = game.get_player(actionData.playerIndex)
    player.opened = nil --close the market GUI
    game.print("a market clicked")
end

return Gui
