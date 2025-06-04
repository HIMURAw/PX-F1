shared_script '@PX-PvP/shared_fg-obfuscated.lua'
shared_script '@PX-PvP/ai_module_fg-obfuscated.lua'
fx_version 'cerulean'
dependencies 'PX-Gun-Base'
games { 'gta5' }
author 'HIMURA'
description 'discord.gg/pixeldev'

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js',
    'html/pxlogo.png'
}

client_scripts {
    'client.lua'
}

shared_script 'config.lua'
