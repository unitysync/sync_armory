local mainOptions = {}
local weaponOptions = {}
local shopOptions = {}
local armorOptions = {}

---@param title string
---@param text string
---@param type string
local function notify(title, text, type)
    lib.notify({
        title = title,
        description = text,
        type = type
    })
end

---@param type string
local function openArmory(type)
    if Config.Password[type] then
        local input = lib.inputDialog(Lang('armory_name'), {
            {
                type = 'input',
                label = 'Password',
                password = true,
                required = true,
            }
        })
        if not input then return end
        if input[1] == Config.Password[type] then
            lib.showContext('sync_armory:' .. type)
        else
            notify(Lang('armory'), Lang('incorrect_password'), 'error')
        end
    else
        lib.showContext('sync_armory:' .. type)
    end
end

---@param data table
local function getWeapon(data)
    lib.registerContext({
        id = 'sync_armory:addWeapons',
        title = Lang('armory_name'),
        menu = 'sync_armory:weapons',
        options = {
            {
                title = 'Add Weapon',
                description = 'All actions in the armory are logged. Ensure you are authorised to do this.',
                icon = 'plus',
                onSelect = function()
                    TriggerServerEvent('sync_armory:server:getWeapons', data)
                end
            },
            {
                title = 'Remove Weapon',
                icon = 'minus',
                onSelect = function()
                    TriggerServerEvent('sync_armory:server:removeWeapons', data)
                end
            }
        }
    })
    lib.showContext('sync_armory:addWeapons')
end

---@param data table
local function getItem(data)
    local input = lib.inputDialog('Shop', {
        {
            type = 'number',
            label = 'Amount',
            required = true,
        }
    })
    if not input then return end
    local amount = tonumber(input[1])
    TriggerServerEvent('sync_armory:server:getItems', data.item, amount)
end

---@param amount number
local function setArmor(amount)
    if not amount then return end
    local playerPed = PlayerPedId()
    if amount == 0 then
        lib.progressBar({
            duration = 3000,
            label = 'Removing Armor',
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
    elseif amount <= 50 then
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
    elseif amount < 50 then
        lib.progressBar({
            duration = 3000,
            label = 'Equipping Heavy Armor',
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
    end
    SetPedArmour(playerPed, amount)
end


local function init()
    for type, location in pairs(Config.Locations) do
        for _, v in pairs(location) do
            -- Register Target for Each Location
            exports.ox_target:addBoxZone({
                coords = v.coords,
                size = Config.TargetSize,
                options = {
                    {
                        label = v.label or 'Open Armory',
                        icon = v.icon or 'fa-solid fa-gun',
                        groups = v.job or 'police',
                        onSelect = function()
                            openArmory(type)
                        end
                    }
                }
            })
        end
        -- Only added to main menu if it exists
        if Config.Items[type] then
            mainOptions[type][#mainOptions[type]+1] = {
                title = 'Shop',
                icon = 'basket-shopping',
                menu = 'sync_armory:'..type..':items'
            } 
        end
        if Config.Weapons[type] then
            mainOptions[type][#mainOptions[type]+1] = {
                title = 'Weapons',
                icon = 'gun',
                menu = 'sync_armory:'..type..':weapons'
            }
        end
        if Config.Armor[type] then
            mainOptions[type][#mainOptions[type]+1] = {
                title = 'Armor',
                icon = 'vest',
                menu = 'sync_armory:'..type..':armor'
            }
        end
        lib.registerContext({
            id = 'sync_armory:'..type,
            title = Lang('armory_name'),
            options = mainOptions
        })
    end
    for type, weapons in pairs(Config.Weapons) do
        for _, v in pairs(weapons) do
            weaponOptions[type][#weaponOptions[type] + 1] = {
                title = v.label,
                args = { item = v.item, components = v.components },
                onSelect = getWeapon,
                icon = v.icon or 'gun'
            }
        end
        lib.registerContext({
            id = 'sync_armory:' .. type .. ':weapons',
            menu = 'sync_armory:' .. type,
            title = Lang('armory_name'),
            options = weaponOptions[type],
        })
    end
    for type, items in pairs(Config.Items) do
        for i = 1, #items do
            shopOptions[type][#shopOptions[type] + 1] = {
                title = items[i].label,
                onSelect = getItem,
                args = { item = items[i].item },
                icon = items[i].icon or 'shop'
            }
        end
        lib.registerContext({
            id = 'sync_armory:' .. type .. ':items',
            menu = 'sync_armory:' .. type,
            title = Lang('armory_name'),
            options = shopOptions[type],
        })
    end
    for type, option in pairs(Config.Armor) do
        for _, v in pairs(option) do
            armorOptions[type][#armorOptions[type] + 1] = {
                title = v.label,
                onSelect = setArmor,
                args = { amount = v.armor }
            }
        end
        lib.registerContext({
            id = 'sync_armory:' .. type .. ':armor',
            menu = 'sync_armory:' .. type,
            title = Lang('armory_name'),
            options = {
                {
                    title = option.label,
                    onSelect = setArmor,
                    args = { amount = option.amount }
                },
                {
                    title = 'Remove Vest',
                    onSelect = setArmor,
                    args = { amount = option.amount }
                },
            },
        })
    end
    lib.registerContext({
        id = 'sync_armory:armor',
        menu = 'sync_armory:main',
        title = Lang('armory_name'),
        options = {
            {
                title = 'Load Bearing Vest',
                event = 'sync_armory:setArmor',
                args = { type = 1 }
            },
            {
                title = 'Remove Vest',
                event = 'sync_armory:setArmor',
                args = { type = 'remove' }
            },
        },
    })
end

init()
