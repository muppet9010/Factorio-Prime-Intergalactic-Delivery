local ShopGui = {}
local GuiUtil = require("utility/gui-util")
local GuiActionsClick = require("utility/gui-actions-click")
local GuiActionsOpened = require("utility/gui-actions-opened")
local Interfaces = require("utility/interfaces")
--local Logging = require("utility/logging")

ShopGui.OnLoad = function()
    Interfaces.RegisterInterface("ShopGui.RegisterMarketForOpened", ShopGui.RegisterMarketForOpened)
    GuiActionsOpened.LinkGuiOpenedActionNameToFunction("ShopGui.MarketOpened", ShopGui.MarketOpened)
    GuiActionsClick.LinkGuiClickActionNameToFunction("ShopGui.CloseGuiClickAction", ShopGui.CloseGuiClickAction)
    GuiActionsClick.LinkGuiClickActionNameToFunction("ShopGui.AddToShoppingBasketAction", ShopGui.AddToShoppingBasketAction)
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
    local elements =
        GuiUtil.AddElement(
        {
            parent = player.gui.center,
            name = "shopMain",
            type = "frame",
            direction = "vertical",
            style = "muppet_padded_frame_main",
            storeName = "ShopGui",
            styling = {right_padding = 4, bottom_padding = 4},
            children = {
                {
                    type = "flow",
                    direction = "horizontal",
                    style = "muppet_horizontal_flow",
                    styling = {horizontal_align = "left"},
                    children = {
                        {
                            name = "shopMainHeaderBar",
                            type = "label",
                            style = "muppet_large_bold_heading",
                            caption = "self"
                        },
                        {
                            type = "flow",
                            direction = "horizontal",
                            style = "muppet_horizontal_flow",
                            styling = {horizontal_align = "right", horizontally_stretchable = true, padding = 4},
                            children = {
                                {
                                    name = "shopMainHeaderBarClose",
                                    type = "sprite-button",
                                    sprite = "utility/close_white",
                                    tooltip = "self",
                                    style = "close_button",
                                    registerClick = {actionName = "ShopGui.CloseGuiClickAction"}
                                }
                            }
                        }
                    }
                },
                {
                    name = "shopMainContent",
                    type = "flow",
                    direction = "horizontal",
                    style = "muppet_horizontal_flow",
                    returnElement = true,
                    children = {
                        {
                            name = "shopMainLeftColumn",
                            type = "flow",
                            direction = "vertical",
                            style = "muppet_vertical_flow",
                            returnElement = true
                        }
                    }
                }
            }
        }
    )

    local shopMainLeftColumnFlow = GuiUtil.GetNameFromReturnedElements(elements, "shopMainLeftColumn", "flow")
    local shopMainContentFlow = GuiUtil.GetNameFromReturnedElements(elements, "shopMainContent", "flow")
    ShopGui.CreateItemList(shopMainLeftColumnFlow)
    ShopGui.CreateItemDetails(shopMainLeftColumnFlow)
    ShopGui.CreateShoppingBasket(shopMainContentFlow)
end

ShopGui.CreateItemList = function(shopMainLeftColumnFlow)
    GuiUtil.AddElement(
        {
            parent = shopMainLeftColumnFlow,
            type = "frame",
            direction = "vertical",
            style = "muppet_padded_frame_content",
            styling = {width = 500, height = 300},
            children = {
                {
                    name = "shopMainHeaderBar",
                    type = "scroll-pane",
                    direction = "vertical",
                    horizontal_scroll_policy = "never",
                    vertical_scroll_policy = "auto",
                    storeName = "ShopGui",
                    styling = {horizontally_stretchable = true, vertically_stretchable = true}
                }
            }
        }
    )
end

ShopGui.CreateItemDetails = function(shopMainLeftColumnFlow)
    GuiUtil.AddElement(
        {
            parent = shopMainLeftColumnFlow,
            type = "frame",
            direction = "vertical",
            style = "muppet_padded_frame_content",
            styling = {width = 500},
            children = {
                {
                    type = "flow",
                    direction = "vertical",
                    style = "muppet_vertical_flow_spaced",
                    styling = {horizontal_align = "center"},
                    children = {
                        {
                            name = "itemDetailsTitle",
                            type = "label",
                            style = "muppet_medium_semibold_heading",
                            storeName = "ShopGui",
                            styling = {horizontally_stretchable = true}
                        }
                    }
                },
                {
                    type = "flow",
                    direction = "horizontal",
                    style = "muppet_horizontal_flow_spaced",
                    children = {
                        {
                            type = "flow",
                            direction = "vertical",
                            style = "muppet_vertical_flow_spaced",
                            styling = {horizontal_align = "center", top_margin = 4, bottom_margin = 4},
                            children = {
                                {
                                    name = "itemDetailsImage",
                                    type = "sprite",
                                    style = "prime_intergalactic_delivery_sprite_64",
                                    storeName = "ShopGui"
                                },
                                {
                                    name = "itemDetailsPrice",
                                    type = "label",
                                    style = "muppet_small_semibold_text",
                                    storeName = "ShopGui"
                                },
                                {
                                    name = "itemDetailsAdd",
                                    type = "button",
                                    style = "muppet_small_button",
                                    caption = "Add to basket",
                                    registerClick = {actionName = "ShopGui.AddToShoppingBasketAction"}
                                }
                            }
                        },
                        {type = "line", direction = "vertical", style = "line", styling = {vertically_stretchable = true}},
                        {
                            type = "flow",
                            direction = "vertical",
                            style = "muppet_vertical_flow",
                            styling = {horizontally_stretchable = true},
                            children = {
                                {
                                    name = "shopItemsDetailsDescription",
                                    type = "label",
                                    style = "muppet_small_text",
                                    storeName = "ShopGui"
                                }
                            }
                        }
                    }
                }
            }
        }
    )
end

ShopGui.CreateShoppingBasket = function(shopMainContentFlow)
    GuiUtil.AddElement(
        {
            parent = shopMainContentFlow,
            type = "frame",
            direction = "vertical",
            style = "muppet_padded_frame_content",
            styling = {width = 400, vertically_stretchable = true}
        }
    )
end

ShopGui.PopulateTestData = function(playerIndex)
    GuiUtil.UpdateElementFromPlayersReferenceStorage(playerIndex, "ShopGui", "itemDetailsTitle", "label", {caption = "Test Item Title"})
    GuiUtil.UpdateElementFromPlayersReferenceStorage(playerIndex, "ShopGui", "itemDetailsImage", "sprite", {sprite = "entity/roboport"})
    GuiUtil.UpdateElementFromPlayersReferenceStorage(playerIndex, "ShopGui", "shopItemsDetailsDescription", "label", {caption = "A  description of this thing with quite a few words as a bit of flavour text is always nice."})
    GuiUtil.UpdateElementFromPlayersReferenceStorage(playerIndex, "ShopGui", "itemDetailsPrice", "label", {caption = "5,000 " .. "[img=item/coin]"})
end

ShopGui.AddToShoppingBasketAction = function(actionData)
    game.print("create ShopGui.AddToShoppingBasketAction: " .. tostring(actionData))
end

return ShopGui
