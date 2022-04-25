local naughty = require("naughty")
local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")
local awful = require("awful")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("components.helpers")
local ruled = require("ruled")
local menubar = require("menubar")

-- Notifications.

naughty.connect_signal("request::icon", function(n, context, hints)
    if context ~= "app_icon" then return end

    local path = menubar.utils.lookup_icon(hints.app_icon) or
                     menubar.utils.lookup_icon(hints.app_icon:lower())
    if path then n.icon = path end
end)

naughty.config.defaults.ontop = true
naughty.config.defaults.screen = awful.screen.focused()
naughty.config.defaults.timeout = 3
naughty.config.defaults.title = "Notification"
naughty.config.defaults.position = "top_right"
naughty.config.defaults.icon = beautiful.notification_icon
naughty.config.presets.ok = naughty.config.presets.normal
naughty.config.presets.info = naughty.config.presets.normal
naughty.config.presets.warn = naughty.config.presets.critical


ruled.notification.connect_signal("request::rules", function()
    ruled.notification.append_rule {
        rule       = { urgency = "critical" },
        properties = { timeout = 0 }
    }
    ruled.notification.append_rule {
        rule       = { urgency = "normal" },
        properties = { timeout = 10 }
    }
    ruled.notification.append_rule {
        rule       = { urgency = "low" },
        properties = { timeout = 5 }
    }
end)

naughty.connect_signal("request::display", function(n)
-- notification actions
    local appicon = beautiful.notification_icon
    local time = os.date("%H:%M")
    local action_widget = {
        {
            {
                id = "text_role",
                align = "center",
                valign = "center",
                font = beautiful.uifont .. " 10",
                widget = wibox.widget.textbox
            },
            top = dpi(2),
            bottom = dpi(2),
            left = dpi(2),
            right = dpi(2),
            widget = wibox.container.margin
        },
        bg = beautiful.bluealt,
        forced_height = dpi(20),
        forced_width = dpi(20),
        shape = helpers.rrect(dpi(4)),
        widget = wibox.container.background
    }
    local actions = wibox.widget {
        notification = n,
        base_layout = wibox.widget {
            spacing = dpi(8),
            layout = wibox.layout.flex.horizontal
        },
        widget_template = action_widget,
        style = {underline_normal = false, underline_selected = true},
        widget = naughty.list.actions
    }

-- notifications setup.
    naughty.layout.box {
        notification = n,
        type = "notification",
        widget_template = {
            {
                {
                    {
                        {
                            {
                                {
                                    {
                                        {
                                            image = appicon,
                                            resize = true,
                                            clip_shape = helpers.rrect(
                                                beautiful.border_radius - 3),
                                            widget = wibox.widget.imagebox
                                        },
                                        strategy = "max",
                                        height = dpi(20),
                                        widget = wibox.container.constraint
                                    },
                                    right = dpi(10),
                                    widget = wibox.container.margin
                                },
                                {
                                    markup = "<span foreground = '" .. beautiful.blue .. "' >" .. n.app_name .. "</span>",
                                    align = "left",
                                    font = beautiful.uifont .. " 10",
                                    widget = wibox.widget.textbox
                                },
                                {
                                    markup = time,
                                    align = "right",
                                    font = beautiful.uifont .. " 8",
                                    widget = wibox.widget.textbox
                                },
                                layout = wibox.layout.align.horizontal
                            },
                           top = dpi(7),
                           left = dpi(20),
                           right = dpi(20),
                           bottom = dpi(5),
                           widget = wibox.container.margin
                       },
                        bg = beautiful.bluealt,
                        widget = wibox.container.background
                    },
                    {
                        {
                            {
                                helpers.vertical_pad(10),
                                {
                                    {
                                        step_function = wibox.container.scroll
                                            .step_functions
                                            .waiting_nonlinear_back_and_forth,
                                        speed = 50,
                                        {
                                            markup = "<span weight='bold'>" ..
                                                n.title .. "</span>",
                                            font = beautiful.uifont .. " 10",
                                            align = "left",
                                            widget = wibox.widget.textbox
                                        },
                                        forced_width = dpi(204),
                                        widget = wibox.container.scroll
                                            .horizontal
                                    },
                                    {
                                        {
                                            markup = n.message,
                                            align = "left",
                                            font = beautiful.uifont .. " 10",
                                            widget = wibox.widget.textbox
                                        },
                                        right = 10,
                                        widget = wibox.container.margin
                                    },
                                    spacing = 0,
                                    layout = wibox.layout.flex.vertical
                                },
                                helpers.vertical_pad(10),
                                layout = wibox.layout.align.vertical
                            },
                            left = dpi(20),
                            right = dpi(20),
                            widget = wibox.container.margin
                        },
                        {
                            {
                                nil,
                                {
                                    {
                                        image = n.icon,
                                        resize = true,
                                        clip_shape = helpers.rrect(
                                            beautiful.border_radius - 3),
                                        widget = wibox.widget.imagebox
                                    },
                                    strategy = "max",
                                    height = 40,
                                    widget = wibox.container.constraint
                                },
                                nil,
                                expand = "none",
                                layout = wibox.layout.align.vertical
                            },
                            top = dpi(0),
                            left = dpi(10),
                            right = dpi(10),
                            bottom = dpi(0),
                            widget = wibox.container.margin
                        },
                        layout = wibox.layout.fixed.horizontal
                    },
                    {
                        {actions, layout = wibox.layout.fixed.vertical},
                        margins = dpi(10),
                        visible = n.actions and #n.actions > 0,
                        widget = wibox.container.margin
                    },
                    layout = wibox.layout.fixed.vertical
                },
                top = dpi(0),
                bottom = dpi(5),
                widget = wibox.container.margin
            },
            shape = helpers.rrect(dpi(8)),
            widget = wibox.container.background
        }
    }
end)


-- Error handling
if _G.awesome.startup_errors then
  naughty.notify(
    {
      preset = naughty.config.presets.critical,
      title = 'Oops, there were errors during startup!',
      text = _G.awesome.startup_errors
    }
  )
end

do
  local in_error = false
  _G.awesome.connect_signal(
    'debug::error',
    function(err)
      if in_error then
        return
      end
      in_error = true

      naughty.notify(
        {
          preset = naughty.config.presets.critical,
          title = 'Oops, an error happened!',
          text = tostring(err)
        }
      )
      in_error = false
    end
  )
end

-- Create a notification sound
naughty.connect_signal(
    'request::display',
    function(n)
      awful.spawn.with_shell('canberra-gtk-play -i message')
    end
)

function log_this(title, txt)
  naughty.notify(
    {
      title = 'log: ' .. title,
      text = txt
    }
  )
end
