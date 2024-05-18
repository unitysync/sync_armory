local weaponOptions = {}
local shopOptions = {}
local swatShopOptions = {}
local swatWeaponOptions = {}


function RegisterTarget()
    for i = 1, #Config.Locations.Main do
        exports.ox_target:addBoxZone({
            coords = Config.Locations.Main[i],
            size = Config.TargetSize,
            options = {
                {
                    label = Lang('open_armory'),
                    event = 'sync_armory:OpenArmory',
                    icon = "fa-solid fa-gun",
                    groups = 'police'
                }
            }
        })
    end
    for i = 1, #Config.Locations.Swat do
        exports.ox_target:addBoxZone({
            coords = Config.Locations.Swat[i],
            size = Config.TargetSize,
            options = {
                {
                    label = Lang('open_swat_armory'),
                    event = 'sync_armory:OpenSwatArmory',
                    icon = "fa-solid fa-person-rifle",
                    groups = 'police'
                }
            }
        })
    end
end

function RegisterMainContext()
    lib.registerContext({
        id = "sync_armory:main",
        title = Lang('armory_name'),
        options = {
            {
                title = "Weapons",
                icon = "gun",
                menu = "sync_armory:weapons",
            },
            {
                title = "Armor",
                icon = "vest",
                menu = "sync_armory:armor"
            },
            {
                title = "Shop",
                icon = "basket-shopping",
                menu = 'sync_armory:shop'
            },
        }
    })
    lib.registerContext({
        id = "sync_armory:swat",
        title = Lang('swat_armory_name'),
        options = {
            {
                title = "Weapons",
                icon = "gun",
                menu = "sync_armory:swatWeapons",
            },
            {
                title = "Armor",
                icon = "vest",
                menu = "sync_armory:swatArmor"
            },
            {
                title = "Shop",
                icon = "basket-shopping",
                menu = 'sync_armory:swatShop'
            },
        }
    })
end

function RegisterSubMenus()
    for i = 1, #Config.Weapons.Main do
        weaponOptions[#weaponOptions+1] = {
            title = Config.Weapons.Main[i].label,
            event = "sync_armory:cl_getWeapons",
            args = { item = Config.Weapons.Main[i].item},
            icon = Config.Weapons.Main[i].icon or 'gun'
        }
    end
    lib.registerContext({
        id = "sync_armory:weapons",
        menu = "sync_armory:main",
        title = Lang('armory_name'),
        options = weaponOptions,
    })
    for i = 1, #Config.Items.Main do
        shopOptions[#shopOptions+1] = {
            title = Config.Items.Main[i].label,
            event = "sync_armory:cl_getItems",
            args = { item = Config.Items.Main[i].item},
            icon = Config.Items.Main[i].icon or 'shop'
        }
    end
    lib.registerContext({
        id = "sync_armory:shop",
        menu = "sync_armory:main",
        title = Lang('armory_name'),
        options = shopOptions,
    })
    lib.registerContext({
        id = "sync_armory:armor",
        menu = "sync_armory:main",
        title = Lang('armory_name'),
        options = {
            {
                title = "Load Bearing Vest",
                event = "sync_armory:setArmor",
                args = { type = 1 }
            },
            {
                title = "Remove Vest",
                event = "sync_armory:setArmor",
                args = { type = "remove"}
            },
        },
    })
end

function RegisterSwatMenus()
    for i = 1, #Config.Weapons.Swat do
        swatWeaponOptions[#swatWeaponOptions+1] ={
            title = Config.Weapons.Swat[i].label,
            event = "sync_armory:cl_getWeapons",
            icon = Config.Weapons.Swat[i].icon or 'gun',
            args = { item = Config.Weapons.Swat[i].item}
        }
    end
    lib.registerContext({
        id = "sync_armory:swatWeapons",
        menu = "sync_armory:swat",
        title = Lang('swat_armory_name'),
        options = swatWeaponOptions,
    })
    for i = 1, #Config.Items.Swat do
        swatShopOptions[#swatShopOptions+1] = {
            title = Config.Items.Swat[i].label,
            event = "sync_armory:cl_getItems",
            icon = Config.Items.Swat[i].icon or 'shop',
            args = { item = Config.Items.Swat[i].item}
        }
    end
    lib.registerContext({
        id = "sync_armory:swatShop",
        menu = "sync_armory:swat",
        title = Lang('swat_armory_name'),
        options = swatShopOptions,
    })
    lib.registerContext({
        id = "sync_armory:swatArmor",
        menu = "sync_armory:swat",
        title = Lang('swat_armory_name'),
        options = {
            {
                title = "Ballistic Plate Carrier Vest",
                event = "sync_armory:setArmor",
                args = { type = 2 }
            },
            {
                title = "Load Bearing Vest",
                event = "sync_armory:setArmor",
                args = { type = 1 }
            },
            {
                title = "Remove Vest",
                event = "sync_armory:setArmor",
                args = { type = "remove"}
            },
        },
    })
end

function Notify(title, text, type)
    lib.notify({
        title = title,
        description = text,
        type = type
    })
end