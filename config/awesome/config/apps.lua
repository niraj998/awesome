--[[ These are used through out the awesome config.
make sure to have output of commands as same as below, if you change. ]]--

-- set your terminal.
local term = os.getenv("TERMINAL") or 'st'

-- different terminal handle class differently, set how your works here
local termclass = term .. " --class"

if term == 'st' then
termclass = term .. " -c"
end

local home = os.getenv("HOME")

return {
-- Apps
    -- use same classes as below for terminal.
    terminal =                term,
    floatingterminal =        termclass .. ' scrachpad',
    internet =                termclass .. ' net nmtui',
    fullscreenterminal =      termclass .. ' fullscreenterminal',
    mpd =                     termclass .. ' music ncmpcpp',
    musicalt =                'spotify',
    editor =                  term .. ' nvim',
    run =                     'rofi -config ' .. home .. '/.config/awesome/assets/configs/config.rasi  -show drun',
    browser =                 'brave',
    files =                   'thunar',
    bluetooth =               'blueberry',
    volumeapp  =              'pavucontrol',

-- Power
    power =                   'sudo shutdown -P now',
    restart =                 'sudo reboot',
    suspend =                 'systemctl suspend',

-- updates
    update =                  term .. ' sudo pacman -Syu',
    updates =                 'checkupdates | wc -l',

-- These are used for keyboard shortcuts and scrolling on bar widgets.

-- you can use amixer/brightnessctl script and they'll work fine. but you'll need pamixer and xbacklight in your system to get values.
-- Brightness
    brightplus =              'xbacklight -inc 1',
    brightless =              '[ "$(xbacklight -get | cut -d "." -f1 )" -gt 1 ] && xbacklight -dec 1 ',

-- Volume
    volumeplus =              'pamixer --allow-boost -i 3',
    volumeless =              'pamixer --allow-boost -d 3',
    volumemute =              'pamixer -t',
}
