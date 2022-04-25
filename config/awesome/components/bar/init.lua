local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local apps = require("config.apps")
local helpers = require("components.helpers")
local watch = require('awful.widget.watch')
local modkey = "Mod4"

--({{ Import Long Widgets
-- if something is not working checkout the widgets itself.
local text_taglist = require("components.bar.taglist")
local battery = require("components.bar.battery")
local music = require("components.bar.music")
local network = require("components.bar.network")
local volume = require("components.bar.volume")
local update = require("components.bar.update")
local brightness = require("components.bar.brightness")

-- you can pick what to show and what not to at the end of this file. in bar setup.
--}})


--({{ Set update Intervals
--[[ Bar functions similar to dwmblocks.
Bar gets updated whenever you call on these functions, you will see this throughout these config.
    sb_wifi()
    sb_ethernet()
    sb_bluetooth()
    sb_battery()
    sb_volume()
    sb_brightness()
    sb_music()
you can also run this functions from terminal outside this config file.
like this, echo 'sb_volume()' | awesome-client   ]]--

-- widgets update interval (in seconds)
local interval = 60

watch('sh -c', interval, function()
    sb_wifi() -- update wifi status
    sb_ethernet() -- update ethernet status
    sb_bluetooth() -- update bluetooth status
    sb_battery() -- update battery status
-- volume/brightness updates everytime you incerease decrease volume through widget/keyboard shortcuts. so no need to update at intervals.
--    sb_volume()
--    sb_brightness()
end)

local musicinterval = 15
watch('sh -c', musicinterval, function(_, stdout)
  sb_music()
end)
-- }})


-- ({{ Short Widgets/Buttons
-- Search
local search = wibox.widget{
 wibox.widget{
       markup = "<span foreground='".. beautiful.blue .."'></span>",
       font =  beautiful.iconfont .. " 13",
       widget = wibox.widget.textbox,
     },
      layout = wibox.layout.fixed.horizontal,
        buttons = gears.table.join(
        awful.button({ }, 1, function ()
        awful.spawn(apps.run)
end))
}

-- Notification
local notification = wibox.widget{
 wibox.widget{
       markup = "<span foreground='".. beautiful.blue .."'>󰵚</span>",
       font =  beautiful.iconfont .. " 14",
       widget = wibox.widget.textbox,
     },
      layout = wibox.layout.fixed.horizontal,
        buttons = gears.table.join(
        awful.button({ }, 1, function ()
      notifs_toggle()
end))
}

-- Search
local power = wibox.widget{
 wibox.widget{
       markup = "<span foreground='".. beautiful.blue .."'></span>",
       font =  beautiful.iconfont .. " 13",
       widget = wibox.widget.textbox,
     },
      layout = wibox.layout.fixed.horizontal,
        buttons = awful.button({ }, 1, function ()
                    exit_screen_show()
                end)
}

-- Time
local time = wibox.widget.textclock("<span font='" .. beautiful.uifont .. " 12'>%d %b (%a) | %H:%M </span>",60)
-- }})


