local currVersion = GetResourceMetadata(GetCurrentResourceName(), 'version', 0)
local ESX = exports.es_extended:getSharedObject()
local inv = exports.ox_inventory
local webhook = 'CHANGE_ME' -- Set to false to disable webhook.

local function debugPrint(text)
    if Config.Debug then
    print('[^2INFO^7] ' .. text)
    end
end

local function sendToDiscord(color, name, message)
    if not webhook then return end
    local embed = {
        {
            ['color'] = color,
            ['title'] = '**Police Armory**',
            ['description'] = message,
            ['footer'] = {
                ['text'] = 'Armory Logs',
            },
        }
    }
    if webhook == 'CHANGE_ME' then
        debugPrint('Webhook not set up, please set it up in sv_main.lua')
    else
        PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({ username = name, embeds = embed }), { ['Content-Type'] = 'application/json' })
    end
end

debugPrint('sync_armory has loaded')
debugPrint('Current Version: ' .. currVersion)

for type, password in pairs(Config.Passwords) do
    if password == 'CHANGE_ME' then
        debugPrint(('Password is not set up for type: %s. Please set it up in config.lua'):format(type))
    end
end


RegisterNetEvent('sync_armory:server:getWeapons', function(data)
    local item, components = data.item, data.components
    local xPlayer = ESX.GetPlayerFromId(source)
    local canCarryItem = inv:CanCarryItem(source, item, 1)
    local itemCount = inv:GetItemCount(source, item)
    if xPlayer.getJob().name == 'police' and itemCount == 0 and canCarryItem then
        sendToDiscord(16711680, 'Armory Logs', '**Action:** `Received Item` \n **Character Name:** `' .. xPlayer.getName() .. '`\n **Player Name:** `' .. GetPlayerName(source) .. '`\n **Item:** `' .. item .. '`\n <t:' .. os.time() .. ':f>')
        inv:AddItem(source, item, 1, {components = components})
    elseif xPlayer.getJob().name == 'police' and itemCount > 0 then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Police Armory',
            description = 'You can only carry 1 of each weapon.',
            type = 'error'
        })
    end
end)

RegisterNetEvent('sync_armory:removeWeapons', function(item)
    local xPlayer = ESX.GetPlayerFromId(source)
    sendToDiscord(16711680, 'Armory Logs', '**Action:** `Received Item` \n **Character Name:**`' .. xPlayer.getName() .. '`\n **Player Name:** `' .. GetPlayerName(source) .. '`\n **Item:** `' .. item .. '`\n **Count:** `' .. count .. '`\n <t:' .. os.time() .. ':f>')
    local itemCount = inv:GetItemCount(source, item)
    if itemCount ~= 0 then
        inv:RemoveItem(source, item, 1)
    end
end)

RegisterNetEvent('sync_armory:server:getItems', function(item, count)
    local xPlayer = ESX.GetPlayerFromId(source)
    local canCarryItem = inv:CanCarryItem(source, item, count)
    if xPlayer.getJob().name == 'police' and canCarryItem then
        sendToDiscord(16711680, 'Armory Logs', '**Action:** `Received Item` \n **Character Name:**`' .. xPlayer.getName() .. '`\n **Player Name:** `' .. GetPlayerName(source) .. '`\n **Item:** `' .. item .. '`\n **Count:** `' .. count .. '`\n <t:' .. os.time() .. ':f>')
        inv:AddItem(source, item, count)
    end
end)

