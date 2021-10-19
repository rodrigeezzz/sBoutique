fx_version 'cerulean'
games { 'rdr3', 'gta5' }

author 'RageUI'
description 'RageUI'
version '1.0.0'

--RAGEUI
client_scripts {
    "dependencies/RageUI/RMenu.lua",
    "dependencies/RageUI/menu/RageUI.lua",
    "dependencies/RageUI/menu/Menu.lua",
    "dependencies/RageUI/menu/MenuController.lua",
    "dependencies/RageUI/components/*.lua",
    "dependencies/RageUI/menu/elements/*.lua",
    "dependencies/RageUI/menu/items/*.lua",
    "dependencies/RageUI/menu/panels/*.lua",
    "dependencies/RageUI/menu/windows/*.lua"
}


-- Authentic clients side
client_scripts {
    'authentic/events/admin/CAdmin.lua',
    'authentic/events/cb/client.lua',
    'authentic/events/helpers/Helper.lua',
    'authentic/events/helpers/CHelper.lua',
    'authentic/events/level/CLevel.lua',
    'authentic/events/logs/SLogs.Lua',
    'authentic/events/tebex/CAnim.lua',
    'authentic/events/tebex/CCase.lua',
    'authentic/events/tebex/CPolice.lua',
    'authentic/events/tebex/CTebex.lua',
    'authentic/events/tebex/CWeapon.lua',
}

-- notify

server_script "r_notif/farees_sv.lua"


-- Authentic server side
server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'dependencies/LiteMySQL.lua',
    'authentic/events/logs/SLogs.lua',
    'authentic/events/cb/server.lua',
    'authentic/events/admin/SAdmin.lua',
    'authentic/events/level/SLevel.lua',
    'authentic/events/tebex/STebex.lua',
    'authentic/events/tebex/SPolice.lua',
    'authentic/events/tebex/SWeapon.lua',
    'authentic/events/tebex/Ctwt.lua'
}