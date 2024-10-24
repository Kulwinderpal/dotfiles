#!/bin/sh

# Install the Prerequistories
sudo add-apt-repository universe
sudo apt update
sudo apt install git hyprland sway-notification-center alacritty waybar polkit-kde-agent-1

# Install Yazi
sudo apt install cargo
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
rustup update
cargo install --locked yazi-fm yazi-cli

# Compile xdg-desktop-portal-hyprland
sudo apt install hyprland-protocols hyprlang hyprutils hyprwayland-scanner libdrm pipewire sdbus-cpp
git clone --recursive https://github.com/hyprwm/xdg-desktop-portal-hyprland
cd xdg-desktop-portal-hyprland/
cmake -DCMAKE_INSTALL_LIBEXECDIR=/usr/lib -DCMAKE_INSTALL_PREFIX=/usr -B build
cmake --build build
sudo cmake --install build

# Compile Rofi
sudo apt install make autoconf automake pkg-config flex bison check
git clone https://github.com/lbonn/rofi.git ~/
cd rofi
git pull
git submodule update --init
autoreconf -i

# Compile Hyprpicker
sudo apt install cmake cairo pango1.0
git clone https://github.com/hyprwm/hyprpicker.git ~/
cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
cmake --build ./build --config Release --target hyprpicker -j`nproc 2>/dev/null || getconf _NPROCESSORS_CONF`
cmake --install ./build

# Install waypaper
sudo apt install python-pipx
pipx install waypaper

# Compile Hyprshot
git clone https://github.com/Gustash/hyprshot.git ~/
sudo ln -s ~/hyprshot/hyprshot /usr/share/applications/hyprshot
chmod +x Hyprshot/hyprshot


# Use the Hyprland Configuration
mkdir -p ~/.config/hypr/ ~/.config/rofi ~/.config/waybar
echo "# EDIT THIS ACCORDING TO THE WIKI INSTRUCTIONS.

# Refer to the wiki for more information.
# https://wiki.hyprland.org/Configuring/Configuring-Hyprland/

# Please note not all available settings / options are set here.
# For a full list, see the wiki

# You can split this configuration into multiple files
# Create your files separately and then link them to this file like this:
# source = ~/.config/hypr/myColors.conf


################
### MONITORS ###
################

# See https://wiki.hyprland.org/Configuring/Monitors/
monitor=,preferred,auto,auto


###################
### MY PROGRAMS ###
###################

# See https://wiki.hyprland.org/Configuring/Keywords/

# Set programs that you use
$terminal = alacritty
$browser = firefox
$fileManager = dolphin
$menu = rofi -show drun

#################
### AUTOSTART ###
#################

# Autostart necessary processes (like notifications daemons, status bars, etc.)

exec-once = waybar & hyprpaper & $terminal & swaync & systemctl --user start plasma-polkit-agent


#############################
### ENVIRONMENT VARIABLES ###
#############################

# See https://wiki.hyprland.org/Configuring/Environment-variables/

env = XCURSOR_SIZE,32
env = HYPRCURSOR_SIZE,32

#####################
### LOOK AND FEEL ###
#####################

# Refer to https://wiki.hyprland.org/Configuring/Variables/

# https://wiki.hyprland.org/Configuring/Variables/#general
general { 
    gaps_in = 5
    gaps_out = 14

    border_size = 2

    # https://wiki.hyprland.org/Configuring/Variables/#variable-types for info about colors
    col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
    col.inactive_border = rgba(595959aa)

    # Set to true enable resizing windows by clicking and dragging on borders and gaps
    resize_on_border = false 

    # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
    allow_tearing = false

    layout = dwindle
}

# https://wiki.hyprland.org/Configuring/Variables/#decoration
decoration {
    rounding = 7

    # Change transparency of focused and unfocused windows
    active_opacity = 0.9
    inactive_opacity = 0.8

    drop_shadow = true
    shadow_range = 4
    shadow_render_power = 3
    col.shadow = rgba(1a1a1aee)
    windowrule = opacity 0.8 override 1.0 $terminal

    # https://wiki.hyprland.org/Configuring/Variables/#blur
    blur {
        enabled = true
        size = 8
        passes = 2
         new_optimizations = yes
        ignore_opacity=true
        
        vibrancy = 0.1696
    }
}

