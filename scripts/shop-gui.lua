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
    GuiActionsClick.LinkGuiClickActionNameToFunction("ShopGui.SelectItemInList", ShopGui.SelectItemInList)
end

ShopGui.RegisterMarketForOpened = function(marketEntity)
    GuiActionsOpened.RegisterEntityForGuiOpenedAction(marketEntity, "ShopGui.MarketOpened")
end

ShopGui.MarketOpened = function(actionData)
    local player = game.get_player(actionData.playerIndex)
    player.opened = nil --close the market GUI
    ShopGui.CloseGui(player.index)
    ShopGui.CreateGui(player)

    ShopGui.PopulateItemsList(player.index)
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
            style = "muppet_frame_main_shadowRisen_paddingBR",
            storeName = "ShopGui",
            children = {
                {
                    type = "flow",
                    direction = "horizontal",
                    style = "muppet_flow_horizontal_marginTL",
                    styling = {horizontal_align = "left", right_padding = 4},
                    children = {
                        {
                            name = "shopGuiTitle",
                            type = "label",
                            style = "muppet_label_heading_large_bold_paddingSides",
                            caption = "self"
                        },
                        {
                            type = "flow",
                            direction = "horizontal",
                            style = "muppet_flow_horizontal",
                            styling = {horizontal_align = "right", horizontally_stretchable = true},
                            children = {
                                {
                                    name = "shopGuiCloseButton",
                                    type = "sprite-button",
                                    sprite = "prime_intergalactic_delivery-close_white",
                                    tooltip = "self",
                                    style = "muppet_sprite_button_frame_clickable",
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
                    style = "muppet_flow_horizontal",
                    returnElement = true,
                    children = {
                        {
                            name = "shopMainLeftColumn",
                            type = "flow",
                            direction = "vertical",
                            style = "muppet_flow_vertical",
                            returnElement = true,
                            children = {
                                {
                                    type = "flow",
                                    direction = "vertical",
                                    style = "muppet_flow_vertical_marginTL",
                                    styling = {width = 500, height = 300, padding = 2}, --make the scroll pane fit with other frames via theis flow
                                    children = {
                                        {
                                            type = "scroll-pane",
                                            direction = "vertical",
                                            horizontal_scroll_policy = "never",
                                            vertical_scroll_policy = "always",
                                            style = "muppet_scroll",
                                            styling = {horizontally_stretchable = true, vertically_stretchable = true},
                                            children = {
                                                {
                                                    name = "shopItemList",
                                                    type = "table",
                                                    column_count = 5,
                                                    storeName = "ShopGui",
                                                    style = "muppet_table"
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    )

    local shopMainLeftColumnFlow = GuiUtil.GetNameFromReturnedElements(elements, "shopMainLeftColumn", "flow")
    local shopMainContentFlow = GuiUtil.GetNameFromReturnedElements(elements, "shopMainContent", "flow")
    ShopGui.CreateItemDetails(shopMainLeftColumnFlow)
    ShopGui.CreateShoppingBasket(shopMainContentFlow)
end

ShopGui.CreateItemDetails = function(shopMainLeftColumnFlow)
    GuiUtil.AddElement(
        {
            parent = shopMainLeftColumnFlow,
            type = "frame",
            direction = "vertical",
            style = "muppet_frame_content_shadowRisen_marginTL_paddingBR",
            styling = {width = 500},
            children = {
                {
                    type = "flow",
                    direction = "horizontal",
                    style = "muppet_flow_horizontal_marginTL_spaced",
                    children = {
                        {
                            type = "flow",
                            direction = "vertical",
                            style = "muppet_flow_vertical_spaced",
                            styling = {horizontal_align = "center", top_margin = 4, bottom_margin = 4},
                            children = {
                                {
                                    name = "itemDetailsImage",
                                    type = "sprite",
                                    style = "muppet_sprite_64",
                                    storeName = "ShopGui"
                                },
                                {
                                    name = "itemDetailsPrice",
                                    type = "label",
                                    style = "muppet_label_text_small_semibold",
                                    storeName = "ShopGui",
                                    caption = " "
                                },
                                {
                                    name = "itemDetailsAdd",
                                    type = "button",
                                    style = "muppet_small_button",
                                    caption = "Add to basket",
                                    storeName = "ShopGui",
                                    enabled = false
                                }
                            }
                        },
                        {
                            type = "line",
                            direction = "vertical",
                            style = "line",
                            styling = {vertically_stretchable = true}
                        },
                        {
                            type = "flow",
                            direction = "vertical",
                            style = "muppet_flow_vertical",
                            styling = {horizontally_stretchable = true},
                            children = {
                                {
                                    type = "flow",
                                    direction = "vertical",
                                    style = "muppet_flow_vertical",
                                    styling = {horizontal_align = "center"},
                                    children = {
                                        {
                                            name = "itemDetailsTitle",
                                            type = "label",
                                            style = "muppet_label_heading_medium_semibold",
                                            storeName = "ShopGui",
                                            styling = {horizontally_stretchable = true}
                                        }
                                    }
                                },
                                {
                                    name = "shopItemsDetailsDescription",
                                    type = "label",
                                    style = "muppet_label_text_small",
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
            style = "muppet_frame_content_shadowRisen_marginTL_paddingBR",
            styling = {width = 400, vertically_stretchable = true}
        }
    )
end

ShopGui.PopulateItemsList = function(playerIndex)
    local itemListTable = GuiUtil.GetElementFromPlayersReferenceStorage(playerIndex, "ShopGui", "shopItemList", "table")
    itemListTable.clear()
    for itemName, itemDetails in pairs(global.shop.items) do
        GuiUtil.AddElement(
            {
                parent = itemListTable,
                name = itemName,
                type = "frame",
                direction = "vertical",
                style = "muppet_frame_contentInnerLight_shadowRisen",
                registerClick = {actionName = "ShopGui.SelectItemInList", data = {itemName = itemName}},
                children = {
                    {
                        name = itemName,
                        type = "flow",
                        direction = "vertical",
                        style = "muppet_flow_vertical_spaced",
                        styling = {horizontal_align = "center", horizontally_stretchable = true, vertically_stretchable = true},
                        registerClick = {actionName = "ShopGui.SelectItemInList", data = {itemName = itemName}},
                        children = {
                            {
                                name = itemName,
                                type = "sprite",
                                style = "muppet_sprite_48",
                                sprite = itemDetails.picture,
                                registerClick = {actionName = "ShopGui.SelectItemInList", data = {itemName = itemName}}
                            },
                            {
                                name = itemName,
                                type = "label",
                                style = "muppet_label_text_small",
                                caption = itemDetails.price .. "[img=item/coin]",
                                registerClick = {actionName = "ShopGui.SelectItemInList", data = {itemName = itemName}}
                            }
                        }
                    }
                }
            }
        )
    end
end

ShopGui.AddToShoppingBasketAction = function(actionData)
    game.print("create ShopGui.AddToShoppingBasketAction: " .. actionData.data.itemName)
end

ShopGui.SelectItemInList = function(actionData)
    local playerIndex, itemName = actionData.playerIndex, actionData.data.itemName
    local itemDetails = global.shop.items[itemName]

    GuiUtil.UpdateElementFromPlayersReferenceStorage(playerIndex, "ShopGui", "itemDetailsTitle", "label", {caption = {itemDetails.localisedName}})
    GuiUtil.UpdateElementFromPlayersReferenceStorage(playerIndex, "ShopGui", "itemDetailsImage", "sprite", {sprite = itemDetails.picture})
    GuiUtil.UpdateElementFromPlayersReferenceStorage(playerIndex, "ShopGui", "shopItemsDetailsDescription", "label", {caption = {itemDetails.localisedDescription}})
    GuiUtil.UpdateElementFromPlayersReferenceStorage(playerIndex, "ShopGui", "itemDetailsPrice", "label", {caption = itemDetails.price .. "[img=item/coin]"})
    GuiUtil.UpdateElementFromPlayersReferenceStorage(
        playerIndex,
        "ShopGui",
        "itemDetailsAdd",
        "button",
        {
            registerClick = {actionName = "ShopGui.AddToShoppingBasketAction", data = {itemName = itemName}},
            enabled = true
        }
    )
end

return ShopGui
