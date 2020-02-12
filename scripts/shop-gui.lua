local ShopGui = {}
local GuiUtil = require("utility/gui-util")
local GuiActionsClick = require("utility/gui-actions-click")
local GuiActionsOpened = require("utility/gui-actions-opened")
local Interfaces = require("utility/interfaces")
local Events = require("utility/events")
local Colors = require("utility/colors")
local Logging = require("utility/logging")
local Utils = require("utility/utils")
local Commands = require("utility/commands")

local coinIconText = " [img=item/coin]"

ShopGui.CreateGlobals = function()
    global.shopGui = global.shopGui or {}
    global.shopGui.guiOpenPlayerIndex = global.shopGui.guiOpenPlayerIndex or nil
    global.shopGui.guiOpenPlayerText = global.shopGui.guiOpenPlayerText or nil
    global.shopGui.guiOpenShopText = global.shopGui.guiOpenShopText or nil
    global.shopGui.shoppingBasket = global.shopGui.shoppingBasket or {}
    global.shopGui.currentSoftwareLevelOffered = global.shopGui.currentSoftwareLevelOffered or {}
    global.shopGui.currentPurchaseId = global.shopGui.currentPurchaseId or math.random(117, 462)
    global.shopGui.ordersMade = global.shopGui.ordersMade or {}
end

ShopGui.OnLoad = function()
    Interfaces.RegisterInterface("ShopGui.RegisterMarketForOpened", ShopGui.RegisterMarketForOpened)
    GuiActionsOpened.LinkGuiOpenedActionNameToFunction("ShopGui.MarketEntityClicked", ShopGui.MarketEntityClicked)
    GuiActionsClick.LinkGuiClickActionNameToFunction("ShopGui.CloseGuiClickAction", ShopGui.CloseGuiClickAction)
    GuiActionsClick.LinkGuiClickActionNameToFunction("ShopGui.AddToShoppingBasketAction", ShopGui.AddToShoppingBasketAction)
    GuiActionsClick.LinkGuiClickActionNameToFunction("ShopGui.SelectItemInListAction", ShopGui.SelectItemInListAction)
    Events.RegisterHandler(defines.events.on_player_left_game, "ShopGui.OnPlayerLeftGame", ShopGui.OnPlayerLeftGame)
    GuiActionsClick.LinkGuiClickActionNameToFunction("ShopGui.BuyBasketAction", ShopGui.BuyBasketAction)
    GuiActionsClick.LinkGuiClickActionNameToFunction("ShopGui.EmptyBasketAction", ShopGui.EmptyBasketAction)
    Interfaces.RegisterInterface("ShopGui.RecreateGui", ShopGui.RecreateGui)
    GuiActionsClick.LinkGuiClickActionNameToFunction("ShopGui.ChangeBasketQuantityAction", ShopGui.ChangeBasketQuantityAction)
    Events.RegisterHandler(defines.events.on_player_died, "ShopGui.OnPlayerDied", ShopGui.OnPlayerDied)
    Commands.Register("prime_intergalactic_delivery_export_orders", {"api-description.prime_intergalactic_delivery_export_orders"}, ShopGui.ExportOrders, false)
end

ShopGui.RegisterMarketForOpened = function(marketEntity)
    GuiActionsOpened.RegisterEntityForGuiOpenedAction(marketEntity, "ShopGui.MarketEntityClicked")
end

ShopGui.MarketEntityClicked = function(actionData)
    local player = game.get_player(actionData.playerIndex)
    player.opened = nil --close the market GUI
    if global.shopGui.guiOpenPlayerIndex then
        return
    end
    ShopGui.PlayerOpeningGui(player)
end

ShopGui.CloseGuiClickAction = function(actionData)
    ShopGui.CloseGui(actionData.playerIndex)
end

ShopGui.CloseGui = function(playerIndex)
    global.shopGui.guiOpenPlayerIndex = nil
    if global.shopGui.guiOpenPlayerText ~= nil then
        rendering.destroy(global.shopGui.guiOpenPlayerText)
    end
    rendering.destroy(global.shopGui.guiOpenShopText)
    GuiUtil.DestroyElementInPlayersReferenceStorage(playerIndex, "ShopGui", "shopGuiMain", "frame")