# https://wiki.hyprland.org/Configuring/Variables/#animations
animations {
    enabled = true

    # Default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

    bezier = myBezier, 0.05, 0.9, 0.1, 1.05

    animation = windows, 1, 7, myBezier
    animation = windowsOut, 1, 7, default, popin 80%
    animation = border, 1, 10, default
    animation = borderangle, 1, 8, default
    animation = fade, 1, 7, default
    animation = workspaces, 1, 6, default
}

# See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
dwindle {
    pseudotile = true # Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
    preserve_split = true # You probably want this
}

# See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
master {
    new_status = master
}

# https://wiki.hyprland.org/Configuring/Variables/#misc
misc { 
    force_default_wallpaper = -1 # Set to 0 or 1 to disable the anime mascot wallpapers
    disable_hyprland_logo = false # If true disables the random hyprland logo / anime girl background. :(
}


#############
### INPUT ###
#############

# https://wiki.hyprland.org/Configuring/Variables/#input
input {
    kb_layout = us
    kb_variant =
    kb_model =
    kb_options =
    kb_rules =

    follow_mouse = 1

    sensitivity = 0 # -1.0 - 1.0, 0 means no modification.

    touchpad {
        natural_scroll = false
        disable_while_typing = false

    }
}

# https://wiki.hyprland.org/Configuring/Variables/#gestures
gestures {
    workspace_swipe = true
}

# Example per-device config
# See https://wiki.hyprland.org/Configuring/Keywords/#per-device-input-configs for more
device {
    name = epic-mouse-v1
    sensitivity = -0.5
}


###################
### KEYBINDINGS ###
###################

# See https://wiki.hyprland.org/Configuring/Keywords/
$mainMod = SUPER # Sets "Windows" key as main modifier

# Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
bind = $mainMod, Q, exec, $terminal 
bind = $mainMod, B, exec, $browser
bind = $mainMod, C, killactive,
bind = $mainMod, M, exit,
bind = $mainMod, D, exec, $fileManager
bind = $mainMod, F, togglefloating,
bind = $mainMod, R, exec, $menu
bind = $mainMod, P, pseudo, # dwindle
bind = $mainMod, J, togglesplit, # dwindle
bind = , PRINT, exec, hyprshot -m region -o ~/Pictures/Screenshots/

# Resize the Active Window
bind = $mainMod SHIFT, right, resizeactive, 10 0
bind = $mainMod SHIFT, left, resizeactive, -10 0
bind = $mainMod SHIFT, up, resizeactive, 0 -10
bind = $mainMod SHIFT, down, resizeactive, 0 10

# Move focus with mainMod + arrow keys
bind = $mainMod, left, movefocus, l
bind = $mainMod, right, movefocus, r
bind = $mainMod, up, movefocus, u
bind = $mainMod, down, movefocus, d

# Switch workspaces with mainMod + [0-9]
bind = $mainMod, 1, workspace, 1
bind = $mainMod, 2, workspace, 2
bind = $mainMod, 3, workspace, 3
bind = $mainMod, 4, workspace, 4
bind = $mainMod, 5, workspace, 5
bind = $mainMod, 6, workspace, 6
bind = $mainMod, 7, workspace, 7
bind = $mainMod, 8, workspace, 8
bind = $mainMod, 9, workspace, 9
bind = $mainMod, 0, workspace, 10

# Move active window to a workspace with mainMod + SHIFT + [0-9]
bind = $mainMod SHIFT, 1, movetoworkspace, 1
bind = $mainMod SHIFT, 2, movetoworkspace, 2
bind = $mainMod SHIFT, 3, movetoworkspace, 3
bind = $mainMod SHIFT, 4, movetoworkspace, 4
bind = $mainMod SHIFT, 5, movetoworkspace, 5
bind = $mainMod SHIFT, 6, movetoworkspace, 6
bind = $mainMod SHIFT, 7, movetoworkspace, 7
bind = $mainMod SHIFT, 8, movetoworkspace, 8
bind = $mainMod SHIFT, 9, movetoworkspace, 9
bind = $mainMod SHIFT, 0, movetoworkspace, 10

