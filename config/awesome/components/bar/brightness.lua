local awful = require("awful")
local wibox = require('wibox')
local dpi = require('beautiful').xresources.apply_dpi
local watch = require('awful.widget.watch')
local beautiful = require('beautiful')
local apps = require("config.apps")
local gears = require("gears")

-- brightness value will only show if you have xbacklight.
-- scrolling up and down on widget runs brightmess script you gave in apps.lua.


-- create battery widgets components
local briicon = wibox.widget.textbox("")
briicon.font = beautiful.iconfont .. " 14"

local briperc = wibox.widget.textbox()
briperc.font = beautiful.uifont .. " 13"

-- update icons and percentage
function sb_brightness()
awful.spawn.easy_async_with_shell('xbacklight -get | cut -d "." -f1 || echo 0 ' , function(stdout)
  briperc.text= tonumber(stdout) or 0
    end)
end

-- brightness widget.
local brightwidget = wibox.widget {
          wibox.widget{
                briicon,
                fg = beautiful.blue,
                widget = wibox.container.background
          },
          wibox.widget{
                briperc,
                fg = beautiful.white,
                widget = wibox.container.background
          },
        spacing = dpi(4),
        layout = wibox.layout.fixed.horizontal,
	buttons = gears.table.join(
                 awful.button({ }, 4, function ()
                  awful.spawn.with_shell(apps.brightplus)
		sb_brightness()
                 end),
                 awful.button({ }, 5, function ()
                  awful.spawn.with_shell(apps.brightless)
		sb_brightness()
                 end))
}

briperc.visible = false
    brightwidget:connect_signal("mouse::enter", function()
	briperc.visible = true
    end)
    brightwidget:connect_signal("mouse::leave", function()
	briperc.visible = false
    end)

-- return widget
return brightwidget
