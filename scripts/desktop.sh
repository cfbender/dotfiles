#!/bin/bash

# Desktop stuff
sudo pacman -S i3-gaps rofi picom nitrogen morc_menu dmenu wmctrl bmenu polybar

sudo cp ../plasma-i3.desktop /usr/share/xsessions/
sudo cp ../plasma-qtile.desktop /usr/share/xsessions/

sudo xrdb ~/.Xresources

sudo cp ../assets/*.ttf /usr/share/fonts/
sudo fc-cache
