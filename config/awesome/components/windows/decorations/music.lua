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
local icons = home .. "/.config/awesome/assets/icons/music/"
local music = require("components.bar.music")
local apps = require("config.apps")

local command = {}

-- Get Commands for player
command.toggle = "mpc -q toggle"
command.song = "mpc -f %title% current"
command.artist = "mpc -f %artist% current "
command.prev = "mpc -q prev"
command.next = "mpc -q next"
command.playlist= "mpc status %songpos%/%length%"

-- Title widget
local title = wibox.widget.textbox("Title")
title.font = beautiful.uifont .. " 13"
title.align = "center"
title.valign = "center"

-- Artist widget
local artist = wibox.widget.textbox("Artist")
artist.font = beautiful.uifont .. " 13"
artist.align = "center"
artist.valign = "center"

-- Title widget
local playlist = wibox.widget.textbox("0/0")
playlist.font = beautiful.uifont .. " 13"
playlist.align = "center"
playlist.valign = "center"

-- Get Metadata
_G.updatencmpcpp = function()
awful.spawn.easy_async_with_shell(command.song, function(song)
      title:set_markup ("<span foreground='" .. beautiful.blue .. "'>" .. song .. "</span>")
end)
awful.spawn.easy_async_with_shell(command.artist, function(out)
      artist.text = out
end)
awful.spawn.easy_async_with_shell(command.playlist, function(stdout)
      playlist.text =  stdout
end)
end

-- Main Music Widget
local music = wibox.widget {
    wibox.widget{
            markup = "<span foreground='" .. beautiful.blue .. "' ></span>",
            font = beautiful.iconfont .. " 18",
            widget = wibox.widget.textbox,
            align = "center",
            valign = "center",
            buttons = awful.button({ }, 1, function ()
                awful.spawn.with_shell(command.prev)
                updatencmpcpp()
                end)
            },
    wibox.widget({
		 {
             playlist,
             widget = wibox.container.place,
                 },
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
             spacing = dpi(4),
             layout = wibox.layout.fixed.horizontal,
             buttons = awful.button({ }, 1, function ()
                       awful.spawn.with_shell(command.toggle)
                       updatencmpcpp()
                     end)
          }),
    wibox.widget{
             font = beautiful.iconfont .. " 18",
             align = "center",
             valign = "center",
             markup = "<span foreground='" .. beautiful.blue .."' ></span>",
             widget = wibox.widget.textbox,
             buttons = awful.button({ }, 1, function ()
                       awful.spawn.with_shell(command.next)
                       updatencmpcpp()
                      end)
},
        spacing = dpi(8),
        layout = wibox.layout.fixed.horizontal,
--        forced_height = dpi(50),
--        forced_width = dpi(200),
        buttons = awful.button({ }, 3, function()
        awful.spawn(apps.mpd)
        end)
}

music.visible = true

updatencmpcpp()


local imagebuttons = function(image, onclick)
    local image = wibox.widget {
--    image = gears.color.recolor_image(icons .. image , '#61afef'),
    image = icons .. image,
    resize = true,
    valign = "center",
    halign = "center",
    widget = wibox.widget.imagebox,
}
    if onclick ~= nil then
        image:connect_signal("button::press", onclick)
    end
    return image
end



local imageactions = function(c, icon, keys)
  local shortcut = imagebuttons( icon , function()
        awful.spawn.with_shell("xdotool key " .. keys .."; ")
    end)
    shortcut.forced_width = dpi(32)
    shortcut.forced_height = dpi(32)
    return shortcut
end




-- Add paddings and background to widgets.
local function containers(widget)
    local container = wibox.widget
      {
        widget,
        top = dpi(3),
        bottom = dpi(3),
        left = dpi(3),
        right = dpi(3),
        widget = wibox.container.margin
    }
    local box = wibox.widget{
        {
            container,
            top = dpi(4),
            bottom = dpi(4),
            left = dpi(4),
            right = dpi(4),
            widget = wibox.container.margin
        },
        bg = beautiful.blackalt,
        shape = helpers.rrect(dpi(10)),
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



local thunarbar = function (c)

-- Top Bar
awful.titlebar(c, { position = "top",  size = dpi(40)  }):setup {
    {
--    nil,
--    containers(imageactions(c, "music.png", "1")),
wibox.widget {
 wibox.widget {
--    image = gears.color.recolor_image(icons .. "music.png", '#61afef'),
    image = icons .. "music.png",
    resize = true,
    valign = "center",
    halign = "center",
    widget = wibox.widget.imagebox,
    buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:activate { context = "titlebar", action = "mouse_move"  }
        end),
        awful.button({ }, 3, function()
            c:activate { context = "titlebar", action = "mouse_resize"}
        end)
	)
},
	 top = dpi(8),
	 bottom = dpi(8),
	 left = dpi(8),
	 widget = wibox.container.margin
},

--    musicicon,
    containers(music),
      wibox.widget {
         awful.titlebar.widget.closebutton(c),
	 top = dpi(8),
	 bottom = dpi(8),
	 right = dpi(8),
	 widget = wibox.container.margin
       },
    expand = "none",
    layout = wibox.layout.align.horizontal
     },
    bg = beautiful.black,
    widget = wibox.container.background
  }

-- Left Bar
  awful.titlebar(c, { position = "left",  size = dpi(65)  }):setup {
   {
	   {  {
     containers(imageactions(c, "playlist.png", "1")),
     containers(imageactions(c, "library.png", "4")),
     containers(imageactions(c, "wave.png", "8")),
     containers(imageactions(c, "shuffle.png", "z")),
     containers(imageactions(c, "repeat.png", "r")),
     layout = wibox.layout.fixed.vertical
     },

          layout = wibox.layout.fixed.vertical
     },


       top = dpi(60),
       left = dpi(7),
       right = dpi(7),
       widget = wibox.container.margin
  },
  bg = beautiful.black,
  widget = wibox.container.background



  }
end

--ruled.client.connect_signal("request::rules", function()
--    ruled.client.append_rule {
--        id = "music",
--        rule = {
--		{class = "music"},
--		{instance = "music"}},
--        callback = thunarbar
--    }
--end)

table.insert(awful.rules.rules, {
    rule_any = {
        class = {
            "music",
        },
        instance = {
            "music",
        },
    },
    properties = {},
    callback = thunarbar
})
