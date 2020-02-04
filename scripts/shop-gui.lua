local ShopGui = {}
local GuiUtil = require("utility/gui-util")
local GuiActionsClick = require("utility/gui-actions-click")
local GuiActionsOpened = require("utility/gui-actions-opened")
local Interfaces = require("utility/interfaces")

ShopGui.OnLoad = function()
    Interfaces.RegisterInterface("ShopGui.RegisterMarketForOpened", ShopGui.RegisterMarketForOpened)
    GuiActionsOpened.LinkGuiOpenedActionNameToFunction("ShopGui.MarketOpened", ShopGui.MarketOpened)
    GuiActionsClick.LinkGuiClickActionNameToFunction("ShopGui.CloseGuiClickAction", ShopGui.CloseGuiClickAction)
end

ShopGui.RegisterMarketForOpened = function(marketEntity)
    GuiActionsOpened.RegisterEntityForGuiOpenedAction(marketEntity, "ShopGui.MarketOpened")
end

ShopGui.MarketOpened = function(actionData)
    local player = game.get_player(actionData.playerIndex)
    player.opened = nil --close the market GUI
    ShopGui.CloseGui(player.index)
    ShopGui.CreateGui(player)

    --TODO : test data
    ShopGui.PopulateTestData(player.index)
end

ShopGui.CloseGuiClickAction = function(actionData)
    ShopGui.CloseGui(actionData.playerIndex)
end

ShopGui.CloseGui = function(playerIndex)
    GuiUtil.DestroyElementInPlayersReferenceStorage(playerIndex, "ShopGui", "shopMain", "frame")
end

ShopGui.CreateGui = function(player)
    local shopMainFrame = GuiUtil.AddElement({parent = player.gui.center, name = "shopMain", type = "frame", direction = "vertical", style = "muppet_padded_frame_main"}, "ShopGui")
    shopMainFrame.style.right_padding = 4
    shopMainFrame.style.bottom_padding = 4

    ShopGui.CreateMainHeaderBar(shopMainFrame)

    local shopMainContentFlow = GuiUtil.AddElement({parent = shopMainFrame, type = "flow", direction = "horizontal", style = "muppet_horizontal_flow"})
    local shopMainLeftColumnFlow = GuiUtil.AddElement({parent = shopMainContentFlow, type = "flow", direction = "vertical", style = "muppet_vertical_flow"})

    ShopGui.CreateItemList(shopMainLeftColumnFlow)
    ShopGui.CreateItemDetails(shopMainLeftColumnFlow)
    ShopGui.CreateShoppingBasket(shopMainContentFlow)
end

ShopGui.CreateMainHeaderBar = function(shopMainFrame)
    local shopMainHeaderBarFlow = GuiUtil.AddElement({parent = shopMainFrame, type = "flow", direction = "horizontal", style = "muppet_horizontal_flow"})
    shopMainHeaderBarFlow.style.horizontal_align = "left"

    GuiUtil.AddElement({parent = shopMainHeaderBarFlow, name = "shopMainHeaderBar", type = "label", style = "muppet_large_bold_heading", caption = "self"})

    local shopMainHeaderBarCloseFlow = GuiUtil.AddElement({parent = shopMainHeaderBarFlow, type = "flow", direction = "horizontal", style = "muppet_horizontal_flow"})
    shopMainHeaderBarCloseFlow.style.horizontal_align = "right"
    shopMainHeaderBarCloseFlow.style.horizontally_stretchable = true
    shopMainHeaderBarCloseFlow.style.padding = 4
    GuiUtil.AddElement({parent = shopMainHeaderBarCloseFlow, name = "shopMainHeaderBarClose", type = "sprite-button", sprite = "utility/close_white", tooltip = "self", style = "close_button"})
    GuiActionsClick.RegisterGuiForClick("shopMainHeaderBarClose", "sprite-button", "ShopGui.CloseGuiClickAction")
end

