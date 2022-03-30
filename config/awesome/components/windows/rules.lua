local awful = require('awful')

--|r|u|l|e|s|--
--+-+-+-+-+-+--
awful.rules.rules = {
    { rule = { },
      properties = { focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
    }
    },
	-- Floating Clients
    { rule_any = {
      name = {
            "SimpleScreenRecorder",
    },
      class = {
          "music",
          "Gpick",
          "feh",
          "Lxappearance",
          "Xfce4-about",
          "mpv",
	  "net",
    },
    }, properties = { floating = true, x = 227, y = 128, width = 910, height = 512 }},

-- Maximized
   { rule_any = {
     class = {
          "Simple-scan",
          "Zathura",
          "Font-manager",
   },
   },
     properties = {  maximized = true }
   },

-- Sticky and Floating
   { rule_any = {
     class = {
         "Pavucontrol",
         "Blueberry",
         "scrachpad"
   },
   },
     properties = {  floating = true, ontop = true, sticky = true, placement = awful.placement.centered , width = 683, height = 384 }
   },

-- Full Screen
    { rule_any = {
      class = {
          "mpv",
          "fullscreenterminal"
    },
    },
      properties = {  fullscreen = true }
    },
}
