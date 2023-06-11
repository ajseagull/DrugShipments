fx_version 'cerulean'
games { 'gta5' }

author 'Coevect'
description 'Drug Shipments'
version '1.0.0'

-- What to run
client_scripts {
    '@PolyZone/client.lua',
    '@PolyZone/CircleZone.lua',
    'client.lua'
}

shared_script 'config.lua'

server_script 'server.lua'