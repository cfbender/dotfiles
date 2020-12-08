#!/bin/bash

# code
sudo pacman -S code --noconfirm

# JS/TS
sudo pacman -S nodejs npm --noconfirm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.0/install.sh | bash
sudo pacman -S yarn --noconfirm
yarn global add typescript

# Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
cargo install cargo-edit

# Haskell
curl -sSL https://get.haskellstack.org/ | sh

# Python
sudo pacman -S python --noconfirm
sudo pacman -S gcc --noconfirm
pip3 install thefuck

#Lua
sudo pacman -S lua --noconfirm

# jetbrains
flatpak install flathub com.jetbrains.DataGrip -y

# docker
sudo pacman -S docker --noconfirm

# Meld
sudo pacman -S meld --noconfirm

# Deno
curl -fsSL https://deno.land/x/install/install.sh | sh
