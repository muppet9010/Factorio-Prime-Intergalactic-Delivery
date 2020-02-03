--local Logging = require("utility/logging")
local GuiActionsClick = {}
local GuiUtil = require("utility/gui-util")
MOD = MOD or {}
MOD.guiClickActions = MOD.guiClickActions or {}

--Called from the root of Control.lua
GuiActionsClick.MonitorGuiClickActions = function()
    script.on_event(defines.events.on_gui_click, GuiActionsClick._HandleGuiClickAction)
end

--Called from OnLoad() from each script file.
--When actionFunction is triggered actionData argument passed: {actionName = actionName, playerIndex = playerIndex, data = data_passed_on_event_register, eventData = raw_factorio_event_data}
GuiActionsClick.LinkGuiClickActionNameToFunction = function(actionName, actionFunction)
    if actionName == nil or actionFunction == nil then
        error("GuiActions.LinkGuiClickActionNameToFunction called with missing arguments")
    end
    MOD.guiClickActions[actionName] = actionFunction
end

--Called after creating a button or other GuiElement is created to register a specific GUI click action name to it.
GuiActionsClick.RegisterGuiForClick = function(elementName, elementType, actionName, data)
    if elementName == nil or elementType == nil or actionName == nil then
        error("GuiActions.RegisterGuiForClick called with missing arguments")
    end
    local name = GuiUtil.GenerateName(elementName, elementType)
    global.UTILITYGUIACTIONSGUICLICK = global.UTILITYGUIACTIONSGUICLICK or {}
    global.UTILITYGUIACTIONSGUICLICK[name] = {actionName = actionName, data = data}
end

--Called when desired to remove a specific button or other GuiElement from triggering its action.
GuiActionsClick.RemoveGuiForClick = function(elementName, elementType)
    if elementName == nil or elementType == nil then
        error("GuiActions.RemoveButtonName called with missing arguments")
    end
    if global.UTILITYGUIACTIONSGUICLICK == nil then
        return
    end
    local name = GuiUtil.GenerateName(elementName, elementType)
    global.UTILITYGUIACTIONSGUICLICK[name] = nil
end

GuiActionsClick._HandleGuiClickAction = function(rawFactorioEventData)
    if global.UTILITYGUIACTIONSGUICLICK == nil then
        return
    end
    local clickedElementName = rawFactorioEventData.element.name
    local guiClickDetails = global.UTILITYGUIACTIONSGUICLICK[clickedElementName]
    if guiClickDetails ~= nil then
        local actionName = guiClickDetails.actionName
        local actionFunction = MOD.guiClickActions[actionName]
        local actionData = {actionName = actionName, playerIndex = rawFactorioEventData.player_index, data = guiClickDetails.data, eventData = rawFactorioEventData}
        if actionFunction == nil then
            error("ERROR: GUI Click Handler - no registered action for name: '" .. tostring(actionName) .. "'")
            return
        end
        actionFunction(actionData)
    else
        return
    end
end

return GuiActionsClick
