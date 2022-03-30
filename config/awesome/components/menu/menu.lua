local awful = require("awful")
local beautiful = require("beautiful")
local hotkeys_popup = require("awful.hotkeys_popup")
local apps = require("config.apps")
local helpers = require("components.helpers")

-- Awesome menu
mymainmenu = awful.menu({ items = { { "Awesome", {  { "Hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
                                                    { "Restart", awesome.restart            },
                                                    { "Quit", function() awesome.quit() end },
                                                 }
                                    },

                                    { "Power", {    { "Power Off", apps.power                   },
                                                    { "Restart", apps.restart                   },
                                                    { "LogOut", apps.logout                     },
                                                    { "Lock", function() lock_screen_show() end },
                                               }
                                    },

                                    { "Browser", apps.browser                          },
                                    { "Terminal", apps.terminal                        },
                                    { "Launcher", apps.run                             },
                                    { "File Browser", apps.files                       },
                                    { "Music", apps.mpd                                },
                                    { "Editor", apps.editor                            },
                                    { "Set Wallpaper", function() setwallpaper() end   },
                                  },
})

mymainmenu.wibox.shape = helpers.rrect(beautiful.border_radius + 2)
