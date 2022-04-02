pcall(require, "luarocks.loader")
local awful = require("awful")
require("awful.autofocus")
local beautiful = require("beautiful")
local getfs = require("gears.filesystem")

--[[ rc.lua binds entire configurations together.

file structure of whole configurations are as follows:

1. assets folder has wallpapers, icons, picom and rofi configurations.
2. config folder has all the necessary configurations. you might want to change. like what packages you use, keyboard shortcuts, wallpapers, startup programs.
3. components folder has all of the components of configs, like notifications, bar, menu, windows management, etc.
4. theme folder contains all colors, theming, etc.
5. if you want to know more just read init.lua file inside of any of these folders/subfolders.
]]--


-- all commands in awesome config will run in this shell
-- awful.util.shell = 'dash'
awful.util.shell = 'sh'

-- Import theme
beautiful.init(getfs.get_configuration_dir() .. "theme/theme.lua")

-- Set Wallpapers
-- just add your wallpaper directory inside wallpaper.lua, to use your own wallpapers.
require("config.wallpaper")

-- notifications
require("components.notify")

-- notification center
require("components.notify.center")

-- lockscreen, password is awesome. you can change that in the lockscreen.lua file
require("components.lockscreen")

-- exitscreen
require("components.exitscreen")

-- topbar
require("components.bar")

-- menu
require("components.menu")

--[[ keyboard shortcuts.
Super+Enter 	Terminal
Super+q 	kill Client
Super+F1	All Hotkeys
Super+r		rofi
]]--
require('config.keys')

-- windows/rules/clients managements, titlebars.. etc.
require("components.windows")

-- startup profgrams. add your startup programs in startup script.
awful.spawn.with_shell(getfs.get_configuration_dir() .. "config/startup")


-- Collect Garbage
collectgarbage("setpause", 110)
collectgarbage("setstepmul", 1000)
