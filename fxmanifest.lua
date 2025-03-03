fx_version 'cerulean'
game 'gta5'

author 'sync'
description 'Armory script using ox_lib'
version '1.1.2'

lua54 'yes'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
    'locales.lua'
}

client_script 'client.lua'
server_script 'server.lua'


dependencies {
    'ox_lib',
    'ox_inventory',
    'es_extended'
}
