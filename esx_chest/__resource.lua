
--###################################
--## ESX_CHEST By MaXxaM#0511 ####
--###################################
resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'esx_chest By MaXxaM#0511'

client_scripts {
	'@es_extended/locale.lua',
	'locales/it.lua',
	'config.lua',
	'client.lua'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'locales/it.lua',
	'config.lua',
	'server.lua'
}

dependencies {
	'es_extended'
}
