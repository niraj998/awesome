local awful = require("awful")
local wibox = require('wibox')
local beautiful = require('beautiful')
local gears = require("gears")
local apps = require("config.apps")
local dpi = require('beautiful').xresources.apply_dpi

-- update widget. (runs only once on the startup)

-- widget components
local updateicon = wibox.widget{
                markup = "<span foreground='"..beautiful.blue.."'></span>",
                font =  beautiful.iconfont .. " 13",
                widget = wibox.widget.textbox
}

-- note it only check for update once on the startup.
local updatenum = wibox.widget.textbox()
updatenum.font = beautiful.uifont .. " 13"
  awful.spawn.easy_async_with_shell(apps.updates , function(stdout)
  updatenum.text = tonumber(stdout)
end)


-- Widget
return wibox.widget {
          wibox.widget{
                updateicon,
                fg = beautiful.blue,
                widget = wibox.container.background
          },
          wibox.widget{
                updatenum,
                fg = beautiful.blue,
                widget = wibox.container.background
          },
        spacing = dpi(6),
        layout = wibox.layout.fixed.horizontal,
        buttons = gears.table.join(
         awful.button({ }, 1, function ()
         awful.spawn(apps.update)
         end)) }
