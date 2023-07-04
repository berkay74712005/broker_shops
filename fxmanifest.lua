fx_version 'adamant'

game 'gta5'

author 'broker'
name 'BROKER-SHOPS'

description 'broker shops v1'

version '1.0'

ui_page 'html/index.html'

shared_scripts {
    'cfg.lua',
}

server_script {
    'server.lua',
}

client_scripts {
	'client.lua',
}

files {
    'html/index.html',
    'html/assets/items/*',
    'html/assets/*',
}