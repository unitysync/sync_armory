Config = {}
Config.Language = 'en' -- Setup more languages in locales.lua
Config.Debug = false -- Set to true to enable debug messages

-- Item Table
Config.Items = {
    ['main'] = {
        { item = 'ammo-9', label = '9mm Ammo', icon = 'nui://ox_inventory/web/images/ammo-9.png' },
    },
    ['swat'] = {
        { item = 'ammo-rifle',    label = '5.56x45mm',                    icon = 'nui://ox_inventory/web/images/ammo-rifle.png' },
        { name = 'at_flashlight', label = 'Tactical Flashlight',          icon = 'nui://ox_inventory/web/images/at_flashlight.png' },
        { name = 'bodyarmor_3',   label = 'Ballistic Plate Carrier Vest', icon = 'nui://ox_inventory/web/images/bodyarmor_3.png' },
        { name = 'ammo-9',        label = '9mm Ammo',                     icon = 'nui://ox_inventory/web/images/ammo-9.png' },
    }
}

-- Weapon Table
Config.Weapons = {
    ['main'] = {
        { item = 'weapon_combatpistol', label = 'Combat Pistol', icon = 'nui://ox_inventory/web/images/weapon_combatpistol.png' },
        { item = 'weapon_stungun',      label = 'TASER',         icon = 'nui://ox_inventory/web/images/weapon_stungun.png' },
        { item = 'weapon_nightstick',   label = 'Baton',         icon = 'nui://ox_inventory/web/images/weapon_nightstick.png' },
        { item = 'weapon_flashlight',   label = 'Flashlight',    icon = 'nui://ox_inventory/web/images/weapon_flashlight.png' },
    },
    ['swat'] = {
        { item = 'weapon_carbinerifle', label = 'Carbine Rifle', icon = 'nui://ox_inventory/web/images/WEAPON_CARBINERIFLE.png' },
    }
}

Config.Armor = {
    ['main'] = {
        { armor = 50, label = 'Stab Proof Vest', icon = 'nui://ox_inventory/web/images/bodyarmor_1.png' },
    },
    ['swat'] = {
        { armor = 100, label = 'Ballistic Plate Carrier Vest', icon = 'nui://ox_inventory/web/images/bodyarmor_3.png' },
    }
}

Config.Passwords = {
    ['swat'] = 'CHANGE_ME', -- SWAT PASSWORD
}
Config.UseTarget = true -- Set to false to use markers
Config.Locations = {
    ['main'] = {
        { coords = vec3(437.440, -983.365, 34.087), icon = 'gun', job = 'police', label = 'Open Armory' }, -- MRPD MAIN | CHANGE AND ADD MORE LOCATIONS
    },
    ['swat'] = {
        { coords = vec3(441.991, -988.187, 34.298), icon = 'person-rifle', job = 'police', label = 'Open SWAT Armory'}, -- MRPD SWAT | CHANGE AND ADD MORE LOCATIONS
    },
}
