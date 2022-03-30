local awful = require("awful")
local wibox = require("wibox")
local home = os.getenv("HOME")
local gears = require("gears")

-- Use AwesomeWM to set wallpaper ?, uses feh if false.
local useawesomewallpaper = true

-- set random wallpapers on startup/awesome restart ?.
local randomisewallpapers = true

-- to set random wallpaper from this dir, (you can chane it to any folder from your system)
local wallpaperdir = home .. "/.config/awesome/assets/wallpaper"

-- use this wallpaper if randomize is false
local wallpaper = home .. "/.config/awesome/assets/wallpaper/1.png"


-- AwesomeWM Wallpaper function.
local function awesomewallpaper()

-- wallpaper on each screen
  for s = 1, screen.count() do
    if randomisewallpapers then
      -- pick random picture from dir and set wallpaper
      screen.connect_signal("request::wallpaper", function(s)
        awful.wallpaper {
            screen = s,
            widget = {
              { image  = gears.filesystem.get_random_file_from_dir(wallpaperdir, {".jpg", ".png", ".svg", ".bmp"}, true ),
                resize = true,
                widget = wibox.widget.imagebox,
              },
                valign = "center",
                halign = "center",
                tiled  = false,
                widget = wibox.container.tile,
            }}
    end)

    else

     -- set given wallpaper
    screen.connect_signal("request::wallpaper", function(s)
        awful.wallpaper {
            screen = s,
            widget = {
                {
                    image     = wallpaper,
                    resize = true,
                    widget    = wibox.widget.imagebox,
                },
                valign = "center",
                halign = "center",
                tiled  = false,
                widget = wibox.container.tile,
            }
        }
        end)
    end
  end
end

-- use feh to set wallpaper.
local function fehwallpaper()
  if randomisewallpapers then
    -- pick random picture from dir and set wallpaper
    awful.spawn.with_shell( "feh -z --bg-scale " .. wallpaperdir)
    else
    -- set given wallpaper
    awful.spawn.with_shell( "feh --bg-scale " .. wallpaper)
  end
end

-- global function. use this function to set/reset wallpapers.
function setwallpaper()
if useawesomewallpaper then
    awesomewallpaper()
else
    fehwallpaper()
end
end

-- set wallpaper once
setwallpaper()