# Example special workspace (scratchpad)
bind = $mainMod, S, togglespecialworkspace, magic
bind = $mainMod SHIFT, S, movetoworkspace, special:magic

# Scroll through existing workspaces with mainMod + scroll
bind = $mainMod, mouse_down, workspace, e+1
bind = $mainMod, mouse_up, workspace, e-1

# Move/resize windows with mainMod + LMB/RMB and dragging
bindm = $mainMod, mouse:272, movewindow
bindm = $mainMod, mouse:273, resizewindow

# Laptop multimedia keys for volume and LCD brightness
bindel = ,XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
bindel = ,XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
bindel = ,XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
bindel = ,XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
bindel = ,XF86MonBrightnessUp, exec, brightnessctl s 10%+
bindel = ,XF86MonBrightnessDown, exec, brightnessctl s 10%-

##############################
### WINDOWS AND WORKSPACES ###
##############################

# See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
# See https://wiki.hyprland.org/Configuring/Workspace-Rules/ for workspace rules

# Example windowrule v1
# windowrule = float, ^(kitty)$

# Example windowrule v2
# windowrulev2 = float,class:^(kitty)$,title:^(kitty)$

windowrulev2 = suppressevent maximize, class:.* # You'll probably like this." > ~/.config/hypr/hyprland.conf

# Use the Rofi Configuration file
echo "configuration {
  display-drun:"Applications";
  display-window: "Windows";
  drun-display-format: "{icon} {name}";
  font: "ComicNeue Regular 14";
  modi: "window,run,drun";
  show-icons: true;
}

@theme "/dev/null"

* {
    text-color:  #dcdfe4;
    background-color:  rgba(40,44,52,0);
    dark: #1c1c1c;
    // Black
    black:       #282c34;
    lightblack:  #383a42;
    //
    // Red
    red:         #e06c75;
    lightred:    #e45649;
    //
    // Green
    green:       #98c379;
    lightgreen:  #50a14f;
    //
    // Yellow
    yellow:      #e5c07b;
    lightyellow: #c18401;
    //
    // Blue
    blue:      #61afef;
    lightblue: #0184bc;
    //
    // Magenta
    magenta:      #c678dd;
    lightmagenta: #a626a4;
    //
    // Cyan
    cyan:      #56b6c2;
    lightcyan: #0997b3;
    //
    // White
    white:      #dcdfe4;
    lightwhite: #fafafa;
    //
    // Bold, Italic, Underline
    highlight:     bold #fafafa;
}
window {
    height:   100%;
    width: 30em;
    location: west;
    anchor:   west;
    border:  0px 2px 0px 0px;
    text-color: @lightwhite;
}
mode-switcher {
    border: 2px 0px 0px 0px;
    background-color: @lightblack;
    padding: 4px;
}
button selected {
    border-color: @lightgreen;
    text-color: @lightgreen;
}
inputbar {
    background-color: @lightblack;
    text-color: @lightgreen;
    padding: 4px;
    border: 0px 0px 2px 0px;
}
mainbox {
    expand: true;
    background-color: #1c1c1cee;
    spacing: 1em;
}
listview {
    padding: 0em 0.4em 0em 1em;
    dynamic: false;
    lines: 0;
}
element-text {
    background-color: inherit;
    text-color:       inherit;
}
element selected  normal {
    background-color: @blue;
}
element normal active {
    text-color: @lightblue;
}
element normal urgent {
    text-color: @lightred;
}
element alternate normal {
}
element alternate active {
    text-color: @lightblue;
}
element alternate urgent {
    text-color: @lightred;
}
element selected active {
    background-color: @lightblue;
    text-color: @dark;
}
element selected urgent {
    background-color: @lightred;
    text-color: @dark;
}
error-message {
    expand: true;
    background-color: red;
    border-color: darkred;
    border: 2px;
    padding: 1em;
}" > ~/.config/rofi/config.rasi

