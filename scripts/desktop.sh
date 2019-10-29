#!/bin/bash

#Dracula theme

git clone git@github.com:EliverLara/Ant-Dracula.git ~/.themes/

gsettings set org.gnome.desktop.interface gtk-theme "Ant-Dracula"
gsettings set org.gnome.desktop.wm.preferences theme "Ant-Dracula"

git clone git@github.com:dracula/tilix.git /tmp/dracula-tilix
cp /tmp/dracula-tilix/Dracula.json ~/.config/tilix/schemes

rm -rf /tmp/dracula-tilix

FILE=/.config/gtk-3.0/gtk.css
if [ -f "$FILE" ]; then
    echo "$FILE already exists. Skipping."
else 
    cp ../.config/gtk-3.0/gtk.css  /.config/gtk-3.0/
fi

# zsh settings
git clone https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting