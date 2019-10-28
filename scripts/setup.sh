#!/bin/bash

./symlink.sh
./aptinstall.sh
./flatpakinstall.sh
./programs.sh
./desktop.sh

# Get all upgrades
sudo apt upgrade -y

# See our bash changes
source ~/.zshrc