# Use the Waybar Configuration Files
echo "@define-color bg #1f2329;
@define-color bg1 #282c34;
@define-color bg2 #30363f;
@define-color bg3 #323641;
@define-color bg_blue #61afef;
@define-color bg_d #181b20;
@define-color bg_yellow #e8c88c;
@define-color black #0e1013;
@define-color blue #4fa6ed;
@define-color cyan #48b0bd;
@define-color dark_cyan #266269;
@define-color dark_purple #7e3992;
@define-color dark_red #8b3434;
@define-color dark_yellow #835d1a;
@define-color fg #a0a8b7;
@define-color green #8ebd6b;
@define-color grey #535965;
@define-color light_grey #7a818e;
@define-color orange #cc9057;
@define-color purple #bf68d9;
@define-color red #e55561;
@define-color yellow #e2b86b;

* {
  font-family: "ComicNeue";
  font-size: 14px;
  margin: 0;
  padding: 0;
}

window#waybar {
  background: @bg;
  color: @fg;
  border-radius: 5px;
  border: none;
  padding: 0 2px;
}

#workspaces {
  margin-left: .5em;
  padding: .2em;
}

#workspaces > button {
  font-weight: bold;
  border-radius: 3px;
  padding: 0 .4em;
  margin: 0;
}

#workspaces > button.active {
  font-size: 1em;
  color: @bg1;
  background: @blue;
}

#window {
  background: @bg1;
  padding: 0 1em;
  border-radius: 1em;
  margin:  5px;
}

#clock,
#backlight.value,
#network.value,
#memory.value,
#cpu.value,
#battery.value {
  font-size: 1em;
  margin: 5px .5em 5px 0;
  padding: 0 1em 0 .5em;
  border-radius: 0 1em 1em 0;
  background: @bg1;
}

#custom-clock-icon,
#backlight.icon,
#network.icon,
#memory.icon,
#cpu.icon,
#battery.icon {
  font-size: 1em;
  margin: 5px 0 5px .5em;
  padding: 0 .5em 0 .5em;
  border-radius: 1em 0 0 1em;
  background: @fg;
  color: @bg1;
}
#custom-clock-icon {
  background: @green;
}
#backlight.icon {
  background: @yellow;
}
#network.icon {
  background: @purple;
}
#memory.icon {
  background: @red;
}
#cpu.icon {
  background: @cyan;
}

#battery.icon {
  background: @blue;
}
#battery.icon.warning {
  background: @yellow;
}
#battery.icon.critical {
  background: @red;
}
#battery.icon.charging {
  background: @green;
}

#clock {
  color: @green;
}
#backlight.value {
  color: @yellow;
}
#network.value {
  color: @purple;
}
#cpu.value {
  color: @cyan;
}
#memory.value {
  color: @red;
}

#battery.value {
  color: @blue;
}
#battery.value.warning {
  color: @yellow;
}
#battery.value.critical {
  color: @red;
}
#battery.value.charging {
  color: @green;
}

#custom-notification {
  border-radius: 1em;
  font-size: 1em;
  margin: 5px 0 5px .5em;
  padding: 0 .5em 0 .5em;
  background: @yellow;
  color: @bg1;
}" > ~/.config/waybar/style.css

