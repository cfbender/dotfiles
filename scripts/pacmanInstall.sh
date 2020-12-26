#!/bin/bash

function install {
  which $1 &> /dev/null

  if [ $? -ne 0 ]; then
    echo "Installing: ${1}..."
    sudo pacman -S $1 --noconfirm
  else
    echo "Already installed: ${1}"
  fi
}

# Basics
install flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Image processing
install gimp

# Get all upgrades
sudo pacman -Syyu --noconfirm

# Terminal setup
# Fish and fisher
install fish
curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish
# Alacritty
install alacritty
# neovim
install neovim
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
install python-neovim
# aura
oldDir=$(pwd)
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ..
rm -rf yay
cd $oldDir
# tmux and tpm
install tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# ripgrep
install ripgrep
# screenshot util
install maim xclip
# bashtop
install bashtop

# ranger dev icons
git clone https://github.com/alexanderjeurissen/ranger_devicons ~/.config/ranger/plugins/ranger_devicons

sudo chsh -s $(which fish)
fisher

install lsd
