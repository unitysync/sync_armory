local currVersion = GetResourceMetadata(GetCurrentResourceName(), 'version', 0)
local webhook = 'CHANGE_ME'

DebugPrint("sync_armory has loaded")
DebugPrint("Current Version: " .. currVersion)

RegisterNetEvent('sync_armory:sv_getWeapons')
AddEventHandler('sync_armory:sv_getWeapons', function(item)
    local xPlayer = ESX.GetPlayerFromId(source)
    local canCarryItem = exports.ox_inventory:CanCarryItem(source, item, 1)
    local itemCount = exports.ox_inventory:GetItemCount(source, item)
    if xPlayer.getJob().name == "police" and itemCount == 0 and canCarryItem then
        sendToDiscord(16711680, 'Armory Logs', "**Action:** `Received Item` \n **Character Name:** `" .. xPlayer.getName() .. "`\n **Player Name:** `" .. GetPlayerName(source) .. "`\n **Item:** `" .. item .. '`\n <t:' .. os.time() .. ':f>')
        exports.ox_inventory:AddItem(source, item, 1)
    elseif xPlayer.getJob().name == "police" and itemCount > 0 then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Police Armory',
            description = 'You can only carry 1 of each weapon',
            type = 'error'
        })
    end
end)

RegisterNetEvent('sync_armory:removeWeapons')
AddEventHandler('sync_armory:removeWeapons', function(item)
    local xPlayer = ESX.GetPlayerFromId(source)
    sendToDiscord(16711680, 'Armory Logs', "**Action:** `Received Item` \n **Character Name:**`" .. xPlayer.getName() .. "`\n **Player Name:** `" .. GetPlayerName(source) .. "`\n **Item:** `" .. item .. "`\n **Count:** `" .. count .. '`\n <t:' .. os.time() .. ':f>')
    local itemCount = exports.ox_inventory:GetItemCount(source, item)
    if itemCount ~= 0 then
        exports.ox_inventory:RemoveItem(source, item, 1)
    end
end)

RegisterNetEvent('sync_armory:sv_getItems')
AddEventHandler('sync_armory:sv_getItems', function(item, count)
    local xPlayer = ESX.GetPlayerFromId(source)
    local canCarryItem = exports.ox_inventory:CanCarryItem(source, item, count)
    if xPlayer.getJob().name == "police" and canCarryItem then
        sendToDiscord(16711680, 'Armory Logs', "**Action:** `Received Item` \n **Character Name:**`" .. xPlayer.getName() .. "`\n **Player Name:** `" .. GetPlayerName(source) .. "`\n **Item:** `" .. item .. "`\n **Count:** `" .. count .. '`\n <t:' .. os.time() .. ':f>')
        exports.ox_inventory:AddItem(source, item, count)
    end
end)

function DebugPrint(text)
    print("[^2INFO^7] " .. text)
end

function sendToDiscord(color, name, message)
    local embed = {
        {
            ["color"] = color,
            ["title"] = "**Police Armory**",
            ["description"] = message,
            ["footer"] = {
                ["text"] = 'QPS Armory Logs',
            },
        }
    }
    if webhook == 'CHANGE_ME' then
        DebugPrint('Webhook not set up, please set it up in sv_main.lua')
    else
        PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({ username = name, embeds = embed }), { ['Content-Type'] = 'application/json' })
    end
end
