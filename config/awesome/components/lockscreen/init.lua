--[[ this is fork of exitscreen from elenapan's dotfiles, I've added some more things ]]--
-- As a lockscreen this is not secure at all, it can be easily broken.

local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local helpers = require("components.helpers")
local apps = require("config.apps")


local password
if user and user.lock_screen_password then
  password = user.lock_screen_password
else
  password = "awesome"
end


local poweroff_text_icon = ""
local reboot_text_icon = ""
local exit_text_icon = ""

local button_bg = beautiful.black
local button_size = dpi(150)

-- Commands
local poweroff_command = function()   awful.spawn.with_shell(apps.power) end
local reboot_command = function()    awful.spawn.with_shell(apps.restart) end
local exit_command = function()    awesome.quit() end

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
        forced_height = dpi(100),
        forced_width = dpi(100),
        shape_border_width = dpi(4),
        shape_border_color = button_bg,
        shape = gears.shape.circle,
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
local exit = create_button(exit_text_icon, beautiful.green, "Exit", exit_command)


local lock_screen_symbol = ""
local lock_screen_fail_symbol = ""
local lock_animation_icon = wibox.widget {
    forced_height = dpi(80),
   forced_width = dpi(80),
  font = beautiful.iconfont .. " 60",
   align = "center",
   valign = "center",
    fg = beautiful.grey,
   bg = beautiful.white,
   widget = wibox.widget.textbox(lock_screen_symbol)
}

-- A dummy textbox needed to get user input.
-- It will not be visible anywhere.
local some_textbox = wibox.widget.textbox()

local function screen_mask(s)
    local mask = wibox({visible = false, ontop = true, type = "splash", screen = s})
    awful.placement.maximize(mask)
    mask.bg = beautiful.blackdark .. "25"
    mask.fg = beautiful.white
    return mask
end

-- Create the lock screen wibox
-- Set the type to "splash" and set all "splash" windows to be blurred in your
-- compositor configuration file
lock_screen = wibox({visible = false, ontop = true, type = "splash", screen = screen.primary})
awful.placement.maximize(lock_screen)

lock_screen.bg = beautiful.blackdark
lock_screen.fg = beautiful.grey

for s in screen do
    if s == screen.primary then
        s.mylockscreen = lock_screen
    else
        s.mylockscreen = screen_mask(s)
    end
end

local day_of_the_week = wibox.widget {
    font = "Pacifico 65",
    forced_width = dpi(800),
    align = "center",
    valign = "center",
    widget = wibox.widget.textclock("%A")
}

local function update_dotw()
    day_of_the_week.markup = helpers.colorize_text(day_of_the_week.text, beautiful.green)
end

update_dotw()

day_of_the_week:connect_signal("widget::redraw_needed", function ()
    update_dotw()
end)

local month = wibox.widget {
    font = beautiful.uifont .. " 80",
    align = "center",
    valign = "center",
    widget = wibox.widget.textclock("%B %d")
}

local time = wibox.widget {
     font = beautiful.uifont .. " 80",
    align = "center",
    valign = "center",
    widget = wibox.widget.textclock("%H:%M")
}


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
        forced_height = dpi(220),
        forced_width = dpi(220),
        shape = gears.shape.circle,
        widget = wibox.container.background
    },
    nil,
    expand = "none",
    layout = wibox.layout.align.horizontal
}


local user = os.getenv("USER")
-- Capitalize username
local username = wibox.widget.textbox(user:sub(1,1):upper()..user:sub(2))
username.font = "sans 30"
username.align = "center"
username.valign = "center"

local function update_month()
    month.markup = helpers.colorize_text(month.text:upper(), beautiful.blue.."35")
end

update_month()

month:connect_signal("widget::redraw_needed", function ()
    update_month()
end)

-- Lock animation
local lock_animation_widget_rotate = wibox.container.rotate()

local arc = function()
    return function(cr, width, height)
        gears.shape.arc(cr, width, height, dpi(5), 0, math.pi/2, true, true)
    end
end

