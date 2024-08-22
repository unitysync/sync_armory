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
    if Config.Passwords[type] then
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
                    TriggerServerEvent('sync_armory:getWeapons', data)
                    lib.showContext(('sync_armory:%s:weapons'):format(data.type))
                end
            },
            {
                title = 'Remove Weapon',
                icon = 'minus',
                onSelect = function()
                    TriggerServerEvent('sync_armory:removeWeapons', data)
                    lib.showContext(('sync_armory:%s:weapons'):format(data.type))
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
    TriggerServerEvent('sync_armory:getItems', data.item, input[1])
    lib.showContext(('sync_armory:%s:items'):format(data.type))
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
        mainOptions[type] = {}
        local main = mainOptions[type]
        for _, v in pairs(location) do
            if Config.UseTarget then
                -- Register Target for Each Location
                exports.ox_target:addBoxZone({
                    coords = v.coords,
                    size = vector3(2, 2, 2),
                    options = {
                        {
                            label = v.label or 'Open Armory',
                            icon = ('fa-solid fa-%s'):format(v.icon) or 'fa-solid fa-gun',
                            groups = v.job or 'police',
                            onSelect = function()
                                openArmory(type)
                            end
                        }
                    }
                })
            else
                local uiText = ("**Police Armory**  \nPress [E] to %s"):format(v.label or 'Open Armory')
                local point = lib.points.new({
                    coords = v.coords,
                    distance = 20,
                })

                local marker = lib.marker.new({
                    coords = v.coords,
                    type = 1,
                })

                function point:nearby()
                    marker:draw()

                    if self.currentDistance < 2 then
                        if not lib.isTextUIOpen() then
                            lib.showTextUI(uiText, {
                                icon = v.icon or 'gun'
                            })
                        end

                        if IsControlJustPressed(0, 51) then
                            openArmory(type)
                        end
                    else
                        local isOpen, currentText = lib.isTextUIOpen()
                        if isOpen and currentText == uiText then
                            lib.hideTextUI()
                        end
                    end
                end
            end
        end
        -- Only added to main menu if it exists
        if Config.Items[type] then
            main[#main + 1] = {
                title = 'Shop',
                icon = 'basket-shopping',
                menu = ('sync_armory:%s:items'):format(type)
            }
        end
        if Config.Weapons[type] then
            main[#main + 1] = {
                title = 'Weapons',
                icon = 'gun',
                menu = ('sync_armory:%s:weapons'):format(type)
            }
        end
        if Config.Armor[type] then
            main[#main + 1] = {
                title = 'Armor',
                icon = 'vest',
                menu = ('sync_armory:%s:armor'):format(type)
            }
        end
        if Config.Loadouts then
            main[#main + 1] = {
                title = 'Loadouts',
                icon = 'backpack',
                arrow = true,
                onSelect = function()
                    local options = {}
                    local response = lib.callback.await('sync_armory:fetchLoadouts')
                    if not response then
                        options[#options + 1] = {
                            title = 'No Loadouts Found',
                            icon = 'backpack',
                            disabled = true
                        }
                    else
                        for _, loadout in pairs(response) do
                            options[#options + 1] = {
                                title = loadout.name,
                                onSelect = function()
                                    TriggerServerEvent('sync_armory:getLoadout', loadout.loadoutId)
                                end,
                                icon = 'backpack',
                            }
                        end
                    end
                    options[#options + 1] = {
                        title = 'Create Loadout',
                        icon = 'plus',
                        onSelect = function()
                            local rows = {}
                            rows[1] = {
                                type = 'input',
                                label = 'Name',
                                required = true,
                            }
                            local selection = {}
                            for _, weapon in pairs(Config.Weapons[type]) do
                                selection[#selection + 1] ={
                                    label = weapon.label,
                                    value = weapon.item,
                                }
                            end
                            rows[2] = {
                                type = 'multi-select',
                                label = 'Select Weapons',
                                icon = 'gun',
                                required = true,
                                options = selection
                            }
                            local input = lib.inputDialog('Create Loadout', rows)
                            if not input then return end
                            local weapons = {}
                            local selectedWeapons = input[2]
                            ---@diagnostic disable-next-line: param-type-mismatch
                            for _, weapon in pairs(selectedWeapons) do
                                weapons[#weapons + 1] = weapon
                            end
                            TriggerServerEvent('sync_armory:registerLoadout', {
                                name = input[1],
                                weapons = weapons
                            })
                        end
                    }
                    lib.registerContext({
                        id = 'sync_armory:loadouts',
                        title = Lang('armory_name'),
                        menu = ('sync_armory:%s:main'):format(type),
                        options = options
                    })
                    lib.showContext('sync_armory:loadouts')
                end,
            }
        end
        lib.registerContext({
            id = ('sync_armory:%s'):format(type),
            title = Lang('armory_name'),
            options = main
        })
    end
    for type, weapons in pairs(Config.Weapons) do
        for _, v in pairs(weapons) do
            weaponOptions[type] = {}
            local weapon = weaponOptions[type]
            weapon[#weapon + 1] = {
                title = v.label,
                args = { item = v.item, components = v.components, type = type },
                onSelect = getWeapon,
                icon = v.icon or 'gun'
            }
        end
        lib.registerContext({
            id = ('sync_armory:%s:weapons'):format(type),
            menu = ('sync_armory:%s'):format(type),
            title = Lang('armory_name'),
            options = weaponOptions[type],
        })
    end
    for type, items in pairs(Config.Items) do
        shopOptions[type] = {}
        local shop = shopOptions[type]
        for i = 1, #items do
            shop[#shop + 1] = {
                title = items[i].label,
                onSelect = getItem,
                args = { item = items[i].item, type = type },
                icon = items[i].icon or 'shop'
            }
        end
        lib.registerContext({
            id = ('sync_armory:%s:items'):format(type),
            menu = ('sync_armory:%s'):format(type),
            title = Lang('armory_name'),
            options = shop,
        })
    end
    for type, option in pairs(Config.Armor) do
        armorOptions[type] = {}
        local armor = armorOptions[type]
        for _, v in pairs(option) do
            armor[#armor + 1] = {
                title = v.label,
                onSelect = setArmor,
                args = { amount = v.armor },
                icon = v.icon or 'vest'
            }
        end
        armor[#armor + 1] = {
            title = 'Remove Vest',
            onSelect = setArmor,
            args = { amount = 0 },
            icon = 'vest'
        }
        lib.registerContext({
            id = ('sync_armory:%s:armor'):format(type),
            menu = ('sync_armory:'):format(type),
            title = Lang('armory_name'),
            options = armor
        })
    end
end

init()
