lib.versionCheck('unitysync/sync_armory')
CreateThread(function()
    local success, _ = pcall(MySQL.scalar.await, 'SELECT 1 FROM armory')
    if not success then
        MySQL.query('CREATE TABLE `armory` (`owner` TINYTEXT DEFAULT NULL, `armory` TEXT NOT NULL,)')
    end
end)

local ESX = exports.es_extended:getSharedObject()
local inv = exports.ox_inventory
local webhook = 'CHANGE_ME' -- Set to false to disable webhook.

local function sendToDiscord(data)
    if not webhook then return end
    local embed = {
        {
            ['color'] = data.color,
            ['title'] = '**Police Armory**',
            ['description'] = data.message,
            ['footer'] = {
                ['text'] = 'Armory Logs',
            },
        }
    }
    if webhook == 'CHANGE_ME' then
        lib.print.warn('Webhook not set up, please set it up in sv_main.lua')
    else
        PerformHttpRequest(webhook, function(err, text, headers) end, 'POST',
            json.encode({ username = data.name, embeds = embed }), { ['Content-Type'] = 'application/json' })
    end
end

for type, password in pairs(Config.Passwords) do
    if password == 'CHANGE_ME' then
        lib.print.warn(('Password is not set up for type: %s. Please set it up in config.lua'):format(type))
    end
end


RegisterNetEvent('sync_armory:getWeapons', function(data)
    local item = data.item
    local xPlayer = ESX.GetPlayerFromId(source)
    local canCarryItem = inv:CanCarryItem(source, item, 1)
    local itemCount = inv:GetItemCount(source, item)
    if xPlayer.getJob().name == 'police' and itemCount == 0 and canCarryItem then
        sendToDiscord({
            color = 16711680,
            name = 'Armory Logs',
            message = ('**Action:** `Received Item` \n **Character Name:** `%s`\n **Player Name:** `%s`\n **Item:** `%s`\n <t:%s:f>'):format(xPlayer.getName(), GetPlayerName(source), item, os.time())
        })
        for i, weapons in pairs(Config.Weapons) do
            for _, v in pairs(weapons) do
                if item == v.item then -- Only allow defined weapons to be given
                    inv:AddItem(source, item, 1, { components = v.components })
                    break
                end
            end
        end
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
    sendToDiscord({
        color = 16711680,
        name = 'Armory Logs',
        message = ('**Action:** `Removed Weapon` \n **Character Name:** `%s`\n **Player Name:** `%s`\n **Weapon:** `%s`\n <t:%s:f>'):format(xPlayer.getName(), GetPlayerName(source), item, os.time())
    })
    local itemCount = inv:GetItemCount(source, item)
    if itemCount ~= 0 then
        for i, weapons in pairs(Config.Weapons) do
            for _, v in pairs(weapons) do
                if item == v.item then -- Only allow defined items to be removed
                    inv:RemoveItem(source, item, 1)
                    break
                end
            end
        end
    end
end)

RegisterNetEvent('sync_armory:getItems', function(item, count)
    local xPlayer = ESX.GetPlayerFromId(source)
    local canCarryItem = inv:CanCarryItem(source, item, count)
    if xPlayer.getJob().name == 'police' and canCarryItem then
        sendToDiscord({
            color = 16711680,
            name = 'Armory Logs',
            message = ('**Action:** `Received Item` \n **Character Name:** `%s`\n **Player Name:** `%s`\n **Item:** `%s`\n <t:%s:f>'):format(xPlayer.getName(), GetPlayerName(source), item, os.time())
        })
        for type, items in pairs(Config.Items) do
            for i, v in pairs(items) do
                if item == v.item then -- Only allow defined items to be given
                    inv:AddItem(source, item, count)
                    break
                end
            end
        end
    end
end)