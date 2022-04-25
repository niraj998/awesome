local gears = require("gears")
local awful = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup")
local apps = require("config.apps")

local modkey = "Mod4"
local alt = "Mod1"


--|M|o|u|s|e|--
--+-+-+-+-+-+--
root.buttons(gears.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))


--|K|e|y|b|o|a|r|d|--
--+-+-+-+-+-+-+-+-+--
globalkeys = gears.table.join(

--|A|w|e|s|o|m|e| |W|M|--
--+-+-+-+-+-+-+-+-+-+-+--
  awful.key({ modkey, }, "F1",      hotkeys_popup.show_help,
            {description="Hotkeys", group="Awesome"}),

  awful.key({ modkey, "Shift" }, "r", awesome.restart,
            {description = "Reload", group = "Awesome"}),

  awful.key({ modkey, "Shift"   }, "q", exit_screen_show,
            {description = "Quit", group = "Awesome"}),

  awful.key({ modkey }, "d", function()    _G.run.open()  end,
  	    { description = "Run awesome prompt", group = "Awesome" }),

  awful.key({ alt, "Shift" }, "d", function()    sidebar_toggle()  end,
  	    { description = "Run awesome prompt", group = "Awesome" }),

  awful.key({ modkey,  }, "Delete", exit_screen_show,
            {description = "Exitscreen", group = "Awesome"}),

  awful.key({ modkey, "Shift" }, "Delete", lock_screen_show,
            {description = "Lockscreen", group = "Awesome"}),

  awful.key({ modkey, "Shift" }, "/" , notifs_toggle,
            {description = "Notification Center", group = "Awesome"}),

--|C|u|s|t|o|m|--
--+-+-+-+-+-+-+--

  awful.key({ alt, }, "F1", function ()
        awful.spawn.with_shell("sh -c '$HOME/.config/rofi/mount/mountusb' ")         end,
            {description = "Mount Drive", group = "Custom"}),
  awful.key({ alt, }, "F2", function ()
        awful.spawn.with_shell("sh -c '$HOME/.config/rofi/mount/cellmount' ")         end,
            {description = "Mount Android", group = "Custom"}),
  awful.key({ alt, }, "F3", function ()
	awful.spawn.with_shell("sh -c '$HOME/.config/rofi/music/music' ")         end,
	    {description = "Music", group = "Custom"}),
  awful.key({ alt, }, "F4", function ()
        awful.spawn.with_shell("sh -c '$HOME/.config/rofi/wifi/wifi' ")         end,
            {description = "Wifi", group = "Custom"}),
  awful.key({ alt, }, "F5", function ()
        awful.spawn.with_shell("sh -c '$HOME/.config/rofi/screenshot/screenshot' ")         end,
            {description = "Screenshot", group = "Custom"}),
  awful.key({ alt, }, "F6", function ()
        awful.spawn.with_shell("sh -c '$HOME/.config/rofi/screen/screen' ")         end,
            {description = "Screen", group = "Custom"}),
  awful.key({ modkey, "Shift" }, "e", function ()
        awful.spawn.with_shell("rofi -config $HOME/.config/awesome/assets/configs/config.rasi -show filebrowser")         end,
            {description = "Screen", group = "Custom"}),



--|C|l|i|e|n|t|s|--
--+-+-+-+-+-+-+-+--
  awful.key({ modkey,  }, "h", function () awful.client.focus.byidx( 1) end,
            {description = "Focus on Next Client", group = "Clients"}),

  awful.key({ modkey,  }, "l", function () awful.client.focus.byidx(-1) end,
            {description = "Focus on Previous Client", group = "Clients"}),

  awful.key({ modkey,  }, "u", awful.client.urgent.jumpto,
            {description = "Jump to Urgent", group = "Clients"}),
  awful.key({ modkey,  }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
            {description = "Last Client", group = "Clients"}),

  awful.key({ modkey, "Shift" }, "l",     function () awful.tag.incmwfact( 0.05)          end,
            {description = "increase master width factor", group = "Clients"}),

  awful.key({ modkey, "Shift" }, "h",     function () awful.tag.incmwfact(-0.05)          end,
            {description = "decrease master width factor", group = "Clients"}),

  awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  if c then
                    c:emit_signal(
                        "request::activate", "key.unminimize", {raise = true}
                    )
                  end
              end,
              {description = "restore minimized", group = "Clients"}),

