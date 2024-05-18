Config = {}
Config.Language = 'en' -- Setup more languages in locales.lua

-- Item Table
Config.Items = {
    Main = {
        { item = 'ammo-9', label = '9mm Ammo', icon = 'nui://ox_inventory/web/images/ammo-9.png' },
    },
    Swat = {
        { item = 'ammo-rifle',    label = '5.56x45mm',                    icon = 'nui://ox_inventory/web/images/ammo-rifle.png' },
        { name = 'at_flashlight', label = 'Tactical Flashlight',          icon = 'nui://ox_inventory/web/images/at_flashlight.png' },
        { name = 'bodyarmor_3',   label = 'Ballistic Plate Carrier Vest', icon = 'nui://ox_inventory/web/images/bodyarmor_3.png' },
        { name = 'ammo-9',        label = '9mm Ammo',                     icon = 'nui://ox_inventory/web/images/ammo-9.png' },
    }
}

-- Weapon Table
Config.Weapons = {
    Main = {
        { item = 'weapon_combatpistol', label = 'Combat Pistol', icon = 'nui://ox_inventory/web/images/weapon_combatpistol.png' },
        { item = 'weapon_stungun',      label = 'TASER',         icon = 'nui://ox_inventory/web/images/weapon_stungun.png' },
        { item = 'weapon_nightstick',   label = 'Baton',         icon = 'nui://ox_inventory/web/images/weapon_nightstick.png' },
        { item = 'weapon_flashlight',   label = 'Flashlight',    icon = 'nui://ox_inventory/web/images/weapon_flashlight.png' },
    },
    Swat = {
        { item = 'WEAPON_CARBINERIFLE', label = 'Carbine Rifle', icon = 'nui://ox_inventory/web/images/WEAPON_CARBINERIFLE.png' },
    }
}

Config.Password = 'CHANGE_ME'
Config.TargetSize = vector3(2, 2, 2)
Config.Locations = {
    Swat = {
        vec3(441.991, -988.187, 34.298), -- MRPD SWAT | CHANGE AND ADD MORE LOCATIONS
    },
    Main = {
        vec3(437.440, -983.365, 34.087), -- MRPD MAIN | CHANGE AND ADD MORE LOCATIONS
    },
}

Config.Webhook = 'CHANGE_ME'
