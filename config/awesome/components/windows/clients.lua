require("awful.autofocus")
local awful = require('awful')
local gears = require('gears')
local beautiful = require('beautiful')
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local helpers = require("components.helpers")

require("components.windows.better-resize")

--|f|o|c|u|s| |f|o|l|l|o|w|s| |m|o|u|s|e|--
--+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+--
client.connect_signal("mouse::enter", function(c)
    c:activate { context = "mouse_enter", raise = false }
end)

--|w|i|n|d|o|w|s| |m|a|n|a|g|e|m|e|n|t|--
--+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+--
-- better client management
-- inspired from marterial shell --

local function renderClient(client, mode)

  if client.class == 'music' then
    client.border_width = 0
     client.shape = helpers.rrect(beautiful.border_radius + 4)
    return
  elseif client.class == 'Thunar' then
     client.border_width = 0
     client.shape = helpers.rrect(beautiful.border_radius + 4)
    return
  end

  if client.skip_decoration or (client.rendering_mode == mode) then
     return
  end

  if client.fullscreen then
       client.rendering_mode = "maximize"
  elseif client.maximized then
       client.rendering_mode = "maximize"
  elseif client.maximized_horizontal then
       client.rendering_mode = "maximize"
  elseif client.maximized_vertical then
       client.rendering_mode = "maximize"
  elseif client.floating then
     client.rendering_mode = "floating"
  else
       client.rendering_mode = mode
  end


  if client.rendering_mode == 'maximize' then
     awful.titlebar.hide(client, beautiful.titlebar_position)
     client.border_width = 0
     client.shape = function(cr, w, h)     gears.shape.rectangle(cr, w, h)     end
  elseif client.rendering_mode == 'floating' then
     client.border_width = beautiful.border_width + 1
     awful.titlebar.show(client, beautiful.titlebar_position)
     client.shape = helpers.rrect(beautiful.border_radius + 6 )
  elseif client.rendering_mode == 'tile' then
     awful.titlebar.hide(client, beautiful.titlebar_position)
     client.border_width = beautiful.border_width
     client.shape = helpers.rrect(beautiful.border_radius + 2  )
  elseif  client.rendering_mode == 'other' then
     client.border_width = beautiful.border_width
     awful.titlebar.show(client, beautiful.titlebar_position)
     client.shape = helpers.rrect(beautiful.border_radius + 4  )
  end
end

local changesonclient = false

local function changesonscreen(currentScreen)
local maxtag = currentScreen.selected_tag ~= nil and currentScreen.selected_tag.layout == awful.layout.suit.max
local floatingtag =  currentScreen.selected_tag.layout == awful.layout.suit.floating
local fullscntag =  currentScreen.selected_tag.layout == awful.layout.suit.fullscreen
local tiled =  currentScreen.selected_tag.layout == awful.layout.suit.tile
local clientsToManage = {}

for _, client in pairs(currentScreen.clients) do
  if not client.skip_decoration and not client.hidden then
    table.insert(clientsToManage, client)
  end
end

if (maxtag) then
   currentScreen.client_mode = 'maximize'
elseif (floatingtag) then
   currentScreen.client_mode = 'floating'
elseif (fullscntag) then
   currentScreen.client_mode = 'maximize'
elseif (#clientsToManage == 1) then
   currentScreen.client_mode = 'maximize'
elseif (tiled) then
   currentScreen.client_mode = 'tile'
else
   currentScreen.client_mode = 'other'
end

for _, client in pairs(clientsToManage) do
   renderClient(client, currentScreen.client_mode)
end
  changesonclient = false
end

function callclients(client)
  if not changesonclient then
    if not client.skip_decoration and client.screen then
        changesonclient = true
        local screen = client.screen
        gears.timer.delayed_call( function() changesonscreen(screen) end)
    end
  end
end

function calltags(tag)
  if not changesonclient then
    if tag.screen then
      changeonclient = true
      local screen = tag.screen
      gears.timer.delayed_call( function() changesonscreen(screen) end)
    end
  end
end

_G.client.connect_signal('manage', callclients)
_G.client.connect_signal('unmanage', callclients)
_G.client.connect_signal('property::hidden', callclients)
_G.client.connect_signal('property::minimized', callclients)
_G.client.connect_signal('property::fullscreen', callclients)
_G.tag.connect_signal('property::selected', calltags)
_G.tag.connect_signal('property::layout', calltags)


--|A|d|d| |C|l|i|e|n|t| |B|o|r|d|e|r|s|--
--+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+--
_G.client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
_G.client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
