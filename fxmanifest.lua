fx_version 'cerulean'
game 'gta5'

author 'sync'
description 'Armory script using ox_lib'
version '1.0.0'

lua54 'yes'

client_scripts {
    'client/*.lua',
}

shared_scripts {
    '@ox_lib/init.lua',
    '@es_extended/imports.lua',
    'config.lua',
    'locales.lua'
}

server_scripts {
    'server/*.lua'
}
dependencies {
    'ox_lib',
    'ox_inventory',
    'es_extended'
}