echo "{
  "margin": "2",
  "modules-left": [
    "hyprland/workspaces",
    "hyprland/window"
  ],
  "modules-center": [
    "custom/notification",
    "custom/clock-icon",
    "clock",
    "tray"
  ],
  "modules-right": [
    "backlight#icon",
    "backlight#value",
    "network#icon",
    "network#value",
    "cpu#icon",
    "cpu#value",
    "memory#icon",
    "memory#value",
    "battery#icon",
    "battery#value"
  ],
  "custom/notification": {
    "tooltip": false,
    "format": "{icon}",
    "format-icons": {
      "notification": "<span foreground='red'><sup></sup></span>",
      "none": " ",
      "dnd-notification": "<span foreground='red'><sup></sup></span>",
      "dnd-none": " ",
      "inhibited-notification": "<span foreground='red'><sup></sup></span>",
      "inhibited-none": " ",
      "dnd-inhibited-notification": "<span foreground='red'><sup></sup></span>",
      "dnd-inhibited-none": " "
    },
    "return-type": "json",
    "exec-if": "which swaync-client",
    "exec": "swaync-client -swb",
    "on-click": "swaync-client -t -sw",
    "on-click-right": "swaync-client -d -sw",
    "escape": true
  },
  "hyprland/workspaces": {
    "format": "{icon}"
  },
  "hyprland/window": {
    "format": "{title}",
    "max-length": 40,
    "icon": true,
    "icon-size": 18
  },
  "custom/clock-icon": {
    "format": " "
  },
  "clock": {
    "interval": 1,
    "format": "{:%H:%M:%S}",
    "format-alt": "  {:%A, %B %d, %Y (  %H:%M)}",
    "tooltip-format": "<tt><small>{calendar}</small></tt>",
    "calendar": {
      "mode": "year",
      "mode-mon-col": 3,
      "weeks-pos": "right",
      "on-scroll": 1,
      "format": {
        "months": "<span color='#ffead3'><b>{}</b></span>",
        "days": "<span color='#ecc6d9'><b>{}</b></span>",
        "weeks": "<span color='#99ffdd'><b>W{}</b></span>",
        "weekdays": "<span color='#ffcc66'><b>{}</b></span>",
        "today": "<span color='#ff6699'><b><u>{}</u></b></span>"
      }
    },
    "actions": {
      "on-click-right": "mode",
      "on-click-forward": "tz_up",
      "on-click-backward": "tz_down",
      "on-scroll-up": "shift_up",
      "on-scroll-down": "shift_down"
    }
  },
  "tray": {
    "icon-size": 16,
    "spacing": 5
  },
  "backlight#icon": {
    "format": "{icon}",
    "format-icons": [
      "󰃞 ",
      "󰃝 ",
      "󰃟 ",
      "󰃠 "
    ]
  },
  "backlight#value": {
    "format": "{percent}%"
  },
  "network#icon": {
    "interval": 10,
    "format": "()",
    "format-wifi": "󰖩 ",
    "format-ethernet": " ",
    "format-disconnected": " ",
    "tooltip-format": " ",
    "tooltip-format-wifi": "󰖩 ",
    "tooltip-format-ethernet": " ",
    "tooltip-format-disconnected": " ",
    "max-length": 2,
    "on-click": "alacritty -e nmtui"
  },
  "network#value": {
    "interval": 10,
    "format": "{ifname}",
    "format-wifi": "{essid} ({signalStrength}%)",
    "format-ethernet": "{ipaddr}/{cidr}",
    "format-disconnected": "Disconnected",
    "tooltip-format": "{ifname} via {gwaddr}",
    "tooltip-format-wifi": "{essid} ({signalStrength}%)",
    "tooltip-format-ethernet": "{ifname}",
    "tooltip-format-disconnected": "Disconnected",
    "max-length": 30,
    "on-click": "alacritty -e nmtui"
  },
  "memory#icon": {
    "interval": 10,
    "format": " ",
    "on-click": "alacritty -e btop"

  },
  "memory#value": {
    "interval": 10,
    "format": "{used:0.1f}/{total:0.1f}G",
    "on-click": "alacritty -e btop"
  },
  "cpu#icon": {
    "interval": 10,
    "format": " ",
    "on-click": "alacritty -e btop"
  },
  "cpu#value": {
    "interval": 10,
    "format": "{usage}%",
    "on-click": "alacritty -e btop"
  },
  "battery#icon": {
    "interval": 1,
    "states": {
      "warning": 30,
      "critical": 15
    },
    "format": "{icon}",
    "format-charging": " ",
    "format-icons": [
      " ",
      " ",
      " ",
      " ",
      " "
    ],
    "max-length": 2
  },
  "battery": {
    "interval": 1,
    "states": {
      "warning": 30,
      "critical": 15
    },
    "format": "{capacity}%",
    "format-charging": "{capacity}%",
    "max-length": 5
  },
  "reload_style_on_change": true
}" > ~/.config/waybar/config.jsonc
