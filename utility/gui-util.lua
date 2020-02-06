local GuiUtil = {}
local Utils = require("utility/utils")
local GuiActionsClick = require("utility/gui-actions-click")
local Logging = require("utility/logging")
local Constants = require("constants")

--[[
    - elementDetails takes everything that GuiElement.add() accepts in Factorio API. Plus compulsory "parent" argument of who to create the GUI element under if it isn't a child element.
    - The "name" argument will be merged with the mod name and type to try and ensure a unique name is given to the GUI element in Factorio API.
    - The optional "children" argument is an array of other elements detail's arrays, to recursively add in this hierachy. Parent argument isn't required and is ignored for children, as it is worked out during recursive loop.
    - Passing the string "self" as the caption/tooltip value or localised string name will be auto replaced to its unique mod auto generated name under gui-caption/gui-tooltip. This avoids having to duplicate name when defining the element's arguments.
    - The optional "styling" argument of a table of style attributes to be applied post element creation. Saves having to capture local reference to do this with at element declaration point.
    - The optional "registerClick" passes the supplied "actionName" string and the optional "data" table to GuiActionsClick.RegisterGuiForClick().
    - The optional "returnElement" if true will return the element in a table of elements. Key will be the elements name..type and the value a reference to the element.
]]
GuiUtil.AddElement = function(elementDetails)
    local rawName = elementDetails.name
    elementDetails.name = GuiUtil.GenerateGuiElementName(elementDetails.name, elementDetails.type)
    elementDetails.caption = GuiUtil._ReplaceSelfWithGeneratedName(elementDetails, "caption")
    elementDetails.tooltip = GuiUtil._ReplaceSelfWithGeneratedName(elementDetails, "tooltip")
    local returnElements = {}
    local element = elementDetails.parent.add(elementDetails)
    if elementDetails.returnElement then
        if elementDetails.name == nil then
            Logging.LogPrint("ERROR: returnElement attribute requires element name to be supplied.")
        else
            returnElements[elementDetails.name] = element
        end
    end
    if elementDetails.styling ~= nil then
        for k, v in pairs(elementDetails.styling) do
            element.style[k] = v
        end
    end
    if elementDetails.storeName ~= nil then
        if elementDetails.name == nil then
            Logging.LogPrint("ERROR: storeName attribute requires element name to be supplied.")
        else
            GuiUtil.AddElementToPlayersReferenceStorage(element.player_index, elementDetails.storeName, elementDetails.name, element)
        end
    end
    if elementDetails.registerClick ~= nil then
        if elementDetails.name == nil then
            Logging.LogPrint("ERROR: registerClick attribute requires element name to be supplied.")
        else
            GuiActionsClick.RegisterGuiForClick(rawName, elementDetails.type, elementDetails.registerClick.actionName, elementDetails.registerClick.data)
        end
    end

    if elementDetails.children ~= nil then
        for _, child in pairs(elementDetails.children) do
            child.parent = element
            local childReturnElements = GuiUtil.AddElement(child)
            if childReturnElements ~= nil then
                returnElements = Utils.TableMerge({returnElements, childReturnElements})
            end
        end
    end
    if Utils.GetTableNonNilLength(returnElements) then
        return returnElements
    else
        return nil
    end
end

--Gets a specific name and type from the returned elements table from the GuiUtil.AddElement() function.
GuiUtil.GetNameFromReturnedElements = function(returnedElements, elementName, elementType)
    if returnedElements == nil then
        return nil
    else
        return returnedElements[GuiUtil.GenerateGuiElementName(elementName, elementType)]
    end
end

GuiUtil._CreatePlayersElementReferenceStorage = function(playerIndex, storeName)
    global.GUIUtilPlayerElementReferenceStorage = global.GUIUtilPlayerElementReferenceStorage or {}
    global.GUIUtilPlayerElementReferenceStorage[playerIndex] = global.GUIUtilPlayerElementReferenceStorage[playerIndex] or {}
    global.GUIUtilPlayerElementReferenceStorage[playerIndex][storeName] = global.GUIUtilPlayerElementReferenceStorage[playerIndex][storeName] or {}
end

