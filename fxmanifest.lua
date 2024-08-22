fx_version 'cerulean'
game 'gta5'

author 'sync'
description 'Armory script using ox_lib'
version '1.0.3'

lua54 'yes'

client_script 'client.lua'
server_scripts 'server.lua'


shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
    'locales.lua'
}

dependencies {
    'ox_lib',
    'ox_inventory',
    'es_extended'
}

