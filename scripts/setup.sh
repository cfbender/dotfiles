#!/bin/bash

./symlink.sh
./pacmanInstall.sh
./flatpakinstall.sh
./programs.sh

# Get all upgrades
sudo pacman -Syyu

# Terminal setup
# Fish and fisher
sudo pacman -S fish
curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish
# Alacritty
sudo pacman -S alacritty
# neovim
sudo pacman -S neovim
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
sudo pacman -S tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# ripgrep
sudo pacman -S ripgrep
fisher

# screenshot util
sudo pacman -S maim xclip

# ranger dev icons
git clone https://github.com/alexanderjeurissen/ranger_devicons ~/.config/ranger/plugins/ranger_devicons
