local awful = require('awful')
local gears = require('gears')
local wibox = require('wibox')
local beautiful = require('beautiful')
require("config.keys")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi


--|t|i|t|l|e|b|a|r|--
--+-+-+-+-+-+-+-+-+--
awful.titlebar.enable_tooltip = true
client.connect_signal("request::titlebars", function(c)
   local buttons = {
       awful.button({ }, 1, function()
           c:activate { context = "titlebar", action = "mouse_move"  }
   end),
       awful.button({ }, 3, function()
           c:activate { context = "titlebar", action = "mouse_resize"}
   end),
   }
       awful.titlebar(c, { position = beautiful.titlebar_position,  size = beautiful.titlebar_size}):setup {
   {
    {
       awful.titlebar.widget.closebutton(c),
       awful.titlebar.widget.maximizedbutton(c),
       awful.titlebar.widget.minimizebutton (c),
       spacing = dpi(3),
       layout = wibox.layout.fixed.vertical
   },
   {
       buttons = buttons,
       layout  = wibox.layout.flex.vertical
   },
       layout = wibox.layout.align.vertical
   },
       top = dpi(6),
       left = dpi(2),
       right = dpi(2),
       widget = wibox.container.margin
   }
end)
