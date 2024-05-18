CreateThread(function()
    RegisterTarget()
    RegisterMainContext()
    RegisterSubMenus()
    RegisterSwatMenus()
end)

AddEventHandler('sync_armory:OpenArmory', function()
    lib.showContext('sync_armory:main')
end)

AddEventHandler('sync_armory:OpenSwatArmory', function()
    local input = lib.inputDialog(Lang('swat_armory_name'), {
        {
            type = 'input',
            label = 'Password',
            password = true,
            required = true,
        }
    })
    if input[1] == Config.Password then
        lib.showContext('sync_armory:swat')
    else
        Notify(Lang('armory'), Lang('incorrect_password'), 'error')
    end
end)

AddEventHandler('sync_armory:cl_getWeapons', function(data)
    local item = data.item
    lib.registerContext({
        id = "sync_armory:addWeapons",
        title = Lang('armory_name'),
        menu = "sync_armory:weapons",
        options = {
            {
                title = "Add Weapon",
                icon = 'plus',
                onSelect = function()
                    TriggerServerEvent('sync_armory:sv_getWeapons', item)
                end
            },
            {
                title = "Remove Weapon",
                icon = 'minus',
                onSelect = function()
                    TriggerServerEvent('sync_armory:removeWeapons', item)
                end
            }
        }
    })
    lib.showContext('sync_armory:addWeapons')
end)

AddEventHandler('sync_armory:cl_getItems', function(data)
    local item = data.item
    local input = lib.inputDialog('Shop', {
        {
            type = 'number',
            label = 'Amount',
            required = true,
        }
    })
    if not input then return end
    local amount = tonumber(input[1])
    TriggerServerEvent('sync_armory:sv_getItems', item, amount)
end)

AddEventHandler('sync_armory:setArmor', function(data)
    local playerPed = PlayerPedId()
    if data.type == "remove" then
        lib.progressBar({
            duration = 3000,
            label = 'Remove Armor',
            position = 'bottom',
            useWhileDead = false,
            canCancel = false,
            disable = {
                car = true,
            },
            anim = {
                dict = 'clothingtie',
                clip = 'try_tie_negative_a'
            }
        })
        SetPedArmour(playerPed, 0)
    elseif data.type == 1 then
        lib.progressBar({
            duration = 3000,
            label = 'Equipping Armor',
            position = 'bottom',
            useWhileDead = false,
            canCancel = false,
            disable = {
                car = true,
            },
            anim = {
                dict = 'clothingtie',
                clip = 'try_tie_negative_a'
            }
        })
        SetPedArmour(playerPed, 50)
    elseif data.type == 2 then
        lib.progressBar({
            duration = 3000,
            label = 'Equipping Armor',
            position = 'bottom',
            useWhileDead = false,
            canCancel = false,
            disable = {
                car = true,
            },
            anim = {
                dict = 'clothingtie',
                clip = 'try_tie_negative_a'
            }
        })
        SetPedArmour(playerPed, 100)
    end
end)
