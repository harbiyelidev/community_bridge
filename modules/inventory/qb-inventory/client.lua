if GetResourceState('qb-inventory') ~= 'started' then return end

local qb = exports['qb-inventory']

Inventory = Inventory or {}

RegisterNetEvent('community_bridge:client:qb-inventory:openStash', function(id, data)
    if source ~= 65535 then return end
    TriggerEvent("inventory:client:SetCurrentStash", id)
    TriggerServerEvent('inventory:server:OpenInventory', 'stash', id, { maxweight = data.weight, slots = data.slots })
end)

---This will return a boolean if the player has the item in their inventory
---@param item string
---@return boolean
Inventory.HasItem = function(item)
    return qb:HasItem(item)
end

---This will return a string of the image path for the item
---@param item string
---@return string
Inventory.GetImagePath = function(item)
    item = Inventory.StripPNG(item)
    local file = LoadResourceFile("qb-inventory", string.format("html/images/%s.png", item))
    local imagePath = file and string.format("nui://qb-inventory/html/images/%s.png", item)
    return imagePath or "https://avatars.githubusercontent.com/u/47620135"
end

Inventory.GetItemInfo = function(item)
    local itemData = Framework.Shared.Items[item]
    if not itemData then return {} end
    local repackedTable = {
        name = itemData.name,
        label = itemData.label,
        stack = itemData.unique,
        weight = itemData.weight,
        description = itemData.description,
        image = Inventory.GetImagePath(itemData.image or itemData.name)
    }
    return repackedTable
end

