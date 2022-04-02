local awful = require("awful")
local wibox = require('wibox')
local dpi = require('beautiful').xresources.apply_dpi
local beautiful = require('beautiful')
local gears = require("gears")
local apps = require("config.apps")

-- left click to open volume management application like, pavucontrol or pulsemixer.
-- right click to toggle mute.
-- scroll up/down to increase/decrease volume.
-- note volume widget only updates when you do any of the above things. or use keyboard shortcuts to control volume.

-- widget components
local volicon = wibox.widget.textbox()
volicon.font = beautiful.iconfont .. " 14"
local volperc = wibox.widget.textbox()
volperc.align = 'center'
volperc.valign = 'center'
volperc.font = beautiful.uifont .. " 13"

-- widget function.
sb_volume = function()
  awful.spawn.easy_async_with_shell('pamixer --get-volume' , function(stdout)
    local vol = tonumber(stdout)
    awful.spawn.easy_async_with_shell('pamixer --get-mute' , function(out)
      if string.match(out, "true") then
         volicon.markup = "<span foreground = '" .. beautiful.red .. "'>婢</span>"
         volperc.markup = "<span foreground = '" .. beautiful.red .. "'>M</span>"
      else
         volperc.text = vol .. "%"
         awful.spawn.easy_async_with_shell('pactl list sinks | grep "Active Port" | grep headphone > /dev/null && echo headphones' , function(out)
           if string.match(out, "headphones") then
             volicon.text = ''
           else
              if vol >= 65 then
                 volicon.text = '墳'
              elseif vol >= 10 then
                 volicon.text =  '奔'
              else
                 volicon.text = '奄'
              end
           end
         end)
      end
    end)
  end)
end


-- run once on startup
sb_volume()

-- the volume widget
return  wibox.widget {
          wibox.widget{
                volicon,
                fg = beautiful.blue,
                widget = wibox.container.background
          },
          wibox.widget{
                volperc,
                fg = beautiful.white,
                widget = wibox.container.background
          },
        spacing = dpi(6),
        layout = wibox.layout.fixed.horizontal,
      buttons = gears.table.join(
   awful.button({ }, 1, function ()
      awful.spawn.with_shell(apps.volumeapp .. "; echo 'sb_volume()' | awesome-client" )
   end),
   awful.button({ }, 3, function()
      awful.spawn.with_shell(apps.volumemute)
	sb_volume()
    end),
   awful.button({ }, 4, function ()
      awful.spawn.with_shell(apps.volumeplus)
	sb_volume()
   end),
   awful.button({ }, 5, function ()
      awful.spawn.with_shell(apps.volumeless)
	sb_volume()
   end))
}
