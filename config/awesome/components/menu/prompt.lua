local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local helpers = require("components.helpers")
_G.run = {}

-- Awesome run launcher
local function promptwidget(prompt, opts)
    return awful.popup {
      widget = {
      prompt,
      top = dpi(15),
      bottom = dpi(15),
      left = dpi(15),
      right = dpi(30),
      widget = wibox.container.margin,
      },
    ontop = true,
    placement = awful.placement.centered,
    visible = false,
    border_color = beautiful.bluealt,
    border_width = dpi(3),
    bg = beautiful.black,
    shape = helpers.rrect(dpi(6))
  }
end

local prompt = awful.widget.prompt {
  prompt = "Run:",
  done_callback = function()
    _G.run.close()
  end,
}

local promptwgt = promptwidget(prompt)

-- toggle on and off.
function _G.run.open()
  promptwgt.visible = true
  prompt:run()
end

function _G.run.close()
   promptwgt.visible = false
end