--|L|a|y|o|u|t|s|--
--+-+-+-+-+-+-+-+--
  awful.key({ modkey,  }, "Left", function () awful.screen.focus_relative( 1) end,
            {description = "Focus the next screen", group = "Screen"}),

  awful.key({ modkey,  }, "Right", function () awful.screen.focus_relative(-1) end,
            {description = "Focus the previous screen", group = "Screen"}),

  awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
            {description = "Increase the number of columns", group = "Layouts"}),

  awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
            {description = "Decrease the number of columns", group = "Layouts"}),

  awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
            {description = "Next layout", group = "Layouts"}),

  awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
            {description = "Previous layout", group = "Layouts"}),

--|L|a|u|n|c|h| |P|r|o|g|r|a|m|s|--
--+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+--

  awful.key({ modkey, }, "Return", function () awful.spawn(apps.terminal) end,
            {description = "Terminal", group = "Programs"}),

  awful.key({ modkey, "Shift" }, "Return", function () awful.spawn(apps.floatingterminal) end,
            {description = "Floating Terminal", group = "Programs"}),

  awful.key({ modkey, alt, }, "Return", function () awful.spawn(apps.fullscreenterminal) end,
            {description = "FullScreen Terminal", group = "Programs"}),

  awful.key({ modkey,           }, "r", function () awful.spawn(apps.run) end,
              {description = "run prompt", group = "Programs"}),

  awful.key({ modkey,           }, "w", function () awful.spawn(apps.browser) end,
              {description = "browser", group = "Programs"}),

  awful.key({ modkey,           }, "e", function () awful.spawn(apps.files) end,
              {description = "file browser", group = "Programs"}),

--|C|o|n|t|r|o|l|l|e|r|s|--
--+-+-+-+-+-+-+-+-+-+-+-+--
  awful.key({}, "XF86AudioLowerVolume", function ()
        awful.spawn.with_shell(apps.volumeless)
        sb_volume()
        end,
            {description = "Volume Down", group = "Controllers"}),

    awful.key({}, "XF86AudioRaiseVolume", function ()
        awful.spawn.with_shell(apps.volumeplus)
        sb_volume()
        end,
           {description = "Volume Down", group = "Controllers"}),

    awful.key({}, "XF86AudioMute", function ()
        awful.spawn.with_shell(apps.volumemute)
        sb_volume()
    end,
          {description = "Mute", group = "Controllers"}),

    awful.key({alt, }, "-", function ()
        awful.spawn.with_shell(apps.volumeless)
        sb_volume()
    end,
          {description = "Volume Down", group = "Controllers"}),

    awful.key({alt, }, "=", function ()
        awful.spawn.with_shell(apps.volumeplus)
        sb_volume()
    end,
          {description = "Volume Up", group = "Controllers"}),

    awful.key({alt, }, "0", function ()
        awful.spawn.with_shell(apps.volumemute)
        sb_volume()
    end,
          {description = "Mute", group = "Controllers"}),

    -- Brightness
   awful.key({ }, "XF86MonBrightnessDown", function ()
        awful.spawn.with_shell(apps.brightless)
   end,
             {description = "Brightness down", group = "Controllers"}),

   awful.key({ }, "XF86MonBrightnessUp", function ()
        awful.spawn.with_shell(apps.brightplus)
    end,
          {description = "Brightness up", group = "Controllers"})

)


clientkeys = gears.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "Clients"}),
    awful.key({ modkey,   }, "q",      function (c) c:kill()                         end,
              {description = "close", group = "Clients"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "Clients"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "Clients"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "Clients"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "Clients"}),
    awful.key({ modkey,           }, "n",
        function (c)
             c.minimized = true
        end ,
        {description = "minimize", group = "Clients"}),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "(un)maximize", group = "Clients"}),
    awful.key({ modkey, "Control" }, "m",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        {description = "(un)maximize vertically", group = "Clients"}),
    awful.key({ modkey, "Shift"   }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        {description = "(un)maximize horizontally", group = "Clients"})
)

-- Tags
for i = 1, 6 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag", group = "Tags"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag", group = "Tags"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag", group = "Tags"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag", group = "Tags"})
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

return keys
