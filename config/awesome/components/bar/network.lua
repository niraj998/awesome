local awful = require("awful")
local wibox = require('wibox')
local watch = require('awful.widget.watch')
local beautiful = require('beautiful')
local gears = require("gears")
local apps = require("config.apps")
local dpi = require('beautiful').xresources.apply_dpi

-- this widget shows network status.

-- get all the components
local wifiicon = wibox.widget.textbox()
wifiicon.font = beautiful.iconfont .. " 13"

local ethicon = wibox.widget.textbox()
ethicon.font = beautiful.iconfont .. " 13"

local bticon = wibox.widget.textbox()
bticon.font = beautiful.iconfont .. " 13"

-- Get Bluetooth status
function sb_bluetooth()
  awful.spawn.easy_async_with_shell("bluetoothctl show | grep Powered | awk '{print $2}'", function(out)
    if string.match(out, "no") then
        bticon.text = ''
    else
       awful.spawn.easy_async_with_shell("bluetoothctl info >> /dev/null && echo connected  || echo on ", function(out)
        if string.match(out, "connected") then
           bticon.text = ''
        else
           bticon.text = ''
        end
        end)
    end
end)
end

-- Get Ethernet status
-- if it's not working properly you can replace en* with the full name
function sb_ethernet()
    awful.spawn.easy_async_with_shell("sh -c 'cat /sys/class/net/en*/operstate' ", function(out)
      if string.match(out, "up") then
        ethicon.text = ''
    else
       ethicon.text = ''
       ethicon.text = ''
    end
end)
end

-- Get Wifi status
-- if it's not working properly you can replace wl* with the full name
function sb_wifi()
    awful.spawn.easy_async_with_shell("sh -c 'cat /sys/class/net/wl*/flags' ", function(out)
      if string.match(out, "0x1003") then
       local   getstrength = [[  awk '/^\s*w/ { print  int($3 * 100 / 70) }' /proc/net/wireless   ]]
            awful.spawn.easy_async_with_shell(getstrength , function(stdout)
            local strength = tonumber(stdout) or 0
              if strength > 80 then
                wifiicon.text = '󰤨'
              elseif strength > 60 then
                wifiicon.text = '󰤥'
              elseif strength > 40 then
                wifiicon.text = '󰤢'
              elseif strength > 20 then
                wifiicon.text = '󰤟'
              else
                wifiicon.text = '󰤯'
              end
            end)
      else
         wifiicon.text = '󰤭'
      end
    end)
end

-- wifi/ethernet widget
local network = wibox.widget {
          wibox.widget{
                ethicon,
                fg = beautiful.blue,
                widget = wibox.container.background
          },
          wibox.widget{
                wifiicon,
                fg = beautiful.blue,
                widget = wibox.container.background
          },
        spacing = dpi(6),
        layout = wibox.layout.fixed.horizontal,
        buttons = gears.table.join(
        awful.button({ }, 1, function ()
        awful.spawn.with_shell(apps.internet .. "; echo 'sb_ethernet()' | awesome-client; echo 'sb_wifi()' | awesome-client" )
      sb_ethernet()
      sb_wifi()
end))}

-- bluetooth widget.
local bluetooth = wibox.widget {
          wibox.widget{
                bticon,
                fg = beautiful.blue,
                widget = wibox.container.background
          },
        layout = wibox.layout.fixed.horizontal,
        buttons = gears.table.join(
        awful.button({ }, 1, function ()
        awful.spawn(apps.bluetooth )
      sb_bluetooth()
end))
}

-- return widget
return wibox.widget {
          wibox.widget{
                network,
                fg = beautiful.blue,
                widget = wibox.container.background
          },
          wibox.widget{
                markup = "<span foreground='"..beautiful.blue.."'><b>|</b></span>",
                font =  beautiful.uifont .. " 12",
                widget = wibox.widget.textbox
          },
          wibox.widget{
                bluetooth,
                fg = beautiful.blue,
                widget = wibox.container.background
          },
        spacing = dpi(6),
        layout = wibox.layout.fixed.horizontal,
}