end

ShopGui.OnPlayerLeftGame = function(event)
    local playerIndex = event.player_index
    if playerIndex == global.shopGui.guiOpenPlayerIndex then
        ShopGui.CloseGui(playerIndex)
    end
end

ShopGui.OnPlayerDied = function(event)
    local playerIndex = event.player_index
    if playerIndex == global.shopGui.guiOpenPlayerIndex then
        ShopGui.CloseGui(playerIndex)
    end
end

ShopGui.RecreateGui = function()
    local playerIndex = global.shopGui.guiOpenPlayerIndex
    if playerIndex == nil then
        return
    end
    ShopGui.CloseGui(playerIndex)
    ShopGui.PlayerOpeningGui(game.get_player(playerIndex))
end

ShopGui.PlayerOpeningGui = function(player)
    global.shopGui.guiOpenPlayerIndex = player.index
    if player.character ~= nil then
        global.shopGui.guiOpenPlayerText = rendering.draw_text {text = {"rendering-text.prime_intergalactic_delivery-player_in_shop_gui"}, surface = global.surface, target = player.character, color = Colors.white, alignment = "center"}
    end
    global.shopGui.guiOpenShopText = rendering.draw_text {text = {"rendering-text.prime_intergalactic_delivery-shop_gui_in_use"}, surface = global.surface, target = global.facility.shop, color = Colors.white, alignment = "center"}

    if Utils.GetTableNonNilLength(global.shopGui.currentSoftwareLevelOffered) == 0 then
        for itemName, itemDetails in pairs(global.shop.items) do
            if itemDetails.type == "software" then
                global.shopGui.currentSoftwareLevelOffered[itemName] = global.shop.softwareLevelsPurchased[itemName] + 1
            end
        end
    end

    ShopGui.CreateGuiStructure(player)
    ShopGui.PopulateItemsList(player.index)
    ShopGui.UpdateShoppingBasket(player.index)
end

