local wibox = require("wibox")
local awful = require("awful")
local watch = require("awful.widget.watch")
local beautiful = require("beautiful")
local apps = require("config.apps")
local gears = require("gears")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local command = {}

-- on music icon left clicking on icon makes controllers visible/ right clicking on icon change from controlling mpd to other music player.

-- If you're not using mpd, change this to false
local usempd = true


local function musicwidget()

-- Get Commands for player
function musiccommands()
if usempd then
command.toggle = "mpc -q toggle"
command.song = "mpc -f %title% current | cut -c1-15"
command.artist = "mpc -f %artist% current | cut -c1-10"
command.prev = "mpc -q prev"
command.next = "mpc -q next"
else
command.toggle = "playerctl --player=" .. apps.musicalt ..  " play-pause"
command.song = "playerctl --player=" .. apps.musicalt .. " metadata --format {{title}} | cut -c1-15"
command.artist = "playerctl --player=" .. apps.musicalt .. " metadata --format {{artist}} | cut -c1-10"
command.prev = "playerctl --player=" .. apps.musicalt .. " previous"
command.next = "playerctl --player=" .. apps.musicalt .. " next"
end
return command
end

musiccommands()

-- Title widget
local title = wibox.widget.textbox("Title")
title.font = beautiful.uifont .. " 11"
title.align = "center"
title.valign = "center"

-- Artist widget
local artist = wibox.widget.textbox("Artist")
artist.font = beautiful.uifont .. " 11"
artist.align = "center"
artist.valign = "center"

-- Get Metadata
function sb_music()
awful.spawn.easy_async_with_shell(command.song, function(song)
      title:set_markup ("<span foreground='" .. beautiful.blue .. "'>" .. song .. "</span>")
end)
awful.spawn.easy_async_with_shell(command.artist, function(out)
      artist.text = out
end)
end

-- Main Music Widget,
local music = wibox.widget {
    wibox.widget{
            markup = "<span foreground='" .. beautiful.blue .. "' ></span>",
            font = beautiful.iconfont .. " 17",
            widget = wibox.widget.textbox,
            align = "center",
            valign = "center",
            buttons = awful.button({ }, 1, function ()
                awful.spawn.with_shell(command.prev)
                sb_music()
                end)
            },
    wibox.widget({
                 {
             artist,
             widget = wibox.container.place,
                 },
                 {
             markup = "<b>-</b>",
             font =  beautiful.uifont .. " 10",
             widget = wibox.widget.textbox
                 },
                 {
             title,
             widget = wibox.container.place,
                 },
             spacing = 3,
             layout = wibox.layout.fixed.horizontal,
             buttons = awful.button({ }, 1, function ()
                       awful.spawn.with_shell(command.toggle)
                       sb_music()
                     end)
          }),
	    wibox.widget{
             font = beautiful.iconfont .. " 17",
             align = "center",
             valign = "center",
             markup = "<span foreground='" .. beautiful.blue .."' ></span>",
             widget = wibox.widget.textbox,
             buttons = awful.button({ }, 1, function ()
                       awful.spawn.with_shell(command.next)
                       sb_music()
                      end)
},
        spacing = 4,
        layout = wibox.layout.fixed.horizontal,
        buttons = awful.button({ }, 3, function()
        awful.spawn(apps.mpd)
        end)
}

-- widget not visible by default
music.visible = false

-- music icon
local player = wibox.widget {
       markup = "<span foreground='".. beautiful.blue .."'></span>",
       font =  beautiful.iconfont .. " 14",
       widget = wibox.widget.textbox,
       buttons =  gears.table.join(
            awful.button({ }, 1, function ()
                if music.visible then
                   music.visible = false
                else
                   music.visible = true
                end
                   sb_music()
                end),
             awful.button({ }, 3, function ()
                  if usempd then
                    usempd = false
                  else
                    usempd = true
                  end
                    musiccommands()
                 end))
}

-- return whole music widget
return  wibox.widget{
       player,
       music,
       bg = beautiful.blackalt,
       widget = wibox.container.background,
       spacing = 6,
       layout = wibox.layout.fixed.horizontal,
       buttons = gears.table.join(
                 awful.button({ }, 1, function ()
                 sb_music()
                 end))
}
end

return musicwidget()
