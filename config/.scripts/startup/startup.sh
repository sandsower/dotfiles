#!/bin/bash 

# Core components (order is important!)
(
    feh --bg-fill ~/.wallpapers/Space_Spiral_Nord.png &
    (
        picom -b 
        ~/xborder/xborders -c ~/.config/picom/xborder.json
    ) &
    # ~/.config/polybar/launch.sh
) &

# Services
dbus-launch dunst --config ~/.config/dunst/dunstrc &
