#!/bin/bash

function install {
  which $1 &> /dev/null

  if [ $? -ne 0 ]; then
    echo "Installing: ${1}..."
    install -S $1 --noconfirm
  else
    echo "Already installed: ${1}"
  fi
}

# Basics
install flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Image processing
install gimp

# Desktop stuff
install rofi

# Get all upgrades
sudo pacman -Syyu --noconfirm

# Terminal setup
# Fish and fisher
install -S fish
curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish
# Alacritty
install -S alacritty
# neovim
install -S neovim
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
# aura
oldDir=$(pwd)
git clone https://aur.archlinux.org/aura-bin.git
cd aura-bin
makepkg -si
cd ..
rm -rf aura-bin
cd $oldDir
# tmux and tpm
install -S tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# ripgrep
install -S ripgrep
fisher

# screenshot util
install -S maim xclip

# ranger dev icons
git clone https://github.com/alexanderjeurissen/ranger_devicons ~/.config/ranger/plugins/ranger_devicons