local lock_animation_arc = wibox.widget {

--wibox.widget {
    wibox.widget.textbox(""),
    shape = arc(),
    bg = "#00000000",
    forced_width = dpi(90),
    forced_height = dpi(90),
    widget = wibox.container.background
}

local lock_animation_widget = {
    {
        lock_animation_arc,
        widget = lock_animation_widget_rotate
    },
    lock_animation_icon,
    layout = wibox.layout.stack
}

-- Lock helper functions
local characters_entered = 0
local function reset()
    characters_entered = 0;
    lock_animation_icon.markup = helpers.colorize_text(lock_screen_symbol, beautiful.grey)
    lock_animation_widget_rotate.direction = "north"
    lock_animation_arc.bg = "#00000000"
end

local function fail()
    characters_entered = 0;
    lock_animation_icon.markup = helpers.colorize_text(lock_screen_fail_symbol, beautiful.pink)
    lock_animation_widget_rotate.direction = "north"
    lock_animation_arc.bg = "#00000000"
end

local animation_colors = {
    beautiful.blue,
    beautiful.purple,
    beautiful.blue,
    beautiful.yellow,
    beautiful.blue,
    beautiful.purple,
}

local animation_directions = {"north", "west", "south", "east"}

-- Function that animates every key press
local function key_animation(char_inserted)
    local color
    local direction = animation_directions[(characters_entered % 4) + 1]
    if char_inserted then
        color = animation_colors[(characters_entered % 6) + 1]
        lock_animation_icon.text = lock_screen_symbol
    else
        if characters_entered == 0 then
            reset()
        else
            color = beautiful.blue .. "55"
        end
    end

    lock_animation_arc.bg = color
    lock_animation_widget_rotate.direction = direction
end

-- Get input from user
local function grab_password()
    awful.prompt.run {
        hooks = {
            -- Custom escape behaviour: Do not cancel input with Escape
            -- Instead, this will just clear any input received so far.
            {{ }, 'Escape',
                function(_)
                    reset()
                    grab_password()
                end
            }
        },
        keypressed_callback  = function(mod, key, cmd)
            -- Only count single character keys (thus preventing
            -- "Shift", "Escape", etc from triggering the animation)
            if #key == 1 then
                characters_entered = characters_entered + 1
                key_animation(true)
            elseif key == "BackSpace" then
                if characters_entered > 0 then
                    characters_entered = characters_entered - 1
                end
                key_animation(false)
            end
        end,
        exe_callback = function(input)
            -- Check input
            if input == password then
                -- YAY
                reset()
                for s in screen do
                    s.mylockscreen.visible = false
                end
            else
                -- NAY
                fail()
                grab_password()
            end
        end,
        textbox = some_textbox,
    }
end

function lock_screen_show()
    for s in screen do
        s.mylockscreen.visible = true
    end
    grab_password()
end

lock_screen:setup {
  nil,
{
    nil,
{
{  {        pic,
{         username,
          fg = beautiful.grey,
          widget = wibox.container.background },
{        lock_animation_widget,
          top = dpi(5),
          widget = wibox.container.margin
        },
          spacing = dpi(10),
          widget = wibox.layout.fixed.vertical,
      },
           top = dpi(20),
           left = dpi(300),
           right = dpi(50),
           widget  = wibox.container.margin,
      },
  {
                                forced_height = dpi(290),
                                forced_width = dpi(5),
                                shape = gears.shape.rectangle,
                                bg = beautiful.yellow,
                                widget = wibox.container.background
                            },
{  {
{
{         time,
          fg = beautiful.purple,
          widget = wibox.container.background      },
{         month,
          day_of_the_week,
          layout = wibox.layout.stack      },
          widget = wibox.layout.fixed.vertical

        },
      {{ nil,
        { poweroff,
          reboot,
          exit,
          spacing = dpi(30),
          widget = wibox.layout.fixed.horizontal        },
     expand = "none",
     layout = wibox.layout.align.horizontal        },
          top = dpi(10),
          widget = wibox.container.margin
        },
          spacing = dpi(10),
          widget = wibox.layout.fixed.vertical         },
          right = dpi(240),
          widget = wibox.container.margin
    },
spacing = dpi(0),
layout = wibox.layout.fixed.horizontal

},
     expand = "none",
     layout = wibox.layout.align.vertical
},
     expand = "none",
     layout = wibox.layout.align.horizontal

}
