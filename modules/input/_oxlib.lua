local resourceName = "ox_lib"
local configValue = BridgeClientConfig.InputSystem
if (configValue == "auto" and GetResourceState(resourceName) ~= "started") or (configValue ~= "auto" and configValue ~= resourceName) then return end

function QBTypeToOxType(_type)
    if _type == "text" then
        return "input"
    elseif _type == "password" then
        return "input"
    elseif _type == "number" then
        return "number"
    elseif _type == "radio" then
        return "checkbox"
    elseif _type == "checkbox" then
        return "checkbox"
    elseif _type == "select" then
        return "select"
    end
end

function QBToOxInput(data)
    local returnData = {}
    for i, v in pairs(data) do
        local input = {
            label = v.text,
            name = i,
            type = QBTypeToOxType(v.type),
            required = v.isRequired,
            default = v.placeholder,
        }
        if v.type == "select" then
            input.options = {}
            for i, v in pairs(v.options) do
                table.insert(input.options, {value = v.value, label = v.text})
            end
        elseif v.type == "checkbox" then
            for i, v in pairs(v.options) do
                table.insert(returnData, {value = v.value, label = v.text})
            end
        end
        table.insert(returnData, input)
    end
    return returnData
end

function OpenInput(title, data, isQBFormat, submitText)
    local inputs = data.inputs
    if isQBFormat then
        return lib.inputDialog(title, QBToOxInput(inputs))
    else
        return lib.inputDialog(title, data)
    end
end