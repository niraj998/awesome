local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()
local gears = require("gears")
local icondir = gfs.get_configuration_dir() .. "assets/icons/"


-- inherit default theme
local theme = dofile(themes_path.."default/theme.lua")
-- load vector assets' generators for this theme

-- Fonts
theme.iconfont = 'FiraCode Nerd Font '
theme.uifont = 'FiraSans '
--theme.uifont = 'Digital-7 '
theme.font = theme.iconfont .. " 12"

-- Colors --
theme.transparent = "#00000000"
theme.background = "#1E222A"
theme.blue = '#61AFEF'
theme.green = '#7EC7A2'
theme.pink = '#D46489'
theme.red = '#E06C75'
theme.yellow = '#EBCB8B'
theme.white = '#D8DEE9'
theme.purple = '#C678DD'
theme.black = '#1E222A'
theme.blackalt = '#252931'
theme.bluealt = '#253140'
theme.grey = '#545862'
theme.orange = '#CAAA6A'
theme.blackdark = "#15181E"

-- userpic
theme.profile = icondir .. "others/profile.png"

-- background
theme.bg_normal     = theme.black
theme.bg_focus      = theme.black
theme.bg_urgent     = theme.black
theme.bg_minimize   = theme.black
theme.bg_systray    = theme.bluealt

-- Foreground
theme.fg_normal     = theme.white
theme.fg_focus      = theme.white
theme.fg_urgent     = theme.white
theme.fg_minimize   = theme.white
theme.fg_occupied   = theme.white

-- Systray
theme.systray_icon_spacing = dpi(8)

-- Clients
theme.useless_gap  = dpi(3)
theme.gap_single_client = false
theme.border_width  = dpi(3)
theme.border_normal = theme.black
theme.border_focus  = theme.bluealt
theme.border_marked = theme.white
theme.border_radius = dpi(6)

-- Tasklist
theme.tasklist_font = theme.uifont .. " 12"
theme.tasklist_bg_normal = theme.bluealt
theme.tasklist_bg_focus = theme.blue .. "55"
theme.tasklist_bg_urgent = theme.pink .. "55"
-- theme.tasklist_fg_focus = theme.white
-- theme.tasklist_fg_urgent = theme.white
-- theme.tasklist_fg_normal = theme.white

-- snap
theme.snap_shape = gears.shape.rectangle
theme.snap_bg = theme.bluealt
theme.snap_border_width = dpi(15)

-- titlebar
theme.titlebar_bg_focus = theme.bluealt
theme.titlebar_bg = theme.black
-- theme.titlebar_fg_focus = theme.white
-- theme.titlebar_fg_normal = theme.white
theme.titlebar_size = dpi(25)
theme.titlebar_position = "right"

-- titlebar icons
theme.titlebar_close_button_normal = icondir .. "titlebar/closenormal.png"
theme.titlebar_close_button_focus  = icondir .. "titlebar/closefocus.png"
theme.titlebar_minimize_button_normal = icondir .. "titlebar/minnormal.png"
theme.titlebar_minimize_button_focus  = icondir .. "titlebar/minfocus.png"
theme.titlebar_maximized_button_normal_inactive = icondir .. "titlebar/maxnormal.png"
theme.titlebar_maximized_button_focus_inactive  = icondir .. "titlebar/maxfocus.png"
theme.titlebar_maximized_button_normal_active = icondir .. "titlebar/maxnormal.png"
theme.titlebar_maximized_button_focus_active  = icondir .. "titlebar/maxfocus.png"
theme.notification_icon = icondir .. "others/notification.svg"

-- tooltip
theme.tooltip_fg = theme.white
theme.tooltip_bg = theme.black

-- menu
theme.menu_submenu_icon = icondir .. "others/forward.png"
theme.menu_height = dpi(25)
theme.menu_width  = dpi(180)
theme.menu_font = theme.uifont .. " 12"
theme.menu_border_color = theme.blackalt
theme.menu_border_width = dpi(2)
theme.menu_fg_normal = theme.white
theme.menu_bg_normal = theme.blackdark .. "99"
theme.menu_fg_focus = theme.black
theme.menu_bg_focus = theme.blue

-- icons
theme.icon_theme = "/usr/share/icons/Papirus"

-- Hotkeys
theme.hotkeys_bg = theme.blackdark .. "DD"
theme.hotkeys_border_color = theme.black
theme.hotkeys_font = theme.uifont .. " 11"
theme.hotkeys_description_font = theme.uifont .. " 11"
theme.hotkeys_group_margin = dpi(15)
theme.hotkeys_label_bg = theme.blue
theme.hotkeys_label_fg = theme.black
theme.hotkeys_fg =  theme.white
theme.hotkeys_modifiers_fg = theme.white

-- Pacman Taglist
theme.taglist_text_font = theme.iconfont .. " 15"
--theme.taglist_text_empty = {"●", "●", "●", "●", "●", "●", "●", "●", "●", "●"}
--theme.taglist_text_empty = {"", "", "", "", "", "", "", "", "", ""}
theme.taglist_text_empty = {"•", "•", "•", "•", "•", "•", "•", "•", "•", "•"}
theme.taglist_text_occupied = { "","", "", "", "", "", "", "", "", "" }
theme.taglist_text_focused = { "󰮯", "󰮯", "󰮯", "󰮯", "󰮯", "󰮯", "󰮯", "󰮯", "󰮯", "󰮯" }
theme.taglist_text_urgent =  { "", "", "", "", "", "", "", "", "",  "" }

theme.taglist_text_color_urgent   = { theme.red, theme.red, theme.orange, theme.pink, theme.yellow, theme.orange, theme.red, theme.red, theme.yellow, theme.orange }
theme.taglist_text_color_empty    = { theme.yellow, theme.yellow, theme.yellow, theme.yellow, theme.yellow, theme.yellow, theme.yellow, theme.yellow, theme.yellow, theme.yellow }
theme.taglist_text_color_focused    = { theme.yellow, theme.yellow, theme.yellow, theme.yellow, theme.yellow, theme.yellow, theme.yellow, theme.yellow, theme.yellow, theme.yellow }
-- colorful ghosts
--theme.taglist_text_color_occupied    = { theme.red, theme.purple, theme.green, theme.yellow, theme.purple, theme.red, theme.green, theme.purple, theme.red, theme.green }
-- blue ghosts
theme.taglist_text_color_occupied    = { theme.blue, theme.blue, theme.blue, theme.blue, theme.blue, theme.blue, theme.blue, theme.blue, theme.blue, theme.blue }


-- Old Taglist
theme.taglist_fg_empty = theme.grey
theme.taglist_fg_occupied =  theme.green
theme.taglist_fg_urgent = theme.red
theme.taglist_fg_focus = theme.blue
theme.taglist_fg_occupied =  theme.purple
theme.taglist_fg_urgent = theme.red
theme.taglist_fg_focus = theme.blue
theme.taglist_bg_empty = theme.bluealt
theme.taglist_bg_occupied =  theme.bluealt
theme.taglist_bg_urgent = theme.bluealt
theme.taglist_bg_focus = theme.bluealt
theme.taglist_font = theme.iconfont .. " 16"

-- No taglist squares
local taglist_square_size = dpi(0)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
     taglist_square_size, theme.fg_normal)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
    taglist_square_size, theme.fg_normal)

return theme
