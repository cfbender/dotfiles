#!/bin/bash

# code
sudo pacman -S code

# JS/TS
pacman -S nodejs npm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.0/install.sh | bash
pacman -S yarn
yarn global add typescript

# Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
cargo install cargo-edit

# Haskell
curl -sSL https://get.haskellstack.org/ | sh

# Python
sudo pacman -S python

#Lua
sudo pacman -S lua

# jetbrains
flatpak install flathub com.jetbrains.DataGrip -y

# docker
sudo pacman -S docker