ShopGui.CreateGuiStructure = function(player)
    GuiUtil.AddElement(
        {
            parent = player.gui.center,
            name = "shopGuiMain",
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
                            style = "muppet_flow_horizontal_spaced",
                            styling = {horizontal_align = "right", horizontally_stretchable = true, top_margin = 4},
                            children = {
                                {
                                    name = "shopGuiBasketEmpty",
                                    type = "button",
                                    style = "muppet_button_text_small_frame_paddingNone",
                                    styling = {},
                                    caption = "self",
                                    storeName = "ShopGui",
                                    registerClick = {actionName = "ShopGui.EmptyBasketAction"},
                                    enabled = false
                                },
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
                    type = "flow",
                    direction = "horizontal",
                    style = "muppet_flow_horizontal",
                    children = {
                        {
                            type = "frame",
                            direction = "vertical",
                            style = "muppet_frame_content_shadowRisen_marginTL_paddingBR",
                            styling = {width = 500},
                            children = {
                                {
                                    type = "flow",
                                    direction = "vertical",
                                    style = "muppet_flow_vertical_marginTL",
                                    children = {
                                        {
                                            type = "scroll-pane",
                                            direction = "vertical",
                                            horizontal_scroll_policy = "never",
                                            vertical_scroll_policy = "always",
                                            style = "muppet_scroll",
                                            styling = {horizontally_stretchable = true, vertically_stretchable = true, height = 300},
                                            children = {
                                                {
                                                    name = "shopGuiItemList",
                                                    type = "table",
                                                    column_count = 5,
                                                    storeName = "ShopGui",
                                                    style = "muppet_table"
                                                }
                                            }
                                        }
                                    }
                                },
                                {
                                    type = "flow",
                                    direction = "horizontal",
                                    style = "muppet_flow_horizontal_marginTL_spaced",
                                    styling = {height = 124},
                                    children = {
                                        {
                                            type = "flow",
                                            direction = "vertical",
                                            style = "muppet_flow_vertical_spaced",
                                            styling = {horizontal_align = "center", top_margin = 4},
                                            children = {
                                                {
                                                    name = "shopGuiItemDetailsImage",
                                                    type = "sprite",
                                                    style = "muppet_sprite_64",
                                                    storeName = "ShopGui"
                                                },
                                                {
                                                    name = "shopGuiItemDetailsPrice",
                                                    type = "label",
                                                    style = "muppet_label_text_small_semibold",
                                                    storeName = "ShopGui",
                                                    caption = " "
                                                },
                                                {
                                                    name = "shopGuiItemDetailsAdd",
                                                    type = "button",
                                                    style = "muppet_button_text_small_paddingSides",
                                                    caption = "self",
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
                                                            name = "shopGuiItemDetailsTitle",
                                                            type = "label",
                                                            style = "muppet_label_heading_medium_semibold",
                                                            storeName = "ShopGui",
                                                            styling = {horizontally_stretchable = true}
                                                        }
                                                    }
                                                },
                                                {
                                                    name = "shopGuiItemsDetailsDescription",
                                                    type = "label",
                                                    style = "muppet_label_text_small",
                                                    storeName = "ShopGui"
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        },
                        {
                            type = "frame",
                            direction = "vertical",
                            style = "muppet_frame_content_shadowRisen_marginTL_paddingBR",
                            styling = {width = 400},
                            children = {
                                {
                                    type = "flow",
                                    direction = "vertical",
                                    style = "muppet_flow_vertical_spaced",
                                    children = {
                                        {
                                            type = "scroll-pane",
                                            direction = "vertical",
                                            horizontal_scroll_policy = "never",
                                            vertical_scroll_policy = "always",
                                            style = "muppet_scroll_marginTL",
                                            styling = {horizontally_stretchable = true, right_margin = 4, height = 328},
                                            children = {
                                                {
                                                    name = "shopGuiBasketList",
                                                    type = "table",
                                                    style = "muppet_table_cellPadded",
                                                    column_count = 3,
                                                    storeName = "ShopGui",
                                                    draw_horizontal_line_after_headers = true,
                                                    styling = {column_alignments = {"left", "left", "right"}, vertically_stretchable = true}
                                                }
                                            }
                                        },
                                        {
                                            type = "flow",
                                            direction = "horizontal",
                                            style = "muppet_flow_horizontal",
                                            styling = {top_margin = 8, bottom_margin = 0},
                                            children = {
                                                {
                                                    type = "frame",
                                                    style = "muppet_frame_contentInnerDark_shadowSunken",
                                                    styling = {width = 200, left_margin = 4},
                                                    children = {
                                                        {
                                                            type = "table",
                                                            style = "muppet_table_verticalSpaced",
                                                            column_count = 2,
                                                            styling = {column_alignments = {"left", "right"}},
                                                            children = {
                                                                {
                                                                    name = "shopGuiBasketCreditLabel",
                                                                    type = "label",
                                                                    style = "muppet_label_text_medium_semibold",
                                                                    caption = "self",
                                                                    styling = {horizontally_stretchable = true}
                                                                },
                                                                {
                                                                    name = "shopGuiBasketCreditValue",
                                                                    type = "label",
                                                                    style = "muppet_label_text_medium",
                                                                    storeName = "ShopGui"
                                                                },
                                                                {
                                                                    name = "shopGuiBasketTotalCostLabel",
                                                                    type = "label",
                                                                    style = "muppet_label_text_medium_semibold",
                                                                    caption = "self"
                                                                },
                                                                {
                                                                    name = "shopGuiBasketTotalCostValue",
                                                                    type = "label",
                                                                    style = "muppet_label_text_medium",
                                                                    storeName = "ShopGui"
                                                                },
                                                                {
                                                                    name = "shopGuiBasketAvailableLabel",
                                                                    type = "label",
                                                                    style = "muppet_label_text_medium_semibold",
                                                                    caption = "self"
                                                                },
                                                                {
                                                                    name = "shopGuiBasketAvailableValue",
                                                                    type = "label",
                                                                    style = "muppet_label_text_medium",
                                                                    storeName = "ShopGui"
                                                                }
                                                            }
                                                        }
                                                    }
                                                },
                                                {
                                                    type = "flow",
                                                    direction = "vertical",
                                                    style = "muppet_flow_vertical_spaced",
                                                    styling = {horizontal_align = "center", height = 88, width = 170, left_margin = 8},
                                                    children = {
                                                        {
                                                            name = "shopGuiBasketDeliveryEta",
                                                            type = "label",
                                                            style = "muppet_label_text_small",
                                                            caption = {"self", ShopGui.GetDeliveryEtaLocalisedString()},
                                                            styling = {vertical_align = "center"}
                                                        },
                                                        {
                                                            name = "shopGuiBasketOrderId",
                                                            type = "label",
                                                            style = "muppet_label_text_small",
                                                            caption = {"self", global.shopGui.currentPurchaseId},
                                                            styling = {vertical_align = "center"}
                                                        },
                                                        {
                                                            type = "flow",
                                                            direction = "vertical",
                                                            style = "muppet_flow_vertical",
                                                            styling = {vertical_align = "bottom", horizontal_align = "right", horizontally_stretchable = true, vertically_stretchable = true},
                                                            children = {
                                                                {
                                                                    name = "shopGuiBasketBuy",
                                                                    type = "button",
                                                                    style = "muppet_button_text_large_bold",
                                                                    styling = {left_padding = 20, right_padding = 20, bottom_margin = -4},
                                                                    caption = "self",
                                                                    storeName = "ShopGui",
                                                                    registerClick = {actionName = "ShopGui.BuyBasketAction"},
                                                                    enabled = false
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
                    }
                }
            }
        }
    )
end

ShopGui.PopulateItemsList = function(playerIndex)
    local itemListTable = GuiUtil.GetElementFromPlayersReferenceStorage(playerIndex, "ShopGui", "shopGuiItemList", "table")
    itemListTable.clear()
    for itemName, itemDetails in pairs(global.shop.items) do
        local disabled, priceValue = false
        if itemDetails.type ~= "software" then
            priceValue = itemDetails.price
        else
            local offeredLevel = global.shopGui.currentSoftwareLevelOffered[itemName]
            priceValue = Interfaces.Call("Shop.CalculateSoftwarePrice", offeredLevel)
            if offeredLevel > global.shop.softwareMaxLevel then
                disabled = true
            end
        end
        GuiUtil.AddElement(
            {
                parent = itemListTable,
                name = "guiShopItemList" .. itemName,
                type = "frame",
                direction = "vertical",
                style = "muppet_frame_contentInnerLight_shadowRisen",
                registerClick = {actionName = "ShopGui.SelectItemInListAction", data = {itemName = itemName}, disabled = disabled},
                enabled = not disabled,
                children = {
                    {
                        name = "guiShopItemList" .. itemName,
                        type = "flow",
                        direction = "vertical",
                        style = "muppet_flow_vertical_spaced",
                        styling = {horizontal_align = "center", natural_width = 92, natural_height = 72},
                        registerClick = {actionName = "ShopGui.SelectItemInListAction", data = {itemName = itemName}, disabled = disabled},
                        enabled = not disabled,
                        children = {
                            {
                                name = "guiShopItemList" .. itemName,
                                type = "sprite",
                                style = "muppet_sprite_48",
                                sprite = itemDetails.picture,
                                registerClick = {actionName = "ShopGui.SelectItemInListAction", data = {itemName = itemName}, disabled = disabled},
                                enabled = not disabled
                            },
                            {
                                name = "guiShopItemList" .. itemName,
                                type = "label",
                                style = "muppet_label_text_small_bold",
                                caption = Utils.DisplayNumberPretty(priceValue) .. coinIconText,
                                registerClick = {actionName = "ShopGui.SelectItemInListAction", data = {itemName = itemName}, disabled = disabled},
                                enabled = not disabled
                            }
                        }
                    }
                }
            }
        )
    end
end

ShopGui.SelectItemInListAction = function(actionData)
    ShopGui.UpdateSelectedItemDetails(actionData.playerIndex, actionData.data.itemName)
end

ShopGui.UpdateSelectedItemDetails = function(playerIndex, itemName)
    local itemDetails = global.shop.items[itemName]
    local disabled, titleCaption, priceValue = false
    if itemDetails.type ~= "software" then
        titleCaption = {itemDetails.localisedName}
        priceValue = itemDetails.price
    else
        local offeredLevel = global.shopGui.currentSoftwareLevelOffered[itemName]
        titleCaption = {"gui-caption.prime_intergalactic_delivery-shopGuiItemDetailsTitleSoftware", {itemDetails.localisedName}, offeredLevel}
        priceValue = Interfaces.Call("Shop.CalculateSoftwarePrice", offeredLevel)
        if offeredLevel > global.shop.softwareMaxLevel then
            disabled = true
        end
    end

    GuiUtil.UpdateElementFromPlayersReferenceStorage(playerIndex, "ShopGui", "shopGuiItemDetailsTitle", "label", {caption = titleCaption})
    GuiUtil.UpdateElementFromPlayersReferenceStorage(playerIndex, "ShopGui", "shopGuiItemDetailsImage", "sprite", {sprite = itemDetails.picture})
    GuiUtil.UpdateElementFromPlayersReferenceStorage(playerIndex, "ShopGui", "shopGuiItemsDetailsDescription", "label", {caption = {itemDetails.localisedDescription}})
    GuiUtil.UpdateElementFromPlayersReferenceStorage(playerIndex, "ShopGui", "shopGuiItemDetailsPrice", "label", {caption = Utils.DisplayNumberPretty(priceValue) .. coinIconText})
    GuiUtil.UpdateElementFromPlayersReferenceStorage(
        playerIndex,
        "ShopGui",
        "shopGuiItemDetailsAdd",
        "button",
        {
            registerClick = {actionName = "ShopGui.AddToShoppingBasketAction", data = {itemName = itemName}, disabled = disabled},
            enabled = not disabled
        }
    )
end

ShopGui.AddToShoppingBasketAction = function(actionData)
    ShopGui.ChangeBasketQuantity(actionData.playerIndex, actionData.data.itemName, 1)
end

ShopGui.UpdateShoppingBasket = function(playerIndex)
    local shoppingBasketList = GuiUtil.GetElementFromPlayersReferenceStorage(playerIndex, "ShopGui", "shopGuiBasketList", "table")
    shoppingBasketList.clear()
    GuiUtil.AddElement({parent = shoppingBasketList, type = "label", style = "muppet_label_heading_small_bold", caption = {"gui-caption.prime_intergalactic_delivery-shopGuiBasketItemNameHeading"}, styling = {horizontally_stretchable = true}})
    GuiUtil.AddElement({parent = shoppingBasketList, type = "label", style = "muppet_label_heading_small_bold", caption = {"gui-caption.prime_intergalactic_delivery-shopGuiBasketItemQuantityHeading"}, styling = {width = 55}})
    GuiUtil.AddElement({parent = shoppingBasketList, type = "label", style = "muppet_label_heading_small_bold", caption = {"gui-caption.prime_intergalactic_delivery-shopGuiBasketItemPriceHeading"}, styling = {width = 80}})

    local totalCostValue = 0
    for itemName, itemQuantity in pairs(global.shopGui.shoppingBasket) do
        local itemDetails = global.shop.items[itemName]
        if itemDetails == nil then
            global.shop.items[itemName] = nil
        else
            local itemQuantityIncreaseExclude, itemQuantityCost = false
            if itemDetails.type ~= "software" then
                itemQuantityCost = (itemDetails.price * itemQuantity)
            else
                itemQuantityCost = Interfaces.Call("Shop.CalculateSoftwareLevelsPrice", itemName, itemQuantity)
                local offeredLevel = global.shopGui.currentSoftwareLevelOffered[itemName]
                if offeredLevel > global.shop.softwareMaxLevel then
                    itemQuantityIncreaseExclude = true
                end
            end
            totalCostValue = totalCostValue + itemQuantityCost

            GuiUtil.AddElement(
                {
                    parent = shoppingBasketList,
                    type = "label",
                    style = "muppet_label_text_small_semibold",
                    caption = {itemDetails.localisedName}
                }
            )
            GuiUtil.AddElement(
                {
                    parent = shoppingBasketList,
                    type = "flow",
                    direction = "horizontal",
                    style = "muppet_flow_horizontal",
                    children = {
                        {
                            type = "flow",
                            direction = "vertical",
                            style = "muppet_flow_vertical",
                            styling = {vertical_spacing = 2, vertically_stretchable = true, vertical_align = "center"},
                            children = {
                                {
                                    name = "shopGuiBasketItemQuantityIncrease" .. itemName,
                                    type = "sprite-button",
                                    sprite = "prime_intergalactic_delivery-basket_up_arrow",
                                    hovered_sprite = "prime_intergalactic_delivery-basket_up_arrow_hovered",
                                    clicked_sprite = "prime_intergalactic_delivery-basket_up_arrow_hovered",
                                    style = "muppet_sprite_button_noBorder",
                                    styling = {width = 14, height = 7},
                                    registerClick = {actionName = "ShopGui.ChangeBasketQuantityAction", data = {itemName = itemName, change = 1}},
                                    exclude = itemQuantityIncreaseExclude
                                },
                                {
                                    name = "shopGuiBasketItemQuantityIncreasePlaceholder" .. itemName,
                                    type = "sprite-button",
                                    style = "muppet_sprite_button_noBorder",
                                    styling = {width = 14, height = 7},
                                    exclude = not itemQuantityIncreaseExclude
                                },
                                {
                                    name = "shopGuiBasketItemQuantityDecrease" .. itemName,
                                    type = "sprite-button",
                                    sprite = "prime_intergalactic_delivery-basket_down_arrow",
                                    hovered_sprite = "prime_intergalactic_delivery-basket_down_arrow_hovered",
                                    clicked_sprite = "prime_intergalactic_delivery-basket_down_arrow_hovered",
                                    style = "muppet_sprite_button_noBorder",
                                    styling = {width = 14, height = 7},
                                    registerClick = {actionName = "ShopGui.ChangeBasketQuantityAction", data = {itemName = itemName, change = -1}}
                                }
                            }
                        },
                        {
                            type = "label",
                            style = "muppet_label_text_small_semibold",
                            caption = itemQuantity
                        }
                    }
                }
            )
            GuiUtil.AddElement(
                {
                    parent = shoppingBasketList,
                    type = "label",
                    style = "muppet_label_text_small_semibold",
                    caption = Utils.DisplayNumberPretty(itemQuantityCost) .. coinIconText
                }
            )
        end
    end

    local creditValue = global.facility.paymentChest.get_item_count("coin")
    GuiUtil.UpdateElementFromPlayersReferenceStorage(playerIndex, "ShopGui", "shopGuiBasketCreditValue", "label", {caption = Utils.DisplayNumberPretty(creditValue) .. coinIconText})
    GuiUtil.UpdateElementFromPlayersReferenceStorage(playerIndex, "ShopGui", "shopGuiBasketTotalCostValue", "label", {caption = Utils.DisplayNumberPretty(totalCostValue) .. coinIconText})
    local availableValue = creditValue - totalCostValue
    local availableValueColor
    local shoppingBasketBuyButton = GuiUtil.GetElementFromPlayersReferenceStorage(playerIndex, "ShopGui", "shopGuiBasketBuy", "button")
    local shoppingBasketEmptyButton = GuiUtil.GetElementFromPlayersReferenceStorage(playerIndex, "ShopGui", "shopGuiBasketEmpty", "button")
    if availableValue < 0 then
        availableValueColor = Colors.red
        shoppingBasketBuyButton.enabled = false
    else
        availableValueColor = Colors.white
        if totalCostValue > 0 then
            shoppingBasketBuyButton.enabled = true
        else
            shoppingBasketBuyButton.enabled = false
        end
    end
    if totalCostValue > 0 then
        shoppingBasketEmptyButton.enabled = true
    else
        shoppingBasketEmptyButton.enabled = false
    end
    GuiUtil.UpdateElementFromPlayersReferenceStorage(playerIndex, "ShopGui", "shopGuiBasketAvailableValue", "label", {caption = Utils.DisplayNumberPretty(availableValue) .. coinIconText, styling = {font_color = availableValueColor}})
end

ShopGui.ChangeBasketQuantityAction = function(actionData)
    ShopGui.ChangeBasketQuantity(actionData.playerIndex, actionData.data.itemName, actionData.data.change)
end

ShopGui.ChangeBasketQuantity = function(playerIndex, itemName, change)
    local value = (global.shopGui.shoppingBasket[itemName] or 0) + change
    if value < 0 then
        value = 0
    end
    if value > 0 then
        global.shopGui.shoppingBasket[itemName] = value
    else
        global.shopGui.shoppingBasket[itemName] = nil
    end

    local itemDetails = global.shop.items[itemName]
    if itemDetails.type == "software" then
        global.shopGui.currentSoftwareLevelOffered[itemName] = global.shopGui.currentSoftwareLevelOffered[itemName] + change
        ShopGui.UpdateSelectedItemDetails(playerIndex, itemName)
        ShopGui.PopulateItemsList(playerIndex)
    end

    ShopGui.UpdateShoppingBasket(playerIndex)
end

ShopGui.BuyBasketAction = function(actionData)
    local purchaseComplete = Interfaces.Call("Shop.BuyBasketItems")
    if purchaseComplete then
        local player = game.get_player(actionData.playerIndex)
        table.insert(global.shopGui.ordersMade, {orderId = global.shopGui.currentPurchaseId, tick = game.tick, playerName = player.name, items = Utils.DeepCopy(global.shopGui.shoppingBasket)})
        global.shopGui.currentPurchaseId = global.shopGui.currentPurchaseId + 1
        ShopGui.EmptyBasketAction(actionData)
        ShopGui.CloseGui(actionData.playerIndex)
    else
        Logging.LogPrint("ERROR: purchase filed to go through, um........")
    end
end

ShopGui.EmptyBasketAction = function(actionData)
    global.shopGui.shoppingBasket = {}
    global.shopGui.currentSoftwareLevelOffered = {}
    ShopGui.UpdateShoppingBasket(actionData.playerIndex)
end

ShopGui.GetDeliveryEtaLocalisedString = function()
    local deliveryMin, deliveryMax = global.shop.deliveryDelayMinTicks / 3600, global.shop.deliveryDelayMaxTicks / 3600
    if deliveryMin == deliveryMax then
        local deliveryMinRounded = Utils.RoundNumberToDecimalPlaces(deliveryMin, 0)
        if deliveryMinRounded == 0 then
            return {"gui-caption.prime_intergalactic_delivery-shopGuiBasketDeliveryEtaInstant"}
        else
            return {"gui-caption.prime_intergalactic_delivery-shopGuiBasketDeliveryEtaExactMinutes", Utils.RoundNumberToDecimalPlaces(deliveryMin, 0)}
        end
    else
        return {"gui-caption.prime_intergalactic_delivery-shopGuiBasketDeliveryEtaRangeMinutes", Utils.RoundNumberToDecimalPlaces(deliveryMin, 0), Utils.RoundNumberToDecimalPlaces(deliveryMax, 0)}
    end
end

ShopGui.ExportOrders = function(commandData)
    game.write_file("Prime_Intergalactic_Delivery_Orders.txt", Utils.TableContentsToJSON(global.shopGui.ordersMade), false, commandData.player_index)
end

return ShopGui