--({{ Top Bar

-- Create bar for each screen
awful.screen.connect_for_each_screen(function(s)

s.padding = {top = 0}

-- Tags
tag.connect_signal("request::default_layouts", function()
awful.layout.append_default_layouts({
    awful.layout.suit.tile,
    awful.layout.suit.max,
    awful.layout.suit.floating,
    awful.layout.suit.fair,
--    awful.layout.suit.tile.left,
--    awful.layout.suit.tile.bottom,
--    awful.layout.suit.tile.top,
--    awful.layout.suit.fair.horizontal,
--    awful.layout.suit.spiral,
--   awful.layout.suit.spiral.dwindle,
--    awful.layout.suit.max.fullscreen,
--    awful.layout.suit.magnifier,
--    awful.layout.suit.corner.nw,
    })
end)

awful.tag( { "󰈹", "", "󰉋", "󰓇", "󰟴", "󰒓" } , s, awful.layout.layouts[1])

local taglistbuttons =  gears.table.join(
      awful.button({ }, 1, function(t) t:view_only() end),
      awful.button({ modkey }, 1, function(t)
                   if client.focus then
                      client.focus:move_to_tag(t)
                   end
                   end),
      awful.button({ }, 3, awful.tag.viewtoggle),
      awful.button({ modkey }, 3, function(t)
                   if client.focus then
                      client.focus:toggle_tag(t)
                   end
                   end),
      awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
      awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
         )

-- Taglist
-- this is old taglist. (default with awesome bar)
s.mytaglist = awful.widget.taglist {
    screen  = s,
    filter  = awful.widget.taglist.filter.all,
    buttons = taglistbuttons,
    layout = {
    forced_num_cols = 1,
    layout = wibox.layout.grid.horizontal,
         },
    forced_width = 5,
    forced_height = 5,
}

-- Tasklist
s.mytasklist = awful.widget.tasklist {
    screen   = s,
    filter   = awful.widget.tasklist.filter.currenttags,
    buttons  = {gears.table.join(
      awful.button({ }, 1, function (c)
                   if c == client.focus then
                      c.minimized = true
                   else
                      c:emit_signal(
                                    "request::activate",
                                    "tasklist",
                                    {raise = true}
                                    )
                   end
                   end),
      awful.button({ }, 2, function ()
      awful.client:kill()
                              end),
      awful.button({ }, 3, function()
      awful.menu.client_list({ theme = { width = 250 } })
                              end),
      awful.button({ }, 4, function ()
      awful.client.focus.byidx(1)
                              end),
      awful.button({ }, 5, function ()
      awful.client.focus.byidx(-1)
                             end))
    },
    style = {
        icon_size = 22,
        shape = helpers.rrect(dpi(6)),
    },
    layout   = {
      spacing = dpi(4),
        spacing_widget = {
            valign = "center",
            halign = "center",
            widget = wibox.container.place,
        },
        layout  = wibox.layout.flex.horizontal
    },
    widget_template = {
    {
       {
       {
       {
           id     = "icon_role",
           widget = wibox.widget.imagebox,
       },
           top = dpi(1),
           bottom = dpi(1),
           left = dpi(4),
           right = dpi(4),
           widget  = wibox.container.margin,
       },
           layout = wibox.layout.fixed.horizontal,
       },
        		left = dpi(3),
     				right = dpi(3),
            widget = wibox.container.margin
       },
            id     = "background_role",
            widget = wibox.container.background,
       },
}

-- Promptbox
s.mypromptbox = awful.widget.prompt()

-- Systray
s.systray = wibox.widget.systray()

-- Layoutbox
s.mylayoutbox = awful.widget.layoutbox(s)
-- s.mylayoutbox = wibox.container.margin(s.mylayoutbox, 0, 0, 0, 0)
s.mylayoutbox:buttons(gears.table.join(
    awful.button({ }, 1, function () awful.layout.inc( 1) end),
    awful.button({ }, 3, function () awful.layout.inc(-1) end),
    awful.button({ }, 4, function () awful.layout.inc( 1) end),
    awful.button({ }, 5, function () awful.layout.inc(-1) end)))

-- function to add paddings and background to widgets.
local function barcontainer(widget)
    local container = wibox.widget
      {
        widget,
        top = dpi(1),
        bottom = dpi(1),
        left = dpi(3),
        right = dpi(3),
        widget = wibox.container.margin
    }
    local box = wibox.widget{
        {
            container,
            top = dpi(1),
            bottom = dpi(1),
            left = dpi(4),
            right = dpi(4),
            widget = wibox.container.margin
        },
        bg = beautiful.bluealt,
        shape = helpers.rrect(dpi(6)),
        widget = wibox.container.background
    }
return wibox.widget{
        box,
        top = dpi(4),
        bottom = dpi(4),
        right = dpi(2),
        left = dpi(2),
        widget = wibox.container.margin
    }
end

-- Merge widgets together to add in background container.
local sysbox = wibox.widget{
      brightness,
      volume,
      battery,
      s.mylayoutbox,
      spacing = dpi(10),
     layout = wibox.layout.fixed.horizontal,
}

-- ┌┐ ┌─┐┬─┐
-- ├┴┐├─┤├┬┘
-- └─┘┴ ┴┴└─

s.mywibox = awful.wibox({ position = "top", width = '100%', height = 30, screen = s, stretch = false, margins = 0, bg = beautiful.black })
s.mywibox.y = 0

-- Add widgets to the wibox
s.mywibox:setup {
layout = wibox.layout.stack,
{
      layout = wibox.layout.align.horizontal,
  { -- Left widgets
      barcontainer(search),

-- pick any one taglist

--      barcontainer(s.mytaglist), -- default awesome taglist
      barcontainer(text_taglist(s)), -- pacman taglist

      s.mypromptbox,
   	{
      s.mytasklist,
      top = dpi(3),
      bottom = dpi(3),
      widget = wibox.container.margin,
   	},

  layout = wibox.layout.fixed.horizontal,
  },
      nil,
  { -- Right widgets

      barcontainer(s.systray),
      barcontainer(music),
--      barcontainer(update),
--      barcontainer(notification),
      barcontainer(network),
      barcontainer(sysbox),
      barcontainer(power),
      layout = wibox.layout.fixed.horizontal,
  },
},
  {-- Center widget
      barcontainer(time),
 	    valign = "center",
 	    halign = "center",
 	    layout = wibox.container.place,
  },
}
end)

--)}}
