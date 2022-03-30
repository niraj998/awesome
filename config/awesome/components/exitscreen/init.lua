--[[ this is fork of exitscreen from elenapan's dotfiles, I've added some more things ]]--
local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local apps = require("config.apps")
local helpers = require("components.helpers")


-- ({{ Preferences
-- Appearance
local poweroff_text_icon = ""
local reboot_text_icon = ""
local suspend_text_icon = ""
local exit_text_icon = ""
local lock_text_icon = ""

-- Buttons
local button_bg = beautiful.black
local button_size = dpi(150)

-- Commands, they are comming from apps file change there.
local poweroff_command = function()   awful.spawn.with_shell(apps.power) end
local reboot_command = function()    awful.spawn.with_shell(apps.restart) end
local suspend_command = function()   lock_screen_show()
                                     awful.spawn.with_shell(apps.suspend) end
local exit_command = function()    awesome.quit() end
local lock_command = function()     lock_screen_show()  end
-- }})

-- ({{ Widgets

-- Helper function that generates the clickable buttons
local create_button = function(symbol, hover_color, text, command)
    local icon = wibox.widget {
        forced_height = button_size,
        forced_width = button_size,
        align = "center",
        valign = "center",
        font = beautiful.iconfont .. " 40",
        markup = helpers.colorize_text(symbol, beautiful.grey),
        widget = wibox.widget.textbox()
    }
    local button = wibox.widget {
        {
            nil,
            icon,
            expand = "none",
            layout = wibox.layout.align.horizontal
        },
        forced_height = button_size,
        forced_width = button_size,
        shape_border_width = dpi(10),
        shape_border_color = button_bg,
        shape = helpers.rrect(dpi(20)),
        bg = button_bg,
        widget = wibox.container.background
    }
    -- Bind left click to run the command
    button:buttons(gears.table.join(
        awful.button({ }, 1, function ()
            command()
        end)
    ))
    -- Change color on hover
    button:connect_signal("mouse::enter", function ()
        icon.markup = helpers.colorize_text(icon.text, hover_color)
        button.shape_border_color = hover_color
    end)
    button:connect_signal("mouse::leave", function ()
        icon.markup = helpers.colorize_text(icon.text, beautiful.grey)
        button.shape_border_color = button_bg
    end)
    return button
end

-- Create the buttons
local poweroff = create_button(poweroff_text_icon, beautiful.purple, "Poweroff", poweroff_command)
local reboot = create_button(reboot_text_icon, beautiful.pink, "Reboot", reboot_command)
local suspend = create_button(suspend_text_icon, beautiful.blue, "Suspend", suspend_command)
local exit = create_button(exit_text_icon, beautiful.green, "Exit", exit_command)
local lock = create_button(lock_text_icon, beautiful.yellow, "Lock", lock_command)

-- Profile Picture
local pic = wibox.widget {
    nil,
    {
        {
            image = beautiful.profile,
            resize = true,
            clip_shape = gears.shape.circle,
            widget = wibox.widget.imagebox,
        },
        border_width = dpi(5),
        border_color = beautiful.blackalt,
        bg = beautiful.blue,
        forced_height = dpi(200),
        forced_width = dpi(200),
        shape = gears.shape.circle,
        widget = wibox.container.background
    },
    nil,
    expand = "none",
    layout = wibox.layout.align.horizontal
}

-- Get Username
local user = os.getenv("USER")
local username = wibox.widget.textbox("Goodbye ".. user:sub(1,1):upper()..user:sub(2))
username.font = "sans 40"
username.align = "center"
username.valign = "center"

-- Create screen mask for second screen.
local function screen_mask(s)
    local mask = wibox({visible = false, ontop = true, type = "splash", screen = s})
    awful.placement.maximize(mask)
    mask.bg = beautiful.blackalt
    mask.fg = beautiful.grey

    return mask
end

-- Create the exit screen wibox.
exit_screen = wibox({visible = false, ontop = true, type = "splash"})
awful.placement.maximize(exit_screen)
exit_screen.bg = beautiful.blackdark  .. "EE"
exit_screen.fg = beautiful.grey

-- ({{ Create Exit Screen
for s in screen do
    if s == screen.primary then
        s.myexitscreen = exit_screen
    else
        s.myexitscreen = screen_mask(s)
    end

    s.myexitscreen:buttons(gears.table.join(
        -- Left click - Hide exit_screen
        awful.button({ }, 1, function ()
            exit_screen_hide()
        end),
        -- Middle click - Hide exit_screen
        awful.button({ }, 2, function ()
            exit_screen_hide()
        end),
        -- Right click - Hide exit_screen
        awful.button({ }, 3, function ()
            exit_screen_hide()
        end)
    ))
end

local exit_screen_grabber
function exit_screen_hide()
    awful.keygrabber.stop(exit_screen_grabber)
    for s in screen do
        s.myexitscreen.visible = false
    end
end

local keybinds = {
    ['escape'] = exit_screen_hide,
    ['q'] = exit_screen_hide,
    ['x'] = exit_screen_hide,
    ['s'] = function () suspend_command(); exit_screen_hide() end,
    ['e'] = exit_command,
    ['p'] = poweroff_command,
    ['r'] = reboot_command,
    ['l'] = function ()
        lock_command()
        -- Kinda fixes the "white" (undimmed) flash that appears between
        -- exit screen disappearing and lock screen appearing
        gears.timer.delayed_call(function()
            exit_screen_hide()
        end)
    end
}
--)}}
--)}}

-- function to set exit screen
function exit_screen_show()
    exit_screen_grabber = awful.keygrabber.run(function(_, key, event)
        -- Ignore case
        key = key:lower()

        if event == "release" then return end

        if keybinds[key] then
            keybinds[key]()
        end
    end)
    for s in screen do
        s.myexitscreen.visible = true
    end
end

-- Item placement
exit_screen:setup {
nil,
  {
    nil,
    {
        {
          pic,
          username,
          spacing = dpi(10),
          layout = wibox.layout.fixed.vertical
        },
        {
          poweroff,
          reboot,
          suspend,
          exit,
          lock,
          spacing = dpi(50),
          layout = wibox.layout.fixed.horizontal
        },
       spacing = dpi(60),
       layout = wibox.layout.fixed.vertical
    },
     expand = "none",
     layout = wibox.layout.align.horizontal
  },
    expand = "none",
    layout = wibox.layout.align.vertical
}