GuiUtil.AddElementToPlayersReferenceStorage = function(playerIndex, storeName, fullName, element)
    GuiUtil._CreatePlayersElementReferenceStorage(playerIndex, storeName)
    global.GUIUtilPlayerElementReferenceStorage[playerIndex][storeName][fullName] = element
end

GuiUtil.GetElementFromPlayersReferenceStorage = function(playerIndex, storeName, name, type)
    GuiUtil._CreatePlayersElementReferenceStorage(playerIndex, storeName)
    return global.GUIUtilPlayerElementReferenceStorage[playerIndex][storeName][GuiUtil.GenerateGuiElementName(name, type)]
end

GuiUtil.GetOrAddElement = function(arguments, storeName)
    local frameElement = GuiUtil.GetElementFromPlayersReferenceStorage(arguments.parent.player_index, storeName, arguments.name, arguments.type)
    if frameElement == nil then
        frameElement = GuiUtil.AddElement(arguments, storeName)
    end
    return frameElement
end

GuiUtil.UpdateElementFromPlayersReferenceStorage = function(playerIndex, storeName, name, type, arguments)
    local element = GuiUtil.GetElementFromPlayersReferenceStorage(playerIndex, storeName, name, type)
    if element ~= nil then
        local generatedName = GuiUtil.GenerateGuiElementName(name, type)
        for argName, argValue in pairs(arguments) do
            if argName == "caption" or argName == "tooltip" then
                argValue = GuiUtil._ReplaceSelfWithGeneratedName({name = generatedName, [argName] = argValue}, argName)
            end
            element[argName] = argValue
        end
    end
    return element
end

GuiUtil.DestroyElementInPlayersReferenceStorage = function(playerIndex, storeName, name, type)
    local elementName = GuiUtil.GenerateGuiElementName(name, type)
    if global.GUIUtilPlayerElementReferenceStorage ~= nil and global.GUIUtilPlayerElementReferenceStorage[playerIndex] ~= nil and global.GUIUtilPlayerElementReferenceStorage[playerIndex][storeName] ~= nil and global.GUIUtilPlayerElementReferenceStorage[playerIndex][storeName][elementName] ~= nil then
        if global.GUIUtilPlayerElementReferenceStorage[playerIndex][storeName][elementName].valid then
            global.GUIUtilPlayerElementReferenceStorage[playerIndex][storeName][elementName].destroy()
        end
        global.GUIUtilPlayerElementReferenceStorage[playerIndex][storeName][elementName] = nil
    end
end

GuiUtil.DestroyPlayersReferenceStorage = function(playerIndex, storeName)
    if global.GUIUtilPlayerElementReferenceStorage == nil or global.GUIUtilPlayerElementReferenceStorage[playerIndex] == nil then
        return
    end
    if storeName == nil then
        for _, store in pairs(global.GUIUtilPlayerElementReferenceStorage[playerIndex]) do
            for _, element in pairs(store) do
                if element.valid then
                    element.destroy()
                end
            end
        end
        global.GUIUtilPlayerElementReferenceStorage[playerIndex] = nil
    else
        if global.GUIUtilPlayerElementReferenceStorage[playerIndex][storeName] == nil then
            return
        end
        for _, element in pairs(global.GUIUtilPlayerElementReferenceStorage[playerIndex][storeName]) do
            if element.valid then
                element.destroy()
            end
        end
        global.GUIUtilPlayerElementReferenceStorage[playerIndex][storeName] = nil
    end
end

GuiUtil._ReplaceSelfWithGeneratedName = function(arguments, argName)
    local arg = arguments[argName]
    if arg == nil or arguments.name == nil then
        arg = nil
    elseif arg == "self" then
        arg = {"gui-" .. argName .. "." .. arguments.name}
    elseif type(arg) == "table" and arg[1] ~= nil and arg[1] == "self" then
        arg[1] = "gui-" .. argName .. "." .. arguments.name
    end
    return arg
end

GuiUtil.GenerateGuiElementName = function(name, type)
    if name == nil then
        return nil
    else
        return Constants.ModName .. "-" .. name .. "-" .. type
    end
end

return GuiUtil
