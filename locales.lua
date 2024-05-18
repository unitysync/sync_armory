Locales = {
    ['en'] = {
        ['armory_name'] = 'Police Armory',
        ['add_weapon'] = 'Add Weapon',
        ['remove_weapon'] = 'Remove Weapon',
        ['open_armory'] = 'Open Armory',
        ['open_swat_armory'] = 'Open SWAT Armory',
        ['armory'] = 'Armory',
        ['incorrect_password'] = 'Incorrect Password',

    },
}

function Lang(locale)
    if Locales[Config.Language][locale] then
        return Locales[Config.Language][locale]
    else
        print('Locale Invalid (' .. locale .. ')')
    end
end