ShopGui.CreateItemList = function(shopMainLeftColumnFlow)
    local shopItemListFrame = GuiUtil.AddElement({parent = shopMainLeftColumnFlow, type = "frame", direction = "vertical", style = "muppet_padded_frame_content"})
    shopItemListFrame.style.width = 500
    shopItemListFrame.style.height = 300

    local shopMainHeaderBarScroll = GuiUtil.AddElement({parent = shopItemListFrame, name = "shopMainHeaderBar", type = "scroll-pane", direction = "vertical", horizontal_scroll_policy = "never", vertical_scroll_policy = "auto"}, "ShopGui")
    shopMainHeaderBarScroll.style.horizontally_stretchable = true
    shopMainHeaderBarScroll.style.vertically_stretchable = true
end

ShopGui.CreateItemDetails = function(shopMainLeftColumnFlow)
    local frame = GuiUtil.AddElement({parent = shopMainLeftColumnFlow, type = "frame", direction = "vertical", style = "muppet_padded_frame_content"})
    frame.style.width = 500

    local header = GuiUtil.AddElement({parent = frame, type = "flow", direction = "vertical", style = "muppet_vertical_flow_spaced"})
    header.style.horizontal_align = "center"
    local title = GuiUtil.AddElement({parent = header, name = "itemDetailsTitle", type = "label", style = "muppet_medium_semibold_heading"}, "ShopGui")
    title.style.horizontally_stretchable = true

    local frameContent = GuiUtil.AddElement({parent = frame, type = "flow", direction = "horizontal", style = "muppet_horizontal_flow_spaced"})

    local leftColumn = GuiUtil.AddElement({parent = frameContent, type = "flow", direction = "vertical", style = "muppet_vertical_flow_spaced"})
    leftColumn.style.horizontal_align = "center"

    GuiUtil.AddElement({parent = leftColumn, name = "itemDetailsImage", type = "sprite", style = "prime_intergalactic_delivery_sprite_64"}, "ShopGui")

    GuiUtil.AddElement({parent = leftColumn, name = "itemDetailsPrice", type = "label", style = "muppet_small_semibold_text"}, "ShopGui")

    local leftColumn = GuiUtil.AddElement({parent = leftColumn, name = "itemDetailsAdd", type = "button", style = "muppet_small_button", caption = "Add to basket"})
    --TODO: add a button link for this add to basket button

    local contentLine = GuiUtil.AddElement({parent = frameContent, type = "line", direction = "vertical", style = "line"})
    contentLine.style.vertically_stretchable = true

    local rightColumn = GuiUtil.AddElement({parent = frameContent, type = "flow", direction = "vertical", style = "muppet_vertical_flow"})
    rightColumn.style.horizontally_stretchable = true

    GuiUtil.AddElement({parent = rightColumn, name = "shopItemsDetailsDescription", type = "label", style = "muppet_small_text"}, "ShopGui")
end

ShopGui.CreateShoppingBasket = function(shopMainContentFlow)
    local shopItemDetailsFrame = GuiUtil.AddElement({parent = shopMainContentFlow, type = "frame", direction = "vertical", style = "muppet_padded_frame_content"})
    shopItemDetailsFrame.style.width = 400
    shopItemDetailsFrame.style.vertically_stretchable = true
end

ShopGui.PopulateTestData = function(playerIndex)
    GuiUtil.UpdateElementFromPlayersReferenceStorage(playerIndex, "ShopGui", "itemDetailsTitle", "label", {caption = "Test Item Title"})
    GuiUtil.UpdateElementFromPlayersReferenceStorage(playerIndex, "ShopGui", "itemDetailsImage", "sprite", {sprite = "entity/roboport"})
    GuiUtil.UpdateElementFromPlayersReferenceStorage(playerIndex, "ShopGui", "shopItemsDetailsDescription", "label", {caption = "A  description of this thing with quite a few words as a bit of flavour text is always nice."})
    GuiUtil.UpdateElementFromPlayersReferenceStorage(playerIndex, "ShopGui", "itemDetailsPrice", "label", {caption = "5,000 " .. "[img=item/coin]"})
end

return ShopGui
