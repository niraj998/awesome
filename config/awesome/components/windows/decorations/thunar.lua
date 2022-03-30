local awful = require("awful")
local helpers = require("components.helpers")
local watch = require("awful.widget.watch")
local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")
local ruled = require("ruled")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local home = os.getenv("HOME")


local textbuttons = function(color, text, font, onclick)
    local textbutton = wibox.widget {
        font = font,
        align = "center",
        valign = "center",
        markup = "<span foreground='"..color.."'>"..text.."</span>",
        widget = wibox.widget.textbox  }
    if onclick ~= nil then
        textbutton:connect_signal("button::press", onclick)
    end
    return textbutton
end

local shortcuts = function(c, icon, location)
  local shortcut = textbuttons(beautiful.blue, icon, "FiraMono Nerd Font 25", function()
        awful.spawn.with_shell("xdotool key ctrl+l; xdotool type --delay 0 "..location.."; xdotool key Return;")
    end)
    shortcut.forced_width = dpi(32)
    shortcut.forced_height = dpi(32)
    return shortcut
end

local actions = function(c, icon, keys)
  local shortcut = textbuttons(beautiful.blue, icon, "FiraMono Nerd Font 25", function()
        awful.spawn.with_shell("xdotool key " .. keys .."; ")
    end)
    shortcut.forced_width = dpi(32)
    shortcut.forced_height = dpi(32)
    return shortcut
end

local thunarbar = function (c)

  awful.titlebar(c, { position = "left",  size = dpi(40)  }):setup {
   {
     {
       {
         awful.titlebar.widget.closebutton(c),
         spacing = dpi(3),
         layout = wibox.layout.fixed.vertical
       },
       top = dpi(6),
       left = dpi(7),
       right = dpi(7),
       bottom = dpi(30),
       widget = wibox.container.margin
     },
          actions(c, "", "ctrl+shift+n"),
       {
           bg = beautiful.grey,
           forced_height = dpi(1),
           widget = wibox.container.background
       },
          shortcuts(c, "", home),
          shortcuts(c, "", home .. "/media/Pictures"),
          shortcuts(c, "", home .. "/media/Music"),
          shortcuts(c, "", home .. "/media/Videos"),
	  shortcuts(c, "", home .. "/media/Downloads"),
          shortcuts(c, "", home .. "/media/Documents"),
          shortcuts(c, "", home .. "/media"),
     	  shortcuts(c, "", "/mnt"),
          shortcuts(c, "ﲎ", home .. "/Cell"),
	  spacing = dpi(5),
          layout = wibox.layout.fixed.vertical
     },
       top = dpi(6),
       left = dpi(2),
       right = dpi(2),
       widget = wibox.container.margin
  }
end

ruled.client.connect_signal("request::rules", function()
    ruled.client.append_rule {
        id = "thunar",
        rule = {instance = "thunar"},
        callback = thunarbar
    }
end)
